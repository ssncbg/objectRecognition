    function orderingObjects(originalImage, regionProps, numberOfObjects)
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

    %Perimeter
    [blah, order] = sort([regionProps(:).Perimeter], 'descend'); 
    sortedObjectsPerimeter = regionProps(order);
    for k = 1 : numberOfObjects
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsPerimeter(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);
        perimeter = sortedObjectsPerimeter(k).Perimeter;

        subplot(4, numberOfObjects, k);
        imshow(subImage);
        title (sprintf('Perimeter: %g', perimeter));
    end

    %Area
    [blah, order] = sort([regionProps(:).Area], 'descend'); 
    sortedObjectsArea = regionProps(order);
    for k = 1 : numberOfObjects
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsArea(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);
        area = sortedObjectsArea(k).Area;

        subplot(4, numberOfObjects, numberOfObjects + k);
        imshow(subImage);
        title (sprintf('Area: %g', area));
    end

    %Circularity
    allPerimeters = [regionProps.Perimeter];
    allAreas = [regionProps.Area];
    allCircularities = allPerimeters  .^ 2 ./ (4 * pi* allAreas);

    [blah, order] = sort(allCircularities(:), 'descend'); 
    sortedObjectsCircularity = regionProps(order);

    for k = 1 : numberOfObjects
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsCircularity(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

        perimeter = sortedObjectsCircularity(k).Perimeter;
        area = sortedObjectsCircularity(k).Area;
        circularity = (perimeter^2)/(4*pi*area);

        subplot(4, numberOfObjects, numberOfObjects*2 + k);
        imshow(subImage);
        title (sprintf('Circularity: %g', circularity));
    end

    %TODO: Sharpness

    mainTitle = suptitle('Ordered objects');
    mainTitle.FontSize = 20;
end