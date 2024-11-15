function [h] = plot_results(g,h,p,s)
iplotu = p.plot.plotu;iplotsed = p.plot.plotsed;ivid = p.plot.ividsave;
vidname = p.plot.vidsavename;
amp = 100;
ampqb = 3e3;
ampu = 3;
%if (mod(h.time_step,max(1,floor(p.jumpplot/p.dt)))==0|h.time_step<1000)
if (mod(h.time_step-1,p.jumpplot)==0)
  if h.time_step==1
    fs = 16;
    figure(1);clf
    dum = get(1,'position');
    set(1,'position',[dum(1) dum(2) 1100 400])
    h.plot.zb=fill([g.x g.x(end) g.x(1)],[g.zb ...
                        1.1*min(g.zb) 1.1*min(g.zb)],[.9 .9 .5]);hold on 
    if isfield(g,'zb_hb')&s.ised==2
      h.plot.zb_hb=fill([g.x g.x(end) g.x(1)],[g.zb_hb ...
                        1.1*min(g.zb_hb) 1.1*min(g.zb_hb)],[.8 .8 .8]);hold on 
    end
    plot(g.x,g.zb,'k')
    del = .75*p.dx/2;
    h.plot.eta=fill([g.x fliplr(g.x)],[h.eta fliplr(g.zb)],[.8 .8 1]);
    h.plot.eta.FaceAlpha=.5;
    %axis([min(g.x) max(g.x) .5*min(g.zb) max(max(g.zb),.2)])
    axis([min(g.x) max(g.x) min(g.zb)-.1 max(max(g.zb),.8)])
    ax = axis;ax1 = (ax(2)-ax(1));ax2 = (ax(4)-ax(3));
    plot([ax(1)+.5*ax1 ax(1)+.8*ax1],[ax(3)+.2*ax2 ax(3)+.2*ax2],'k','linewidth',3);
    text(ax(1)+.75*ax1,ax(3)+.1*ax2,['$T_f = $',num2str(p.ftime)],'interpreter','latex','fontsize',fs)
    h.plot.timebar=plot(ax(1)+.5*ax1 + .3*ax1*h.time/p.ftime ,ax(3)+.2*ax2,'r.','markersize',15);
    grid off

    title([p.name],'interpreter','latex','fontsize',fs)
    ylabel('$z [m]$','interpreter','latex','fontsize',fs)
    xlabel('$x [m]$','interpreter','latex','fontsize',fs)
    set(gca,'TickLabelInterpreter','latex','fontsize',fs)
    if p.wave.Hrms>0;
      h.plot.Hrms = plot(g.x,h.wave.Hrms,'b','linewidth',2);
    end

    if p.wind_vel>0
      anArrow = annotation('arrow') ;
      anArrow.Parent = gca;
      anArrow.Position = [10+ax(1), .1, amp*p.cf_wind*abs(p.wind_vel)*p.wind_vel*p.rho_air, 0] ;
      text(10+ax(1), .15,'$\tau_s$','interpreter','latex','fontsize',fs)
      anArrow.Color = [1 0 0];0
      anArrow.LineWidth = 3;
    end
    if iplotu
      inds = [1:2:length(g.x)];
      h.plot.u = quiver(g.x(inds),g.zb(inds)+.5*h.h(inds),ampu*h.q(inds)./h.h(inds),0*g.x(inds),0);
      h.plot.u.MaxHeadSize = .005;
      h.plot.uinds = inds;
      h.plot.u.LineWidth=1;
      h.plot.u.Color='r';
      h.plot.ampu = ampu;
    end
    if iplotsed&s.ised
      inds = [1:2:length(g.x)];
      h.plot.qb = quiver(g.x(inds),g.zb(inds)+.01,ampqb*s.qb(inds),0*g.x(inds),0);
      h.plot.qb.MaxHeadSize = .005;
      h.plot.qbinds = inds;
      h.plot.qb.LineWidth=1;
      h.plot.qb.Color='r';
      h.plot.ampqb = ampqb;
    end
    if ivid==1;
      h.plot.vidObj = VideoWriter(['./',p.name,'/',vidname]);
      h.plot.vidObj.FrameRate=30;
      open(h.plot.vidObj);
      currFrame = getframe(gcf);writeVideo(h.plot.vidObj,currFrame);
      print('-dpng',['./',p.name,'/',vidname,'.png'])
    end
    
  else
    %set(h.plot.hh,'ydata',h.eta);
    ax = axis;ax1 = (ax(2)-ax(1));ax2 = (ax(4)-ax(3));
    set(h.plot.timebar,'xdata',(ax(1)+.5*ax1 + .3*ax1*h.time/p.ftime));
    set(h.plot.eta,'ydata',[h.eta fliplr(g.zb)])
    if isfield(h.plot,'vidObj');currFrame = getframe(gcf);writeVideo(h.plot.vidObj,currFrame);end
    if isfield(h.plot,'Hrms');set(h.plot.Hrms,'ydata',h.wave.Hrms);end
    if isfield(h.plot,'u');set(h.plot.u,'udata',h.plot.ampu*h.q(h.plot.uinds)./h.h(h.plot.uinds),'ydata',g.zb(h.plot.uinds)+.5*h.h(h.plot.uinds));end
    if isfield(h.plot,'qb');set(h.plot.qb,'ydata',g.zb(h.plot.qbinds),'udata',h.plot.ampqb*s.qb(h.plot.qbinds));end
    if s.ised>0;set(h.plot.zb,'ydata',[g.zb 1.1*min(g.zb) 1.1*min(g.zb)]);end 

  
  
  
  end
  pause(.01)  
else
  h.ploti=0;  
end
