% CHART NLSWE, and wave, sediment model  
% p = structure of parameters
% g = structure of geometry
% h = structure of hydro
% w = structure of waves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
tic
p.name = 'planar';
%p.name = 'rehoboth';
p.name = 'gee';
addpath('mfiles',p.name)
% Set model default run parameters
[p,g,s] = default(p);
% Set model run parameters
[p,g,s] = params_and_geom(p);
% Make geometry
g = init_grid(g,p);
% Set time_step
[p] = set_dt(g,p);
% Initialize hydro
[h] = init_hydro(g,p);
% Initialize sed
[s] = init_sed(s,p);
saved = [];
%%%%%%%%%%%%%%%%%%%%%%Time Loop%%%%%%%%%%%%%%%%%%%%%
while h.time<p.ftime;
  h.old = h;
  h.old.old= rmfield(h.old.old,'old');
  
  % Integrate hydro to next time level 
  [g,h] = shallow_water_moving_shore(g,h,p);

  % Find new total load
  [s,g] = sed_trans(g,h,p,s);

  %Update time step
  h.time_step = h.time_step+1;
  h.time = (h.time_step)*p.dt;

  %save results
  [saved] = save_results(g,h,p,s,saved);

  %plot results
  [h] = plot_results(g,h,p,s);

  % check for haywire computation
  if max(isnan(h.q))
    error('Nan detected')
  end

  %Update time step
  %h.time_step = h.time_step+1;
  %h.time = (h.time_step)*p.dt;

end
if isfield(h.plot,'vidObj');close(h.plot.vidObj);end

toc