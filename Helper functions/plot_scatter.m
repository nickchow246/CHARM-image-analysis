% Scatter plot function (no bins needed)
function plot_scatter(table, columns)
    y = table{:, columns(1)};
    x = table{:, columns(2)};
    
    figure;
    scatter(x, y, 'filled');
    hold on
    p = polyfit(x, y, 1);
    y_fit = polyval(p, x);
    plot(x, y_fit, 'r-', 'LineWidth', 2)
    ylim([0 max(y) * 1.1])
    
    xlabel(table.Properties.VariableNames{columns(2)})
    ylabel(table.Properties.VariableNames{columns(1)})
    title([table.Properties.VariableNames{columns(1)}, ' vs ', table.Properties.VariableNames{columns(2)}])
    legend('Data', 'Best Fit')
    grid on
    hold off
end