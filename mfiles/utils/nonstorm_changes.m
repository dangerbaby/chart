function zbf = nonstorm_changes(mm,in,zbi);
%function zbf = nonstorm_changes(mm,in,zbi);
% mm = morpho model params structure
% in = morpho model in struct
%
dz = zeros(size(zbi));


if isfield(mm,'irecover')
  if mm.irecover
  zbfdum = beach_recover(zbi,in.zbe,in.height_berm+.1,mm.T90,in.T_recover);
  dz = dz+(zbfdum-zbi);
  end
end

if isfield(mm,'ilongshoregrad')
  if mm.ilongshoregrad
    zbfdum = beach_translate(zbi,in.height_berm,mm.dXdt,in.T_recover);
  dz = dz+(zbfdum-zbi);
  end
end

%Emergency nourishment here?

zbf = zbi+dz;
  