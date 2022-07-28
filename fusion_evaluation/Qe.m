function Qeout = Qe(x1,x2,f,blk_size,qw1)
%% by zoe 2012/1/3 email:dreamcather1986@163.com
%compute the edge-dependent fusion quality index 
apl=1;
x1=edge(x1,'canny'); % edge image of a
x2=edge(x2,'canny');
f=edge(f,'canny');
qw2= Qw(x1,x2,f,blk_size);
Qeout=qw1^(1-apl) * qw2^apl;


