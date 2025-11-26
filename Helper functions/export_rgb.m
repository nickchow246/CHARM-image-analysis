function export_rgb(image, chunk_size, filepath)
    % Get the number of Z-sections in the stack
    num_z = size(image, 3);
    
    % Initialize the start index and file counter
    start_index = 1;
    file_counter = 1;
    
    while start_index <= num_z
        % Create a new TIFF file for each chunk of XY images
        end_index = min(start_index + chunk_size - 1, num_z);
        chunk_image = image(:, :, start_index:end_index, :);
        chunk_z = end_index - start_index + 1;
        RGB_chunk = convert_RGB(chunk_image);
        
        % Generate the file path for the current chunk
        [filepath_prefix, filepath_ext] = split_path(filepath);
        chunk_filepath = sprintf('%s_%d%s', filepath_prefix, file_counter, filepath_ext);
        
        for i = 1:chunk_z
            rgbImage = squeeze(RGB_chunk(:, :, i, :));
            if i == 1
                imwrite(rgbImage, chunk_filepath);
            else
                imwrite(rgbImage, chunk_filepath, 'WriteMode', 'append');
            end
        end
        
        start_index = end_index + 1;
        file_counter = file_counter + 1;
    end
end

function [filepath_prefix, filepath_ext] = split_path(filepath)
    [path, name, filepath_ext] = fileparts(filepath);
    filepath_prefix = fullfile(path, name);
end

function RGB_image = convert_RGB(image)    
    [num_y, num_x, num_z, num_c] = size(image);
    RGB_image = zeros(num_y, num_x, num_z, 3);
    
    for z = 1:num_z
        twoChannelImage = squeeze(image(:, :, z, :));
        
        % Extract the individual channels
        E = double(twoChannelImage(:, :, 1));
        S = double(twoChannelImage(:, :, 2));
        
        % Divide E and S channels by 255
        E = E / 65535;
        S = S / 65535;
        E = min(max(E, 0), 1);
        S = min(max(S, 0), 1);
        
        % Apply the conversion formula using vectorization
        R = 10.^(-0.644 * S - 0.093 * E);
        G = 10.^(-0.717 * S - 0.954 * E);
        B = 10.^(-0.267 * S - 0.283 * E);
        
        % Create the RGB image for the current Z-section
        rgbImage = cat(3, R, G, B);
        
        % Store the RGB image in the rgbStack
        RGB_image(:, :, z, :) = rgbImage;
    end
end