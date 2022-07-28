function q01=Q0(x,y,blk_size)
%% �������� �����blk_size=1ʱ�������������� ��ʼ 20150625
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
%% �������� �����blk_size=1ʱ�������������� ���� 20150625

x=double(x);
y=double(y);
[m,n]=size(x);

N=m*n;
B=blk_size;
% ��ͼ��ֿ飬��ͼ��ֳ�B*B��С�Ŀ飬Ȼ��ÿ������Ϊ B^2 *1������
matx1=rang_block(x,B);
matf=rang_block(y,B);
%�������п�� quality index
C=m*n/(B*B); %�ܹ���C��
q0 = zeros(1,C);
for i=1:C
    q0(i)=Q0w(matx1(:,i),matf(:,i),B*B);
end
q01 = sum(q0)/C;