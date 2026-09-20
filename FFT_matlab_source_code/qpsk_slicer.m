function y = qpsk_slicer(x)
%QPSK_SLICER  Hard slicer for QPSK (unit-average-power)
%   x: complex vector/matrix
%   y: same size as x, each element mapped to nearest QPSK constellation point

x = complex(x);  % ensure complex type

yr = sign(real(x));
yi = sign(imag(x));

% tie-break when real/imag is exactly 0: choose +1 (you can change this if desired)
yr(yr == 0) = 1;
yi(yi == 0) = 1;

y = (yr + 1j*yi);
end