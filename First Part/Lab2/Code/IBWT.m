function [inv_im]=IBWT(bwt_im,nIter)
    for c=1:nIter
        m=size(bwt_im,1)/2^(nIter-c);
        n=size(bwt_im,2)/2^(nIter-c);
        [Wm]=BWT_matrix(m);
        [Wn]=BWT_matrix_tilde(n);
        inv_im=Wm'*bwt_im(1:m,1:n)*Wn;
        bwt_im(1:m,1:n)=inv_im;
    end
    figure;imagesc(inv_im);colormap(gray);title('Inverse BWT image');
end
