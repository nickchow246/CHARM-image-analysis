function image = scale_stack(image, parameters_optimized)
    E_to_S = parameters_optimized(1);
    S_to_E = parameters_optimized(2);
    scale_E = parameters_optimized(3);
    scale_S = parameters_optimized(4);
    image = double(image);
    
    [num_y, num_x, num_z, num_c] = size(image);
    
    % Iterate over each z-plane
    for z = 1:num_z
        % Extract E and S channels for the current plane
        E = image(:,:,z,1);
        S = image(:,:,z,2);
        
        % Resolve crosstalk
        E_crosstalk = E * E_to_S;
        S_crosstalk = S * S_to_E;
        E = E - S_crosstalk;
        S = S - E_crosstalk;
        E = max(E, 0);
        S = max(S, 0);
    
        % Scale the channels
        E = E * scale_E;
        S = S * scale_S;
        
        % Store the scaled E and S channels back in the image stack
        image(:,:,z,1) = E;
        image(:,:,z,2) = S;
    end
end