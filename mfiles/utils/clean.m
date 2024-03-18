function g = clean(g)
%iclean = 0; % iclean = 1 to remove all existing results in infile and outfile directories   

if g.iclean 
  disp('Cleaning up old results and inputs')
  [~,~,~]=rmdir([g.name,'/work/infiles'],'s');
  [~,~,~]=rmdir([g.name,'work/outfiles'],'s');
  delete([g.name,'/g.mat']);
end

%g.old_inputs_exist = exist([g.name,'/g.mat'],'file');


