% readTNOset
%
for i=1:41
    name1 = num2str(i,'fusionsource/TNO/Test_vi/%d.bmp');

    name2 =num2str(i,'fusionsource/TNO/Test_ir/%d.bmp');

    fusename = num2str(i,'fusionresult/TNO/%d.png');  %
%     fusename = num2str(i,'fusionresult/TNO_CNNOP (800)/%d.png');  
    
    namelist(i).vis = name1;
    namelist(i).nir = name2;
    namelist(i).fusion =fusename;
    
end

