%%% Non-linear averaging for image processing
clear all;
clc;
Im_orig=imread('trui.tif');
I=Im_orig;
k=0.2;
n=150;
figure;imagesc(I);colormap(gray);title('Original');
I=padarray(I,[1,1]);
I=double(I);
out=I;
for ite=1:n
    for x=2:size(I,1)-1
        for y=2:size(I,2)-1
            out_sum=0;
            Wsum=0;
            for i=-1:1
                for j=-1:1
                    Wij=exp(-k*abs(I(x,y)-I(x+i,y+j)));
                    out_sum=out_sum+Wij*I(x+i,y+j);
                    Wsum=Wsum+Wij;
                end
            end
            out(x,y)=out_sum/Wsum;
        end
    end
    I=out;
end

figure;imagesc(out);colormap(gray);title('Filtered');
out_canny_orig=edge(Im_orig,'canny');        
figure;imagesc(out_canny_orig);colormap(gray);title('out_canny_orig');

out_canny_filtered=edge(I,'canny');        
figure;imagesc(out_canny_filtered);colormap(gray);title('out_canny_filtered');










