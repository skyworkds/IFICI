
img = imread('images\b28_1.tif');
% img = imread('D:\matlab\0��Ŀ��\dl\data\����ͼ��testimage\videoplayback (15)_Moment.jpg');
if(size(img,3)>1)
    img = rgb2gray(img);
end
I_read = double(img);

f=fft2(img);        
f=fftshift(f);      
margin=log(abs(f));     
phase=(angle(f));     %ͼ����λ��
figure,imshow(img);

f=1/121*ones(11);%��ͨ�˲������˳���Ƶ����
oldmargin = margin;
margin=imfilter(margin,f);
oldmargin = oldmargin - oldmargin;
R_P_e = exp(margin).*exp(phase*sqrt(-1));

R_P_e=ifftshift(R_P_e);      %ʹͼ��Գ�A*e^(jB)
I = ifft2((R_P_e));
figure,imshow(abs(I),[]);

figure,imshow(img,[]);
figure,imshow(abs(I)+double(img),[]);
figure,imshow(I,[]);

pause;

clear all
Picture = imread('images\b28_1.tif');
if(size(Picture,3)>1) 
    Picture_Gray = rgb2gray(Picture);%�Ҷȴ���
else
    Picture_Gray = Picture;
end
 
Picture_FFT = fft2(Picture_Gray);%����Ҷ�任
Picture_FFT_Shift = fftshift(Picture_FFT);%��Ƶ�׽����ƶ�����0Ƶ�ʵ�������
Picture_AM_Spectrum = log(abs(Picture_FFT_Shift));%��ø���Ҷ�任�ķ�����
Picture_Phase_Specture = log(angle(Picture_FFT_Shift)*180/pi);%��ø���Ҷ�任����λ��
Picture_Restructure = ifft2(abs(Picture_FFT).*exp(j*(angle(Picture_FFT))));%˫���ع�
figure(1)
subplot(221)
imshow(Picture_Gray)
title('ԭͼ��')
subplot(222)
imshow(Picture_AM_Spectrum,[])%��ʾͼ��ķ����ף�����'[]'��Ϊ�˽���ֵ��������
title('ͼ�������')
subplot(223)
imshow(Picture_Phase_Specture,[]);
title('ͼ����λ��')
subplot(224)
imshow(Picture_Restructure,[]);
title('˫���ع�ͼ')
