function data = read_EPISODE_rp(file)

%nHeaderLines = 11;
nHeaderLines = 10;
%nHours = 128;
%nRP = 21335;
nHours = 8760;
% nHours = 6660;

%nRP = 21209
nRP = 21184;
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