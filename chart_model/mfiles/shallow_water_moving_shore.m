function [h] = shallow_water_moving_shore (g,h,p)

small_depth = 1e-5;
qold = h.q;
hold = h.h;
etaold = h.eta;

iwet  = hold>small_depth;idry = ~iwet;

%find new conditions at boundaries
[h] = set_bc(g,h,p);

% do the wave model
if p.wave.Hrms>0
  [k,n,c] = dispersion (2*pi/p.wave.T,hold);
  H(1)=p.wave.Hrms;
  for i = 2:length(hold);
    H(i)=min(sqrt(H(i-1)^2*c(i-1)*n(i-1)/(c(i)*n(i))),p.wave.gamma*hold(i));
  end
  [Sxy Sxx Syy] = radstress (H, 0*H, n, c);
  dSxxdx = [0 Sxx(3:end)-Sxx(1:end-2) 0]./(2*p.dx);
  dSxxdx(idry) = 0;
  Ur = -p.g*H.^2./(8*c.*hold);
  Ur(idry) = 0;
else
  H = 0*hold;
  dSxxdx = 0*hold;
  Ur = 0*hold;
end

idryonright = [hold(2:end)<small_depth 0];
iwetonright = 1-idryonright;
idryonleft = [0 hold(1:end-1)<small_depth ];
iwetonleft = 1-idryonleft;
ind_pos = qold>0;  ind_neg = ~ind_pos;
detadx =    [0 (etaold(3:end)-etaold(1:end-2))./(2*p.dx) (etaold(end)-etaold(end-1))/p.dx];  % CD
                                                                                             
%detadxpos = [0 (etaold(2:end)-etaold(1:end-1))./(1*p.dx)];  % 
%detadxneg = [  (etaold(2:end)-etaold(1:end-1))./(1*p.dx) (etaold(end)-etaold(end-1))/p.dx];  % 
%detadx =  detadxpos.*ind_pos + detadxneg.*ind_neg;                                                 
%detadx =  detadxpos;                                                
ind = find(iwet&idryonright&~idryonleft);
detadx(ind) = (etaold(ind)-etaold(ind-1))/p.dx;
ind = find(iwet&~idryonright&idryonleft);
detadx(ind) = (etaold(ind+1)-etaold(ind))/p.dx;
if p.iboundary_l ==1;detadx(end) = .005*(g.zb(end)-etaold(end))/p.dx;end
pressgrad = p.g*hold.*detadx;
U = qold./hold;
U = sign(U).*min(abs(U),sqrt(p.g*hold));
U = U+Ur;
taub = 1*p.cf*abs(U).*U;
taub(idry)=0;  
taua = 1*p.cf_wind*p.rho_air/p.rho*abs(p.wind_vel).*p.wind_vel*ones(size(qold));
taua(idry)=0;  
qsqoverh = p.iconvect*([qold.^2./(hold+eps)]);
qsqoverh(idry)=0;
%convectgrad = [0 qsqoverh(3:end)-qsqoverh(1:end-2) 0]./(2*p.dx); 
dqsqoverhdxpos = [0 qsqoverh(2:end)-qsqoverh(1:end-1) ]./(p.dx); 
dqsqoverhdxneg = [qsqoverh(2:end)-qsqoverh(1:end-1) 0 ]./(p.dx); 
convectgrad   = ind_pos.*dqsqoverhdxpos+ind_neg.*dqsqoverhdxneg;
qnew    = qold-1*p.dt*pressgrad-1*p.dt*taub-1*p.dt*convectgrad+1*p.dt*taua-p.dt*dSxxdx/p.rho;
if (p.iboundary_0==0);qnew(1) = 0;end
if (p.iboundary_0==2|p.iboundary_0==3);qnew(1) = h.q_0;end
qnew(find(idry)) = 0;
if (p.iboundary_l==0);qnew(end) = 0;end
dqdx    = [(qnew(2)-qnew(1))/(p.dx)  (qnew(3:end)-qnew(1:end-2))./(2*p.dx)  (qnew(end)-qnew(end-1))/(p.dx)  ];
dqdx(find(idry)) = 0;
hnew    = hold-1*p.dt*(dqdx);
if (p.iboundary_0==2|p.iboundary_0==3);hnew(1) = h.h_0;end

%F = ((h.q./h.h).^2)./(p.g*h.h);
%median(F,'omitnan')
if (mod(h.time_step,p.jumpsmooth)==0)
 
  sn = max(0,min(p.smooth_num,1));
  hnew= (1-sn)*hnew+sn*window(hnew,3);
end

etanew = hnew+g.zb;
%find all newly wet points on righ of wetted domain
ind = find(idry&iwetonleft&[0 qnew(1:end-1)>0]&[0 etanew(1:end-1)]>g.zb);
% disp(['qnew:',sprintf(repmat('%0.3g ',1,2),qnew)])
% disp(['dqdx:',sprintf(repmat('%0.3g ',1,2),dqdx)])
%if ~isempty(ind)
%  disp(['Newly wet:',num2str([h.time_step ind])])
%end
hnew(ind) = (etanew(ind-1)-g.zb(ind)).*(g.dzbdx(ind)>0) +.005*(g.dzbdx(ind)<=0);
%find all newly wet points on left of wetted domain
ind = find(idry&iwetonright&[qnew(2:end)<0 0]&[etanew(2:end) 0]>g.zb);
% disp(['qnew:',sprintf(repmat('%0.3g ',1,2),qnew)])
% disp(['dqdx:',sprintf(repmat('%0.3g ',1,2),dqdx)])
%if ~isempty(ind)
%  disp(['Newly wet:',num2str([h.time_step ind])])
%end
hnew(ind) = (etanew(ind+1)-g.zb(ind)).*(g.dzbdx(ind)<0) +.005*(g.dzbdx(ind)>=0);

hnew(hnew<0)=0;
%hnew(hnew<small_depth)=0;
etanew = hnew+g.zb;
h.q = qnew;
h.h = hnew;
h.eta = etanew;
if p.wave.Hrms>0
  h.wave.Hrms=H;
  h.wave.c=c;
end
