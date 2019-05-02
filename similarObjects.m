function similarObjects(originalImage, regionProps, numberOfObjects)
    figure
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    imshow(originalImage); hold on;

    selected = 0;

    while(selected == 0)
        [x, y] = ginput(1);
        selected = 1;
    end
    
    %searchs for clicked object
    for k = 1 : numberOfObjects
        thisBlobsCentroid = regionProps(k).Centroid;
        radius = regionProps(k).EquivDiameter / 2;
        
        xMin = thisBlobsCentroid(1) - radius;
        xMax = thisBlobsCentroid(1) + radius;
        yMin = thisBlobsCentroid(2) - radius;
        yMax = thisBlobsCentroid(2) + radius;
        
        if(x >= xMin) && (x <= xMax) && (y >= yMin) && (y <= yMax) 
            regionPropsCoin = regionProps(k);
            break
        end
    end
    
    %====Perimeter=========================================================
    allPerimeters = [regionProps.Perimeter];
    diferencePerimeters = abs(regionPropsCoin(1).Perimeter - allPerimeters);
    [blah, order] = sort(diferencePerimeters(:), 'ascend'); 
    sortedObjectsPerimeters = regionProps(order)
    
    subplot(4, numberOfObjects, 1);
    imshow(imcrop(originalImage, sortedObjectsPerimeters(1).BoundingBox));
    title (sprintf('Selected Object\n Perimeter: %g',...
        round(sortedObjectsPerimeters(1).Perimeter)));
    
    sortedObjectsPerimeters(1) = [];
    
    for k = 1 : numberOfObjects -1
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsPerimeters(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

        perimeter = round(sortedObjectsPerimeters(k).Perimeter);
        
        subplot(4, numberOfObjects, k + 1);
        imshow(subImage);
        title (sprintf('Perimeter: %g', perimeter));
    end
    
    %====Area==============================================================
    allAreas = [regionProps.Area];
    diferenceArea = abs(regionPropsCoin(1).Area - allAreas);
    [blah, order] = sort(diferenceArea(:), 'ascend'); 
    sortedObjectsArea = regionProps(order)
        
    subplot(4, numberOfObjects, numberOfObjects + 1);
    imshow(imcrop(originalImage, sortedObjectsArea(1).BoundingBox));
    title (sprintf('Selected Object\n Area: %g',sortedObjectsArea(1).Area));
    
    sortedObjectsArea(1) = [];
    
    for k = 1 : numberOfObjects-1
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsArea(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

        area = sortedObjectsArea(k).Area;
        
        subplot(4, numberOfObjects, numberOfObjects + k + 1);
        imshow(subImage);
        title (sprintf('Area: %g', area));
    end
    
    %====Circularity=======================================================
    allCircularities = allPerimeters  .^ 2 ./ (4 * pi* allAreas);
    coinSelectedCircularity = regionPropsCoin(1).Perimeter  .^ 2 ./ (4 * pi* regionPropsCoin(1).Area);
    diferenceCircularities = abs(coinSelectedCircularity - allCircularities);
    [blah, order] = sort(diferenceCircularities(:), 'ascend'); 
    sortedObjectsCircularity = regionProps(order)
        
    subplot(4, numberOfObjects, numberOfObjects*2 + 1);
    imshow(imcrop(originalImage, sortedObjectsCircularity(1).BoundingBox));
    title (sprintf('Selected Object\n Circularity: %.2g', coinSelectedCircularity));
    
    sortedObjectsCircularity(1) = [];
    
    for k = 1 : numberOfObjects-1
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsCircularity(k).BoundingBox;  % Get list of pixels in current blob.
        
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

         perimeter = sortedObjectsCircularity(k).Perimeter;
        area = sortedObjectsCircularity(k).Area;
        circularity = (perimeter^2)/(4*pi*area);
        
        subplot(4, numberOfObjects, numberOfObjects*2 + k + 1);
        imshow(subImage);
        title (sprintf('Circularity: %.2g', circularity));
    end
end