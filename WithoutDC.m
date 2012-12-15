function out_img = WithoutDC(src_img, patch_h, patch_w)
patch_hh = (patch_h-1) / 2;
patch_ww = (patch_w-1) / 2;
pad_src_img = padarray(src_img, [patch_hh patch_ww], 'both');
[pad_src_h pad_src_w] = size(pad_src_img);
[patches_x patches_y] = meshgrid(1+patch_ww:pad_src_w-patch_ww, 1+patch_hh:pad_src_h-patch_hh);
[h w] = size(patches_x);
out_img = zeros(size(src_img));
for i = 1:h
    for j = 1:w
        x = patches_x(i,j);
        y = patches_y(i,j);
        index_x = x-patch_ww:x+patch_ww;
        index_y = y-patch_hh:y+patch_hh;
        avg = mean(mean(pad_src_img(index_y, index_x)));
        out_img(y-patch_hh,x-patch_ww) = pad_src_img(y,x)-avg;
    end
end

