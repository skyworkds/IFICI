function Qwout = Qw( x1,x2,f,blk_size )
%% by zoe 2012/1/3 email:dreamcather1986@163.com
%compute the weighted fusion quality index
% 输入：源图像a,b
%       融合图像f
%       分块大小ble_size
%输出：the weighted fusion quality index
%% 新增代码 解决当blk_size=1时程序遇到的问题 开始 20190625
if blk_size<2
    [m,n]=size(x1);
    [re_m,re_n]=deal(m,n);
    if mod(m,2)>0
        re_m=m+1;
    end
    if mod(n,2)>0
        re_n=n+1;
    end
    if re_m~=m || re_n~=n
        x1=imresize(x1,[re_m,re_n]);
        x2=imresize(x2,[re_m,re_n]);
        f=imresize(f,[re_m,re_n]);
    end
    blk_size=blk_size+1;
end
%% 新增代码 解决当blk_size=1时程序遇到的问题 结束 20190625

x1=double(x1);
x2=double(x2);
f=double(f);
[m,n]=size(f);
B=blk_size;
% 对图像分块，把图像分成B*B大小的块，然后将每快重整为 B^2 *1的向量
matx1=rang_block(x1,B);
matx2=rang_block(x2,B);
matf=rang_block(f,B);
%计算所有块的 quality index
C=(m*n)/(B*B); %总共有C块
q=0; %质量初始值
CW=zeros(1,C);
for j=1:C
     saw=var(matx1(:,j));
     sbw=var(matx2(:,j));
     cw=max(saw,sbw);
     CW(j)=cw;
end
CWS=sum(CW);
for i=1:C
    q0a=Q0w(matx1(:,i),matf(:,i),B*B);
    q0b=Q0w(matx2(:,i),matf(:,i),B*B);
    saw=var(matx1(:,i));
    sbw=var(matx2(:,i));
    if(saw==0&&sbw==0)
        rw=0.5;
  else
        rw=saw/(saw+sbw);
   end
    cw=max(saw,sbw)/CWS;
    q=q+(rw*q0a+(1-rw)*q0b)*cw;
end
Qwout=q; 
