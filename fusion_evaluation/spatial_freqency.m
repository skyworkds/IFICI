function SF = spatial_freqency(X)
X = double(X)/255;
RF=0;
CF=0;
[H,W]=size(X);
for y=2:H
    for x=2:W
        RF=RF+(X(y,x)-X(y,x-1))*(X(y,x)-X(y,x-1));
        CF=CF+(X(y,x)-X(y-1,x))*(X(y,x)-X(y-1,x));
    end
end
SF = sqrt(RF+CF);