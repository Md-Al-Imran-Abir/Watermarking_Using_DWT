function [r, g, b] = RGBComponents(RGB)
% Divides RGB image into its components
%   RGB: RGB image 
%   r: red component of the RGB image
%   g: green component of the RGB image
%   b: blue component of the RGB image

r = RGB(:, :, 1);
g = RGB(:, :, 2);
b = RGB(:, :, 3);

end