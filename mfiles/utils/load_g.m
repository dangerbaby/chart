function g=load_g(g)

if g.iclean==0
  disp('Loading saved g structure')
  load([g.name,'/g.mat']);
  g.iclean=0;
end