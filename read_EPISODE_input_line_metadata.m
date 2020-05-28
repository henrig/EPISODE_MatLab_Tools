function out = read_EPISODE_input_line_metadata(file)
% FUNCTION to read a metadata linesource file for EPISODE. 
% It is a fixed format file so there should be limited use for testing. 
% The output is out. which is a shape struct.

% Open file
fid = fopen(file);
nHeaderLines = 7;
% Reader header
header = textscan(fid, '%s', nHeaderLines, 'delimiter', '\n');

% ADT limit
ADT_lim=header{1}{2};
ADT_lim=ADT_lim(end-4:end);

% Total number of lines sources
TOT=header{1}{3};
TOT=TOT(end-4:end);

% Number of lines put into grid
GRID=header{1}{4};
GRID=GRID(end-5:end);

% Number of lines saved as line source
LINES=header{1}{5};
LINES=LINES(end-5:end);

% Number of line sources:
nLINES=header{1}{6};
nLINES=nLINES(end-5:end);

fclose(fid);

fprintf('******  Line  Metadata **************\n')
fprintf('INPUT:  is a linesource metadata file\n')
fprintf('for EPISODE.  \n')
fprintf('ADT limit    :  %s\n',ADT_lim)
fprintf('Total LINES  :  %s\n',TOT)
fprintf('Grid  LINES  :  %s\n',GRID)
fprintf('Line  LINES  :  %s\n',LINES)
fprintf('*************************************\n')
fprintf('OUTPUT is a shape struct that needs  \n')
fprintf('dbfspec (   dbfspec=makedbfspec()   )\n')
fprintf('after the emissions fields has been  \n')
fprintf('added.  \n')


% [A,m,data] =
A=importdata(file,' ',nHeaderLines);
T.IQLV     = A.data(:,1);     
T.X1V      = A.data(:,2);    
T.X2V      = A.data(:,3);
T.Y1V      = A.data(:,4);   
T.Y2V      = A.data(:,5);    
T.Z1V      = A.data(:,6);   
T.Z2V      = A.data(:,7);    
T.WV       = A.data(:,8);
T.RMAXV    = A.data(:,9); 
T.INDICES  = A.data(:,10);

% Calculate the length of each roadlink (needed for emissions)
T.d = sqrt( (T.X2V(:)-T.X1V(:)).^2 + (T.Y2V(:)-T.Y1V(:)).^2 );

% Make a shape struct
for i=1:size(T.X1V,1)
out(i).BoundingBox(1,1)= T.X1V(i);
out(i).BoundingBox(2,1)= T.X2V(i);
out(i).BoundingBox(1,2)= T.Y1V(i);
out(i).BoundingBox(2,2)= T.Y2V(i);

out(i).X(1)=T.X1V(i);
out(i).X(2)=T.X2V(i);
out(i).X(3)=NaN;

out(i).Y(1)=T.Y1V(i);
out(i).Y(2)=T.Y2V(i);
out(i).Y(3)=NaN;
out(i).Width=T.WV(i);
out(i).Length = T.d(i);

out(i).Geometry = 'Line';

out(i).ID = T.IQLV(i);
end




end
