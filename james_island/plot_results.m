dirnames = dir([g.name,'/work/outfiles']);
lw = 3;
fs = 20;
iplotforcing = 0;
iplotmorpho = 1;
cnt = 0;
close all
disp('Plotting results')
if iplotmorpho

  if contains(g.mm.modelname,'cshore','IgnoreCase',1);ics = 1;else;ics=0;end
  if contains(g.mm.modelname,'sbeach','IgnoreCase',1);isb = 1;else;isb=0;end
  if contains(g.mm.modelname,'xbeach','IgnoreCase',1);ixb = 1;else;ixb=0;end

  for i = 3:length(dirnames)% loop over reaches and MCnum
    %  for i = 3
    cnt = cnt+1;
    % fname = dir(['./work/outfiles/',dirnames(i).name]);
    % load(['./work/outfiles/',dirnames(i).name,'/',fname(3).name])
    
    if ics
      load([g.name,'/work/outfiles/',dirnames(i).name,'/csout.mat'])
      load([g.name,'/work/infiles/',dirnames(i).name,'/csin.mat'])
      csout = out;
      csin = in;
    end
    if isb
      load([g.name,'/work/outfiles/',dirnames(i).name,'/sbout.mat'])
      load([g.name,'/work/infiles/',dirnames(i).name,'/sbin.mat'])
      sbout = out;
      sbin = in;
    end
    if ixb
      load([g.name,'/work/outfiles/',dirnames(i).name,'/xbout.mat'])
      xbout = out;
    end
    

    
    figure;clear hh;
    conf = 2;
    if isb&~ics&~ixb
      hh(1) = plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'k','linewidth',lw);hold on
      hh(2) = plot(sbout(conf,1).x,sbout(conf,1).final_profile,'b-','linewidth',lw);hold on
      hh(3) = plot(sbout(conf,2).x,sbout(conf,2).initial_profile,'r--','linewidth',lw);
      hh(4) = plot(sbout(conf,1).x,sbout(conf,end).final_profile,'k--','linewidth',lw);
      hlabs = {'Initial';'SBEACH after 1st storm';'Before 2nd storm'; ...
               ['SBEACH after ',num2str(size(sbout,2)),' storms']};
      plot(sbin(conf,1).x,sbin(conf,1).min_zb,'r-','linewidth',lw);
      hl=legend(hh,hlabs,'Interpreter','latex');
      title([strrep(sbout(conf,1).name,'_','-'),' ;  Recovery = ',num2str(g.mm.irecover),...
             '  $T_{90}$ = ',num2str(g.mm.T90)],'Interpreter','latex','fontsize',fs)
    xlim([0 500])
    end
    if ics&~isb&~ixb
      hh(1) = plot(csout(conf,1).x,csout(conf,1).initial_profile,'k','linewidth',lw);hold on
      hh(2) = plot(csout(conf,1).x,csout(conf,1).final_profile,'b-','linewidth',lw);hold on
      hh(3) = plot(csout(conf,2).x,csout(conf,2).initial_profile,'r--','linewidth',lw);
      hh(4) = plot(csout(conf,1).x,csout(conf,end).final_profile,'k--','linewidth',lw);
      hl=legend(hh,'Initial','CSHORE after 1st storm','Before 2nd storm',['CSHORE after ',num2str(size(csout,2)),' storms'],...
                'Interpreter','latex','location','best');
      title([strrep(csout(conf,1).name,'_','-'),' ;  dXdt = ',num2str(g.mm.dXdt),' Recovery = ',num2str(g.mm.irecover),...
             '  $T_{90}$ = ',num2str(g.mm.T90)],'Interpreter','latex','fontsize',fs)
      xlim([0 500])
    end
    if ics&isb&~ixb
      hh(1) = plot(csout(conf,1).x,csout(conf,1).initial_profile,'k');hold on
      hh(1) = plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'kx');hold on
      %plot(csout(conf,1).x_offset-csout(conf,1).x,csout(conf,2).initial_profile,'r');hold on
      hh(2) = plot(csout(conf,1).x,csout(conf,end).final_profile,'r-');hold on
      %plot(sbout(conf,1).x,sbout(conf,1).initial_profile,'k');hold on
      %plot(sbout(conf,1).x,sbout(conf,).initial_profile,'r');hold on
      hh(3) = plot(sbout(conf,1).x,sbout(conf,end).final_profile,'b-');hold on
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
    
    set(gca,'TickLabelInterpreter','latex','fontsize',fs)
    %
    %  title(allout(conf).name(1,1:end-8),'interpreter','none')
    xlabel('$x[m]$','interpreter','latex','fontsize',fs)
    ylabel('$z[m]$','interpreter','latex','fontsize',fs)
    set(gca,'TickLabelInterpreter','latex')

    %print('-dpng',[dirnames(i).name,'.png'])  
  end
end
if iplotforcing
  t0 = now;
  for i = 1:length(g.forcing)
    figure
    plot(t0+g.forcing(i).t,g.forcing(i).Hmo)
    datetick
    set(gca,'TickLabelInterpreter','latex','fontsize',fs)
    title(['Distributed Storms for ',num2str(g.config.mcs_nYears),' year life-cycle, MCnum',num2str(i)],'interpreter','latex','fontsize',fs)
    xlabel('$date$','interpreter','latex','fontsize',fs)
    ylabel('$H_{m0}$','interpreter','latex','fontsize',fs)
  end
end