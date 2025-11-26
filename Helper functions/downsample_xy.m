function outimage = downsample_xy(image, downsample_xy_factor)
    channel1 = imresize3(image(:, :, :, 1), [size(image, 1) / downsample_xy_factor, ...
        size(image, 2) / downsample_xy_factor, size(image, 3)]);
    channel2 = imresize3(image(:, :, :, 2), [size(image, 1) / downsample_xy_factor, ...
        size(image, 2) / downsample_xy_factor, size(image, 3)]);
    outimage = cat(4, channel1, channel2);
end