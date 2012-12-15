%super resolving an image through back projection
function outputImg = BackProjection(highResImg, lowResImg, scale_level)
iter = 3;
gaussian_h = 5 ;
gaussian_w = 5 ;
factor = power(2, 1/3);
sigma = power(factor, scale_level)/3;
%sigma = 0.5;
psf = fspecial('gaussian', [gaussian_h gaussian_w], sigma);
for i = 1:iter
    bluredImg = imfilter(highResImg, psf, 'symmetric');
    downSampledImg = imresize(bluredImg, size(lowResImg), 'bicubic');
    diffImg = lowResImg - downSampledImg;
    upsampledDiffImg = imresize(diffImg, size(highResImg), 'bicubic');
    bluredDiffImg = imfilter(upsampledDiffImg, psf', 'symmetric');
    highResImg = highResImg + 0.5*bluredDiffImg;
end
outputImg = highResImg;