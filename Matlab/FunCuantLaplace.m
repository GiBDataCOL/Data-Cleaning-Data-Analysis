function [FO]=FunCuantLaplace(y,X,p,betha,tau)
    T=length(y);
    FO=0;
    
    for i=1:T
        
        u=(y(i)-(X(i,:)*betha));
        
        if (u>=0)
            FO=FO+(p*abs(u));
        elseif (u<0)
            FO=FO+((1-p)*abs(u));
        end
        
    end
    
    FO=T*log(tau)-tau*FO;
    FO=FO*(-1);
    
end