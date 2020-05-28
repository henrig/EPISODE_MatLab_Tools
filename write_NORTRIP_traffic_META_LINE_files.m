function [] = write_NORTRIP_traffic_META_LINE_files(fpath,S,TV,episode_id,ds)
%¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
% Miljodirektoratet Traffic emission model function:
% PROGRAM :: WRITE NORTRIP META FILES  ::
%
% 09.03.2017 -Henrik Grythe
% Kjeller NILU
%¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
% OUTPUT: 
%¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤


% % % Hour              * Simulation Hour * 1 to end simulation?          * % Integer *
% % % Emission_dir1     * Exhaust(?) PM(?) Emission data given in unit    * g/s.m
% % % Emission_dir2     * Exhaust(?) PM(?) Emission data given in unit    * g/s.m
% % % Traffic           * Traffic data (sum both directions) given in unit* veh/hr 
% % % HDV               * Fraction of Heavy Duty Vehicles (direction 2)   * %HDV/hr  ?
% % % adt               * Total adt Light +gods+bus?                      * #/day
% % % RoadLinkID        * Unique(?) ID of that roadlink                   * Integer
% % % Speed             * Free Flow Speed (direction 2) given in unit     * km/hr 
% % % X1                * Starting X pos UTM ??N                          * double
% % % X2                * Ending  X pos UTM ??N                           * double       
% % % Y1                * Starting Y pos UTM ??N                          * double            
% % % Y2                * Ending  Y pos UTM ??N                           * double         
% % % lon               * Lon Lat for the centre of the road link         * degree.decimal(100)?
% % % lat               * Lon Lat for the centre of the road link         * degree.decimal(100)?
% % % Z1                * Starting altitude                               * m    
% % % Z2                * Ending  altitude                                * m 
% % % length            * DISTANCE travelled by cars on road              * m?
% % % n_lanes           * we have that info.                              * # lanes
% % % Width             * base on lanes/type ??                           * m?
% % % road_type         * Road types: 1.EV / 2.FV / 3.RV / 4.KV / 5.T/ 6.Jet  * integer    
% % % 
% % % MaxInfluenceDist  * How is this calculated ??
% % % CalcIndices       * How is this calculated ??


%% Extract the fields needed from the shapefile
LV       = extractfield(S,'LETTE_BILER');
HGV      = extractfield(S,'BF_GODS');
BUS      = extractfield(S,'AVGANGER_YD');
r_length = extractfield(S,'DISTANCE')*1e3; %km to m
Lan      = extractfield(S,'LANES');
lt       = extractfield(S,'LINKTYPE');
lt2      = extractfield(S,'VK');

AnnpmEM  = extractfield(S,'light_PM')+extractfield(S,'heavy_PM')+extractfield(S,'bus_PM');
% Does this need adjusting? check
speed    = extractfield(S,'SPEED');
Width    = extractfield(S,'DEKKEBREDDE');
oID      = extractfield(S,'HP_ID');


%% MAKE NECESSARY CALCULATIONS AND CORRECTIONS
% Create the longitude and latitude center points
for i=1:length(S)
    [lat(i),lon(i)]=utm2deg((S(i).X(1)+S(i).X(end-1))/2,(S(i).Y(1)+S(i).Y(end-1))/2,'32 N');
end

% Get the annual daily traffic
ADT      = LV+HGV+BUS;

% CT = the three categories ==3; % hrs = number of hours 
[CT,hrs] = size(TV);
% scale from which to calculate emissions from 
scale    = 1/3600;

% Calculate the width of the road based on the number of lanes. Assumes a
% fixed roadwdith of 3 meters for now. Ask if RTM can give width in meters instead!
ult=unique(lt);
urt=unique(lt2)
%% Tunnels and Jets needs to be fixed properly! * Road types: 1.EV / 2.FV / 3.RV / 4.KV / 5.T/ 6.Jet
% {0×0 char}    {'E'}    {'F'}    {'K'}    {'P'}    {'R'}
UD=[4,1, 2,        4,      4, 3];
r_type=zeros(size(ADT));
for i=1:length(UD)
% lt2 way:    
    idx=ismember(lt2,char(urt(i)));
    r_type(idx)=UD(i);    
% for i=1:length(ult)    
%  lt1 way:    
%     idx=lt==ult(i);
%     r_type(idx)=ult(i);    
end
lt2(r_type==0)


%% This needs to be fixed properly! * Road types: 1.EV / 2.FV / 3.RV / 4.KV / 5.T/ 6.Jet
for i=1:length(oID)
    ID(i)=i;
end


% strange lane formate, needs a bit of fixing and mixing
b=regexp(Lan,'\d+(\.)?(\d+)?','match');
for i=1:length(b)
    la=max(str2double([b{i}]));
    if isempty(la)
     n_lanes(i)=0;
    else
     n_lanes(i)=la;
    end
end
Lane_width=3; % meter
Width=Lanes*Lane_width;


for i=1:length(S)
    if Width(i)==0
       Width(i)=3.4; 
    end
end

Width2    = extractfield(S,'DEKKEBREDDE');
Width(Width2>0)=Width2;


% Define the range of influence on the receptor
influence_zone=69*ones(length(S),1); % meter
CalcIndices=69*zeros(length(S),1);

%% START WRITING FILE: LsrcStaticData_traffic.txt
fname=strcat(fpath,'LsrcStaticData_traffic.txt');
fid=fopen(fname,'w+');

