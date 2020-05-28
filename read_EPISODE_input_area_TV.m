function out = read_EPISODE_input_area_TV(file)


% Open file
fid = fopen(file);


k = isempty(strfind(file, 'grnd'));
if k
    nHeaderLines = 9;
    % Reader header
    header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');
    
    % What is the inputfile about
    comp=header{1}{4};
    comp=comp(end-3:end);
    
    unit=header{1}{5};
    unit=unit(end-8:end);
    
    % Get info on start date and end date
    datestart=header{1}{6};
    ds=datenum(datestart(18:end),'yyyy mm dd hh');
    
    datestop=header{1}{7};
    de=datenum(datestop(18:end),'yyyy mm dd hh');
    % calculate the number of hours in the file
    dates=ds:1/24:de;
    nHours=length(dates);

    size=header{1}{9};
    nx= str2num(size(16:17));
    ny= str2num(size(19:20));
else
    
    nHeaderLines = 10;
    % Reader header
    header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');
    % What is the inputfile about
    comp=header{1}{5};
    comp=comp(end-3:end);
    
    unit=header{1}{6};
    unit=unit(end-8:end);
    
    % Get info on start date and end date
    datestart=header{1}{7};
    ds=datenum(datestart(18:end),'yyyy mm dd hh');
    
    datestop=header{1}{8};
    de=datenum(datestop(18:end),'yyyy mm dd hh');
    % calculate the number of hours in the file
    dates=ds:1/24:de;
    nHours=length(dates);
    % Get info on grid size
    size=header{1}{10};
    pm = isempty(strfind(file, 'pm10'));
if pm
    nx= str2num(size(16:17));
    ny= str2num(size(19:20));
else
    nx= str2num(size(end-4:end-3));
    ny= str2num(size(end-1:end));
end
    
end



% calculates the number of rows
rows = nx * ny;

fprintf('*************************************\n')
fprintf('Compound   :  %s\n',comp)
fprintf('Unit       :  %s\n',unit)
fprintf('Start date :  %s\n',datestr(ds))
fprintf('End   date :  %s\n',datestr(de))
fprintf('Time length:  %i\n',nHours)
fprintf('*************************************\n')

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
TV=squeeze(sum(sum(gridval)));
fprintf('out.annual:  %s\n','grams / total time')

% generates the ouput object
out.annual = annual;
out.nx     = nx;
out.ny     = ny;
out.dates  = dates;
out.compound = comp;
out.TV     = TV;

% grid2val = nan(ny,nx,nHours);
% % test for comparison with old method
% for h=1:nHours
%     for i=1:length(xi)
%         grid2val(yi(i), xi(i), h) = val(i, h);
%     end
% end
%
% annual2= sum(grid2val,3);
%
% figure
% imagesc(annual)
% figure
% imagesc(annual2)
end















