% Lab 4
im=imread('images/cameraman.tif');
h = fspecial('motion');  % translation-invariant bluring kernel 
f = im2double(imread('cameraman.tif'));
% Add Gaussian noise, with zero mean and
% std dev = 1 graylevel
noise = (1/255)*randn(size(f));
h = fspecial('motion',15,45);
Blurred = imfilter(f,h,'circular');
g = Blurred + noise;
imshow(g,[]), title('g = Blurred and Noisy');
% True noise-to-signal ratio
K = sum(noise(:).^2)/sum(f(:).^2);
fprintf('K = %f\n', K);
% Estimated noise-to-signal ratio
K = sum(noise(:).^2)/sum(g(:).^2);
fprintf('K = %f\n', K);
figure, imshow(deconvwnr(g,h,K),[]);
title('deconvwnr(g,h,K)');
