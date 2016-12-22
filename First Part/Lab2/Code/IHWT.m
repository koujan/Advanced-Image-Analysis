function [inv_im]=IHWT(hwt_im,nIter)
    for c=1:nIter
        m=size(hwt_im,1)/2^(nIter-c);
        n=size(hwt_im,2)/2^(nIter-c);
        [Wm]=HWT_matrix(m);
        [Wn]=HWT_matrix(n);
        inv_im=Wm'*hwt_im(1:m,1:n)*Wn;
        hwt_im(1:m,1:n)=inv_im;
    end
    %figure;imagesc(inv_im);colormap(gray);title('Inverse HWT image');
end