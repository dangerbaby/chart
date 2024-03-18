function g = make_tides(tides_input_file,g)
if ~g.iclean;return;end
eval(tides_input_file) % returns with tides
g.tides = tides;


