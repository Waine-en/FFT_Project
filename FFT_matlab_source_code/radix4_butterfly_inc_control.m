function [Y0, Y1, Y2, Y3] = radix4_butterfly_inc_control(x0, x1, x2, x3, ...
    control);
    if (control == 0) 
         Y0 = x3;
         Y1 = x1;
         Y2 = x2;
         Y3 = x0;
    elseif control == 1
         Y0 = x0;
         Y1 = x3;
         Y2 = x2;
         Y3 = x1;    
    elseif control == 2
         Y0 = x0;
         Y1 = x1;
         Y2 = x3;
         Y3 = x2;    
    elseif control == 3
        Y0 =  x0        +  x1        +  x2        +  x3;
        Y1 =  x0        - 1j*x1      -  x2        + 1j*x3;
        Y2 =  x0        -    x1      +  x2        -    x3;
        Y3 =  x0        + 1j*x1      -  x2        - 1j*x3;
    end
end