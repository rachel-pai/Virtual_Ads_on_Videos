function [ projected_img ] = inverse_warping( img_final, img_initial, pts_final, pts_initial )
% inverse_warping takes two images and a set of correspondences between
% them, and warps all the pts_initial in img_initial to the pts_final in 
% img_final,
% image_final: video images; img_initial:logo_img
% pts_final:interior_pts; 
% pts_initial:warped_logo_pts, video banner insertation corresponding points in banner
% round each element of X to the nearest integer greater than or equal to that element.
    
pts_final = ceil(pts_final);  
pts_initial = ceil(pts_initial);

ind_final= sub2ind([size(img_final,1), size(img_final,2)],...
    pts_final(:,2),...
    pts_final(:,1));
ind_initial = sub2ind([size(img_initial,1) size(img_initial,2)],...
    pts_initial(:,2),...
    pts_initial(:,1));

%HSI color
% read the original image
% call createMask function to get the mask and the filtered image
    [BW,~] = createMask(img_final);
%%
% plot the original image, mask and filtered image all in one figure
% subplot(1,3,1);imshow(I);title('Original Image');
% subplot(1,3,2);
% imshow(~BW);title('Mask');
%% 
% row, col, row = y, col=x
    [y,x] = find(~BW);
    mask =[x,y];
%     subplot(1,3,3);imshow(maskedRGBImage);title('Filtered Image');
    
    mask_final= sub2ind([size(img_final,1), size(img_final,2)],...
        mask(:,2),...
        mask(:,1)); 

%     [ia, ib] = ismember(ind_final, mask_final, 'rows');
    [C,ia2,~] = intersect(ind_final,mask_final,'rows');
    ind_initial2 = ind_initial;
    ind_initial2 = ind_initial2(ia2,:);
    
    projected_img = img_final;
    for color = 1:3
        sub_img_final = img_final(:,:,color); % video image 
        sub_img_initial = img_initial(:,:,color); % banner image
        % sub_img_final( ind_final) substitute pixels value in video image
        sub_img_final(C) = sub_img_initial(ind_initial2)*0.5 + sub_img_final(C)*0.5;
        projected_img(:,:,color) = sub_img_final;
    end
%     imshow(projected_img2);

% projected_img = img_final;
% 
% for color = 1:3
%     sub_img_final = img_final(:,:,color);
%     sub_img_initial = img_initial(:,:,color);
%     sub_img_final(ind_final) = sub_img_initial(ind_initial)*0.5 + sub_img_final(ind_final)*0.5;
%     projected_img(:,:,color) = sub_img_final;
% end

end

