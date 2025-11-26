function correctedImage = attenuation_correction(image, exponential_E, exponential_S)
    % Get dimensions of the image stack
    [num_y, num_x, num_z, num_c] = size(image);
    
    % Initialize the corrected image stack with same size as input
    correctedImage = zeros(size(image), 'like', image);
    
    % Apply the correction factor to each plane
    for z = 1:num_z
        % Extract the individual channels for current plane
        E = double(image(:,:,z,1));
        S = double(image(:,:,z,2));
        
        % Calculate the correction factors for each channel
        correctionFactor_E = exp(-exponential_E * (z - 1));
        correctionFactor_S = exp(-exponential_S * (z - 1));
        
        % Apply the correction factors to each channel
        correctedImage(:,:,z,1) = E * correctionFactor_E;
        correctedImage(:,:,z,2) = S * correctionFactor_S;
    end
end