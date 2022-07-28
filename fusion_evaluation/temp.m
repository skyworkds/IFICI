
img = imread('images\b28_1.tif');
% img = imread('D:\matlab\0点目标\dl\data\论文图像testimage\videoplayback (15)_Moment.jpg');
if(size(img,3)>1)
    img = rgb2gray(img);
end
I_read = double(img);

f=fft2(img);        
f=fftshift(f);      
margin=log(abs(f));     
phase=(angle(f));     %图像相位谱
figure,imshow(img);

f=1/121*ones(11);%低通滤波器，滤除高频噪声
oldmargin = margin;
margin=imfilter(margin,f);
oldmargin = oldmargin - oldmargin;
R_P_e = exp(margin).*exp(phase*sqrt(-1));

R_P_e=ifftshift(R_P_e);      %使图像对称A*e^(jB)
I = ifft2((R_P_e));
figure,imshow(abs(I),[]);

figure,imshow(img,[]);
figure,imshow(abs(I)+double(img),[]);
figure,imshow(I,[]);

pause;

clear all
Picture = imread('images\b28_1.tif');
if(size(Picture,3)>1) 
    Picture_Gray = rgb2gray(Picture);%灰度处理
else
    Picture_Gray = Picture;
end
 
Picture_FFT = fft2(Picture_Gray);%傅里叶变换
Picture_FFT_Shift = fftshift(Picture_FFT);%对频谱进行移动，是0频率点在中心
Picture_AM_Spectrum = log(abs(Picture_FFT_Shift));%获得傅里叶变换的幅度谱
Picture_Phase_Specture = log(angle(Picture_FFT_Shift)*180/pi);%获得傅里叶变换的相位谱
Picture_Restructure = ifft2(abs(Picture_FFT).*exp(j*(angle(Picture_FFT))));%双谱重构
figure(1)
subplot(221)
imshow(Picture_Gray)
title('原图像')
subplot(222)
imshow(Picture_AM_Spectrum,[])%显示图像的幅度谱，参数'[]'是为了将其值线性拉伸
title('图像幅度谱')
subplot(223)
imshow(Picture_Phase_Specture,[]);
title('图像相位谱')
subplot(224)
imshow(Picture_Restructure,[]);
title('双谱重构图')
