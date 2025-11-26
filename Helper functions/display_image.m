function display_image(image, z_index)
    % Create a figure with subplots
    figure;
    
    for i = 1:length(z_index)
        % Extract the two channels for the selected Z plane
        current_plane = image(:,:,z_index(i),:);
        
        % Convert the selected plane to RGB
        rgbImage = convert_RGB_single(current_plane);
        
        % Display the RGB image in a subplot
        subplot(1, length(z_index), i);
        imshow(rgbImage);
        title(sprintf('Z Plane %d', z_index(i)));
    end
end

function rgbImage = convert_RGB_single(plane)
    % Extract the individual channels
    E = double(plane(:,:,1));
    S = double(plane(:,:,2));
    
    % Get max value based on class of original image
    max_val = 65535;
    
    % Normalize E and S channels
    E = E / max_val;
    S = S / max_val;
    
    % Apply the conversion formula using vectorization
    R = 10.^(-0.644 * S - 0.093 * E);
    G = 10.^(-0.717 * S - 0.954 * E);
    B = 10.^(-0.267 * S - 0.283 * E);
    
    % Create the RGB image
    rgbImage = cat(3, R, G, B);
end