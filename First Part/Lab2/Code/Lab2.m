% % DCT & HWT (Image Compression/Quantization)

% %% Part 1 (DCT and IDCT)
% im=imread('images/circuit.tif');
% im=double(im);
% dct_im=dct2(im);
% subplot(1,3,1);imagesc(im);colormap(gray);title('Original Image');
% subplot(1,3,2);imagesc(log(1+abs(dct_im)));colormap(gray);title('DCT Image');
% inv_im=idct2(dct_im);
% subplot(1,3,3);imagesc(inv_im);colormap(gray);title('Inverse DCT image');

% 
% %% Part 2  (2D Haar)
% function [Wm,Wn]=HWT_matrix(im)
% clear all;
% clc;
% im=imread('images/lena.gif');
% im=double(im);
% [m,n]=size(im);
% nIter=2;
% for c=1:nIter
%     [Wm]=HWT_matrix(m);
%     [Wn]=HWT_matrix(n);
%     hwt_im(1:m,1:n)=Wm*im*Wn';
%     m=m/2;
%     n=n/2;
%     im=hwt_im(1:m,1:n);
%     
% end
% figure;imagesc(hwt_im);colormap(gray);title('HWT image');
% for c=1:nIter
%     m=size(hwt_im,1)/2^(nIter-c);
%     n=size(hwt_im,2)/2^(nIter-c);
%     [Wm]=HWT_matrix(m);
%     [Wn]=HWT_matrix(n);
%     inv_im=Wm'*hwt_im(1:m,1:n)*Wn;
%     hwt_im(1:m,1:n)=inv_im;
% end
% figure;imagesc(inv_im);colormap(gray);title('Inverse HWT image');

% %% Part 3 Daubechies 
% function [Wm,Wn]=HWT_matrix(im)
% clear all;
% clc;
% im=imread('images/lena.gif');
% [m,n]=size(im);
% im=double(im);
% nIter=1;
% for c=1:nIter
%     [Wm]=DWT_matrix(m);
%     [Wn]=DWT_matrix(n);
%     dwt_im(1:m,1:n)=Wm*im*Wn';
%     m=m/2;
%     n=n/2;
%     im=dwt_im(1:m,1:n);
%     
% end
% figure;imagesc(dwt_im);colormap(gray);title('DWT image');
% for c=1:nIter
%     m=size(dwt_im,1)/2^(nIter-c);
%     n=size(dwt_im,2)/2^(nIter-c);
%     [Wm]=DWT_matrix(m);
%     [Wn]=DWT_matrix(n);
%     inv_im=Wm'*dwt_im(1:m,1:n)*Wn;
%     dwt_im(1:m,1:n)=inv_im;
% end
% figure;imagesc(inv_im);colormap(gray);title('Inverse DWT image');

%% part4 (Apply two iterations of DCT, DWT), How to apply the DCT with more than one iteration
%%%%%%%%%% Naive+DCT %%%%%%%%%%%%% test from 10 to 100 with step of 10 and
%%%%%%%%%% notice the difference, take RMSE and SNR as quantitative
%%%%%%%%%% measueres
% im=imread('images/circuit.tif');
% im=double(im);
% dct_im=dct2(im);
% max(max(dct_im))
% figure;imshow(dct_im);
% figure;imagesc(log(1+abs(dct_im)));colormap(gray);title('DCT image');colorbar
% im_out=quant_naive(dct_im,max(max(dct_im))/5);
% im_out2=quant_naive(im,36);
% MSE2=mean(mean((im-im_out2).^2));
% figure;imagesc(im_out2);colormap(gray);title(['Quantized image without DCT', ' MSE=',num2str(MSE2)]);colorbar
% inv_im=idct2(im_out);
% MSE=mean(mean((im-inv_im).^2));
% figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE)]);colorbar
% figure;imagesc(im);colormap(gray);title('Original Image');colorbar
%%                          Naive, Optimal: DCT
clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
[dct_im]=dct2(im);
max(max(dct_im))
nb_levels=round( ( max(max(dct_im))-min(min(dct_im)) )/10 );
im_out=quant_naive(dct_im,nb_levels);
im_out2=quant_naive(im,19);
figure;hist(dct_im(:),100);title('Histogram of the image in DCT domain');
figure;imhist(uint8(im_out2));title('Histogram of quantized image withOUT DCT');
MSE_orig=sum( (im(:)-im_out2(:)).^2) /(size(im,1)*size(im,2));
figure;imagesc(im_out2);colormap(gray);title(['Quantized image withOUT DCT, MSE=',num2str(MSE_orig)]);colorbar
[inv_im]=idct2(im_out);
MSE_dct=mean(mean((im-inv_im).^2));
figure;imhist(uint8(inv_im));title('Histogram of quantized DCT image');
figure;imagesc(inv_im);colormap(gray);title(['Quantized image with DCT, MSE=',num2str(MSE_dct)]);colorbar
figure;imagesc(im);colormap(gray);title('Original Image');colorbar

