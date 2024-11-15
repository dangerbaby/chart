% CHART NLSWE, and wave, sediment model  
% p = structure of parameters
% g = structure of geometry
% h = structure of hydro
% w = structure of waves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
tic
p.name = 'planar';
addpath('mfiles',p.name)
% Set model run parameters
[p,g,s] = params_and_geom(p);
% Make geometry
%g = grid_bathy(p);
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
  
  % integrate hydro to next time level 
  [h] = shallow_water_moving_shore(g,h,p);

  % find new bedload
  %[sed] = sed_bedload(geom,hydro,param,sed);

  %  find new suspended load
  [s,g] = sed_trans(g,h,p,s);

  %save results
  [saved] = save_results(g,h,p,s,saved);

  %plot results
  [h] = plot_results(g,h,p,s);

  % check for haywire computation
  if max(isnan(h.q))
    error('Nan detected')
  end

  %Update time step
  h.time_step = h.time_step+1;
  h.time = (h.time_step)*p.dt;




end
  
return
%Parameters
param.name = 'planarwithwaves';
param.ividsave = 0;
param.dx =  1;
param.Cn = .5;
param.ftime = 100;
param.ftime = 24*3600;
param.jumpplot = 10000;
param.jumpsave = 100000;
param.smooth_num = .1;
param.jumpsmooth = Inf;
param.delta_s=.01;
param.H = 0*0.3;
param.T = 200;
param.T = 12*3600;
param.wave.Hrms = 1*.6;
param.wave.T = 8;
param.wave.gamma = .7;
param.iconvect = 1;
param.w = 2*pi/param.T;
param.iboundary = 2;% force boundary with incident wave free surface time series
                    
%param.iboundary = 0;% no flux ( reflective boundary)

% Set hydro parameters
[param] = set_params_hydro(param);
% Make geometry
[geom] = grid_bathy(param);
% Set sediment parameters
[sed] = set_params_sed(geom,param);
% Set time_step
[param] = set_dt(geom,param);
% Initialize hydro
[hydro] = init_hydro(geom,param);
% Get boundary data
%[hydro dat] = get_data(geom,hydro,param);
% Initialize time
hydro.time_step = 1;
hydro.time=0;
saved.ini = 0;
hydro.old=hydro;
hydro.old.old=hydro;
cnt=0;
%t_old = 0
tic; 
%%%%%%%%%%%%%%%%%%%%%%Time Loop%%%%%%%%%%%%%%%%%%%%%
while hydro.time<param.ftime;
  hydro.old = hydro;
  hydro.old.old= rmfield(hydro.old.old,'old');
  
  
  %find new conditions at seaward boundary
  [hydro] = sea_bc(geom,hydro,param);

  % determine eddy viscosity
  [hydro] = set_eddy_visc(geom,hydro,param);

  % integrate hydro to next time level 

  [hydro] = shallow_water_moving_shore(geom,hydro,param);

  % find new bedload
  %[sed] = sed_bedload(geom,hydro,param,sed);

  % find new suspended load
  %[sed] = suspended_sed(geom,hydro,param,sed);

  % smooth hydro if necessary
  %[hydro] = smooth_hydro(geom,hydro,param);

  %plot results
  [hydro] = plot_results(geom,hydro,param,sed);
  %if hydro.ploti;t_new = toc;disp(num2str(t_new-t_old));t_old=t_new;,end
  if hydro.ploti&param.ftime-hydro.time<50;cnt = cnt+1;M(cnt)=getframe(1);end


  % check for haywire computation
  if max(isnan(hydro.q))
    error('Nan detected')
  end

  %Update time step
  hydro.time_step = hydro.time_step+1;
  hydro.time = (hydro.time_step)*param.dt;

end
%%%%%%%%%%%%%%%%%%%%%%End Time Loop%%%%%%%%%%%%%%%%%%%%%
if isfield(hydro.plot,'vidObj');close(hydro.plot.vidObj);end
%plot_results_final(meas_data,saved);
toc