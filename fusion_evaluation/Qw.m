function Qwout = Qw( x1,x2,f,blk_size )
%% by zoe 2012/1/3 email:dreamcather1986@163.com
%compute the weighted fusion quality index
% ���룺Դͼ��a,b
%       �ں�ͼ��f
%       �ֿ��Сble_size
%�����the weighted fusion quality index
%% �������� �����blk_size=1ʱ�������������� ��ʼ 20190625
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
%% �������� �����blk_size=1ʱ�������������� ���� 20190625

x1=double(x1);
x2=double(x2);
f=double(f);
[m,n]=size(f);
B=blk_size;
% ��ͼ��ֿ飬��ͼ��ֳ�B*B��С�Ŀ飬Ȼ��ÿ������Ϊ B^2 *1������
matx1=rang_block(x1,B);
matx2=rang_block(x2,B);
matf=rang_block(f,B);
%�������п�� quality index
C=(m*n)/(B*B); %�ܹ���C��
q=0; %������ʼֵ
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
