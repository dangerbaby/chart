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
  clear allout;    
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

      % use zbf to make new PRI file
      if storm<size(in,2)
        newfn = [g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm+1).name,'.PRI'];
        fid = fopen(newfn,'w');
        in(conf,storm).header = {'C>------------------------------------------------------------'
                            'E>------------------------------------------------------------'};
        for ii = 1:length(in(conf,storm).header)
          fprintf(fid,'%s \n',cell2mat(in(conf,storm).header(ii)));
        end
        fprintf(fid,'   %d\n',length(dum.x));
        fprintf(fid,'   %6.3f %6.3f \n',[dum.x' dum.zbf']');
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

