%% QiuruiChen q.chen@student.utwente.nl
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
%%
% Load logo image. Replace with your image as desired.
logo_img = imread('utwente.jpg');
% Generate logo points (they are just the outer corners of the image)
[logoy, logox, ~] = size(logo_img);
logo_pts = [0 0; logox 0; logox logoy; 0 logoy];

% Load the points that the logo corners will map onto in the main image
load imagePoints.mat
num_ima = size(imagePoints, 3); %% imagePoints 

% Set of images to test on
test_images = 1:num_ima; 
num_test = length(test_images);

% Initialize the images
video_imgs = cell(num_test, 1);
projected_imgs = cell(num_test, 1);

Folder = 'data/';
FileList = dir(fullfile(Folder, '*.jpg'));

for iFile = 1:130
    aFile = fullfile(Folder, FileList(iFile).name);
    video_imgs{iFile} = imread(aFile);
end

%%
for i=1:num_ima

    % Find all points in the video frame inside the polygon defined by
    % imagePoints
    % calculate_interior_pts input image_size and corners 
    [ interior_pts ] = calculate_interior_pts(size(video_imgs{i}),...
        imagePoints(:,:,test_images(i)));
    
%     Warp the interior_pts to coordinates in the logo image
    warped_logo_pts = warp_pts(imagePoints(:,:,i),...
        logo_pts,...
        interior_pts);

%     Copy the RGB values from the logo_img to the video frame
    projected_imgs{i} = inverse_warping(video_imgs{i},...
        logo_img,...
        interior_pts,...
        warped_logo_pts);

end

%% save videos
videoName ='clip1';          
save_video(projected_imgs,videoName)