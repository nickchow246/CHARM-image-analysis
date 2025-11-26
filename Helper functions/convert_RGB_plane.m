function rgbPlane = convert_RGB_plane(brightest_plane, parameters)
    % Unpack the parameters
    E_to_S = parameters(1);
    S_to_E = parameters(2);
    scale_E = parameters(3);
    scale_S = parameters(4);
    
    % Extract the individual channels from the brightest plane
    E = double(brightest_plane(:, :, 1));
    S = double(brightest_plane(:, :, 2));
    
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
    
    % Divide E and S channels by 255
    E = E / 65535;
    S = S / 65535;
    
    % Apply the conversion formula using vectorization
    R = 10.^(-0.644 * S - 0.093 * E);
    G = 10.^(-0.717 * S - 0.954 * E);
    B = 10.^(-0.267 * S - 0.283 * E);
    
    % Create the RGB plane
    rgbPlane = cat(3, R, G, B);
end