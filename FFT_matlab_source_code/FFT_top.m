function [SQNR, BER] = FFT_top(sample_number, symbol_number, Cycle_number, ...
    base_dir, debug_mode, seed, direction, FFT_IFFT_mode, idx_rev2_rev, ...
    fid_in_r, fid_in_i, fid_out_r, fid_out_i, ...
    mode, mode_tw, mode_f, mode_s, ...
    WL_x, FL_x, WL_Y_stage1, FL_Y_stage1, WL_Y_stage2, FL_Y_stage2, ...
    WL_Y_stage3, FL_Y_stage3, WL_Y_stage4, FL_Y_stage4, WL_tw, FL_tw)

if debug_mode == "true"
    fname_out_debug_r = "out_debug_real.mem";
    fname_out_debug_i = "out_debug_imag.mem";
    fname_out_mul_r = "out_mul_real.mem";
    fname_out_mul_i = "out_mul_imag.mem";    
    % --- Output debug real ---
    fid_out_debug_r = fopen(fname_out_debug_r, 'w');
    if fid_out_debug_r < 0
        error('Cannot open file for writing: %s', fname_out_debug_r);
    end
    % --- Output debug imag ---
    fid_out_debug_i = fopen(fname_out_debug_i, 'w');
    if fid_out_debug_i < 0
        error('Cannot open file for writing: %s', fname_out_debug_i);
    end

    % --- Output mul real ---
    fid_out_mul_r = fopen(fname_out_mul_r, 'w');
    if fid_out_mul_r < 0
        error('Cannot open file for writing: %s', fname_out_mul_r);
    end
    % --- Output mul imag ---
    fid_out_mul_i = fopen(fname_out_mul_i, 'w');
    if fid_out_mul_i < 0
        error('Cannot open file for writing: %s', fname_out_mul_i);
    end    
end
Complex_zero = complex(0, 0);
%% ========================================================================
% Performance metric accumulators
% ========================================================================

% SQNR
SQNR_signal_power = 0;
SQNR_error_power  = 0;

% BER
bit_error_count = 0;
total_bit_count = 0;
%% 開始電路相關敘述:
% 1. 控制訊號
R_stage1 = 0;
R_stage2 = 0;
R_stage3 = 0;
R_stage4 = 0;
R_stage_recode = zeros(Cycle_number, 4);

% 2. delay buffer/element:
DFF_64_up = zeros(1, 64);
DFF_64_middle = zeros(1, 64);
DFF_64_down = zeros(1, 64);
DFF_16_up = zeros(1, 16);
DFF_16_middle = zeros(1, 16);
DFF_16_down = zeros(1, 16);
DFF_4_up = zeros(1, 4);
DFF_4_middle = zeros(1, 4);
DFF_4_down = zeros(1, 4);
DFF_1_up = zeros(1, 1);
DFF_1_middle = zeros(1, 1);
DFF_1_down = zeros(1, 1);

% 3. twiddle factor:
k256_1 = 0:63;
ROM64 = twiddle_factor(256, k256_1).';
ADDR64 = 1;

k64_1 = 0:15;
ROM16 = twiddle_factor(64, k64_1).';
ADDR16 = 1;

k16_1 = 0:3;
ROM4 = twiddle_factor(16, k16_1).';
ADDR4 = 1;

% 4. output memory:
output_memory = zeros(sample_number, 1);
output_memory_non_reorder = zeros(sample_number, 1);
output_addr = 1;
symbol_addr = 1;
result_record = zeros(sample_number, symbol_number);
DFF_1_out_up = 0;
DFF_1_out_middle = 0;
DFF_1_out_down = 0;
DFF_4_out_up = 0;
DFF_4_out_middle = 0;
DFF_4_out_down = 0;
DFF_16_out_up = 0;
DFF_16_out_middle = 0;
DFF_16_out_down = 0;
DFF_64_out_up = 0;
DFF_64_out_middle = 0;
DFF_64_out_down = 0;
Y = 0;

