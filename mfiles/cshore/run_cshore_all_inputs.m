function run_cshore_all_inputs(g)
mm = g.mm;
if ~contains(mm.modelname,'cshore','IgnoreCase',1);return;end
% run all inputs found in the infiles directory
clearevery = 100;
%addpath 'mfiles' 
%iclean = 0; % iclean = 1 to remove all existing resultrs in outfile directory   
%if iclean;[j1,j1,j1]=rmdir('./work/outfiles','s');clear j1 iclean;end
dirnames = dir([g.name,'/work/infiles']);
fidlog = fopen('log.txt','w');
numruns=0;
tic;
for i = 3:length(dirnames)
  clear out;    
  [success,message,messageid] = mkdir(['./work/outfiles/',dirnames(i).name]);
  load([g.name,'/work/infiles/',dirnames(i).name,'/csin.mat'])
  disp(['Directory ',dirnames(i).name,' has ', num2str(size(in,1)),' configurations with ', num2str(size(in,2)),' sequential storms'])
  for storm = 1:size(in,2)
    for conf =1:size(in,1)
      make_infile(in(conf,storm),g);   
      %       cnt=cnt+1;
      disp(['running CSHORE on ',g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm).name,'.infile'])
      numruns=numruns+1;
      if isunix
        system(['./executables/CSHORE_USACE_LINUX.out ',g.name,'/work/infiles/',...
                dirnames(i).name,'/',in(conf,storm).name,'>junk & ']);
        % system(['../executables/CSHORE_USACE_LINUX.out ./work/infiles/',...
        %         dirnames(i).name,'/',in(conf,storm).name,' ']);
      elseif ispc
        % parr run
        system(['start /B .\executables\cshore_usace_win.out ',g.name,'\work\infiles\',...
                dirnames(i).name,'\',in(conf,storm).name,'>NUL']);
      end
    end
    
    % now let it catch up
    if isunix
      [r,n]=system('pgrep -c CSHORE');n = str2num(n);disp([num2str(n),' processes still running'])
      while(n>0)
	pause(2);[r,n]=system('pgrep -c CSHORE');n = str2num(n);disp([num2str(n),' processes still running'])
      end
    elseif ispc
      [j1 n] = system('tasklist |find /I /C "cshore_usace_win.out"');
      n = str2num(n);disp([num2str(n),' processes still running'])
      while(n>0)
        pause(2);[j1 n]=system('tasklist |find /I /C "cshore_usace_win.out"');
        n = str2num(n);disp([num2str(n),' processes still running'])
      end
    end
    % now read results and write new bot position for the next time 
    for conf =1:size(in,1)
      dum=load_results_chart([g.name,'/work/infiles/',dirnames(i).name,'/',in(conf,storm).name]);
      out(conf,storm).x = dum.x;
      out(conf,storm).initial_profile               = dum.initial_profile;               
      out(conf,storm).final_profile                 = dum.final_profile  ;               
      out(conf,storm).max_profile_elev              = dum.max_profile_elev ;             
      out(conf,storm).min_profile_elev              = dum.min_profile_elev;              
      out(conf,storm).max_hrms                      = dum.max_hrms       ;               
      out(conf,storm).max_water_elevation_plus_setup= dum.max_water_elevation_plus_setup ;
      out(conf,storm).name                          = in(conf,storm).name;
      out(conf,storm).x_offset                      = in(conf,storm).x_offset;
      if storm<size(in,2)
        in(conf,storm+1).zb = out(conf,storm).final_profile;
      end
    end
  end %storm
  save([g.name,'/work/outfiles/',dirnames(i).name,'/csout.mat'],'out')
  save([g.name,'/work/outfiles/',dirnames(i).name,'/csin.mat'],'in')
end % reaches



fprintf(fidlog,'%s\n',['Runtime of ',num2str(toc),' s for ',num2str(numruns),' runs']);
fprintf('%s\n',['Runtime of ',num2str(toc),' s for ',num2str(numruns),' runs']);
fclose(fidlog);
toc

