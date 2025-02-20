function [g]=init_grid(g,p)

if max(abs(((g.x(2:end)-g.x(1:end-1))-p.dx)))>.001
  disp(['Interpolating bathy data'])
  x = g.x(1):p.dx:g.x(end);
  g.zb = interp1(g.x,g.zb,x);
  g.x = x;
end

g = addstructure(g);             %add structure to g, if present
knk = (g.zb(3:end)-2*g.zb(2:end-1)+g.zb(1:end-2))/p.dx^2;
%disp(['Max, Min knk in initial profile = ',num2str([max(knk) min(knk)])])
cnt=0;
while(max(abs(knk))>p.maxconcav)
  cnt = cnt+1;
  zb0 = g.zb(1)-(g.zb(2)-g.zb(1));
  zbl = g.zb(end)+(g.zb(end)-g.zb(end-1));
  g.zb = (1/3)*([zb0 g.zb(1:end-1)]+[g.zb(1:end)]+[g.zb(2:end) zbl]);
  knk = (g.zb(3:end)-2*g.zb(2:end-1)+g.zb(1:end-2))/p.dx^2;
  %disp(['New Max, Min knk in initial profile = ',num2str([max(knk) min(knk)])])
  if isfield(g,'struct');
  if cnt==1;disp('Preserving structure crest elevation while smoothing');end
  delta =   g.struct.crest_elev-g.zb(g.struct.crest_ind);
  g.zb = g.zb+delta*exp(-(g.x-g.x(g.struct.crest_ind)).^2/g.struct.crest_width^2);
  end
end
%  g.zb(x>g.struct.crest_x)=g.struct.crest_elev;

g.dzbdx = [(g.zb(2)-g.zb(1))/p.dx (g.zb(3:end)-g.zb(1:end-2))/(2*p.dx) (g.zb(end)-g.zb(end-1))/p.dx];
g.zb_init = g.zb;
