% 5. twiddle factor: 
ROM64 = trunc_fixed_v2(ROM64, WL_tw, FL_tw, mode_tw);
ROM16 = trunc_fixed_v2(ROM16, WL_tw, FL_tw, mode_tw);
ROM4  = trunc_fixed_v2(ROM4,  WL_tw, FL_tw, mode_tw);
[qr64, qi64, qr_u64, qi_u64] = write_twiddle_mem(ROM64, WL_tw, FL_tw, base_dir, 'tw64_r.mem', 'tw64_i.mem');
[qr16, qi16, qr_u16, qi_u16] = write_twiddle_mem(ROM16, WL_tw, FL_tw, base_dir, 'tw16_r.mem', 'tw16_i.mem');
[qr4, qi4, qr_u4, qi_u4] = write_twiddle_mem(ROM4, WL_tw, FL_tw, base_dir, 'tw4_r.mem', 'tw4_i.mem');

%[hex64_digits, hex64_r, hex64_i, qr64_u, qi64_u] = twiddle_to_hex_onlyWL(ROM64, WL_tw);
%[hex16_digits, hex16_r, hex16_i, qr16_u, qi16_u] = twiddle_to_hex_onlyWL(ROM16, WL_tw);
%[hex4_digits,  hex4_r,  hex4_i,  qr4_u,  qi4_u]  = twiddle_to_hex_onlyWL(ROM4, WL_tw);
%for n = 1:numel(hex64_r)
%    fprintf(fid_tw64_r, '%s\n', hex64_r{n});
%end

SYMBOL = 1;
for Cycle = 1:Cycle_number
    if mod(Cycle-1, sample_number) == 0

  %     fprintf(['SYMBOL:%d\n'], SYMBOL);
  %     SYMBOL = SYMBOL +1;

        Y_buf = Y;
        Y = gen_from_S(sample_number, seed);
        x = ifft(Y);
        x = trunc_fixed_v2(x, WL_x, FL_x, mode_tw);
        seed = seed + 1;
        if Cycle <= (symbol_number*sample_number)
           [hex_digits_x, qr, qi, qr_u, qi_u] = write_twiddle_mem_v2(x, WL_x, FL_x);
           for n = 1:numel(qr_u)
               fprintf(fid_in_r, ['%0', num2str(hex_digits_x), 'X\n'], qr_u(n));
           end
           for n = 1:numel(qr_u)
               fprintf(fid_in_i, ['%0', num2str(hex_digits_x), 'X\n'], qi_u(n));
           end            
         %   [qr, qi, qr_u, qi_u] = write_twiddle_mem(x, WL_x, FL_x, 'in_real.mem', 'in_imag.mem');
        end
    end

    % step1: 產生正確control signal:
    if mod(Cycle-1, 256)==0
        R_stage1 = 0;        
    elseif mod(Cycle-1+192, 256)==0
        R_stage1 = 1; 
    elseif mod(Cycle-1+128, 256)==0
        R_stage1 = 2; 
    elseif mod(Cycle-1+64, 256)==0        
        R_stage1 = 3; 
    end    

    if mod(Cycle-1, 64)==0
        R_stage2 = 0;        
    elseif mod(Cycle-1+48, 64)==0
        R_stage2 = 1; 
    elseif mod(Cycle-1+32, 64)==0
        R_stage2 = 2; 
    elseif mod(Cycle-1+16, 64)==0        
        R_stage2 = 3; 
    end

    if mod(Cycle-1, 16)==0
        R_stage3 = 0;        
    elseif mod(Cycle-1+12, 16)==0
        R_stage3 = 1; 
    elseif mod(Cycle-1+8, 16)==0
        R_stage3 = 2; 
    elseif mod(Cycle-1+4, 16)==0        
        R_stage3 = 3; 
    end

    if mod(Cycle-1, 4)==0
        R_stage4 = 0;        
    elseif mod(Cycle-1+3, 4)==0
        R_stage4 = 1; 
    elseif mod(Cycle-1+2, 4)==0
        R_stage4 = 2; 
    elseif mod(Cycle-1+1, 4)==0        
        R_stage4 = 3; 
    end
