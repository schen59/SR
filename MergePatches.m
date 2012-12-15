function out_img = MergePatches(patches, overlap_size, img_H,img_W)
patch_dim = size(patches, 1);
patch_size = sqrt(patch_dim);
half_patch_size = (patch_size-1) / 2;
interval_size = patch_size - overlap_size;
pad_img_H = img_H + patch_size;
pad_img_W = img_W + patch_size;
pad_out_img = zeros(pad_img_H, pad_img_W);
gaussian_kernel = fspecial('gaussian', patch_size, 1);
weight = zeros(pad_img_H, pad_img_W);
[patches_x patches_y] = meshgrid(1+half_patch_size:interval_size:pad_img_W-half_patch_size, ...
                             1+half_patch_size:interval_size:pad_img_H-half_patch_size);
[h w] = size(patches_x);
patch_idx = 1;
for j = 1:w
    for i = 1:h
        patch_x = patches_x(i,j);
        patch_y = patches_y(i,j);
        x_idx = patch_x-half_patch_size:patch_x+half_patch_size;
        y_idx = patch_y-half_patch_size:patch_y+half_patch_size;
        pad_out_img(y_idx, x_idx) = pad_out_img(y_idx, x_idx) + reshape(patches(:, patch_idx), [patch_size patch_size]).*gaussian_kernel;
        weight(y_idx, x_idx) = weight(y_idx, x_idx) + gaussian_kernel;
        patch_idx = patch_idx + 1;
    end
end
index = (pad_out_img == 0);
pad_out_img = pad_out_img./weight;
pad_out_img(index) = 0;
out_img = pad_out_img(1:img_H, 1:img_W);