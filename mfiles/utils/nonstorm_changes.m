function zbf = nonstorm_changes(in);
%function zbf = nonstorm_changes(in);
% NOTE: function uses positive ofshore convention for all arrays of bottom position.
% in = nonstorm changes params structure
% in.zbi = initial profile with constant dx
%
% in.recover = 1,0 binary flag to include, exclude cross-shore recovery
% in.zbe  = ebuilibrium profile on the zbi x grid
% in.z_berm = elevation delineating berm( which can recover) from dune ( which can not recover)
% in.T90 = single time to reach 90% recovered [days]
% in.T_recover = time for predicted zbf [days] ( time to next storm)
%
% in.ilongshoregrad = 1,0 binary flag to include, exclude shifting of profile from longshore gradients
% 
% zbf =  final profile
dz = zeros(size(in.zbi));
if isfield(in,'irecover')
  if in.irecover
    if in.ilongshoregrad
      zbe =   beach_translate(in.zbe,in.z_berm,in.dXdt,in.T_recover_cumulative);
    else
      zbe = in.zbe;
    end

    zbfdum = beach_recover(in.zbi,zbe,in.z_berm,in.T90,in.T_recover);
    %[zbe;zbfdum]
    %error
    dz = dz+(zbfdum-in.zbi);
  end
end

if isfield(in,'ilongshoregrad')
  if in.ilongshoregrad
    zbfdum = beach_translate(in.zbi,in.z_berm,in.dXdt,in.T_recover);
  dz = dz+(zbfdum-in.zbi);
  end
end

%Emergency nourishment here?

zbf = in.zbi+dz;
%z = [in.zbi;in.zbe;zbf]
%error('stop')
  