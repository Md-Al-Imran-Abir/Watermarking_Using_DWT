function image = iDWT2Level(coeff, wname)
% Performs 2 level discrete wavelet transformation
%   image: output image
%   wname: Name of wavelet, example: 'haar', 'db10', 'sym8', etc.
%   coeff: 2nd level approximation and detail ...
%                       coefficient matrices

co = coeff;

cA = idwt2(co(:,:,1), co(:,:,2), co(:,:,3), co(:,:,4), wname);
cV = idwt2(co(:,:,5), co(:,:,6), co(:,:,7), co(:,:,8), wname);
cH = idwt2(co(:,:,9), co(:,:,10), co(:,:,11), co(:,:,12), wname);
cD = idwt2(co(:,:,13), co(:,:,14), co(:,:,15), co(:,:,16), wname);

image = idwt2(cA, cV, cH, cD, wname);