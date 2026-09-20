clc;
clear;
close all;
seed = 2025;
sample_number = 256;
symbol_number = 1000;
Cycle_number = symbol_number * sample_number + (sample_number) -1;

direction = 'right';
FFT_IFFT_mode = "FFT";
debug_mode = "false";

idx_rev2_rev = idx_rev_singleport_radix4(sample_number).';



% 0. open file:
base_dir = "./result";
% --- File name ---
fname_in_r = fullfile(base_dir, "in_real.mem");
fname_in_i = fullfile(base_dir, "in_imag.mem");
fname_out_r = fullfile(base_dir, "out_real.mem");
fname_out_i = fullfile(base_dir, "out_imag.mem");
% --- Input real ---
fid_in_r = fopen(fname_in_r, 'w');
if fid_in_r < 0
    error('Cannot open file for writing: %s', fname_in_r);
end
% --- Input imag ---
fid_in_i = fopen(fname_in_i, 'w');
if fid_in_i < 0
    error('Cannot open file for writing: %s', fname_in_i);
end
% --- Output real ---
fid_out_r = fopen(fname_out_r, 'w');
if fid_out_r < 0
    error('Cannot open file for writing: %s', fname_out_r);
end
% --- Output imag ---
fid_out_i = fopen(fname_out_i, 'w');
if fid_out_i < 0
    error('Cannot open file for writing: %s', fname_out_i);
end
%==================================================================


% 5. WL設定:
mode = "trunc";
mode_tw = "round_to_zero";
mode_f = "floor";
mode_s = "saturate";


%WL_x = 16;
%FL_x = 13;
%WL_Y_stage1 = (WL_x+2);
%FL_Y_stage1 = FL_x;
%WL_Y_stage2 = (WL_Y_stage1+1);
%FL_Y_stage2 = FL_x;
%WL_Y_stage3 = (WL_Y_stage2+1);
%FL_Y_stage3 = FL_x;
%WL_Y_stage4 = (WL_Y_stage3+1);
%FL_Y_stage4 = FL_x;
%WL_tw = 10;
%FL_tw = 8;

%WL_x_list = 13:1:13;
%WL_Y_stage1_list = 15:1:15;
%WL_Y_stage2_list = 15:1:15;
%WL_Y_stage3_list = 14:1:14;
%WL_Y_stage4_list = 14:1:14;
%WL_tw_list = 10:1:10;
%
%% Fixed WL
%WL_x_fixed = 13;
%WL_Y_stage1_fixed = 15;
%WL_Y_stage2_fixed = 15;
%WL_Y_stage3_fixed = 14;
%WL_Y_stage4_fixed = 14;
%WL_tw_fixed = 10;

WL_x_list = 17:1:17;
WL_Y_stage1_list = 19:1:19;
WL_Y_stage2_list = 19:1:19;
WL_Y_stage3_list = 18:1:18;
WL_Y_stage4_list = 17:1:17;
WL_tw_list = 11:1:11;

% Fixed WL
WL_x_fixed = 17;
WL_Y_stage1_fixed = 19;
WL_Y_stage2_fixed = 19;
WL_Y_stage3_fixed = 18;
WL_Y_stage4_fixed = 17;
WL_tw_fixed = 11;

SQNR_grid = zeros( ...
    numel(WL_x_list), ...
    numel(WL_Y_stage1_list), ...
    numel(WL_Y_stage2_list), ...
    numel(WL_Y_stage3_list), ...
    numel(WL_Y_stage4_list), ...
    numel(WL_tw_list) ...
    );
BER_grid = zeros( ...
    numel(WL_x_list), ...
    numel(WL_Y_stage1_list), ...
    numel(WL_Y_stage2_list), ...
    numel(WL_Y_stage3_list), ...
    numel(WL_Y_stage4_list), ...
    numel(WL_tw_list) ...
    );

%% ========================================================================
% Plot Mode
%
% true  : plot SQNR + BER for this WL
% false : do not plot
% ========================================================================

plot_WL_x        = false;
plot_WL_Y_stage1 = false;
plot_WL_Y_stage2 = false;
plot_WL_Y_stage3 = false;
plot_WL_Y_stage4 = false;
plot_WL_tw       = false;

