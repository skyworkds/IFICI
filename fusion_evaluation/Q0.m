function q01=Q0(x,y,blk_size)
%% 新增代码 解决当blk_size=1时程序遇到的问题 开始 20150625
if blk_size<2
    [m,n]=size(x);
    [re_m,re_n]=deal(m,n);
    if mod(m,2)>0
        re_m=m+1;
    end
    if mod(n,2)>0
        re_n=n+1;
    end
    if re_m~=m || re_n~=n
        x=imresize(x,[re_m,re_n]);
        y=imresize(y,[re_m,re_n]);
    end
    blk_size=blk_size+1;
end
%% 新增代码 解决当blk_size=1时程序遇到的问题 结束 20150625

x=double(x);
y=double(y);
[m,n]=size(x);

N=m*n;
B=blk_size;
% 对图像分块，把图像分成B*B大小的块，然后将每快重整为 B^2 *1的向量
matx1=rang_block(x,B);
matf=rang_block(y,B);
%计算所有块的 quality index
C=m*n/(B*B); %总共有C块
q0 = zeros(1,C);
for i=1:C
    q0(i)=Q0w(matx1(:,i),matf(:,i),B*B);
end
q01 = sum(q0)/C;