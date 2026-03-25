
%START user model inputs
mm.modelname = {}; 
mm.modelname = {'sbeach'}; 
%mm.modelname = {'cshore'}; 
%mm.modelname = {'cshore sbeach'}; 
%mm.modelname = {'xbeach'}; 
%
mm.dx = 1; % [m] default 1
mm.gamma = .7; % default .7
mm.tanphi = .63;
mm.fw = .015;
mm.cshore.effb = .002;
mm.cshore.efff = .004;
mm.cshore.slp = .5;
mm.cshore.slpot = .2;
mm.cshore.blp = .001;
mm.cshore.rwh = .1;
mm.sbeach.K = .1*1.75e-6;
mm.irecover = 1;
mm.ilongshoregrad = 1;
mm.T90 = 20; %day
mm.dXdt = .005;%m/day, pos for accretion


