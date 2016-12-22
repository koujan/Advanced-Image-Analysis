function [bwt_im]=BWT(im,nIter)
    im=double(im);
    [m,n]=size(im);
    for c=1:nIter
        [Wm]=BWT_matrix_tilde(m);
        [Wn]=BWT_matrix(n);
        bwt_im(1:m,1:n)=Wm*im*Wn';
        m=m/2;
        n=n/2;
        im=bwt_im(1:m,1:n);
    end
    figure;imagesc(bwt_im);colormap(gray);title('BWT image');
end