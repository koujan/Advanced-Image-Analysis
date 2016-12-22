function [inv_im]=IDWT(dwt_im,nIter,coff)
    for c=1:nIter
        m=size(dwt_im,1)/2^(nIter-c);
        n=size(dwt_im,2)/2^(nIter-c);
        [Wm]=DWT_matrix(m,coff);
        [Wn]=DWT_matrix(n,coff);
        inv_im=Wm'*dwt_im(1:m,1:n)*Wn;
        dwt_im(1:m,1:n)=inv_im;
    end
    %figure;imagesc(inv_im);colormap(gray);title('Inverse DWT image');
end