%    R_stage_recode(Cycle, 1) = R_stage1;
%    R_stage_recode(Cycle, 2) = R_stage2;
%    R_stage_recode(Cycle, 3) = R_stage3;
%    R_stage_recode(Cycle, 4) = R_stage4;
    % step2: 開始電路模擬:
    % =================================================>
    % stage1:
        % radix4_butterfly
    if Cycle <= (sample_number*symbol_number)
        [Y0_stage1, Y1_stage1, Y2_stage1, Y3_stage1] = radix4_butterfly_inc_control(DFF_64_down(end), DFF_64_middle(end), DFF_64_up(end), ...
            x(mod(Cycle-1, sample_number)+1), R_stage1);
    else
        [Y0_stage1, Y1_stage1, Y2_stage1, Y3_stage1] = radix4_butterfly_inc_control(DFF_64_down(end), DFF_64_middle(end), DFF_64_up(end), ...
            Complex_zero, R_stage1);
    end
    Y0_stage1 = trunc_fixed_v2(Y0_stage1, WL_Y_stage1, FL_Y_stage1, mode);
    Y1_stage1 = trunc_fixed_v2(Y1_stage1, WL_Y_stage1, FL_Y_stage1, mode);
    Y2_stage1 = trunc_fixed_v2(Y2_stage1, WL_Y_stage1, FL_Y_stage1, mode);
    Y3_stage1 = trunc_fixed_v2(Y3_stage1, WL_Y_stage1, FL_Y_stage1, mode);
   
    %==============>
    if debug_mode == "true"
        [hex_digits_Y3_stage1, qr_Y3_stage1, qi_Y3_stage1, qr_u_Y3_stage1, qi_u_Y3_stage1] = ...
            write_twiddle_mem_v2(Y3_stage1, WL_Y_stage1, FL_Y_stage1);
        for n = 1:numel(qr_u_Y3_stage1)
            fprintf(fid_out_debug_r, ['%0', num2str(hex_digits_Y3_stage1), 'X\n'], qr_u_Y3_stage1(n));
        end
        for n = 1:numel(qi_u_Y3_stage1)
            fprintf(fid_out_debug_i, ['%0', num2str(hex_digits_Y3_stage1), 'X\n'], qi_u_Y3_stage1(n));
        end 
    end
    %==============>
        % delay buffer:
    [DFF_64_up, DFF_64_out_up] = shift_reg(DFF_64_up, Y2_stage1, direction);
    [DFF_64_middle, DFF_64_out_middle] = shift_reg(DFF_64_middle, Y1_stage1, direction);
    [DFF_64_down, DFF_64_out_down] = shift_reg(DFF_64_down, Y0_stage1, direction);

        % Multiplication:
    %MUL_out_stage1 = MUL_v2(Y3_stage1, ROM64(ADDR64), R_stage1);
%    MUL_out_stage1 = MUL_v3(Y3_stage1, ROM64(ADDR64), R_stage1,...
%    WL_Y_stage1, FL_Y_stage1, WL_tw, FL_tw, WL_Y_stage2, FL_Y_stage2, mode_f, mode_s);
    MUL_out_stage1 = MUL_v4(Y3_stage1, ROM64(ADDR64), R_stage1,...
    WL_Y_stage1, FL_Y_stage1, WL_tw, FL_tw, WL_Y_stage2, FL_Y_stage2, mode_f, mode_s, mode);
    %==============>
    if debug_mode == "true"
        [hex_digits_MUL_stage1, qr_MUL_stage1, qi_MUL_stage1, qr_u_MUL_stage1, qi_u_MUL_stage1] = ...
            write_twiddle_mem_v2(MUL_out_stage1, WL_Y_stage1, FL_Y_stage1);
        for n = 1:numel(qr_u_MUL_stage1)
            fprintf(fid_out_mul_r, ['%0', num2str(hex_digits_MUL_stage1), 'X\n'], qr_u_MUL_stage1(n));
        end
        for n = 1:numel(qi_u_MUL_stage1)
            fprintf(fid_out_mul_i, ['%0', num2str(hex_digits_MUL_stage1), 'X\n'], qi_u_MUL_stage1(n));
        end 
    end
    %==============>         
    ADDR64 = ADDR64 + 1;
    if ADDR64 == 65
        ADDR64 = 1;
    end 

    % =================================================>
    % stage2:
    [Y0_stage2, Y1_stage2, Y2_stage2, Y3_stage2] = radix4_butterfly_inc_control(DFF_16_down(end), DFF_16_middle(end), DFF_16_up(end), ...
        MUL_out_stage1, R_stage2);
    Y0_stage2 = trunc_fixed_v2(Y0_stage2, WL_Y_stage2, FL_Y_stage2, mode);
    Y1_stage2 = trunc_fixed_v2(Y1_stage2, WL_Y_stage2, FL_Y_stage2, mode);
    Y2_stage2 = trunc_fixed_v2(Y2_stage2, WL_Y_stage2, FL_Y_stage2, mode);
    Y3_stage2 = trunc_fixed_v2(Y3_stage2, WL_Y_stage2, FL_Y_stage2, mode);

        % delay buffer:
    [DFF_16_up, DFF_16_out_up] = shift_reg(DFF_16_up, Y2_stage2, direction);
    [DFF_16_middle, DFF_16_out_middle] = shift_reg(DFF_16_middle, Y1_stage2, direction);
    [DFF_16_down, DFF_16_out_down] = shift_reg(DFF_16_down, Y0_stage2, direction);

        % Multiplication:
    %MUL_out_stage2 = MUL_v2(Y3_stage2, ROM16(ADDR16), R_stage2);
