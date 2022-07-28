function mutural_informationR=mutural_information(grey_matrixA,grey_matrixB,grey_matrixF,grey_level)
% mutural_informationR=mutural_information(grey_matrixA,grey_matrixB,grey_matrixF,grey_level)
% compute mutural information of the image
% grey_matrixA , grey_matrixB,grey_matrixF are grey values of imageA,imageB and fusion image
% grey_level is the grayscale degree of image
% please set grey_level=256

HA=information_entropy(grey_matrixA,grey_level);
HB=information_entropy(grey_matrixB,grey_level);
HF=information_entropy(grey_matrixF,grey_level);
HFA=Hab(grey_matrixF,grey_matrixA,grey_level);
HFB=Hab(grey_matrixF,grey_matrixB,grey_level);
MIFA=HA+HF-HFA;
MIFB=HB+HF-HFB;
mutural_informationR=MIFA+MIFB;
