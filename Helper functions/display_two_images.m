function display_two_images(my_image, target_image)
    % Create a figure with two subplots
    figure;
    
    % Display the first image in subplot 1
    subplot(1, 2, 1);
    imshow(my_image);
    title('My Image');
    
    % Display the second image in subplot 2
    subplot(1, 2, 2);
    imshow(target_image);
    title('Target Image');
end