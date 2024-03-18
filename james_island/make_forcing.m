function g = make_forcing(g)
if ~g.iclean;return;end

addpath(genpath('~/wes/StormSim-Library/StormSim_Library'))
% use SS to make series of storms, separated into years 
cd(g.name)
%stormsim_input_file = 'StormSim_Inputs.xlsx'; %Include relative path if not in parent directory
%config = call_input_parser(stormsim_input_file);  
load brad_config.mat
config = alter_config_inputs(config);
[storm, ~, prob_mass, config] = call_chs_data_formater(config);
load ssresults.mat
[project_forcing] = call_project_forcing_formater(config, storm, prob_mass);

% make proper time-series of boundary conditions
g.forcing = make_timeseries(config,project_forcing);
g.config = config;
cd ..                                              