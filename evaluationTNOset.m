    clc
    clear all
close all


method = 0; % 0 
if method == 0
    addpath 'fusion_evaluation';
   readTNOset;
   indexs = [1:1:41];
    evnames={'EN'};
    evnames ={evnames, 'avgradient','edgestrength','sd', 'avgray', 'imagesharp', 'MI', 'Qabf', 'Q0', 'Qw', 'Qe', 'PSNR', 'FMI', 'SSIM', 'SF', 'RMSE','CC'};
%     xlswrite('TNO.xlsx',indexs,1,'b1:v1');
    for i=1:17
        xlswrite('TNO.xlsx',cellstr(evnames{i}),1,['a',num2str(i+1)]);
    end

   alph = 'a':'z'; 
    cellheads={};
    for i=1:26 %26
        cellheads{i} =strcat(alph(i));
    end   
    for i=1:26  %52
        cellheads{i+26} =strcat('a', alph(i)) ;
    end  

    for i=1:41
        i
        visfilename = namelist(i).vis;
        imgvis  = imread(visfilename); 
        nirfilename = namelist(i).nir;
        imgir = imread(nirfilename); 
        fusionname =  namelist(i).fusion;
        imgfusion = imread(fusionname); 

        vresult = Evaluation(imgir,imgvis,imgfusion,256);
        cellname = strcat(cellheads(i+1),'2:',cellheads(i+1),'19');
        
        xlswrite('TNO.xlsx',vresult',1,cellname{1})
    end
end

if method == 1
	 easy = 1; % easy = 1 means that the test runs are not time-consuming metrics, easy = 0 means that the test is time-consuming metrics
	
    addpath 'evaluation';
    readTNOset;
    indexs = [1:1:41];
    evnames={'EN'};
    evnames ={evnames, 'SF','SD','PSNR','MSE', 'MI', 'VIF', 'AG', 'CC', 'SCD', 'Qabf', 'Nabf', 'SSIM', 'MS_SSIM', 'FMI_pixel', 'FMI_dct', 'FMI_w'};
%     xlswrite('TNO.xlsx',indexs,1,'b1:v1');
    for i=1:17
        xlswrite('TNOsun.xlsx',cellstr(evnames{i}),1,['a',num2str(i+1)]);
    end

    alph = 'a':'z'; 
    cellheads={};
    for i=1:26 %26
        cellheads{i} =strcat(alph(i));
    end   
    for i=1:26  %52
        cellheads{i+26} =strcat('a', alph(i)) ;
    end  

    
    for i=1:41
        i
        visfilename = namelist(i).vis;
        imgvis  = imread(visfilename); 
        nirfilename = namelist(i).nir;
        imgir = imread(nirfilename); 
        fusionname =  namelist(i).fusion;
        imgfusion = imread(fusionname); 

%         vresult = Evaluation(imgir,imgvis,imgfusion,256);
        [EN, SF,SD,PSNR,MSE, MI, VIF, AG, CC, SCD, Qabf, Nabf, SSIM, MS_SSIM, FMI_pixel, FMI_dct, FMI_w] = analysis_Reference(imgfusion,imgir,imgvis, easy);
        Result=zeros(1,17);
        vresult(1,1) = EN; vresult(1,2) = SF; vresult(1,3) = SD; vresult(1,4) = PSNR; vresult(1,5) = MSE; vresult(1,6) = MI; 
        vresult(1,7) = VIF; vresult(1,8) = AG; vresult(1,9) = CC; vresult(1,10) = SCD; vresult(1,11) = Qabf; vresult(1,12) = Nabf; 
        vresult(1,13) = SSIM; vresult(1,14) = MS_SSIM; vresult(1,15) = FMI_pixel; vresult(1,16) = FMI_dct; vresult(1,17) = FMI_w; 
        
        cellname = strcat(cellheads(i+1),'2:',cellheads(i+1),'18');
        xlswrite('TNOsun.xlsx',vresult',1,cellname{1})
    end
   
end





    