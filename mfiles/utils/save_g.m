function save_g(g)

g=rmfield(g,'iclean');
save([g.name,'/g.mat'],'g'); 