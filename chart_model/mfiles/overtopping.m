function [g,h]=overtopping(g,h,p)
if ~isfield(g,'struct');return;end
if ~isfield(h,'wave');return;end
if h.wave.Hrms(1)<.1;return;end
if g.struct.iover==0;return;end
%

if h.time_step==1;
 disp('Init overtopping')

end

toe_h = h.h(g.struct.inds(1));
toe_eta = h.eta(g.struct.inds(1));
toe_Hmo = sqrt(2)*h.wave.Hrms(g.struct.inds(1));
Rc = max(0,g.struct.crest_elev-toe_eta);
gam = 0.5;

q = 1*(h.eta(g.struct.inds(end))<(g.struct.crest_elev-.01))*sqrt(p.g*toe_Hmo^3)*.06*exp(-1.5*Rc/(gam*toe_Hmo));
idoner = find(g.x>=g.x(g.struct.inds(1))&g.x<g.struct.crest_x&h.h>.01);
ireceive = g.struct.inds(end):g.struct.inds(end)+1;
h.h(idoner) = h.h(idoner)-p.dt*q/(p.dx*length(idoner));
h.h(ireceive) = h.h(ireceive)+p.dt*q/(p.dx*length(ireceive));
