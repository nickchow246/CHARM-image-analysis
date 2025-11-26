function [avg_intensity, params_log, params_lsq, pixel_count, bin_centers] = analyze_penetration_2(filename, background_method)
    num_bin = 200;
    image = double(imread(filename));
    
    if background_method == "raw"
        subtracted = image;
    end

    if background_method == "five"
        percentile_5 = prctile(image(:), 5);
        subtracted = max(image - percentile_5, 0);
    end

    if background_method == "ten"
        percentile_10 = prctile(image(:), 10);
        subtracted = max(image - percentile_10, 0);
    end
    
    % Initial mask creation
    bw = imbinarize(subtracted/max(subtracted(:)), 'global');
    se = strel('disk', 5);
    temp = imclose(bw, se);
    min_size = 200000;
    large_regions = bwareaopen(temp, min_size);
    filled = imfill(large_regions, 'holes');
    
    % New mask improvement steps
    temp2 = filled;
    for i = 1:100
        temp2 = imdilate(temp2, se);
    end
    
    fat = imfill(temp2, 'holes');
    for i = 1:120
        fat = imerode(fat, se);
    end
    
    % Combine masks
    final = fat | filled;
    
    % Distance transform and binning
    D = bwdist(~final);
    max_dist = max(D(:));
    edges = linspace(0, max_dist, num_bin + 1);
    bin_centers = (edges(1:end-1) + edges(2:end)) / 2;
    
    D_binned = zeros(size(D));
    for i = 1:num_bin
        D_binned(D > edges(i) & D <= edges(i+1)) = i;
    end
    
    avg_intensity = zeros(1, num_bin);
    pixel_count = zeros(1, num_bin);
    
    for i = 1:num_bin
        bin_mask = (D_binned == i);
        pixels_in_bin = subtracted(bin_mask);
        if ~isempty(pixels_in_bin)
            avg_intensity(i) = mean(pixels_in_bin);
            pixel_count(i) = length(pixels_in_bin);
        end
    end
    
    % Method 1: Log-linear fit
    x = double(bin_centers');
    y = double(avg_intensity');
    
    valid = y > 0;
    x_valid = x(valid);
    y_valid = y(valid);
    
    p = polyfit(x_valid, log(y_valid), 1);
    a_log = exp(p(2));
    b_log = p(1);
    decay_length_log = -1/b_log;
    
    y_fit_log = a_log * exp(b_log * x);
    SSres_log = sum((y - y_fit_log).^2);
    SStot_log = sum((y - mean(y)).^2);
    Rsquared_log = 1 - SSres_log/SStot_log;
    
    params_log = [a_log, b_log, decay_length_log, Rsquared_log];
    
    % Method 2: Nonlinear least squares fit
    expfun = @(b,x) double(b(1)*exp(b(2)*x));
    b0 = double([a_log, b_log]);
    lb = [0, -Inf];
    ub = [Inf, 0];
    
    options = optimoptions('lsqcurvefit', 'Display', 'off');
    b = lsqcurvefit(expfun, b0, x_valid, y_valid, lb, ub, options);
    
    a_lsq = b(1);
    b_lsq = b(2);
    decay_length_lsq = -1/b_lsq;
    
    y_fit_lsq = a_lsq * exp(b_lsq * x);
    SSres_lsq = sum((y - y_fit_lsq).^2);
    SStot_lsq = sum((y - mean(y)).^2);
    Rsquared_lsq = 1 - SSres_lsq/SStot_lsq;
    
    params_lsq = [a_lsq, b_lsq, decay_length_lsq, Rsquared_lsq];
end
