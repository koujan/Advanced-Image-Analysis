function [Wm]=HWT_matrix(m)
    W1=zeros(m/2,m);
    W1(1,1:2)=[1,1];
    for i=2:m/2
        W1(i,:)=circshift(W1(i-1,:),2,2);
    end

    W2=zeros(m/2,m);
    W2(1,1:2)=[-1,1];
    for i=2:m/2
        W2(i,:)=circshift(W2(i-1,:),2,2);
    end

    Wm=double([W1;W2]);
    Wm=Wm/sqrt(2);
end
