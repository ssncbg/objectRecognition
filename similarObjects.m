function similarObjects(originalImage, binaryImage, regionProps, numberOfObjects)
    figure
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    imshow(originalImage); hold on;

    n = 0;
    but = 1;

    while(but == 1 | but == 32)
        [ci, li, but] = ginput(1);
        if but == 1
            n = n + 1;
            cp(n) = ci;
            lp(n) = li;
            plot(ci, li, 'r.', 'MarkerSize', 18); drawnow;
            if n > 1
                plot(cp(:), lp(:), 'r.-', 'MarkerSize', 8); drawnow;
            end
        end
    end
    cp = cp'; lp = lp';

    polygonShape = roipoly(originalImage, cp, lp);
    singleCoin = bitand(polygonShape, binaryImage);

    regionPropsCoin = regionprops(singleCoin,'Centroid', 'Perimeter', 'Area', 'BoundingBox');
    
    %Perimeter
    allPerimeters = [regionProps.Perimeter];
    diferencePerimeters = abs(regionPropsCoin(1).Perimeter - allPerimeters);
    [blah, order] = sort(diferencePerimeters(:), 'ascend'); 
    sortedObjectsPerimeters = regionProps(order)
    
    subplot(4, numberOfObjects, 1);
    imshow(imcrop(originalImage, sortedObjectsPerimeters(1).BoundingBox));
    title (sprintf('Selected Object\n Perimeter: %g',sortedObjectsPerimeters(1).Area));
    
    sortedObjectsPerimeters(1) = [];
    
    for k = 1 : numberOfObjects -1
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsPerimeters(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

        perimeter = sortedObjectsPerimeters(k).Perimeter;
        
        subplot(4, numberOfObjects, k + 1);
        imshow(subImage);
        title (sprintf('Perimeter: %g', perimeter));
    end
    
    %Area
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
    
    %Circularity
    allCircularities = allPerimeters  .^ 2 ./ (4 * pi* allAreas);
    coinSelectedCircularity = regionPropsCoin(1).Perimeter  .^ 2 ./ (4 * pi* regionPropsCoin(1).Area);
    diferenceCircularities = abs(coinSelectedCircularity - allCircularities);
    [blah, order] = sort(diferenceCircularities(:), 'ascend'); 
    sortedObjectsCircularity = regionProps(order)
        
    subplot(4, numberOfObjects, numberOfObjects*2 + 1);
    imshow(imcrop(originalImage, sortedObjectsCircularity(1).BoundingBox));
    title (sprintf('Selected Object\n Circularity: %g', coinSelectedCircularity));
    
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
        title (sprintf('Circularity: %g', circularity));
    end
end