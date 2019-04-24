function similarObjects(originalImage, binaryImage)
figure
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

regionPropsCoin = regionprops(singleCoin,'Centroid');

imshow(singleCoin);

pause

end