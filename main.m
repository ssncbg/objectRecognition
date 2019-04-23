clear all, close all;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(3, 3, 1);
originalImage = imread('Moedas4.jpg');
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


[lb num]=bwlabel(redThresholdImage);
regionPropsBeforeFill = regionprops(lb, rgb2gray(originalImage),'all');

filledImage = imfill(redThresholdImage, 8,'holes');

[lb num]=bwlabel(filledImage);
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

%Centroid
subplot(3, 3, 3);
imshow(redThresholdImage);
title('Centroid');
for i=1:length(numberOfObjects)
    centroid = regionProps(i).Centroid;
    hold on
    plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 8, 'LineWidth', 1);
    hold off
end

%Individual objects with perimeter and area
figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Maximize the figure window.
for k = 1 : length(numberOfObjects)           % Loop through all blobs.
    % Find the bounding box of each blob.
    thisBlobsBoundingBox = regionProps(k).BoundingBox;  % Get list of pixels in current blob.
    % Extract out this coin into it's own image.
    subImage = imcrop(originalImage, thisBlobsBoundingBox);

    perimeter = regionProps(k).Perimeter;
    area = regionProps(k).Area;
    circularity = (perimeter^2)/(4*pi*area);
    subplot(3, 4, k);
    imshow(subImage);
    title (sprintf('Perimeter: %g \nArea: %g \nCircularity: %g', perimeter, area, circularity));
end

%==========================================================================
%Ordering the objects depending on the, area, perimeter, circularity or sharpness

figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(4, length(numberOfObjects), 1);

%Perimeter
[blah, order] = sort([regionProps(:).Perimeter], 'descend'); 
sortedObjectsPerimeter = regionProps(order);
for k = 1 : length(numberOfObjects)
    % Find the bounding box of each blob.
    thisBlobsBoundingBox = sortedObjectsPerimeter(k).BoundingBox;  % Get list of pixels in current blob.
    % Extract out this coin into it's own image.
    subImage = imcrop(originalImage, thisBlobsBoundingBox);
    perimeter = sortedObjectsPerimeter(k).Perimeter;
    
    subplot(4, length(numberOfObjects), k);
    imshow(subImage);
    title (sprintf('Perimeter: %g', perimeter));
end

%Area
[blah, order] = sort([regionProps(:).Area], 'descend'); 
sortedObjectsArea = regionProps(order);
for k = 1 : length(numberOfObjects)
    % Find the bounding box of each blob.
    thisBlobsBoundingBox = sortedObjectsArea(k).BoundingBox;  % Get list of pixels in current blob.
    % Extract out this coin into it's own image.
    subImage = imcrop(originalImage, thisBlobsBoundingBox);
    area = sortedObjectsArea(k).Area;
    
    subplot(4, length(numberOfObjects), length(numberOfObjects) + k);
    imshow(subImage);
    title (sprintf('Area: %g', area));
end

%Circularity
allPerimeters = [regionProps.Perimeter];
allAreas = [regionProps.Area];
allCircularities = allPerimeters  .^ 2 ./ (4 * pi* allAreas);

[blah, order] = sort(allCircularities(:), 'descend'); 
sortedObjectsCircularity = regionProps(order);

for k = 1 : length(numberOfObjects)
    % Find the bounding box of each blob.
    thisBlobsBoundingBox = sortedObjectsCircularity(k).BoundingBox;  % Get list of pixels in current blob.
    % Extract out this coin into it's own image.
    subImage = imcrop(originalImage, thisBlobsBoundingBox);
    
    perimeter = sortedObjectsCircularity(k).Perimeter;
    area = sortedObjectsCircularity(k).Area;
    circularity = (perimeter^2)/(4*pi*area);
    
    subplot(4, length(numberOfObjects), length(numberOfObjects)*2 + k);
    imshow(subImage);
    title (sprintf('Circularity: %g', circularity));
end

mainTitle = suptitle('Ordered objects');
mainTitle.FontSize = 20;
        
  

