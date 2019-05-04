    function orderingObjects(labelImage, binaryImage, regionProps, numberOfObjects, sharp)
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    colors = colormap('jet');
    numberOfColor = length(colors);
    
    %====Perimeter=========================================================
    [blah, order] = sort([regionProps(:).Perimeter], 'ascend');
    sortedObjectsPerimeter = regionProps(order);
    
    subplot(2,2,1);
    imshow(binaryImage);
    title('Order by Perimeter');
    for k = 1 : numberOfObjects
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsPerimeter(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        rgbPerimeter = label2rgb(bwlabel(subImage), colors(indexColor, :), 'k');
        
        hold on
        image(round(sortedObjectsPerimeter(k).BoundingBox(1)), ...
            round(sortedObjectsPerimeter(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end

    %====Area==============================================================
    [blah, order] = sort([regionProps(:).Area], 'ascend'); 
    sortedObjectsArea = regionProps(order);
    
    subplot(2,2,2);
    imshow(binaryImage);
    title('Order by Area');
    for k = 1 : numberOfObjects
         % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsArea(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        rgbPerimeter = label2rgb(bwlabel(subImage), colors(indexColor, :), 'k');
        
        hold on
        image(round(sortedObjectsArea(k).BoundingBox(1)), ...
            round(sortedObjectsArea(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end

    %====Circularity=======================================================
    allPerimeters = [regionProps.Perimeter];
    allAreas = [regionProps.Area];
    allCircularities = allPerimeters  .^ 2 ./ (4 * pi* allAreas);

    [blah, order] = sort(allCircularities(:), 'ascend'); 
    sortedObjectsCircularity = regionProps(order);

    subplot(2,2,3);
    imshow(binaryImage);
    title('Order by Circularity');
    for k = 1 : numberOfObjects
         % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsCircularity(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        rgbPerimeter = label2rgb(bwlabel(subImage), colors(indexColor, :), 'k');
        
        hold on
        image(round(sortedObjectsCircularity(k).BoundingBox(1)), ...
            round(sortedObjectsCircularity(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end
   
    %====Sharpness=======================================================
    
    [blah, order] = sort(sharp(:), 'ascend'); 
    sortedObjectsSharp = regionProps(order);
   
    subplot(2,2,4);
    imshow(binaryImage);
    title('Order by Sharpness');
    for k = 1 : numberOfObjects
         % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsSharp(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        rgbPerimeter = label2rgb(bwlabel(subImage), colors(indexColor, :), 'k');
        
        hold on
        image(round(sortedObjectsSharp(k).BoundingBox(1)), ...
            round(sortedObjectsSharp(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end

end