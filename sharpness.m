function [xMin,yMin,xMax,yMax, difference] = sharpness(S)
       minX = [];
       maxX = [];
       maxY = [];
       minY = [];
       nrMin = 0;
       nrMax = 0;
       slope = -1;
       if S(1) > S(2)
           maxY = [maxY; S(1)];
           maxX = [maxX; 1];
           nrMax = 1;
       elseif S(1) < S(2)
           minY = [minY; S(1)];
           minX = S(1);
           nrMin = 1;
           slope = 1;
       end
       [m,n] = size(S)
       for j=2:n
           if slope == -1
              if S(j-1) < S(j) && S(j) - S(j-1) > 0.005
                  minY = [minY;S(j-1)];
                  minX = [minX;j-1];
                  nrMin= nrMin + 1;
                  slope = 1;
              end 
           else
              if S(j-1) > S(j) && S(j-1) - S(j) > 0.005
                  maxY = [maxY;S(j-1)];
                  maxX = [maxX;j-1];
                  nrMax = nrMax + 1;
                  slope = -1;
              end 
           end
           if j==n && nrMax ~= nrMin   
               if slope == 1 && nrMin > nrMax
                  maxY = [maxY;S(j)];
                  maxX = [maxX;j];
               elseif slope == -1 && nrMax > nrMin
                  minY = [minY;S(j)];
                  minX = [minX;j];
               end
                           
           end
       end
       xMin = minX;
       xMax = maxX;
       yMin = minY;
       yMax = maxY;
       [r,c] = size(yMax);
       difference = 0;
       for k=1:r
           if yMax(k) > 0 && yMin(k) > 0 
               difference = difference + (yMax(k) - yMin(k));
           elseif yMax(k) < 0 && yMin(k) < 0 
               difference = difference + (abs(yMax(k)) - abs(yMin(k)));
           elseif yMax(k) > 0 && yMin(k) < 0
               difference = difference + (yMax(k) + abs(yMin(k))); 
           end
       end
       
end