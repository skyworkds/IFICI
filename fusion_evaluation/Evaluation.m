function Result=Evaluation(grey_matrixA,grey_matrixB,fusion_matrix,grey_level)
%建议输入图像的尺度时0-255
if mod(size(grey_matrixA,1),8) == 0 && mod(size(grey_matrixA,2),8) == 0 
    blk_size = 8;
else
    blk_size = gcd(size(grey_matrixA,1),size(grey_matrixA,2));
end

Result=zeros(1,17);
Result(1,1)=information_entropy(fusion_matrix,grey_level);  %融合图像的信息熵
fprintf('信息熵：%f\n',Result(1,1));
Result(1,2)=avg_gradient(fusion_matrix);                    %平均梯度
fprintf('平均梯度：%f\n',Result(1,2));
Result(1,3)=edge_intensity(fusion_matrix);                  %边缘强度
fprintf('边缘强度：%f\n',Result(1,3));
[img_mean, img_var] = variance(fusion_matrix);             %灰度均值，标准差(均方差MSE)
Result(1,4)=img_var;
Result(1,5)=img_mean;
fprintf('标准差：%f\n',Result(1,4));
fprintf('灰度均值：%f\n', Result(1,5));
Result(1,6)=figure_definition(fusion_matrix);               %图像清晰度
fprintf('图像清晰度：%f\n',Result(1,6));
Result(1,7)=mutural_information(grey_matrixA,grey_matrixB,fusion_matrix,grey_level);    %互信息
fprintf('互信息：%f\n',Result(1,7));
Result(1,8)=Qabf(grey_matrixA,grey_matrixB,fusion_matrix);     %边缘关联
fprintf('Qabf：%f\n',Result(1,8));
q01 = Q0(grey_matrixA,fusion_matrix,blk_size);
q02 = Q0(grey_matrixB,fusion_matrix,blk_size);
Result(1,9)=(q01 + q02)/2;   %通用图像质量指数
fprintf('Q0：%f\n', Result(1,9));
Result(1,10)=Qw(grey_matrixA,grey_matrixB,fusion_matrix,blk_size);     %加权融合质量指数
fprintf('Qw：%f\n', Result(1,10));
Result(1,11)=Qe(grey_matrixA,grey_matrixB,fusion_matrix,blk_size,Result(1,10)); %%%边缘相关融合质量指数
fprintf('Qe：%f\n',Result(1,11));
% Result(1,12)=(psnr(grey_matrixA,fusion_matrix)+psnr(grey_matrixB,fusion_matrix))/2;
Result(1,12)=(psnr(grey_matrixA,fusion_matrix)+psnr(grey_matrixB,fusion_matrix))/2;
fprintf('psnr:%f\n',Result(1,12));
Result(1,13)=fmi(grey_matrixA,grey_matrixB,fusion_matrix,'none',3);
fprintf('FMI:%f\n',Result(1,13));
[ssimval_A, ssimmap_A] = ssim(fusion_matrix,grey_matrixA);
[ssimval_B, ssimmap_B] = ssim(fusion_matrix,grey_matrixB);
Result(1,14)=(ssimval_A+ssimval_B)/2;
fprintf('SSIM:%f\n',Result(1,14));
Result(1,15)=spatial_freqency(fusion_matrix);
fprintf('SF:%f\n',Result(1,15));
Result(1,16)=(RMSE(fusion_matrix,grey_matrixA)+RMSE(fusion_matrix,grey_matrixB))/2;
fprintf('RMSE:%f\n',Result(1,16));
Result(1,17)=(correlation_coeffient(grey_matrixA,fusion_matrix)+correlation_coeffient(grey_matrixB,fusion_matrix))/2;
fprintf('CC:%f\n',Result(1,17));

