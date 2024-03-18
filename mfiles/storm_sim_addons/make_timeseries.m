function brad_forcing = make_timeseries(config,project_forcing)


disp(['Number of time-series = ',num2str((config.mcs_nLC))])
disp(['Each of = ',num2str(config.mcs_nYears),' years'])

%for i = 1:1
for i = 1:length(project_forcing.CC.Timeseries)
  brad_forcing(i).summary = project_forcing.CC.Timeseries(i).LCNUM;
  stormnum = (project_forcing.CC.Timeseries(i).LCNUM(:,1));
  yr = (project_forcing.CC.Timeseries(i).LCNUM(:,10));
  unittime = 4; %day
  numinterval = floor(365/unittime);
  unittime = 365/numinterval;
  t = [];Hmo = [];wl = [];Tp=[];dir = [];
  for j = 1:config.mcs_nYears
    
    ind0yr = find(project_forcing.CC.Timeseries(i).LCNUM(:,10)==j&(project_forcing.CC.Timeseries(i).LCNUM(:,3)==0));
    ind0nextyr = [find(project_forcing.CC.Timeseries(i).LCNUM(:,10)>j&(project_forcing.CC.Timeseries(i).LCNUM(:,3)==0));length(yr)+1];
    ind0yr = [ind0yr;ind0nextyr(1)];
    storms = stormnum(ind0yr(1:end-1));
    numstorms = length(storms);
    rate= (numstorms/numinterval); %storms/interval
    isstorm = random('Binomial',1,rate,1,numinterval);
    while sum(isstorm)~=numstorms
        isstorm = random('Binomial',1,rate,1,numinterval);
    end
    for k = 1:numinterval
      if isstorm(k);
        %ind = find(storms(sum(isstorm(1:k)))==project_forcing.CC.Timeseries(i).LCNUM(:,1)&yr==j);
        indstart = find(storms(sum(isstorm(1:k)))==project_forcing.CC.Timeseries(i).LCNUM(:,1)&yr==j&...
                      project_forcing.CC.Timeseries(i).LCNUM(:,3)==0);
        indstart = indstart(1);
        indend = ind0yr(find(indstart==ind0yr)+1)-1;indend=indend(1);
        ind = indstart:indend;
        t = [t (j-1)*365+(k-1)*unittime+project_forcing.CC.Timeseries(i).LCNUM(ind,3)'/24];   
        Hmo = [Hmo project_forcing.CC.Timeseries(i).LCNUM(ind,6)'];Hmo(end) = NaN;   
        wl = [wl project_forcing.CC.Timeseries(i).LCNUM(ind,5)'];Hmo(end) = NaN;   
        Tp = [Tp project_forcing.CC.Timeseries(i).LCNUM(ind,7)'];Hmo(end) = NaN;   
        dir = [dir project_forcing.CC.Timeseries(i).LCNUM(ind,8)'];Hmo(end) = NaN;   
      else
        t = [t (j-1)*365+[(k-1) k-1e-9]*unittime];
        Hmo = [Hmo NaN NaN];
        wl = [wl NaN NaN];
        Tp = [Tp NaN NaN];
        dir = [dir NaN NaN];
      end
      
    end
    disp(['Year ',num2str(j),' calls for ',num2str(numstorms),' storms, and ',num2str(sum(isstorm)),' are distributed.'])
  end
  if max((t(2:end)-t(1:end-1))<0);error('t is not monontonically increasing');end
  brad_forcing(i).t = t;  brad_forcing(i).Hmo = Hmo;  brad_forcing(i).Tp = Tp;  brad_forcing(i).wl = wl;  brad_forcing(i).dir=dir;
end

return

dum = 2;
figure(1);clf
plot(t,Hmo)
xlim([dum-1 dum]* 365)
figure(2);clf
ind = find(yr==dum);
plot(project_forcing.CC.Timeseries(i).LCNUM(ind,6))