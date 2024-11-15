function [saved]=save_results(g,h,p,s,saved)

DT = max(1,floor(p.jumpsave/p.dt));

if h.time_step==1
  %dum = NaN*zeros(floor((p.ftime/p.dt)/DT),length(h.q));
  saved.cnt = 0;
  saved.time = NaN*zeros(floor((p.ftime/p.dt)/DT),1);
  %saved.eta_2 = NaN*zeros(floor((p.ftime/p.dt)/DT),length(d.gauge_positions_ind));
  %saved.x_sl = NaN*zeros(floor((p.ftime/p.dt)/DT),1);
  %saved.C = dum_c;
  %saved.C0 = dum_c;
end
if (mod(h.time_step,DT)==0)
  saved.cnt = saved.cnt+1;
  saved.time(saved.cnt) = h.time ;
  %saved.eta_2(saved.cnt,:) = h.eta(d.gauge_positions_ind);
  %saved.x_sl(saved.cnt) = h.xs;
  %saved.C(saved.cnt,:) = sed.C;
  saved.h(saved.cnt,:) = h.h;
  saved.q(saved.cnt,:) = h.q;
  if s.ised
  saved.qb(saved.cnt,:) = s.qb;
  end
end
