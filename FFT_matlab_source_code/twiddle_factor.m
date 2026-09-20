function W = twiddle_factor(N, k)
%TWIDDLE_FACTOR  產生 FFT 用的 twiddle factor W_N^k
%
%   W = TWIDDLE_FACTOR(N, k)
%
%   定義：
%       W_N = exp(-j*2*pi/N)
%       W   = W_N.^k = exp(-j*2*pi*k/N)
%
%   輸入：
%       N : 正整數，下標（例如 N = 8）
%       k : 上標，可以是純量或向量（例如 0:3）
%
%   輸出：
%       W : 與 k 同尺寸的複數陣列，每個元素都是對應的 W_N^k

    % 先把 k 折回 0 ~ N-1（可選，但通常 FFT 會這樣做）
    k = mod(k, N);

    % 實際計算 twiddle factor
    W = exp(-1j * 2*pi .* k ./ N);
end