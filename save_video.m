function [] = save_video( images, videoName)
% save_video save multiple image into video
% Inputs:
%     images - a Nx1 cell of N images (projected_imgs for this assignment)
%     videoName - saved video name 
% example = save_video(projected_imgs,'clip1')
% QiuruiChen q.chen@studnet.utwente.nl

outputname = videoName;
profile = 'MPEG-4';
framerate = 10;
quality = 95;

wobj = VideoWriter(outputname,profile);
wobj.FrameRate = framerate;
wobj.Quality = quality;
open(wobj);

num_ima = length(images);
for i=1:num_ima
    img = images{i};        % read images
    writeVideo(wobj,img);   % save image into video
end
close(wobj)

end

