function y = cmul_trunc_fixed_v2(a, b, WL, FL, mode)
%COMPLEX_MULT_V1 Complex multiplication with truncation at every stage
%
% Inputs:
%   a, b : complex (or real) scalar / vector / matrix
%   WL   : word length (including sign bit)
%   FL   : fractional length
%   mode : truncation mode, default = "trunc"

%
% Supported cases:
%   real    .* real
%   real    .* complex
%   complex .* real
%   complex .* complex

% Output:
%   y    : truncated complex multiplication result
%
% Rule:
%   p1 = trunc_fixed_v2(real(a).*real(b), WL, FL, mode);
%   p2 = trunc_fixed_v2(imag(a).*imag(b), WL, FL, mode);
%   p3 = trunc_fixed_v2(real(a).*imag(b), WL, FL, mode);
%   p4 = trunc_fixed_v2(imag(a).*real(b), WL, FL, mode);
%
%   yr = trunc_fixed_v2(p1 - p2, WL, FL, mode);
%   yi = trunc_fixed_v2(p3 + p4, WL, FL, mode);
%
%   y  = complex(yr, yi);

    if nargin < 5
        mode = "trunc";
    end

    ar = real(a);
    ai = imag(a);
    br = real(b);
    bi = imag(b);

    % Stage 1: 4 multiplications, each followed by truncation
    p1 = trunc_fixed_v2(ar .* br, WL-1, FL, mode);
    p2 = trunc_fixed_v2(ai .* bi, WL-1, FL, mode);
    p3 = trunc_fixed_v2(ar .* bi, WL-1, FL, mode);
    p4 = trunc_fixed_v2(ai .* br, WL-1, FL, mode);



    % Stage 2: 2 add/sub operations, each followed by truncation
    yr = trunc_fixed_v2(p1 - p2, WL, FL, mode);
    yi = trunc_fixed_v2(p3 + p4, WL, FL, mode);

    y = complex(yr, yi);




    
end