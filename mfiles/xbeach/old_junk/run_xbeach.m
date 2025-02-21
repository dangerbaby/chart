%function [out] = run_xbeach(g,in2)
mm = g.mm;
if ~contains(mm.modelname,'xbeach','IgnoreCase',1);return;end
disp('Running XBeach')

return



if g.ixbeach==0;out = [];return;end

maindir = pwd;
cd(maindir)
addpath(genpath([maindir,'/xbeach']))
exec_cmd = [maindir,'/xbeach/xbeach_src/src/xbeach/xbeach'];
%exec_cmd = [maindir,'/xbeach/xbeachlnk'];
outdir = [maindir,'/xbeach/xbeach_sims_nobind_changewrapdeg/'];
mkdir(outdir)
nonhydrostatic = 0;
frf_dir_offset = 72; 


% For each lidar gauge
SLR = 0;
for i = 1%:length(in2)

  % make temp ith working dir
  cd(outdir)
  simdir = ['./sim',num2str(i)]; 
  mkdir(simdir)
  cd(simdir)
 
  % define parameters
  dt_target = [1/24]*86400;
  tstart = 0;
  BC.ts_datenum = tstart*[1:1+1/24];
  BC.Hs = ones(numel(BC.ts_datenum)+1,1)*in2(i).Hrms;
  BC.Tp = ones(numel(BC.ts_datenum)+1,1)*in2(i).Tp;
  BC.WL = ones(size(BC.ts_datenum)).*in2(i).swlbc; % water level at seaward boundary in meters
  %tmp_angle = wrapTo360(frf_dir_offset-in2(i).angle); % requires mapping toolbox
  tmp_angle = wrapdeg(frf_dir_offset - in2(i).angle);
  BC.angle = tmp_angle; % constant incident wave angle at seaward boundary in
  
  % Create tide forcing file
  clear tide_data
  tide_data(:,1) = [BC.ts_datenum 99999999];
  tide_data(:,1) = round([(tide_data(:,1) -tide_data(1,1))*86400]);
  tide_data(:,2) = [BC.WL(:)+SLR; BC.WL(end)+SLR];
  tide_data(:,3) = [BC.WL(:)+SLR; BC.WL(end)+SLR];
  save('tide.txt', 'tide_data', '-ascii')

  % Creat wave forcing file
  clear jonswap_data
  nsteps = 2;
  for ix = 1:numel(BC.Hs)
    jonswap_data(ix,:) = [BC.Hs(ix) BC.Tp(ix) round(180+BC.angle) 3.3 20 round(median(dt_target)*nsteps) 1];
  end
  iddel = find(jonswap_data(:,1) == 0);
  jonswap_data(iddel,:) = [];
  jonswap_data(end+1,:) = jonswap_data(end,:);
  
  % Create bathy files
  XNEW = in2(i).x;
  ZNEW = in2(i).zb;
  YNEW = zeros(size(XNEW));
  save('bed.dep' ,'ZNEW', '-ascii')
  save('x.grd' ,'XNEW', '-ascii')
  save('y.grd' ,'YNEW', '-ascii')
  
  % make the infiles
  in = xb_generate_model('bathy', {'x', XNEW, 'y', YNEW, 'z', ZNEW, 'optimize', false});
  in = xs_set(in, 'bedfriction', 'manning');
  in = xs_set(in, 'bedfriccoef', in2(i).fric_fac);
  in = xs_set(in, 'gamma', in2(i).gamma);
  in = xs_set(in, 'hmin', 0.05); % min water depth for flow return
  in = xs_set(in, 'vegetation', 0);
  if nonhydrostatic == 1
  in = xs_set(in, 'nonh', 1); %change this flag if want the nonhydrostatic correction
  in = xs_set(in, 'wavemodel','nonh');
  end
  %in = xs_set(in, 'posdwn', -1);
  in = xs_set(in, 'sedtrans', 0);
  in = xs_set(in, 'morphology', 0);
  in = xs_set(in, 'thetamin', round(180+BC.angle-45));
  in = xs_set(in, 'thetamax', round(180+BC.angle+45));
  in = xs_set(in, 'dtheta', 10);
  in = xs_set(in, 'zs0', 0);
  in = xs_set(in, 'thetanaut', 1);
  in = xs_set(in, 'tstop', 2700);           % 45 minute simulation total, with 30 useable minutes
  in = xs_set(in, 'tstart', 900);           % 15 minute spinup
  in = xs_set(in, 'tideloc', 1);
  in = xs_set(in, 'zs0file', 'tide.txt');
  in = xs_set(in, 'tintp', 1);        
  in = xs_set(in, 'tintm', 900);
  in = xs_set(in, 'tintg', 900);
  in = xs_set(in, 'rugdepth', 0.1);
  in = xs_set(in, 'nrugauge',{'-500 0'});
  in = xs_set(in, 'globalvar', {'zs', 'zb', 'H'});
  xb_write_input('params.txt', in)
  save('jonswap.txt', 'jonswap_data', '-ascii')


  % run model
  system(exec_cmd);
  
  
  % Read and Save Runup Output
  xbo = xb_read_output;
  for jj = 1:length(xbo.data)
    if contains(xbo.data(jj).name,'rug')
      id_runup = jj;
    end
  end
  dat = xbo.data(id_runup).value;
  xbrunup = dat;
  save xbrunup.mat xbrunup 
  out(i).results = xbo;

  % calculate R2%
  runup_tmp = xbo.data(id_runup).value(:,end);
  out(i).runup.runup_mean  = nanmean(runup_tmp);
  out(i).runup.runup_std   = nanstd(runup_tmp);
  out(i).runup.runup_13    = out(i).runup.runup_mean +2*out(i).runup.runup_std;
  out(i).runup.runup_2p    = out(i).runup.runup_mean + 1.4*(out(i).runup.runup_13-out(i).runup.runup_mean);

  
  cd(maindir)

  
end
