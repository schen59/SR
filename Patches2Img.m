function out_img = Patches2Img(img_H, img_W, patches, patch_size, overlap_size)
interval_size = patch_size - overlap_size;
pad_img_H = img_H + patch_size - mod(img_H, interval_size);
pad_img_W = img_W + patch_size - mod(img_W, interval_size);
out_img = zeros(pad_img_H, pad_img_W);
is_filled = zeros(pad_img_H, pad_img_W);

patch_dim = (patch_size-1) / 2;
[patches_x patches_y] = meshgrid(1+patch_dim:interval_size:img_W-patch_dim, 1+patch_dim:interval_size:img_H-patch_dim);
gaussian_kernel = fspecial('gaussian', patch_size, 1);
weight_1 = zeros(patch_size);
weight_2 = ones(patch_size);
if overlap_size ~= 0
    weight_1(1:overlap_size,:) = gaussian_kernel(patch_size -overlap_size+1:patch_size,:);
    weight_1(:,1:overlap_size) = gaussian_kernel(:,patch_size -overlap_size+1:patch_size);
    weight_2(1:overlap_size,:) = gaussian_kernel(1:overlap_size,:);
    weight_2(:,1:overlap_size) = gaussian_kernel(:, 1:overlap_size);
end



[h w] = size(patches_x);
patch_idx = 1;
for i = 1:w
    for j = 1:h
        x_0 = patches_x(i,j);
        y_0 = patches_y(i,j);
        patch_filled = is_filled(y_0 - patch_dim:y_0+patch_dim, x_0-patch_dim:x_0+patch_dim);
        old_patch = out_img(y_0 - patch_dim:y_0+patch_dim, x_0-patch_dim:x_0+patch_dim);
        weight_11 = patch_filled.*weight_1;
        sum_weight = weight_11 + weight_2;
        weight_11 = weight_11./sum_weight;
        weight_22 = weight_2./sum_weight;
        new_patch = old_patch.*weight_11 + reshape(patches(:,patch_idx), [patch_size patch_size]).*weight_22;
        out_img(y_0 - patch_dim:y_0+patch_dim, x_0-patch_dim:x_0+patch_dim) = new_patch;
        is_filled(y_0 - patch_dim:y_0+patch_dim, x_0-patch_dim:x_0+patch_dim) = ones(patch_size);
        patch_idx = patch_idx + 1;
    end
end
out_img = out_img(1:img_H, 1:img_W);