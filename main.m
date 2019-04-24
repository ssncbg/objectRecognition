clear all, close all;

numberOfColumns = 2;
numberOfRows = 2;
minAreaObject = 20;

set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(numberOfColumns, numberOfRows, 1);

originalImage = imread('Moedas1.jpg');
imshow(originalImage);
title('Original Image');

%==========================================================================
%Threshold
redBand = originalImage(:, :, 1);
redThresholdValue = graythresh(redBand); 
%uint8
redThresholdValue = uint8(redThresholdValue * 255);
redThresholdImage = (redBand >= redThresholdValue);
%==========================================================================
%Obtaining binary image with holes filled
labelImageBeforeFill=bwlabel(redThresholdImage,4);
regionPropsBeforeFill = regionprops(labelImageBeforeFill, rgb2gray(originalImage),'Area', 'Perimeter', 'Centroid', 'BoundingBox');

filledImage = imfill(redThresholdImage, 8,'holes');
labelImage=bwlabel(filledImage,4);
regionProps = regionprops(labelImage, rgb2gray(originalImage),'Area', 'Perimeter', 'Centroid', 'BoundingBox');

binaryImage = zeros(size(redThresholdImage));
%Fills small holes and new binary image
for i = 1 : length(regionProps)
    diferenceAreas = regionProps(i).Area - regionPropsBeforeFill(i).Area;
    
    if(diferenceAreas > regionProps(i).Area * 0.02)
        regionProps(i) = regionPropsBeforeFill(i);
                
        binaryImage =  bitor(binaryImage, ismember(labelImageBeforeFill, i));
    else
        binaryImage =  bitor(binaryImage, ismember(labelImage, i));
    end
end 

se = strel('disk', 10);
binaryImage = imerode(binaryImage,se);
 
[lb num]=bwlabel(binaryImage,4);
regionProps = regionprops(lb, rgb2gray(originalImage),'all');
numberOfObjects = find([regionProps.Area]>minAreaObject);

subplot(numberOfColumns, numberOfRows, 2);
imshow(binaryImage);
title('Binary Image');
xlabel(sprintf('NumberOfObjects: %d', length(numberOfObjects)));

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
%Ordering the objects depending on the, area, perimeter, circularity 
%or sharpness
%orderingObjects(originalImage, regionProps, length(numberOfObjects));
%==========================================================================
%From a user selection of given object (the user should select one object), 
%generate a figure that shows an ordered list of objects
%i.e. from the most similar to the less similar of the chosen object. 
similarObjects(originalImage, binaryImage, regionProps, length(numberOfObjects));
%==========================================================================

        
  

