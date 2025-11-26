% Error bar plot function with num_bins parameter
function plot_error_bars(table, columns, num_bins)
    y = table{:, columns(1)};
    x = table{:, columns(2)};
    
    temp = linspace(min(x), max(x), num_bins + 3);  % creates num_bins + 2 bins
    edges = temp(2:end-1);  % takes only the central edges
    [counts, edges, bins] = histcounts(x, edges);
    bin_centers = edges(1:end-1) + diff(edges)/2;
    means = zeros(1, num_bins);
    sd = zeros(1, num_bins);
    
    for i = 1:num_bins
        bin_data = y(bins == i);
        means(i) = mean(bin_data, 'omitnan');
        sd(i) = std(bin_data, 'omitnan');
    end
    
    figure;
    errorbar(bin_centers, means, sd, 'o', 'MarkerFaceColor', 'b');
    hold on
    p = polyfit(x, y, 1);
    y_fit = polyval(p, x);
    plot(x, y_fit, 'r-', 'LineWidth', 2)
    ylim([0 max(means + sd) * 1.1])
    
    xlabel(table.Properties.VariableNames{columns(2)})
    ylabel(table.Properties.VariableNames{columns(1)})
    title([table.Properties.VariableNames{columns(1)}, ' vs ', table.Properties.VariableNames{columns(2)}])
    legend('Bin Average ± SD', 'Best Fit')
    grid on
    hold off
end