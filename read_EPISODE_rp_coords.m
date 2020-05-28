function [id x y] = read_EPISODE_rp_coords(file);

nHeaderLines = 3;

fid = fopen(file);
% skip header
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');

%d = fscanf(fid, '%s\n');
d = textscan(fid, '%s %f %f %f %d %s', inf);%, 'delimiter', '\t');
fclose(fid);

guid = d{1};
x = d{2};
y = d{3};
z = d{4};
numpersons = d{5};
id = d{6};
end
