function [p,g,s] = params_and_geom(p)

p.plot.ividsave = 0;
p.plot.vidsavename = 'progressive_degradation_waves_without_hardbottom';
p.plot.vidsavename = 'river_without_hardbottom';
p.plot.vidsavename = 'forcing_from_sea_or_bay';
p.plot.vidsavename = 'seawall_without_overtop';
p.plot.vidsavename = 'steep_structure1';
%p.plot.vidsavename = 'waves_on_dune';
p.plot.vidsavename = 'waves_on_dune';
p.plot.plotu = 0;
p.plot.plotsed = 1;
p.dx =  1;
p.Cn = .8;
p.eddyvisc = .0;
p.iconvect = 1;
p.ftime = 120;
p.jumpplot = 3;
p.isave = 0;
p.jumpsave = Inf;
p.smooth_num = .3; % typ 0-0.4 
                    
%p.jumpsmooth = Inf;
p.H = .4;
p.T = 300;
p.w = 2*pi/p.T;
p.eta_0 = 0; % initial waver level
p.maxconcav = 100.05;  % typ .1
%waves
p.wave.time = 0:10:p.ftime+10;
p.wave.Hrms = 1*1*ones(size(p.wave.time))+.0*exp(-(p.wave.time-mean(p.wave.time)).^2/(.5*p.ftime)^2);
p.wave.T = 8*ones(size(p.wave.time));
p.wave.gamma = .6;

p.iboundary_0 = 0;% no flux ( reflective boundary)
p.iboundary_0 = 2;% force boundary with incident wave free surface time series

%p.iboundary_0 = 3;% force boundary with arbitary free surface, q is computed to satisfy continuity

p.iboundary_l = 0;% no flux ( reflective boundary)

%p.iboundary_l = 1;% leaky boundary
%p.iboundary_l = 2;% 
%p.iboundary_l = 3;% force boundary with arbitrary free surface, q is computed to satisfy continuity

p.cf = 0*.02;
p.cf_wind = 0.001;
p.wind_vel = 0*50;
p.g = 9.81;
p.rho = 1000;
p.rho_air=1E-3;

%geometry
L = 100;
x = 0:p.dx:L;
zb0 = -2.5;
zbl = 1.5;
flatlength = 40;
%zbl = -1.5;
%zbl = -.8;
m = (zbl-zb0)/(max(x)-min(x)-flatlength);
zb0p = zb0-m*flatlength;
zb = zb0p+1*m*(x-min(x));
zb(x<=(x(1)+flatlength))=zb0;
%zb = zb+.5*exp(-(x-(mean(x)-.3*L)).^2/40^2);
%zb = zb+1.3*exp(-(x-(mean(x)-.0*L)).^2/100^2);
%zb = zb+.5*exp(-(x-(mean(x)-.3*L)).^2/10^2);
zb = zb+1.5*exp(-(x-(mean(x)+.1*L)).^2/10^2);
%zb = zb+1.5*exp(-(x-(mean(x)+.0*L)).^2/5^2);
dzbdx = [(zb(2)-zb(1))/p.dx (zb(3:end)-zb(1:end-2))/(2*p.dx) (zb(end)-zb(end-1))/p.dx];
g.dx = p.dx;
g.x=x;
g.zb=zb;
%g.zb_hb = g.zb-.15; 
%g.zb_hb(abs(x-(mean(x)+.2*L))>4) = g.zb_hb(abs(x-(mean(x)+.2*L))>4) -.2;
%g.zb_hb=window(g.zb_hb,7);

if 0
  g.struct.crest_x = mean(x)+.2*L; %inform model of x pos used to calculate wave overtopping vol 
  g.struct.crest_elev = .25;       %add structure geom 
  g.struct.crest_width = 2;        %add structure geom 
  g.struct.side_slope = 1/1;       %add structure geom 
  g.struct.iover = 1;              %include eurotop overtop volume
end
dzbdx = [(g.zb(2)-g.zb(1))/p.dx (g.zb(3:end)-g.zb(1:end-2))/(2*p.dx) (g.zb(end)-g.zb(end-1))/p.dx];
g.dzbdx=dzbdx;

% set initial water level
p.eta_init = 0*.3*exp(-(g.x-mean(g.x)).^2/5^2); % initial eta
                                                
%set left boundary timeseries
p.eta_0 = [0 .4 0 0 ];
p.eta_0_time = [0 .3*p.ftime .6*p.ftime 1.1*p.ftime];
p.eta_0_time = 0:10:p.ftime+10;
p.eta_0 = .5*p.H*sin(2*pi/p.T*p.eta_0_time).*min(p.eta_0_time/1000,1); 
p.eta_l_time = 0:10:p.ftime+10;
p.eta_l = .5*p.H*sin(2*pi/p.T*p.eta_0_time-.1*2*pi).*min(p.eta_0_time/1000,1); 

% set sed params
s.ised =  1; % 0=no transport, 1 = equilibrium, 2 = nonequilib
s.d_50 = .2;         % [mm]
s.sg   = 2.65;          % spec grav
s.tanphi = .5;         % tangent of sediment friction angle
s.poro  = 0.4;        % sediment porosity                        
s.bl  = 1;           % empiric bedload param  
s.waveskewparam = .5;  % include wave skew i.e. crests larger in mag than troughs 0 - 1;
s.smooth_num = .1; % 0-1 
s.wf = vfall(s.d_50,20,0);%fall vel of sed in m/s
s.cf= .01; %coeff of skin friction 
s.iboundary_0=0; % no sed conc entering from left boundary
s.iboundary_0=1; % equilib sed conc entering from left boundary

