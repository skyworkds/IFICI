clc;
addpath 'src_iv_images';
% img_ir=imread('images\b04_1.tif');
% img_vis=imread('images\b04_2.tif');
% img_f=imread('images\4.tif');
% 
% 
% img_f=imread('test\fused2_mdlatlrr_level_4_nu_stride_1.png');


img_ir=imread('src_iv_images\b01_1.png');
img_vis=imread('src_iv_images\b01_2.png');
% img_f=imread('images\4.tif');

img_f=imread('ours\result.png');

img_f  = imresize(img_f,size(img_ir));

Evaluation(img_ir,img_vis,img_f,256);
% A=double(pixtrans(double(img_ir)));
% B=double(pixtrans(double(img_f)));
% [h,w]=size(A);
% resu=(A-B).^2;