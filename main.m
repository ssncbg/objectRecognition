clear all, close all;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(3, 3, 1);
originalImage = imread('Moedas3.jpg');
imshow(originalImage);
title('Original Image');

%Threshold
redBand = originalImage(:, :, 1);
redThresholdValue = graythresh(redBand); 
%uint8
redThresholdValue = uint8(redThresholdValue * 255);
redThresholdImage = (redBand >= redThresholdValue);
%fills holes.
%filledImage = imfill(redThresholdImage, 8,'holes');

%se = strel('disk', 10);
%filledImage = imerode(filledImage,se);


[lb num]=bwlabel(redThresholdImage);
regionPropsBeforeFill = regionprops(lb, rgb2gray(originalImage),'all');

filledImage = imfill(redThresholdImage, 8,'holes');

[lb num]=bwlabel(filledImage);
regionProps = regionprops(lb, rgb2gray(originalImage),'all');

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
        subplot(3, 4, k);
		imshow(subImage);
        title (sprintf('Perimeter: %g \nArea: %g', perimeter, area));
    end
    
        
  

