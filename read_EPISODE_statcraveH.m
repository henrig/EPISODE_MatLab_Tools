function out = read_EPISODE_statcraveH(file)
% FUNCTION to read EPISODE line source files and read them into a matrix.
% The matrix is then summed up over the timeperiod to make total emissions.
% 


% Open file
%[data,DELIM, Hlines]=importdata(file);

fid = fopen(file);
header = textscan(fid, '%s', 14, 'delimiter', '\n');

out  = fscanf(fid,'%u%u%u%f%u',[5,inf])';

fclose(fid);
% 
% x=d(:,1);
% y=d(:,2);
% for i=1:length(d)
%     out(x(i),y(i))=d(i,3);
% end
%     
    


end