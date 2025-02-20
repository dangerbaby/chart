function [s]=init_sed(s,p)
if s.ised==0;return;end

s.nu = .00000136;
d2 = s.d_50/1000;

%-----Soulsby Critical Shields Number---------------------------------
dst = (d2)*(p.g*(s.sg-1)/s.nu^2)^(1/3);
s.psicr = 0.3./(1+1.2*dst) + 0.055*(1-exp(-.02*dst));
s.taucr=p.rho*(s.sg-1.0)*p.g*d2.*s.psicr;


%some defaults
if ~isfield(s,'iundertow');s.iundertow = 1;end
if ~isfield(s,'islopeeffect');s.islopeeffect = 1;end


