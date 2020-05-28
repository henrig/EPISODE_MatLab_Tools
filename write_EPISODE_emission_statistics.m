function [ output_args ] = write_EPISODE_emission_statistics(l,a,o)
% LOOP READ FILES IN l & a to do statistics on

fprintf(fid,'%s\n');

for i=1:size(l,1)

    O(i)=read_EPISODE_input_area_2(char(a(i,:).fname));

    
    
    %  read_EPISODE_input_line
end




fid=fopen(o,'w');
% HEADER
fprintf(fid,'\n');
fprintf(fid,' Hourly average gridded area emission file\n');
fprintf(fid,'         Level: %s\n',level);
fprintf(fid,'      Compound: %s\n',comp_str);
fprintf(fid,'         Units: %s\n','g/s');
fprintf(fid,' Starting date: %4u %2u %2u %2u\n',datevec(1),datevec(2),datevec(3),datevec(4));
fprintf(fid,'   Ending date: %4u %2u %2u %2u\n',enddatevec(1),enddatevec(2),enddatevec(3),enddatevec(4));
fprintf(fid,' ----------------------------------------------\n');


end

