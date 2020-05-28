function out = read_EPISODE_input_line_simplified(file,nHeaderLines,nHours)
% FUNCTION to read EPISODE line source files and read them into a matrix.
% The matrix is then summed up over the timeperiod to make total emissions.

% Open file
fid = fopen(file);
%nHeaderLines = 8;


% Reader header
% fprintf('*************************************\n')
% fprintf('Reading header of file \n %s\n',file)
% 
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');
% % What is the inputfile about
% comp=header{1}{3};
% comp=comp(end-3:end);
% 
% unit=header{1}{5};
% unit=unit(end-8:end);
% % Get info on start date and end date
% datestart=header{1}{6};
% ds=datenum(datestart(18:end),'yyyy mm dd hh');
% datestop=header{1}{7};
% de=datenum(datestop(18:end),'yyyy mm dd hh');
% % calculate the number of hours in the file
% dates=ds:1/24:de;
% nHours=length(dates);
% 
% fprintf('*************************************\n')
% fprintf('Compound   :  %s\n',comp)
% fprintf('Unit       :  %s\n',unit)
% fprintf('Start date :  %s\n',datestr(ds))
% fprintf('End   date :  %s\n',datestr(de))
% fprintf('Time length:  %i\n',nHours)
% fprintf('*************************************\n')

% Must have the number of road links that emissions are calculated for.
% This should match the 
% My matlab duns out of memory if i try to convert everything to double, so
% i have to loop through segments of the data
fprintf('Finding number of Road Links ...\n')
M = textscan(fid, '%d%d');
RL =double(unique(M{1,2}));

% Find out where the zero comes from
RL   = RL(2:end);
nRL  = length(RL);
fclose(fid);
fprintf('Found a total of %i unique Road Links \n',nRL)
fprintf('*************************************\n')
EM   = zeros(length(RL),3);
EM(:,1)=RL;

% Read each hour emission for each road link
fid = fopen(file);
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');
TV=NaN(nHours,1);
for n=1:nHours
    clear d val
    d  = fscanf(fid,'%u%u%f%f',[4,nRL]);
    val(:,1) = d(3,:)';
    val(:,2) = d(4,:)';
    EM(:,2) = EM(:,2)+val(:,1)*3600;
    EM(:,3) = EM(:,3)+val(:,2)*3600;
    TV(n)=sum(val(:,2)+val(:,1))*3600;
    if rem(n,500)==0; fprintf('at hour %i of %i \n',n, nHours); end
end
fclose(fid);
fprintf('*************************************\n')
fprintf('Emission out is on unit %s \n','g/yr/m')
fprintf('Need Road link Length to get actual emissions %s \n','T/yr')
TV=TV/sum(TV);
out.EM = EM;
out.unit = 'g/yr/m';
out.TV = TV;


end