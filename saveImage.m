% Qiuruichen q.chen@student.utwente.nl
% save video into images 
close all
clear variables
clc;
%% save Frame into image
Folder = 'data/';
fname ='volleyball.mp4';
vidReader = VideoReader(fname);
opticFlow = opticalFlowFarneback;
iFrame = 1;
while hasFrame(vidReader)
  frames =readFrame(vidReader);
  imwrite(frames, fullfile(Folder, sprintf('%06d.jpg', iFrame)));
  iFrame =iFrame+1;
end

