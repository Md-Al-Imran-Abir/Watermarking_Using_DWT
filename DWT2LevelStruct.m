function coeff = DWT2LevelStruct(image, wname)
% Performs 2 level discrete wavelet transformation
%   image: input image
%   wname: Name of wavelet, example: 'haar', 'db10', 'sym8', etc.
%   coeff: 2nd level approximation and detail ...
%                       coefficient matrices

[cA, cV, cH, cD] = dwt2(image, wname);

[sa, sb] = size(cA);
sac = sa/2;
sbc = sb/2;

coeff(1:16) = struct('coeff', zeros(sac, sbc));

[coeff(1).coeff, coeff(2).coeff, coeff(3).coeff, coeff(4).coeff] = dwt2(cA, wname);
[coeff(5).coeff, coeff(6).coeff, coeff(7).coeff, coeff(8).coeff] = dwt2(cV, wname);
[coeff(9).coeff, coeff(10).coeff, coeff(11).coeff, coeff(12).coeff] = dwt2(cH, wname);
[coeff(13).coeff, coeff(14).coeff, coeff(15).coeff, coeff(16).coeff] = dwt2(cD, wname);

%coeff = coeffS;

% coeff = [coeffs(1).coeff, cV21, cH21, cD21;
%          cA22, cV22, cH22, cD22;
%          cA23, cV23, cH23, cD23;
%          cA24, cV24, cH24, cD24];