function zbf = beach_recover(zbi,zbe,z_berm,T90,T);
%function zbf = beach_recover(zbi,zbe,T90,T);
% zbi = initial array of zb ( pre-recovery)
% zbe = equilib array of bottom position
% z_berm = elevation delineating berm( which can recover) from dune ( which can not recover)
% T90 = single time to reach 90% recovered [days]
% T = time for predicted zbf [days]
T90 = T90*24*3600;
T = T*24*3600;
k = -log(.1)/(T90);
indchange=find(zbe<=z_berm);
zbf = zbi;
zbf2 = zbe+(zbi-zbe)*exp(-k*T);
zbf(indchange) = zbf2(indchange);