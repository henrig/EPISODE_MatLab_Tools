function data = read_EPISODE_rp_Stavanger(file)

nHeaderLines = 11;
% nHours = 8760;
nHours = 8784;


% nHeaderLines = 10;

%nRP = 21209
nRP = 4;
%nRP = 44087;
% Open file
fid = fopen(file);

% skip header
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');

% Read data
d = fscanf(fid, '%f', [nRP+1 nHours]); % +1 for the hour column
d = transpose(d);
hours = d(:,1);
data = d(:,2:end); % get rid of the hour column
%data = d(:,3);
% Close file
fclose(fid);



end
