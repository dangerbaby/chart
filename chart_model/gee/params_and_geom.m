function [p,g,s] = params_and_geom(p)
in=load_infile;
g.in = in;
p.plot.ividsave = 0;
p.plot.vidsavename = 'GEE';
p.plot.plotu = 0;
p.plot.plotsed = 0;
p.dx =  1;
p.Cn = .8;
p.eddyvisc = .1;
p.iconvect = 1;
p.ftime = .1*max(in.timebc_wave);
p.jumpplot = 1000;
p.isave = 1;
p.jumpsave = 100;
p.smooth_num = .3;
%p.jumpsmooth = Inf;
%p.H = 1*0.5;
%p.T = 1*1000;
%p.w = 2*pi/p.T;
p.eta_0 = in.swlbc(1); % initial waver level

%waves
p.wave.time = in.timebc_wave;
p.wave.Hrms = 1*in.Hrms;
p.wave.T = in.Tp;
p.wave.gamma = .6;

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
load ./gee/data/x.dat
load ./gee/data/zb.dat
g.x = x(:,1)';
g.zb = zb(:,1)';



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
s.smooth_num = .5; % 0-.5 
s.wf = vfall(s.d_50,20,0);%fall vel of sed in m/s
s.cf= .01; %coeff of skin friction 
s.iboundary_0=0; % no sed conc entering from left boundary
s.iboundary_0=1; % equilib sed conc entering from left boundary
s.iundertow = 1; %include undertow
s.islopeeffect = 1; %include undertow
