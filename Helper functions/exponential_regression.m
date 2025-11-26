function [exponential_E, exponential_S] = exponential_regression(image, interval)
    % Get dimensions of the image stack
    [~, ~, num_z, ~] = size(image);
    
    % Calculate the indices of planes to use for regression
    indices = 1:interval:num_z;
    num_selected_planes = length(indices);
    
    % Initialize variables to store average values
    avgE = zeros(num_selected_planes, 1);
    avgS = zeros(num_selected_planes, 1);
    
    % Iterate over the selected planes in the image stack
    for i = 1:num_selected_planes
        % Extract E and S channels for the current plane
        E = image(:,:,indices(i),1);
        S = image(:,:,indices(i),2);
        
        % Calculate average values for E and S channels
        E_nonzero = E(E > 0);
        S_nonzero = S(S > 0);
        avgE(i) = mean(E_nonzero(:));
        avgS(i) = mean(S_nonzero(:));
    end
    
    % Define x values for regression based on the selected planes
    x = indices;
    
    % Perform exponential regression for E channel
    coeffE = polyfit(x, log(avgE), 1);
    exponential_E = coeffE(1);
    
    % Perform exponential regression for S channel
    coeffS = polyfit(x, log(avgS), 1);
    exponential_S = coeffS(1);
    
    % Print out the decay coefficients for E and S channels
    fprintf('\nDecay Coefficients:\n');
    fprintf('E channel: exponential_E = %.2e\n', exponential_E);
    fprintf('S channel: exponential_S = %.2e\n', exponential_S);
    
    % Create a scatter plot with exponential regression lines
    figure;
    scatter(x, avgE, 'ro', 'DisplayName', 'E channel');
    hold on;
    scatter(x, avgS, 'bo', 'DisplayName', 'S channel');
    plot(x, exp(coeffE(2)) * exp(exponential_E * x), 'r-', 'DisplayName', sprintf('E fit: exp(%.2e) * exp(%.2e * x)', coeffE(2), exponential_E));
    plot(x, exp(coeffS(2)) * exp(exponential_S * x), 'b-', 'DisplayName', sprintf('S fit: exp(%.2e) * exp(%.2e * x)', coeffS(2), exponential_S));
    xlabel('Plane');
    ylabel('Mean Value');
    title('Exponential Regression');
    legend('Location', 'best');
    grid on;
end