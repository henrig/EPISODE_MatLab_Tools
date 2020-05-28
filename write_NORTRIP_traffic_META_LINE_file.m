function [] = write_NORTRIP_traffic_META_LINE_file(fname,lines,episode_id,makeADTcut,adt_lim,col)
% NORTRIP FILE SHOULD CONTAIN: 
% * RoadLinkID	X1            X2            Y1               Y2            Z1      Z2       Width        MaxInfluenceDist  CalcIndices  lon   lat	length	n_lanes	road_type adt

adt=extractfield(lines,col)+extractfield(lines,'BF_GODS')+extractfield(lines,'AVGANGER_YD');

if makeADTcut
    % Extract ADT
    ADT=adt;
    I=ADT>adt_lim;
    fprintf(' # Roadlinks: %i \n   ADT LIMIT: %i \n # Roadlinks LINE: %i \n # Roadlinks AREA: %i\n\n',length(ADT), adt_lim,sum(I), sum(~I))  
    % extract the lanes to make line meta data of
    NL=lines(I);
else
    NL=lines;
end

adt=extractfield(NL,col)+extractfield(NL,'BF_GODS')+extractfield(NL,'AVGANGER_YD');


% Calculate the width of the road based on the number of lanes. Assumes a
% fixed roadwdith of 3 meters for now. Ask if RTM can give width in meters instead!
lt=extractfield(NL,'LINKTYPE');
ult=unique(extractfield(NL,'LINKTYPE'));
t=1;
for i=1:length(ult)
    idx=lt==ult(i);
    r_type(idx)=t;
    t=t+1;
end

oID=extractfield(NL,'HP_ID');
for i=1:length(oID)
    if length(oID(i))>8
        a=char(oID(1200));
        ID(i)=str2num(a(end-7:end));
    else
        ID(i)=i;
    end
end


Lan=extractfield(NL,'LANES');
% strange lane formate, needs fixing
b=regexp(Lan,'\d+(\.)?(\d+)?','match');
for i=1:length(b)
    la=max(str2double([b{i}]));
    if isempty(la)
    n_lanes(i)=0;
    else
    n_lanes(i)=la;
    end
end

% Calculate in the same way as done previously 
Lane_width=3; % meter
Width=n_lanes*Lane_width;

for i=1:length(NL)
    [lat(i),lon(i)]=utm2deg((NL(i).X(1)+NL(i).X(end-1))/2,(NL(i).Y(1)+NL(i).Y(end-1))/2,'32 N');
end


r_length=extractfield(NL,'DISTANCE')*1e3; %km to m


% Define the range of influence on the receptor
influence_zone=0.69; % meter


% START WRITING FILE
fid=fopen(fname,'w+');

% HEADER
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* ADT limit_________: %i\n',adt_lim);
fprintf(fid,'* ROADLINKS_________: %i\n',length(lines));
if makeADTcut
fprintf(fid,'* ROADLINKS as line_: %i\n',sum(I));
fprintf(fid,'* ROADLINKS in Area_: %i\n',sum(~I));
else
fprintf(fid,'* ROADLINKS as line_: %i\n',length(lines));
fprintf(fid,'* ROADLINKS in Area_: %i\n',0);        
end
fprintf(fid,'* Linesources_______:\n');
fprintf(fid,'%12u\n',length(NL));

fprintf('%10s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s\n','ID','X1','X2','Y1','Y2','Z1','Z2','WIDTH','RMAXV','INFL_ZONE','LON','LAT','LENGTH','nLANES','RDTYPE','ADT');
fprintf('%12u %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12u %12.3f %12.3f %12.1f %12i %12i %12.1f \n',ID(i),NL(i).X(1),NL(i).X(2),NL(i).Y(1),NL(i).Y(2),0,0,Width(i),influence_zone,0,lon(i),lat(i),r_length(i),n_lanes(i),r_type(i),adt(i));

% Linesource ID's
fprintf(fid,'%10s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s\n','ID','X1','X2','Y1','Y2','Z1','Z2','WIDTH','RMAXV','INFL_ZONE','LON','LAT','LENGTH','nLANES','RDTYPE','ADT');
for i =1:length(NL)
    fprintf(fid,'%12u %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12u %8.3f %8.3f %8.1f %2i %i %8.1f \n',ID(i),NL(i).X(1),NL(i).X(2),NL(i).Y(1),NL(i).Y(2),0,0,Width(i),influence_zone,0,lon(i),lat(i),r_length(i),n_lanes(i),r_type(i),adt(i));
end
fclose(fid);
fprintf('* Wrote file: \n %s \n',fname)




% LsrcEmissionVariableData_EP.txt
% 
% {bd71359f-2dac-4d03-8098-262ee749c6c0}
% * Hour  RoadLinkID    Emission_dir1    Emission_dir2
%    1      44570        1.130134E-008    1.130134E-008
%  
% 
% LsrcEmissionVariableData_traffic.txt
% * Hour    RoadLinkID    Traffic    HDV    Speed  
% 1   44570   2.6  0.0  50.0   
% 
% LsrcStaticData_PM10.txt
% 
% {7fab5109-8fc1-47a4-8926-4e3299d856bf}
% 1187
% * RoadLinkID X1            X2            Y1               Y2            Z1      Z2       Width        MaxInfluenceDist  CalcIndices  
% 44610        611026.00      611001.50      6577844.00      6577838.00      4.90      4.88      10.00      60.82      0       
% 
% LsrcStaticData_traffic.txt
% 11879 
% * RoadLinkID    X1            X2            Y1               Y2            Z1      Z2       Width        MaxInfluenceDist  CalcIndices  lon   lat    length    n_lanes    road_type adt
% 44570        623030.50      623083.60      6576708.00      6576716.00      57.30      61.00      10.00      0.69      0   11.162  59.311  53.9  2  4  500.0   
% 
% 


end

