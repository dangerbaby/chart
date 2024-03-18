function make_cshore_in(g)
mm = g.mm;
reaches = g.reaches;
bc = g.bc;


if ~contains(mm.modelname,'cshore','IgnoreCase',1);return;end


for i = 1:length(reaches) % loop over reaches
  for j = 1:length(bc) % loop over MC realizations
    clear in    
    % first make a directory for each reach
    dirname=[reaches(i).dirname,'MCnum',sprintf('%04d',j)];
    [success,message,messageid] = mkdir([g.name,'/work/infiles/',dirname]);
    for l = 1:length(reaches(i).height_dune)% loop over build configs
      for k = 1:length(bc(j).timeseries)% loop over storms
        disp(['Making CSHORE in structure, Reach: ',num2str(i),'  Montecar: ',num2str(j),'  Storm: ',num2str(k),'  Buildconfig: ',num2str(l)])
        in(l,k).dirname=dirname;
        in(l,k).dx = mm.dx;
        in(l,k).magic_text = [in(l,k).dirname,'_',num2str(reaches(i).height_dune(l)),'_',num2str(reaches(i).width_dune(l)), ...
                            '_',num2str(reaches(i).width_berm(l)),'_',sprintf('%03d',k)];
        in(l,k).name=strrep(in(l,k).magic_text,', ','-');
        
        in(l,k).header = {'------------------------------------------------------------'
                          [' ',in(l,k).magic_text]
                          '------------------------------------------------------------'};
        
        ftime = (bc(j).timeseries(k).date(end)-bc(j).timeseries(k).date(1))*24*3600;      % [sec] final time, dictates model duration
        in(l,k).dt = 60*60;         % time interval in seconds for wave and water level conditions
        in(l,k).timebc_wave = [0:in(l,k).dt:ftime];
        %in(l,k).timebc_wave = (storms(k).date-storms(k).date(1))*24*3600;
        in(l,k).datebc = in(l,k).timebc_wave/(24*3600); 
        in(l,k).timebc_surg = in(l,k).timebc_wave;
        in(l,k).nwave = length(in(l,k).timebc_wave); in(l,k).nsurg = in(l,k).nwave;dum = ones(1,in(l,k).nwave);
        in(l,k).Tp    = interp1(bc(j).timeseries(k).date,bc(j).timeseries(k).Tp,in(l,k).datebc);
        in(l,k).Hmo   = interp1(bc(j).timeseries(k).date,bc(j).timeseries(k).Hmo,in(l,k).datebc);
        in(l,k).Hrms  = in(l,k).Hmo./sqrt(2);
        %in(l,k).Hmo(in(l,k).Hmo<.005) = .005;
        in(l,k).swlbc = interp1(bc(j).timeseries(k).date,bc(j).timeseries(k).wl,in(l,k).datebc);
        in(l,k).angle = zeros(size(in(l,k).Hmo));    % constant incident wave angle at seaward boundary in
        x  = 0.3048*reaches(i).profile(l).x_ft;
        x2 = min(x):mm.dx:max(x);
        in(l,k).x_offset = (max(x2));
        in(l,k).x = in(l,k).x_offset-fliplr(x2);

        if k==1;
          zb = 0.3048*reaches(i).profile(l).z_ft; % zb points
          [j1 j2] = unique(x);
          in(l,k).zb = interp1(max(x)-x(j2),zb(j2),in(l,k).x);
          in(l,k).zb = interp1(x,zb,fliplr(x2));
        else
          in(l,k).zb = 999;
        end
          in(l,k).d50 = reaches(i).d50(l);
        %First check for NaN
        if max(isnan([in(l,k).x(:);in(l,k).zb(:);in(l,k).Tp(:);in(l,k).Hmo(:);in(l,k).swlbc(:);in(l,k).angle(:)]))
          error('The in structure contains NaN')
        end
        in(l,k).gamma = mm.gamma;
        in(l,k).tanphi = mm.tanphi;
        in(l,k).wf=vfall(in(l,k).d50,20,0);
        in(l,k).sg = 2.65;
        in(l,k).effb = mm.cshore.effb;
        in(l,k).efff = mm.cshore.efff;
        in(l,k).slp = mm.cshore.slp;
        in(l,k).slpot = mm.cshore.slpot;
        in(l,k).blp = mm.cshore.blp;
        in(l,k).rwh = mm.cshore.rwh;
        in(l,k).fw = mm.fw;
        in(l,k).ilab = 0;
        in(l,k).iline  = 1;
        in(l,k).iprofl = 1.1;
        in(l,k).isedav = 0;
        in(l,k).iperm  = 0;
        in(l,k).iover  = 1;
        in(l,k).iwtran = 0;
        in(l,k).ipond = 0;
        in(l,k).infilt = 0;
        in(l,k).iwcint = 0;
        in(l,k).iroll  = 1;
        in(l,k).iwind  = 0;
        in(l,k).itide = 0;
        in(l,k).iveg = 0;
        %make infile
        %make_infile(in); 
        % save the in structure --just in case
        %save(['./work/infiles/',in(l,k).dirname,'/',in(l,k).name,'.mat'],'in');
      end
    end
    save([g.name,'/work/infiles/',dirname,'/','csin.mat'],'in');
  end
end


