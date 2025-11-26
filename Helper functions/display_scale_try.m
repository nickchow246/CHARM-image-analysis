function display_scale_try(brightest_plane, base_parameters, try_parameters, zoom_factor)
    % Extract base parameter values
    E_to_S_base = base_parameters(1);
    S_to_E_base = base_parameters(2);
    scale_E_base = base_parameters(3);
    scale_S_base = base_parameters(4);
    
    % Extract try parameter values
    scale_E_try = try_parameters(1, :);
    scale_S_try = try_parameters(2, :);
    
    figure;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);  % Full-screen display
    
    % Adjust the spacing between subplots
    subplot_gap = 0.03;
    subplot_width = (1 - subplot_gap * 6) / 5;
    subplot_height = (1 - subplot_gap * 3) / 2;

    % Vary scale_E (1st row)
    for i = 1:numel(scale_E_try)
        parameters = [E_to_S_base, S_to_E_base, scale_E_try(i), scale_S_base];
        converted_image = convert_RGB_plane(brightest_plane, parameters);
        subplot('Position', [subplot_gap + (i-1)*(subplot_width+subplot_gap), subplot_height+2*subplot_gap, subplot_width, subplot_height]);
        imshow(converted_image);
        title(sprintf('Scale E: %.2f', scale_E_try(i)), 'FontSize', 10);
        zoom_middle(zoom_factor);
    end
    
    % Vary scale_S (2nd row)
    for i = 1:numel(scale_S_try)
        parameters = [E_to_S_base, S_to_E_base, scale_E_base, scale_S_try(i)];
        converted_image = convert_RGB_plane(brightest_plane, parameters);
        subplot('Position', [subplot_gap + (i-1)*(subplot_width+subplot_gap), subplot_gap, subplot_width, subplot_height]);
        imshow(converted_image);
        title(sprintf('Scale S: %.2f', scale_S_try(i)), 'FontSize', 10);
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