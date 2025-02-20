function [p,g,s] = params_and_geom(p)


in=load_infile;
g.in = in;
p.plot.ividsave = 0;
p.plot.vidsavename = 'Rehoboth';
p.plot.plotu = 0;
p.plot.plotsed = 0;
p.dx =  2;
p.Cn = .8;
p.eddyvisc = 1;
p.iconvect = 1;
p.ftime = .1*max(in.timebc_wave);
p.jumpplot = 500;
p.jumpsave = Inf;
p.smooth_num = .9;
p.jumpsmooth = Inf;
%p.H = 1*0.5;
%p.T = 1*1000;
%p.w = 2*pi/p.T;
p.eta_0 = in.swlbc(1); % initial waver level

%waves
p.wave.time = in.timebc_wave;
p.wave.Hrms = 2*in.Hrms;
p.wave.T = in.Tp;
p.wave.gamma = .7;

p.iboundary_0 = 3;% force boundary with arbitary free surface, q is computed to satisfy continuity
p.iboundary_l = 0;% no flux ( reflective boundary)

p.cf = 1*.02;
p.cf_wind = 0.001;
p.wind_vel = 0*50;
p.g = 9.81;
p.rho = 1000;
p.rho_air=1E-3;

%geometry
g.x = in.x;
g.zb = in.zb;

% set initial water level
p.eta_init = in.swlbc(1); % initial eta
                                                
%set left boundary timeseries
p.eta_0_time = in.timebc_wave;
p.eta_0 = in.swlbc;

% set sed params
s.ised =  1; % 0=no transport, 1 = equilibrium, 2 = nonequilib
s.d_50 = in.d50;         % [mm]
s.sg   = 2.65;          % spec grav
s.tanphi = .5;         % tangent of sediment friction angle
s.poro  = 0.4;        % sediment porosity                        
s.bl  = 1;           % empiric bedload param  
s.waveskewparam = .0;  % include wave skew i.e. crests larger in mag than troughs 0 - 1;
s.smooth_num = 1; % 0-1 
s.wf = vfall(s.d_50,20,0);%fall vel of sed in m/s
s.cf= .01; %coeff of skin friction 
s.iboundary_0=0; % no sed conc entering from left boundary
s.iboundary_0=1; % equilib sed conc entering from left boundary

