% Make woodburning emissions Bergen
clear all; close all; clc
addpath /storage/home/heg/Documents/MATLAB/Tools

fname='/storage/nilu/Inby/Aktive-prosjekter/o 116111 Tiltaksutredning i Bergen/Utslipp/2015/PM/PM/asrc_uple_20150101_20160101_pm25_HG_testWOOD.txt';
em = read_EPISODE_input_area(fname);

path_emiss     ='/storage/nilu/Inby/Aktive-prosjekter/o 116111 Tiltaksutredning i Bergen/Utslipp/2015/PM/PM/';
nfname         = strcat(path_emiss,'asrc_uple_20150101_20160101_pm25_HG_testWOOD_Tiltak.txt');
% TV=em.tv/mean(em.tv);
% scale=1;
% sarea=em.annual*0.79*3.1710e-08;
% write_EPISODE_wood_Area_file(nfname,sarea,TV,scale)

em2 = read_EPISODE_input_area(nfname);

sum(sum(em.annual))

sum(sum(em2.annual))

sum(sum(em.annual))/sum(sum(em2.annual))


path_shape  = '/storage/home/heg/Documents/EMISSIONS/GIS/Bergen/';
path_emiss     ='/storage/nilu/Inby/Aktive-prosjekter/o 116111 Tiltaksutredning i Bergen/Utslipp/2015/';
meta_file           = strcat(strcat(path_emiss,'NOx/Traffic/linesource_metadata_NEW2.txt'));
NR = read_EPISODE_input_line_metadata(meta_file);

water_file  = strcat(path_shape,'Bergen_Rivers_utm32N');
land_file   = strcat(path_shape,'Bergen_Land_utm32N');
ocean_file  = strcat(path_shape,'Bergen_water_utm32N');
water  = shaperead(water_file);
land  = shaperead(land_file);
ocean= shaperead(ocean_file);


% % BERGEN 32 N
Xmin=284000;
Ymin=6683500;
nX=24;
nY=32;
step=1000;  
xb=Xmin:step:Xmin+(step*(nX-1));
yb=Ymin:step:Ymin+(step*(nY-1));


% 
% % load('First_1k1k_test_HENRIK.mat')
% % area=new_map_1k;
% % area(isnan(area))=0;
% % scale=4.2910e+08/1.5372e+12;
% % sarea=(319*area/sum(sum(area))*1e6/(365*24));% [T/yr] => [g/hr] *1e6/(365*24)
% % % write_EPISODE_wood_Area_file(fname,sarea,TV,scale)
% 
% 
% 
% af2.name          = strcat(path_emiss,'PM/PM/asrc_uple_20150101_20160101_pm25_andreskip.txt');
% em3 = read_EPISODE_input_area(af2.name)
% 
% 
% 
% %%
% % Set 
% fprintf('Read shapefiles for plotting')
% 
% 
figure
subplot(1,2,1)
imagesc(xb+500,yb+500,(log10((em.annual))))
set(gca, 'YDir', 'normal')
axis image
ax=gca
ax.XLim=([min(xb)-500, max(xb)+1500]);
ax.YLim=([min(yb)-500, max(yb)+1500]);
ax.XTick=min(xb):1000:max(xb);ax.XTickLabel='';
ax.YTick=min(yb):1000:max(yb);ax.YTickLabel='';
grid on
hold on
mapshow(NR,'color','k')
mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
mapshow(water,'FaceColor', rgb('Blue'),'FaceAlpha', 0.4, 'EdgeColor',  rgb('Blue'))
title('Bergen ORIGINAL wood emission GRIDDED 1km')
rectangle('Position',[Xmin Ymin 24*1000 32*1000],'EdgeColor','r','LineWidth',3)
cm=(cbrewer('seq','YlOrBr',30,'cubic'))
cmfit(cm,[0.1 8],0.1)
ch=colorbar;
ch.Limits=[0 8];
ch.Ticks=[1:8];
ch.TickLabels


subplot(1,2,2)
imagesc(xb+500,yb+500,log((em2.annual)))
set(gca, 'YDir', 'normal')
axis image
ax=gca;
ch=colorbar;
ch.Limits=[0 15];

