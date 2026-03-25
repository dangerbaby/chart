function g = run_sbeach_all_inputs(g)
mm = g.mm;
if ~contains(mm.modelname,'sbeach','IgnoreCase',1);return;end
% run all cfg files found in the infiles directory
clearevery = 100;
%addpath 'mfiles' 
iclean = 0; % iclean = 1 to remove all existing resultrs in outfile directory   
if iclean ;[j1,j1,j1]=rmdir('./work/outfiles','s');clear j1 iclean;end
dirnames = dir([g.name,'/work/infiles']);
fidlog = fopen('log.txt','w');
numruns=0;
tic;
for i = 3:length(dirnames)
  clear out ;    
  [success,message,messageid] = mkdir([g.name,'/work/outfiles/',dirnames(i).name]);
  load([g.name,'/work/infiles/',dirnames(i).name,'/sbin.mat'])
  %dumnames = dir(['./work/infiles/',dirnames(i).name,'/*',sprintf('%03d',1),'.CFG']);
  %numstorms = length(dir(['./work/infiles/',dirnames(i).name,'/',dumnames(1).name(1:end-8),'*.CFG']));

  %for stormnum = 1:numstorms;% 1 to numstorms
  for storm = 1:size(in,2);% 1 to numstorms
    for conf =1:size(in,1)
      
      %fnames = dir(['./work/infiles/',dirnames(i).name,'/*',sprintf('%03d',stormnum),'.CFG']);
      
      %disp(['Directory ',dirnames(i).name,' has ', num2str(length(fnames)),' sets of input files'])
      %cnt = 0;
      %fprintf(fidlog,'%s\n',['Running ',num2str(length(fnames)),' runs in directory named ',dirnames(i).name]);
      numruns = numruns+1;
      %for j = 1:length(fnames)
      %  cnt=cnt+1;
      disp(['running SBEACH ',g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm).name])
      if isunix
        system(['./executables/SBEACH_LINUX.out -cfgFN ',g.name,'/work/infiles/',...
                dirnames(i).name,'/',in(conf,storm).name,'>junk & ']);
      elseif ispc
        %serial run:			%
        %system(['.\executables\SBEACH_WIN.out -cfgFN ',g.name,'\work\infiles\',...
        %        dirnames(i).name,'\',in(conf,storm).name,'']);
        % parr run
        system(['start /B .\executables\SBEACH_WIN.out -cfgFN ',g.name,'\work\infiles\',...
                dirnames(i).name,'\',in(conf,storm).name,'>NUL']);
        
      end
    end
    % now let it catch up
    if isunix
      [r,n]=system('pgrep -c SBEACH');n = str2num(n);disp([num2str(n),' processes still running'])
      while(n>0)
        pause(.2);[r,n]=system('pgrep -c SBEACH');n = str2num(n);disp([num2str(n),' processes still running'])
      end
    elseif ispc
      %system('tasklist')
      [j1 n] = system('tasklist |find /I /C "SBEACH_WIN.out"');
      n = str2num(n);disp([num2str(n),' processes still running'])
      %pause(2);
      while(n>0)
        pause(.5);[j1 n]=system('tasklist |find /I /C "SBEACH_WIN.out"');
        n = str2num(n);disp([num2str(n),' processes still running'])
      end
      %pause(.5)
      %[j1 j2] = system('tasklist')
    end
    %toc
    %return    
    % load results and put into mat files, then clean up    
    for conf =1:size(in,1)
      %for j = 1:length(fnames)
      disp(['loading ',g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm).name])
      dum = load_results_sbeach([g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm).name]);
      out(conf,storm).x = dum.x;
      out(conf,storm).initial_profile               = dum.zbi;               
      out(conf,storm).final_profile                 = dum.zbf;               
      out(conf,storm).max_profile_elev              = dum.zbmax;             
      out(conf,storm).min_profile_elev              = dum.zbmin;              
      out(conf,storm).max_hrms                      = dum.Hsmax/sqrt(2);               
      out(conf,storm).max_water_elevation_plus_setup= dum.etamax;
      out(conf,storm).name                          = in(conf,storm).name;

      in2.ilongshoregrad = g.mm.ilongshoregrad;
      in2.dXdt = in(conf,storm).dXdt;
      in2.irecover = g.mm.irecover;
      in2.zbi = out(conf,storm).final_profile;
      in2.zbe = in(conf,1).zbe;
      in2.min_zb = in(conf,1).min_zb;
      in2.T90 = g.mm.T90; %time to 90% recovery
      in2.T_recover  = in(conf,storm).T_recover;
      in2.T_recover_cumulative  = in(conf,storm).T_recover_cumulative;
      in2.z_berm = in(conf,storm).height_berm+.1;
      
      zb_prestorm = nonstorm_changes(in2);
      
      % if g.mm.irecover==1
      %   zbi = out(conf,storm).final_profile;
      %   zbe = out(conf,1).initial_profile;
      %   T90 = g.mm.T90; %time to 90% recovery
      %   T  = in(conf,storm).T_recover;
      %   z_berm = in(conf,storm).height_berm+.1;
      %   zb_prestorm = beach_recover(zbi,zbe,z_berm,T90,T);
      %   %zb_prestorm = dum.zbf;
      % else
      %   zb_prestorm = dum.zbf;
      % end
      % max(out(conf,1).initial_profile - in(conf,storm).zbe)
      % max(zb_prestorm-zb_prestorm2)
      % error
      %zbf_recovered = beach_recover(g,dum.zbi,dum.zbf,T);
      % use zbf or zbf_recovered to make new PRI file
      if storm<size(in,2)% except for last storm
        newfn = [g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm+1).name,'.PRI'];
        fid = fopen(newfn,'w');
        in(conf,storm).header = {'C>------------------------------------------------------------'
                            'E>------------------------------------------------------------'};
        for ii = 1:length(in(conf,storm).header)
          fprintf(fid,'%s \n',cell2mat(in(conf,storm).header(ii)));
        end
        fprintf(fid,'   %d\n',length(dum.x));
        %fprintf(fid,'   %6.3f %6.3f \n',[dum.x' dum.zbf']');
        fprintf(fid,'   %6.3f %6.3f \n',[dum.x' zb_prestorm']');
        fclose(fid);
      end
      %if storm==numstorms&j==length(fnames)
      %disp(['saving allout structure']) 
      %mcnum = dirnames(i).name(strfind(dirnames(i).name,'MCnum')+5:end);
      %save(['./work/outfiles/',dirnames(i).name,'/results_mcnum',mcnum],'allout')
      
    end
    save([g.name,'/work/outfiles/',dirnames(i).name,'/sbout.mat'],'out')
  end
end


fprintf(fidlog,'%s\n',['Runtime of ',num2str(toc),' s for ',num2str(numruns),' runs']);
fprintf('%s\n',['Runtime of ',num2str(toc),' s for ',num2str(numruns),' runs']);
fclose(fidlog);
toc

