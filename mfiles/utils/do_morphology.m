function g = do_morphology(g)

% sbeach
g=make_sbeach_infiles(g);
g=run_sbeach_all_inputs(g);

% cshore
make_cshore_in(g);
run_cshore_all_inputs(g);

%xbeach
make_xbeach_in(g);
run_xbeach_all_inputs(g);
