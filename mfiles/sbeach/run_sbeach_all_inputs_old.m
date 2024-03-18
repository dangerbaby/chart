% after make_cshore_infiles, run all infiles found in the infiles directory
clearevery = 100;
%addpath 'mfiles' 
iclean = 1; % iclean = 1 to remove all existing resultrs in outfile directory   
if iclean ;[j1,j1,j1]=rmdir('./work/outfiles','s');clear j1 iclean;end
dirnames = dir('./work/infiles');
fidlog = fopen('log.txt','w');
tic;
for i = 3:length(dirnames)
  clear allout;    
  [success,message,messageid] = mkdir(['./work/outfiles/',dirnames(i).name]);
  dumnames = dir(['./work/infiles/',dirnames(i).name,'/*',sprintf('%03d',1),'.CFG']);
  numstorms = length(dir(['./work/infiles/',dirnames(i).name,'/',dumnames(1).name(1:end-8),'*.CFG']));
  for stormnum = 1:numstorms;% 1 to numstorms
    fnames = dir(['./work/infiles/',dirnames(i).name,'/*',sprintf('%03d',stormnum),'.CFG']);
    
    disp(['Directory ',dirnames(i).name,' has ', num2str(length(fnames)),' sets of input files'])
    cnt = 0;
    fprintf(fidlog,'%s\n',['Running ',num2str(length(fnames)),' runs in directory named ',dirnames(i).name]);
    for j = 1:length(fnames)
      cnt=cnt+1;
      disp(['running ./work/infiles/',dirnames(i).name,'/',fnames(j).name])
       if isunix
         system(['../executables/SBEACH_LINUX.out -cfgFN ./work/infiles/',...
                 dirnames(i).name,'/',fnames(j).name(1:end-4),'>junk & ']);
       elseif ispc
         system(['START /B ..\executables\SBEACH_WIN.out -cfgFN work\infiles\',...
                 dirnames(i).name,'\',fnames(j).name(1:end-4)]);
       end
      % let the system catch up is more runs than clearevery param
      if mod(cnt,clearevery)==0;
        [r,n]=system('pgrep -c SBEACH');n = str2num(n);disp(num2str(n))
        while(n>0)
          pause(.5);[r,n]=system('pgrep -c SBEACH');n = str2num(n);disp(num2str(n))
        end 
      end
    end
    % now let it catch up to avoid loading runs that are half completed
    [r,n]=system('pgrep -c SBEACH');n = str2num(n);disp([num2str(n),' processes still running'])
    while(n>0)
      pause(.5);[r,n]=system('pgrep -c SBEACH');n = str2num(n);disp([num2str(n),' processes still running'])
    end

    % load results and put into mat files, then clean up    
    %fnames2 = dir(['./work/infiles/',dirnames(i).name,'/*.PRC']);

    for j = 1:length(fnames)
      disp(['loading ./work/infiles/',dirnames(i).name,'/',fnames(j).name])
      out = load_results_sbeach(['./work/infiles/',dirnames(i).name,'/',fnames(j).name(1:end-4)]);
      if stormnum==1
        disp(['Initializing allout structure']) 
        allout(j).name = fnames(j).name;
        allout(j).zbi = out.zbi;
        allout(j).x = out.x;
        allout(j).zbf = out.zbf;
      else

        allout(j).zbf = [allout(j).zbf;out.zbf];
        allout(j).name = [allout(j).name;fnames(j).name];
      end
      % use zbf to make new PRI file
      newfn = ['./work/infiles/',dirnames(i).name,'/',fnames(j).name(1:end-7),sprintf('%03d',stormnum+1),'.PRI'];
      fid = fopen(newfn,'w');
      in.header = {'C>------------------------------------------------------------'
                   'E>------------------------------------------------------------'};
      for ii = 1:length(in.header)
        fprintf(fid,'%s \n',cell2mat(in.header(ii)));
      end
      fprintf(fid,'   %d\n',length(out.x));
      fprintf(fid,'   %6.3f %6.3f \n',[out.x' out.zbf']');
      fclose(fid);
      if stormnum==numstorms&j==length(fnames)
        disp(['saving allout structure']) 
        mcnum = dirnames(i).name(strfind(dirnames(i).name,'MCnum')+5:end);
        save(['./work/outfiles/',dirnames(i).name,'/results_mcnum',mcnum],'allout')
      end
    end
    
  end
end

fprintf(fidlog,'%s\n',['Runtime of ',num2str(toc),' s']);
fclose(fidlog);
toc

