function display_first_plane(image, custom_title)
    % Get the first plane (Z-section) from the image stack
    first_plane = squeeze(image(:, :, 1, :));
    
    % Get the number of channels in the first plane
    num_channels = size(first_plane, 3);
    
    % Create a figure to display the channels
    figure;
    
    for c = 1:num_channels
        % Get the current channel from the first plane
        channel = first_plane(:, :, c);
        
        % Display the channel in a subplot
        subplot(1, num_channels, c);
        imshow(channel, []);
        title(sprintf('Channel %d', c));
    end
    
    % Add the custom title to the figure
    sgtitle(custom_title);
end