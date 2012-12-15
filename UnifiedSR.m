tic
img_name = 'text_2.bmp';
low_Img_Color = imread(img_name);
factor = power(2, 1/3);
low_Img_Color = im2single(low_Img_Color);
img_dim = ndims(low_Img_Color);
if img_dim == 2
    low_Img_luminance = low_Img_Color;
else
    [low_Img_luminance low_Img_chrominance] = decomposeImage(low_Img_Color);
end
[low_H low_W] = size(low_Img_luminance);
high_H = round(power(factor, 3) * low_H);
high_W = round(power(factor, 3) * low_W);
high_Img = imresize(low_Img_Color, [high_H high_W], 'bilinear');
patch_H = 5;
patch_W = 5;
patch_Dim = patch_H * patch_W;
high_Img_luminance = low_Img_luminance;
low_database = [];
high_database = [];

high_H = low_H;
high_W = low_W;
neighbor_num = 9;
avg_kernel = fspecial('average', [2 2]);
for i = 1:3
    i
    [new_low_database new_high_database] = GenerateDatabase(high_Img_luminance);
    low_database = [low_database';new_low_database']';
    high_database = [high_database';new_high_database']';
    anno = ann(low_database);
    high_H = round(high_H * power(factor, 1));
    high_W = round(high_W * power(factor, 1));
    cur_high_img = imresize(high_Img_luminance, [high_H high_W], 'bicubic');
    %cur_high_img_blur = imfilter(cur_high_img, avg_kernel, 'symmetric');
    %high_Img_Patches = Img2Patches(cur_high_img, patch_H, patch_W);
    high_Img_Patches = ExtractPatches(cur_high_img, patch_H, 1);
    %high_Img_Patches_Blur = Img2Patches(cur_high_img_blur, patch_H, patch_W);
    %cur_good_dist = sum(power(high_Img_Patches-high_Img_Patches_Blur, 2));
    patch_mean = mean(high_Img_Patches);
    high_Img_Patches = high_Img_Patches - repmat(patch_mean, [patch_Dim 1]);
    patches_num = size(high_Img_Patches,2);
    [idx dst] = ksearch(anno, high_Img_Patches, neighbor_num, 0.5,[false]);
    %good_dst_idx = find(dst > repmat(cur_good_dist, [neighbor_num 1]));
    weight = exp(-dst*0.25);
    %weight(good_dst_idx) = 0.01;
    weight = weight./repmat(sum(weight),[neighbor_num 1]);
    weighted_patch = high_database(:,idx).*repmat(weight(:)',[patch_Dim 1]);
    result_patches = (reshape(sum(reshape(weighted_patch',[neighbor_num patches_num*patch_Dim])),[patches_num patch_Dim]))' + ...
                 repmat(patch_mean,[patch_Dim 1]);
    %high_Img_luminance = reshape(high_Pixel, size(cur_high_img));
    [cur_img_H cur_img_W] = size(cur_high_img);
    high_Img_luminance = MergePatches(result_patches, 1, cur_img_H, cur_img_W);
    high_Img_luminance = BackProjection(high_Img_luminance, low_Img_luminance, i);
    anno = close(anno);
end
if img_dim == 2
    high_Img_Color = high_Img_luminance;
else
    high_Img_chrominance = imresize(low_Img_chrominance, size(high_Img_luminance), 'bicubic');
    high_Img_Color = composeImage(high_Img_luminance, high_Img_chrominance);
end
toc
figure;
imshow(high_Img_Color);
imwrite(high_Img_Color, strcat('USR_2X_',img_name));
figure;
imshow(high_Img);
imwrite(high_Img, strcat('bicubic_2X_',img_name));

    