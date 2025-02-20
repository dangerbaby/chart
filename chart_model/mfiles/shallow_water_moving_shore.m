function [g,h] = shallow_water_moving_shore (g,h,p)
small_depth = 1e-3;
qold = h.q;
hold = h.h;
etaold = h.eta;
taper = 1*max(0,min(1,hold/(.05)));
iwet  = hold>small_depth;idry = ~iwet;
%iwet
%find new conditions at boundaries
[h] = set_bc(g,h,p);

% do the wave model
if mean(p.wave.Hrms)>0
  if h.time_step==1
    h.bc.Hrms = interp1([ -1 p.wave.time],[p.wave.Hrms(1) p.wave.Hrms],h.time_ts);
    h.bc.T = interp1([-1 p.wave.time],[p.wave.T(1) p.wave.T],h.time_ts);
  end
  %[k,n,c] = dispersion(2*pi/p.wave.T,hold);
  [k,n,c] = dispersion_quick (2*pi/h.bc.T(h.time_step),hold);

  H(1)=h.bc.Hrms(h.time_step);
   for i = 2:length(hold);
     H(i)=min(sqrt(H(i-1)^2*c(i-1)*n(i-1)/(c(i)*n(i))),p.wave.gamma*hold(i));
   end
  Sxx = p.rho/8*p.g*H.^2.*(2*n-.5);
  dSxxdx =1*[0 Sxx(3:end)-Sxx(1:end-2) 0]./(2*p.dx);
  %dSxxdx = [0 Sxx(2:end)-Sxx(1:end-1) ]./(1*p.dx);
  dSxxdx(idry) = 0;
  Ur = -p.g*H.^2./(8*c.*hold);
  Ur(idry) = 0;
else
  H = 0*hold;
  dSxxdx = 0*hold;
  Ur = 0*hold;
end
U = qold./hold;
U = sign(U).*min(abs(U),sqrt(p.g*hold));
U = U+Ur;
taub = 1*p.cf*abs(U).*U;
taub(idry)=0;  
taua = 1*p.cf_wind*p.rho_air/p.rho*abs(p.wind_vel).*p.wind_vel*ones(size(qold));
taua(idry)=0;  

idryonright = [hold(2:end)<small_depth false];
iwetonright = ~idryonright;
idryonleft = [false hold(1:end-1)<small_depth ];
iwetonleft = ~idryonleft;

detadx =    [(etaold(2)-etaold(1))/p.dx (etaold(3:end)-etaold(1:end-2))./(2*p.dx) (etaold(end)-etaold(end-1))/p.dx];  % CD
% i1 = detadx>0;i2= ~i1;
% detadx1=[0 (etaold(2:end)-etaold(1:end-1))/p.dx];
% detadx2=[(etaold(2:end)-etaold(1:end-1))/p.dx 0];
% detadx = detadx1.*i2+detadx2.*i1;



ind = find(iwet&idryonright&~idryonleft);
detadx(ind) = (etaold(ind)-etaold(ind-1))/p.dx;
%detadx(ind) = ind_pos(ind).*(etaold(ind)-etaold(ind-1))/p.dx+ind_neg(ind).*(g.zb(ind+1)-etaold(ind))/p.dx;
%a = 1;
%detadx(ind) = a*detadx(ind)+(1-a)*((g.zb(ind+1)-etaold(ind))/(1*p.dx));
%ind = find(iwet&~idryonright&idryonleft);
ind = find(iwet&~idryonright&idryonleft&[ones(1,length(g.x)-1) 0]);
detadx(ind) = (etaold(ind+1)-etaold(ind))/p.dx;

if p.iboundary_l ==1;detadx(end) = .001*(g.zb(end)-etaold(end))/p.dx;end
%if p.iboundary_l ==1;detadx(end) = -.01*p.cf;end
%if p.iboundary_l ==2;detadx(end) = (etaold(end)-etaold(end-1))/p.dx;end
if ~isfield(p,'iswash')|p.iswash==0
  Pwet = 1;
else
  Pwet = 1;
end

pressgrad = p.g*hold.*detadx;
%pressgrad(idry)=0;
qsqoverh = p.iconvect*([qold.^2./(hold+eps)]);
qsqoverh(idry)=0;
%convectgrad = [0 qsqoverh(3:end)-qsqoverh(1:end-2) 0]./(2*p.dx); 
dqsqoverhdxpos = [0 qsqoverh(2:end)-qsqoverh(1:end-1) ]./(p.dx); 
dqsqoverhdxneg = [qsqoverh(2:end)-qsqoverh(1:end-1) 0 ]./(p.dx); 
ind_pos = qold>0;  ind_neg = ~ind_pos;
convectgrad   = ind_pos.*dqsqoverhdxpos+ind_neg.*dqsqoverhdxneg;
convectgrad(end) = 0;
convectgrad(1) = 0;
%dudx=cdiff(p.dx,U);
%Txx = .3*sqrt(p.g*hold).*hold.*dudx;
%ddxTxx = cdiff(p.dx,Txx);ddxTxx(isnan(ddxTxx))=0;
ddxTxx = p.eddyvisc*sqrt(p.g*hold).*hold.*cdiff(p.dx,cdiff(p.dx,U));ddxTxx(isnan(ddxTxx))=0;
dqdt = -1*pressgrad-1*taub-1*convectgrad+1*taua-1*dSxxdx/p.rho+1*ddxTxx;
qnew = qold+p.dt*dqdt;

if (p.iboundary_0==0);qnew(1) = 0;end
if (p.iboundary_0==2|p.iboundary_0==3);qnew(1) = h.q_0;end
qnew(find(idry)) = 0;
if (p.iboundary_l==0);qnew(end) = 0;end
if (p.iboundary_l==3);qnew(end) = h.q_l;end