% ------------------------------------------------------------
% 4. Sweep
% ------------------------------------------------------------
fprintf('=============================================\n');
fprintf('Start Fixed-Point Sweep\n');
%fprintf('Total cases = %d\n', total_case);
fprintf('=============================================\n');
%% ========================================================================
% Sweep
% ========================================================================
for WLx = 1:length(WL_x_list)
    for WLY1 = 1:length(WL_Y_stage1_list)
        for WLY2 = 1:length(WL_Y_stage2_list)
            for WLY3 = 1:length(WL_Y_stage3_list)
                for WLY4 = 1:length(WL_Y_stage4_list)  
                    for WLtw = 1:length(WL_tw_list)
                        % =========================================================
                        % Fixed-point setting
                        % =========================================================
                        WL_x = WL_x_list(WLx);
                        WL_Y_stage1 = WL_Y_stage1_list(WLY1);
                        WL_Y_stage2 = WL_Y_stage2_list(WLY2);
                        WL_Y_stage3 = WL_Y_stage3_list(WLY3);
                        WL_Y_stage4 = WL_Y_stage4_list(WLY4);
                        WL_tw = WL_tw_list(WLtw);

                 %      FL_x = WL_x - 3;
                 %      FL_Y_stage1 = WL_Y_stage1 - 5;
                 %      FL_Y_stage2 = WL_Y_stage2 - 6;
                 %      FL_Y_stage3 = WL_Y_stage3 - 6;
                 %      FL_Y_stage4 = WL_Y_stage4 - 6;
                 %      FL_tw = WL_tw - 2;
                        FL_x = WL_x - 3;
                        FL_Y_stage1 = WL_Y_stage1 - 5;
                        FL_Y_stage2 = WL_Y_stage2 - 6;
                        FL_Y_stage3 = WL_Y_stage3 - 6;
                        FL_Y_stage4 = WL_Y_stage4 - 6;
                        FL_tw = WL_tw - 3;
                        % =========================================================
                        % Display current sweep setting
                        % =========================================================
                        fprintf(['WL_x:%d, WL_Y_stage1:%d, ', ...
                                 'WL_Y_stage2:%d, WL_Y_stage3:%d, ', ...
                                 'WL_Y_stage4:%d, WL_tw:%d\n'], ...
                                 WL_x, WL_Y_stage1, ...
                                 WL_Y_stage2, WL_Y_stage3, ...
                                 WL_Y_stage4, WL_tw);


                        % =========================================================
                        % FFT Algorithm
                        % =========================================================                      
                        [SQNR, BER] = FFT_top(sample_number, symbol_number, Cycle_number, ...
                            base_dir, debug_mode, seed, direction, FFT_IFFT_mode, idx_rev2_rev, ...
                            fid_in_r, fid_in_i, fid_out_r, fid_out_i, ...
                            mode, mode_tw, mode_f, mode_s, ...
                            WL_x, FL_x, WL_Y_stage1, FL_Y_stage1, WL_Y_stage2, FL_Y_stage2, ...
                            WL_Y_stage3, FL_Y_stage3, WL_Y_stage4, FL_Y_stage4, WL_tw, FL_tw);

                        SQNR_grid( ...
                            WLx, ...
                            WLY1, ...
                            WLY2, ...
                            WLY3, ...
                            WLY4, ...
                            WLtw) = SQNR;

                        BER_grid( ...
                            WLx, ...
                            WLY1, ...
                            WLY2, ...
                            WLY3, ...
                            WLY4, ...
                            WLtw) = BER;
                    end
                end
            end
        end
    end
end

%% ========================================================================
% Plot
% ========================================================================



% 找到對應 index
Wx_fixed  = find(WL_x_list       == WL_x_fixed);
WY1_fixed = find(WL_Y_stage1_list == WL_Y_stage1_fixed);
WY2_fixed = find(WL_Y_stage2_list == WL_Y_stage2_fixed);
WY3_fixed = find(WL_Y_stage3_list == WL_Y_stage3_fixed);
WY4_fixed = find(WL_Y_stage4_list == WL_Y_stage4_fixed);
Wtw_fixed = find(WL_tw_list      == WL_tw_fixed);

LineWidth = 3.0;
%% ========================================================================
% Output folder
% ========================================================================

output_dir = fullfile(pwd, 'output');

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end



%% ========================================================================
% WL_x
% ========================================================================

