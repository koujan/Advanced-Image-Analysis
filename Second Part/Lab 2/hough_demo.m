clear all;

c=imread('cameraman.tif');

edges=edge(c,'canny');

figure,
imshow(edges);

hc=hough(c);

figure,
imshow(mat2gray(hc)*1.5)

[r,theta]=find(hc>90);

c2=imadd(imdivide(c,4),192);

line1 = 9;
line2 = 5;
figure,
imshow(c2)
houghline(c,r(line1),theta(line1))
houghline(c,r(line2),theta(line2))


