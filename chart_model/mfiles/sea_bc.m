
function [h] = sea_bc(g, h, p, d)
% iboundary = 0 simple no flux bounray on left
if p.iboundary ==0
  %nothing needs to be done
end
if p.iboundary ==1 | p.iboundary == 2;
  h.eta_b_inc = p.H/2*sin(-p.w*h.time+pi);
  %if h.time>p.T;h.eta_b_inc = 0;end
  c = sqrt(p.g*h.old.h(1));
  k =(p.w)/c;
  %h.eta_1_inc = p.H/2*sin(k*p.dx/2 - p.w*h.time+pi);
  %h.eta_b_inc(h.time>p.T)=0;
  %h.eta_1_inc(h.time>p.T)=0;
  
  dx = c*p.dt;
  if h.time_step>2;
    eta_tot_tmp_pt = h.old.eta(1) + dx*(h.old.eta(2)-h.old.eta(1))/p.dx;
    %eta_inc_tmp_pt = p.H/2*sin(k*dx - p.w*h.old.time+pi)
    eta_inc_tmp_pt = h.old.old.eta_b_inc;
    eta_ref_tmp_pt = eta_tot_tmp_pt - eta_inc_tmp_pt;
  else
    eta_ref_tmp_pt = 0;
  end
  
  h.eta_b_ref = 1*eta_ref_tmp_pt;% 
  h.eta_b = h.eta_b_inc+h.eta_b_ref;
  h.h_b = h.eta_b-g.zb(1);
  h.q_b = (h.eta_b_inc-h.eta_b_ref)*sqrt(p.g*h.h_b);

end
%if p.iboundary == 3
%  h.h_1 = -g.zb_cent(1)+1*d.eta_ts(h.time_step);
%end


