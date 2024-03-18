function out =  load_results_sbeach(fn)

fid = fopen([fn,'.PRC']);
tot = textscan(fid,'%s','delimiter','\n');
tot = tot{:};
tot = cellfun(@(x) [x ' '],tot,'UniformOutput',false);
fclose(fid);

dum = strfind(tot,'NUMBER OF GRID CELLS');
row_ind = find(~cellfun('isempty',dum));
dum = tot{row_ind};
out.N = str2num(dum(findstr(dum,':')+1:end));
%out.N

dum = strfind(tot,'POSITION OF GRID CELLS RELATIVE TO INITIAL PROFILE');
row_ind = find(~cellfun('isempty',dum))+1;
out.x=str2num([tot{row_ind:row_ind+floor((out.N-1)/10)}]);
%out.x([1 end])


dum = strfind(tot,'INITIAL PROFILE ELEVATION');
row_ind = find(~cellfun('isempty',dum))+1;
out.zbi=str2num([tot{row_ind:row_ind+floor((out.N-1)/10)}]);
%out.zbi([1 end])

dum = strfind(tot,'FINAL PROFILE ELEVATION');
row_ind = find(~cellfun('isempty',dum))+1;
out.zbf=str2num([tot{row_ind:row_ind+floor((out.N-1)/10)}]);

dum = strfind(tot,'MAXIMUM CALCULATED ELEVATION');
row_ind = find(~cellfun('isempty',dum))+1;
out.zbmax=str2num([tot{row_ind:row_ind+floor((out.N-1)/10)}]);

dum = strfind(tot,'MINIMUM CALCULATED ELEVATION');
row_ind = find(~cellfun('isempty',dum))+1;
out.zbmin=str2num([tot{row_ind:row_ind+floor((out.N-1)/10)}]);


fid = fopen([fn,'.XVR']);
tot = textscan(fid,'%s','delimiter','\n');
tot = tot{:};
tot = cellfun(@(x) [x ' '],tot,'UniformOutput',false);
fclose(fid);

dum = strfind(tot,'MAXIMUM CALCULATED WAVE HEIGHT');
row_indi = find(~cellfun('isempty',dum))+3;
dum = strfind(tot,'CORRESPONDING TIME STEPS');
row_indf = find(~cellfun('isempty',dum));
row_indf = min(row_indf(row_indf>row_indi))-1;
out.Hsmax=str2num([tot{row_indi:row_indf}]);
out.Hsmax= [nan(1,out.N-length(out.Hsmax)) out.Hsmax];
 
dum = strfind(tot,'MAXIMUM CALCULATED TOTAL WATER ELEVATION');
row_indi = find(~cellfun('isempty',dum))+3;
dum = strfind(tot,'CORRESPONDING TIME STEPS');
row_indf = find(~cellfun('isempty',dum));
row_indf = min(row_indf(row_indf>row_indi));
out.etamax=str2num([tot{row_indi:row_indf-1}]);
out.etamax= [nan(1,out.N-length(out.etamax)) out.etamax];
