function [Wm]=DWT_matrix(m,coff)
    % m is the number of rows/columns of the image of interest
    % There is a function in Matlab for Daubechies Coefficients: dbaux(N,sqrt(2))
    W1=zeros(m/2,m);
    if(coff==4)
        h=[(1-sqrt(3))/(4*sqrt(2)),(3-sqrt(3))/(4*sqrt(2)),(3+sqrt(3))/(4*sqrt(2)),(1+sqrt(3))/(4*sqrt(2))];
        W1(1,1:4)=h;
    elseif(coff==6)
        h=[0.332671,0.806892,0.459878,-0.135011,-0.085441,0.035226];
        W1(1,1:6)=h;
    end
    
    for i=2:m/2
        W1(i,:)=circshift(W1(i-1,:),2,2);
    end
    W2=zeros(m/2,m);
    if(coff==4)
        W2(1,1:4)=[h(4),-h(3),h(2),-h(1)];
    elseif(coff==6)
        W2(1,1:6)=[h(6),-h(5),h(4),-h(3),h(2),-h(1)];
    end
    for i=2:m/2
        W2(i,:)=circshift(W2(i-1,:),2,2);
    end

    Wm=double([W1;W2]);
end
