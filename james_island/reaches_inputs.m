
%START user reaches inputs
inp.names       = {'Reach1' 'Reach3'}; 
inp.height_dune = {{8 10} {10.5 11}}; %[ft]
inp.width_dune  = {10 {12 15}}; %[ft]
inp.width_berm  = {{100 150} {120 }}; %[ft]
inp.width_upland  = {200 220}; %[ft]
inp.height_upland  = {6 7}; %[ft]
inp.slope_dune  = {.25 .25};
inp.height_berm  = {3 5}; %[ft]
inp.slope_foreshore  = {.2 .2};
%Specify minimum profile, one value per reach
inp.min_height_dune = {7 8}; %[ft]
inp.min_width_dune  = {8 8}; %[ft]
inp.min_width_berm  = {80 80}; %[ft]
inp.min_width_upland  = {200 220}; %[ft]
inp.min_height_upland  = {6 7}; %[ft]
inp.min_slope_dune  = {.25 .25};
inp.min_height_berm  = {2 4}; %[ft]
inp.min_slope_foreshore  = {.2 .2};

inp.d50 = {.30 .34}; % [mm] with length = 1 or number of reaches

