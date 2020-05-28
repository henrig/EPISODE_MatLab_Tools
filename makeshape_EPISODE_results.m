function [] = makeshape_EPISODE_results(M,ff)

Xmin = min(M.utmxvec_100);
Ymin = min(M.utmyvec_100);
nX   = length(M.utmxvec_100);
nY   = length(M.utmyvec_100);

step = round(M.utmxvec_100(2)-M.utmxvec_100(1));
S100 = Make_shape_polygon_squares(Xmin,Ymin,nX,nY,step);

t=1;
for i=1:length(M.utmxvec_100)
    for j=1:length(M.utmyvec_100)
        S100 = setfield(S100,{t},'AvgConc',{1},M.maptry_100(i,j));
        S100 = setfield(S100,{t},'Day31'  ,{1},M.maptry_day_100(i,j));
        S100 = setfield(S100,{t},'Hour19' ,{1},M.maptry_hour_100(i,j));
        t=t+1;
        if rem(t,2000)==0; fprintf('Assigned: %i of %i fields \n',t,nX*nY)
    end
end
% ofilename=(ff);
% dbf=makedbfspec(S100);
% shapewrite(S100,ofilename, 'DbfSpec', dbf);
end