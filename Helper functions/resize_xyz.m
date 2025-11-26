function r_image = resize_xyz(image, desired_pixel_size, pixel_size_xy, pixel_size_z)
    [num_y, num_x, num_z, num_c] = size(image);
    scale_xy = pixel_size_xy / desired_pixel_size;
    scale_z = pixel_size_z / desired_pixel_size;
    new_size = round([num_y * scale_xy, num_x * scale_xy, num_z * scale_z]);
    r_image = zeros(new_size(1), new_size(2), new_size(3), num_c, 'like', image);
    
    % Process each channel separately if multichannel
    for c = 1:num_c
        current_stack = image(:,:,:,c);
        r_image(:,:,:,c) = imresize3(current_stack, new_size, 'linear');
    end
end