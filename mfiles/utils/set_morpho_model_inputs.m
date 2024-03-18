function g = set_morpho_model_inputs(input_file,g)

eval(input_file) % returns with tides
                 %g.tides = tides;
g.mm = mm;

