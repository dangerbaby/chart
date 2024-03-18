function g=make_sbeach_infiles(g)
mm = g.mm;
reaches=g.reaches;
bc=g.bc

if ~contains(mm.modelname,'sbeach','IgnoreCase',1);return;end


for i = 1:length(reaches) % loop over reaches
  for j = 1:length(bc) % loop over MC realizations
    clear in
    % first make a directory for each reach
    dirname=[reaches(i).dirname,'MCnum',sprintf('%04d',j)];
    [success,message,messageid] = mkdir([g.name,'/work/infiles/',dirname]);
    for l = 1:length(reaches(i).height_dune)% loop over build configs
      for k = 1:length(bc(j).timeseries) % loop over storms
        in(l,k).dx = mm.dx;
        in(l,k).dirname = dirname;
        disp(['making SBEACH input : Reach: ',num2str(i),'  Montecar: ',num2str(j),'  Storm: ',num2str(k),' Buildconfig: ',num2str(l)])
        in(l,k).magic_text = [dirname,'_',num2str(reaches(i).height_dune(l)),'_',num2str(reaches(i).width_dune(l)), ...
                         '_',num2str(reaches(i).width_berm(l)),'_',sprintf('%03d',k)];
        in(l,k).name=strrep(in(l,k).magic_text,', ','-');
        
        in(l,k).header = {'C>------------------------------------------------------------'
                     ['C> ',in(l,k).magic_text]
                     'C>------------------------------------------------------------'
                     'E>------------------------------------------------------------'};
        
        ftime = (bc(j).timeseries(k).date(end)-bc(j).timeseries(k).date(1))*24*3600;      % [sec] final time, dictates model duration
        in(l,k).dt = 5*60;         % time interval in seconds for wave and water level conditions
        in(l,k).timebc_wave = [0:in(l,k).dt:ftime];
        %in(l,k).timebc_wave = (storms(k).date-storms(k).date(1))*24*3600;
        in(l,k).datebc = in(l,k).timebc_wave/(24*3600); 
        in(l,k).timebc_surg = in(l,k).timebc_wave;
        in(l,k).nwave = length(in(l,k).timebc_wave); in(l,k).nsurg = in(l,k).nwave;dum = ones(1,in(l,k).nwave);
        in(l,k).Tp    = interp1(bc(j).timeseries(k).date,bc(j).timeseries(k).Tp,in(l,k).datebc);
        in(l,k).Hmo   = interp1(bc(j).timeseries(k).date,bc(j).timeseries(k).Hmo,in(l,k).datebc);
        in(l,k).Hmo(in(l,k).Hmo<.005) = .005;
        in(l,k).swlbc = interp1(bc(j).timeseries(k).date,bc(j).timeseries(k).wl,in(l,k).datebc);
        in(l,k).angle = zeros(size(in(l,k).Hmo));    % constant incident wave angle at seaward boundary in
        zb = 0.3048*reaches(i).profile(l).z_ft; % zb points
        x  = 0.3048*reaches(i).profile(l).x_ft;
        in(l,k).x = (min(x):mm.dx:max(x));
        [j1 j2] = unique(x);
        in(l,k).zb = interp1(x(j2),zb(j2),in(l,k).x);

        in(l,k).d50 = reaches(i).d50(l);
        %First check for NaN
        if max(isnan([in(l,k).x(:);in(l,k).zb(:);in(l,k).Tp(:);in(l,k).Hmo(:);in(l,k).swlbc(:);in(l,k).angle(:)]))
          error('The in structure contains NaN')
        end
        % save the in structure --just in case
        save([g.name,'/work/infiles/',dirname,'/',in(l,k).name,'.mat'],'in');
        if k==1;% PRI file
                %in(l,k).name
                %in(l,k).dirname
          fid = fopen([g.name,'/work/infiles/',dirname,'/',in(l,k).name '.PRI'],'w');
	  %fid = fopen(['work\infiles\',in(l,k).dirname,'\dum.PRI'],'w')
	  %['work\infiles\',in(l,k).dirname,'\',in(l,k).name,'.PRI']
	  %fid = fopen(['work\infiles\',in(l,k).dirname,'\',in(l,k).name,'.PRI'],'w')
          for ii = 1:length(in(l,k).header)
            fprintf(fid,'%s \n',cell2mat(in(l,k).header(ii)));
          end
          fprintf(fid,'   %d\n',length(in(l,k).x));
          fprintf(fid,'   %6.3f %6.3f \n',[in(l,k).x' in(l,k).zb']');
          fclose(fid);
        end
        % ELV file
        %['work/infiles/',in(l,k).dirname,'/',in(l,k).name,'.ELV']
	fid = fopen([g.name,'/work/infiles/',dirname,'/',in(l,k).name,'.ELV'],'w');
        for ii = 1:length(in(l,k).header)
          fprintf(fid,'%s \n',cell2mat(in(l,k).header(ii)));
        end
        fprintf(fid,'   %6.3f \n',[in(l,k).swlbc]);
        fclose(fid);
        % WAV file
        fid = fopen([g.name,'/work/infiles/',dirname,'/',in(l,k).name '.WAV'],'w');
        for ii = 1:length(in(l,k).header)
          fprintf(fid,'%s \n',cell2mat(in(l,k).header(ii)));
        end
        fprintf(fid,'   %6.3f %6.3f \n',[in(l,k).Hmo' in(l,k).Tp']');
        fclose(fid);
        
        %in(l,k).name = g.name;
        make_cfg(in(l,k),g)
        
        
        
      end
    end
        save([g.name,'/work/infiles/',dirname,'/','sbin.mat'],'in');
  end
end
%g.sbeach.in = in;

