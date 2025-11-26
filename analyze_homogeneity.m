function [avg_intensity, params_homo, pixel_count, bin_centers] = analyze_homogeneity(filename, background_method)
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
    
    % homogeneity
    pixel_all = sum(pixel_count);
    avg_all = sum(avg_intensity .* pixel_count) / pixel_all;
    running = sum(pixel_count .* (avg_intensity - avg_all).^2);
    SD = sqrt(running / pixel_all);
    CV = SD / avg_all;
    params_homo = [SD, avg_all, CV];
end