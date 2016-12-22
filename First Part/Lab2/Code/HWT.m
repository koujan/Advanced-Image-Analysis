function [hwt_im]=HWT(im,nIter)
    im=double(im);
    [m,n]=size(im);
    for c=1:nIter
        [Wm]=HWT_matrix(m);
        [Wn]=HWT_matrix(n);
        hwt_im(1:m,1:n)=Wm*im*Wn';
        m=m/2;
        n=n/2;
        im=hwt_im(1:m,1:n);
    end
    %figure;imagesc(hwt_im);colormap(gray);title('HWT image');
end