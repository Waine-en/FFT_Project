function idx_rev2_rev = idx_rev_singleport_radix4(N)
%IDX_REV_SINGLEPORT_RADIX4
%  單一輸出 port（只收 Y3），且每個 stage 的輸出順序皆為 control: 3->0->1->2
%  N 必須為 4^s (16/64/256/...)
%
%  回傳 idx_rev2_rev 為 1-based row vector

    s = log(N)/log(4);
    assert(abs(s-round(s)) < 1e-12, 'N must be 4^s, e.g., 16/64/256.');

    r_seq = [4 1 2 3];      % 對應 3,0,1,2（MATLAB 1-based）
    idx_rev2_rev = rec(1:N, r_seq);
end

function out = rec(in, r_seq)
    L = numel(in);
    if L == 1
        out = in;
        return;
    end

    % 關鍵：不要轉置！
    % 這行會得到交錯分塊：
    % row1=[1 5 9 13], row2=[2 6 10 14], row3=[3 7 11 15], row4=[4 8 12 16]
    M = reshape(in, 4, []);         % 4 x (L/4)

    % 先做 block 順序 3->0->1->2
    M = M(r_seq, :);

    % block 內再遞迴同樣規則
    for i = 1:4
        M(i,:) = rec(M(i,:), r_seq);
    end

    % 串接輸出要用「row-wise」串起來
    out = reshape(M.', 1, []);
end