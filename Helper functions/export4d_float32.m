function export4d_float32(multichannel, num_channel, folder, outname, extension)
    for i = 1:num_channel
        outpath = fullfile(folder, [outname, '_c', num2str(i-1), extension]);
        if num_channel >= 2
            img_channel = multichannel(:, :, :, i);
        end
        if num_channel == 1
            img_channel = multichannel;
        end
        numSlices = size(img_channel, 3);
        description = ['ImageJ=1.53c' newline 'slices=' num2str(numSlices)];
        
        % Open Tiff file with 'w8' for BigTiff support if needed
        t = Tiff(outpath, 'w8');
        
        for j = 1:numSlices
            % Set up tags for each slice
            tagstruct.ImageLength = size(img_channel, 1);
            tagstruct.ImageWidth = size(img_channel, 2);
            tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
            tagstruct.BitsPerSample = 32;
            tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;  % for float32/single
            tagstruct.SamplesPerPixel = 1;
            tagstruct.RowsPerStrip = 16;
            tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
            tagstruct.ImageDescription = description;
            
            % Write the slice
            t.setTag(tagstruct);
            t.write(img_channel(:,:,j));
            
            % Create new directory for next slice (except for last slice)
            if j < numSlices
                t.writeDirectory();
            end
        end
        
        % Close the file
        t.close();
    end
end