function out = read_EPISODE_ASCII2_st(file)
% This v2 should be able to read multiple hours

% Could read parameters from input file - do it simply for now
nx = 38;
ny = 27;
nHeaderLines = 11;
nHours = 8760;
% nHours = 6660;
rows = nx * ny;

% Open file
fid = fopen(file);

% Reader header (could be extended to read the parameters)
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');

% Loop through all hours
for i=1:nHours
    d = fscanf(fid,'%u%u%f',[3,rows]);
    xi = d(1,:)';
    yi = d(2,:)';
    val(:,i) = d(3,:)';
    subheader = textscan(fid, '%s', 3, 'delimiter', '\n');
end

% Close file
fclose(fid);

% Convert vectors into matrices of dimension nx x ny x nHours
out = nan(ny,nx,nHours);
for h=1:nHours
    for i=1:length(xi)
        out(yi(i), xi(i), h) = val(i, h);
    end
end




end