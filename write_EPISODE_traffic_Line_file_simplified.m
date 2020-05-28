function  write_EPISODE_traffic_Line_file_simplified(fname,episode_id,EM,TV,LID)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EERT: Exhaust Emissions from Road Traffic 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explanation goes here: 

% INPUT: fname: (str) name of output file (EPISODE EMISSIONS FILE ) 
% INPUT: episode_id: (str) 
% INPUT: Emissions (double) per roadlink.  
% INPUT: TV (double) per class.  
% INPUT: LID (integer) per rorad link. unique ID number (match the META file)


% NILU: Apr 2018: Henrik Grythe 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fname='/storage/home/heg/Documents/EMISSIONS/Plot_Stavanger/test_area_traffic_PM25.txt'
[nCl,nLine]   = size(EM);
[nC,   hrs]   = size(TV);

if nCl ~= nC
   error('Dimensions of linesources and TV not consistent') 
end

scale=1/3600;
% START WRITING FILE
fid=fopen(fname,'w');
% HEADER
fprintf(fid,'%38s\n',episode_id);
fprintf(fid,'* %3s %5s %10s %10s\n','HR','IQLVV','QL1V','QL2V');
%fprintf(fid,'* %5u\n',nLine);
%fprintf('%11.3e %11.3e\n',EM(1,1)*scale*TV(1,1))/2,EM(1,1));

%  One line for each emission, containing hour linkID and Emission x2??????
for h=1:hrs
    for li=1:nLine
        E=0;
        for cl=1:nC
            E=E + (EM(cl,li)*scale*TV(cl,h))/2;
        end
        QL2V=E;
        print_data=[h;LID(li);QL2V';QL2V'];
        fprintf(fid,'%5u %5u %11.3e %11.3e\n',print_data);
    end
    if rem(h,500)==0;    fprintf('Hour: %i\n',h); end
end
fprintf('WROTE file: %s\n',fname)
fclose(fid);

end
