
%START user reaches inputs
inp.names       = {'Reach1' 'Reach3'}; 
inp.height_dune = {{9 10} num2cell(9:1:10)}; %[ft]
inp.height_dune = {{9 14} 9}; %[ft]
inp.width_dune  = {10 {12 15}}; %[ft]
inp.width_berm  = {{100 150} {120 130}}; %[ft]
inp.width_berm  = {{100 150} {120 }}; %[ft]
inp.width_upland  = {200 220}; %[ft]
inp.height_upland  = {6 7}; %[ft]
inp.slope_dune  = {.25 .25};
inp.height_berm  = {4 5}; %[ft]
inp.slope_foreshore  = {.2 .2};
inp.d50 = {.30 .34}; % [mm] with length = 1 or number of reaches

