function Y = gen_from_S(sample_number, seed)
%GEN8_FROM_S  Randomly generate 8 samples from S={1+j,1-j,-1+j,-1-j}
% Usage:
%   Y = gen8_from_S();        % random each run
%   Y = gen8_from_S(1234);    % reproducible with seed
%
% Output:
%   Y : 8x1 complex vector, representing Y0~Y7

    S = [1+1j, 1-1j, -1+1j, -1-1j];

    if nargin >= 1 && ~isempty(seed)
        rng(seed);
    end

    idx = randi(numel(S), sample_number, 1);  % uniform random indices in {1..4}
    Y   = S(idx).';
end