%% Naive+HWT
clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
nIter=3;
[hwt_im]=HWT(im,nIter);
max(max(hwt_im))
figure;hist(hwt_im(:),100);title('Histogram of the image in DCT domain');
im_out=quant_naive(hwt_im,10);
figure;imhist(uint8(im_out));title('Histogram of quantized HWT image');
im_out2=quant_naive(im,19);
figure;imhist(uint8(im_out2));title('Histogram of quantized image');
RMSE2=sqrt(mean(mean((im-im_out2).^2)));
Rmse=sqrt(sum( (im(:)-im_out2(:)).^2) /(size(im,1)*size(im,2)));
figure;imagesc(im_out2);colormap(gray);title(['Quantized image without HWT, RMSE=',num2str(Rmse)]);colorbar
[inv_im]=IHWT(im_out,nIter);
RMSE=sqrt(mean(mean((im-inv_im).^2)));
figure;imagesc(inv_im);colormap(gray);title(['Quantized image with HWT, RMSE=',num2str(RMSE)]);colorbar
figure;imagesc(im);colormap(gray);title('Original Image');colorbar
%% Optimal+DCT
im=imread('images/lena.gif');
im=double(im);
[dct_im]=dct2(im);
[PARTITION, CODEBOOK]=lloyds(dct_im(:), 20);
[~,quan_im] = quantiz(dct_im(:), PARTITION, CODEBOOK);
inv_dct=idct2(reshape(quan_im,[size(im,1) size(im,2)]));
MSE=sum( (inv_dct(:)-im(:)).^2) /(size(im,1)*size(im,2));
figure;imagesc(im);colormap(gray);title('Original Image');colorbar;
figure;imagesc(inv_dct);colormap(gray);colorbar;title(['Quantized image, RMSE=',num2str(MSE)]);
figure;imhist(uint8(inv_dct));title('Histogram of quantized DCT image');

%% Optimal HWT
clear all;
clc;
im=imread('images/circuit.tif');
im=double(im);
[dct_im]=HWT(im,1);
[PARTITION, CODEBOOK]=lloyds(dct_im(:), 30);
[~,quan_im] = quantiz(dct_im(:), PARTITION, CODEBOOK);
inv_dct=IHWT(reshape(quan_im,[size(im,1) size(im,2)]),1);
MSE=sum( (inv_dct(:)-im(:)).^2) /(size(im,1)*size(im,2));
length(unique(uint8(inv_dct)))
length(unique(uint8(im)))
figure;imagesc(im);colormap(gray);title('Original Image');colorbar;
figure;imagesc(inv_dct);colormap(gray);colorbar;title(['Quantized image, RMSE=',num2str(MSE)]);
figure;imhist(uint8(inv_dct));title('Histogram of quantized DCT image');
%% BWT
im=imread('images/lena.gif');
nIter=2;
bwt_im=DWT(im,nIter,4);
[inv_im]=IDWT(bwt_im,nIter,4);
close all;
subplot(1,3,1);imagesc(im);colormap(gray);title('Original Image');
subplot(1,3,2);imagesc(bwt_im);colormap(gray);title('BWT Image');
subplot(1,3,3);imagesc(im);colormap(gray);title('IBWT Image');
%% 2 niter DCT
im=imread('images/circuit.tif');
im=double(im);
subplot(2,2,1);imagesc(im);colormap(gray);title('Original Image');
dct_im=dct2(im);
nnz(dct_im==0)
length(unique(dct_im))
subplot(2,2,2);imagesc(log(1+abs(dct_im)));colormap(gray);title('1st iteration DCT');
dct_im=dct2(dct_im);
length(unique(dct_im))
subplot(2,2,3);imagesc(dct_im);colormap(gray);title('2nd iteration DCT');
inv=idct2(dct_im);
inv=idct2(inv);
subplot(2,2,4);imagesc(im);colormap(gray);title('Reconstructed Image');



