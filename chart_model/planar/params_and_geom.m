function [p,g,s] = params_and_geom(p)

p.plot.ividsave = 1;
p.plot.vidsavename = 'progressive_degradation_with_hardbottom';
p.plot.plotu = 0;
p.plot.plotsed = 0;
p.dx =  1;
p.Cn = .2;
p.ftime = 2100;
p.jumpplot = 40;
p.jumpsave = 1;
p.smooth_num = .1;
p.jumpsmooth = Inf;
%p.delta_s=.01;
p.H = 1*0.4;
p.T = 600;
p.eta_0 = 0; % initial waver level
p.wave.Hrms =0*.6;
p.wave.T = 6;
p.wave.gamma = .7;
p.iconvect = 1;
p.w = 2*pi/p.T;
p.iboundary_0 = 2;% force boundary with incident wave free surface time series
                  
%p.iboundary_0 = 3;% force boundary with arbitary free surface and q
%p.iboundary_0 = 0;% no flux ( reflective boundary)
p.iboundary_l = 0;% no flux ( reflective boundary)
p.iboundary_l = 1;% allow flow out
p.cf = 5*.02;
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
%zbl = -1.5;
m = (zbl-zb0)/(max(x)-min(x));
zb = zb0+1*m*(x-min(x));
%zb = zb+.2*exp(-(x-(mean(x)-.3*L)).^2/10^2);
%zb = zb+.5*exp(-(x-(mean(x)-.3*L)).^2/10^2);
zb = zb+.4*exp(-(x-(mean(x)+.2*L)).^2/8^2);
zb = zb-.4*exp(-(x-(mean(x)+.6*L)).^2/25^2);
dzbdx = [(zb(2)-zb(1))/p.dx (zb(3:end)-zb(1:end-2))/(2*p.dx) (zb(end)-zb(end-1))/p.dx];
g.dx = p.dx;
g.x=x;
g.zb=zb;
g.zb_hb = g.zb-.05;
g.dzbdx=dzbdx;

% set initial water level
p.eta_init = 0*.3*exp(-(g.x-mean(g.x)).^2/5^2); % initial eta
                                                
%set left boundary timeseries
p.eta_0 = [0 .4 0 0 ];
p.eta_0_time = [0 .3*p.ftime .6*p.ftime 1.1*p.ftime];

% set sed params
s.ised =  2; % 0=no transport, 1 = equilibrium, 2 = nonequilib
s.d_50 = .2;         % [mm]
s.sg   = 2.65;          % spec grav
s.tanphi = .5;         % tangent of sediment friction angle
s.poro  = 0.4;        % sediment porosity                        
s.bl  = 30;           % empiric bedload param  
s.waveskewparam = .0;  % include wave skew i.e. crests larger in mag than troughs 0 - 1;
s.smooth_num = 1; % 0-1 
s.wf = vfall(s.d_50,20,0);%fall vel of sed in m/s
s.cf= .01; %coeff of skin friction 
s.iboundary_0=0; % no sed conc entering from left boundary
s.iboundary_0=1; % equilib sed conc entering from left boundary

