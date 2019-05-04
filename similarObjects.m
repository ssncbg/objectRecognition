function similarObjects(originalImage, regionProps, numberOfObjects, sharpness)
    figure
    title('Similar objects');
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
            regionPropObjectSelected = regionProps(k);
            break
        end
    end
    
    %====Perimeter=========================================================
    allPerimeters = [regionProps.Perimeter];
    diferencePerimeters = abs(regionPropObjectSelected(1).Perimeter - allPerimeters);
    [blah, order] = sort(diferencePerimeters(:), 'ascend'); 
    sortedObjectsPerimeters = regionProps(order)
    
    subplot(4, numberOfObjects, 1);
    imshow(imcrop(originalImage, sortedObjectsPerimeters(1).BoundingBox));
    title('Selected Object');
    xlabel (sprintf('Perimeter: %g',...
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
        xlabel (sprintf('Perimeter: %g', perimeter));
    end
    
    %====Area==============================================================
    allAreas = [regionProps.Area];
    diferenceArea = abs(regionPropObjectSelected(1).Area - allAreas);
    [blah, order] = sort(diferenceArea(:), 'ascend'); 
    sortedObjectsArea = regionProps(order)
        
    subplot(4, numberOfObjects, numberOfObjects + 1);
    imshow(imcrop(originalImage, sortedObjectsArea(1).BoundingBox));
    title('Selected Object');
    xlabel (sprintf('Area: %g',sortedObjectsArea(1).Area));
    
    sortedObjectsArea(1) = [];
    
    for k = 1 : numberOfObjects-1
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsArea(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

        area = sortedObjectsArea(k).Area;
        
        subplot(4, numberOfObjects, numberOfObjects + k + 1);
        imshow(subImage);
        xlabel (sprintf('Area: %g', area));
    end
    
    %====Circularity=======================================================
    allCircularities = allPerimeters  .^ 2 ./ (4 * pi* allAreas);
    coinSelectedCircularity = regionPropObjectSelected(1).Perimeter  .^ 2 ./ (4 * pi* regionPropObjectSelected(1).Area);
    diferenceCircularities = abs(coinSelectedCircularity - allCircularities);
    [blah, order] = sort(diferenceCircularities(:), 'ascend'); 
    sortedObjectsCircularity = regionProps(order)
        
    subplot(4, numberOfObjects, numberOfObjects*2 + 1);
    imshow(imcrop(originalImage, sortedObjectsCircularity(1).BoundingBox));
    title('Selected Object');
    xlabel (sprintf('Circularity: %.2g', coinSelectedCircularity));
    
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
        xlabel (sprintf('Circularity: %.2g', circularity));
    end
    
    %====Sharpness=========================================================
    for index = 1 : numberOfObjects
        if(regionProps(index).Centroid == regionPropObjectSelected(1).Centroid)
            break
        end
    end
    
    diferenceSharpnesss = abs(sharpness(index) - sharpness);
    [blah, order] = sort(diferenceSharpnesss(:), 'ascend'); 
    sortedObjectsSharpness = regionProps(order);
    sortedSharpness = sharpness(order);
        
    subplot(4, numberOfObjects, numberOfObjects*3 + 1);
    imshow(imcrop(originalImage, sortedObjectsSharpness(1).BoundingBox));
    title('Selected Object');
    xlabel (sprintf('Sharpness: %.2g', sortedSharpness(1)));
    
    sortedObjectsSharpness(1) = [];
    sortedSharpness(1) = []
    
    for k = 1 : numberOfObjects-1
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsSharpness(k).BoundingBox;  % Get list of pixels in current blob.
        
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);
        
        subplot(4, numberOfObjects, numberOfObjects*3 + k + 1);
        imshow(subImage);
        xlabel (sprintf('Sharpness: %.2g', sortedSharpness(k)));
    end
end