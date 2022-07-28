
%TNO
clc
clear all
close all

addpath(genpath(cd));


readTNOset;

 lambda = 1
 c_1 = 0.01; c_2 = 0.01; c_3=0.07; lambda1 = 1;lambda2 = 1;     % set parameters   
 epsilon_stop = 1e-3;  % 

for i=1:41
i

    visfilename = namelist(i).vis;
    imgvis  = double(imread(visfilename)); 
    nirfilename = namelist(i).nir;
    imgir = double(imread(nirfilename)); 
    fusionname =  namelist(i).fusion;

    
    [ visR, visL, visepsilon_R, visepsilon_L ] = dsprocessingnew( imgvis, c_1, c_2, c_3, lambda1,lambda2, epsilon_stop  );
    [ irR, irL, irepsilon_R, irepsilon_L ] = dsprocessingnew( imgir, c_1, c_2, c_3, lambda1,lambda2, epsilon_stop  );
    

    ParaRule.Low_Coeffs_Rule='max'; 
    ParaRule.High_Coeffs_Rule='max';
    fL = nsctfusion(visL,irL,ParaRule);

    ParaRule.Low_Coeffs_Rule='ave'; 
    % ParaRule.Low_Coeffs_Rule='max'; 
    ParaRule.High_Coeffs_Rule='max';  %
    fR = nsctfusion(visR,irR,ParaRule);
    
    f = fL.*fR;
    
%     f = tvdenoise(f,400,10,imgvis); %tvdenoise(f,lambda,NumSteps,u)  || f - u ||^2_L^2  +  lambda*TV(u)
%     imshow(f,[]);
    imwrite(uint8(f),fusionname);

end