% HEADER
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* ROADLINKS_________: %i\n',length(S));
fprintf(fid,'* ROADLINKS as line_: %i\n',length(S));
fprintf(fid,'* ROADLINKS in Area_: %i\n',0);        
fprintf(fid,'* Linesources_______:\n');
fprintf(fid,'%12u\n',length(S));
% Linesource ID's
fprintf(fid,'* %10s %12s %12s %12s %12s %12s %12s %12s %12s %12s %8s %8s %8s %8s %8s %8s\n','ID','X1','X2','Y1','Y2','Z1','Z2','WIDTH','RMAXV','INFL_ZONE','LON','LAT','LENGTH','nLANES','RDTYPE','ADT');
for i =1:length(S)
    fprintf(fid,'%12u %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12u %8.3f %8.3f %8.1f %2i %i %8.1f \n',ID(i),S(i).X(1),S(i).X(2),S(i).Y(1),S(i).Y(2),0,0,Width(i),influence_zone(i),CalcIndices(i),lon(i),lat(i),r_length(i),n_lanes(i),r_type(i),ADT(i));
end
fclose(fid);
fprintf('* Wrote file: \n %s \n',fname)


%% % LsrcStaticData_PM10.txt
fname=strcat(fpath,'LsrcStaticData_PM10.txt');
fid=fopen(fname,'w+');

% HEADER
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* ROADLINKS_________: %i\n',length(S));
fprintf(fid,'* ROADLINKS as line_: %i\n',length(S));
fprintf(fid,'* ROADLINKS in Area_: %i\n',0);        
fprintf(fid,'* Linesources_______:\n');
fprintf(fid,'%12u\n',length(S));
% Linesource ID's
fprintf(fid,'* %10s %12s %12s %12s %12s %12s %12s %12s %12s %12s \n','ID','X1','X2','Y1','Y2','Z1','Z2','WIDTH','RMAXV','INFL_ZONE');
for i =1:length(S)
    fprintf(fid,'%12u %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12u\n',ID(i),S(i).X(1),S(i).X(2),S(i).Y(1),S(i).Y(2),0,0,Width(i),influence_zone(i),CalcIndices(i));
end
fclose(fid);
fprintf('* Wrote file: \n %s \n',fname)

% START WRITING FILE: LsrcEmissionVariableData_traffic.txt
fname=strcat(fpath,'LsrcEmissionVariableData_traffic.txt');
fid=fopen(fname,'w+');
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* %10s %12s %12s %12s %12s\n','Hour','RoadLinkID','Traffic','HDV','Speed');

fprintf('Start of timevariation is: %s\n',datestr(ds,'dddd'))
wd=weekday(ds);
fprintf('Start changed to         : %s\n',datestr(2+ds-weekday(ds),'dddd'))
cnt=24*(9-wd);
% for i=1:length(DS)
% fprintf('Start of timevariation is: %s %i %s %i \n',datestr(2+DS(i)-weekday(DS(i)),'dddd'), 2-weekday(DS(i)),datestr(DS(i),'dddd'),weekday(DS(i)))
% end
for t=cnt+1:cnt+168 %length(TV)
    HLV=365*LV *TV(1,t);
    HHG=365*HGV*TV(2,t);
    HBU=365*BUS*TV(3,t);
    for i =1:length(S)
        if HLV(i)>0 
            HGF(i)=(HHG(i)+HBU(i))/(HLV(i)+HHG(i)+HBU(i));
        elseif (HHG(i)+HBU(i))>0 & HLV(i)<=0
            HGF(i)=1;
        else
            HGF(i)=0;
%            fprintf('%i suspicious road %f %f %f \n',i,HLV,HHG,HBU)
        end
        fprintf(fid,'%12u %12i %12.1f %12.3f %12i\n',t-cnt,ID(i),HLV(i)+HHG(i)+HBU(i),100*HGF(i),speed(i));
    end
Hm(t)=mean(HGF);
    
end

fclose(fid);
fprintf('* Wrote file: \n %s \n',fname)


% % START WRITING FILE: LsrcEmissionVariableData_EP.txt
% fname=strcat(fpath,'LsrcEmissionVariableData_EP.txt')
% fid=fopen(fname,'w+');
% fprintf(fid,'%38s\n',episode_id);
% fprintf(fid,'%10s %12s %12s %12s \n','Hour','RoadLinkID','Emission_dir1','Emission_dir2');
% for i =1:length(NL)
%     fprintf(fid,'%12u %12i %12.1f %12.1f \n',h,ID(i), E(i)/2, E(i)/2);
% end
% fclose(fid);
% fprintf('* Wrote file: \n %s \n',fname)
% 
















end

%% % LsrcEmissionVariableData_EP.txt
% % % {bd71359f-2dac-4d03-8098-262ee749c6c0}
% % % * Hour  RoadLinkID    Emission_dir1    Emission_dir2
% % %    1      44570        1.130134E-008    1.130134E-008
%% % LsrcEmissionVariableData_traffic.txt
% % % * Hour    RoadLinkID    Traffic    HDV    Speed  
% % % 1   44570   2.6  0.0  50.0   
%% % LsrcStaticData_PM10.txt
% % % {7fab5109-8fc1-47a4-8926-4e3299d856bf}
% % % 1187
% % % * RoadLinkID X1            X2            Y1               Y2            Z1      Z2       Width        MaxInfluenceDist  CalcIndices  
% % % 44610        611026.00      611001.50      6577844.00      6577838.00      4.90      4.88      10.00      60.82      0       
%% % LsrcStaticData_traffic.txt
% % % 11879 
% % % * RoadLinkID    X1            X2            Y1               Y2            Z1      Z2       Width        MaxInfluenceDist  CalcIndices  lon   lat    length    n_lanes    road_type adt
% % % 44570        623030.50      623083.60      6576708.00      6576716.00      57.30      61.00      10.00      0.69      0   11.162  59.311  53.9  2  4  500.0   
% % % 

