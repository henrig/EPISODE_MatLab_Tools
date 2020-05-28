function  write_EPISODE_wood_Area_file(fname,area,TV,scale)
% Writes an area emissions (traffic) file for EPISODE to read.
% fname = name of file to be written
% area  = data(ns,ew) to be written
% TV    = TV(t) timevariation to be written


% fname='/storage/home/heg/Documents/EMISSIONS/Plot_Stavanger/test_area_traffic_PM25.txt'
[ns,ew]   = size(area); % 32 24
h         = length(TV);
% Scale is needed to make the correct units 



% Set these as varargs for future use in different simulations
episode_id  ='{Bergen-AQ-calculations------------01}';
level       ='uple';
comp_str    ='PM25';
datevec     =[2015  1  1  1 0 0];
enddatevec  =[2016  1  1  0 0 0];

% some remnant parameters from old code not really needed anymore, but may
% have unknown uses. Leave for now.

scaling=1/3600; %Converts g/hr to g/s
save_gridded_area_index=1;

fid=fopen(fname,'w');
% HEADER
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* ----------------------------------------------\n');
fprintf(fid,'* Hourly average gridded area emission file\n');
%fprintf(fid,'*         Level: %s\n',level);
fprintf(fid,'*      Compound: %s\n',comp_str);
fprintf(fid,'*         Units: %s\n','g/s');
fprintf(fid,'* Starting date: %4u %2u %2u %2u\n',datevec(1),datevec(2),datevec(3),datevec(4));
fprintf(fid,'*   Ending date: %4u %2u %2u %2u\n',enddatevec(1),enddatevec(2),enddatevec(3),enddatevec(4));
fprintf(fid,'* ----------------------------------------------\n');

% GRIDDED EMISSION per hour.
for t=1:h
TEXT1=['H: ',num2str(t,'%6u')];
fprintf(fid,'%10s%10s%3u%3u\n',TEXT1,'Area',ew,ns);
for i=1:ns
    for j=1:ew
            fprintf(fid,'%3u %3u %10.2e\n',j,i,area(i,j)*TV(t)*scale);
%           fprintf('%3u %3u %10.2e\n',j,i,area(i,j)*TV(h)*scale);
%           fprintf(fid,'%11.3e\n',area(i,j,h));
    end
end
fprintf(fid,'\n');
end


fclose(fid);



end