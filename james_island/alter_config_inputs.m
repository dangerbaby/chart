function config = alter_config_inputs(config)

config.workflow   = 3;
config.mcs_nLC    = 4; % was 200
config.mcs_nYears = 10;% was 50

for i = 1:size(config.chs_files_2_convert,1)
  config.chs_files_2_convert{i,1} = './james_island/Temp/H5';
  config.chs_files_2_convert_path{i} = './james_island/Temp/H5';
  config.chs_files_2_convert{i,1} = './Temp/H5';
  config.chs_files_2_convert_path{i} = './Temp/H5';
end


%config