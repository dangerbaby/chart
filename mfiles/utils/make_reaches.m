function g = make_reaches(reaches_input_file,g)
if ~g.iclean;return;end
%eval([g.name,'/',reaches_input_file]) % returns with inp
eval(reaches_input_file) % returns with inp
reaches=find_all_combos(inp);
reaches = make_profiles(reaches,g.name);
g.reaches = reaches;

