function g = make_boundary_conditions(g)
if ~g.iclean;return;end

w = 2*pi/(g.tides.T/24);%1/day
for i = 1:length(g.forcing)
  indstart = find(g.forcing(i).summary(:,3)==0);
  indend = [indstart-1;size(g.forcing(i).summary,1)];indend = indend(2:end);
  for j = 1:length(indstart)
    ind = indstart(j):indend(j);
    bc(i).timeseries(j).date = g.forcing(i).summary(ind,3)/24;         
    bc(i).timeseries(j).wl   = g.forcing(i).summary(ind,5)+g.tides.amp*sin(w*bc(i).timeseries(j).date);         
    bc(i).timeseries(j).Hmo  = g.forcing(i).summary(ind,6);         
    bc(i).timeseries(j).Tp   = g.forcing(i).summary(ind,7);         
    bc(i).timeseries(j).dir  = g.forcing(i).summary(ind,8);         
  end
end

g.bc = bc;