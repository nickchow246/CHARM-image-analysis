function brightest_plane = load_brightest_plane(image, interval)
    [num_y, num_x, num_z, num_c] = size(image);
    max_combined_intensity = -Inf;
    max_index = 0;
    
    for z = 1:interval:num_z
        % Get the two-channel image for the current Z-section
        two_channel_image = squeeze(image(:, :, z, :));
        
        % Extract the individual channels
        channel_E = double(two_channel_image(:, :, 1));
        channel_S = double(two_channel_image(:, :, 2));
        
        % Perform 4-time downsampling of each channel in both X and Y directions
        downsampled_E = imresize(channel_E, 0.25);
        downsampled_S = imresize(channel_S, 0.25);
        
        % Calculate the combined intensity by summing downsampled E and S channels
        combined_intensity = sum(downsampled_E(:)) + sum(downsampled_S(:));
        
        % Update max combined intensity and index if necessary
        if combined_intensity > max_combined_intensity
            max_combined_intensity = combined_intensity;
            max_index = z;
        end
    end
    
    temp = imresize(image(:,:,max_index,1), 0.25);
    [resized_y, resized_x] = size(temp);
    brightest_plane = zeros(resized_y, resized_x, num_c);
    brightest_plane(:,:,1) = imresize(image(:,:,max_index,1), 0.25);
    brightest_plane(:,:,2) = imresize(image(:,:,max_index,2), 0.25);
end