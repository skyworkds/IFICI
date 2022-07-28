function [img_mean, img_var] = variance(img)
%VARIANCE Calculate the grayscale mean and standard deviation of the image.
%   [img_mean,img_var] = VARIANCE(img) calculates the mean and standard 
%   deviation of the image, parameter img is an array containing the image 
%   data.
% 
%   The return value img_mean is the grayscale mean  of the image, and the 
%   return value img_var is the standard deviation of the image.
%   计算图像的灰度均值和标准差。

img = double(img); 
% Get rows and colums of img 
[r, c] = size(img); 

% Mean value
img_mean = mean(mean(img));

% Variance 
[~, c_mean] = size(img_mean);
%   If the source image is a grayscale image
if c_mean == 1
    img_var = sqrt(sum(sum((img - img_mean).^2)) / (r * c ));
%   If the source image is a truecolor image
else if c_mean == 3
        img_mean = mean(img_mean);
        img_var = mean(sqrt(sum(sum((img - img_mean).^2)) / (r * c )));
    end
end
end