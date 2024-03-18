dirnames = dir([g.name,'/work/outfiles']);
cnt = 0;
ics = 1;
isb = 1;
ixb = 1;
for i = 3:length(dirnames)
  %  for i = 3
  cnt = cnt+1;
  % fname = dir(['./work/outfiles/',dirnames(i).name]);
  % load(['./work/outfiles/',dirnames(i).name,'/',fname(3).name])
  
  if ics
    load([g.name,'/work/outfiles/',dirnames(i).name,'/csout.mat'])
    csout = out;
  end
  if isb
    load([g.name,'/work/outfiles/',dirnames(i).name,'/sbout.mat'])
    sbout = out;
  end
  if ixb
    load([g.name,'/work/outfiles/',dirnames(i).name,'/xbout.mat'])
    xbout = out;
  end
  
  conf = 1;
  
  figure(cnt);clf;clear hh;
  if isb&~ics&~ixb
    hh(1) = plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'k');hold on
    hh(2) = plot(sbout(conf,1).x,sbout(conf,1).final_profile,'b-');hold on
    %  plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'r--')
    %plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'r--')
    hl=legend(hh,'Initial','SBEACH');set(hl,'Interpreter','latex')
    title(sbout(conf,1).name,'interpreter','none','fontsize',16)
  end
  if ics&isb&~ixb
    hh(1) = plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,1).initial_profile,'k');hold on
    hh(1) = plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'kx');hold on
    %plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,2).initial_profile,'r');hold on
    hh(2) = plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,end).final_profile,'r-');hold on
    %plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'k');hold on
    %plot(sbout(conf,1).x,sbout(conf,).initial_profile,'r');hold on
    hh(3) = plot(sbout(conf,1).x,sbout(conf,1).final_profile,'b-');hold on
    %  plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'r--')
    %plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'r--')
    hl=legend(hh,'Initial','CSHORE','SBEACH');set(hl,'Interpreter','latex')
    title(csout(conf,1).name,'interpreter','none','fontsize',16)
  end
  if ics&isb&ixb
    hh(1) = plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,1).initial_profile,'k');hold on
    plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,1).initial_profile,'rs');hold on
    plot(xbout(conf,1).x_offset-xbout(conf,1).x,xbout(conf,1).initial_profile,'mo','markersize',10);hold on
    plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'bx');hold on

    %plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,2).initial_profile,'r');hold on
    hh(2) = plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,end).final_profile,'r-');hold on
    %plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'k');hold on
    %plot(sbout(conf,1).x,sbout(conf,).initial_profile,'r');hold on
    hh(3) = plot(sbout(conf,1).x,sbout(conf,1).final_profile,'b-');hold on
    hh(4) = plot(xbout(conf,1).x_offset-xbout(conf,1).x,xbout(conf,1).final_profile,'m-');hold on
    %  plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'r--')
    %plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'r--')
    hl=legend(hh,'Initial','CSHORE','SBEACH','Xbeach');set(hl,'Interpreter','latex')
    title(csout(conf,1).name,'interpreter','none','fontsize',16)
  end
  
  set(gca,'TickLabelInterpreter','latex')
  xlim([0 500])
  %  title(allout(conf).name(1,1:end-8),'interpreter','none')
  xlabel('$x[m]$','interpreter','latex','fontsize',16)
  ylabel('$z[m]$','interpreter','latex','fontsize',16)
  set(gca,'TickLabelInterpreter','latex')

  %print('-dpng',[dirnames(i).name,'.png'])  
end
