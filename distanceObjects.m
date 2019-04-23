function distanceObjects(image, regionProps, numberOfObjects)
    positionSubPlot = 1;
    figure
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    title('Distance between objects');
    
    for k = 1 : numberOfObjects
        subplot(round(numberOfObjects/3), 3, positionSubPlot);
        imshow(image);
        positionSubPlot = positionSubPlot + 1;
       for i = 1 : numberOfObjects
           if(k ~= i)
               centroidA = regionProps(k).Centroid;
               centroidB = regionProps(i).Centroid;
               
               midpointX = (centroidA(1)+centroidB(1))/2;
               midpointY = (centroidA(2)+centroidB(2))/2;
               
               distance = pdist2(centroidA, centroidB);
                             
               hold on
               line([centroidA(1) centroidB(1)], [centroidA(2) centroidB(2)]);
               text(midpointX, midpointY, sprintf('%g',distance), 'Color', 'red');
               hold off
          end
       end
    end
end