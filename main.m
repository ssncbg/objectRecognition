clear all, close all;

numberOfColumns = 2;
numberOfRows = 3;
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
%==========================================================================
%Obtaining binary image with holes filled
labelImageBeforeFill=bwlabel(redThresholdImage,4);
regionPropsBeforeFill = regionprops(labelImageBeforeFill, rgb2gray(originalImage),'Area', 'Perimeter', 'Centroid', 'BoundingBox', 'EquivDiameter');

filledImage = imfill(redThresholdImage, 8,'holes');
labelImage=bwlabel(filledImage,4);
regionProps = regionprops(labelImage, rgb2gray(originalImage),'Area', 'Perimeter', 'Centroid', 'BoundingBox', 'EquivDiameter');

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
numberOfObjects = length(find([regionProps.Area]>minAreaObject));

subplot(numberOfColumns, numberOfRows, 2);
imshow(binaryImage);
title('Binary Image');
xlabel(sprintf('Number Of Objects: %d', numberOfObjects));

%==========================================================================
%Visualization centroid of each object
subplot(numberOfColumns, numberOfRows, 3);
imshow(binaryImage);
title('Objects Centroids');
for i=1:numberOfObjects
    centroid = regionProps(i).Centroid;
    hold on
    plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 8, 'LineWidth', 1);
    hold off
end

%==========================================================================
%Visualization boundarie of each object
subplot(numberOfColumns, numberOfRows, 4);
imshow(binaryImage);
title('Objects Boundaries');
hold on
visboundaries(binaryImage);
hold off
%==========================================================================
%Compute the amount of money
subplot(numberOfColumns, numberOfRows, 5);
imshow(binaryImage);

one_cent = 0;
two_cent = 0;
five_cent = 0;
ten_cent = 0;
twenty_cent = 0;
fifty_cent = 0;
euro = 0;

threshold = 0.88;
for k = 1:numberOfObjects
    %find the x,y coordinates for the boundary of k
    area = regionProps(k).Area;
    %calculate the metric deciding whether the object is round, if object
    %is above given threshold it's circulat
    metric = 4*pi*area/regionProps(k).Perimeter^2;
    %if object is above or equal to the threshold, it is a coin and the
    %area will be used to decide which type of coin it is.
    if metric >= threshold
        
        % Place image of coin on top of binary picture
        thisBlobsBoundingBox = regionProps(k).BoundingBox;
        
        radius = regionProps(k).EquivDiameter / 2;
        subImage = imcrop(originalImage, thisBlobsBoundingBox);
        hold on
        image(round(regionProps(k).Centroid(1) - radius), round(regionProps(k).Centroid(2) - radius), subImage);
        hold off
        
        if(area < 12000 && area > 11000)
            ten_cent = ten_cent+1;
        elseif (area < 8000 && area > 7000)
            one_cent = one_cent+1;
        elseif(area < 11000 && area > 10000)
            two_cent = two_cent+1;
        elseif(area < 15500 && area > 14500)
            twenty_cent = twenty_cent+1;
        elseif(area < 14000 && area > 13000)
            five_cent = five_cent+1;
        elseif(area < 17000 && area > 16000)
            euro = euro+1;
        elseif(area < 19000 && area > 17500)
            fifty_cent = fifty_cent+1;
        end
    end
    
end

total_amount = one_cent*0.01 + two_cent*0.02 + five_cent*0.05 + ...
ten_cent*0.1 + twenty_cent*0.2 + fifty_cent*0.5 + euro;

title(sprintf('Total amount: %g', total_amount));

%==========================================================================
%Relative distance of the objects
%distanceObjects(redThresholdImage, regionProps, numberOfObjects);
%==========================================================================
%Visualization perimeter and area of each object
%New figure with individual images of each object
%individualObjects(originalImage, regionProps, numberOfObjects);
%==========================================================================
%Derivative of the objects boundary
sharp = derivative(binaryImage, numberOfObjects);
%==========================================================================
%Ordering the objects depending on the, area, perimeter, circularity 
%or sharpness
%orderingObjects(originalImage, regionProps, numberOfObjects, sharp);
%==========================================================================
%From a user selection of given object (the user should select one object), 
%generate a figure that shows an ordered list of objects
%i.e. from the most similar to the less similar of the chosen object. 
similarObjects(originalImage, regionProps, numberOfObjects, sharp);
%==========================================================================


        
  

