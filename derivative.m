function derivative(image, numberOfObjects)
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    plotPosition = 1;
    stepSize=30;
    B = bwboundaries(image, 'noholes');
    %get 1st object to test
    for i=1:size(B)
        A = B(i);
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
        subplot(numberOfObjects, 3, plotPosition);
        plot(X(:),Y(:));
        plotPosition = plotPosition + 1;
        
        subplot(numberOfObjects, 3, plotPosition);
        plot(D);  
        plotPosition = plotPosition + 1;
        
        subplot(numberOfObjects, 3, plotPosition);
        
        plot(diff(D)/stepSize);  
        plotPosition = plotPosition + 1;
    end