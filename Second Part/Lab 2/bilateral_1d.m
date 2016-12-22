n=1:1:500; % Generate a vector from 1 to 500; the increment is 1.

I0=zeros(size(n)); % Generate a vector of zeros; the size of the vector is equal to the size of n.
I0(1:250)=15; I0(251:end)=10; % Set the first 250 values to 15, and the rest to 10.

I_noisy = I0 + 1.7*randn(size(I0)); % 0.5 is the standard deviation of the noise
figure; 
subplot(2,1,1); plot(n,I0); axis ([190 310 6 18]); title('Original signal');
subplot(2,1,2); plot(n,I_noisy); axis ([190 310 6 18]); title('Noisy signal');

sigma_d=10; 
N=round(4*sigma_d); % N determines the spatial neighborhood
sigma_r=1.3;

d = -N:1:N;
weights_d = exp(-d.*d/(2*sigma_d*sigma_d));

x=260; % An example
pixels = I_noisy(x-N:x+N); % Put the pixels within the neighborhood of the center pixel into a vector.
weights = weights_d .* exp(-(pixels-I_noisy(x)).*(pixels-I_noisy(x))/(2*sigma_r*sigma_r)) + 0.0001;

weights = weights./sum(weights);

figure; plot([x-N:x+N],weights); title(['weights for point x=',num2str(x)]);

% Repeat for all pixels

I_output = I_noisy;
I = I_noisy;
niter = 5;

for iter=1:niter,
  for i=1+N:length(I)-N, % Be careful with the borders; do not exceed the dimensions.
     pixels = I(i-N:i+N);
     weights = weights_d .* exp(-(pixels-I(i)).*(pixels-I(i))/(2*sigma_r*sigma_r)) + 0.0001;
     weights = weights./sum(weights);
     I_output(i) = sum(weights.*pixels);
  end
  I = I_output;
end

figure; 
subplot(3,1,1); plot(n,I0); axis ([190 310 6 18]); title('Original signal');
subplot(3,1,2); plot(n,I_noisy); axis ([190 310 6 18]); title('Noisy signal');
subplot(3,1,3); plot(n,I_output); axis ([190 310 6 18]); title(['Smoothed signal after ',num2str(niter),' iterations']);

