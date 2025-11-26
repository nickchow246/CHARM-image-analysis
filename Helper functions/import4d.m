function multichannel = import4d(folder, filename, extension, num_channel)

    firstFile = fullfile(folder, [filename, '_c0', extension]);
    info = imfinfo(firstFile);
    z = numel(info);
    img0 = imread(firstFile, 1);
    [y, x] = size(img0);

    multichannel = zeros(y, x, z, num_channel, 'like', img0);

    for i = 1:num_channel
        path_i = fullfile(folder, [filename, '_c', num2str(i-1), extension]);
        for j = 1:z
            multichannel(:, :, j, i) = imread(path_i, j);
        end
        fprintf('Finished importing channel %d\n', i);
    end
end