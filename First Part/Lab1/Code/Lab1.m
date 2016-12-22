% Lab1 Advanced Image Analysis

im=imread('images/circuit.tif');
subplot(1,2,1);imagesc(im);axis image;title('Circuit image');colormap(gray)
%im_out=phase_only(im);colormap(gray);
%%%%%%%%
imafft = fft2(im);
% Now use only the phase
newfft = imafft./abs(imafft);
%newfft = exp(i.*angle(imafft)); Alternative way of implementing the
%previous line, edited by me
ima_out = ifft2(newfft);
subplot(1,2,2);imagesc(abs(ima_out));axis image;title('Phase only image');colormap(gray)

%% adding phase noise
ima = imread('images/lena.bmp');
imafft = fft2(ima);
subplot(1,2,1);imagesc(ima);colormap(gray);axis image;title('Lena image');
% Gets magnitude and phase.
mag = abs(imafft);
phi = angle(imafft);
s = size(ima);
rand_phase = 4*pi*(rand(s(1),s(2))-0.5);  %random phase between 0 and 2pi
% Generates the modified spectrum
newfft = mag.*exp(i*rand_phase);

ima_out = ifft2(newfft);

subplot(1,2,2);colormap(gray);
imagesc(abs(ima_out));
axis image;
title('Random phase image');
%phase is more critical in reconstruction

%% adding magnitude noise
ima = imread('images/sar.bmp');
subplot(1,2,1);colormap(gray);imagesc(ima);colormap(gray);axis image;title('SAR image');
% Get fourier transform first
imafft = fft2(ima);

% Gets magnitude and phase.
mag = abs(imafft);
maxm = max(max(mag));
phi = angle(imafft);
s = size(ima);
rand_mag = maxm*rand(s(1),s(2));

% Generates the modified spectrum
newfft = rand_mag.*exp(i*phi);

ima_out = ifft2(newfft);

subplot(1,2,2);colormap(gray);imagesc(abs(ima_out));
axis image;
title('Random magnitude version');

%% Simple filtering
ima=imread('images/lena.gif');colormap(gray)
SimpleFiltering(ima,0,0.2)
colormap(gray)

%% FFT
im=imread('images/lena.gif');
[i,j]=meshgrid((1:size(im,1)),(1:size(im,2)));
shift=(-1).^(i+j);
im=double(im);
im_shifted=shift.*im;
[u,x]=meshgrid(0:size(im,1)-1);
w1=exp(-1i*2/size(im,1)*pi*u.*x);
[v,y]=meshgrid(0:size(im,2)-1);
w2=exp(-1i*2/size(im,2)*pi*v.*y);
fft_im=w1*im_shifted*w2;
mag=abs(fft_im);
subplot(2,3,1);imagesc(im);title('Original image');colormap(gray)
subplot(2,3,2);imagesc(log(1+mag));title('Magnitude spectrum');colormap(gray)
subplot(2,3,3);imagesc(angle(fft_im));title('Phase spectrum');colormap(gray)
% create the filter, which is of a Butterworth type
for i=1:size(im,1)
    for j=1:size(im,2)
        D(i,j)=sqrt((i-1-size(im,1)/2)^2+(j-1-size(im,2)/2).^2);
    end
end
cutoff=30;
n=10;
filter=1./(1+(D/cutoff).^(2*n));
filtered_im=fft_im.*filter;
subplot(2,3,4);imagesc(log(1+filter));title('Low pass filter');colormap(gray)
mag_filtered=abs(filtered_im);
subplot(2,3,5);imagesc(log(1+mag_filtered));title('Magnitude specturm of the filtered image');colormap(gray)
%orig_im=ifft2(filtered_im);
orig_im=w1.^(-1)*filtered_im*w2.^(-1);
orig_im=shift.*orig_im;
subplot(2,3,6);imagesc(real(orig_im));title('filtered image');colormap(gray)

%% Fourier spectrum and average value
im=imread('ImageA.TIF');
subplot(1,3,1);imagesc(im);title('original image');colormap(gray)
[i,j]=meshgrid((1:size(im,1)),(1:size(im,2)));
shift=(-1).^(i+j);
im=double(im);
im_shifted=shift.*im;
fft_im=fft2(im_shifted);
subplot(1,3,2);imagesc(log(1+abs(fft2(im))));title('magnitude spectrum befor centering');colormap(gray)
subplot(1,3,3);imagesc(log(1+abs(fft_im)));title('magnitude spectrum after centering');colormap(gray)
%subplot(1,3,3);imagesc(angle(fft_im));title('phase spectrum');colormap(gray)
% compute the mean of the image 
fft_im(size(im,1)/2+1,size(im,2)/2+1)*1/(size(im,1)*size(im,2))

%% Compression and DCT
im=imread('images/circuit.tif');
[ima,imafft,mag_quant,phi_quant] = quant_fft(im,1000,1000,128);
colormap(gray);



