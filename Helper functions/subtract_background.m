function s_image = subtract_background(g_image, background_level)
    [num_y, num_x, num_z, num_c] = size(g_image);
    s_image = zeros(num_y, num_x, num_z, num_c);
    for c = 1:num_c
        for z = 1:num_z
            slice = squeeze(g_image(:, :, z, c));
            s_image(:, :, z, c) = max(slice - background_level * mean(slice(:)), 0);
        end
    end
end