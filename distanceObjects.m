function distanceObjects(originalImage, regionProps, numberOfObjects)
    figure
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    title('Distance between objects');
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
    
    allDistance = [];
    for i = 1 : numberOfObjects
       centroidA = regionProps(i).Centroid;
       centroidB = regionPropObjectSelected(1).Centroid;

       %midpointX = (centroidA(1)+centroidB(1))/2;
       %midpointY = (centroidA(2)+centroidB(2))/2;

       distance = pdist2(centroidA, centroidB);
       %distanceInfo = [centroidA, centroidB, midpointX, midpointY, distance];
       allDistance = [allDistance; distance];
       %hold on
       %line([centroidA(1) centroidB(1)], [centroidA(2) centroidB(2)]);
       %text(midpointX, midpointY, sprintf('%g',distance), 'Color', 'red');
       %hold off
    end
    
    [blah, order] = sort(allDistance, 'ascend'); 
    %allDistance = allDistance(order);
    regionProps = regionProps(order);
    
  for i = 2 : numberOfObjects
       centroidA = regionProps(i).Centroid;
       centroidB = regionPropObjectSelected(1).Centroid;

       %midpointX = (centroidA(1)+centroidB(1))/2;
       %midpointY = (centroidA(2)+centroidB(2))/2;

       %distance = pdist2(centroidA, centroidB);
       
       hold on
       line([centroidA(1) centroidB(1)], [centroidA(2) centroidB(2)], ...
           'LineWidth', (i-1) * 2, 'Color', 'red');
       %text(midpointX, midpointY, sprintf('%g',distance), 'Color', 'green');
       hold off
  end
