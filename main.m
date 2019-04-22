clear all, close all;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(3, 3, 1);
originalImage = imread('Moedas3.jpg');
imshow(originalImage);
title('Original Image');

subplot(3, 3, 2);
%threshold
redBand = originalImage(:, :, 1);
redThresholdValue = graythresh(redBand); 
%uint8
redThresholdValue = uint8(redThresholdValue * 255);
redThresholdImage = (redBand >= redThresholdValue);
%fills holes.
%filledImage = imfill(redThresholdImage, 8,'holes');

se = strel('disk', 10);
%filledImage = imerode(filledImage,se);

imshow(redThresholdImage);
title('Threshold Image');

[lb num]=bwlabel(redThresholdImage);
regionProps = regionprops(lb,'area','FilledImage','Centroid');
inds = find([regionProps.Area]>20);

subplot(3, 3, 3);
whiteImage = uint8(255 * ones(size(originalImage)));
whiteImage = insertText(whiteImage,[10 10], sprintf('Number of objects: %d',length(inds)),'BoxOpacity',0, 'fontsize',80);
imshow(whiteImage);
%emptyImage.text(10, 10, 'Total objects:');


subplot(3, 3, 4);
imshow(redThresholdImage);
title('Centroid');
for i=1:length(inds)
    centroid = regionProps(i).Centroid;
    disp(centroid);  
    hold on
    plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 8, 'LineWidth', 1);
    hold off
end


