
function [h] = set_bc(g, h, p, d)
% iboundary_0 = 0 simple no flux bounray on left
% iboundary_0 = 1 simple oscillating boundary based on p.H and p.T on left
% iboundary_0 = 2 simple oscillating boundary based on p.H and p.T allowing neg prop waves to radiate
% iboundary_0 = 3 set both h, q on left

if p.iboundary_0 ==0
  %nothing needs to be done
end
if p.iboundary_0 == 2;
  h.eta_0_inc = p.H/2*sin(-p.w*h.time+pi);
  %if h.time>p.T;h.eta_0_inc = 0;end
  c = sqrt(p.g*h.old.h(1));
  k =(p.w)/c;
  dx = c*p.dt;
  if h.time_step>2;
    eta_tot_tmp_pt = h.old.eta(1) + dx*(h.old.eta(2)-h.old.eta(1))/p.dx;
    %eta_inc_tmp_pt = p.H/2*sin(k*dx - p.w*h.old.time+pi)
    eta_inc_tmp_pt = h.old.old.eta_0_inc;
    eta_ref_tmp_pt = eta_tot_tmp_pt - eta_inc_tmp_pt;
  else
    eta_ref_tmp_pt = 0;
  end
  h.eta_0_ref = 1*eta_ref_tmp_pt;% 
  h.eta_0 = h.eta_0_inc+h.eta_0_ref;
  h.h_0 = h.eta_0-g.zb(1);
  h.q_0 = (h.eta_0_inc-h.eta_0_ref)*sqrt(p.g*h.h_0);
end
if p.iboundary_0 == 3
  %h.q_0 = .5;
  %h.h_0 = 0-g.zb(1);
  dhdt = .002;
  dhdt = h.dhdt(h.time_step);
  h.h_0 = h.eta_0_i(h.time_step)-g.zb(1);
  %h.h_0 = h.h(1)+p.dt*dhdt;
  h.q_0 = h.q(2)+p.dx*dhdt;
  %h.q_0 = .01;
end


