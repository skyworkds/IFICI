function FusedImg=NSCT_fusion(matrixA,matrixB,ParaRule)
%%
Low_Coeffs_Rule=ParaRule.Low_Coeffs_Rule; %'ave','PCNN','EOL-PCNN'
High_Coeffs_Rule=ParaRule.High_Coeffs_Rule; %'max','PCNN','EOL-PCNN'
%% Parameters for NSCT
pfilt = 'pyrexc';
dfilt = 'vk';
nlevs = [2,3,3,4];
disp('Decompose the image via nsct ...')
yA=nsctdec(matrixA,nlevs,dfilt,pfilt);
yB=nsctdec(matrixB,nlevs,dfilt,pfilt);
%%
n = length(yA);
%% Initialized the coefficients of fused image
Fused=yA;
%%
%=============================================
% Lowpass subband
disp('Process in Lowpass subband...')
ALow= yA{1};
BLow =yB{1};
%%
switch Low_Coeffs_Rule
    case 'max'
        Fused{1}=max(ALow,BLow);
    case 'ave'
        Fused{1}=(ALow+BLow)/2;
    case 'vis'
        Fused{1}=ALow;
    case 'ir'
        Fused{1}=BLow;
end
%%
%=============================================
% Bandpass subbands
disp('Process in  Bandpass subbands...')
for l=2:n
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nlevs(l-1)==0
        Ahigh=yA{l};
        Bhigh=yB{l};
        switch High_Coeffs_Rule
            case 'max'
                decision_map=(abs(Ahigh)>=abs(Bhigh));
                Fused{l}=decision_map.*Ahigh+(~decision_map).*Bhigh;
        end
    else
        for d=1:length(yA{l})
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Ahigh=yA{l}{d};
            Bhigh=yB{l}{d};
            switch High_Coeffs_Rule
                case 'max'
                    decision_map=(abs(Ahigh)>=abs(Bhigh));
                    Fused{l}{d}=decision_map.*Ahigh+(~decision_map).*Bhigh;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
end
disp('High frequecy field process is ended')
%=============================================
disp('Reconstruct the image via nsct ...')
F=nsctrec(Fused, dfilt, pfilt);
disp('Reconstruct is ended...')
%%
% F(F<0)=0;
% F(F>255)=255;
% F=round(F);
FusedImg = F;