%    MUL_out_stage2 = MUL_v3(Y3_stage2, ROM16(ADDR16), R_stage2,...
%    WL_Y_stage2, FL_Y_stage2, WL_tw, FL_tw, WL_Y_stage3, FL_Y_stage3, mode_f, mode_s);  
    MUL_out_stage2 = MUL_v4(Y3_stage2, ROM16(ADDR16), R_stage2,...
    WL_Y_stage2, FL_Y_stage2, WL_tw, FL_tw, WL_Y_stage3, FL_Y_stage3, mode_f, mode_s, mode);   
    ADDR16 = ADDR16 + 1;
    if ADDR16 == 17
        ADDR16 = 1;
    end
    % =================================================>
    % stage3:
        % radix4_butterfly
    [Y0_stage3, Y1_stage3, Y2_stage3, Y3_stage3] = radix4_butterfly_inc_control(DFF_4_down(end), DFF_4_middle(end), DFF_4_up(end), ...
        MUL_out_stage2, R_stage3);
    Y0_stage3 = trunc_fixed_v2(Y0_stage3, WL_Y_stage3, FL_Y_stage3, mode);
    Y1_stage3 = trunc_fixed_v2(Y1_stage3, WL_Y_stage3, FL_Y_stage3, mode);
    Y2_stage3 = trunc_fixed_v2(Y2_stage3, WL_Y_stage3, FL_Y_stage3, mode);
    Y3_stage3 = trunc_fixed_v2(Y3_stage3, WL_Y_stage3, FL_Y_stage3, mode);

        % delay buffer:
    [DFF_4_up, DFF_4_out_up] = shift_reg(DFF_4_up, Y2_stage3, direction);
    [DFF_4_middle, DFF_4_out_middle] = shift_reg(DFF_4_middle, Y1_stage3, direction);
    [DFF_4_down, DFF_4_out_down] = shift_reg(DFF_4_down, Y0_stage3, direction);

        % Multiplication:
    %MUL_out_stage3 = MUL_v2(Y3_stage3, ROM4(ADDR4), R_stage3);
