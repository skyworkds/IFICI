function mi=MI(image1,image2)  
[M,N]=size(image1);
hxy = zeros(256,256);
hx = zeros(1,256);
hy = zeros(1,256);

 %%%%�ж��ǲ������ֵ����Сֵ��һ���ģ���֤����ͼ��ĻҶ�ֵ����һ����
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
       hxy(a,b) = hxy(a,b)+1;  %%��������ͼ���Ӧ�����Ϣ��  ���ϸ����ܶ�
       hx(a) = hx(a)+1;         %%��Ե�����ܶ�
       hy(b) = hy(b)+1;          %%%��Ե�����ܶ�
   end
end

%%����Ϣ��
hs = sum(sum(hxy));
index = find(hxy~=0);
p = hxy/hs;%%�����
Hxy = sum(sum(-p(index).*log(p(index)))); 

%%%�󵥸���Ϣ��--x
hs = sum(sum(hx));
index = find(hx~=0);
p = hx/hs;
Hx = sum(sum(-p(index).*log(p(index))));

%%%�󵥸���Ϣ��--y
hs = sum(sum(hy));
index = find(hy~=0);
p = hy/hs;
Hy = sum(sum(-p(index).*log(p(index))));

%%����������
mi = Hx+Hy-Hxy;