if plot_WL_x

    % ====================================================================
    % Figure 60 : SQNR vs WL_x
    % ====================================================================

    figure(60);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    SQNR_curve = squeeze( ...
        SQNR_grid(:, ...
        WY1_fixed, ...
        WY2_fixed, ...
        WY3_fixed, ...
        WY4_fixed, ...
        Wtw_fixed));


    SQNR_curve(SQNR_curve <= 0) = 1e-20;


    semilogy(WL_x_list, SQNR_curve, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{x}');

    ylabel('SQNR');

    title(sprintf('SQNR vs WL_{x}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_x.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_x.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_x.pdf'), ...
        'ContentType', 'vector');



    % ====================================================================
    % Figure 70 : BER vs WL_x
    % ====================================================================

    figure(70);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    BER_curve = squeeze( ...
        BER_grid(:, ...
        WY1_fixed, ...
        WY2_fixed, ...
        WY3_fixed, ...
        WY4_fixed, ...
        Wtw_fixed));


    % BER = 0 cannot be shown on logarithmic axis.
    % This only modifies the plotted copy.
    % BER_grid itself is not modified.
    BER_curve_plot = BER_curve;

    BER_curve_plot(BER_curve_plot <= 0) = 1e-20;


    semilogy(WL_x_list, BER_curve_plot, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{x}');

    ylabel('BER');

    title(sprintf('BER vs WL_{x}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_x.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_x.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_x.pdf'), ...
        'ContentType', 'vector');

end


%% ========================================================================
% WL_Y_stage1
% ========================================================================

if plot_WL_Y_stage1

    % ====================================================================
    % Figure 61 : SQNR vs WL_Y_stage1
    % ====================================================================

    figure(61);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    SQNR_curve = squeeze( ...
        SQNR_grid( ...
        Wx_fixed, ...
        :, ...
        WY2_fixed, ...
        WY3_fixed, ...
        WY4_fixed, ...
        Wtw_fixed));


    SQNR_curve(SQNR_curve <= 0) = 1e-20;


    semilogy(WL_Y_stage1_list, SQNR_curve, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage1}');

    ylabel('SQNR');

    title(sprintf('SQNR vs WL_{stage1}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y1.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y1.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y1.pdf'), ...
        'ContentType', 'vector');



    % ====================================================================
    % Figure 71 : BER vs WL_Y_stage1
    % ====================================================================

    figure(71);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    BER_curve = squeeze( ...
        BER_grid( ...
        Wx_fixed, ...
        :, ...
        WY2_fixed, ...
        WY3_fixed, ...
        WY4_fixed, ...
        Wtw_fixed));


    BER_curve_plot = BER_curve;

    BER_curve_plot(BER_curve_plot <= 0) = 1e-20;


    semilogy(WL_Y_stage1_list, BER_curve_plot, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage1}');

    ylabel('BER');

    title(sprintf('BER vs WL_{stage1}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y1.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y1.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y1.pdf'), ...
        'ContentType', 'vector');

end


%% ========================================================================
% WL_Y_stage2
% ========================================================================

if plot_WL_Y_stage2

    % ====================================================================
    % Figure 62 : SQNR vs WL_Y_stage2
    % ====================================================================

    figure(62);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    SQNR_curve = squeeze( ...
        SQNR_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        :, ...
        WY3_fixed, ...
        WY4_fixed, ...
        Wtw_fixed));


    SQNR_curve(SQNR_curve <= 0) = 1e-20;


    semilogy(WL_Y_stage2_list, SQNR_curve, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage2}');

    ylabel('SQNR');

    title(sprintf('SQNR vs WL_{stage2}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y2.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y2.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y2.pdf'), ...
        'ContentType', 'vector');



    % ====================================================================
    % Figure 72 : BER vs WL_Y_stage2
    % ====================================================================

    figure(72);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    BER_curve = squeeze( ...
        BER_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        :, ...
        WY3_fixed, ...
        WY4_fixed, ...
        Wtw_fixed));


    BER_curve_plot = BER_curve;

    BER_curve_plot(BER_curve_plot <= 0) = 1e-20;


    semilogy(WL_Y_stage2_list, BER_curve_plot, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage2}');

    ylabel('BER');

    title(sprintf('BER vs WL_{stage2}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y2.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y2.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y2.pdf'), ...
        'ContentType', 'vector');

end


%% ========================================================================
% WL_Y_stage3
% ========================================================================

