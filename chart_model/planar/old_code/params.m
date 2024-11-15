function p = params(p)

p.ividsave = 0;
p.dx =  1;
p.Cn = .5;
p.ftime = 150;
p.jumpplot = 1;
p.jumpsave = 100000;
p.smooth_num = .1;
p.jumpsmooth = Inf;
%p.delta_s=.01;
p.H = 0*0.3;
p.T = 200;
p.eta_0 = 0; % initial waver level
p.wave.Hrms = 1*.6;
p.wave.T = 8;
p.wave.gamma = .7;
p.iconvect = 1;
p.w = 2*pi/p.T;
p.iboundary = 2;% force boundary with incident wave free surface time series
p.cf = 0.01;
p.cf_wind = 0.001;
p.wind_vel = 0*50;
                   
%p.iboundary = 0;% no flux ( reflective boundary)

p.g = 9.81;
p.rho = 1000;
p.rho_air=1E-3;

