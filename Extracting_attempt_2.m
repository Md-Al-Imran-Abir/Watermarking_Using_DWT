%% Initiate
clc
clear
close all

%% Loading Watermarked Video
tic
vidPathE = "D:\MSc\DIP\Project\Matlab\Watermarked_video_3_attempt_2.mp4";
vidObjE = VideoReader(vidPathE);
%% Video Parameters
nFramesE = vidObjE.NumFrames; % no of frames in the video
vidHe =  vidObjE.Height; % frame height
vidWe = vidObjE.Width; % frame width
fprintf('Number of frames = %d\nFrame Height = %d\nFrame Width = %d',...
    nFramesE, vidHe, vidWe)
%% Create Empty Frames and Load Video Frames into those
% create frames as structure
movE(1:nFramesE) = struct('cdata', zeros(vidHe, vidWe, 3, 'uint8'),...
    'colormap', []);
% copy video frames into the mov struct
for k = 1:nFramesE
    movE(k).cdata = read(vidObjE, k);
end
fprintf('Loaded %d frames sucsessfully', nFramesE)
toc

%% Loading Main Video
tic
vidPathM = "D:\MSc\DIP\Project\Matlab\Sample_Video.mp4"; % video path

vidObjM = VideoReader(vidPathM); % Load video

%% Video Parameters

nFramesM = vidObjM.NumFrames; % number of params
vidHm = vidObjM.Height; % frame height
vidWm = vidObjM.Width; % frame width
print1 = sprintf("Number of frames = %d\nFrame height = %d..." + ...
    "\nFrame width = %d", nFramesM, vidHm, vidWm);
disp(print1)
%% Create empty frames and Copy video into those frames
movM(1:nFramesM) = struct('cdata', zeros(vidHm, vidWm, 3, 'uint8'),...
    'colormap',[]);
%copy video frames into the struct
for k = 1:nFramesM
    movM(k).cdata = read(vidObjM, k);
end
fprintf('Loaded %d frames successfully\n', nFramesM)
toc

%% De-Embedding of Message Image
% Initializing to keep message image's rgb components' coefficients
rCoeff = zeros(180, 320, 16);
gCoeff = zeros(180, 320, 16);
bCoeff = zeros(180, 320, 16);

scl_factorE = 0.01;
for i = 1:16*3
    % DWT on watermarked video frame
    [rFrameE, ~, ~] = RGBComponents(movE(350+i).cdata);
    [cAframeE1, cVframeE1, cHframeE1, cDframeE1] = dwt2(rFrameE, 'haar');
    [cAframeE, cVframeE, cHframeE, cDframeE] = dwt2(cAframeE1, 'haar');
    % DWT on main video frame
    [rFrameM, ~, ~] = RGBComponents(movM(350+i).cdata);
    [cAframeM1, cVframeM1, cHframeM1, cDframeM1] = dwt2(rFrameM, 'haar');
    [cAframeM, cVframeM, cHframeM, cDframeM] = dwt2(cAframeM1, 'haar');
%     fprintf('iteration no: %d and size = [%d,%d]\n', i, size(cAframeE))%(cAframeE - cAframeM) / scl_factorE))
    if i<=16
        rCoeff(:, :, i) = (cAframeE - cAframeM) / scl_factorE;
    elseif (i>=17) && (i<=32)
        gCoeff(:, :, i-16) = (cAframeE - cAframeM) / scl_factorE;
    else
        bCoeff(:, :, i-32) = (cAframeE - cAframeM) / scl_factorE;
    end
end

%% Extracting the Message Image
rMsgE = iDWT2Level(rCoeff, 'haar');
gMsgE = iDWT2Level(gCoeff, 'haar');
bMsgE = iDWT2Level(bCoeff, 'haar');

msgImg = cat(3, rMsgE, gMsgE, bMsgE);
figure
imshow(msgImg)

imshow(rMsgE)

%misc = imread(exp.jpg)
