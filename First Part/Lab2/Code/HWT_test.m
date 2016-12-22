%%% HWT: naive and optimal quantization


%%%%%%%%%%%%%     naive       %%%%%%%%%%%%%%%%

clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
nIter=3;
[hwt_im]=HWT(im,nIter);
nb_levels=[10:10:100];
MSE_hwt_na=zeros(1,length(nb_levels));
PSNR_hwt_na=zeros(1,length(nb_levels));
for i=1:length(nb_levels)
    im_out=quant_naive(hwt_im,nb_levels(i));
    [inv_im]=IHWT(im_out,nIter);
    MSE_hwt_na(i)=mean(mean((im-inv_im).^2));
    PSNR_hwt_na(i)=10*log10(max(max(im))^2/MSE_hwt_na(i));
end
% figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct_na(end))]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar

%% %%%%%%%%%%%%%     Optimal       %%%%%%%%%%%%%%%%
clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
nIter=2;
[hwt_im]=HWT(im,nIter);
nb_levels=[10:90:100];
MSE_hwt_op=zeros(1,length(nb_levels));
PSNR_hwt_op=zeros(1,length(nb_levels));
for i=1:length(nb_levels)
    [PARTITION, CODEBOOK]=lloyds(hwt_im(:), nb_levels(i));
    [~,quan_im] = quantiz(hwt_im(:), PARTITION, CODEBOOK);
    [inv_im]=IHWT(reshape(quan_im,[size(im,1) size(im,2)]),nIter);
    MSE_hwt_op(i)=mean(mean((im-inv_im).^2));
    PSNR_hwt_op(i)=10*log10(max(max(im))^2/MSE_hwt_op(i));
    subplot(1,2,i);imagesc(inv_im);colormap(gray);title(['Iterative HWT, nb-levels=',num2str(nb_levels(i))]);
end
% figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct_na(end))]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar
%save(['HWT_res_',num2str(nIter)],'MSE_hwt_na','PSNR_hwt_na','MSE_hwt_op','PSNR_hwt_op');
%% Draw the metrics
load('HWT_res_2');
nb_levels=[10:10:100];
plot(nb_levels,MSE_hwt_na,'-bo');hold on;
plot(nb_levels,PSNR_hwt_na,'-ko');
plot(nb_levels,MSE_hwt_op,'-go');
plot(nb_levels,PSNR_hwt_op,'-ro');legend('MSE-naive','PSNR-naive','MSE-optimal','PSNR-optimal');
title('Compression metrics for Iterative HWT');
