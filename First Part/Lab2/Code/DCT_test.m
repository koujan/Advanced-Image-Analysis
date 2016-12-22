%%% DCT: naive and optimal quantization

%%%%%%%%%%%%%     naive       %%%%%%%%%%%%%%%%

clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
[dct_im]=dct2(im);
nb_levels=[10:10:100];
MSE_dct_na=zeros(1,length(nb_levels));
PSNR_dct_na=zeros(1,length(nb_levels));
for i=1:length(nb_levels)
    im_out=quant_naive(dct_im,nb_levels(i));
    [inv_im]=idct2(im_out);
    MSE_dct_na(i)=mean(mean((im-inv_im).^2));
    PSNR_dct_na(i)=10*log10(max(max(im))^2/MSE_dct_na(i));
end
% figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct_na(end))]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar

%% %%%%%%%%%%%%%     Optimal       %%%%%%%%%%%%%%%%
clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
[dct_im]=dct2(im);
nb_levels=[10:90:100];
MSE_dct_op=zeros(1,length(nb_levels));
PSNR_dct_op=zeros(1,length(nb_levels));
for i=1:length(nb_levels)
    [PARTITION, CODEBOOK]=lloyds(dct_im(:), nb_levels(i));
    [~,quan_im] = quantiz(dct_im(:), PARTITION, CODEBOOK);
    [inv_im]=idct2(reshape(quan_im,[size(im,1) size(im,2)]));
    MSE_dct_op(i)=mean(mean((im-inv_im).^2));
    PSNR_dct_op(i)=10*log10(max(max(im))^2/MSE_dct_op(i));
    subplot(1,2,i);imagesc(inv_im);colormap(gray);title(['DCT, nb_levels=',num2str(nb_levels(i))]);
end
% figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct_na(end))]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar
%save('DCT_res','MSE_dct_na','PSNR_dct_na','MSE_dct_op','PSNR_dct_op');
%% Draw the metrics
% load('DCT_res');
% nb_levels=[10:10:100];
% plot(nb_levels,MSE_dct_na,'-bo');hold on;
% plot(nb_levels,PSNR_dct_na,'-ko');
% plot(nb_levels,MSE_dct_op,'-go');
% plot(nb_levels,PSNR_dct_op,'-ro');legend('MSE-naive','PSNR-naive','MSE-optimal','PSNR-optimal');
% title('Compression metrics for DCT');



