function out = read_EPISODE_input_area_2(file,nHeaderLines,nHours)


% Open file
fid = fopen(file);

nHeaderLines = 9;
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');
grid = textscan(fid, '%s', 1, 'delimiter', '\n');
GI=char(grid{1,1});
nx= str2num(GI(end-4:end-3));
ny= str2num(GI(end-1:end));
% calculates the number of rows
rows = nx * ny;

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
gridval=reshape(val,nx,ny,nHours);
gridval=permute(gridval,[2,1,3]);
annual= sum(gridval,3)*3600;
fprintf('out.annual:  %s\n','grams / total time')

% generates the ouput object
out.annual = annual;
out.nx     = nx;
out.ny     = ny;
out.tv     = squeeze(sum(sum(gridval)));



end