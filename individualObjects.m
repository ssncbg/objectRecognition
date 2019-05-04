function individualObjects(originalImage, regionProps, numberOfObjects, sharpness)
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
    % Maximize the figure window.
    for k = 1 : numberOfObjects
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = regionProps(k).BoundingBox;  % Get list of pixels in current blob.
        % Extract out this coin into it's own image.
        subImage = imcrop(originalImage, thisBlobsBoundingBox);

        perimeter = regionProps(k).Perimeter;
        area = regionProps(k).Area;
        circularity = (perimeter^2)/(4*pi*area);
        subplot(ceil(numberOfObjects/3), 3, k);
        imshow(subImage);
        title (sprintf('Perimeter: %g \nArea: %g \nCircularity: %.2g\nSharpness: %.2g', ...
            perimeter, area, circularity,sharpness(k)));
    end
end