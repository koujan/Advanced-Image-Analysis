clear all; close all; clc;

% im = imread('images/lena.png');
% im = imread('images/trui.tif');
I = imread('images/cameraman.tif');
% im = imread('images/barbara.tif');
% Note: "im2double" makes image range 0..1
I = im2double(I(:,:,1));

%%% Add noise
std_n=0.05; % Gaussian noise standard deviation
noise = randn(size(I))*std_n; % White Gaussian noise
f = I + noise;  % noisy input image

figure,imshow(I),title(['original']);
figure,imshow(f),title(['noisy']);
%%%%%%%%%% my part %%%%%%%%%%%%
%[f1,f2]=gradient(f);
[n,m] = size(f);
f1 = (f(:,[2:n n])-f(:,[1 1:n-1]))/2;
f2 = (f([2:m m],:)-f([1 1:m-1],:))/2;

%%%%%%%%%%%%%%%%%%%%%%%%%
u = f1;


[n,m] = size(f1);

lambda = 10;
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
      u1 = u + dt*curv + dt*(f1-u)*lambda;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = f2;


[n,m] = size(f2);

lambda = 10;
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
      u2 = u + dt*curv + dt*(f2-u)*lambda;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[img_direct] = poisson_solver_function(u1,u2,f);
figure,imshow(img_direct),title('tv-diffused');


