    function orderingObjects(binaryImage, regionProps, numberOfObjects, sharp)
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    colors = colormap('hsv');
    numberOfColor = length(colors);
    
    %====Perimeter=========================================================
    [blah, order] = sort([regionProps(:).Perimeter], 'ascend');
    sortedObjectsPerimeter = regionProps(order);
    
    subplot(3,2,1);
    imshow(binaryImage);
    title('Order by Perimeter');
    for k = 1 : numberOfObjects
        % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsPerimeter(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        [subImage,nObj] = bwlabel(subImage);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        colorUse = [];
        for i = 1 : nObj
            int = indexColor + i;
            if (indexColor >63)
                colorUse = [colorUse; colors(63, :)];
            else
                colorUse = [colorUse; colors(int, :)];
            end
        end
        rgbPerimeter = label2rgb(bwlabel(subImage), colorUse,'k');
        hold on
        image(round(sortedObjectsPerimeter(k).BoundingBox(1)), ...
            round(sortedObjectsPerimeter(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end

    %====Area==============================================================
    [blah, order] = sort([regionProps(:).Area], 'ascend'); 
    sortedObjectsArea = regionProps(order);
    
    subplot(3,2,2);
    imshow(binaryImage);
    title('Order by Area');
    for k = 1 : numberOfObjects
         % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsArea(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        colorUse = [];
        for i = 1 : nObj
            int = indexColor + i;
            if (indexColor >63)
                colorUse = [colorUse; colors(63, :)];
            else
                colorUse = [colorUse; colors(int, :)];
            end
        end
        rgbPerimeter = label2rgb(bwlabel(subImage), colorUse,'k');
        
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

    subplot(3,2,3);
    imshow(binaryImage);
    title('Order by Circularity');
    for k = 1 : numberOfObjects
         % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsCircularity(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        colorUse = [];
        for i = 1 : nObj
            int = indexColor + i;
            if (indexColor >63)
                colorUse = [colorUse; colors(63, :)];
            else
                colorUse = [colorUse; colors(int, :)];
            end
        end
        rgbPerimeter = label2rgb(bwlabel(subImage), colorUse,'k');
        
        hold on
        image(round(sortedObjectsCircularity(k).BoundingBox(1)), ...
            round(sortedObjectsCircularity(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end
   
    %====Sharpness=======================================================
    
    [blah, order] = sort(sharp(:), 'ascend'); 
    sortedObjectsSharp = regionProps(order);
   
    subplot(3,2,4);
    imshow(binaryImage);
    title('Order by Sharpness');
    for k = 1 : numberOfObjects
         % Find the bounding box of each blob.
        thisBlobsBoundingBox = sortedObjectsSharp(k).BoundingBox;

        subImage = imcrop(binaryImage, thisBlobsBoundingBox);
        
        indexColor = round(numberOfColor/ (numberOfObjects - k + 1));
        colorUse = [];
        for i = 1 : nObj
            int = indexColor + i;
            if (indexColor >63)
                colorUse = [colorUse; colors(63, :)];
            else
                colorUse = [colorUse; colors(int, :)];
            end
        end
        rgbPerimeter = label2rgb(bwlabel(subImage), colorUse,'k');
        
        hold on
        image(round(sortedObjectsSharp(k).BoundingBox(1)), ...
            round(sortedObjectsSharp(k).BoundingBox(2)), rgbPerimeter);
        hold off
    end
    
    subplot(3,2,[5,6]);
    %rgb = [colors(:,1), colors(:,2), colors(:,3)]
    %imshow(rgb');
    img=zeros(1,64,3); %initialize
    img(1,:,:)=colors;  
    
    imshow(img);
    %diminish space between label and image
    xh = get(gca,'xlabel')
    xlabel('smaller to bigger');
    p = get(xh,'position');
    p(2) = 0.5*p(2) ;
    set(xh,'position',p)

end