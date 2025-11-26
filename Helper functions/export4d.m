function export4d(multichannel, num_channel, folder, outname, extension)
    for i = 1:num_channel
        outpath = fullfile(folder, [outname, '_c', num2str(i-1), extension]);
        if num_channel >= 2
            img_channel = multichannel(:, :, :, i);
        end
        if num_channel == 1
            img_channel = multichannel;
        end
        numSlices = size(img_channel, 3);
        for j = 1:numSlices
            if j == 1
                imwrite(img_channel(:, :, j), outpath);
            else
                imwrite(img_channel(:, :, j), outpath, 'WriteMode', 'append');
            end
        end
    end
end
