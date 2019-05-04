function sharp = derivative(image, numberOfObjects)
    figure;
    set(gcf, 'Position', get(0, 'Screensize'));
    plotPosition = 1;
    stepSize=10;
    B = bwboundaries(image, 'noholes');
    %get 1st object to test
    sharp = [];
    for j=1:size(B)
        A = B(j);
        %convert to mat
        C = cell2mat(A);
        [row,col] = size(C);
        %split in X and Y
        X = [];
        Y = [];
        X = [X, C(1,1)];
        Y = [Y, C(1,2)];
        %get X and Y points 
        for i=1:row-1
            T = [C(i+1,1), C(i+1,2); C(i,1), C(i,2)];        
            if mod(i,stepSize) == 0
                X = [X, C(i,1)];
                Y = [Y, C(i,2)];
            end
            if i == row-1
                X = [X, C(i+1,1)];
                Y = [Y, C(i+1,2)];
                X = [X, C(1,1)];
                Y = [Y, C(1,2)];
            end
        end    
        D = diff(Y)/stepSize;
        S = diff(D)/stepSize;
        subplot(numberOfObjects, 3, plotPosition);
        
        plot(X(:),Y(:));
        hold on
        plot(X(:),Y(:), 'b.');
        hold off
        if(j==1)
           title(sprintf('Object bondaries')); 
        end
        plotPosition = plotPosition + 1;
        
        subplot(numberOfObjects, 3, plotPosition);
        plot(D);  
        if(j==1)
           title(sprintf('1st Derivative')); 
        end
        plotPosition = plotPosition + 1;
        
        subplot(numberOfObjects, 3, plotPosition);
        plot(S,'b');
        hold on;
        [xMin,yMin,xMax,yMax, sharpObj] = sharpness(S);
        sharp = [sharp;sharpObj];
        plot(xMin,yMin,'or');
        plot(xMax,yMax,'og');
        if(j==1)
           title(sprintf('2nd derivative (sharpness)')); 
        end
        plotPosition = plotPosition + 1;  
    end
end
    