function multichannel = import4d_big_nonauto(filenames, z, num_channel)
    
    filename = filenames(1);
    info = imfinfo(filename);
    x = info(1).Width;    
    y = info(1).Height;   

    multichannel = zeros(y, x, z, num_channel, 'uint16');

    for i = 1:num_channel
        path_i = filenames(i);
        multichannel(:, :, :, i) = readBigTiff(path_i);
        fprintf('Finished importing channel %d\n', i);
    end
end