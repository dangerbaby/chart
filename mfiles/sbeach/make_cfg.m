function make_cfg(in,g)
fid = fopen(['general.CFG'],'r');
tot = textscan(fid,'%s','headerlines',0,'delimiter','\n');
tot = tot{:};
fclose(fid);
%swap stuff

%     fill_title
dum = strfind(tot,'fill_title');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',in.name]);
%     fill_ndx       fill_xstart
dum = strfind(tot,'fill_ndx');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(length(in.x)),'  ',num2str(in.x(1))]);
%fill_dxc
dum = strfind(tot,'fill_dxc');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(in.dx)]);
%     fill_ndt       fill_dt
dum = strfind(tot,'fill_ndt');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(length(in.timebc_wave)),'  ',num2str(in.dt/60)]);
%     fill_dtwav
dum = strfind(tot,'fill_dtwav');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(in.dt/60)]);
% fill_dmeas
dum = strfind(tot,'fill_dmeas');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(-in.zb(end))]);
%     fill_dtelv
dum = strfind(tot,'fill_dtelv');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(in.dt/60)]);
%     fill_d50
dum = strfind(tot,'fill_d50');
row_ind = find(~cellfun('isempty',dum));
tot(row_ind) = cellstr(['  ',num2str(in.d50)]);



fid = fopen([g.name,'/work/infiles/',in.dirname,'/',in.name '.CFG'],'w');
fprintf(fid,'%s\n',tot{:});
fclose(fid);



