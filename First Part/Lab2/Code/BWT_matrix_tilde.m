function [Wm]=BWT_matrix_tilde(m)
    W1=zeros(m/2,m);
    W1(1,1:2)=[1/2,1/4];
    W1(1,end)=1/4;
    for i=2:m/2
        W1(i,:)=circshift(W1(i-1,:),2,2);
    end
    W2=zeros(m/2,m);
    W2(1,1:4)=[1/4,-3/4,1/4,1/8];
    W2(1,end)=1/8;
    for i=2:m/2
        W2(i,:)=circshift(W2(i-1,:),2,2);
    end
    Wm=double(sqrt(2)*[W1;W2]);
end
