%housekeeping:
addpath(genpath('./mfiles'));
clear all;close all

% project name and directory
g.name = 'james_island';

%more housecleaning
g.iclean = 0;
g = clean(g);

% load old forcing, if it exists and iclean = 0
g = load_g(g);

%use SS or whatever to make your series of storms
g = make_forcing(g);

%make transects or reaches 
g = make_reaches('reaches_inputs',g);

%make tides
g = make_tides('tides_inputs',g);

%make bc's
g = make_boundary_conditions(g);

%save forcing 
save_g(g)

%run_morphology
g = set_morpho_model_inputs('morpho_model_inputs',g);
g = do_morphology(g);

%plot profile with changes
%plot_results







return


if ~exist('config')
  %housekeeping:
  clear all;close all
  addpath(genpath('../StormSim_Library'),genpath('../brad_mfiles'));

  % use SS to make series of storms, separated into years 
  stormsim_input_file = 'StormSim_Inputs.xlsx'; %Include relative path if not in parent directory
  config = call_input_parser(stormsim_input_file); % 
  config = alter_config_inputs(config);
  [storm, ~, prob_mass, config] = call_chs_data_formater(config);
  [project_forcing] = call_project_forcing_formater(config, storm, prob_mass);

  % make proper time-series of boundary conditions
  forcing = make_timeseries(config,project_forcing);

end

return



iclean = 0; % iclean = 1 to remove all existing results in infile and outfile directories   
if iclean ;[j1,j1,j1]=rmdir('work/infiles','s');[j1,j1,j1]=rmdir('work/outfiles','s');clear j1 iclean;end


%make transects or reaches 
reaches_input_file = 'reaches_inputs';
reaches=make_reaches(reaches_input_file);
%make tides
tides_input_file = 'tides_inputs';
tides=make_tides(tides_input_file);
%make storms
bc = make_boundary_conditions(forcing,tides);
%run_morphology
model_input_file = 'model_inputs';
run(model_input_file);

reaches = do_morphology(mm,reaches,bc);

%plot profile with changes
%plot_results




