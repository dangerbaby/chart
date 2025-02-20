function [g]=addstructure(g)
if ~isfield(g,'struct');return;end
disp('Adding structure')

[j1 j2] = min(abs(g.x-g.struct.crest_x));
x = abs(g.x-g.struct.crest_x);
h = g.struct.crest_elev + .5*g.struct.crest_width*g.struct.side_slope;
zb = h-g.struct.side_slope*x;
zb = min(zb,g.struct.crest_elev);

g.struct.crest_ind = j2;
g.struct.inds = find(zb>g.zb);
g.zb = max(zb,g.zb);

