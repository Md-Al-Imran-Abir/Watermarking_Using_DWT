function [LL3, LH3, HL3, HH3] = DWT3Level(image, wname)
% Performs 3 level discrete wavelet transformation
%   image: input image
%   wname: Name of wavelet, example: 'haar', 'db10', 'sym8', etc.
%   LL3, LH3, HL3, HH3: 3rd level approximation and detail ...
%                       coefficient matrices

[cA, cV, cH, cD] = dwt2(image, wname);

[cA21, cV21, cH21, cD21] = dwt2(cA, wname);
[cA22, cV22, cH22, cD22] = dwt2(cV, wname);
[cA23, cV23, cH23, cD23] = dwt2(cH, wname);
[cA24, cV24, vH24, cD24] = dwt2(cD, wname);

