function  write_EPISODE_traffic_Area_file_simplified(fname,area,TV,episode_id)
% Writes an area emissions (traffic) file for EPISODE to read.

% fname='/storage/home/heg/Documents/EMISSIONS/Plot_Stavanger/test_area_traffic_PM25.txt'
[ns,ew]   = size(area); % 14 25
h         = length(TV);
% Scale is needed to make the correct units
scale=1/3600;

fid=fopen(fname,'w');
% HEADER
fprintf(fid,'%38s\n',episode_id);

% GRIDDED EMISSION per hour.
for t=1:h
    TEXT1=['H: ',num2str(t,'%6u')];
    fprintf(fid,'%10s%10s%3u%3u\n',TEXT1,'Area',ew,ns);
    for i=1:ns
        for j=1:ew
            fprintf(fid,'%3u %3u %10.2e\n',j,i,area(i,j)*TV(t)*scale);
        end
    end
    fprintf(fid,'\n');
end
fprintf('WROTE file: %s\n',fname)

fclose(fid);

end


% fprintf(fid,'* ----------------------------------------------\n');
% fprintf(fid,'* Hourly average gridded area emission file\n');
% fprintf(fid,'*         Level: %s\n',level);
% fprintf(fid,'*      Compound: %s\n',comp_str);
% fprintf(fid,'*         Units: %s\n','g/s');
% fprintf(fid,'* Starting date: %4u %2u %2u %2u\n',startdatevec(1),startdatevec(2),startdatevec(3),startdatevec(4));
% fprintf(fid,'*   Ending date: %4u %2u %2u %2u\n',enddatevec(1),enddatevec(2),enddatevec(3),enddatevec(4));
% fprintf(fid,'* ----------------------------------------------\n');
