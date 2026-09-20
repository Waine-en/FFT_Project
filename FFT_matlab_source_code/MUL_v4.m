function MUL_out = MUL_v4(MUL_in, twiddle_factor, control,...
    WLx, FLx, WLw, FLw, WLout, FLout, mode, overflow, mode_t)
    if control == 0
       % MUL_out = MUL_in;
       % MUL_out = trunc_fixed_v2(MUL_in, WLout, FLout, mode_t);

        twiddle_factor_0 = trunc_fixed_v2(complex(1, 0), WLw, FLw, mode_t);
        MUL_out = cmul_trunc_fixed_v2(MUL_in, twiddle_factor_0, WLout, FLout, mode_t);
    elseif control == 1
        MUL_out = cmul_trunc_fixed_v2(MUL_in, twiddle_factor, WLout, FLout, mode_t);
    elseif control == 2
        twiddle_factor_2 = cmul_trunc_fixed_v2(twiddle_factor, twiddle_factor, WLw, FLw, mode_t);
        MUL_out = cmul_trunc_fixed_v2(MUL_in, twiddle_factor_2, WLout, FLout, mode_t);
    elseif control == 3
        twiddle_factor_2 = cmul_trunc_fixed_v2(twiddle_factor, twiddle_factor, WLw, FLw, mode_t);
        twiddle_factor_3 = cmul_trunc_fixed_v2(twiddle_factor_2, twiddle_factor, WLw, FLw, mode_t);
        MUL_out = cmul_trunc_fixed_v2(MUL_in, twiddle_factor_3, WLout, FLout, mode_t);
    end
end
