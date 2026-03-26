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
      out(conf,storm).x                             = in(conf,storm).x_offset-fliplr(dum.x');
      out(conf,storm).initial_profile               = fliplr(dum.initial_profile');               
      out(conf,storm).final_profile                 = fliplr(dum.final_profile')  ;               
      out(conf,storm).max_profile_elev              = fliplr(dum.max_profile_elev') ;             
      out(conf,storm).min_profile_elev              = fliplr(dum.min_profile_elev');              
      out(conf,storm).max_hrms                      = fliplr(dum.max_hrms')       ;               
      out(conf,storm).max_water_elevation_plus_setup= fliplr(dum.max_water_elevation_plus_setup') ;
      out(conf,storm).name                          = in(conf,storm).name;
      out(conf,storm).x_offset                      = in(conf,storm).x_offset;

      in2.ilongshoregrad = g.mm.ilongshoregrad;
      in2.dXdt = in(conf,storm).dXdt;
      in2.irecover = g.mm.irecover;
      in2.zbi = out(conf,storm).final_profile;
      in2.zbe = fliplr(in(conf,1).zbe);% flipped because in structure has pos onshore coords
      in2.min_zb = fliplr(in(conf,1).min_zb);
      in2.T90 = g.mm.T90; %time to 90% recovery
      in2.T_recover  = in(conf,storm).T_recover;
      in2.T_recover_cumulative  = in(conf,storm).T_recover_cumulative;
      in2.z_berm = in(conf,storm).height_berm+.1;
      
      zb_prestorm = nonstorm_changes(in2);
      
      
      %zb_prestorm = nonstorm_changes(g.mm,in(conf,storm),out(conf,storm).final_profile)
      
      if storm<size(in,2)
        % if g.mm.irecover==1
        %   zbi = out(conf,storm).final_profile;
        %   zbe = out(conf,1).initial_profile;
        %   T90 = g.mm.T90; %time to 90% recovery
        %   T  = in(conf,storm).T_recover;
        %   z_berm = in(conf,storm).height_berm+.1;
        %   zb_prestorm = beach_recover(zbi,zbe,z_berm,T90,T);
        %   %zb_prestorm = dum.zbf;
        % else
        %   zb_prestorm = out(conf,storm).final_profile;
        % end
        in(conf,storm+1).zb = fliplr(zb_prestorm);
        %in(conf,storm+1).zb = fliplr(out(conf,storm).final_profile);
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

