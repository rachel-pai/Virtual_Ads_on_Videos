function [ intersections ] = find_intersection(frames)

intersections= zeros(10,2,length(frames));
for n = 1:length(frames)
    grayImage = frames{n};
    % Get the dimensions of the image.  
    % numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
    [rows, columns, numberOfColorChannels] = size(grayImage);
    if numberOfColorChannels > 1
        % It's not really gray scale like we expected - it's color.
        % Use weighted sum of ALL channels to create a gray scale image.
        grayImage = rgb2gray(grayImage); 
        % ALTERNATE METHOD: Convert it to gray scale by taking only the green channel,
        % which in a typical snapshot will be the least noisy channel.
        % grayImage = grayImage(:, :, 2); % Take green channel.
    end
%    grayImage = imcrop(grayImage,[0 480 1920 1080]);
    binaryImage = grayImage < 200;
    binaryImage = imcomplement(binaryImage);

CC = bwconncomp(binaryImage,8);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);
outputImage = ismember(L,find([S.Area]>200)) > 0;
% imshow(outputImage);
% 
SE =  strel('disk',10,8);
bianry_dialeted = imdilate(outputImage,SE);
bianry_dialeted = imdilate(bianry_dialeted,SE);
bianry_dialeted = imerode(bianry_dialeted,SE);
bianry_dialeted = imerode(bianry_dialeted,SE);
% imshow(bianry_dialeted);
outputImage = bianry_dialeted;
%% remove the largets circle
% CC = bwconncomp(outputImage,8);
% S = regionprops(CC, 'Area');
% L = labelmatrix(CC);
% [biggestArea, indexofBiggest] = sort([S.Area],'descend');
% indexofBiggest(1)= [];
% outputImage = ismember(L,indexofBiggest) > 0;

%% 
CC = bwconncomp(outputImage,8);
S = regionprops(CC, 'EulerNumber','Area','Perimeter');
L = labelmatrix(CC);
[biggestArea, indexofBiggest] = sort([S.Area],'descend');
indexofBiggest(1)= [];
perimeter = find([S.Perimeter]>200);
both_have = intersect(indexofBiggest,perimeter);
outputImage = ismember(L,both_have) > 0;

outputImage_2 = bwmorph(outputImage,'skel',inf);
% outputImage_3 = bwmorph(outputImage_2,'clean',inf);
IM = outputImage_2;
   
    %% use ransac find 7 lines
    % get coordiante of all 1s in bianry image
    [y, x] = find(IM);
    pts = [x, y];
    % transpose, let it be 2xm double 
    pts = pts.'; 

    iterNum = 300;
    thDist = 2;
    thInlrRatio = .1;
    f = figure('visible','off');
    imshow(IM); hold on;
    m = zeros(7,1);
    b = zeros(7,1);
    for j=1:7
        % remove dots which previous operation used
        if j ~=1
            pts(:,inlier_index) = [];
        end
        X = pts(1,:);
        [t,r,idx,inlier_index] = ransac(pts,iterNum,thDist,thInlrRatio);
        k1 = -tan(t);
        b1 = r/cos(t);
        % plot lines
        plot(X,k1*X+b1,'r');
        m(j) = k1; % first two lines must be those two horizontal lines 
        b(j) = b1;
    end

    %% find intersection 
    intersection = zeros(10,2);
    for i=1:5
        xintersect = (b(2+i)-b(2))/(m(2)-m(2+i));
        yintersect = m(2)*xintersect + b(2);
        plot(xintersect,yintersect,'x','LineWidth',20,'Color','red');
        intersection(i+i-1,1) = xintersect;
        intersection(i+i-1,2) = yintersect;

        xintersect = (b(2+i)-b(1))/(m(1)-m(2+i));
        yintersect = m(1)*xintersect + b(1);
        plot(xintersect,yintersect,'x','LineWidth',20,'Color','red');
        intersection(i+i,1) = xintersect;
        intersection(i+i,2) = yintersect;    
    end

    saveas(f,['test/filename' num2str(n) '.png']);
    intersection_temp = [];
    dot_sort_y= sortrows(intersection,1);
    loc = 1;
    while loc<10
        dot_low = dot_sort_y(loc:loc+1,:); 
        dot_low = sortrows(dot_low,2);
        intersection_temp = cat(1,intersection_temp, dot_low);
        loc=loc+2;
    end
    intersections(:,:,n) = intersection_temp;
end

end
