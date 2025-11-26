% Stacked proportions function with num_bins parameter
function plot_stacked_proportions(table, columns, num_bins)
    unique_categories = unique(table{:, columns(1)});
    if length(unique_categories) > 20
        error('Too many categories (%d) in column %d. Maximum allowed is 20.', ...
            length(unique_categories), columns(1));
    end
    
    x = table{:, columns(2)};
    categories = string(table{:, columns(1)});
    
    temp = linspace(min(x), max(x), num_bins + 3);  % creates num_bins + 2 bins
    edges = temp(2:end-1);  % takes only the central edges
    [counts, edges, bins] = histcounts(x, edges);
    unique_categories = unique(categories);
    proportions = zeros(length(unique_categories), num_bins);
    
    for i = 1:num_bins
        bin_indices = (bins == i);
        bin_categories = categories(bin_indices);
        bin_total = sum(bin_indices);
        
        if bin_total > 0
            for j = 1:length(unique_categories)
                proportions(j,i) = sum(strcmp(bin_categories, unique_categories(j))) / bin_total;
            end
        end
    end
    
    figure;
    bar(edges(1:end-1) + diff(edges)/2, proportions', 'stacked')
    ylim([0 1])
    xlabel(table.Properties.VariableNames{columns(2)})
    ylabel(['Proportion of ' table.Properties.VariableNames{columns(1)}])
    title([table.Properties.VariableNames{columns(1)}, ' vs ', table.Properties.VariableNames{columns(2)}])
    legend(string(unique_categories), 'Location', 'eastoutside')
    grid on
end