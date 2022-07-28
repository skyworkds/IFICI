function [ resu] = RMSE(img_A,img_B)
%MSE 此处显示有关此函数的摘要
%   此处显示详细说明
img_A=double(img_A);
img_B=double(img_B);
[h,w]=size(img_A);
resu=sqrt(sum(sum((img_A-img_B).^2))/(h*w));
end

