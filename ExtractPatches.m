function patches = ExtractPatches(src_img, patch_size, overlap_size)
interval_size = patch_size-overlap_size;
patch_dim = (patch_size-1) / 2;
[src_H src_W] = size(src_img);
pad_src_img = padarray(src_img, [patch_size patch_size], 'symmetric', 'post');

[pad_src_H pad_src_W] = size(pad_src_img);
[patches_x patches_y] = meshgrid(1+patch_dim:interval_size:pad_src_W-patch_dim, 1+patch_dim:interval_size:pad_src_H-patch_dim);
[patch_x patch_y] = meshgrid(-patch_dim:patch_dim, -patch_dim:patch_dim);
patches_num = numel(patches_x);
patch_num = numel(patch_x);
patches_xx = repmat(patch_x(:)', [patches_num 1]) + repmat(patches_x(:), [1 patch_num]);
patches_yy = repmat(patch_y(:)', [patches_num 1]) + repmat(patches_y(:), [1 patch_num]);
patches_index = sub2ind([pad_src_H pad_src_W], patches_yy(:), patches_xx(:));
patches = reshape(pad_src_img(patches_index), [patches_num patch_num]);
patches = patches';

