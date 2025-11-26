function display_crosstalk_try(brightest_plane, base_parameters, crosstalk_parameters, zoom_factor)
    % Extract base parameter values
    E_to_S_base = base_parameters(1);
    S_to_E_base = base_parameters(2);
    scale_E_base = base_parameters(3);
    scale_S_base = base_parameters(4);
    
    % Extract crosstalk parameter values
    E_to_S_try = crosstalk_parameters(1, :);
    S_to_E_try = crosstalk_parameters(2, :);
    
    figure;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);  % Full-screen display
    
    % Adjust the spacing between subplots
    subplot_gap = 0.03;
    subplot_width = (1 - subplot_gap * 6) / 5;
    subplot_height = (1 - subplot_gap * 5) / 4;
    
    % Vary E_to_S (1st row)
    for i = 1:numel(E_to_S_try)
        parameters = [E_to_S_try(i), S_to_E_base, 0, scale_S_base];
        converted_image = convert_crosstalk_plane(brightest_plane, parameters);
        subplot('Position', [subplot_gap + (i-1)*(subplot_width+subplot_gap), subplot_height*3+4*subplot_gap, subplot_width, subplot_height]);
        imshow(converted_image);
        
        if i == 1
            title('Original confocal image (i.e. E to S = 0.0)', 'FontSize', 10);
        else
            title(sprintf('E to S: %.1f', E_to_S_try(i)), 'FontSize', 10);
        end
        
        zoom_middle(zoom_factor);
    end
    
    % Vary S_to_E (2nd row)
    for i = 1:numel(S_to_E_try)
        parameters = [E_to_S_base, S_to_E_try(i), scale_E_base, 0];
        converted_image = convert_crosstalk_plane(brightest_plane, parameters);
        subplot('Position', [subplot_gap + (i-1)*(subplot_width+subplot_gap), subplot_height*2+3*subplot_gap, subplot_width, subplot_height]);
        imshow(converted_image);
        
        if i == 1
            title('Original confocal image (i.e. S to E = 0.0)', 'FontSize', 10);
        else
            title(sprintf('S to E: %.1f', S_to_E_try(i)), 'FontSize', 10);
        end
        
        zoom_middle(zoom_factor);
    end
    
    % Vary E_to_S (3rd row)
    for i = 1:numel(E_to_S_try)
        parameters = [E_to_S_try(i), S_to_E_base, 0, scale_S_base];
        converted_image = convert_RGB_plane(brightest_plane, parameters);
        subplot('Position', [subplot_gap + (i-1)*(subplot_width+subplot_gap), subplot_height+2*subplot_gap, subplot_width, subplot_height]);
        imshow(converted_image);
        
        if i == 1
            title('Original confocal image (i.e. E to S = 0.0)', 'FontSize', 10);
        else
            title(sprintf('E to S: %.1f', E_to_S_try(i)), 'FontSize', 10);
        end
        
        zoom_middle(zoom_factor);
    end
    
    % Vary S_to_E (4th row)
    for i = 1:numel(S_to_E_try)
        parameters = [E_to_S_base, S_to_E_try(i), scale_E_base, 0];
        converted_image = convert_RGB_plane(brightest_plane, parameters);
        subplot('Position', [subplot_gap + (i-1)*(subplot_width+subplot_gap), subplot_gap, subplot_width, subplot_height]);
        imshow(converted_image);
        
        if i == 1
            title('Original confocal image (i.e. S to E = 0.0)', 'FontSize', 10);
        else
            title(sprintf('S to E: %.1f', S_to_E_try(i)), 'FontSize', 10);
        end
        
        zoom_middle(zoom_factor);
    end
end

function zoom_middle(zoom_factor)
    xlim_val = xlim;
    ylim_val = ylim;
    x_center = mean(xlim_val);
    y_center = mean(ylim_val);
    x_half_range = diff(xlim_val) / (2 * zoom_factor);
    y_half_range = diff(ylim_val) / (2 * zoom_factor);
    xlim([x_center - x_half_range, x_center + x_half_range]);
    ylim([y_center - y_half_range, y_center + y_half_range]);
end

function crosstalkPlane = convert_crosstalk_plane(brightest_plane, parameters)
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
    
    % Create the RGB plane
    crosstalkPlane = E + S;
end