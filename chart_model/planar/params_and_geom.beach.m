function [p,g,s] = params_and_geom(p)

p.plot.ividsave = 0;
p.plot.vidsavename = 'overwash';
p.plot.plotu = 1;
p.plot.plotsed = 1;
p.dx =  1;
p.Cn = .2;
p.ftime = 1000;
p.jumpplot = 200;
p.jumpsave = 1;
p.smooth_num = .1;
p.jumpsmooth = Inf;
%p.delta_s=.01;
p.H = 0*0.2;
p.T = 500;
p.eta_0 = 0; % initial waver level
p.wave.Hrms =1*.6;
p.wave.T = 6;
p.wave.gamma = .7;
p.iconvect = 1;
p.w = 2*pi/p.T;
p.iboundary_0 = 2;% force boundary with incident wave free surface time series
                  
%p.iboundary_0 = 3;% force boundary with arbitary free surface and q
%p.iboundary_0 = 0;% no flux ( reflective boundary)
p.iboundary_l = 0;% no flux ( reflective boundary)
%p.iboundary_l = 1;% allow flow out
p.cf = 1*.02;
p.cf_wind = 0.001;
p.wind_vel = 0*50;
p.g = 9.81;
p.rho = 1000;
p.rho_air=1E-3;

%geometry
L = 150;
x = -L:p.dx:0;
zb0 = -1.5;
zbl = .4;
m = (zbl-zb0)/(max(x)-min(x));
zb = zb0+1*m*(x-min(x));
zb = zb+.5*exp(-(x-(mean(x)-.2*L)).^2/15^2);
%zb = zb-.2*exp(-(x-(mean(x)+.3*L)).^2/8^2);
%zb = zb-.3*exp(-(x-(mean(x)+.5*L)).^2/12^2);
dzbdx = [(zb(2)-zb(1))/p.dx (zb(3:end)-zb(1:end-2))/(2*p.dx) (zb(end)-zb(end-1))/p.dx];
g.dx = p.dx;
g.x=x;
g.zb=zb;
g.dzbdx=dzbdx;

% set initial water level
p.eta_init = 0*.3*exp(-(g.x-mean(g.x)).^2/5^2); % initial eta
                                                
%set left boundary timeseries
p.eta_0 = [0 .4 0 0 ];
p.eta_0_time = [0 .3*p.ftime .6*p.ftime 1.1*p.ftime];

% set sed params
s.ised = 1;
s.d_50 = .2;         % [mm]
s.sg = 2.65;          % spec grav
s.tanphi = .5;         % tangent of sediment friction angle
s.poro  = 0.4;        % sediment porosity                        
s.bl  = 1;           % empiric bedload param  
s.waveskewparam = .0;  % include wave skew i.e. crests larger in mag than troughs 0 - 1;
s.smooth_num = 1;


