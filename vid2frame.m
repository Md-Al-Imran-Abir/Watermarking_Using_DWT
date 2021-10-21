function y = vid2frame(vidObj)
% warning off;
% clear all;
% close all;
% clc;
% 
% obj =VideoReader('Free Nature Stock Footage Clip from VideoBlocks.mp4');
vid = read(vidObj);
frames = vidObj.NumberOfFrames; %Read the Total number of frames and displyed in command window 
ST='.bmp';

%%ex)readind and writing the 100 frames 

%if u want to change the values means replace upto 1:776

 for x = 1:frames
      Sx=num2str(x);
      Strc=strcat(Sx,ST);
      Vid=read(vidObj,x);
      imwrite(Vid,Strc);
 end
 