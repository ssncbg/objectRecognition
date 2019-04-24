clear all, close all;

numberOfColumns = 2;
numberOfRows = 2;
minAreaObject = 20;

set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(numberOfColumns, numberOfRows, 1);

originalImage = imread('Moedas3.jpg');
imshow(originalImage);
title('Original Image');

%==========================================================================
%Threshold
redBand = originalImage(:, :, 1);
redThresholdValue = graythresh(redBand); 
%uint8
redThresholdValue = uint8(redThresholdValue * 255);
redThresholdImage = (redBand >= redThresholdValue);

labelImageBeforeFill=bwlabel(redThresholdImage,4);
regionPropsBeforeFill = regionprops(labelImageBeforeFill, rgb2gray(originalImage),'all');

%==========================================================================
%Obtaining binary image with holes filled
filledImage = imfill(redThresholdImage, 8,'holes');
labelImage=bwlabel(filledImage,4);
regionProps = regionprops(labelImage, rgb2gray(originalImage),'all');

binaryImage = zeros(size(redThresholdImage));
%Fills small holes and new binary image
for i = 1 : length(regionProps)
    areaA = regionProps(i).Area;
    areaB = regionPropsBeforeFill(i).Area;
    diferenceAreas = regionProps(i).Area - regionPropsBeforeFill(i).Area;
    
    if(diferenceAreas > regionProps(i).Area * 0.02)
        regionProps(i) = regionPropsBeforeFill(i);
                
        binaryImage =  bitor(binaryImage, ismember(labelImageBeforeFill, i));
    else
        binaryImage =  bitor(binaryImage, ismember(labelImage, i));
    end
end 
    
numberOfObjects = find([regionProps.Area]>minAreaObject);

subplot(numberOfColumns, numberOfRows, 2);
imshow(binaryImage);
title('Binary Image');
xlabel(sprintf('NumberOfObjects: %d', length(numberOfObjects)));

% filledImage = imfill(redThresholdImage, 8,'holes');
% 
% se = strel('disk', 10);
% erodeImage = imerode(filledImage,se);
% 
% [lb num]=bwlabel(erodeImage,4);
% regionPropsBefore = regionprops(lb, rgb2gray(originalImage),'all');
% 
% subplot(numberOfColumns, numberOfRows, 3);
% imshow(erodeImage);
   
% for k = 1 : numberOfObjects
%     % Find the bounding box of each blob.
%     thisBlobsBoundingBox = sortedObjectsPerimeter(k).BoundingBox;  % Get list of pixels in current blob.
%     % Extract out this coin into it's own image.
%     subImage = imcrop(originalImage, thisBlobsBoundingBox);
%     perimeter = sortedObjectsPerimeter(k).Perimeter;
% 
%     subplot(4, numberOfObjects, k);
%     imshow(subImage);
%     title (sprintf('Perimeter: %g', perimeter));
% end


%==========================================================================
%Visualization centroid of each object
subplot(numberOfColumns, numberOfRows, 3);
imshow(binaryImage);
title('Objects Centroids');
for i=1:length(numberOfObjects)
    centroid = regionProps(i).Centroid;
    hold on
    plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 8, 'LineWidth', 1);
    hold off
end

%Visualization boundarie of each object
subplot(numberOfColumns, numberOfRows, 4);
imshow(binaryImage);
title('Objects Boundaries');
hold on
visboundaries(binaryImage);
hold off

%==========================================================================
%Relative distance of the objects
%distanceObjects(redThresholdImage, regionProps, length(numberOfObjects));
%==========================================================================
%Visualization perimeter and area of each object
%New figure with individual images of each object
%individualObjects(originalImage, regionProps, length(numberOfObjects));
%==========================================================================
%Ordering the objects depending on the, area, perimeter, circularity or sharpness
%orderingObjects(originalImage, regionProps, length(numberOfObjects));
%==========================================================================
        
  