ax.XLim=([min(xb)-500, max(xb)+1500]);
ax.YLim=([min(yb)-500, max(yb)+1500]);
ax.XTick=min(xb):1000:max(xb);ax.XTickLabel='';
ax.YTick=min(yb):1000:max(yb);ax.YTickLabel='';
grid on
hold on
mapshow(NR,'color','k')
mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
mapshow(water,'FaceColor', rgb('Blue'),'FaceAlpha', 0.4, 'EdgeColor',  rgb('Blue'))
title('Bergen wood emission GRIDDED 1km')
rectangle('Position',[Xmin Ymin 24*1000 32*1000],'EdgeColor','r','LineWidth',3)
cm=(cbrewer('seq','YlOrBr',30,'cubic'))
cmfit(cm,[0 15],0.5)
%%%%%rectangle('Position',[Xmin+13000 Ymin+15000 2*1000 2*1000],'EdgeColor','r','LineWidth',3)
% 
% 
% 
% diff=(flipud(em.annual)-flipud(em2.annual));
% diff=diff./(flipud(em.annual)+em2.annual);
% figure
% imagesc(xb+500,yb+500,diff)
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xb):1000:max(xb);ax.XTickLabel='';
% ax.YTick=min(yb):1000:max(yb);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
% mapshow(water,'FaceColor', rgb('Blue'),'FaceAlpha', 0.4, 'EdgeColor',  rgb('Blue'))
% title('Bergen ORIGINAL wood emission GRIDDED 1km')
% cm=(cbrewer('div','PuOr',40,'cubic'))
% cmfit(cm,[-100 100],2.5)
% 
% %%
% % Set 
% path_shape  = '/storage/home/heg/Documents/EMISSIONS/GIS/Bergen/';
% path_emiss     ='/storage/nilu/Inby/Aktive-prosjekter/o 116111 Tiltaksutredning i Bergen/Utslipp/2015/';
% meta_file           = strcat(strcat(path_emiss,'NOx/Traffic/linesource_metadata_NEW2.txt'));
% NR = read_EPISODE_input_line_metadata(meta_file);
% 
% 
% 
% WE=shaperead('/storage/home/heg/Documents/EMISSIONS/Plot_Bergen/Bergen_wood_1x1_for_Henrik/Bergen_wood_1x1_for_Henrik');
% fprintf('Read shapefile for EMISSIONS')
% 
% for i=1:length(WE)
%     xl(i)=WE(i).X(1);
%     yl(i)=WE(i).Y(1);
% end
% 
% XL=reshape(xl,24,32);
% YL=reshape(yl,24,32);
% xvec=XL(:,1);
% yvec=YL(1,:);
% 
% emiss=extractfield(WE,'SUM_All_te');
% EM=reshape(emiss,24,32)
% 
% % % BERGEN 32 N
% Xmin=284000;
% Ymin=6683500;
% nX=24;
% nY=32;
% step=1000;  
% xb=Xmin:step:Xmin+(step*(nX-1));
% yb=Ymin:step:Ymin+(step*(nY-1));
% 
% load('Emissions_HG_method_Bergen_1k_v3.mat')
% map_1k=tmap1;
% fprintf('Read HG EMISSIONS')
% 
% 
% lx=extractfield(WE,'X');
% ly=extractfield(WE,'Y');
% Ixl=xt_1k>=Xmin;
% Ixh=xt_1k<=max(xb);
% Xlims=Ixl&Ixh;
% xmap_1k=(map_1k(:,Xlims));
% Iyl=yt_1k>=Ymin;
% Iyh=yt_1k<=max(yb);
% Ylims=Iyl&Iyh;
% new_map_1k=map_1k(Ylims,Xlims);
% 
% new_map_1k=429*new_map_1k/nansum(nansum(new_map_1k));
% 
% 
% 
% map_1k(map_1k<=0)=NaN;
% 
% EM=fliplr(flipud(reshape(emiss,24,32)));
% %EM=reshape(emiss,24,32);
% % EM(EM<0.0)=NaN
% % EM(isnan(EM))=0;
% 
% %mapshow(WE.X,WE.Y,WE.SUM_All_te,'DisplayType', 'contour')
% 
% %new_map_1k(isnan(new_map_1k))=0;
% 
% %%
% save('First_1k1k_test_HENRIK.mat','xb','yb','new_map_1k')
% figure(1);clf
% h=imagesc(xb+500,yb+500,(new_map_1k))
% set(h,'alphadata',~isnan(new_map_1k))
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xt_1k):1000:max(xt_1k);ax.XTickLabel='';
% ax.YTick=min(yt_1k):1000:max(yt_1k);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
% mapshow(water,'FaceColor', rgb('Blue'),'FaceAlpha', 0.4, 'EdgeColor',  rgb('Blue'))
% title('Bergen wood emission GRIDDED 1km')
% rectangle('Position',[Xmin Ymin nX*1000 nY*1000],'EdgeColor','r','LineWidth',3)
% 
% 
% figure(2);clf
% h=imagesc(xvec+500,yvec+500,log(EM))
% set(h,'alphadata',~isnan(EM))
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xt_1k):1000:max(xt_1k);ax.XTickLabel='';
% ax.YTick=min(yt_1k):1000:max(yt_1k);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
% mapshow(water,'FaceColor', rgb('Blue'),'FaceAlpha', 0.4, 'EdgeColor',  rgb('Blue'))
% title('Bergen wood emission GRIDDED 1km')
% rectangle('Position',[Xmin Ymin nX*1000 nY*1000],'EdgeColor','r','LineWidth',3)
% 
% 
% 
% 
% %%
% figure(2);clf
% subplot(1,2,1)
% h=imagesc(xb+500,yb+500,log10(new_map_1k))
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xt_1k):1000:max(xt_1k);ax.XTickLabel='';
% ax.YTick=min(yt_1k):1000:max(yt_1k);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% h=colorbar;
% h.Limits=[0 1.2];
% cm=(cbrewer('seq','YlOrBr',40,'cubic'));
% cmfit(cm,[0 1.2],0.1)
% mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
% 
% subplot(1,2,2)
% h=imagesc(xvec+500,yvec+500,log10(EM'))
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xt_1k):1000:max(xt_1k);ax.XTickLabel='';
% ax.YTick=min(yt_1k):1000:max(yt_1k);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% h=colorbar;
% h.Limits=[0 1.2];
% cm=(cbrewer('seq','YlOrBr',40,'cubic'));
% cmfit(cm,[0 1.2],0.1)
% mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
% 
% %%
% 
% 
% 
% diff=EM'-new_map_1k;
% figure;clf
% %subplot(1,3,3)
% h=imagesc(xvec,yvec,diff)
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xt_1k):1000:max(xt_1k);ax.XTickLabel='';
% ax.YTick=min(yt_1k):1000:max(yt_1k);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% h=colorbar;
% h.Limits=[-20 20];
% cm=(cbrewer('div','PuOr',40,'cubic'))
% cmfit(cm,[-20 20],1)
% title('DAM - HENRIK')
% 
% diff_pct=100*(EM'-new_map_1k)./((EM'+new_map_1k));
% 
% figure;clf
% %subplot(1,3,3)
% h=imagesc(xvec,yvec,diff_pct)
% set(gca, 'YDir', 'normal')
% axis image
% ax=gca
% ax.XLim=([min(xb)-500, max(xb)+1500]);
% ax.YLim=([min(yb)-500, max(yb)+1500]);
% ax.XTick=min(xt_1k):1000:max(xt_1k);ax.XTickLabel='';
% ax.YTick=min(yt_1k):1000:max(yt_1k);ax.YTickLabel='';
% grid on
% hold on
% mapshow(NR,'color','k')
% h=colorbar;
% h.Limits=[-50 50];
% cm=(cbrewer('div','PuOr',40,'cubic'))
% cmfit(cm,[-50 50],1)
% title('DAM - HENRIK')
% mapshow(land,'FaceColor', rgb('Sienna'),'FaceAlpha', 0.3, 'EdgeColor',  rgb('Yellow'))
% 
% 
% 
% 
% 
% %%
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
