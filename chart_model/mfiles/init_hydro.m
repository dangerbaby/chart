function [h]=init_hydro(g,p)
dum = zeros(size(g.x));
%amp = 0*.3;sd = 7;


%eta_init = p.eta_0; % initial eta with a level surface
%eta_init = amp*exp(-(g.x-mean(g.x)).^2/sd^2); % initial eta with a level surface
if isfield(p,'eta_init')
  h.eta = max(p.eta_init,g.zb);
else
  h.eta = max(0,g.zb);
end
%eta_init = amp*exp(-(g.x_walls-mean(g.x_walls)).^2/sd^2); % initial eta with a level surface
%h.eta_walls = max(eta_init,g.zb_walls);
%h.h = h.eta-g.zb_cent;
h.h = h.eta-g.zb;
% l = min(p.dx,h.h_walls(1:end-1)./(g.dzbdx_cent+eps));
% int_vol_from_left = l.*h.h_walls(1:end-1)-.5*g.dzbdx_cent.*l.^2;
% l = min(p.dx,h.h_walls(2:end)./(abs(g.dzbdx_cent)+eps));
% int_vol_from_right = l.*h.h_walls(2:end)+.5*g.dzbdx_cent.*l.^2;
% h.vol = (g.dzbdx_cent>=0).*int_vol_from_left +  (g.dzbdx_cent<0).*int_vol_from_right;
% h.tot_vol = sum(h.vol);
%h.detadx = g.dzbdx_walls;h.detadx(h.h_walls>0)=0;

h.q=dum;
%h.u = dumw;
%h.dqdt = dumw;
%h.eta_1_inc=0;
%
h.time_ts = p.dt:p.dt:p.ftime+p.dt;
h.time_step = 1;
h.time=0;
h.old=h;
h.old.old=h;
%h.plot_cnt=0;

if isfield(p,'eta_0')
  h.eta_0_i = interp1(p.eta_0_time,p.eta_0,h.time_ts);
  h.dhdt = cdiff(p.dt,h.eta_0_i);
end


