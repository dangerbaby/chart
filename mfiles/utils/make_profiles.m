function reaches = make_profiles(reaches,name)
%first add in the submerged part
%works with txt file named 'whatever_submerged_profile.txt' in the work directory positive going offshore 
% and in ft

for i = 1:length(reaches)
  fn = ['./',name,'/work/',reaches(i).dirname,'_submerged_profile.txt'];
  fid=fopen(fn,'r') ;
  if fid<0
    error(['Can not locate the submerged profile file: ',fn])
  end
  tot = textscan(fid,'%f%f');
  fclose(fid);
  x_sub  = tot{1};
  z_sub  = tot{2};
  for j = 1:length(reaches(i).height_dune)
    x = [0 reaches(i).width_upland(j)];
    z = [reaches(i).height_upland(j) reaches(i).height_upland(j)];
    x = [x x(end)+(reaches(i).height_dune(j)-reaches(i).height_upland(j))/reaches(i).slope_dune(j)];
    z = [z reaches(i).height_dune(j)];
    x = [x x(end)+reaches(i).width_dune(j)];
    z = [z reaches(i).height_dune(j)];
    x = [x x(end)+(reaches(i).height_dune(j)-reaches(i).height_berm(j))/reaches(i).slope_dune(j)];
    z = [z reaches(i).height_berm(j)];
    x = [x x(end)+reaches(i).width_berm(j)];
    z = [z reaches(i).height_berm(j)];
    x = [x x(end)+(reaches(i).height_berm(j)-z_sub(1))/reaches(i).slope_foreshore(j)];
    z = [z z_sub(1)];
    x_sub2 = x_sub+x(end);

    reaches(i).profile(j).x_ft = [x x_sub2'];
    reaches(i).profile(j).z_ft = [z z_sub'];
    reaches(i).profile(j).height_berm_ft=reaches(i).height_berm(j);
    reaches(i).profile(j).z_equilib_ft =reaches(i).profile(j).z_ft;
  end

  % construct min profile
  x = [0 reaches(i).min_width_upland];
  z = [reaches(i).min_height_upland  reaches(i).min_height_upland ];
  x = [x x(end)+(reaches(i).min_height_dune -reaches(i).min_height_upland )/reaches(i).min_slope_dune ];
  z = [z reaches(i).min_height_dune ];
  x = [x x(end)+reaches(i).min_width_dune ];
  z = [z reaches(i).min_height_dune ];
  x = [x x(end)+(reaches(i).min_height_dune -reaches(i).min_height_berm )/reaches(i).min_slope_dune ];
  z = [z reaches(i).min_height_berm ];
  x = [x x(end)+reaches(i).min_width_berm ];
  z = [z reaches(i).min_height_berm ];
  x = [x x(end)+(reaches(i).min_height_berm -z_sub(1))/reaches(i).min_slope_foreshore ];
  z = [z z_sub(1)];
  x_sub2 = x_sub+x(end);
  for j = 1:length(reaches(i).height_dune)
    reaches(i).profile(j).min_x_ft = [x x_sub2'];
    reaches(i).profile(j).min_z_ft = [z z_sub'];
  end  
  
  

end

