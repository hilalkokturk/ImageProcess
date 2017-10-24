% #I is the image that we will scale
% #s is the scale factor
% #option is the scale algorithm option that we will use
function I2 = iminterpolate(I,s,option)
    I = imread('peppers.png'); % #We are getting the image
    if option == "nearest"  % #We check that whether option is nearest 
                            % interpolation 
        %if option equals to nearest we will use nearest interpolation
        %algorithm
                            
        currentSize = size(I); % #We are getting the image current size
        newSize = round(s*currentSize(1:2));  % #We are calculating the new 
        % image size with recpect to scale factor
        
        % #We are calculating row and cloumn index to resize our image 
        % with respect to nearest interpolotion
        row = round(((1:newSize(1))-0.5)/s+0.5);
        col = round(((1:newSize(2))-0.5)/s+0.5);

        I2 = I(row,col,:);  % #We are appliying the new row and 
        % cloumn index to our image and we are keeping this in I2 variable
        imshow(I);
        figure;
        imshow(I2);
    end
    
    if option =="bilinear"  % #We check that whether option is bilinear 
                            % interpolation 
        % #if option equals to bilinear we will use bilinear interpolation
        %algorithm
                           
    
    I = imread('peppers.png'); % #We are getting the image which we will use
    
    current_row = size(I,1); % #We are getting the row count on the image
    current_col = size(I,2); % #We are getting the cloumn count on the image
    RGB_val = size(I,3); % #We are getting the RGB_value of the image
    
    output_row = round(current_row*s); % #We are calculating the output image row count 
    output_col = round(current_col*s); % #We are calculating the output image cloumn count
    
    % #We are calculating the rate between input image row size and output image row
    % size. Also, we are calculating the rate between input image cloumn size and
    % output image cloumn size. We can calculate this from 1/scale factor.
    % Because scale factor is constant. We resize the image with equal
    % scale for row and cloumn.
    r = 1/s; 

    % #We return the co-ordinates in every point in our image.
    % #coX and coY will represent this co-ordinates.
    [coY, coX] = meshgrid(1 : output_col, 1 : output_row);
    
    % #We determine the co-ordinates of points which will be need to fulfill.
    % #coX and coY will represent this co-ordinates.

    coX = coX * r;
    coY = coY * r;
    
    % #We determine the co-ordinates of the nearest point for an empy point.
    % #The nearest point co-ordinates for an empty point will be
    % represented by (x,y).
    x = round(coX);
    y = round(coY);

    % #We determine the values which are out of range.
    % #We return these values to make these in range.
    x(x<1) = 1;
    y(y<1) = 1;
    x(x > current_row - 1) = current_row - 1;
    y(y > current_col - 1) = current_col - 1;

    % #We calculate the delta values. Delta values for each is necessary
    % because when we fulfill the empty points in image, we will use
    % values. The point which is more closest between four point will be
    % more effective to fulfill the empty points.
    
    deltax = coX - x;
    deltay = coY - y;
    % #We determine the 4 points which are more closest the empty point.
    % #PS: We use closest 4 points to fulfill empty points. Because
    % according to bilenear polatation, we need more closest 4 points.
    p1 = sub2ind([current_row, current_col], x, y);
    p2 = sub2ind([current_row, current_col], x+1,y);
    p3 = sub2ind([current_row, current_col], x, y+1);
    p4 = sub2ind([current_row, current_col], x+1, y+1);       

    % #We are ceating new matrix to output image. This matrix is zero
    % matrix. The size of the matrix output_row*output_coloumn*RGB_value.
    % Then we converts output image to input image class. After this
    % operation, output image will consist of input image values with empty
    % points.
    I2 = zeros(output_row, output_col, RGB_val);
    I2 = cast(I2, class(I));
    
    % #We are using for loop to fill empty point in output 
    % with respect to bilenear polatation algorithm.
    for j = 1 : RGB_val
        iVar = double(I(:,:,j));

        temp = iVar(p1).*(1 - deltax).*(1 - deltay) + iVar(p2).*(deltax).*(1 - deltay) + iVar(p3).*(1 - deltax).*(deltay) + iVar(p4).*(deltax).*(deltay);
        I2(:,:,j) = cast(temp, class(I));
    end
        % #Finally, we display the input and output image.
        imshow(I); 
        figure;
        imshow(I2);
   
    end
end