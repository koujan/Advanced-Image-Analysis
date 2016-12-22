%%% DWT: naive and optimal quantization

%%%%%%%%%%%%%     naive       %%%%%%%%%%%%%%%%

clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
nIter=2;
coff=6;
[dwt_im]=DWT(im,nIter,coff);
nb_levels=[10:10:100];
MSE_dwt_na=zeros(1,length(nb_levels));
PSNR_dwt_na=zeros(1,length(nb_levels));
for i=1:length(nb_levels)
    im_out=quant_naive(dwt_im,nb_levels(i));
    [inv_im]=IDWT(im_out,nIter,coff);
    MSE_dwt_na(i)=mean(mean((im-inv_im).^2));
    PSNR_dwt_na(i)=10*log10(max(max(im))^2/MSE_dwt_na(i));
end
% figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct_na(end))]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar

%% %%%%%%%%%%%%%     Optimal       %%%%%%%%%%%%%%%%
clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
nIter=1;
coff=6;
[dwt_im]=DWT(im,nIter,coff);
nb_levels=[10:90:100];
MSE_dwt_op=zeros(1,length(nb_levels));
PSNR_dwt_op=zeros(1,length(nb_levels));
for i=1:length(nb_levels)
    [PARTITION, CODEBOOK]=lloyds(dwt_im(:), nb_levels(i));
    [~,quan_im] = quantiz(dwt_im(:), PARTITION, CODEBOOK);
    [inv_im]=IDWT(reshape(quan_im,[size(im,1) size(im,2)]),nIter,coff);
    MSE_dwt_op(i)=mean(mean((im-inv_im).^2));
    PSNR_dwt_op(i)=10*log10(max(max(im))^2/MSE_dwt_op(i));
    subplot(1,2,i);imagesc(inv_im);colormap(gray);title(['Db6, nb-levels=',num2str(nb_levels(i))]);
end
% figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct_na(end))]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar
%save(['DWT_res_n',num2str(nIter),'_',num2str(coff)],'MSE_dwt_na','PSNR_dwt_na','MSE_dwt_op','PSNR_dwt_op');
%% Draw the metrics
% load('DWT_res_n1_6');
% nb_levels=[10:10:100];
% plot(nb_levels,MSE_dwt_na,'-bo');hold on;
% plot(nb_levels,PSNR_dwt_na,'-ko');
% plot(nb_levels,MSE_dwt_op,'-go');
% plot(nb_levels,PSNR_dwt_op,'-ro');legend('MSE-naive','PSNR-naive','MSE-optimal','PSNR-optimal');
% title('Compression metrics for Db6');
