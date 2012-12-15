function [] = Gaussian_Pyramid(src_Img)
factor = 1.25;
src_H = size(src_Img,1);
src_W = size(src_Img,2);
for i = 1:7
    new_W = round(src_W / power(factor, i-1));
    new_H = round(src_H / power(factor, i-1));
    gaussian_k = fspecial('gaussian',[5 5], power(1.25,i-1) -1 +0.01);
    new_Img_blur = imfilter(src_Img, gaussian_k, 'symmetric');
    new_Img = imresize(new_Img_blur, [new_H new_W], 'bilinear');
    new_Img = WithoutDC(new_Img, 5,5);
    figure;
    imshow(new_Img);
    imwrite(new_Img, strcat(strcat('textture_',num2str(i)),'.jpg'));
end
    