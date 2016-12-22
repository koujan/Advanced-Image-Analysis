clear all; close all; clc;

% im = imread('images/lena.png');
% im = imread('images/trui.tif');
I = imread('images/cameraman.tif');
% im = imread('images/barbara.tif');
% Note: "im2double" makes image range 0..1
I = im2double(I(:,:,1));

%%% Add noise
std_n=0.08; % Gaussian noise standard deviation
noise = randn(size(I))*std_n; % White Gaussian noise
f = I + noise;  % noisy input image

figure,imshow(I),title(['original']);
figure,imshow(f),title(['noisy']);
%%%%%%%%%% my part %%%%%%%%%%%%
%[dx,dy]=gradient(f);
%f=sqrt(dx.^2+dy.^2);

%%%%%%%%%%%%%%%%%%%%%%%%%
u = f;


[n,m] = size(f);

lambda = 100;
epsilon= 0.01;
ep2 = epsilon^2;

niter = 1000; dt = 0.001; 
for i = 1:niter   
    % Computation of the tv-seminorm:
    % estimate derivatives
      ux = (u(:,[2:n n])-u(:,[1 1:n-1]))/2;
	  uy = (u([2:m m],:)-u([1 1:m-1],:))/2;
	  uxx = u(:,[2:n n])+u(:,[1 1:n-1])-2*u;
	  uyy = u([2:m m],:)+u([1 1:m-1],:)-2*u;
	  Dp = u([2:m m],[2:n n])+u([1 1:m-1],[1 1:n-1]);
	  Dm = u([1 1:m-1],[2:n n])+u([2:m m],[1 1:n-1]);
	  uxy = (Dp-Dm)/4;
    % compute flow
      Num = uxx.*(ep2+uy.^2) - 2*ux.*uy.*uxy + uyy.*(ep2+ux.^2);
      Den = (ep2+ux.^2+uy.^2).^(3/2);
      curv = Num./Den;
    % update the image
      u = u + dt*curv + dt*(f-u)*lambda;
end

figure,imshow(u),title(['tv-diffused']);