% if (mod(h.time_step,p.jumpsmooth)==0)
%   disp('Smoothing')
%   sn = max(0,min(p.smooth_num,1));
%   qsm=window(qnew,5);
%   qsm=[qnew(1) .5*(qnew(1:end-1)+qnew(2:end))];
%   qnew= (1-sn)*qnew+sn*qsm;
% end

%Fr = max(qnew(iwet).^2./(p.g*hnew(iwet).^3));
Fr = (qnew(hold>small_depth).^2./(p.g*hold(hold>small_depth).^3));
if max(Fr)>1;
  %disp(['Supercritical flow at t = ',num2str([h.time max(Fr)])])
  %qnew(Fr>1) = .8*qnew(Fr>1);
  qnew(2:end-1) = (1-p.smooth_num)*qnew(2:end-1) + .5*p.smooth_num*(qnew(1:end-2)+qnew(3:end));
  hold(2:end-1) = (1-p.smooth_num)*hold(2:end-1) + .5*p.smooth_num*(hold(1:end-2)+hold(3:end));
  qnew(idry) = 0;
  hold(idry) = 0;
end

dqdx    = [(qnew(2)-qnew(1))/(p.dx)  (qnew(3:end)-qnew(1:end-2))./(2*p.dx)  (qnew(end)-qnew(end-1))/(p.dx)  ];
dqdx(find(idry)) = 0; %2025-01-17 should comment this out?
hnew    = hold-1*p.dt*(dqdx);
if min(hnew)<0
  indnegh = find(hnew<0) ;
  %disp(['h<0 at ',num2str([h.time_step indnegh hnew(indnegh)])])  
  %disp(['                   and h(i-1) h(i) h(i+1) ',num2str([hnew(indnegh-1) hnew(indnegh) hnew(indnegh+1)])])   
  %disp(['                   and q(i-1) q(i) q(i+1) ',num2str([qnew(indnegh-1) qnew(indnegh) qnew(indnegh+1)])]) 
  
  %hnew(indnegh) = max(.5*(hnew(indnegh+1)-hnew(indnegh-1)+g.zb(indnegh+1)-g.zb(indnegh-1))-g.zb(indnegh),0);
  hnew(indnegh) = small_depth; 
  %qnew(indnegh-1:indnegh+1) =   mean(qnew(indnegh-2:indnegh+2)); 
  
  %disp(['                   corrected to  ',num2str(hnew(indnegh))])  
  qsm = window(qnew,3);
  %qsm = qnew;
  qnew = (1-.9)*qnew+.9*qsm; 
end
  
etanew = hnew+g.zb;
if (p.iboundary_0==2|p.iboundary_0==3);hnew(1) = h.h_0;end
if (p.iboundary_l==3);hnew(end) = h.h_l;end

%TV = sum(abs(etanew(2:end)-etanew(1:end-1)).*iwet(1:end-1));
%disp(['Froude Num = ',sprintf('%9.8f %3.2f',[Fr max(qnew)])])
%disp(['TV = ',sprintf('%3.2f %3.2f',[TV max(qnew)])])
% if (mod(h.time_step,p.jumpsmooth)==0)
%      disp('Smoothing')
%      sn = max(0,min(p.smooth_num,1));
%      qsm = window(qnew,5);
%      qnew = (1-sn)*qnew+sn*qsm; 
     %etasm = etanew;etasm(idry)=NaN;etasm=window(etasm,3);etasm(isnan(etasm))=etanew(isnan(etasm));
     %etanew= (1-sn)*etanew+sn*etasm;
     %hnew = etanew-g.zb;
     %end

%disp(num2str([etanew(29) etanew(30) qnew(29) dqdt(29)*p.dt dSxxdx(29)/1000 pressgrad(29)])) 
%find all newly wet points on right of wetted domains
ind = find(idry&iwetonleft&[0 qnew(1:end-1)>0]&[0 etanew(1:end-1)]>g.zb);
%max(ind)
% disp(['qnew:',sprintf(repmat('%0.3g ',1,2),qnew)])
% disp(['dqdx:',sprintf(repmat('%0.3g ',1,2),dqdx)])
%if ~isempty(ind)
%  disp(['Time ',num2str([h.time_step]),' Newly wet:',num2str([ind])])
%end
hnew(ind) = (etanew(ind-1)-g.zb(ind)).*(g.dzbdx(ind)>0) +2*small_depth*(g.dzbdx(ind)<=0);
%hnew(ind) = (etanew(ind-1)-g.zb(ind)).*(g.dzbdx(ind)>=0) +2*small_depth*(g.dzbdx(ind)<0);
%qnew(ind) = 0;
%find all newly wet points on left of wetted domain
ind = find(idry&iwetonright&[qnew(2:end)<0 0]&[etanew(2:end) 0]>g.zb);
% disp(['qnew:',sprintf(repmat('%0.3g ',1,2),qnew)])
% disp(['dqdx:',sprintf(repmat('%0.3g ',1,2),dqdx)])
%if ~isempty(ind)
%  disp(['Newly wet:',num2str([h.time_step ind])])
%end
hnew(ind) = (etanew(ind+1)-g.zb(ind)).*(g.dzbdx(ind)<0) +.005*(g.dzbdx(ind)>=0);

hnew(hnew<0)=0;
%hnew(hnew<0)=small_depth;
etanew = hnew+g.zb;
if H(1)>0
  h.wave.Hrms=H;
  h.wave.c=c;
end
h.q = qnew;
h.h = hnew;
h.eta = etanew;

[g,h]= overtopping(g,h,p);
