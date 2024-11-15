function   [s,g] = sed_trans(g,h,p,s)
if s.ised==0;return;end

d2=s.d_50/1000;
U = h.q./h.h;

if p.wave.Hrms>0&1
  U = U-1*(p.g*h.wave.Hrms.^2)./(8*h.wave.c.*h.h);
  U(isnan(U))=0;
  t = repmat(linspace(0,p.wave.T,9)',1,length(h.h));   t = t(1:end-1,:);
  w = 2*pi/p.wave.T;
  kh = h.h.*w./h.wave.c;
  sigu = (h.wave.Hrms*w)./(sqrt(8)*sinh(kh));
  if isfield(s,'waveskewparam')
    sk = min(1,max(0,s.waveskewparam));
    U0 = sqrt(2)*sigu/sqrt(1+sk^2);
    U1 = sk*U0;
  else
     U0 = sqrt(2)*sigu;
     U1 = 0*U0;
  end
  u = repmat(U0,size(t,1),1).*cos(w*t)+repmat(U1,size(t,1),1).*cos(2*w*t);
else 
  u=0;
end

%Ulim = U;
%U = U+u
Ulim = sign(U).*min(abs(U),1*sqrt(p.g.*max(h.h,0)));
Ulim = u+repmat(Ulim,size(u,1),1);
dzbdx = repmat(g.dzbdx,size(u,1),1);
% for u>0
slopeeffectneg = s.tanphi./(s.tanphi+dzbdx); % for neg slope (downslope enhance)
slopeeffectpos = (s.tanphi-2*dzbdx)./(s.tanphi-dzbdx);
slopeeffectqpos = slopeeffectneg.*(dzbdx<=0)+slopeeffectpos.*(dzbdx>0);
% for u<0
slopeeffectpos = s.tanphi./(s.tanphi-dzbdx);%for pos slope
slopeeffectneg = (s.tanphi+2*dzbdx)./(s.tanphi+dzbdx);
slopeeffectqneg = slopeeffectneg.*(dzbdx<=0)+slopeeffectpos.*(dzbdx>0);
slopeeffect = slopeeffectqneg.*(Ulim<=0)+slopeeffectqpos.*(Ulim>0);
%slopeeffect = 1-(slopeeffect-1); % reverse slope effect for testing
%slopeeffect = .5*(slopeeffect+[slopeeffect(1) slopeeffect(1:end-1)]);

tau_skin = s.cf*p.rho*abs(Ulim).*Ulim;
%disp(['Ulim:',sprintf(repmat('%0.3g ',1,1),Ulim)])
theta = tau_skin./ (p.g*p.rho*(s.sg-1)*d2);
theta_cr = s.taucr/(p.g*p.rho*(s.sg-1)*d2);
phi = zeros(size(tau_skin));
ind = (abs(theta)>theta_cr);
phi(ind) = s.bl*8*sign(theta(ind)).*(abs(theta(ind))-theta_cr).^1.5;
qbeq = phi.*sqrt(p.g*(s.sg-1)*d2^3);
qbeq = qbeq.*slopeeffect;
qbeq = mean(qbeq,1);

  
%if std(qb>1e-3)&1
if std(qbeq>1e-3)&1
  disp([num2str(h.time),' Smoothing qbeq'])
  qbsm = mean([[qbeq(2:end) qbeq(end)];qbeq;[qbeq(1) qbeq(1:end-1)]]);
  sn = max(0,min(s.smooth_num,1));
  %qb= (1-sn)*qb+sn*window(qb,11);
  qbeq= (1-sn)*qbeq+sn*qbsm;
  qbeq(h.h<eps) = 0;
end
if s.ised==1
  qb = qbeq;
  dqbdx = [0 (qb(3:end)-qb(1:end-2))/(2*p.dx) (qb(end)-qb(end-1))/p.dx];
elseif s.ised==2
  if isfield(g,'zb_hb')
    th = g.zb-g.zb_hb;
  else
    th = 100;%absurdly thick sand layer;
  end
  minth = .01;% minimum thickness
  avail = th>minth;
  s.blthick = .01;
  s.beta = s.wf./(s.blthick*Ulim);  s.beta(s.beta>100) = 100;   s.beta(s.beta<-100) = -100;
  s.beta(isnan(s.beta)) = 0;
   %s.beta = ones(size(s.beta));
  A = diag(2*p.dx*s.beta)+diag(ones(1,length(s.beta)-1),1)+diag(-ones(1,length(s.beta)-1),-1);
  A(1,1) = -1;
  A(end,end) = 1;
  B = 2*p.dx*s.beta'.*qbeq(1:end)';
  B(1) = 0;
  B(end) = 0;
  B = B.*avail';
  X = A\B;
  qb = [X'];
  dqbdx = s.beta.*(qbeq.*avail-qb);
  
  
end




  
%dqbdx = [0 (qb(3:end)-qb(1:end-2))/(2*p.dx) 0];
%dqbdx = [0 (qb(2:end)-qb(1:end-1))/(1*p.dx)];
dzbdt = -dqbdx/(1-s.poro);
s.qbeq = qbeq;
s.qb = qb;
s.U = U;
g.zb = g.zb+p.dt*dzbdt;

%disp(['qb:',sprintf(repmat('%0.3g ',1,1),qb)])



