function derivative(image, numberOfObjects)
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    plotPosition = 1;

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
        %get X and Y points 
        countX = 0;
        for i=1:row-2
            T = [C(i+1,1), C(i+1,2); C(i,1), C(i,2)];        
            if mod(i,10)==0
                countX = countX+1;
                X = [X; C(i,1)];
                Y = [Y; C(i,2)];
            end
        end    
        D = [];
        for i=1:countX-1
           if X(i+1)-X(i) == 0
               D = [D;0];
           else
               D = [D;(Y(i+1)-Y(i))/(X(i+1)-X(i))];
           end
        end
        subplot(numberOfObjects, 3, plotPosition);
        plot(C(:, 1), C(:, 2));  
        plotPosition = plotPosition + 1;
        
        subplot(numberOfObjects, 3, plotPosition);
        plot(C(:,1));  
        plotPosition = plotPosition + 1;
        
        subplot(numberOfObjects, 3, plotPosition);
        plot(D);  
        plotPosition = plotPosition + 1;
    end