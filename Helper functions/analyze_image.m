function analyze_image(image, interval)
    [~, ~, num_z, ~] = size(image);
    num_intervals = ceil(num_z / interval);
   
    minE = zeros(num_intervals, 1);
    maxE = zeros(num_intervals, 1);
    avgE = zeros(num_intervals, 1);
    minS = zeros(num_intervals, 1);
    maxS = zeros(num_intervals, 1);
    avgS = zeros(num_intervals, 1);
    
    for i = 1:num_intervals
        z = 1 + (i-1)*interval;
        if z > num_z
            break;
        end

        E = image(:, :, z, 1);
        S = image(:, :, z, 2);
        
        % Calculate statistics for E channel
        minE(i) = min(E(:));
        maxE(i) = max(E(:));
        E_nonzero = E(E > 0);
        if ~isempty(E_nonzero)
            avgE(i) = mean(E_nonzero(:));
        end
        
        % Calculate statistics for S channel
        minS(i) = min(S(:));
        maxS(i) = max(S(:));
        S_nonzero = S(S > 0);
        if ~isempty(S_nonzero)
            avgS(i) = mean(S_nonzero(:));
        end
    end
    
    fprintf('Plane\tMin E\tMax E\tAvg E\tMin S\tMax S\tAvg S\n');
    for i = 1:num_intervals
        plane_number = 1 + (i-1)*interval;
        fprintf('%d\t%g\t%g\t%g\t%g\t%g\t%g\n', ...
            plane_number, round(minE(i)), round(maxE(i)), round(avgE(i)), ...
            round(minS(i)), round(maxS(i)), round(avgS(i)));
    end
end