%% QiuruiChen q.chen@student.utwente.nl
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
%% read images 
Folder = 'data/';
FileList = dir(fullfile(Folder, '*.jpg'));
%% 
frameSpec = {};
% for iFile = 1:length(FileList)
for iFile = 45:85
    aFile = fullfile(Folder, FileList(iFile).name);
    frameSpec{iFile-44} = imread(aFile);
end

%% find intersection of court lines 
 intersection_all  = find_intersection( frameSpec );
%% get the intrinsic matrix 
worldPoints = [0 0;0 30000;20000 0;20000 30000;30000 0;30000 30000;40000 0;40000 30000;60000 0;60000 30000];
imageSize = [size(frameSpec{1}, 1), size(frameSpec{1}, 2)];
[cameraParams, ~, estimationErrors] = estimateCameraParameters(intersection_all, worldPoints, ...
                                     'ImageSize', imageSize);

                                 
%% show extrinsics
% figure;
% showExtrinsics(cameraParams);
%% for each frame find the corresponding corners 
%  read all frame 
frameRGB = {};
for iFile = 1:130
    aFile = fullfile(Folder, FileList(iFile).name);
    frameRGB{iFile} = imread(aFile);
end
%%
intersection_all  = find_intersection( frameRGB );
%%
for n = 1:length(frameRGB)
    [rotationMatrix,translationVector] = extrinsics(...
    intersection_all(:,:,n),worldPoints,cameraParams);
%     rotationMatrix = cameraParams.RotationMatrices(:,:,n);
%     translationVector = cameraParams.TranslationVectors(n,:);
    P = cameraMatrix(cameraParams,rotationMatrix,translationVector);

%  insertWorldPoints = [0,-8000,0;0,-3000,0;20000,-3000,0;20000,-8000,0];
    insertWorldPoints = [0,-10000,0;20000,-10000,0;20000,-5000,0;0,-5000,0];
    imagePoints(:,:,n) = worldToImage(cameraParams,rotationMatrix,translationVector,insertWorldPoints);
%     banner = imread('utwente.jpg');
%     banner_resized = imresize(banner, [50 200]);
end
%%
save imagePoints imagePoints
