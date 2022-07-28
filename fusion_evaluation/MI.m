function mi=MI(image1,image2)  
[M,N]=size(image1);
hxy = zeros(256,256);
hx = zeros(1,256);
hy = zeros(1,256);

 %%%%判断是不是最大值和最小值是一样的，保证整幅图像的灰度值不是一样的
if max(max(image1))~=min(min(image1)) 
    image1 = (image1-min(min(image1)))/(max(max(image1))-min(min(image1)));
else
    image1 = zeros(M,N);
end
 
if max(max(image2))~=min(min(image2))
    image2 = (image2-min(min(image2)))/(max(max(image2))-min(min(image2)));
else
    image2 = zeros(M,N);
end

image1 = double(int16(image1*255))+1;
image2 = double(int16(image2*255))+1;


for i=1:M
    for j=1:N
       a = image1(i,j);
       b = image2(i,j) ;
       hxy(a,b) = hxy(a,b)+1;  %%计算两幅图像对应点的信息量  联合概率密度
       hx(a) = hx(a)+1;         %%边缘概率密度
       hy(b) = hy(b)+1;          %%%边缘概率密度
   end
end

%%求互信息熵
hs = sum(sum(hxy));
index = find(hxy~=0);
p = hxy/hs;%%求概率
Hxy = sum(sum(-p(index).*log(p(index)))); 

%%%求单个信息熵--x
hs = sum(sum(hx));
index = find(hx~=0);
p = hx/hs;
Hx = sum(sum(-p(index).*log(p(index))));

%%%求单个信息熵--y
hs = sum(sum(hy));
index = find(hy~=0);
p = hy/hs;
Hy = sum(sum(-p(index).*log(p(index))));

%%计算联合熵
mi = Hx+Hy-Hxy;