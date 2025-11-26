function blurred_image = gaussian_blur_3d(image, sigma_xy, sigma_z)
    [num_y, num_x, num_z, num_c] = size(image);
    blurred_image = zeros(num_y, num_x, num_z, num_c);
    
    for c = 1:num_c
        channel_stack = squeeze(image(:, :, :, c));
        blurred_channel_stack = imgaussfilt3(channel_stack, [sigma_xy, sigma_xy, sigma_z]);
        blurred_image(:, :, :, c) = blurred_channel_stack;
    end
end