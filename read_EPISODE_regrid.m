function [out] = read_EPISODE_regrid(ef)

em=ef.annual;
[yy, xx]=size(em);

i=1;
for y=1:yy
    for x=1:xx
        out(i)=ef.annual(y,x)*1e-6;
        i=i+1;
    end
end
end