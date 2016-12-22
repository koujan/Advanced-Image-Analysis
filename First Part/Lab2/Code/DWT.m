function [dwt_im]=DWT(im,nIter,coff)
    im=double(im);
    [m,n]=size(im);
    for c=1:nIter
        [Wm]=DWT_matrix(m,coff);
        [Wn]=DWT_matrix(n,coff);
        dwt_im(1:m,1:n)=Wm*im*Wn';
        m=m/2;
        n=n/2;
        im=dwt_im(1:m,1:n);
    end
    %figure;imagesc(dwt_im);colormap(gray);title('DWT image');
end