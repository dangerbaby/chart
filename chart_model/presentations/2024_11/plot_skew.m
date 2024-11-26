H = 1;
h = 1.5;
T = 8;
t =  0:.01:T;
fs = 14;

w = 2*pi/T;
[k,n,c] = dispersion (w,h);
sigu = (H*w)./(sqrt(8)*sinh(k*h));

sk = 0
U0 = sqrt(2)*sigu/sqrt(1+sk^2);
U1 = sk*U0;
u0 = U0*cos(w*t)+U1*cos(2*w*t);

sk = .5
U0 = sqrt(2)*sigu/sqrt(1+sk^2);
U1 = sk*U0;
u1 = U0*cos(w*t)+U1*cos(2*w*t);


figure(1);clf
plot(t,0*u,'k','linewidth',1);hold all
hh(1)=plot(t,u0,'b','linewidth',2)
hh(2) = plot(t,u1,'r','linewidth',2)
title('Nonlinear waveform','interpreter','latex','fontsize',fs)
ylabel('$u [m/s]$','interpreter','latex','fontsize',fs)
xlabel('$t [s]$','interpreter','latex','fontsize',fs)
set(gca,'TickLabelInterpreter','latex','fontsize',fs)
legend(hh,'$S = 0$','$S = 1/2$','interpreter','latex','fontsize',fs,'Location','north')
text(.4,-.7,'$H = 1 m$','interpreter','latex','fontsize',fs)
text(.4,-.9,'$h = 1.5 m$','interpreter','latex','fontsize',fs)
text(.4,-1.1,'$T = 8 s$','interpreter','latex','fontsize',fs)
print -dpng skewness.png