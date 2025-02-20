iprint =   0;
fn = dir('saved-*');
%load saved-2025-02-20-10.mat
load(fn(end).name)
load ./data/zb.dat
load ./data/x.dat
load ./data/zb_time.dat
cnt = 0;
figure(1);clf;clear hh hlabs
for i = 1:1:length(zb_time)
%for i = 1:1:2

  [j1 j2] = min(abs(zb_time(i)-[saved.time]));
  if abs(j1)<60
    cnt = cnt+1;
    disp(['Data-time Model-time Error ',num2str([zb_time(i) saved.time(j2) j1])])
    hh(cnt)=plot(x(:,i),zb(:,i),'-','linewidth',2);hold all
    plot(saved.x,saved.zb(j2,:),'--','linewidth',2,'color',get(hh(cnt),'color'));hold all
    hlabs{cnt}= ['Time =   ',num2str(zb_time(i)/3600),' hrs'];
  end

end
legend(hh,hlabs,'location','northwest')
%axis([0 45 -0 7])
ylabel('$z_{b} [m]$','fontname','times','fontsize',20,'interpreter','latex')
xlabel('x [m]','fontname','times','fontsize',14,'fontangle','italic')
title('Profile Evolution','fontname','times','fontsize',14,'fontangle','italic')