%    MUL_out_stage3 = MUL_v3(Y3_stage3, ROM4(ADDR4), R_stage3,...
%    WL_Y_stage3, FL_Y_stage3, WL_tw, FL_tw, WL_Y_stage3, FL_Y_stage3, mode_f, mode_s);   
    MUL_out_stage3 = MUL_v4(Y3_stage3, ROM4(ADDR4), R_stage3,...
    WL_Y_stage3, FL_Y_stage3, WL_tw, FL_tw, WL_Y_stage4, FL_Y_stage4, mode_f, mode_s, mode);       
    ADDR4 = ADDR4 + 1;
    if ADDR4 == 5
        ADDR4 = 1;
    end

    % =================================================>
    % stage4:
    [Y0_stage4, Y1_stage4, Y2_stage4, Y3_stage4] = radix4_butterfly_inc_control(DFF_1_down(end), DFF_1_middle(end), DFF_1_up(end), ...
        MUL_out_stage3, R_stage4);
    Y0_stage4 = trunc_fixed_v2(Y0_stage4, WL_Y_stage4, FL_Y_stage4, mode);
    Y1_stage4 = trunc_fixed_v2(Y1_stage4, WL_Y_stage4, FL_Y_stage4, mode);
    Y2_stage4 = trunc_fixed_v2(Y2_stage4, WL_Y_stage4, FL_Y_stage4, mode);
    Y3_stage4 = trunc_fixed_v2(Y3_stage4, WL_Y_stage4, FL_Y_stage4, mode);
        % delay buffer:
    [DFF_1_up, DFF_1_out_up] = shift_reg(DFF_1_up, Y2_stage4, direction);
    [DFF_1_middle, DFF_1_out_middle] = shift_reg(DFF_1_middle, Y1_stage4, direction);
    [DFF_1_down, DFF_1_out_down] = shift_reg(DFF_1_down, Y0_stage4, direction);
    
    
    
    % =================================================>
    % 收資料
    if Cycle >= sample_number && (mod(Cycle, sample_number) < sample_number)        
       inv_addr = idx_rev2_rev(output_addr);
       output_memory(inv_addr) = Y3_stage4;
       output_memory_non_reorder(output_addr) = Y3_stage4;
       output_addr = output_addr + 1;
      
       if output_addr == sample_number +1
           output_addr = 1;
           % ====================================================================
           % Original symbol decision
           % ====================================================================
           sliced_output = qpsk_slicer(output_memory);
          
           result_record(:, symbol_addr) = ...
               abs(Y_buf - sliced_output) < 1e-9;
          
           compare = [Y_buf output_memory];
          
          
           % ====================================================================
           % SQNR
           % ====================================================================
           SQNR_signal_power = SQNR_signal_power + ...
               sum(abs(Y_buf).^2);
          
           SQNR_error_power = SQNR_error_power + ...
               sum(abs(Y_buf - output_memory).^2);
          
          
           % ====================================================================
           % BER
           % QPSK: real / imag 各對應 1 bit
           % ====================================================================
           ref_real_bit = real(Y_buf) >= 0;
           ref_imag_bit = imag(Y_buf) >= 0;
          
           fixed_real_bit = real(sliced_output) >= 0;
           fixed_imag_bit = imag(sliced_output) >= 0;
          
           bit_error_count = bit_error_count + ...
               sum(ref_real_bit ~= fixed_real_bit) + ...
               sum(ref_imag_bit ~= fixed_imag_bit);
          
           total_bit_count = total_bit_count + ...
               2 * numel(Y_buf);
          
          
           symbol_addr = symbol_addr + 1;
           % ====================================================================
           % Original output file
           % ====================================================================

            [hex_digits_stage4, qr_stage4, qi_stage4, qr_u_stage4, qi_u_stage4] = write_twiddle_mem_v2(output_memory_non_reorder, WL_Y_stage4, FL_Y_stage4);
            for n = 1:numel(qr_u_stage4)
                fprintf(fid_out_r, ['%0', num2str(hex_digits_stage4), 'X\n'], qr_u_stage4(n));
            end
            for n = 1:numel(qr_u_stage4)
                fprintf(fid_out_i, ['%0', num2str(hex_digits_stage4), 'X\n'], qi_u_stage4(n));
            end
           %output_memory = zeros(sample_number, 1);
       end
    end

end


if debug_mode == "true"
    fclose(fid_out_debug_r);  
    fclose(fid_out_debug_i);
    fclose(fid_out_mul_r);  
    fclose(fid_out_mul_i);
end
%% ========================================================================
% Final performance metrics
% ========================================================================

% SQNR [dB]
if SQNR_error_power == 0
    SQNR = Inf;
else
    SQNR = 10 * log10( ...
        SQNR_signal_power / SQNR_error_power);
end

% BER
if total_bit_count == 0
    BER = NaN;
else
    BER = bit_error_count / total_bit_count;
end
end