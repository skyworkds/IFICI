function [ resu] = RMSE(img_A,img_B)
%MSE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
img_A=double(img_A);
img_B=double(img_B);
[h,w]=size(img_A);
resu=sqrt(sum(sum((img_A-img_B).^2))/(h*w));
end

