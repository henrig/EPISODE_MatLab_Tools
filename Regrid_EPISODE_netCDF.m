function [out_var] = Regrid_EPISODE_netCDF(nc_file,Input_component,sim_year,varargin)
% Function for re-gridding EPISODE concentrations.
% CALLS FUNCTIONS: getGridValueAtCoordinates, inpolygons
% Reads a NETcdf output file and returns a regridded version on UTM grid
% 100 and 10 m resolution.
numvarargs=length(varargin);
if ~nargin
    error('make_maptry:Inputs','Needs at least one input.')
end

if numvarargs > 0
    for i = 1:numvarargs
        switch char(varargin{i})
            case 'outline_file'
                outline_file=char(varargin{i});
        end
    end
    
else
    outline_file='';
end

if ~exist('days_over','var')
    days_over   = 31;
    fprintf('Using default: 31st day\n')
end
if ~exist('hour_over','var')
    hour_over   = 19;
    fprintf('Using default: 19th hour\n')
end
if ~exist('outline_file','file')
    fprintf('No outline file for cropping data found \n')
end

if ~exist(nc_file,'file')
    fprintf('%s\n',nc_file)
    error('make_maptry:Input','nc_file not found.')
end
%--------------------------------------------------------------------------

fprintf('*** Reading NETcdf file:  %s \n  ...',nc_file)
ifo                   = ncinfo(nc_file);
fprintf('*** Reading NETcdf file:  %s \n  ...',nc_file)
x1                    = double(ncread(nc_file,'latr'));
y1                    = double(ncread(nc_file,'lonr'));
RP1                   = double(ncread(nc_file,sprintf('%s_r' ,Input_component)));
D1                    = double(ncread(nc_file,sprintf('%s_2d',Input_component)));
gx                    = double(ncread(nc_file,'x'));
gy                    = double(ncread(nc_file,'y'));
out_var.t             = sim_year+double(ncread(nc_file,'t'))/24;
fprintf('*** DONE Reading NETcdf file \n',nc_file)

D_ave                 = nanmean(D1,3); % D_ave
RP_ave                = nanmean(RP1,2);


size(D1)
size(RP1)
% Simulation not always adds up to a day, need to for daily concentrations.
% Repeat last hour to make a full year or remove extra hour.
if rem(size(RP1,2),24)==23
    RP1(:,end+1)  = RP1(:,end);
    D1(:,:,end+1) = D1(:,:,end);    
elseif rem(size(RP1,2),24)==1
    RP1         = RP1(:,1:end-1);
    D1          = D1(:,:,1:end-1);    
end



%HG defaultm, almanac and mfdewan inbuilt matlab functions
mstruct               = defaultm('utm');
mstruct.zone          = '32N';
mstruct.geoid         = almanac('earth','geoid','m','wgs84');
mstruct               = defaultm(utm(mstruct));
[x,y]                 = mfwdtran(mstruct, x1, y1);


%%% Define grids of 100m and 10m
utmxvec_100           = gx(1):100:gx(end);
utmyvec_100           = gy(1):100:gy(end);
utmxvec_10            = gx(1):10:gx(end);
utmyvec_10            = gy(1):10:gy(end);
[xgrid,ygrid]         = meshgrid(gx,gy);
[xgrid_100,ygrid_100] = meshgrid(utmxvec_100,utmyvec_100);
[xgrid_10,ygrid_10]   = meshgrid(utmxvec_10,utmyvec_10);

%HG Defining a new variable of sorts, is this needed????
sizeRP                = size(RP1);
FRP                   = NaN(sizeRP(1),sizeRP(2));
FRP(1:sizeRP(1),1:sizeRP(2)) = RP1;

%HG reshape, take daily mean and then reshaping back again, IS THIS USED??
result                = reshape(FRP', 24, size(FRP,2)/24*size(FRP,1));
result                = nanmean(result);
result                = reshape(result, size(FRP,2)/24, size(FRP,1));


%HG Find the critical (19th) higest hour value
HAG                   = sort(D1,3,'descend');
out_hour_grid         = HAG(:,:,hour_over);
hour_rp               = sort(RP1,2,'descend');
RP_Hour               = hour_rp(:,hour_over);

%HG Find the daily means (31st) for grid
sizeD                 = size(D1);
DRP                   = NaN(size(gx,1),size(gy,1),size(D1,3));
DRP(1:sizeD(1),1:sizeD(2),1:sizeD(3)) = D1;
daily_avg_grid        = mean(permute(reshape(DRP,size(gx,1),size(gy,1),24,[]),[1 2 4 3]),4);
DAG                   = sort(daily_avg_grid,3,'descend');
out_days_grid         = DAG(:,:,days_over);

day_ave               = sort(result,1,'descend');
out_days              = day_ave(days_over,:);

%%%% original pixel of grid data, WHATS 708???
orig_grid             = getGridValueAtCoordinates(xgrid, ygrid, D_ave',x,y, 708);
orig_grid_hour        = getGridValueAtCoordinates(xgrid, ygrid, out_hour_grid',x,y, 708);
orig_grid_pmday       = getGridValueAtCoordinates(xgrid, ygrid, out_days_grid',x,y, 708);

int_grid              = interp2(gx,gy,D_ave',x,y,'spline');
int_grid_hour         = interp2(gx,gy,out_hour_grid',x,y,'spline');
int_grid_pmday        = interp2(gx,gy,out_days_grid',x,y,'spline');

%HG Subtract the original grid conc from the RP, to avoind double counting
Out_rec               = RP_ave-orig_grid+int_grid;
Out_rec_hour          = RP_Hour-orig_grid_hour+int_grid_hour;
Out_rec_pmday         = out_days'-orig_grid_pmday+int_grid_pmday;

new_map               = griddata(x,y,Out_rec,xgrid_100,ygrid_100,'cubic');
new_map_hour          = griddata(x,y,Out_rec_hour,xgrid_100,ygrid_100,'cubic');
new_map_pmday         = griddata(x,y,Out_rec_pmday,xgrid_100,ygrid_100,'cubic');

new_map_10            = interp2(utmxvec_100,utmyvec_100,new_map,xgrid_10,ygrid_10,'cubic');
new_map_hour_10       = interp2(utmxvec_100,utmyvec_100,new_map_hour,xgrid_10,ygrid_10,'cubic');
new_map_pmday_10      = interp2(utmxvec_100,utmyvec_100,new_map_pmday,xgrid_10,ygrid_10,'cubic');



% Check if  filenames for input files & read the shapefiles
if exist(outline_file,'file')
    fprintf('*** Reading Outline shape:    %s \n...\n',outline_file)
    Border            = shaperead(strcat(path_shape,'bergen_outline_utm32N'));
    [in, ~]       = inpolygons(xgrid_10,ygrid_10,Border.X,Border.Y);
else
    in= ones(size(new_map_10));
end
out_var.maptry_100            = new_map;
out_var.maptry_hour_100       = new_map_hour;
out_var.maptry_day_100        = new_map_pmday;

out_var.maptry                = new_map_10.*in;
out_var.maptry_hour           = new_map_hour_10.*in;
out_var.maptry_hour(out_var.maptry_hour<0.1)=NaN;
out_var.maptry_day            = new_map_pmday_10.*in;
out_var.maptry_day(out_var.maptry_day<0.1)=NaN;

out_var.utmxvec_100=utmxvec_100;
out_var.utmyvec_100=utmyvec_100;
out_var.utmxvec_10=utmxvec_10;
out_var.utmyvec_10=utmyvec_10;
end