if plot_WL_Y_stage3

    % ====================================================================
    % Figure 63 : SQNR vs WL_Y_stage3
    % ====================================================================

    figure(63);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    SQNR_curve = squeeze( ...
        SQNR_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        WY2_fixed, ...
        :, ...
        WY4_fixed, ...
        Wtw_fixed));


    SQNR_curve(SQNR_curve <= 0) = 1e-20;


    semilogy(WL_Y_stage3_list, SQNR_curve, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage3}');

    ylabel('SQNR');

    title(sprintf('SQNR vs WL_{stage3}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y3.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y3.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y3.pdf'), ...
        'ContentType', 'vector');



    % ====================================================================
    % Figure 73 : BER vs WL_Y_stage3
    % ====================================================================

    figure(73);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    BER_curve = squeeze( ...
        BER_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        WY2_fixed, ...
        :, ...
        WY4_fixed, ...
        Wtw_fixed));


    BER_curve_plot = BER_curve;

    BER_curve_plot(BER_curve_plot <= 0) = 1e-20;


    semilogy(WL_Y_stage3_list, BER_curve_plot, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage3}');

    ylabel('BER');

    title(sprintf('BER vs WL_{stage3}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y3.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y3.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y3.pdf'), ...
        'ContentType', 'vector');

end


%% ========================================================================
% WL_Y_stage4
% ========================================================================

if plot_WL_Y_stage4

    % ====================================================================
    % Figure 64 : SQNR vs WL_Y_stage4
    % ====================================================================

    figure(64);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    SQNR_curve = squeeze( ...
        SQNR_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        WY2_fixed, ...
        WY3_fixed, ...
        :, ...
        Wtw_fixed));


    SQNR_curve(SQNR_curve <= 0) = 1e-20;


    semilogy(WL_Y_stage4_list, SQNR_curve, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage4}');

    ylabel('SQNR');

    title(sprintf('SQNR vs WL_{stage4}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y4.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y4.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_Y4.pdf'), ...
        'ContentType', 'vector');



    % ====================================================================
    % Figure 74 : BER vs WL_Y_stage4
    % ====================================================================

    figure(74);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    BER_curve = squeeze( ...
        BER_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        WY2_fixed, ...
        WY3_fixed, ...
        :, ...
        Wtw_fixed));


    BER_curve_plot = BER_curve;

    BER_curve_plot(BER_curve_plot <= 0) = 1e-20;


    semilogy(WL_Y_stage4_list, BER_curve_plot, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{stage4}');

    ylabel('BER');

    title(sprintf('BER vs WL_{stage4}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y4.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y4.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_Y4.pdf'), ...
        'ContentType', 'vector');

end


%% ========================================================================
% WL_tw
% ========================================================================

if plot_WL_tw

    % ====================================================================
    % Figure 65 : SQNR vs WL_tw
    % ====================================================================

    figure(65);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    SQNR_curve = squeeze( ...
        SQNR_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        WY2_fixed, ...
        WY3_fixed, ...
        WY4_fixed, ...
        :));


    SQNR_curve(SQNR_curve <= 0) = 1e-20;


    semilogy(WL_tw_list, SQNR_curve, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{tw}');

    ylabel('SQNR');

    title(sprintf('SQNR vs WL_{tw}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_tw.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_tw.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'SQNR_vs_WL_tw.pdf'), ...
        'ContentType', 'vector');



    % ====================================================================
    % Figure 75 : BER vs WL_tw
    % ====================================================================

    figure(75);
    hold on;
    grid on;

    ax = gca;

    colororder(ax, turbo(1));

    set(ax, 'DefaultLineMarkerSize', 7);


    BER_curve = squeeze( ...
        BER_grid( ...
        Wx_fixed, ...
        WY1_fixed, ...
        WY2_fixed, ...
        WY3_fixed, ...
        WY4_fixed, ...
        :));


    BER_curve_plot = BER_curve;

    BER_curve_plot(BER_curve_plot <= 0) = 1e-20;


    semilogy(WL_tw_list, BER_curve_plot, '-o', ...
        'LineWidth', LineWidth);


    xlabel('WL_{tw}');

    ylabel('BER');

    title(sprintf('BER vs WL_{tw}'));

    set(gca, 'YScale', 'log');

    grid on;

    hold off;


    savefig(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_tw.fig'));


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_tw.png'), ...
        'Resolution', 300);


    exportgraphics(gcf, ...
        fullfile(output_dir, 'BER_vs_WL_tw.pdf'), ...
        'ContentType', 'vector');

end






fclose(fid_in_r);
fclose(fid_in_i);
fclose(fid_out_r);
fclose(fid_out_i);