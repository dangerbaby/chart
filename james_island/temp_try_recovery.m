dirnames = dir([g.name,'/work/outfiles']);
lw = 3;
fs = 20;
iplotforcing = 1;
iplotmorpho = 1;
cnt = 0;
close all



% for i = 3:length(dirnames)
for i = 3
  cnt = cnt+1;
  load([g.name,'/work/outfiles/',dirnames(i).name,'/sbout.mat'])
  load([g.name,'/work/infiles/',dirnames(i).name,'/sbin.mat'])
end
conf = 1;
storm = 3;
zbi = out(conf,storm).final_profile;
zbe = out(conf,1).initial_profile;
T90 = 28; %time to 90% recovery
T  = in(conf,storm).T_recover;
z_berm = 1.25;
zbf_recovered = beach_recover(zbi,zbe,z_berm,T90,T);

hh(1) = plot(out(conf,1).x,zbe,'k','linewidth',1);hold on
hh(2) = plot(out(conf,1).x,out(conf,storm).initial_profile,'k--','linewidth',4);hold on
hh(3) = plot(out(conf,1).x,out(conf,storm).final_profile,'b-','linewidth',lw);hold on
%hh(3) = plot(out(conf,2).x,out(conf,2).initial_profile,'r--','linewidth',lw);
hh(4) = plot(out(conf,2).x,zbf_recovered,'r--','linewidth',lw);
%hh(4) = plot(out(conf,1).x,out(conf,end).final_profile,'k--','linewidth',lw);
hl=legend(hh,'Equilibrium','Pre-storm','SBEACH post storm','With Recovery before next storm',...
          'Interpreter','latex','fontsize',fs);
title([strrep(out(conf,1).name,'_','-'),'$   T_{90}$ = ',num2str(T90),'   T = ',num2str(T)],'Interpreter','latex','fontsize',fs)
xlim([40 200])
print -dpng example_recovery.png