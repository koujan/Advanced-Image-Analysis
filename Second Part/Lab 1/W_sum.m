function [W]=W_sum(I,x,y,k)
W=0;
    for i=-1:1
        for j=-1:1
            W=W+exp(-k*abs(I(x,y)-I(x+i,y+j)));
        end
    end
end
