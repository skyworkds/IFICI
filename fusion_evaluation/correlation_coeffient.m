function [ resu ] = correlation_coeffient( imgA,imgF)
%CORRELATION_COEFFIENT 此处显示有关此函数的摘要
%   此处显示详细说明
[h,w]=size(imgA);
imgA=double(imgA);
imgF=double(imgF);
avg_A=mean(mean(imgA));
avg_F=mean(mean(imgF));
% numerator分子
numerator_AF =0;
var_A=0;
var_F=0;
for y=1:h
    for x=1:w
       numerator_AF=((imgA(y,x)-avg_A)*(imgF(y,x)-avg_F))+numerator_AF;
       var_A=var_A+((imgA(y,x)-avg_A)*(imgA(y,x)-avg_A));
       var_F=var_F+((imgF(y,x)-avg_F)*(imgF(y,x)-avg_F));
    end
end
% denominator 分母
denominator_AF=sqrt(double(var_A*var_F));
resu=double(numerator_AF)/denominator_AF;
end
