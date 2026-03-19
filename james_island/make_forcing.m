function g = make_forcing(g)
if ~g.iclean;return;end
cheat = 1;
scale = 2;
%addpath(genpath('~/wes/StormSim-Library/StormSim_Library'))
addpath(genpath(g.pathtostormsim));

% use SS to make series of storms, separated into years 
cd(g.name)
if cheat 
  load brad_config.mat
  config = alter_config_inputs(config);
  %  disp([' In make_forcing 0 with mcs_nLc  =',num2str(config.mcs_nLC)])
else
  stormsim_input_file = 'StormSim_Inputs.xlsx'; %Include relative path if not in parent directory
  config = call_input_parser(stormsim_input_file);  
end
[storm, ~, prob_mass, config] = call_chs_data_formater(config);
%load ssresults.mat
[project_forcing] = call_project_forcing_formater(config, storm, prob_mass);

% make proper time-series of boundary conditions
g.forcing = make_timeseries(config,project_forcing);
if exist('scale')
  for i = 1:length(g.forcing)
    g.forcing(i).summary(:,6)= scale*g.forcing(i).summary(:,6);
    g.forcing(i).summary(:,7)= max(1,scale)*g.forcing(i).summary(:,7);
    g.forcing(i).Hmo = scale*g.forcing(i).Hmo;
    g.forcing(i).Tp = max(1,scale)*g.forcing(i).Tp;
  end
end
g.config = config;
%disp([' In make_forcing with mcs_nLc  =',num2str(config.mcs_nLC)])
cd ..                                              