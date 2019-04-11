I = imread('img.jpg');

harris(I,30,10);

%I is the image
%window_size is the size of the filter
%corner_thresh is the threshold value for response points
function corner_response=harris(I, window_size, corner_thresh) 
    Igray = rgb2gray(I);
    
    %generate a gaussian filter
    sigma = 1;
    g = fspecial('gauss',window_size,sigma);
    [gx,gy] = gradient(g);
    
    %convolve the gradient with the image to get
    %the x and y derivitave images
    Ix = conv2(Igray,gx);
    Iy = conv2(Igray,gy);

    %do element wise multiplication
    Ix2 = times(Ix,Ix);
    Iy2 = times(Iy,Iy);
    Ixy = times(Ix,Iy);

    %convole again
    Sx2 = conv2(Ix,g);
    Sy2 = conv2(Iy,g);
    Sxy = conv2(Ixy,g);

    %calculate the response
    [n, m] = size(Ix2);
    for y = 1:m
        for x = 1:n
            H = [Sx2(x,y), Sxy(x,y); Sxy(x,y), Sy2(x,y)];
            R(x,y) = det(H)-(.05*trace(H)^2);
            if R(x,y) < corner_thresh
                R(x,y) = 0;
            end
        end
    end

    %white points are corners
    imshow(R);
    figure, imshow(Igray);
end