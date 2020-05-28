function  write_EPISODE_traffic_Line_file(fname,line,SF,LID,TV,scale)
% Writes an area emissions (traffic) file for EPISODE to read.

% fname='/storage/home/heg/Documents/EMISSIONS/Plot_Stavanger/test_area_traffic_PM25.txt'
[nLine]   = size(line); % 14 25
h       = length(TV);
% Scale is needed to make the correct units


% Set these as varargs for future use in different simulations
%episode_id  ='{Stavanger-AQ-calculations---------01}';
episode_id  ='{NedreGlomma-AQ-calculations--------01}';
level       ='lsrc';
comp_str    ='PM25';
ADT_limit   = 1000;
datevec     =[2012  1  1  0 0 0];
enddatevec  =[2012 12 31 23 0 0];

% some remnant parameters from old code not really needed anymore, but may
% have unknown uses. Leave for now.
scaling=1/3600; %Converts g/hr to g/s
save_gridded_area_index=1;


% START WRITING FILE
fid=fopen(fname,'w');

% HEADER
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* Hourly average linesource emission file\n');
fprintf(fid,'*      Compound: %s\n',comp_str);
fprintf(fid,'*     ADT limit: %u\n',ADT_limit);
fprintf(fid,'*         Units: %s\n','g/s/m');
fprintf(fid,'* Starting date: %4u %2u %2u %2u\n',datevec(1),datevec(2),datevec(3),datevec(4));
fprintf(fid,'*   Ending date: %4u %2u %2u %2u\n',enddatevec(1),enddatevec(2),enddatevec(3),enddatevec(4));
fprintf(fid,'* %3s %5s %10s %10s\n','HR','IQLVV','QL1V','QL2V');


%  One line for each emission, containing hour linkID and Emission x2??????
if size(TV,2)==1
    for h=1:length(TV)
        for li=1:length(LID)
            QL1V=line(li)/2*scale*TV(h);
            QL2V=QL1V;
            print_data=[h;LID(li);QL1V';QL2V'];
            fprintf(fid,'%5u %5u %11.3e %11.3e\n',print_data);
        end
    end
    fprintf('WROTE file: %s\n',fname)
elseif size(TV,2)==2
    TVfrac=extractfield(SF,'TVfrac');
    for h=1:length(TV)
        for li=1:length(LID)
            QL1V=line(li)/2*scale*(TV(h,2)*sum(TVfrac+TV(h,1)*(1-TVfrac)));
            QL2V=QL1V;
            print_data=[h;LID(li);QL1V';QL2V'];
            fprintf(fid,'%5u %5u %11.3e %11.3e\n',print_data);
        end
    end
    fprintf('WROTE file: %s\n',fname)
else
    warning('Timevariation dimension not consistent')
end
fclose(fid);

end