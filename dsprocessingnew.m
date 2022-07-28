

%
function [ R, L, epsilon_r, epsilon_l ] = dsprocessingnew( S, c_1, c_2, c_3, lambda1,lambda2, epsilon_stop )

    eps = 1e-6;
    [M,N] = size(S);
    s = log(S+eps);
    r = zeros(M,N);
    l = zeros(M,N);
    b_h = zeros(M,N);
    b_v = zeros(M,N);
    d_h = zeros(M,N);
    d_v = zeros(M,N);
    
    
    R = zeros(M,N);
    
    eigsDtD = getC(s);
     
    error_r = 10;
    error_l = 10;
    while error_r > epsilon_stop || error_l > epsilon_stop
        %
        if  error_r > epsilon_stop
            rold = r;
            [ r, b_h, b_v,d_h,d_v] = solving( s, l, rold, b_h, b_v ,d_h,d_v );
            r = min(r,0);
            if(sum(r(:)) == 0)
                r = r+ eps;
            end
            error_r = norm( (r-rold),2)/ (norm(rold,2)+eps);
        end

       if error_l > epsilon_stop
            Fsr = fft2(s-r);
            L = exp(l);
            lold = l;
            Ld = L.*eigsDtD;
            l = real( ifft2(Fsr./(1+c_2*Ld)) );
            l = max(l, s);
            error_l = norm( (l-lold),2)/ (norm(lold,2)+eps);
       end
        
        display(['error:',  ' error_r=', num2str(error_r), 'error_l=',num2str(error_l)]);
    end
    epsilon_l = error_l;
    epsilon_r = error_r;
    
     R = exp(r);
     L = exp(l);

    function [ r, b_h, b_v,d_h,d_v ] = solving(s, l, r, b_h, b_v ,d_h,d_v )
        R = exp(r);
      
        %1
        rgh = dsgradient_h(r, 1);
        rgv = dsgradient_v(r, 1);
        a_h = R.*rgh + b_h;
        a_v = R.* rgv + b_v;
        a_h = shrink(a_h, 1/(2*lambda1) );
        a_v = shrink(a_v, 1/(2*lambda1) );
        %2
%          sgh = dsgradient_h(s-l, 1)*1.2; % s
%          sgv = dsgradient_v(s-l, 1)*1.2; 
         
         sgh = dsgradient_h(s-l, 1); % s
         sgv = dsgradient_v(s-l, 1); 
        
        c_h = rgh-sgh;
        c_v = rgv-sgv;
        c_h = shrink(c_h, 1/(2*lambda2) );
        c_v = shrink(c_v, 1/(2*lambda2) );
        %3
        
        Fsl = fft2(s-l);
        
        dhab = a_h - b_h;
        dvab = a_v - b_v;
        gdhab = dsgradient_h(dhab,-1);
        gdvab = dsgradient_v(dvab,-1);
       
        Fs = Fsl+c_1*lambda1*R.*fft2(gdhab+gdvab); 
        %
        dhcd = sgh + c_h - d_h;
        dvcd = sgv + c_v - d_v;
        gdhcd = dsgradient_h(dhcd,-1);
        gdvcd = dsgradient_v(dvcd,-1);
        
        Fs = Fs+c_3*lambda2*fft2(gdhcd+gdvcd);
        
        
        r = real(ifft2(Fs./(1+(c_1*lambda1*R.*R + c_3*lambda2).*eigsDtD)));
        
        
        
%         r = min(r,0);    //
%         R = exp(r);
%         fh = [ diff( r, 1, 2 ), r( :, 1, : ) - r( :, end , : ) ]; 
%         fv = [ diff( r, 1, 1 ); r( 1, :, : ) - r( end , :, : ) ];
        
        b_h = b_h + R.*rgh - a_h;
        b_v = b_v + R.*rgv  - a_v;
        
        d_h = d_h + rgh - sgh - c_h;
        d_v = d_v +rgv - sgv - c_v;
        
    end 


    function x = shrink(x,T)
        x = sign(x).*max(abs(x) - T,0); 
    end


    function eigsDtD = getC( F )
        fx = [ 1,  - 1 ];
        fy = [ 1; - 1 ];
        [ N, M, D ] = size( F );
        sizeI2D = [ N, M ];
        otfFx = psf2otf( fx, sizeI2D );
        otfFy = psf2otf( fy, sizeI2D );
        eigsDtD = abs( otfFx ) .^ 2 + abs( otfFy ) .^ 2;
    end

    function gh = dsgradient_h(x, direction)
        if direction == 1
            gh = [ diff( x, 1, 2 ), x( :, 1, : ) - x( :, end , : ) ];
        else
            gh = [x(:,end,:)-x(:,1,:), -diff(x,1,2)];    
        end
    end
    function gv = dsgradient_v(x, direction)
        if direction == 1
            gv = [ diff( x, 1, 1 ); x( 1, :, : ) - x( end , :, : ) ];
        else 
            gv = [x(end,:,:)-x(1,:,:),; -diff(x,1,1)];
        end
    end

end
