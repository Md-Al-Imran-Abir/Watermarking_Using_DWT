%% Watermarking: 2nd Attempt
% Initiate
% clc
% clear
% close all


%% Frame Splitting

tic
disp("Frame Splitting...")
vidPath = "D:\MSc\DIP\Project\Matlab\Sample_Video.mp4"; % video path
msgImgPath = "D:\MSc\DIP\Project\Matlab\image_10.jpg"; % message image path

vidObj = VideoReader(vidPath); % Load video

%% Video Parameters

nFrames = vidObj.NumFrames; % number of params
vidH = vidObj.Height; % frame height
vidW = vidObj.Width; % frame width
print1 = sprintf("Number of frames = %d\nFrame height = %d..." + ...
    "\nFrame width = %d", nFrames, vidH, vidW);
disp(print1)
% Create empty frames and Copy video into those frames
mov(1:nFrames) = struct('cdata', zeros(vidH, vidW, 3, 'uint8'),...
    'colormap',[]);
%% copy video frames into the struct
for k = 1:nFrames
    mov(k).cdata = read(vidObj, k);
end
fprintf('Loaded %d frames successfully\n', nFrames)
toc

%% Divide the message image into rgb components

tic
msg = imread(msgImgPath);
[msgH, msgW] = size(msg);
fprintf('Height = %d and width = %d', msgH, msgW)
rszMsg = imresize(msg, [vidH vidW]);
[rszMsgH, rszMsgW, ~] = size(rszMsg);
fprintf('Resize image height = %d and width = %d \nShould be %d and %d',...
    rszMsgH, rszMsgW, vidH, vidW)
[rMsg, gMsg, bMsg] = RGBComponents(rszMsg);
toc

%% Embed Message Image into Video Frames
% Initialization
tic
mov_reserved = mov; % Keeping a main copy of the video frames
%VidFrame = mov(400:412).cdata
% initializing frames for rgb components of the frames
rFrame = zeros(vidH, vidW, 16*3);
gFrame = zeros(vidH, vidW, 16*3);
bFrame = zeros(vidH, vidW, 16*3);

% initializing frames for watermarking
rFrame_wm = zeros(vidH, vidW, 16*3);

% 2-Level DWT of message image
rMsg_coeff = DWT2Level(rMsg, 'haar');
gMsg_coeff = DWT2Level(gMsg, 'haar');
bMsg_coeff = DWT2Level(bMsg, 'haar');
msg_coeff = [reshape(rMsg_coeff.', 1, []), reshape(gMsg_coeff.', 1, []),...
   reshape(bMsg_coeff.', 1, [])]; %combine all into a row vector 
                                  %just to make thinking about it easier
toc

%% Embedding
tic
scl_factor = 0.01;
for i = 1:16*3
    [rFrame(:, :, i), gFrame(:, :, i), bFrame(:, :, i)] ...
        = RGBComponents(mov(350+i).cdata);
    [cAframe, cVframe, cHframe, cDframe] = dwt2(rFrame(:, :, i), 'haar');
    [cAframe2, cVframe2, cHframe2, cDframe2] = dwt2(cAframe, 'haar');
    cAframe_wm = cAframe2 + scl_factor * msg_coeff(i).coeff;
    rFrame_wm_idwt_1 = idwt2(cAframe_wm, cVframe2, cHframe2, cDframe2, 'haar');
    rFrame_wm(:, :, i) = idwt2(rFrame_wm_idwt_1, cVframe, cHframe, cDframe, 'haar');
    mov(350+i).cdata = uint8(cat(3, rFrame_wm(:, :, i), ...
        gFrame(:, :, i), bFrame(:, :, i)));
end
toc

%% Playing Original and Embedded videos
%tic
%h1 = implay(mov_reserved, vidObj.FrameRate)
%h2 = implay(mov, vidObj.FrameRate)
%toc

%% Writing Watermarked video in a video file
tic
wm_video = VideoWriter('Watermarked_video_3_attempt_2.mp4', 'MPEG-4');
open(wm_video);

for m = 1:nFrames
    %img = readFrame(mov(m).cdata);
    writeVideo(wm_video, mov(m).cdata);
end

close(wm_video);
toc
