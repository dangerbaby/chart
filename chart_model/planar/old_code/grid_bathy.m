function [g]=grid_bathy(p)

dx = p.dx;
%Lx = 20;x_walls = 0:dx:Lx;
x = -60:dx:0;
%x_walls = -500:dx:0;
%x_cent = .5*(x_walls(1:end-1)+x_walls(2:end));
%zb_off = -.5;zb_on = .1;flat_length = 0
%m = 1*(zb_on-zb_off)/(Lx-flat_length); %slope
%zb_walls = zb_off+m*(x_walls-flat_length)+ ...
%    -0*m*(x_walls-Lx/2).*((x_walls-Lx/2)>0);
%   1*.0*exp(-.06*(x_walls-.4*Lx).^2)+1*.0*exp(-.5*(x_walls-.95*Lx).^2);

zb0 = .5;
zbl = -1.05;
zb0 = -1.05;
zbl = .5;
m = (zbl-zb0)/(max(x)-min(x));
zb = zb0+1*m*(x-min(x));
%zb_walls = zb_walls+ .5*exp(-(x_walls+30).^2/10^2);
%zb_walls = -2 + .7*exp((mean(x_walls)-x_walls).^2/25^2);
%zb_walls = -2 + 0*exp((mean(x_walls)-x_walls).^2/25^2);
%zb_walls = -.8+9e-8*(x_walls-min(x_walls)).^3;

%zb_walls(find(x_walls<=flat_length))=zb_off;
%zb_cent = .5*(zb_walls(2:end)+zb_walls(1:end-1));


dzbdx = [0 zb(3:end)-zb(1:end-2) 0]./(2*dx);

g.dx = dx;
g.x=x;
%geom.x_walls=x_walls;
%geom.zb_cent=zb_cent;
g.zb=zb;
g.dzbdx=dzbdx;
%geom.dzbdx_walls=dzbdx_walls;

