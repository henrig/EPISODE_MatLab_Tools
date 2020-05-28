function  write_EPISODE_traffic_META_LINE_file(fname,lines,makeADTcut,adt_lim,col,episode_id)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EERT: Exhaust Emissions from Road Traffic 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explanation goes here: 

% INPUT: fname: (str) name of output file (EPISODE EMISSIONS FILE ) 
% INPUT: episode_id: (str) 
% INPUT: Emissions (double) per roadlink.  
% INPUT: TV (double) per class.  
% INPUT: LID (integer) per rorad link. unique ID number (match the META file)


% NILU: Apr 2018: Henrik Grythe 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Writes a line mete file for EPISODE.

% Set these as varargs for future use in different simulations
% episode_id  ='{Stavanger-AQ-calculations---------01}';
% episode_id  ='{Bergen-AQ-calculations------------01}';
% episode_id  ='{Glomma-AQ-calculations------------01}';

if makeADTcut
    % Extract ADT
    ADT=extractfield(lines,col);
    I=ADT>adt_lim;
    
    fprintf(' # Roadlinks: %i \n   ADT LIMIT: %i \n # Roadlinks LINE: %i \n # Roadlinks AREA: %i\n\n',length(ADT), adt_lim,sum(I), sum(~I))
    
    % extract the lanes to make line meta data of
    NL=lines(I);
else
    NL=lines;
end
% Calculate the width of the road based on the number of lanes. Assumes a
% fixed roadwdith of 3 meters for now. Ask if RTM can give width in meters instead!

Lan=extractfield(NL,'LANES');
% strange lane formate, needs fixing
b=regexp(Lan,'\d+(\.)?(\d+)?','match');
for i=1:length(b)
    Lanes(i)=max(str2double([b{i}]));
end
Lane_width=3; % meter
Width=Lanes*Lane_width;


% Define the range of influence on the receptor
influence_zone=500; % meter


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
fprintf(fid,'* ROADLINKS in Area_: %i\n',length(lines));    
end
fprintf(fid,'* Linesources_______:\n');
fprintf(fid,'%12u\n',length(NL));
% fprintf(fid,'* %10s %12s %12s %12s %12s %12s %12s %12s %12s %12s\n','RoadlinkID','X1','X2','Y1','Y2','Z1','Z2','Width','MaxInfluenceDist','CalcIndices');
fprintf(fid,'* RoadLinkID	X1	X2	Y1	Y2	Z1	Z2	Width	MaxInfluenceDist	CalcIndices \n');

% Linesource ID's
for i =1:length(NL)
    fprintf(fid,'%12u %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12.1f %12u \n',i,NL(i).X(1),NL(i).X(2),NL(i).Y(1),NL(i).Y(2),0,0,Width(i),influence_zone,0);
end
fclose(fid);

fprintf('* Wrote file: \n %s \n',fname)

end

%    fprintf(fid,'%5u\t%8f\t%8f\t%8f\t%8f\t%12.1f %12.1f %12.1f %12.1f %12u \n',i,NL(i).X(1),NL(i).X(2),NL(i).Y(1),NL(i).Y(2),0,0,Width(i),influence_zone,0);
%    44570	623030.5	623083.6	6576708	6576716	57.3	61	10	300	0
