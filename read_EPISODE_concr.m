function d = read_EPISODE_concr(file)
% FUNCTION to read EPISODE line source files and read them into a matrix.
% The matrix is then summed up over the timeperiod to make total emissions.
% 


% Open file
%[data,DELIM, Hlines]=importdata(file);

fid = fopen(file);
header = textscan(fid, '%s', 11, 'delimiter', '\n');

    d  = fscanf(fid,'%u%f%f%f%f',[5,inf])';

fclose(fid);


end