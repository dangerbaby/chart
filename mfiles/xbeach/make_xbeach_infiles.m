function make_xbeach_infiles(in,g)

dum = [g.name,'/work/infiles/',in.dirname,'/'];
dum = '';
nonhydrostatic = 0;

% Create tide forcing file
clear tide_data
tide_data(:,1) = in(1,1).timebc_surg';
tide_data(:,2) = in(1,1).swlbc'; % [BC.WL(:)+SLR; BC.WL(end)+SLR];
tide_data(:,3) = in(1,1).swlbc'; % [BC.WL(:)+SLR; BC.WL(end)+SLR];
save([dum,'tide.txt'], 'tide_data', '-ascii')

% Create bathy files
XNEW = in.x;
ZNEW = in.zb;
YNEW = zeros(size(XNEW));
save([dum,'bed.dep'] ,'ZNEW', '-ascii')
save([dum,'x.grd'] ,'XNEW', '-ascii')
save([dum,'y.grd'] ,'YNEW', '-ascii')

% Creat wave forcing file
clear jonswap_data
nsteps = 2;
for ix = 1:numel(in.Hmo)
  jonswap_data(ix,:) = [in.Hmo(ix) in.Tp(ix) in.angle(ix) 3.3 20 in.dt 1];
end
%jonswap_data


%iddel = find(jonswap_data(:,1) == 0);
%jonswap_data(iddel,:) = [];
%jonswap_data(end+1,:) = jonswap_data(end,:);



% make the infiles
inxb = xb_generate_model('bathy', {'x', XNEW, 'y', YNEW, 'z', ZNEW, 'optimize', false});
inxb = xs_set(inxb, 'bedfriction', 'cf');
inxb = xs_set(inxb, 'bedfriccoef', g.mm.fw/2);
inxb = xs_set(inxb, 'gamma', g.mm.gamma);
inxb = xs_set(inxb, 'hmin', 0.05); % min water depth for flow return
inxb = xs_set(inxb, 'vegetation', 0);
if nonhydrostatic == 1
  inxb = xs_set(inxb, 'nonh', 1); %change this flag if want the nonhydrostatic correction
  inxb = xs_set(inxb, 'wavemodel','nonh');
end
%inxb = xs_set(inxb, 'posdwn', -1);
inxb = xs_set(inxb, 'sedtrans', 1);
inxb = xs_set(inxb, 'morphology', 1);
%inxb = xs_set(inxb, 'thetamin', round(180+BC.angle-45));
%inxb = xs_set(inxb, 'thetamax', round(180+BC.angle+45));
inxb = xs_set(inxb, 'dtheta', 10);
inxb = xs_set(inxb, 'zs0', 0);
inxb = xs_set(inxb, 'thetanaut', 1);
inxb = xs_set(inxb, 'tstop', in.timebc_wave(end));           % 45 minute simulation total, with 30 useable minutes
inxb = xs_set(inxb, 'tstart', 90);           % 15 minute spinup
inxb = xs_set(inxb, 'tideloc', 1);
inxb = xs_set(inxb, 'zs0file', 'tide.txt');
inxb = xs_set(inxb, 'tintp', 1);        
inxb = xs_set(inxb, 'tintm', 900);
inxb = xs_set(inxb, 'tintg', 900);
inxb = xs_set(inxb, 'rugdepth', 0.1);
inxb = xs_set(inxb, 'nrugauge',{'-500 0'});
inxb = xs_set(inxb, 'globalvar', {'zs', 'zb', 'H'});
xb_write_input([dum,'params.txt'], inxb)

save([dum,'jonswap.txt'], 'jonswap_data', '-ascii')