function image = scale_to_10000(image, interval, scale_target)
    [~, ~, num_z, num_c] = size(image);
    
    % Initialize variables to store mean values for each plane within the interval
    num_intervals = ceil(num_z / interval);
    mean_values = zeros(num_intervals, num_c);
    
    % Iterate over the planes with the specified interval
    interval_idx = 1;
    for z = 1:interval:num_z
        for c = 1:num_c
            slice = image(:, :, z, c);
            nonzero_vals = slice(slice > 0);
            if ~isempty(nonzero_vals)
                mean_values(interval_idx, c) = mean(nonzero_vals);
            end
        end
        interval_idx = interval_idx + 1;
    end
    
    max_means = max(mean_values, [], 1);
    scaling_factors = scale_target ./ max_means;
    
    % Print debugging information
    fprintf('Max Mean E: %.2f\n', max_means(1));
    fprintf('Max Mean S: %.2f\n', max_means(2));
    fprintf('Scaling Factor E: %.4f\n', scaling_factors(1));
    fprintf('Scaling Factor S: %.4f\n', scaling_factors(2));

    % Scale each channel
    for c = 1:num_c
        image(:,:,:,c) = image(:,:,:,c) * scaling_factors(c);
    end
end