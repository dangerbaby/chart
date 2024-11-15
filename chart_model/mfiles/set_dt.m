function [p]=set_dt(g,p)

p.dt = ceil(p.Cn*p.dx/sqrt(1*p.g*max(-g.zb))*10000)/10000;

