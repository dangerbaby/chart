function zbf = beach_translate(zbi,z_berm,dXdt,T);
%function zbf = beach_translate(zbi,z_berm,dXdt,T);
% zbi = initial array of zb (pre-translate)[m]
% z_berm = elevation delineating berm(below which can translate) from dune ( which can not translate)[m]
% dXdt = rate of shoreline change [m/day]
% T = time interval for change [days]
if(isnan(T));zbf=zbi;return;end
dX = dXdt*T;
x = 0:length(zbi)-1;
zbdum = interp1(x+dX,zbi,x);
wt = zbi<=z_berm-sign(dX)*.1;
zbf = (1-wt).*zbi+wt.*zbdum;
indbad = isnan(zbf);
zbf(indbad) = zbi(indbad);