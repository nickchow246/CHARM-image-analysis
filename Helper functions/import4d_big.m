function multichannel = import4d_big(folder, filename, extension, z, num_channel)

    firstFile = fullfile(folder, [filename, '_c0', extension]);
    info = imfinfo(firstFile);
    x = info(1).Width;    
    y = info(1).Height;   

    multichannel = zeros(y, x, z, num_channel, 'uint16');

    for i = 1:num_channel
        path_i = fullfile(folder, [filename, '_c', num2str(i-1), extension]);
        multichannel(:, :, :, i) = readBigTiff(path_i);
        clear stack_out
        fprintf('Finished importing channel %d\n', i);
    end
end