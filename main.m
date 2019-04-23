clear all, close all;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(3, 3, 1);
originalImage = imread('Moedas1.jpg');
imshow(originalImage);
title('Original Image');

%Threshold
redBand = originalImage(:, :, 1);
redThresholdValue = graythresh(redBand); 
%uint8
redThresholdValue = uint8(redThresholdValue * 255);
redThresholdImage = (redBand >= redThresholdValue);

%se = strel('disk', 10);
%filledImage = imerode(filledImage,se);


[lb num]=bwlabel(redThresholdImage,4);
regionPropsBeforeFill = regionprops(lb, rgb2gray(originalImage),'all');

filledImage = imfill(redThresholdImage, 8,'holes');

[lb num]=bwlabel(filledImage,4);
regionProps = regionprops(lb, rgb2gray(originalImage),'all');

%Fills small holes
for i = 1 : length(regionProps)
    diferenceAreas = regionProps(i).Area - regionPropsBeforeFill(i).Area;
    if(diferenceAreas > regionProps(i).Area * 0.1)
        regionProps(i) = regionPropsBeforeFill(i);
    end
end 
    
numberOfObjects = find([regionProps.Area]>20);

%Image Threshold
subplot(3, 3, 2);
imshow(redThresholdImage);
title('Threshold Image');
xlabel(sprintf('Number of objects: %d',length(numberOfObjects)));

%==========================================================================
%Visualization centroid of each object
subplot(3, 3, 3);
imshow(redThresholdImage);
title('Centroid');
for i=1:length(numberOfObjects)
    centroid = regionProps(i).Centroid;
    hold on
    plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 8, 'LineWidth', 1);
    hold off
end

%==========================================================================
%Relative distance of the objects
distanceObjects(redThresholdImage, regionProps, length(numberOfObjects));

%==========================================================================
%Visualization perimeter and area of each object
%New figure with individual images of each object
%individualObjects(originalImage, regionProps, length(numberOfObjects));

%==========================================================================
%Ordering the objects depending on the, area, perimeter, circularity or sharpness
%orderingObjects(originalImage, regionProps, length(numberOfObjects));
%==========================================================================
        
  

