 module filter_cut_rx_fsm ( clk , rst_n , params_frame_type_byte , params_filter_rst , current_cut_done_sqid_reg , current_sqcut_done , current_cut_now_sqid_reg_vld , st_rx_start , st_rx_offset , st_rx_end , st_rx_valid , st_rx_data , st_rx_empty , st_rx_cnt , sq_cut_reset_pre , sq_cut_reset , sq_frame_flag , sq_shift_full_flag , sq_cut_len_reg , market_explain , info_classify , dialog_num , contract_flag , contract_num , contract_code , update_time , update_ms , new_price , turnover , volume , position , purchase_price , buy_quantity , sell_price , sell_quantity , market_rdy );
 parameter FIR_R_IDLE_STATE = 5'd0 ;
 parameter FIR_R_SYNC_STATE = 5'd1 ;
 parameter FIR_R_CHECK_STATE = 5'd4 ;
 parameter FIR_R_ID_STATE = 5'd5 ;
 parameter FIR_R_HEADER_STATE = 5'd6 ;
 parameter FIR_R_RDATA0_STATE = 5'd7 ;
 parameter FIR_R_REND_STATE = 5'd8 ;
 parameter FIR_R_ERROR_STATE = 5'd22 ;
 input clk ;
 input rst_n ;
 input [15:0] params_frame_type_byte ;
 input params_filter_rst ;
 input st_rx_start ;
 input [ 3:0] st_rx_offset ;
 input st_rx_end ;
 input st_rx_valid ;
 input [63:0] st_rx_data ;
 input [ 2:0] st_rx_empty ;
 input [15:0] st_rx_cnt ;
 input sq_cut_reset_pre ;
 output sq_cut_reset ;
 input sq_frame_flag ;
 output sq_shift_full_flag ;
 output [15:0] sq_cut_len_reg ;
 output [31:0] current_cut_done_sqid_reg ;
 output current_sqcut_done ;
 output current_cut_now_sqid_reg_vld ;
 output [ 23: 0] market_explain ;
 output [ 7: 0] info_classify ;
 output [ 31: 0] dialog_num ;
 output [ 7: 0] contract_flag ;
 output [ 31: 0] contract_num ;
 output [175: 0] contract_code ;
 output [ 71: 0] update_time ;
 output [ 31: 0] update_ms ;
 output [ 63: 0] new_price ;
 output [ 31: 0] turnover ;
 output [ 63: 0] volume ;
 output [ 63: 0] position ;
 output [ 63: 0] purchase_price ;
 output [ 31: 0] buy_quantity ;
 output [ 63: 0] sell_price ;
 output [ 31: 0] sell_quantity ;
 output market_rdy ;
 wire [31:0] current_cut_done_sqid_reg ;
 reg [31:0] current_cut_now_sqid_reg ;
 reg current_cut_now_sqid_reg_vld ;
 reg current_sqcut_done ;
 reg [ 5:0] st_shift_scnt ;
 reg st_shift_en ;
 wire [191:0] st_shift_reg ;
 wire [ 5:0] st_shift_ccnt ;
 wire [15:0] sync_fisrt_byte = st_shift_reg[127+64:112+64];
 wire [15:0] sync_len_byte = st_shift_reg[111+64: 96+64];
 wire [31:0] sync_four_byte = st_shift_reg[ 95+64: 64+64];
 wire [15:0] frame_type_byte = st_shift_reg[127+64:112+64];
 wire [31:0] frame_sync_byte = st_shift_reg[111+64: 80+64];
 wire [31:0] current_id_wire = st_shift_reg[127+64:96+64] ;
 wire [15:0] patition_cnt_wire = st_shift_reg[ 95+64:80+64] ;
 wire [15:0] patition_len_wire = st_shift_reg[ 79+64:64+64] ;
 wire [15:0] segm_type_wire = st_shift_reg[127+64:112+64];
 wire [15:0] segm_len_wire = st_shift_reg[111+64: 96+64];
 wire [15:0] segm_min_len = 16'd81 ;
 reg [15:0] st_rx_cnt_reg ;
 reg [2 :0] discard_data_cnt ;
 reg [15:0] patition_cnt_reg ;
 reg [15:0] patition_len_reg ;
 reg [15:0] patition_cnt ;
 reg [15:0] segm_len ;
 reg [15:0] segm_type ;
 wire [11:0] segm_cnt0_wire ;
 wire [ 3:0] segm_cnt1_wire ;
 assign segm_cnt0_wire = segm_len[15:4] ;
 assign segm_cnt1_wire = segm_len[ 3:0] ;
 reg [11:0] segm_cnt ;
 reg [15:0] st_rx_cut_cnt ;
 reg [15:0] sq_cut_len_reg ;
 reg sq_cut_reset_pre_dly ;
 reg sq_cut_reset ;
 wire st_rx_data_en = st_rx_valid ;
 reg [ 4:0] fir_rx_cstate ;
 reg [ 4:0] fir_rx_nstate ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 fir_rx_cstate <= 5'd0 ;
 end
 else if (sq_cut_reset||params_filter_rst) begin
 fir_rx_cstate <= 5'd0 ;
 end
 else begin
 fir_rx_cstate <= fir_rx_nstate ;
 end
 end
 wire fir_r_idle_st = ( fir_rx_cstate== FIR_R_IDLE_STATE );
 wire fir_r_sync_st = ( fir_rx_cstate== FIR_R_SYNC_STATE );
 wire fir_r_check_st = ( fir_rx_cstate== FIR_R_CHECK_STATE );
 wire fir_r_id_st = ( fir_rx_cstate== FIR_R_ID_STATE );
 wire fir_r_header_st = ( fir_rx_cstate== FIR_R_HEADER_STATE );
 wire fir_r_rdata0_st = ( fir_rx_cstate== FIR_R_RDATA0_STATE );
 wire fir_r_rend_st = ( fir_rx_cstate== FIR_R_REND_STATE );
 always@ ( * ) begin
 fir_rx_nstate = fir_rx_cstate;
 case(fir_rx_cstate) FIR_R_IDLE_STATE : begin
 if (st_rx_start&&st_rx_data_en) begin
 fir_rx_nstate = FIR_R_SYNC_STATE ;
 end
 end
 FIR_R_SYNC_STATE : begin
 if (st_shift_ccnt>=6'd8) begin
 if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)) begin
 fir_rx_nstate = FIR_R_CHECK_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_ERROR_STATE ;
 end
 end
 end
 FIR_R_CHECK_STATE : begin
 if (st_shift_ccnt>=6'd6 ) begin
 if ( ( frame_type_byte==params_frame_type_byte ) &&(frame_sync_byte==32'h0000_5902) ) begin
 fir_rx_nstate = FIR_R_ID_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_ERROR_STATE ;
 end
 end
 end
 FIR_R_ID_STATE : begin
 if ( st_shift_ccnt>=6'd12 ) begin
 if (patition_cnt_wire<=16'h0001) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_HEADER_STATE ;
 end
 end
 end
 /* FIR_R_DISCARD_STATE : begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
 if ( discard_calc_cnt1==4'd0 ) begin
 if ( st_rx_cnt_reg<(16'd16+ segm_min_len ) ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_DSYNC_STATE ;
 end
 end
 else begin
 fir_rx_nstate = FIR_R_DISEND_STATE ;
 end
 end
 end
 FIR_R_DISEND_STATE: begin
 if ( st_shift_ccnt>=discard_calc_cnt1 ) begin
 if ( st_rx_cnt_reg<( discard_calc_cnt1 + segm_min_len )) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_DSYNC_STATE ;
 end
 end
 end
 */ FIR_R_HEADER_STATE : begin
 if ( st_shift_ccnt>=6'd4 )begin
 fir_rx_nstate = FIR_R_RDATA0_STATE ;
 end
 end
 FIR_R_RDATA0_STATE : begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) )begin
 if (segm_cnt1_wire==4'd0) begin
 if (patition_cnt>=patition_cnt_reg) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_HEADER_STATE ;
 end
 end
 else begin
 fir_rx_nstate = FIR_R_REND_STATE ;
 end
 end
 end
 FIR_R_REND_STATE : begin
 if ( st_shift_ccnt>=segm_cnt1_wire)begin
 if (patition_cnt>=patition_cnt_reg) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_HEADER_STATE ;
 end
 end
 end
 /* FIR_R_RJUDGE_STATE : begin
 if (st_rx_cnt_reg==16'd0) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else if (st_rx_cnt_reg<=16'd8) begin
 fir_rx_nstate = sq_frame_flag ? FIR_RSQ_SEGMT_H_STATE : FIR_RSC_SEGMT_H_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_VSYNC_STATE ;
 end
 end
 */ /* FIR_RSQ_SEGMT_H_STATE : begin
 if ( st_shift_ccnt>=st_rx_cnt_reg ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 FIR_RSC_SEGMT_H_STATE : begin
 if ( st_shift_ccnt>=st_rx_cnt_reg ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 */ /* FIR_RSC_SEGMT_STATE : begin
 if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
 fir_rx_nstate = FIR_RSC_SEGMT_END_STATE ;
 end
 end
 FIR_RSC_SEGMT_END_STATE : begin
 if ( st_shift_ccnt>=st_rx_cnt_reg ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 FIR_RSQ_SEGMT_STATE : begin
 if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
 fir_rx_nstate = FIR_RSQ_SEGMT_END_STATE ;
 end
 end
 FIR_RSQ_SEGMT_END_STATE : begin
 if ( st_shift_ccnt>=st_rx_cnt_reg ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 */ FIR_R_ERROR_STATE : begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 default : begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 endcase end
 /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_frame_flag <= 1'd0 ;
 sc_frame_flag <= 1'd0 ;
 end
 else if ( fir_r_check_st ) begin
 sq_frame_flag <= (frame_type_byte==16'h03e9) ;
 sc_frame_flag <= (frame_type_byte==16'h1389) ;
 end
 end
 */ /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sync_len_rest_reg <= 16'd0 ;
 end
 else if (st_rx_start&&~tcp_sqmatch_flag&&~tcp_scmatch_flag) begin
 sync_len_rest_reg <= first_sync_len_byte - 16'd22 ;
 end
 else if ( fir_r_dsync_st || fir_r_vsync_st ) begin
 sync_len_rest_reg <= sync_len_byte - 16'd22 ;
 end
 end
 */ /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rx_cnt_reg <= 16'd0 ;
 end
 else if ( st_rx_start ) begin
 st_rx_cnt_reg <= (tcp_payload_len - st_rx_cnt - st_rx_offset - 16'd8) ;
 end
 else if ( ( fir_r_dsync_st || fir_r_vsync_st) && (st_shift_ccnt>=16'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if (fir_r_check_st && (st_shift_ccnt>=16'd6) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd6 ;
 end
 else if (fir_r_id_st && (st_shift_ccnt>=16'd12) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd12 ;
 end
 else if (fir_r_header_st && (st_shift_ccnt>=16'd4) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd4 ;
 end
 else if ( fir_r_rdata0_st && (st_shift_ccnt>=6'd16) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd16 ;
 end
 else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - segm_cnt1_wire ;
 end
 else if ( (fir_r_sqcut_st || fir_r_sccut_st) && (st_shift_ccnt>=6'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if ( (fir_r_sqcut_end_st || fir_r_sccut_end_st) && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - st_rx_cnt_reg ;
 end
 else if ( (fir_r_sqcuth_st || fir_r_sccuth_st) && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - st_rx_cnt_reg ;
 end
 else if ((fir_r_sqrcut_st) && (st_shift_ccnt>=16'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if ((fir_r_sqrcut_end_st) && (st_shift_ccnt>=sub_sqcut_len_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - sub_sqcut_len_reg ;
 end
 else if ((fir_r_scrcut_st) && (st_shift_ccnt>=16'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if ((fir_r_scrcut_end_st) && (st_shift_ccnt>=sub_sccut_len_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - sub_sccut_len_reg ;
 end
 end
 */ reg [3:0] sq_cut_reset_pre_cnt ;
 reg [3:0] sq_cut_reset_cnt ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_reset_pre_dly <= 1'd0 ;
 sq_cut_reset_pre_cnt <= 4'd0 ;
 end
 else if (params_filter_rst) begin
 sq_cut_reset_pre_dly <= 1'd0 ;
 sq_cut_reset_pre_cnt <= 4'd0 ;
 end
 else if (sq_cut_reset_pre&&( fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin
 sq_cut_reset_pre_dly <= 1'd0 ;
 sq_cut_reset_pre_cnt <= 4'd0 ;
 end
 else if (sq_cut_reset_pre&&( fir_rx_cstate== FIR_R_IDLE_STATE ) ) begin
 sq_cut_reset_pre_dly <= 1'd0 ;
 sq_cut_reset_pre_cnt <= 4'd0 ;
 end
 else if (sq_cut_reset_pre_dly&& ( fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin
 sq_cut_reset_pre_dly <= 1'd0 ;
 sq_cut_reset_pre_cnt <= 4'd0 ;
 end
 else if (sq_cut_reset_pre_dly && (sq_cut_reset_pre_cnt>=4'd7) ) begin
 sq_cut_reset_pre_dly <= 1'd0 ;
 sq_cut_reset_pre_cnt <= 4'd0 ;
 end
 else if (sq_cut_reset_pre ) begin
 sq_cut_reset_pre_dly <= 1'd1 ;
 sq_cut_reset_pre_cnt <= sq_cut_reset_pre_cnt + 4'd1 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_reset_cnt <= 1'd0 ;
 end
 else if (params_filter_rst) begin
 sq_cut_reset_cnt <= 1'd0 ;
 end
 else if (sq_cut_reset_pre ) begin
 sq_cut_reset_cnt <= sq_cut_reset_cnt + 1'd1 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_reset <= 1'd0 ;
 end
 else if (params_filter_rst) begin
 sq_cut_reset <= 1'd1 ;
 end
 else if (sq_cut_reset_pre&&( fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin
 sq_cut_reset <= 1'd1 ;
 end
 else if (sq_cut_reset_pre&&( fir_rx_cstate== FIR_R_IDLE_STATE ) ) begin
 sq_cut_reset <= 1'd1 ;
 end
 else if (sq_cut_reset_pre_dly&& ( fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin
 sq_cut_reset <= 1'd1 ;
 end
 else if (sq_cut_reset_pre_dly && (sq_cut_reset_pre_cnt>=4'd7) ) begin
 sq_cut_reset <= 1'd1 ;
 end
 else begin
 sq_cut_reset <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 discard_data_cnt <= 3'd0 ;
 end
 else if ( fir_r_rdata0_st ) begin
 discard_data_cnt <= (st_shift_ccnt>=6'd16) ? discard_data_cnt + 1'd1 : discard_data_cnt ;
 end
 else begin
 discard_data_cnt <= 3'd0 ;
 end
 end
 reg segm_type_2439 ;
 reg segm_type_2433 ;
 reg segm_type_2434 ;
 reg segm_type_2433_flag ;
 reg segm_type_2434_flag ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 segm_len <= 16'd0 ;
 segm_type <= 16'd0 ;
 segm_type_2439 <= 1'd0 ;
 segm_type_2433 <= 1'd0 ;
 segm_type_2434 <= 1'd0 ;
 end
 else if ( fir_r_header_st && (st_shift_ccnt>=6'd4) ) begin
 segm_len <= segm_len_wire ;
 segm_type <= segm_type_wire ;
 segm_type_2439 <= (segm_type_wire==16'h2439) ;
 segm_type_2433 <= (segm_type_wire==16'h2433) ;
 segm_type_2434 <= (segm_type_wire==16'h2434) ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 segm_type_2433_flag <= 1'd0 ;
 segm_type_2434_flag <= 1'd0 ;
 end
 else if (fir_r_id_st) begin
 segm_type_2433_flag <= 1'd0 ;
 segm_type_2434_flag <= 1'd0 ;
 end
 else if ( fir_r_header_st && (st_shift_ccnt>=6'd4) ) begin
 segm_type_2433_flag <= (segm_type_wire==16'h2433) ? 1'd1 : segm_type_2433_flag ;
 segm_type_2434_flag <= (segm_type_wire==16'h2434) ? 1'd1 : segm_type_2434_flag ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 patition_cnt_reg <= 16'd0 ;
 patition_len_reg <= 16'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) ) begin
 patition_cnt_reg <= patition_cnt_wire ;
 patition_len_reg <= patition_len_wire ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 patition_cnt <= 16'd0 ;
 end
 else if (fir_r_id_st) begin
 patition_cnt <= 16'd0 ;
 end
 else if ( fir_r_header_st && (st_shift_ccnt>=6'd4 ) ) begin
 patition_cnt <= patition_cnt + 1'd1 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 /* else if (st_rx_start&&~tcp_sqmatch_flag&&~tcp_scmatch_flag && st_rx_data_en) begin
 st_shift_scnt <= 6'd6 ;
 st_shift_en <= 1'd1 ;
 end
 else if (st_rx_start&&tcp_sqmatch_flag && st_rx_data_en) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 */ else if (st_rx_start && st_rx_data_en && (st_rx_empty==3'd0) ) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 /* else if (fir_r_sqrcut_st) begin
 if ( (st_shift_ccnt>=6'd8) && (sub_sqcut_len_reg<=16'd16) ) begin
 st_shift_scnt <= (st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]))) ? sub_sqcut_len_reg[5:0] - 6'd8 : 6'd0 ;
 st_shift_en <= (st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]))) ? 1'd1 : 1'd0;
 end
 else if (st_rx_data_en ) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_sqrcut_end_st && ( st_shift_ccnt>=sub_sqcut_len_reg[5:0] ) ) begin
 st_shift_scnt <= (st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8))) ? 6'd8 : 6'd0 ;
 st_shift_en <= (st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8))) ? 1'd1 : 1'd0 ;
 end
 else if (fir_r_scrcut_st) begin
 if ( (st_shift_ccnt>=6'd8) && (sub_sccut_len_reg<=16'd16) ) begin
 st_shift_scnt <= (st_rx_data_en || (st_shift_ccnt>=(sub_sccut_len_reg[5:0]))) ? sub_sccut_len_reg[5:0] - 6'd8 : 6'd0 ;
 st_shift_en <= (st_rx_data_en || (st_shift_ccnt>=(sub_sccut_len_reg[5:0]))) ? 1'd1 : 1'd0;
 end
 else if (st_rx_data_en ) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_scrcut_end_st && ( st_shift_ccnt>=sub_sccut_len_reg[5:0] ) ) begin
 st_shift_scnt <= (st_rx_data_en || (st_shift_ccnt>=(sub_sccut_len_reg[5:0]+6'd8))) ? 6'd8 : 6'd0 ;
 st_shift_en <= (st_rx_data_en || (st_shift_ccnt>=(sub_sccut_len_reg[5:0]+6'd8))) ? 1'd1 : 1'd0 ;
 end
 */ else if (fir_r_sync_st ) begin
 if (st_shift_ccnt>=6'd8) begin
 st_shift_scnt <= (st_shift_ccnt>=6'd14)|| (st_rx_data_en&&((st_shift_ccnt-st_rx_empty)>=6'd6)) ? 6'd6 : 6'd0 ;
 st_shift_en <= (st_shift_ccnt>=6'd14)|| (st_rx_data_en&&((st_shift_ccnt-st_rx_empty)>=6'd6)) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en && ((st_shift_ccnt+6'd8-st_rx_empty)>=6'd8) ) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 /* else if (fir_r_vsync_st ) begin
 if (st_shift_ccnt>=6'd8) begin
 if ( (st_rx_cnt_reg<(sync_len_byte+16'd4)) && (sq_frame_flag||sc_frame_flag) ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd12)||st_rx_data_en) ? 6'd4 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd12)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (st_rx_data_en) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 */ else if (fir_r_check_st) begin
 if (st_shift_ccnt>=6'd6 ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&((st_shift_ccnt+6'd2-st_rx_empty)>=6'd12))) ? 6'd12 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&((st_shift_ccnt+6'd2-st_rx_empty)>=6'd12))) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en&&((st_shift_ccnt+6'd8-st_rx_empty)>=6'd6)) begin
 st_shift_scnt <= 6'd6 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_id_st) begin
 if ( st_shift_ccnt>=6'd12 ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd16)||(st_rx_data_en&&((st_shift_ccnt-6'd4-st_rx_empty)>=6'd4))) ? 6'd4 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd16)||(st_rx_data_en&&((st_shift_ccnt-6'd4-st_rx_empty)>=6'd4))) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en&& ((st_shift_ccnt+6'd8-st_rx_empty)>=6'd12) ) begin
 st_shift_scnt <= 6'd12 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 /* else if ( fir_r_discard_st ) begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
 if ( discard_calc_cnt1==4'd0 ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd24)||(st_rx_data_en&&(st_shift_ccnt>=6'd16))) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd24)||(st_rx_data_en&&(st_shift_ccnt>=6'd16))) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ? discard_calc_cnt1 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ? 1'd1 : 1'd0 ;
 end
 end
 else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
 st_shift_scnt <= 6'd16 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_disend_st) begin
 if ( st_shift_ccnt>=discard_calc_cnt1 ) begin
 st_shift_scnt <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(discard_calc_cnt1)))) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(discard_calc_cnt1)))) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en) begin
 st_shift_scnt <= discard_calc_cnt1 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 */ else if (fir_r_header_st) begin
 if ( st_shift_ccnt>=6'd4 )begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&& ((st_shift_ccnt+6'd4-st_rx_empty)>=6'd16) )) ? 6'd16 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&& ((st_shift_ccnt+6'd4-st_rx_empty)>=6'd16) )) ? 1'd1 : 1'd0 ;
 end
 else if ( st_rx_data_en && ((st_shift_ccnt+6'd8-st_rx_empty)>=6'd4) ) begin
 st_shift_scnt <= 6'd4 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_rdata0_st) begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) )begin
 if (segm_cnt1_wire==4'd0) begin
 if (patition_cnt<patition_cnt_reg) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd20)|| (st_rx_data_en&& ((st_shift_ccnt-6'd8-st_rx_empty)>=6'd4) ) ) ? 6'd4 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd20)|| (st_rx_data_en&& ((st_shift_ccnt-6'd8-st_rx_empty)>=6'd4) ) ) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else begin
 if (st_shift_ccnt>=(6'd16+segm_cnt1_wire)) begin
 st_shift_scnt <= segm_cnt1_wire ;
 st_shift_en <= 1'd1 ;
 end
 else if (st_rx_data_en && ((st_shift_ccnt-6'd8-st_rx_empty)>= segm_cnt1_wire) ) begin
 st_shift_scnt <= segm_cnt1_wire ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 end
 else if (st_rx_data_en&&(st_shift_ccnt>=(6'd8+st_rx_empty)) ) begin
 st_shift_scnt <= st_shift_en ? 6'd0 : 6'd16 ;
 st_shift_en <= st_shift_en ? 1'd0 : 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if ( fir_r_rend_st ) begin
 if ( st_shift_ccnt>=segm_cnt1_wire)begin
 if (patition_cnt>=patition_cnt_reg) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 else begin
 if ( st_shift_ccnt>=(6'd4+segm_cnt1_wire) ) begin
 st_shift_scnt <= 6'd4 ;
 st_shift_en <= 1'd1 ;
 end
 else if ( st_rx_data_en&&(st_rx_empty<=6'd4 ) ) begin
 st_shift_scnt <= 6'd4 ;
 st_shift_en <= 1'd1 ;
 end
 else if ( st_rx_data_en && ( (st_shift_ccnt + 6'd8) >= (6'd4 + st_rx_empty + segm_cnt1_wire )) ) begin
 st_shift_scnt <= 6'd4 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 end
 else if (st_rx_data_en&& ( (st_shift_ccnt+6'd8-st_rx_empty) >= segm_cnt1_wire ) ) begin
 st_shift_scnt <= segm_cnt1_wire ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 /* else if (fir_r_rjudge_st) begin
 if (st_rx_cnt_reg==16'd0) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 else if (st_rx_cnt_reg<=16'd8) begin
 st_shift_scnt <= st_rx_cnt_reg[5:0] ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd8)||st_rx_data_en) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd8)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 end
 */ /* else if (fir_r_sccut_st || fir_r_sqcut_st ) begin
 if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
 st_shift_scnt <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ? (st_rx_cnt_reg[5:0]-6'd8) : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 */ else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 wire [ 23: 0] market_explain ;
 wire [ 7: 0] info_classify ;
 reg [ 31: 0] dialog_num ;
 wire [ 7: 0] contract_flag ;
 wire [ 31: 0] contract_num ;
 reg [175: 0] contract_code ;
 reg [ 71: 0] update_time ;
 reg [ 31: 0] update_ms ;
 reg [ 63: 0] new_price ;
 reg [ 31: 0] turnover ;
 reg [ 63: 0] volume ;
 reg [ 63: 0] position ;
 reg [ 63: 0] purchase_price ;
 reg [ 31: 0] buy_quantity ;
 reg [ 63: 0] sell_price ;
 reg [ 31: 0] sell_quantity ;
 reg market_rdy ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 dialog_num <= 32'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) ) begin
 dialog_num <= {current_id_wire[7:0],current_id_wire[15:8],current_id_wire[23:16],current_id_wire[31:24]} ;
 end
 end
 wire [127: 0] contract_code0 = st_shift_reg[127+64: 64] ;
 wire [ 47: 0] contract_code1 = st_shift_reg[127+64:80+64] ;
 wire [ 71: 0] contract_code2 = st_shift_reg[ 79+64: 8+64] ;
 wire [ 7: 0] update_time_wire1 = st_shift_reg[ 7+64: 64] ;
 wire [ 63: 0] update_time_wire2 = st_shift_reg[127+64:64+64] ;
 wire [ 31: 0] update_ms_wire = st_shift_reg[ 63+64:32+64] ;
 wire [ 63: 0] new_price_wire = st_shift_reg[127+64: 64+64] ;
 wire [ 31: 0] turnover_wire = st_shift_reg[ 63+64: 32+64] ;
 wire [ 31: 0] volume0 = st_shift_reg[ 31+64: 64] ;
 wire [ 31: 0] volume1 = st_shift_reg[127+64: 96+64] ;
 wire [ 63: 0] position_wire = st_shift_reg[ 95+64: 32+64] ;
 wire [ 63: 0] purchase_price_wire = st_shift_reg[127+64: 64+64] ;
 wire [ 31: 0] buy_quantity_wire = st_shift_reg[ 63+64: 32+64] ;
 wire [ 31: 0] sell_price0 = st_shift_reg[ 31+64: 64] ;
 wire [ 31: 0] sell_price1 = st_shift_reg[127+64: 96+64] ;
 wire [ 31: 0] sell_quantity_wire = st_shift_reg[ 95+64: 64+64] ;
 assign market_explain = {8'h53,8'h51,8'h00} ;
 assign info_classify = 8'h31 ;
 assign contract_flag = 8'h30 ;
 assign contract_num = 32'd0 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 contract_code <= 176'd0 ;
 end
 else if (fir_r_id_st) begin
 contract_code <= 176'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==3'd0) ) begin
 contract_code[175:48] <= contract_code0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==3'd1) ) begin
 contract_code[47: 0] <= contract_code1 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 update_time <= 72'd0 ;
 end
 else if (fir_r_id_st) begin
 update_time <= 72'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==3'd1) ) begin
 update_time[71:64] <= update_time_wire1 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==3'd2) ) begin
 update_time[63: 0] <= update_time_wire2 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 update_ms <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 update_ms <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==3'd2) ) begin
 update_ms[31: 0] <= {update_ms_wire[7:0],update_ms_wire[15:8],update_ms_wire[23:16],update_ms_wire[31:24]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 new_price <= 64'd0 ;
 end
 else if (fir_r_id_st || (&new_price[63:0]) ) begin
 new_price <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2433) && (discard_data_cnt==3'd0) ) begin
 new_price[63: 0] <= {new_price_wire[7:0],new_price_wire[15:8],new_price_wire[23:16],new_price_wire[31:24],new_price_wire[39:32],new_price_wire[47:40],new_price_wire[55:48],new_price_wire[63:56]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 turnover <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 turnover <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2433) && (discard_data_cnt==3'd0) ) begin
 turnover[31: 0] <= { turnover_wire[7:0],turnover_wire[15:8],turnover_wire[23:16],turnover_wire[31:24] } ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 volume <= 64'd0 ;
 end
 else if (fir_r_id_st || (&volume[63:0]) ) begin
 volume <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2433) && (discard_data_cnt==3'd0) ) begin
 volume[31: 0] <= { volume0[7:0],volume0[15:8],volume0[23:16],volume0[31:24] } ;
 end
 else if ( fir_r_rend_st && (segm_type_2433) ) begin
 volume[63: 32] <= { volume1[7:0],volume1[15:8],volume1[23:16],volume1[31:24] } ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 position <= 64'd0 ;
 end
 else if (fir_r_id_st || (&position[63:0]) ) begin
 position <= 'd0 ;
 end
 else if ( fir_r_rend_st && (segm_type_2433) ) begin
 position[63: 0] <= {position_wire[7:0],position_wire[15:8],position_wire[23:16],position_wire[31:24],position_wire[39:32],position_wire[47:40],position_wire[55:48],position_wire[63:56]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 purchase_price <= 64'd0 ;
 end
 else if (fir_r_id_st || (&purchase_price[63:0]) ) begin
 purchase_price <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2434) && (discard_data_cnt==3'd0) ) begin
 purchase_price[63: 0] <= {purchase_price_wire[7:0],purchase_price_wire[15:8],purchase_price_wire[23:16],purchase_price_wire[31:24],purchase_price_wire[39:32],purchase_price_wire[47:40],purchase_price_wire[55:48],purchase_price_wire[63:56]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 buy_quantity <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 buy_quantity <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2434) && (discard_data_cnt==3'd0) ) begin
 buy_quantity[31: 0] <= {buy_quantity_wire[7:0],buy_quantity_wire[15:8],buy_quantity_wire[23:16],buy_quantity_wire[31:24]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sell_price <= 64'd0 ;
 end
 else if (fir_r_id_st ) begin
 sell_price <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2434) && (discard_data_cnt==3'd0) ) begin
 sell_price[31: 0] <= {sell_price0[7:0],sell_price0[15:8],sell_price0[23:16],sell_price0[31:24] } ;
 end
 else if ( fir_r_rend_st && (segm_type_2434) ) begin
 sell_price[63: 0] <= ((&sell_price[31: 0])&&(&sell_price1[31:0])) ? 64'd0 : { {sell_price1[7:0],sell_price1[15:8],sell_price1[23:16],sell_price1[31:24] } , sell_price[31:0] } ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sell_quantity <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 sell_quantity <= 'd0 ;
 end
 else if ( fir_r_rend_st && (segm_type_2434) ) begin
 sell_quantity[31: 0] <= {sell_quantity_wire[7:0],sell_quantity_wire[15:8],sell_quantity_wire[23:16],sell_quantity_wire[31:24]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_cut_now_sqid_reg <= 32'd0 ;
 current_cut_now_sqid_reg_vld <= 1'd0 ;
 end
 else if (params_filter_rst||fir_r_check_st) begin
 current_cut_now_sqid_reg <= 32'd0 ;
 current_cut_now_sqid_reg_vld <= 1'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) && sq_frame_flag ) begin
 current_cut_now_sqid_reg <= current_id_wire ;
 current_cut_now_sqid_reg_vld <= 1'd1 ;
 end
 else begin
 current_cut_now_sqid_reg_vld <= 1'd0 ;
 end
 end
 assign current_cut_done_sqid_reg = current_cut_now_sqid_reg ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqcut_done <= 1'd0 ;
 end
 else if ( fir_r_rdata0_st ) begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) )begin
 if (segm_cnt1_wire==4'd0) begin
 if (patition_cnt>=patition_cnt_reg) begin
 current_sqcut_done <= sq_frame_flag ;
 end
 else begin
 current_sqcut_done <= 1'd0 ;
 end
 end
 else begin
 current_sqcut_done <= 1'd0 ;
 end
 end
 else begin
 current_sqcut_done <= 1'd0 ;
 end
 end
 else if (fir_r_rend_st) begin
 if ( st_shift_ccnt>=segm_cnt1_wire)begin
 if (patition_cnt>=patition_cnt_reg) begin
 current_sqcut_done <= sq_frame_flag ;
 end
 else begin
 current_sqcut_done <= 1'd0 ;
 end
 end
 else begin
 current_sqcut_done <= 1'd0 ;
 end
 end
 else begin
 current_sqcut_done <= 1'd0 ;
 end
 end
 /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg <= 32'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) ) begin
 if ( (current_id_wire>current_sqid_reg)&&sq_frame_flag && (patition_cnt_wire>16'h0001) ) begin
 current_sqid_reg = current_id_wire ;
 end
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_scid_reg <= 32'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) ) begin
 if ( (current_id_wire>current_scid_reg)&&sc_frame_flag && (patition_cnt_wire>16'h0001) ) begin
 current_scid_reg = current_id_wire ;
 end
 end
 end
 */ /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sc_cut_flag <= 1'd0 ;
 end
 else if ( fir_r_vsync_st && (st_rx_cnt_reg<(sync_len_byte+16'd4)) ) begin
 sc_cut_flag <= sc_frame_flag ;
 end
 else if (fir_r_rjudge_st) begin
 sc_cut_flag <= sc_frame_flag && (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ;
 end
 else begin
 sc_cut_flag <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_flag <= 1'd0 ;
 end
 else if ( fir_r_vsync_st && (st_rx_cnt_reg<(sync_len_byte+16'd4)) ) begin
 sq_cut_flag <= sq_frame_flag ;
 end
 else if (fir_r_rjudge_st) begin
 sq_cut_flag <= sq_frame_flag && (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ;
 end
 else begin
 sq_cut_flag <= 1'd0 ;
 end
 end
 */ always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 market_rdy <= 1'd0 ;
 end
 else if (sq_cut_reset_pre || sq_cut_reset || sq_cut_reset_pre_dly ) begin
 market_rdy <= 1'd0 ;
 end
 else if (fir_r_rdata0_st && (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) && (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg) ) begin
 market_rdy <= (segm_type_2433_flag || segm_type_2434_flag) ;
 end
 else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) && (patition_cnt>=patition_cnt_reg) ) begin
 market_rdy <= (segm_type_2433_flag || segm_type_2434_flag) ;
 end
 else begin
 market_rdy <= 1'd0 ;
 end
 end
 /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rx_ready <= 1'd1 ;
 end
 else if (fir_r_rdata0_st && (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1)) && (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg) ) begin
 st_rx_ready <= 1'd0 ;
 end
 else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) && (patition_cnt>=patition_cnt_reg) ) begin
 st_rx_ready <= 1'd0 ;
 end
 else if ( fir_r_rjudge_st ) begin
 st_rx_ready <= 1'd1 ;
 end
 else begin
 st_rx_ready <= 1'd1 ;
 end
 end
 */ always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_len_reg <= 16'd81 ;
 end
 else if (st_rx_start) begin
 sq_cut_len_reg <= 16'd81 ;
 end
 else if ( fir_r_sync_st && (st_shift_ccnt>=6'd8) ) begin
 sq_cut_len_reg <= sync_len_byte + 16'd4 ;
 end
 end
 /* always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rq_cut_cnt <= 16'd0 ;
 end
 else if ( fir_r_sqcuth_st ) begin
 st_rq_cut_cnt <= st_rx_cnt_reg ;
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sq_frame_flag ) begin
 st_rq_cut_cnt <= 16'd8 ;
 end
 else if ( (fir_r_sqcut_st ) && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg>16'd8) ) begin
 st_rq_cut_cnt <= st_rq_cut_cnt + 16'd8 ;
 end
 else if ( (fir_r_sqcut_st ) && (st_shift_ccnt>=st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ) begin
 st_rq_cut_cnt <= st_rq_cut_cnt + st_rx_cnt_reg ;
 end
 else if (fir_r_sqrcut_st && (st_shift_ccnt>=16'd8) && (sub_sqcut_len_reg>16'd8) ) begin
 st_rq_cut_cnt <= st_rq_cut_cnt + 16'd8 ;
 end
 else if (fir_r_sqrcut_st && (st_shift_ccnt>=sub_sqcut_len_reg) && (sub_sqcut_len_reg<=16'd8) ) begin
 st_rq_cut_cnt <= st_rq_cut_cnt + sub_sqcut_len_reg ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rc_cut_cnt <= 16'd0 ;
 end
 else if ( fir_r_sccuth_st ) begin
 st_rc_cut_cnt <= st_rx_cnt_reg ;
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sc_frame_flag ) begin
 st_rc_cut_cnt <= 16'd8 ;
 end
 else if ( ( fir_r_sccut_st) && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg>16'd8) ) begin
 st_rc_cut_cnt <= st_rc_cut_cnt + 16'd8 ;
 end
 else if ( ( fir_r_sccut_st) && (st_shift_ccnt>=st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ) begin
 st_rc_cut_cnt <= st_rc_cut_cnt + st_rx_cnt_reg ;
 end
 else if (fir_r_scrcut_st && (st_shift_ccnt>=16'd8) && (sub_sccut_len_reg>16'd8) ) begin
 st_rc_cut_cnt <= st_rc_cut_cnt + 16'd8 ;
 end
 else if (fir_r_scrcut_st && (st_shift_ccnt>=sub_sccut_len_reg) && (sub_sccut_len_reg<=16'd8) ) begin
 st_rc_cut_cnt <= st_rc_cut_cnt + sub_sccut_len_reg ;
 end
 end
 */ /* fir_cut_out sq_fir_cut_out ( .sq_rx_start (sq_rx_start ), .sq_rx_end (sq_rx_end ), .sq_rx_valid (sq_rx_valid ), .sq_rx_data (sq_rx_data ), .sq_rx_empty (sq_rx_empty ), .fir_r_sqcuth_st (fir_r_sqcuth_st ), .fir_r_vsync_st (fir_r_vsync_st ), .fir_r_sqcut_st (fir_r_sqcut_st ), .st_shift_ccnt (st_shift_ccnt ), .st_rx_cnt_reg (st_rx_cnt_reg ), .sq_frame_flag (sq_frame_flag ), .st_shift_reg (st_shift_reg ), .clk (clk ), .rst_n (rst_n ) );
 fir_cut_out sc_fir_cut_out ( .sq_rx_start (sc_rx_start ), .sq_rx_end (sc_rx_end ), .sq_rx_valid (sc_rx_valid ), .sq_rx_data (sc_rx_data ), .sq_rx_empty (sc_rx_empty ), .fir_r_sqcuth_st (fir_r_sccuth_st ), .fir_r_vsync_st (fir_r_vsync_st ), .fir_r_sqcut_st (fir_r_sccut_st ), .st_shift_ccnt (st_shift_ccnt ), .st_rx_cnt_reg (st_rx_cnt_reg ), .sq_frame_flag (sc_frame_flag ), .st_shift_reg (st_shift_reg ), .clk (clk ), .rst_n (rst_n ) );
 */ fir_shift_reg_192 fir_shift_reg_192 ( .fir_rx_cstate (fir_rx_cstate ) , .st_shift_full_flag (sq_shift_full_flag ) , .st_rx_start (st_rx_start ) , .st_rx_offset (4'd0 ) , .st_rx_end (st_rx_end ) , .st_rx_valid (st_rx_valid ) , .st_rx_data (st_rx_data ) , .st_rx_ready (1'd1 ) , .st_rx_empty (st_rx_empty ) , .fir_r_idle_st (fir_r_idle_st ) , .st_shift_reg (st_shift_reg ) , .st_shift_ccnt (st_shift_ccnt ) , .st_shift_scnt (st_shift_scnt ) , .st_shift_en (st_shift_en ) , .clk (clk ) , .rst_n (rst_n ) );
 endmodule
 module filter_rx_fsm ( clk , rst_n , params_current_sqid_reg_add , params_current_sqid_reg_cnt , params_current_sqid_reg_rst_cnt , sq_market_rdy , debug_discard_calc_cnt1 , debug_st_shift_full_flag , debug_st_shift_scnt , debug_st_shift_en , st_rx_cnt_reg , st_shift_ccnt , sync_len_byte , sq_frame_flag , sync_fisrt_byte , sync_four_byte , params_frame_type_byte , params_03e9_type , params_1389_type , params_07d0_type , sub_sqcut_len_reg , current_sqid_reg_flag , current_cut_now_sqid_reg_vld , current_cut_done_sq00id_reg , current_cut_done_sq01id_reg , current_cut_done_sq02id_reg , current_cut_done_sq03id_reg , current_cut_done_sq04id_reg , current_cut_done_sq05id_reg , current_cut_done_sq06id_reg , current_cut_done_sq07id_reg , current_cut_done_sq08id_reg , current_cut_done_sq09id_reg , current_cut_done_sq10id_reg , current_cut_done_sq11id_reg , current_cut_done_sq12id_reg , current_cut_done_sq13id_reg , current_cut_done_sq14id_reg , current_cut_done_sq15id_reg , current_cut_done_sq16id_reg , current_cut_done_sq17id_reg , current_cut_done_sq18id_reg , current_cut_done_sq19id_reg , current_cut_done_sq20id_reg , current_cut_done_sq21id_reg , current_cut_done_sq22id_reg , current_cut_done_sq23id_reg , current_cut_done_sq24id_reg , current_cut_done_sq25id_reg , current_cut_done_sq26id_reg , current_cut_done_sq27id_reg , current_cut_done_sq28id_reg , current_cut_done_sq29id_reg , current_cut_done_sq30id_reg , current_cut_done_sq31id_reg , current_sqcut_done , sq_cut_on_reg , sq_cut_first_on , st_rx_start_pre , st_rx_start , st_rx_offset , st_rx_end , st_rx_valid , st_rx_ready , st_rx_data , st_rx_empty , st_rx_cnt , first_sync_len_byte, tcp_sqmatch_flag_reg , tcp_sqmatch_flag , seq_err_flag , tcp_payload_len , error_flag , fir_r_idle_st , fir_r_sqcuth_st , fir_r_vsync_st , fir_r_sqcut_st , fir_r_sqcut_end_st , fir_r_sqrcut_st , fir_r_sqrcut_end_st , fir_r_rjudge_st , sq_rx_start , sq_rx_end , sq_rx_valid , sq_rx_data , sq_rx_empty , sq_rx_empty_01 , sq_rx_empty_02 , sq_rx_empty_03 , sq_rx_empty_04 , sq_rx_empty_05 , sq_rx_empty_06 , sq_rx_empty_07 , sq_rx_empty_08 , sq_rx_empty_09 , sq_rx_empty_10 , sq_rx_empty_11 , sq_rx_empty_12 , sq_rx_empty_13 , sq_rx_empty_14 , sq_rx_empty_15 , sq_rx_empty_16 , sq_rx_empty_17 , sq_rx_empty_18 , sq_rx_empty_19 , sq_rx_empty_20 , sq_rx_empty_21 , sq_rx_empty_22 , sq_rx_empty_23 , sq_rx_empty_24 , sq_rx_empty_25 , sq_rx_empty_26 , sq_rx_empty_27 , sq_rx_empty_28 , sq_rx_empty_29 , sq_rx_empty_30 , sq_rx_empty_31 , current_sqid_reg , current_sqid_reg_vld , params_current_sqid_reg_ro , params_filter_rst , sq_shift_full_flag , market_explain , info_classify , dialog_num , contract_flag , contract_num , contract_code , update_time , update_ms , new_price , turnover , volume , position , purchase_price , buy_quantity , sell_price , sell_quantity , market_rdy , fir_rx_cstate );
 parameter FIR_R_IDLE_STATE = 5'd0 ;
 parameter FIR_R_VSYNC_STATE = 5'd2 ;
 parameter FIR_R_CHECK_STATE = 5'd4 ;
 parameter FIR_R_ID_STATE = 5'd5 ;
 parameter FIR_R_HEADER_STATE = 5'd6 ;
 parameter FIR_R_RDATA0_STATE = 5'd7 ;
 parameter FIR_R_REND_STATE = 5'd8 ;
 parameter FIR_R_RJUDGE_STATE = 5'd9 ;
 parameter FIR_R_DISCARD_STATE = 5'd10 ;
 parameter FIR_R_DISEND_STATE = 5'd11 ;
 parameter FIR_RSQ_SEGMT_STATE = 5'd12 ;
 parameter FIR_RSQ_SEGMT_END_STATE = 5'd14 ;
 parameter FIR_RSQ_SEGMT_H_STATE = 5'd16 ;
 parameter FIR_R_SQRCUT_STATE = 5'd18 ;
 parameter FIR_R_SQRCUT_END_STATE = 5'd20 ;
 parameter FIR_R_ERROR_STATE = 5'd22 ;
 input [31:0] params_current_sqid_reg_rst_cnt ;
 input [31:0] sq_market_rdy ;
 output [3:0] debug_discard_calc_cnt1 ;
 output debug_st_shift_full_flag ;
 output [ 5:0] debug_st_shift_scnt ;
 output debug_st_shift_en ;
 input clk ;
 input rst_n ;
 input [15:0] sub_sqcut_len_reg ;
 input [15:0] params_frame_type_byte ;
 input [15:0] params_03e9_type ;
 input [15:0] params_1389_type ;
 input [15:0] params_07d0_type ;
 output current_sqid_reg_flag ;
 output [31:0] params_current_sqid_reg_ro ;
 input params_filter_rst ;
 input [31:0] current_cut_now_sqid_reg_vld ;
 input [31:0] current_cut_done_sq00id_reg ;
 input [31:0] current_cut_done_sq01id_reg ;
 input [31:0] current_cut_done_sq02id_reg ;
 input [31:0] current_cut_done_sq03id_reg ;
 input [31:0] current_cut_done_sq04id_reg ;
 input [31:0] current_cut_done_sq05id_reg ;
 input [31:0] current_cut_done_sq06id_reg ;
 input [31:0] current_cut_done_sq07id_reg ;
 input [31:0] current_cut_done_sq08id_reg ;
 input [31:0] current_cut_done_sq09id_reg ;
 input [31:0] current_cut_done_sq10id_reg ;
 input [31:0] current_cut_done_sq11id_reg ;
 input [31:0] current_cut_done_sq12id_reg ;
 input [31:0] current_cut_done_sq13id_reg ;
 input [31:0] current_cut_done_sq14id_reg ;
 input [31:0] current_cut_done_sq15id_reg ;
 input [31:0] current_cut_done_sq16id_reg ;
 input [31:0] current_cut_done_sq17id_reg ;
 input [31:0] current_cut_done_sq18id_reg ;
 input [31:0] current_cut_done_sq19id_reg ;
 input [31:0] current_cut_done_sq20id_reg ;
 input [31:0] current_cut_done_sq21id_reg ;
 input [31:0] current_cut_done_sq22id_reg ;
 input [31:0] current_cut_done_sq23id_reg ;
 input [31:0] current_cut_done_sq24id_reg ;
 input [31:0] current_cut_done_sq25id_reg ;
 input [31:0] current_cut_done_sq26id_reg ;
 input [31:0] current_cut_done_sq27id_reg ;
 input [31:0] current_cut_done_sq28id_reg ;
 input [31:0] current_cut_done_sq29id_reg ;
 input [31:0] current_cut_done_sq30id_reg ;
 input [31:0] current_cut_done_sq31id_reg ;
 input [31:0] current_sqcut_done ;
 input [31:0] sq_cut_on_reg ;
 input [31:0] sq_cut_first_on ;
 input st_rx_start_pre ;
 input st_rx_start ;
 input [ 3:0] st_rx_offset ;
 input st_rx_end ;
 input st_rx_valid ;
 input [63:0] st_rx_data ;
 input [ 2:0] st_rx_empty ;
 input [15:0] st_rx_cnt ;
 output st_rx_ready ;
 input [15:0] first_sync_len_byte;
 input [31:0] tcp_sqmatch_flag_reg ;
 input tcp_sqmatch_flag ;
 input seq_err_flag ;
 output [31:0] error_flag ;
 output fir_r_idle_st ;
 output fir_r_sqcuth_st ;
 output fir_r_vsync_st ;
 output fir_r_sqcut_st ;
 output fir_r_sqcut_end_st ;
 output fir_r_sqrcut_st ;
 output fir_r_sqrcut_end_st ;
 output fir_r_rjudge_st ;
 input [15:0] tcp_payload_len ;
 input sq_shift_full_flag ;
 output [31:0] sq_rx_start ;
 output [31:0] sq_rx_end ;
 output [31:0] sq_rx_valid ;
 output [63:0] sq_rx_data ;
 output [ 2:0] sq_rx_empty ;
 output [ 2:0] sq_rx_empty_01 ;
 output [ 2:0] sq_rx_empty_02 ;
 output [ 2:0] sq_rx_empty_03 ;
 output [ 2:0] sq_rx_empty_04 ;
 output [ 2:0] sq_rx_empty_05 ;
 output [ 2:0] sq_rx_empty_06 ;
 output [ 2:0] sq_rx_empty_07 ;
 output [ 2:0] sq_rx_empty_08 ;
 output [ 2:0] sq_rx_empty_09 ;
 output [ 2:0] sq_rx_empty_10 ;
 output [ 2:0] sq_rx_empty_11 ;
 output [ 2:0] sq_rx_empty_12 ;
 output [ 2:0] sq_rx_empty_13 ;
 output [ 2:0] sq_rx_empty_14 ;
 output [ 2:0] sq_rx_empty_15 ;
 output [ 2:0] sq_rx_empty_16 ;
 output [ 2:0] sq_rx_empty_17 ;
 output [ 2:0] sq_rx_empty_18 ;
 output [ 2:0] sq_rx_empty_19 ;
 output [ 2:0] sq_rx_empty_20 ;
 output [ 2:0] sq_rx_empty_21 ;
 output [ 2:0] sq_rx_empty_22 ;
 output [ 2:0] sq_rx_empty_23 ;
 output [ 2:0] sq_rx_empty_24 ;
 output [ 2:0] sq_rx_empty_25 ;
 output [ 2:0] sq_rx_empty_26 ;
 output [ 2:0] sq_rx_empty_27 ;
 output [ 2:0] sq_rx_empty_28 ;
 output [ 2:0] sq_rx_empty_29 ;
 output [ 2:0] sq_rx_empty_30 ;
 output [ 2:0] sq_rx_empty_31 ;
 output [31:0] current_sqid_reg ;
 output current_sqid_reg_vld ;
 output [ 23: 0] market_explain ;
 output [ 7: 0] info_classify ;
 output [ 31: 0] dialog_num ;
 output [ 7: 0] contract_flag ;
 output [ 31: 0] contract_num ;
 output [175: 0] contract_code ;
 output [ 71: 0] update_time ;
 output [ 31: 0] update_ms ;
 output [ 63: 0] new_price ;
 output [ 31: 0] turnover ;
 output [ 63: 0] volume ;
 output [ 63: 0] position ;
 output [ 63: 0] purchase_price ;
 output [ 31: 0] buy_quantity ;
 output [ 63: 0] sell_price ;
 output [ 31: 0] sell_quantity ;
 output market_rdy ;
 output [ 15: 0] st_rx_cnt_reg ;
 output [ 5: 0] st_shift_ccnt ;
 output [ 15: 0] sync_len_byte ;
 output [ 15:0] sync_fisrt_byte ;
 output [ 31:0] sync_four_byte ;
 output sq_frame_flag ;
 output fir_rx_cstate;
 input [3:0] params_current_sqid_reg_add ;
 input [3:0] params_current_sqid_reg_cnt ;
 reg frame_type_rdy ;
 wire st_shift_full_flag ;
 wire debug_st_shift_full_flag = st_shift_full_flag ;
 reg [31:0] error_flag ;
 wire st_rx_ready ;
 reg [ 5:0] st_shift_scnt ;
 reg st_shift_en ;
 wire [ 5:0] debug_st_shift_scnt = st_shift_scnt ;
 wire debug_st_shift_en = st_shift_en ;
 wire [31:0] sq_rx_start ;
 wire [31:0] sq_rx_end ;
 wire [31:0] sq_rx_valid ;
 wire [63:0] sq_rx_data ;
 wire [ 2:0] sq_rx_empty ;
 wire [ 2:0] sq_rx_empty_01 ;
 wire [ 2:0] sq_rx_empty_02 ;
 wire [ 2:0] sq_rx_empty_03 ;
 wire [ 2:0] sq_rx_empty_04 ;
 wire [ 2:0] sq_rx_empty_05 ;
 wire [ 2:0] sq_rx_empty_06 ;
 wire [ 2:0] sq_rx_empty_07 ;
 wire [ 2:0] sq_rx_empty_08 ;
 wire [ 2:0] sq_rx_empty_09 ;
 wire [ 2:0] sq_rx_empty_10 ;
 wire [ 2:0] sq_rx_empty_11 ;
 wire [ 2:0] sq_rx_empty_12 ;
 wire [ 2:0] sq_rx_empty_13 ;
 wire [ 2:0] sq_rx_empty_14 ;
 wire [ 2:0] sq_rx_empty_15 ;
 wire [ 2:0] sq_rx_empty_16 ;
 wire [ 2:0] sq_rx_empty_17 ;
 wire [ 2:0] sq_rx_empty_18 ;
 wire [ 2:0] sq_rx_empty_19 ;
 wire [ 2:0] sq_rx_empty_20 ;
 wire [ 2:0] sq_rx_empty_21 ;
 wire [ 2:0] sq_rx_empty_22 ;
 wire [ 2:0] sq_rx_empty_23 ;
 wire [ 2:0] sq_rx_empty_24 ;
 wire [ 2:0] sq_rx_empty_25 ;
 wire [ 2:0] sq_rx_empty_26 ;
 wire [ 2:0] sq_rx_empty_27 ;
 wire [ 2:0] sq_rx_empty_28 ;
 wire [ 2:0] sq_rx_empty_29 ;
 wire [ 2:0] sq_rx_empty_30 ;
 wire [ 2:0] sq_rx_empty_31 ;
 wire [191:0] st_shift_reg ;
 wire [ 5:0] st_shift_ccnt ;
 wire [ 5:0] debug_st_shift_ccnt = st_shift_ccnt ;
 reg [31:0] current_sqid_reg ;
 reg [31:0] current_sqid_reg_max ;
 reg current_sqid_reg_rst ;
 reg current_sqid_reg_vld ;
 reg [31:0] params_current_sqid_reg_ro ;
 reg params_current_sqid_reg_ro_vld ;
 reg current_sqid_reg_match_flag ;
 reg current_sqid_reg_match_flag1 ;
 reg current_sqid_reg_match_flag2 ;
 reg current_sqid_reg_match_flag3 ;
 reg current_sqid_reg_match_flag4 ;
 reg current_sqid_reg_flag ;
 reg [31:0] current_sqid_reg_match_00 ;
 reg [31:0] current_sqid_reg_match_01 ;
 reg [31:0] current_sqid_reg_match_02 ;
 reg [31:0] current_sqid_reg_match_03 ;
 reg [31:0] current_sqid_reg_match_04 ;
 reg [31:0] current_sqid_reg_match_05 ;
 reg [31:0] current_sqid_reg_match_06 ;
 reg [31:0] current_sqid_reg_match_07 ;
 reg [31:0] current_sqid_reg_match_08 ;
 reg [31:0] current_sqid_reg_match_09 ;
 reg [31:0] current_sqid_reg_match_0a ;
 reg [31:0] current_sqid_reg_match_0b ;
 reg [31:0] current_sqid_reg_match_0c ;
 reg [31:0] current_sqid_reg_match_0d ;
 reg [31:0] current_sqid_reg_match_0e ;
 reg [31:0] current_sqid_reg_match_0f ;
 reg [31:0] current_sqid_reg_match_10 ;
 reg [31:0] current_sqid_reg_match_11 ;
 reg [31:0] current_sqid_reg_match_12 ;
 reg [31:0] current_sqid_reg_match_13 ;
 reg [31:0] current_sqid_reg_match_14 ;
 reg [31:0] current_sqid_reg_match_15 ;
 reg [31:0] current_sqid_reg_match_16 ;
 reg [31:0] current_sqid_reg_match_17 ;
 reg [31:0] current_sqid_reg_match_18 ;
 reg [31:0] current_sqid_reg_match_19 ;
 reg [31:0] current_sqid_reg_match_1a ;
 reg [31:0] current_sqid_reg_match_1b ;
 reg [31:0] current_sqid_reg_match_1c ;
 reg [31:0] current_sqid_reg_match_1d ;
 reg [31:0] current_sqid_reg_match_1e ;
 reg [31:0] current_sqid_reg_match_1f ;
 wire [15:0] sync_fisrt_byte = st_shift_reg[127+64:112+64];
 wire [15:0] sync_len_byte = st_shift_reg[111+64: 96+64];
 wire [31:0] sync_four_byte = st_shift_reg[ 95+64: 64+64];
 wire [15:0] frame_type_byte = st_shift_reg[127+64:112+64];
 wire [31:0] frame_sync_byte = st_shift_reg[111+64: 80+64];
 wire [31:0] current_id_wire = st_shift_reg[127+64:96+64] ;
 wire [15:0] patition_cnt_wire = st_shift_reg[ 95+64:80+64] ;
 wire [15:0] patition_len_wire = st_shift_reg[ 79+64:64+64] ;
 wire [15:0] segm_type_wire = st_shift_reg[127+64:112+64];
 wire [15:0] segm_len_wire = st_shift_reg[111+64: 96+64];
 wire [15:0] segm_min_len = 16'd81 ;
 reg [31:0] current_cut_done_sqid_reg ;
 reg [15:0] st_rx_cnt_reg ;
 reg sq_frame_flag ;
 reg [15:0] sync_len_byte_reg ;
 reg [15:0] sync_len_rest_reg ;
 wire [11:0] discard_calc_cnt0 ;
 wire [ 3:0] discard_calc_cnt1 ;
 reg [11:0] discard_data_cnt ;
 assign discard_calc_cnt0 = sync_len_rest_reg[15:4] ;
 assign discard_calc_cnt1 = sync_len_rest_reg[ 3:0] ;
 wire [3:0] debug_discard_calc_cnt1 = sync_len_rest_reg[ 3:0] ;
 reg [15:0] patition_cnt_reg ;
 reg [15:0] patition_len_reg ;
 reg [15:0] patition_cnt ;
 reg [15:0] segm_len ;
 reg [15:0] segm_type ;
 wire [11:0] segm_cnt0_wire ;
 wire [ 3:0] segm_cnt1_wire ;
 assign segm_cnt0_wire = segm_len[15:4] ;
 assign segm_cnt1_wire = segm_len[ 3:0] ;
 reg [11:0] segm_cnt ;
 reg [15:0] st_rx_cut_cnt ;
 wire st_rx_data_en = st_rx_valid && st_rx_ready ;
 reg sq_cut_on ;
 assign st_rx_ready = 1'b1 ;
 reg type_03e9_flag ;
 reg type_1389_flag ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 type_03e9_flag <= 1'd0 ;
 type_1389_flag <= 1'd0 ;
 end
 else begin
 type_03e9_flag <= (params_frame_type_byte==params_03e9_type)|| (params_frame_type_byte==params_07d0_type);
 type_1389_flag <= (params_frame_type_byte==params_1389_type);
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_on <= 5'd0 ;
 end
 else begin
 sq_cut_on <= (&sq_cut_on_reg) ;
 end
 end
 reg [ 4:0] fir_rx_cstate ;
 reg [ 4:0] fir_rx_nstate ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 fir_rx_cstate <= 5'd0 ;
 end
 else if ( (st_rx_start_pre&&~fir_r_idle_st)||params_filter_rst ) begin
 fir_rx_cstate <= 5'd0 ;
 end
 else begin
 fir_rx_cstate <= fir_rx_nstate ;
 end
 end
 wire fir_r_idle_st = ( fir_rx_cstate== FIR_R_IDLE_STATE );
 wire fir_r_vsync_st = ( fir_rx_cstate== FIR_R_VSYNC_STATE );
 wire fir_r_check_st = ( fir_rx_cstate== FIR_R_CHECK_STATE );
 wire fir_r_id_st = ( fir_rx_cstate== FIR_R_ID_STATE );
 wire fir_r_header_st = ( fir_rx_cstate== FIR_R_HEADER_STATE );
 wire fir_r_rdata0_st = ( fir_rx_cstate== FIR_R_RDATA0_STATE );
 wire fir_r_rend_st = ( fir_rx_cstate== FIR_R_REND_STATE );
 wire fir_r_rjudge_st = ( fir_rx_cstate== FIR_R_RJUDGE_STATE );
 wire fir_r_discard_st = ( fir_rx_cstate== FIR_R_DISCARD_STATE );
 wire fir_r_disend_st = ( fir_rx_cstate== FIR_R_DISEND_STATE );
 wire fir_r_sqcut_st = ( fir_rx_cstate== FIR_RSQ_SEGMT_STATE );
 wire fir_r_sqcut_end_st = ( fir_rx_cstate== FIR_RSQ_SEGMT_END_STATE );
 wire fir_r_sqcuth_st = ( fir_rx_cstate== FIR_RSQ_SEGMT_H_STATE );
 wire fir_r_sqrcut_st = ( fir_rx_cstate== FIR_R_SQRCUT_STATE );
 wire fir_r_sqrcut_end_st = ( fir_rx_cstate== FIR_R_SQRCUT_END_STATE );
 wire fir_r_error_st = ( fir_rx_cstate== FIR_R_ERROR_STATE ) ;
 always@ ( * ) begin
 fir_rx_nstate = fir_rx_cstate;
 case(fir_rx_cstate) FIR_R_IDLE_STATE : begin
 if (st_rx_start&&~tcp_sqmatch_flag&&st_rx_data_en) begin
 fir_rx_nstate = FIR_R_CHECK_STATE ;
 end
 else if (st_rx_start&&tcp_sqmatch_flag) begin
 fir_rx_nstate = ( sub_sqcut_len_reg>16'd8 ) ? FIR_R_SQRCUT_STATE : FIR_R_SQRCUT_END_STATE ;
 end
 end
 FIR_R_SQRCUT_STATE : begin
 if ( (st_shift_ccnt>=6'd8) && (sub_sqcut_len_reg<=16'd16) ) begin
 fir_rx_nstate = FIR_R_SQRCUT_END_STATE ;
 end
 end
 FIR_R_SQRCUT_END_STATE : begin
 if ( st_shift_ccnt>=sub_sqcut_len_reg[5:0]) begin
 fir_rx_nstate = ( st_rx_cnt_reg>(sub_sqcut_len_reg[5:0]+6'd8) ) ? FIR_R_VSYNC_STATE : FIR_R_RJUDGE_STATE ;
 end
 end
 FIR_R_VSYNC_STATE : begin
 if (st_shift_ccnt>=6'd8) begin
 if ( (st_rx_cnt_reg<(sync_len_byte+16'd4)) && (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 if ( sq_frame_flag&&~sq_cut_on ) begin
 fir_rx_nstate = current_sqid_reg_flag ? (st_rx_cnt_reg<= (16'd8+16'd8) ) ? FIR_RSQ_SEGMT_END_STATE : FIR_RSQ_SEGMT_STATE : FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 else if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)) begin
 fir_rx_nstate = FIR_R_CHECK_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_ERROR_STATE ;
 end
 end
 end
 FIR_R_CHECK_STATE : begin
 if (st_shift_ccnt>=6'd6 ) begin
 if ( ( ((frame_type_byte==params_1389_type)&&type_1389_flag) || ( type_03e9_flag&&((frame_type_byte==params_03e9_type)||(frame_type_byte==params_07d0_type)) ) ) && (frame_sync_byte==32'h0000_5902) ) begin
 fir_rx_nstate = FIR_R_ID_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_ERROR_STATE ;
 end
 end
 end
 FIR_R_ID_STATE : begin
 if ( st_shift_ccnt>=6'd12 ) begin
 if ( (patition_cnt_wire<=16'h0001) || ~frame_type_rdy ) begin
 fir_rx_nstate = FIR_R_DISCARD_STATE ;
 end
 else if ( current_id_wire<=current_sqid_reg ) begin
 fir_rx_nstate = FIR_R_DISCARD_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_HEADER_STATE ;
 end
 end
 end
 FIR_R_DISCARD_STATE : begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
 if ( discard_calc_cnt1==4'd0 ) begin
 if (st_rx_cnt_reg==6'd16 ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else if (st_rx_cnt_reg<=(16'd16+16'd8)) begin
 fir_rx_nstate = ( (current_sqid_reg_flag&&sq_frame_flag) ) ? FIR_R_RJUDGE_STATE : FIR_R_IDLE_STATE ;
 end
 else if ( st_rx_cnt_reg<(16'd16+ segm_min_len ) ) begin
 fir_rx_nstate = ( (current_sqid_reg_flag&&sq_frame_flag) ) ? FIR_R_VSYNC_STATE : FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_VSYNC_STATE ;
 end
 end
 else begin
 fir_rx_nstate = FIR_R_DISEND_STATE ;
 end
 end
 end
 FIR_R_DISEND_STATE: begin
 if ( st_shift_ccnt>=discard_calc_cnt1 ) begin
 if (st_rx_cnt_reg==discard_calc_cnt1) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else if (st_rx_cnt_reg<=(discard_calc_cnt1+16'd8)) begin
 fir_rx_nstate = ( (current_sqid_reg_flag&&sq_frame_flag) ) ? FIR_R_RJUDGE_STATE : FIR_R_IDLE_STATE ;
 end
 else if ( st_rx_cnt_reg<( discard_calc_cnt1 + segm_min_len )) begin
 fir_rx_nstate = ( (current_sqid_reg_flag&&sq_frame_flag) ) ? FIR_R_VSYNC_STATE : FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_VSYNC_STATE ;
 end
 end
 end
 FIR_R_HEADER_STATE : begin
 if ( st_shift_ccnt>=6'd4 )begin
 fir_rx_nstate = FIR_R_RDATA0_STATE ;
 end
 end
 FIR_R_RDATA0_STATE : begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) )begin
 if (segm_cnt1_wire==4'd0) begin
 if (patition_cnt>=patition_cnt_reg) begin
 if (st_rx_cnt_reg>( 16'd16 + 16'd8 ) ) fir_rx_nstate = FIR_R_VSYNC_STATE ;
 else fir_rx_nstate = FIR_R_RJUDGE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_HEADER_STATE ;
 end
 end
 else begin
 fir_rx_nstate = FIR_R_REND_STATE ;
 end
 end
 end
 FIR_R_REND_STATE : begin
 if ( st_shift_ccnt>=segm_cnt1_wire)begin
 if (patition_cnt>=patition_cnt_reg) begin
 if (st_rx_cnt_reg>( segm_cnt1_wire + 16'd8 ) ) fir_rx_nstate = FIR_R_VSYNC_STATE ;
 else fir_rx_nstate = FIR_R_RJUDGE_STATE ;
 end
 else begin
 fir_rx_nstate = FIR_R_HEADER_STATE ;
 end
 end
 end
 FIR_R_RJUDGE_STATE : begin
 if ( (st_rx_cnt_reg==16'd0) || (sq_cut_on&&sq_frame_flag) ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 else begin
 fir_rx_nstate = sq_frame_flag ? FIR_RSQ_SEGMT_H_STATE : FIR_R_IDLE_STATE ;
 end
 end
 FIR_RSQ_SEGMT_H_STATE : begin
 if ( st_shift_ccnt>=st_rx_cnt_reg ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 FIR_RSQ_SEGMT_STATE : begin
 if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
 fir_rx_nstate = FIR_RSQ_SEGMT_END_STATE ;
 end
 end
 FIR_RSQ_SEGMT_END_STATE : begin
 if ( st_shift_ccnt>=st_rx_cnt_reg ) begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 end
 FIR_R_ERROR_STATE : begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 default : begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 endcase end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_frame_flag <= 1'd0 ;
 frame_type_rdy <= 1'd0 ;
 end
 else if (st_rx_start) begin
 sq_frame_flag <= tcp_sqmatch_flag ;
 frame_type_rdy <= tcp_sqmatch_flag ;
 end
 else if ( fir_r_check_st ) begin
 sq_frame_flag <= ( ((frame_type_byte==params_1389_type)&&type_1389_flag) || ( type_03e9_flag&&((frame_type_byte==params_03e9_type)||(frame_type_byte==params_07d0_type)) ) ) ;
 frame_type_rdy <= (frame_type_byte==params_frame_type_byte) ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sync_len_byte_reg <= 16'd0 ;
 end
 else if ( ( fir_r_vsync_st ) && (st_shift_ccnt>=6'd8) ) begin
 sync_len_byte_reg <= sync_len_byte ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sync_len_rest_reg <= 16'd0 ;
 end
 else if (st_rx_start&&~tcp_sqmatch_flag) begin
 sync_len_rest_reg <= first_sync_len_byte - 16'd22 ;
 end
 else if ( ( fir_r_vsync_st ) && (st_shift_ccnt>=6'd8) ) begin
 sync_len_rest_reg <= sync_len_byte - 16'd22 ;
 end
 end
 reg first_sync_len_error ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 first_sync_len_error <= 1'd0 ;
 end
 else if (st_rx_start&&~tcp_sqmatch_flag) begin
 if (first_sync_len_byte==16'd0) begin
 first_sync_len_error <= 1'd1 ;
 /* synthesis translate_off */ $display("%m first_sync_len_byte = %d Error !!!!! \n ", first_sync_len_byte );
 /* synthesis translate_on */ end
 else begin
 first_sync_len_error <= 1'd0 ;
 end
 end
 else begin
 first_sync_len_error <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rx_cnt_reg <= 16'd0 ;
 end
 else if ( st_rx_start && ~tcp_sqmatch_flag ) begin
 st_rx_cnt_reg <= (st_rx_cnt<=16'd8) ? (tcp_payload_len - st_rx_offset ) : (tcp_payload_len - st_rx_cnt - st_rx_offset + 16'd8 ) ;
 end
 else if ( st_rx_start && tcp_sqmatch_flag ) begin
 st_rx_cnt_reg <= (tcp_payload_len ) ;
 end
 else if ( fir_r_discard_st && (st_shift_ccnt>=16'd16) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd16 ;
 end
 else if ( fir_r_disend_st && ( st_shift_ccnt>=discard_calc_cnt1 ) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - discard_calc_cnt1 ;
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=16'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if (fir_r_check_st && (st_shift_ccnt>=16'd6) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd6 ;
 end
 else if (fir_r_id_st && (st_shift_ccnt>=16'd12) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd12 ;
 end
 else if (fir_r_header_st && (st_shift_ccnt>=16'd4) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd4 ;
 end
 else if ( fir_r_rdata0_st && (st_shift_ccnt>=6'd16) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd16 ;
 end
 else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - segm_cnt1_wire ;
 end
 else if ( fir_r_sqcut_st && (st_shift_ccnt>=6'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if ( fir_r_sqcut_end_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - st_rx_cnt_reg ;
 end
 else if ( (fir_r_sqcuth_st ) && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - st_rx_cnt_reg ;
 end
 else if ((fir_r_sqrcut_st) && (st_shift_ccnt>=16'd8) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - 16'd8 ;
 end
 else if ((fir_r_sqrcut_end_st) && (st_shift_ccnt>=sub_sqcut_len_reg) ) begin
 st_rx_cnt_reg <= st_rx_cnt_reg - sub_sqcut_len_reg ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 discard_data_cnt <= 12'd0 ;
 end
 else if ( fir_r_discard_st||fir_r_rdata0_st ) begin
 discard_data_cnt <= (st_shift_ccnt>=6'd16) ? discard_data_cnt + 1'd1 : discard_data_cnt ;
 end
 else begin
 discard_data_cnt <= 12'd0 ;
 end
 end
 reg segm_type_2439 ;
 reg segm_type_2433 ;
 reg segm_type_2434 ;
 reg segm_type_2433_flag ;
 reg segm_type_2434_flag ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 segm_len <= 16'd0 ;
 segm_type <= 16'd0 ;
 segm_type_2439 <= 1'd0 ;
 segm_type_2433 <= 1'd0 ;
 segm_type_2434 <= 1'd0 ;
 end
 else if ( fir_r_header_st && (st_shift_ccnt>=6'd4) ) begin
 segm_len <= segm_len_wire ;
 segm_type <= segm_type_wire ;
 segm_type_2439 <= (segm_type_wire==16'h2439) ;
 segm_type_2433 <= (segm_type_wire==16'h2433) ;
 segm_type_2434 <= (segm_type_wire==16'h2434) ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 segm_type_2433_flag <= 1'd0 ;
 segm_type_2434_flag <= 1'd0 ;
 end
 else if (fir_r_id_st) begin
 segm_type_2433_flag <= 1'd0 ;
 segm_type_2434_flag <= 1'd0 ;
 end
 else if ( fir_r_header_st && (st_shift_ccnt>=6'd4) ) begin
 segm_type_2433_flag <= (segm_type_wire==16'h2433) ? 1'd1 : segm_type_2433_flag ;
 segm_type_2434_flag <= (segm_type_wire==16'h2434) ? 1'd1 : segm_type_2434_flag ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 patition_cnt_reg <= 16'd0 ;
 patition_len_reg <= 16'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) ) begin
 patition_cnt_reg <= patition_cnt_wire ;
 patition_len_reg <= patition_len_wire ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 patition_cnt <= 16'd0 ;
 end
 else if (fir_r_id_st) begin
 patition_cnt <= 16'd0 ;
 end
 else if ( fir_r_header_st && (st_shift_ccnt>=6'd4 ) ) begin
 patition_cnt <= patition_cnt + 1'd1 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 else if (st_rx_start&&~tcp_sqmatch_flag && st_rx_data_en) begin
 st_shift_scnt <= (st_rx_offset<=3'd2) ? 6'd6 : 6'd0 ;
 st_shift_en <= (st_rx_offset<=3'd2) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_start&&tcp_sqmatch_flag && st_rx_data_en) begin
 st_shift_scnt <= (sub_sqcut_len_reg>16'd8) ? ( (st_rx_offset==3'd0) ? 6'd8 : 6'd0 ) : ((sub_sqcut_len_reg[3:0]+st_rx_offset)>4'd8) ? 6'd0 : sub_sqcut_len_reg[3:0] ;
 st_shift_en <= (sub_sqcut_len_reg>16'd8) ? ( (st_rx_offset==3'd0) ? 1'd1 : 1'd0 ) : ((sub_sqcut_len_reg[3:0]+st_rx_offset)>4'd8) ? 1'd0 : 1'd1 ;
 end
 else if (fir_r_sqrcut_st) begin
 if ( (st_shift_ccnt>=6'd8) && (sub_sqcut_len_reg<=16'd16) ) begin
 st_shift_scnt <= (st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]))) ? sub_sqcut_len_reg[5:0] - 6'd8 : 6'd0 ;
 st_shift_en <= (st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]))) ? 1'd1 : 1'd0;
 end
 else if (st_rx_data_en ) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_sqrcut_end_st && ( st_shift_ccnt>=sub_sqcut_len_reg[5:0] ) ) begin
 st_shift_scnt <= ((st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8)))&&(st_rx_cnt_reg>(sub_sqcut_len_reg[5:0]+6'd8))) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_rx_data_en || (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8)))&&(st_rx_cnt_reg>(sub_sqcut_len_reg[5:0]+6'd8))) ? 1'd1 : 1'd0 ;
 end
 else if (fir_r_sqrcut_end_st && st_rx_data_en ) begin
 st_shift_scnt <= sub_sqcut_len_reg[5:0] ;
 st_shift_en <= 1'd1 ;
 end
 else if (fir_r_vsync_st ) begin
 if (st_shift_ccnt>=6'd8) begin
 if ( st_rx_cnt_reg<(sync_len_byte+16'd4 ) ) begin
 if ( (sq_frame_flag&&current_sqid_reg_flag&&~sq_cut_on ) &&(st_rx_cnt_reg<=(16'd8+16'd8) )) begin
 st_shift_scnt <= ((st_shift_ccnt>=st_rx_cnt_reg[5:0])||st_rx_data_en) ? (st_rx_cnt_reg[5:0]-6'd8) : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=st_rx_cnt_reg[5:0])||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 end
 else if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd14)||st_rx_data_en) ? 6'd6 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd14)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (st_rx_data_en) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_check_st) begin
 if (st_shift_ccnt>=6'd6 ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&(st_shift_ccnt>=6'd10))) ? 6'd12 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&(st_shift_ccnt>=6'd10))) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en) begin
 st_shift_scnt <= 6'd6 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_id_st) begin
 if ( st_shift_ccnt>=6'd12 ) begin
 if ( (current_id_wire<=current_sqid_reg) || (patition_cnt_wire<=16'h0001) || ~frame_type_rdy ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ? 6'd16 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 6'd4 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 end
 else if (st_rx_data_en&&(st_shift_ccnt>=6'd4)) begin
 st_shift_scnt <= 6'd12 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if ( fir_r_discard_st ) begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
 if ( discard_calc_cnt1==4'd0 ) begin
 if (st_rx_cnt_reg<=(16'd16+16'd8)) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd24)|| st_rx_data_en ) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd24)|| st_rx_data_en ) ? 1'd1 : 1'd0 ;
 end
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ? discard_calc_cnt1 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ? 1'd1 : 1'd0 ;
 end
 end
 else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
 st_shift_scnt <= st_shift_en ? 6'd0 : 6'd16 ;
 st_shift_en <= st_shift_en ? 1'd0 : 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_disend_st) begin
 if ( st_shift_ccnt>=discard_calc_cnt1 ) begin
 if (st_rx_cnt_reg<=( discard_calc_cnt1 +16'd8)) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))|| st_rx_data_en ) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))|| st_rx_data_en ) ? 1'd1 : 1'd0 ;
 end
 end
 else if (st_rx_data_en && ( (st_shift_ccnt+6'd8)>= discard_calc_cnt1 ) ) begin
 st_shift_scnt <= discard_calc_cnt1 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_header_st) begin
 if ( st_shift_ccnt>=6'd4 )begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&&(st_shift_ccnt>=6'd12))) ? 6'd16 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&&(st_shift_ccnt>=6'd12))) ? 1'd1 : 1'd0 ;
 end
 else if ( st_rx_data_en ) begin
 st_shift_scnt <= 6'd4 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_rdata0_st) begin
 if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) )begin
 if (segm_cnt1_wire==4'd0) begin
 if (patition_cnt<patition_cnt_reg) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd20)||st_rx_data_en) ? 6'd4 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd20)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else if ( st_rx_cnt_reg>( 16'd16 + 16'd8 ) ) begin
 st_shift_scnt <= ((st_shift_ccnt>=6'd24)||st_rx_data_en) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=6'd24)||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else begin
 if (st_shift_ccnt>=(6'd16+segm_cnt1_wire)) begin
 st_shift_scnt <= segm_cnt1_wire ;
 st_shift_en <= 1'd1 ;
 end
 else if (st_rx_data_en && ((st_shift_ccnt-6'd8 )>= segm_cnt1_wire) ) begin
 st_shift_scnt <= segm_cnt1_wire ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 end
 else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
 st_shift_scnt <= st_shift_en ? 6'd0 : 6'd16 ;
 st_shift_en <= st_shift_en ? 1'd0 : 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if ( fir_r_rend_st ) begin
 if ( st_shift_ccnt>=segm_cnt1_wire)begin
 if (patition_cnt>=patition_cnt_reg) begin
 if ( st_rx_cnt_reg>( segm_cnt1_wire + 16'd8 ) ) begin
 st_shift_scnt <= ((st_shift_ccnt>=(segm_cnt1_wire+16'd8) )||st_rx_data_en) ? 6'd8 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(segm_cnt1_wire+16'd8) )||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else begin
 st_shift_scnt <= ((st_shift_ccnt>=(6'd4+segm_cnt1_wire))||st_rx_data_en) ? 6'd4 : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(6'd4+segm_cnt1_wire))||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 end
 else if ( st_rx_data_en&& ( (st_shift_ccnt+6'd8) >= segm_cnt1_wire ) ) begin
 st_shift_scnt <= segm_cnt1_wire ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else if (fir_r_rjudge_st) begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 else if ( fir_r_sqcut_st ) begin
 if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
 st_shift_scnt <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ? (st_rx_cnt_reg[5:0]-6'd8) : 6'd0 ;
 st_shift_en <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ? 1'd1 : 1'd0 ;
 end
 else if (st_rx_data_en) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else if ((st_shift_ccnt>=6'd16)&&st_shift_en) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 else begin
 st_shift_scnt <= 6'd0 ;
 st_shift_en <= 1'd0 ;
 end
 end
 wire [ 23: 0] market_explain ;
 wire [ 7: 0] info_classify ;
 reg [ 31: 0] dialog_num ;
 wire [ 7: 0] contract_flag ;
 wire [ 31: 0] contract_num ;
 reg [175: 0] contract_code ;
 reg [ 71: 0] update_time ;
 reg [ 31: 0] update_ms ;
 reg [ 63: 0] new_price ;
 reg [ 31: 0] turnover ;
 reg [ 63: 0] volume ;
 reg [ 63: 0] position ;
 reg [ 63: 0] purchase_price ;
 reg [ 31: 0] buy_quantity ;
 reg [ 63: 0] sell_price ;
 reg [ 31: 0] sell_quantity ;
 reg market_rdy ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 dialog_num <= 32'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) ) begin
 dialog_num <= {current_id_wire[7:0],current_id_wire[15:8],current_id_wire[23:16],current_id_wire[31:24]} ;
 end
 end
 wire [127: 0] contract_code0 = st_shift_reg[127+64: 64] ;
 wire [ 47: 0] contract_code1 = st_shift_reg[127+64:80+64] ;
 wire [ 71: 0] contract_code2 = st_shift_reg[ 79+64: 8+64] ;
 wire [ 7: 0] update_time_wire1 = st_shift_reg[ 7+64: 64] ;
 wire [ 63: 0] update_time_wire2 = st_shift_reg[127+64:64+64] ;
 wire [ 31: 0] update_ms_wire = st_shift_reg[ 63+64:32+64] ;
 wire [ 63: 0] new_price_wire = st_shift_reg[127+64: 64+64] ;
 wire [ 31: 0] turnover_wire = st_shift_reg[ 63+64: 32+64] ;
 wire [ 31: 0] volume0 = st_shift_reg[ 31+64: 64] ;
 wire [ 31: 0] volume1 = st_shift_reg[127+64: 96+64] ;
 wire [ 63: 0] position_wire = st_shift_reg[ 95+64: 32+64] ;
 wire [ 63: 0] purchase_price_wire = st_shift_reg[127+64: 64+64] ;
 wire [ 31: 0] buy_quantity_wire = st_shift_reg[ 63+64: 32+64] ;
 wire [ 31: 0] sell_price0 = st_shift_reg[ 31+64: 64] ;
 wire [ 31: 0] sell_price1 = st_shift_reg[127+64: 96+64] ;
 wire [ 31: 0] sell_quantity_wire = st_shift_reg[ 95+64: 64+64] ;
 assign market_explain = {8'h53,8'h51,8'h00} ;
 assign info_classify = 8'h31 ;
 assign contract_flag = 8'h30 ;
 assign contract_num = 32'd0 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 contract_code <= 176'd0 ;
 end
 else if (fir_r_id_st) begin
 contract_code <= 176'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==12'd0) ) begin
 contract_code[175:48] <= contract_code0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==12'd1) ) begin
 contract_code[47: 0] <= contract_code1 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 update_time <= 72'd0 ;
 end
 else if (fir_r_id_st) begin
 update_time <= 72'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==12'd1) ) begin
 update_time[71:64] <= update_time_wire1 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==12'd2) ) begin
 update_time[63: 0] <= update_time_wire2 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 update_ms <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 update_ms <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2439) && (discard_data_cnt==12'd2) ) begin
 update_ms[31: 0] <= {update_ms_wire[7:0],update_ms_wire[15:8],update_ms_wire[23:16],update_ms_wire[31:24]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 new_price <= 64'd0 ;
 end
 else if (fir_r_id_st || (&new_price[63:0]) ) begin
 new_price <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2433) && (discard_data_cnt==12'd0) ) begin
 new_price[63: 0] <= {new_price_wire[7:0],new_price_wire[15:8],new_price_wire[23:16],new_price_wire[31:24],new_price_wire[39:32],new_price_wire[47:40],new_price_wire[55:48],new_price_wire[63:56]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 turnover <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 turnover <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2433) && (discard_data_cnt==12'd0) ) begin
 turnover[31: 0] <= { turnover_wire[7:0],turnover_wire[15:8],turnover_wire[23:16],turnover_wire[31:24] } ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 volume <= 64'd0 ;
 end
 else if (fir_r_id_st || (&volume[63:0]) ) begin
 volume <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2433) && (discard_data_cnt==12'd0) ) begin
 volume[31: 0] <= { volume0[7:0],volume0[15:8],volume0[23:16],volume0[31:24] } ;
 end
 else if ( fir_r_rend_st && (segm_type_2433) ) begin
 volume[63: 32] <= { volume1[7:0],volume1[15:8],volume1[23:16],volume1[31:24] } ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 position <= 64'd0 ;
 end
 else if (fir_r_id_st || (&position[63:0]) ) begin
 position <= 'd0 ;
 end
 else if ( fir_r_rend_st && (segm_type_2433) ) begin
 position[63: 0] <= {position_wire[7:0],position_wire[15:8],position_wire[23:16],position_wire[31:24],position_wire[39:32],position_wire[47:40],position_wire[55:48],position_wire[63:56]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 purchase_price <= 64'd0 ;
 end
 else if (fir_r_id_st || (&purchase_price[63:0]) ) begin
 purchase_price <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2434) && (discard_data_cnt==12'd0) ) begin
 purchase_price[63: 0] <= {purchase_price_wire[7:0],purchase_price_wire[15:8],purchase_price_wire[23:16],purchase_price_wire[31:24],purchase_price_wire[39:32],purchase_price_wire[47:40],purchase_price_wire[55:48],purchase_price_wire[63:56]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 buy_quantity <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 buy_quantity <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2434) && (discard_data_cnt==12'd0) ) begin
 buy_quantity[31: 0] <= {buy_quantity_wire[7:0],buy_quantity_wire[15:8],buy_quantity_wire[23:16],buy_quantity_wire[31:24]} ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sell_price <= 64'd0 ;
 end
 else if (fir_r_id_st ) begin
 sell_price <= 'd0 ;
 end
 else if ( fir_r_rdata0_st && (segm_type_2434) && (discard_data_cnt==12'd0) ) begin
 sell_price[31: 0] <= {sell_price0[7:0],sell_price0[15:8],sell_price0[23:16],sell_price0[31:24] } ;
 end
 else if ( fir_r_rend_st && (segm_type_2434) ) begin
 sell_price[63: 0] <= ((&sell_price[31: 0])&&(&sell_price1[31:0])) ? 64'd0 : { {sell_price1[7:0],sell_price1[15:8],sell_price1[23:16],sell_price1[31:24] } , sell_price[31:0] } ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sell_quantity <= 32'd0 ;
 end
 else if (fir_r_id_st) begin
 sell_quantity <= 'd0 ;
 end
 else if ( fir_r_rend_st && (segm_type_2434) ) begin
 sell_quantity[31: 0] <= {sell_quantity_wire[7:0],sell_quantity_wire[15:8],sell_quantity_wire[23:16],sell_quantity_wire[31:24]} ;
 end
 end
 reg current_sqcut_done_dly ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_cut_done_sqid_reg <= 32'd0 ;
 current_sqcut_done_dly <= 1'd0 ;
 end
 else begin
 case (sq_market_rdy) 32'h0000_0001: current_cut_done_sqid_reg <= (current_cut_done_sq00id_reg) ;
 32'h0000_0002: current_cut_done_sqid_reg <= (current_cut_done_sq01id_reg) ;
 32'h0000_0004: current_cut_done_sqid_reg <= (current_cut_done_sq02id_reg) ;
 32'h0000_0008: current_cut_done_sqid_reg <= (current_cut_done_sq03id_reg) ;
 32'h0000_0010: current_cut_done_sqid_reg <= (current_cut_done_sq04id_reg) ;
 32'h0000_0020: current_cut_done_sqid_reg <= (current_cut_done_sq05id_reg) ;
 32'h0000_0040: current_cut_done_sqid_reg <= (current_cut_done_sq06id_reg) ;
 32'h0000_0080: current_cut_done_sqid_reg <= (current_cut_done_sq07id_reg) ;
 32'h0000_0100: current_cut_done_sqid_reg <= (current_cut_done_sq08id_reg) ;
 32'h0000_0200: current_cut_done_sqid_reg <= (current_cut_done_sq09id_reg) ;
 32'h0000_0400: current_cut_done_sqid_reg <= (current_cut_done_sq10id_reg) ;
 32'h0000_0800: current_cut_done_sqid_reg <= (current_cut_done_sq11id_reg) ;
 32'h0000_1000: current_cut_done_sqid_reg <= (current_cut_done_sq12id_reg) ;
 32'h0000_2000: current_cut_done_sqid_reg <= (current_cut_done_sq13id_reg) ;
 32'h0000_4000: current_cut_done_sqid_reg <= (current_cut_done_sq14id_reg) ;
 32'h0000_8000: current_cut_done_sqid_reg <= (current_cut_done_sq15id_reg) ;
 32'h0001_0000: current_cut_done_sqid_reg <= (current_cut_done_sq16id_reg) ;
 32'h0002_0000: current_cut_done_sqid_reg <= (current_cut_done_sq17id_reg) ;
 32'h0004_0000: current_cut_done_sqid_reg <= (current_cut_done_sq18id_reg) ;
 32'h0008_0000: current_cut_done_sqid_reg <= (current_cut_done_sq19id_reg) ;
 32'h0010_0000: current_cut_done_sqid_reg <= (current_cut_done_sq20id_reg) ;
 32'h0020_0000: current_cut_done_sqid_reg <= (current_cut_done_sq21id_reg) ;
 32'h0040_0000: current_cut_done_sqid_reg <= (current_cut_done_sq22id_reg) ;
 32'h0080_0000: current_cut_done_sqid_reg <= (current_cut_done_sq23id_reg) ;
 32'h0100_0000: current_cut_done_sqid_reg <= (current_cut_done_sq24id_reg) ;
 32'h0200_0000: current_cut_done_sqid_reg <= (current_cut_done_sq25id_reg) ;
 32'h0400_0000: current_cut_done_sqid_reg <= (current_cut_done_sq26id_reg) ;
 32'h0800_0000: current_cut_done_sqid_reg <= (current_cut_done_sq27id_reg) ;
 32'h1000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq28id_reg) ;
 32'h2000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq29id_reg) ;
 32'h4000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq30id_reg) ;
 32'h8000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq31id_reg) ;
 default : current_cut_done_sqid_reg <= current_cut_done_sqid_reg ;
 endcase current_sqcut_done_dly <= |sq_market_rdy ;
 end
 end
 reg current_cut_now_sqid_reg_vld_dly ;
 reg [31:0] current_cut_done_sqid_reg_dly ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_cut_done_sqid_reg_dly <= 32'd0 ;
 current_cut_now_sqid_reg_vld_dly <= 1'd0 ;
 end
 else begin
 case (current_cut_now_sqid_reg_vld) 32'h0000_0001: current_cut_done_sqid_reg_dly <= (current_cut_done_sq00id_reg) ;
 32'h0000_0002: current_cut_done_sqid_reg_dly <= (current_cut_done_sq01id_reg) ;
 32'h0000_0004: current_cut_done_sqid_reg_dly <= (current_cut_done_sq02id_reg) ;
 32'h0000_0008: current_cut_done_sqid_reg_dly <= (current_cut_done_sq03id_reg) ;
 32'h0000_0010: current_cut_done_sqid_reg_dly <= (current_cut_done_sq04id_reg) ;
 32'h0000_0020: current_cut_done_sqid_reg_dly <= (current_cut_done_sq05id_reg) ;
 32'h0000_0040: current_cut_done_sqid_reg_dly <= (current_cut_done_sq06id_reg) ;
 32'h0000_0080: current_cut_done_sqid_reg_dly <= (current_cut_done_sq07id_reg) ;
 32'h0000_0100: current_cut_done_sqid_reg_dly <= (current_cut_done_sq08id_reg) ;
 32'h0000_0200: current_cut_done_sqid_reg_dly <= (current_cut_done_sq09id_reg) ;
 32'h0000_0400: current_cut_done_sqid_reg_dly <= (current_cut_done_sq10id_reg) ;
 32'h0000_0800: current_cut_done_sqid_reg_dly <= (current_cut_done_sq11id_reg) ;
 32'h0000_1000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq12id_reg) ;
 32'h0000_2000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq13id_reg) ;
 32'h0000_4000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq14id_reg) ;
 32'h0000_8000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq15id_reg) ;
 32'h0001_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq16id_reg) ;
 32'h0002_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq17id_reg) ;
 32'h0004_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq18id_reg) ;
 32'h0008_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq19id_reg) ;
 32'h0010_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq20id_reg) ;
 32'h0020_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq21id_reg) ;
 32'h0040_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq22id_reg) ;
 32'h0080_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq23id_reg) ;
 32'h0100_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq24id_reg) ;
 32'h0200_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq25id_reg) ;
 32'h0400_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq26id_reg) ;
 32'h0800_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq27id_reg) ;
 32'h1000_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq28id_reg) ;
 32'h2000_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq29id_reg) ;
 32'h4000_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq30id_reg) ;
 32'h8000_0000: current_cut_done_sqid_reg_dly <= (current_cut_done_sq31id_reg) ;
 default : current_cut_done_sqid_reg_dly <= current_cut_done_sqid_reg_dly ;
 endcase current_cut_now_sqid_reg_vld_dly <= |current_cut_now_sqid_reg_vld ;
 end
 end
 reg current_sqid_error ;
 reg [3:0] current_sqid_reg_max_cnt ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg <= 32'd0 ;
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= 1'd0 ;
 end
 else if (params_filter_rst || current_sqid_reg_rst ) begin
 current_sqid_reg <= 32'd0 ;
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= 1'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) && frame_type_rdy && sq_frame_flag ) begin
 if ( current_id_wire<=current_sqid_reg ) begin
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= 1'd0 ;
 end
 else if (seq_err_flag) begin
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= 1'd0 ;
 end
 else if ( (current_id_wire<=(current_sqid_reg_max+1'd1) ) || (current_sqid_reg==32'd0) || (current_sqid_reg_max_cnt>=params_current_sqid_reg_cnt) ) begin
 current_sqid_reg <= current_id_wire ;
 current_sqid_reg_vld <= 1'd1 ;
 current_sqid_error <= 1'd0 ;
 end
 else begin
 current_sqid_reg <= current_sqid_reg ;
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= ((current_id_wire-current_sqid_reg)>=32'd128 ) ;
 end
 end
 else if (current_sqcut_done_dly && (current_sqid_reg<current_cut_done_sqid_reg) ) begin
 current_sqid_reg <= ((current_cut_done_sqid_reg-current_sqid_reg)>= 32'd8) ? current_sqid_reg : current_cut_done_sqid_reg ;
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= ((current_cut_done_sqid_reg-current_sqid_reg)>=32'd128 ) ;
 end
 else begin
 current_sqid_reg_vld <= 1'd0 ;
 current_sqid_error <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg_max <= 32'd0 ;
 current_sqid_reg_max_cnt <= 4'd0 ;
 end
 else if (params_filter_rst || current_sqid_reg_rst) begin
 current_sqid_reg_max <= 32'd0 ;
 current_sqid_reg_max_cnt <= 4'd0 ;
 end
 else if (current_cut_now_sqid_reg_vld_dly) begin
 if ((current_cut_done_sqid_reg_dly==(current_sqid_reg_max+1'd1)) || (current_sqid_reg_max_cnt>=params_current_sqid_reg_cnt) || (current_sqid_reg_max==32'd0) ) begin
 current_sqid_reg_max <= (current_cut_done_sqid_reg_dly) ;
 current_sqid_reg_max_cnt <= 4'd0 ;
 end
 else if (current_cut_done_sqid_reg_dly>(current_sqid_reg_max+1'd1)) begin
 current_sqid_reg_max_cnt <= current_sqid_reg_max_cnt + 1'd1 ;
 end
 else begin
 current_sqid_reg_max_cnt <= 4'd0 ;
 end
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) && frame_type_rdy && sq_frame_flag ) begin
 if ( (current_id_wire==(current_sqid_reg_max+1'd1)) || (current_sqid_reg_max_cnt>=params_current_sqid_reg_cnt) || (current_sqid_reg_max==32'd0) ) begin
 current_sqid_reg_max <= current_id_wire ;
 current_sqid_reg_max_cnt <= 4'd0 ;
 end
 else if (current_id_wire>(current_sqid_reg_max+1'd1)) begin
 current_sqid_reg_max_cnt <= current_sqid_reg_max_cnt + 1'd1 ;
 end
 else begin
 current_sqid_reg_max_cnt <= 4'd0 ;
 end
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 params_current_sqid_reg_ro <= 32'd0 ;
 params_current_sqid_reg_ro_vld <= 1'd0 ;
 end
 else if (params_filter_rst) begin
 params_current_sqid_reg_ro <= 32'd0 ;
 params_current_sqid_reg_ro_vld <= 1'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) && frame_type_rdy && sq_frame_flag ) begin
 params_current_sqid_reg_ro <= current_id_wire ;
 params_current_sqid_reg_ro_vld <= 1'd1 ;
 end
 else begin
 params_current_sqid_reg_ro_vld <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg_match_00 <= 32'hffff_ffff ;
 current_sqid_reg_match_01 <= 32'hffff_ffff ;
 current_sqid_reg_match_02 <= 32'hffff_ffff ;
 current_sqid_reg_match_03 <= 32'hffff_ffff ;
 current_sqid_reg_match_04 <= 32'hffff_ffff ;
 current_sqid_reg_match_05 <= 32'hffff_ffff ;
 current_sqid_reg_match_06 <= 32'hffff_ffff ;
 current_sqid_reg_match_07 <= 32'hffff_ffff ;
 current_sqid_reg_match_08 <= 32'hffff_ffff ;
 current_sqid_reg_match_09 <= 32'hffff_ffff ;
 current_sqid_reg_match_0a <= 32'hffff_ffff ;
 current_sqid_reg_match_0b <= 32'hffff_ffff ;
 current_sqid_reg_match_0c <= 32'hffff_ffff ;
 current_sqid_reg_match_0d <= 32'hffff_ffff ;
 current_sqid_reg_match_0e <= 32'hffff_ffff ;
 current_sqid_reg_match_0f <= 32'hffff_ffff ;
 current_sqid_reg_match_10 <= 32'hffff_ffff ;
 current_sqid_reg_match_11 <= 32'hffff_ffff ;
 current_sqid_reg_match_12 <= 32'hffff_ffff ;
 current_sqid_reg_match_13 <= 32'hffff_ffff ;
 current_sqid_reg_match_14 <= 32'hffff_ffff ;
 current_sqid_reg_match_15 <= 32'hffff_ffff ;
 current_sqid_reg_match_16 <= 32'hffff_ffff ;
 current_sqid_reg_match_17 <= 32'hffff_ffff ;
 current_sqid_reg_match_18 <= 32'hffff_ffff ;
 current_sqid_reg_match_19 <= 32'hffff_ffff ;
 current_sqid_reg_match_1a <= 32'hffff_ffff ;
 current_sqid_reg_match_1b <= 32'hffff_ffff ;
 current_sqid_reg_match_1c <= 32'hffff_ffff ;
 current_sqid_reg_match_1d <= 32'hffff_ffff ;
 current_sqid_reg_match_1e <= 32'hffff_ffff ;
 current_sqid_reg_match_1f <= 32'hffff_ffff ;
 end
 else if (params_filter_rst) begin
 current_sqid_reg_match_00 <= 32'hffff_ffff ;
 current_sqid_reg_match_01 <= 32'hffff_ffff ;
 current_sqid_reg_match_02 <= 32'hffff_ffff ;
 current_sqid_reg_match_03 <= 32'hffff_ffff ;
 current_sqid_reg_match_04 <= 32'hffff_ffff ;
 current_sqid_reg_match_05 <= 32'hffff_ffff ;
 current_sqid_reg_match_06 <= 32'hffff_ffff ;
 current_sqid_reg_match_07 <= 32'hffff_ffff ;
 current_sqid_reg_match_08 <= 32'hffff_ffff ;
 current_sqid_reg_match_09 <= 32'hffff_ffff ;
 current_sqid_reg_match_0a <= 32'hffff_ffff ;
 current_sqid_reg_match_0b <= 32'hffff_ffff ;
 current_sqid_reg_match_0c <= 32'hffff_ffff ;
 current_sqid_reg_match_0d <= 32'hffff_ffff ;
 current_sqid_reg_match_0e <= 32'hffff_ffff ;
 current_sqid_reg_match_0f <= 32'hffff_ffff ;
 current_sqid_reg_match_10 <= 32'hffff_ffff ;
 current_sqid_reg_match_11 <= 32'hffff_ffff ;
 current_sqid_reg_match_12 <= 32'hffff_ffff ;
 current_sqid_reg_match_13 <= 32'hffff_ffff ;
 current_sqid_reg_match_14 <= 32'hffff_ffff ;
 current_sqid_reg_match_15 <= 32'hffff_ffff ;
 current_sqid_reg_match_16 <= 32'hffff_ffff ;
 current_sqid_reg_match_17 <= 32'hffff_ffff ;
 current_sqid_reg_match_18 <= 32'hffff_ffff ;
 current_sqid_reg_match_19 <= 32'hffff_ffff ;
 current_sqid_reg_match_1a <= 32'hffff_ffff ;
 current_sqid_reg_match_1b <= 32'hffff_ffff ;
 current_sqid_reg_match_1c <= 32'hffff_ffff ;
 current_sqid_reg_match_1d <= 32'hffff_ffff ;
 current_sqid_reg_match_1e <= 32'hffff_ffff ;
 current_sqid_reg_match_1f <= 32'hffff_ffff ;
 end
 else if ( market_rdy ) begin
 current_sqid_reg_match_00 <= params_current_sqid_reg_ro ;
 current_sqid_reg_match_01 <= current_sqid_reg_match_00 ;
 current_sqid_reg_match_02 <= current_sqid_reg_match_01 ;
 current_sqid_reg_match_03 <= current_sqid_reg_match_02 ;
 current_sqid_reg_match_04 <= current_sqid_reg_match_03 ;
 current_sqid_reg_match_05 <= current_sqid_reg_match_04 ;
 current_sqid_reg_match_06 <= current_sqid_reg_match_05 ;
 current_sqid_reg_match_07 <= current_sqid_reg_match_06 ;
 current_sqid_reg_match_08 <= current_sqid_reg_match_07 ;
 current_sqid_reg_match_09 <= current_sqid_reg_match_08 ;
 current_sqid_reg_match_0a <= current_sqid_reg_match_09 ;
 current_sqid_reg_match_0b <= current_sqid_reg_match_0a ;
 current_sqid_reg_match_0c <= current_sqid_reg_match_0b ;
 current_sqid_reg_match_0d <= current_sqid_reg_match_0c ;
 current_sqid_reg_match_0e <= current_sqid_reg_match_0d ;
 current_sqid_reg_match_0f <= current_sqid_reg_match_0e ;
 current_sqid_reg_match_10 <= current_sqid_reg_match_0f ;
 current_sqid_reg_match_11 <= current_sqid_reg_match_10 ;
 current_sqid_reg_match_12 <= current_sqid_reg_match_11 ;
 current_sqid_reg_match_13 <= current_sqid_reg_match_12 ;
 current_sqid_reg_match_14 <= current_sqid_reg_match_13 ;
 current_sqid_reg_match_15 <= current_sqid_reg_match_14 ;
 current_sqid_reg_match_16 <= current_sqid_reg_match_15 ;
 current_sqid_reg_match_17 <= current_sqid_reg_match_16 ;
 current_sqid_reg_match_18 <= current_sqid_reg_match_17 ;
 current_sqid_reg_match_19 <= current_sqid_reg_match_18 ;
 current_sqid_reg_match_1a <= current_sqid_reg_match_19 ;
 current_sqid_reg_match_1b <= current_sqid_reg_match_1a ;
 current_sqid_reg_match_1c <= current_sqid_reg_match_1b ;
 current_sqid_reg_match_1d <= current_sqid_reg_match_1c ;
 current_sqid_reg_match_1e <= current_sqid_reg_match_1d ;
 current_sqid_reg_match_1f <= current_sqid_reg_match_1e ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg_match_flag1 <= 1'd0 ;
 current_sqid_reg_match_flag2 <= 1'd0 ;
 current_sqid_reg_match_flag3 <= 1'd0 ;
 current_sqid_reg_match_flag4 <= 1'd0 ;
 end
 else if (params_filter_rst) begin
 current_sqid_reg_match_flag1 <= 1'd0 ;
 current_sqid_reg_match_flag2 <= 1'd0 ;
 current_sqid_reg_match_flag3 <= 1'd0 ;
 current_sqid_reg_match_flag4 <= 1'd0 ;
 end
 else if ( params_current_sqid_reg_ro_vld ) begin
 current_sqid_reg_match_flag1 <= ( (current_sqid_reg_match_00==params_current_sqid_reg_ro) || (current_sqid_reg_match_01==params_current_sqid_reg_ro) || (current_sqid_reg_match_02==params_current_sqid_reg_ro) || (current_sqid_reg_match_03==params_current_sqid_reg_ro) || (current_sqid_reg_match_04==params_current_sqid_reg_ro) || (current_sqid_reg_match_05==params_current_sqid_reg_ro) || (current_sqid_reg_match_06==params_current_sqid_reg_ro) || (current_sqid_reg_match_07==params_current_sqid_reg_ro) );
 current_sqid_reg_match_flag2 <= ( (current_sqid_reg_match_08==params_current_sqid_reg_ro) || (current_sqid_reg_match_09==params_current_sqid_reg_ro) || (current_sqid_reg_match_0a==params_current_sqid_reg_ro) || (current_sqid_reg_match_0b==params_current_sqid_reg_ro) || (current_sqid_reg_match_0c==params_current_sqid_reg_ro) || (current_sqid_reg_match_0d==params_current_sqid_reg_ro) || (current_sqid_reg_match_0e==params_current_sqid_reg_ro) || (current_sqid_reg_match_0f==params_current_sqid_reg_ro) );
 current_sqid_reg_match_flag3 <= ( (current_sqid_reg_match_10==params_current_sqid_reg_ro) || (current_sqid_reg_match_11==params_current_sqid_reg_ro) || (current_sqid_reg_match_12==params_current_sqid_reg_ro) || (current_sqid_reg_match_13==params_current_sqid_reg_ro) || (current_sqid_reg_match_14==params_current_sqid_reg_ro) || (current_sqid_reg_match_15==params_current_sqid_reg_ro) || (current_sqid_reg_match_16==params_current_sqid_reg_ro) || (current_sqid_reg_match_17==params_current_sqid_reg_ro) );
 current_sqid_reg_match_flag4 <= ( (current_sqid_reg_match_18==params_current_sqid_reg_ro) || (current_sqid_reg_match_19==params_current_sqid_reg_ro) || (current_sqid_reg_match_1a==params_current_sqid_reg_ro) || (current_sqid_reg_match_1b==params_current_sqid_reg_ro) || (current_sqid_reg_match_1c==params_current_sqid_reg_ro) || (current_sqid_reg_match_1d==params_current_sqid_reg_ro) || (current_sqid_reg_match_1e==params_current_sqid_reg_ro) || (current_sqid_reg_match_1f==params_current_sqid_reg_ro) );
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg_match_flag <= 1'd0 ;
 end
 else begin
 current_sqid_reg_match_flag <= current_sqid_reg_match_flag1 || current_sqid_reg_match_flag2 || current_sqid_reg_match_flag3 || current_sqid_reg_match_flag4 ;
 end
 end
 wire [31:0] current_id_wire2 = current_id_wire + 1'd1 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg_flag <= 1'd0 ;
 end
 else if (st_rx_start&&tcp_sqmatch_flag) begin
 current_sqid_reg_flag <= 1'd1 ;
 end
 else if (st_rx_start&&~tcp_sqmatch_flag) begin
 current_sqid_reg_flag <= 1'd0 ;
 end
 else if ( fir_r_id_st && (st_shift_ccnt>=6'd12 ) && frame_type_rdy ) begin
 if ( (current_id_wire2<=current_sqid_reg) ) begin
 current_sqid_reg_flag <= 1'd0 ;
 end
 else begin
 current_sqid_reg_flag <= 1'd1 ;
 end
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 market_rdy <= 1'd0 ;
 end
 else if (fir_r_rdata0_st && (st_shift_ccnt>=6'd16) && (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) && (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg) ) begin
 market_rdy <= frame_type_rdy && ( segm_type_2433_flag || segm_type_2434_flag ) && ~current_sqid_reg_match_flag ;
 end
 else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) && (patition_cnt>=patition_cnt_reg) ) begin
 market_rdy <= frame_type_rdy && ( segm_type_2433_flag || segm_type_2434_flag ) && ~current_sqid_reg_match_flag;
 end
 else begin
 market_rdy <= 1'd0 ;
 end
 end
 reg [47:0] current_sqid_reg_rst_cnt ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_sqid_reg_rst_cnt <= 48'd0 ;
 current_sqid_reg_rst <= 1'd0 ;
 end
 else if ( params_filter_rst ) begin
 current_sqid_reg_rst_cnt <= 48'd0 ;
 current_sqid_reg_rst <= 1'd0 ;
 end
 else if ( market_rdy ) begin
 current_sqid_reg_rst_cnt <= 48'd0 ;
 current_sqid_reg_rst <= 1'd0 ;
 end
 else if ( (current_sqid_reg_rst_cnt>({params_current_sqid_reg_rst_cnt,16'hffff})) && st_rx_start_pre ) begin
 current_sqid_reg_rst_cnt <= 48'd0 ;
 current_sqid_reg_rst <= 1'd1 ;
 /* synthesis translate_off */ $display("%m Warning current_sqid_reg_rst !!!!! \n " );
 /* synthesis translate_on */ end
 else begin
 current_sqid_reg_rst_cnt <= (current_sqid_reg_rst_cnt==48'hffff_ffff_ffff) ? current_sqid_reg_rst_cnt : current_sqid_reg_rst_cnt + 64'd1 ;
 current_sqid_reg_rst <= 1'd0 ;
 end
 end
 fir_cut_out sq_fir_cut_out ( .sq_cut_on ( sq_cut_on_reg ), .sq_cut_first_on ( sq_cut_first_on ), .tcp_sqmatch_flag ( tcp_sqmatch_flag_reg ), .current_sqid_reg_flag (current_sqid_reg_flag ), .sync_len_byte (sync_len_byte ) , .sync_fisrt_byte (sync_fisrt_byte), .sync_four_byte (sync_four_byte), .sq_rx_start (sq_rx_start ), .sq_rx_end (sq_rx_end ), .sq_rx_valid (sq_rx_valid ), .sq_rx_data (sq_rx_data ), .sq_rx_empty (sq_rx_empty ), .sq_rx_empty_01 ( sq_rx_empty_01 ) , .sq_rx_empty_02 ( sq_rx_empty_02 ) , .sq_rx_empty_03 ( sq_rx_empty_03 ) , .sq_rx_empty_04 ( sq_rx_empty_04 ) , .sq_rx_empty_05 ( sq_rx_empty_05 ) , .sq_rx_empty_06 ( sq_rx_empty_06 ) , .sq_rx_empty_07 ( sq_rx_empty_07 ) , .sq_rx_empty_08 ( sq_rx_empty_08 ) , .sq_rx_empty_09 ( sq_rx_empty_09 ) , .sq_rx_empty_10 ( sq_rx_empty_10 ) , .sq_rx_empty_11 ( sq_rx_empty_11 ) , .sq_rx_empty_12 ( sq_rx_empty_12 ) , .sq_rx_empty_13 ( sq_rx_empty_13 ) , .sq_rx_empty_14 ( sq_rx_empty_14 ) , .sq_rx_empty_15 ( sq_rx_empty_15 ) , .sq_rx_empty_16 ( sq_rx_empty_16 ) , .sq_rx_empty_17 ( sq_rx_empty_17 ) , .sq_rx_empty_18 ( sq_rx_empty_18 ) , .sq_rx_empty_19 ( sq_rx_empty_19 ) , .sq_rx_empty_20 ( sq_rx_empty_20 ) , .sq_rx_empty_21 ( sq_rx_empty_21 ) , .sq_rx_empty_22 ( sq_rx_empty_22 ) , .sq_rx_empty_23 ( sq_rx_empty_23 ) , .sq_rx_empty_24 ( sq_rx_empty_24 ) , .sq_rx_empty_25 ( sq_rx_empty_25 ) , .sq_rx_empty_26 ( sq_rx_empty_26 ) , .sq_rx_empty_27 ( sq_rx_empty_27 ) , .sq_rx_empty_28 ( sq_rx_empty_28 ) , .sq_rx_empty_29 ( sq_rx_empty_29 ) , .sq_rx_empty_30 ( sq_rx_empty_30 ) , .sq_rx_empty_31 ( sq_rx_empty_31 ) , .fir_r_sqcuth_st (fir_r_sqcuth_st ), .fir_r_vsync_st (fir_r_vsync_st ), .fir_r_sqrcut_st (fir_r_sqrcut_st ), .fir_r_sqrcut_end_st (fir_r_sqrcut_end_st), .fir_r_sqcut_st (fir_r_sqcut_st ), .fir_r_sqcut_end_st (fir_r_sqcut_end_st ), .sub_sqcut_len_reg (sub_sqcut_len_reg[5:0] ), .st_shift_ccnt (st_shift_ccnt ), .st_rx_cnt_reg (st_rx_cnt_reg ), .sq_frame_flag (sq_frame_flag ), .st_shift_reg (st_shift_reg ), .clk (clk ), .rst_n (rst_n ) );
 fir_shift_reg_192 fir_shift_reg_192 ( .fir_rx_cstate (fir_rx_cstate ) , .st_shift_full_flag (st_shift_full_flag ) , .st_rx_start (st_rx_start ) , .st_rx_offset (st_rx_offset ) , .st_rx_end (st_rx_end ) , .st_rx_valid (st_rx_valid ) , .st_rx_data (st_rx_data ) , .st_rx_ready (st_rx_ready ) , .st_rx_empty (st_rx_empty ) , .fir_r_idle_st (fir_r_idle_st ) , .st_shift_reg (st_shift_reg ) , .st_shift_ccnt (st_shift_ccnt ) , .st_shift_scnt (st_shift_scnt ) , .st_shift_en (st_shift_en ) , .clk (clk ) , .rst_n (rst_n ) );
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 error_flag <= 32'd0 ;
 end
 else begin
 error_flag <= {24'd0,3'd0 , (st_rx_start_pre&&~fir_r_idle_st) , first_sync_len_error||current_sqid_error , st_shift_full_flag , sq_shift_full_flag , fir_r_error_st } ;
 end
 end
 endmodule
 module filter_rx_top ( clk , rst_n , params_current_sqid_reg_add , params_current_sqid_reg_cnt , params_current_sqid_reg_rst_cnt , fir_rx_cstate, debug_discard_calc_cnt1 , debug_st_shift_full_flag , debug_st_shift_scnt, , debug_st_shift_en, , tlp_cnt, current_id_wire, current_sqid_reg, current_sqid_reg_vld, st_rx_cnt_reg , st_shift_ccnt , params_current_sqid_reg_ro , params_filter_rst , params_frame_type_byte , params_03e9_type , params_1389_type , params_07d0_type , st_rx_start , st_rx_offset , st_rx_end , st_rx_valid , st_rx_data , st_rx_empty , st_rx_cnt , st_rx_ready , first_sync_len_byte , tcp_sqmatch_flag , seq_err_flag , error_flag , sq_cut_flag , sq_cut_reset , tcp_payload_len , fifo_data_empty, fifo_data_out , fifo_data_vld, fifo_ready );
 input clk ;
 input rst_n ;
 input [3:0] params_current_sqid_reg_add ;
 input [3:0] params_current_sqid_reg_cnt ;
 input [31:0] params_current_sqid_reg_rst_cnt ;
 output [4:0] fir_rx_cstate;
 output [31:0] tlp_cnt;
 output [31:0] current_id_wire;
 output [31:0] current_sqid_reg;
 output current_sqid_reg_vld ;
 input [ 15: 0] params_frame_type_byte ;
 output [31:0] params_current_sqid_reg_ro ;
 input params_filter_rst ;
 input [15:0] params_03e9_type ;
 input [15:0] params_1389_type ;
 input [15:0] params_07d0_type ;
 input st_rx_start ;
 input [ 3: 0] st_rx_offset ;
 input st_rx_end ;
 input st_rx_valid ;
 input [ 63: 0] st_rx_data ;
 input [ 2: 0] st_rx_empty ;
 input [ 15: 0] st_rx_cnt ;
 output st_rx_ready ;
 input [ 15: 0] first_sync_len_byte ;
 input [31:0] tcp_sqmatch_flag ;
 input [31:0] seq_err_flag ;
 output [31:0] error_flag ;
 output [31:0] sq_cut_flag ;
 output [31:0] sq_cut_reset ;
 input [ 15: 0] tcp_payload_len ;
 output fifo_data_empty;
 output [255:0] fifo_data_out ;
 output fifo_data_vld;
 input fifo_ready;
 wire [31:0] params_current_sqid_reg_ro ;
 wire [31:0] sq_cut_reset ;
 wire [31:0] sq_cut_reset_pre ;
 wire fir_r_idle_st ;
 wire fir_r_sqcuth_st ;
 wire fir_r_vsync_st ;
 wire fir_r_sqcut_st ;
 wire fir_r_sqcut_end_st ;
 wire fir_r_sqrcut_st ;
 wire fir_r_sqrcut_end_st ;
 wire fir_r_rjudge_st ;
 wire [31:0] sq_rx_start ;
 wire [31:0] sq_rx_end ;
 wire [31:0] sq_rx_valid ;
 wire [63:0] sq_rx_data ;
 wire [ 2:0] sq_rx_empty ;
 wire [ 2:0] sq_rx_empty_01 ;
 wire [ 2:0] sq_rx_empty_02 ;
 wire [ 2:0] sq_rx_empty_03 ;
 wire [ 2:0] sq_rx_empty_04 ;
 wire [ 2:0] sq_rx_empty_05 ;
 wire [ 2:0] sq_rx_empty_06 ;
 wire [ 2:0] sq_rx_empty_07 ;
 wire [ 2:0] sq_rx_empty_08 ;
 wire [ 2:0] sq_rx_empty_09 ;
 wire [ 2:0] sq_rx_empty_10 ;
 wire [ 2:0] sq_rx_empty_11 ;
 wire [ 2:0] sq_rx_empty_12 ;
 wire [ 2:0] sq_rx_empty_13 ;
 wire [ 2:0] sq_rx_empty_14 ;
 wire [ 2:0] sq_rx_empty_15 ;
 wire [ 2:0] sq_rx_empty_16 ;
 wire [ 2:0] sq_rx_empty_17 ;
 wire [ 2:0] sq_rx_empty_18 ;
 wire [ 2:0] sq_rx_empty_19 ;
 wire [ 2:0] sq_rx_empty_20 ;
 wire [ 2:0] sq_rx_empty_21 ;
 wire [ 2:0] sq_rx_empty_22 ;
 wire [ 2:0] sq_rx_empty_23 ;
 wire [ 2:0] sq_rx_empty_24 ;
 wire [ 2:0] sq_rx_empty_25 ;
 wire [ 2:0] sq_rx_empty_26 ;
 wire [ 2:0] sq_rx_empty_27 ;
 wire [ 2:0] sq_rx_empty_28 ;
 wire [ 2:0] sq_rx_empty_29 ;
 wire [ 2:0] sq_rx_empty_30 ;
 wire [ 2:0] sq_rx_empty_31 ;
 wire [31:0] current_id_wire = 32'd0 ;
 wire [31:0] current_sqid_reg ;
 wire current_sqid_reg_vld ;
 wire [ 23: 0] market_explain ;
 wire [ 7: 0] info_classify ;
 wire [ 31: 0] dialog_num ;
 wire [ 7: 0] contract_flag ;
 wire [ 31: 0] contract_num ;
 wire [175: 0] contract_code ;
 wire [ 71: 0] update_time ;
 wire [ 31: 0] update_ms ;
 wire [ 63: 0] new_price ;
 wire [ 31: 0] turnover ;
 wire [ 63: 0] volume ;
 wire [ 63: 0] position ;
 wire [ 63: 0] purchase_price ;
 wire [ 31: 0] buy_quantity ;
 wire [ 63: 0] sell_price ;
 wire [ 31: 0] sell_quantity ;
 wire market_rdy ;
 wire [ 23: 0] sq00_market_explain ;
 wire [ 23: 0] sq01_market_explain ;
 wire [ 23: 0] sq02_market_explain ;
 wire [ 23: 0] sq03_market_explain ;
 wire [ 23: 0] sq04_market_explain ;
 wire [ 23: 0] sq05_market_explain ;
 wire [ 23: 0] sq06_market_explain ;
 wire [ 23: 0] sq07_market_explain ;
 wire [ 23: 0] sq08_market_explain ;
 wire [ 23: 0] sq09_market_explain ;
 wire [ 23: 0] sq10_market_explain ;
 wire [ 23: 0] sq11_market_explain ;
 wire [ 23: 0] sq12_market_explain ;
 wire [ 23: 0] sq13_market_explain ;
 wire [ 23: 0] sq14_market_explain ;
 wire [ 23: 0] sq15_market_explain ;
 wire [ 23: 0] sq16_market_explain ;
 wire [ 23: 0] sq17_market_explain ;
 wire [ 23: 0] sq18_market_explain ;
 wire [ 23: 0] sq19_market_explain ;
 wire [ 23: 0] sq20_market_explain ;
 wire [ 23: 0] sq21_market_explain ;
 wire [ 23: 0] sq22_market_explain ;
 wire [ 23: 0] sq23_market_explain ;
 wire [ 23: 0] sq24_market_explain ;
 wire [ 23: 0] sq25_market_explain ;
 wire [ 23: 0] sq26_market_explain ;
 wire [ 23: 0] sq27_market_explain ;
 wire [ 23: 0] sq28_market_explain ;
 wire [ 23: 0] sq29_market_explain ;
 wire [ 23: 0] sq30_market_explain ;
 wire [ 23: 0] sq31_market_explain ;
 wire [ 7: 0] sq00_info_classify ;
 wire [ 7: 0] sq01_info_classify ;
 wire [ 7: 0] sq02_info_classify ;
 wire [ 7: 0] sq03_info_classify ;
 wire [ 7: 0] sq04_info_classify ;
 wire [ 7: 0] sq05_info_classify ;
 wire [ 7: 0] sq06_info_classify ;
 wire [ 7: 0] sq07_info_classify ;
 wire [ 7: 0] sq08_info_classify ;
 wire [ 7: 0] sq09_info_classify ;
 wire [ 7: 0] sq10_info_classify ;
 wire [ 7: 0] sq11_info_classify ;
 wire [ 7: 0] sq12_info_classify ;
 wire [ 7: 0] sq13_info_classify ;
 wire [ 7: 0] sq14_info_classify ;
 wire [ 7: 0] sq15_info_classify ;
 wire [ 7: 0] sq16_info_classify ;
 wire [ 7: 0] sq17_info_classify ;
 wire [ 7: 0] sq18_info_classify ;
 wire [ 7: 0] sq19_info_classify ;
 wire [ 7: 0] sq20_info_classify ;
 wire [ 7: 0] sq21_info_classify ;
 wire [ 7: 0] sq22_info_classify ;
 wire [ 7: 0] sq23_info_classify ;
 wire [ 7: 0] sq24_info_classify ;
 wire [ 7: 0] sq25_info_classify ;
 wire [ 7: 0] sq26_info_classify ;
 wire [ 7: 0] sq27_info_classify ;
 wire [ 7: 0] sq28_info_classify ;
 wire [ 7: 0] sq29_info_classify ;
 wire [ 7: 0] sq30_info_classify ;
 wire [ 7: 0] sq31_info_classify ;
 wire [ 31: 0] sq00_dialog_num ;
 wire [ 31: 0] sq01_dialog_num ;
 wire [ 31: 0] sq02_dialog_num ;
 wire [ 31: 0] sq03_dialog_num ;
 wire [ 31: 0] sq04_dialog_num ;
 wire [ 31: 0] sq05_dialog_num ;
 wire [ 31: 0] sq06_dialog_num ;
 wire [ 31: 0] sq07_dialog_num ;
 wire [ 31: 0] sq08_dialog_num ;
 wire [ 31: 0] sq09_dialog_num ;
 wire [ 31: 0] sq10_dialog_num ;
 wire [ 31: 0] sq11_dialog_num ;
 wire [ 31: 0] sq12_dialog_num ;
 wire [ 31: 0] sq13_dialog_num ;
 wire [ 31: 0] sq14_dialog_num ;
 wire [ 31: 0] sq15_dialog_num ;
 wire [ 31: 0] sq16_dialog_num ;
 wire [ 31: 0] sq17_dialog_num ;
 wire [ 31: 0] sq18_dialog_num ;
 wire [ 31: 0] sq19_dialog_num ;
 wire [ 31: 0] sq20_dialog_num ;
 wire [ 31: 0] sq21_dialog_num ;
 wire [ 31: 0] sq22_dialog_num ;
 wire [ 31: 0] sq23_dialog_num ;
 wire [ 31: 0] sq24_dialog_num ;
 wire [ 31: 0] sq25_dialog_num ;
 wire [ 31: 0] sq26_dialog_num ;
 wire [ 31: 0] sq27_dialog_num ;
 wire [ 31: 0] sq28_dialog_num ;
 wire [ 31: 0] sq29_dialog_num ;
 wire [ 31: 0] sq30_dialog_num ;
 wire [ 31: 0] sq31_dialog_num ;
 wire [ 7: 0] sq00_contract_flag ;
 wire [ 7: 0] sq01_contract_flag ;
 wire [ 7: 0] sq02_contract_flag ;
 wire [ 7: 0] sq03_contract_flag ;
 wire [ 7: 0] sq04_contract_flag ;
 wire [ 7: 0] sq05_contract_flag ;
 wire [ 7: 0] sq06_contract_flag ;
 wire [ 7: 0] sq07_contract_flag ;
 wire [ 7: 0] sq08_contract_flag ;
 wire [ 7: 0] sq09_contract_flag ;
 wire [ 7: 0] sq10_contract_flag ;
 wire [ 7: 0] sq11_contract_flag ;
 wire [ 7: 0] sq12_contract_flag ;
 wire [ 7: 0] sq13_contract_flag ;
 wire [ 7: 0] sq14_contract_flag ;
 wire [ 7: 0] sq15_contract_flag ;
 wire [ 7: 0] sq16_contract_flag ;
 wire [ 7: 0] sq17_contract_flag ;
 wire [ 7: 0] sq18_contract_flag ;
 wire [ 7: 0] sq19_contract_flag ;
 wire [ 7: 0] sq20_contract_flag ;
 wire [ 7: 0] sq21_contract_flag ;
 wire [ 7: 0] sq22_contract_flag ;
 wire [ 7: 0] sq23_contract_flag ;
 wire [ 7: 0] sq24_contract_flag ;
 wire [ 7: 0] sq25_contract_flag ;
 wire [ 7: 0] sq26_contract_flag ;
 wire [ 7: 0] sq27_contract_flag ;
 wire [ 7: 0] sq28_contract_flag ;
 wire [ 7: 0] sq29_contract_flag ;
 wire [ 7: 0] sq30_contract_flag ;
 wire [ 7: 0] sq31_contract_flag ;
 wire [ 31: 0] sq00_contract_num ;
 wire [ 31: 0] sq01_contract_num ;
 wire [ 31: 0] sq02_contract_num ;
 wire [ 31: 0] sq03_contract_num ;
 wire [ 31: 0] sq04_contract_num ;
 wire [ 31: 0] sq05_contract_num ;
 wire [ 31: 0] sq06_contract_num ;
 wire [ 31: 0] sq07_contract_num ;
 wire [ 31: 0] sq08_contract_num ;
 wire [ 31: 0] sq09_contract_num ;
 wire [ 31: 0] sq10_contract_num ;
 wire [ 31: 0] sq11_contract_num ;
 wire [ 31: 0] sq12_contract_num ;
 wire [ 31: 0] sq13_contract_num ;
 wire [ 31: 0] sq14_contract_num ;
 wire [ 31: 0] sq15_contract_num ;
 wire [ 31: 0] sq16_contract_num ;
 wire [ 31: 0] sq17_contract_num ;
 wire [ 31: 0] sq18_contract_num ;
 wire [ 31: 0] sq19_contract_num ;
 wire [ 31: 0] sq20_contract_num ;
 wire [ 31: 0] sq21_contract_num ;
 wire [ 31: 0] sq22_contract_num ;
 wire [ 31: 0] sq23_contract_num ;
 wire [ 31: 0] sq24_contract_num ;
 wire [ 31: 0] sq25_contract_num ;
 wire [ 31: 0] sq26_contract_num ;
 wire [ 31: 0] sq27_contract_num ;
 wire [ 31: 0] sq28_contract_num ;
 wire [ 31: 0] sq29_contract_num ;
 wire [ 31: 0] sq30_contract_num ;
 wire [ 31: 0] sq31_contract_num ;
 wire [175: 0] sq00_contract_code ;
 wire [175: 0] sq01_contract_code ;
 wire [175: 0] sq02_contract_code ;
 wire [175: 0] sq03_contract_code ;
 wire [175: 0] sq04_contract_code ;
 wire [175: 0] sq05_contract_code ;
 wire [175: 0] sq06_contract_code ;
 wire [175: 0] sq07_contract_code ;
 wire [175: 0] sq08_contract_code ;
 wire [175: 0] sq09_contract_code ;
 wire [175: 0] sq10_contract_code ;
 wire [175: 0] sq11_contract_code ;
 wire [175: 0] sq12_contract_code ;
 wire [175: 0] sq13_contract_code ;
 wire [175: 0] sq14_contract_code ;
 wire [175: 0] sq15_contract_code ;
 wire [175: 0] sq16_contract_code ;
 wire [175: 0] sq17_contract_code ;
 wire [175: 0] sq18_contract_code ;
 wire [175: 0] sq19_contract_code ;
 wire [175: 0] sq20_contract_code ;
 wire [175: 0] sq21_contract_code ;
 wire [175: 0] sq22_contract_code ;
 wire [175: 0] sq23_contract_code ;
 wire [175: 0] sq24_contract_code ;
 wire [175: 0] sq25_contract_code ;
 wire [175: 0] sq26_contract_code ;
 wire [175: 0] sq27_contract_code ;
 wire [175: 0] sq28_contract_code ;
 wire [175: 0] sq29_contract_code ;
 wire [175: 0] sq30_contract_code ;
 wire [175: 0] sq31_contract_code ;
 wire [ 71: 0] sq00_update_time ;
 wire [ 71: 0] sq01_update_time ;
 wire [ 71: 0] sq02_update_time ;
 wire [ 71: 0] sq03_update_time ;
 wire [ 71: 0] sq04_update_time ;
 wire [ 71: 0] sq05_update_time ;
 wire [ 71: 0] sq06_update_time ;
 wire [ 71: 0] sq07_update_time ;
 wire [ 71: 0] sq08_update_time ;
 wire [ 71: 0] sq09_update_time ;
 wire [ 71: 0] sq10_update_time ;
 wire [ 71: 0] sq11_update_time ;
 wire [ 71: 0] sq12_update_time ;
 wire [ 71: 0] sq13_update_time ;
 wire [ 71: 0] sq14_update_time ;
 wire [ 71: 0] sq15_update_time ;
 wire [ 71: 0] sq16_update_time ;
 wire [ 71: 0] sq17_update_time ;
 wire [ 71: 0] sq18_update_time ;
 wire [ 71: 0] sq19_update_time ;
 wire [ 71: 0] sq20_update_time ;
 wire [ 71: 0] sq21_update_time ;
 wire [ 71: 0] sq22_update_time ;
 wire [ 71: 0] sq23_update_time ;
 wire [ 71: 0] sq24_update_time ;
 wire [ 71: 0] sq25_update_time ;
 wire [ 71: 0] sq26_update_time ;
 wire [ 71: 0] sq27_update_time ;
 wire [ 71: 0] sq28_update_time ;
 wire [ 71: 0] sq29_update_time ;
 wire [ 71: 0] sq30_update_time ;
 wire [ 71: 0] sq31_update_time ;
 wire [ 31: 0] sq00_update_ms ;
 wire [ 31: 0] sq01_update_ms ;
 wire [ 31: 0] sq02_update_ms ;
 wire [ 31: 0] sq03_update_ms ;
 wire [ 31: 0] sq04_update_ms ;
 wire [ 31: 0] sq05_update_ms ;
 wire [ 31: 0] sq06_update_ms ;
 wire [ 31: 0] sq07_update_ms ;
 wire [ 31: 0] sq08_update_ms ;
 wire [ 31: 0] sq09_update_ms ;
 wire [ 31: 0] sq10_update_ms ;
 wire [ 31: 0] sq11_update_ms ;
 wire [ 31: 0] sq12_update_ms ;
 wire [ 31: 0] sq13_update_ms ;
 wire [ 31: 0] sq14_update_ms ;
 wire [ 31: 0] sq15_update_ms ;
 wire [ 31: 0] sq16_update_ms ;
 wire [ 31: 0] sq17_update_ms ;
 wire [ 31: 0] sq18_update_ms ;
 wire [ 31: 0] sq19_update_ms ;
 wire [ 31: 0] sq20_update_ms ;
 wire [ 31: 0] sq21_update_ms ;
 wire [ 31: 0] sq22_update_ms ;
 wire [ 31: 0] sq23_update_ms ;
 wire [ 31: 0] sq24_update_ms ;
 wire [ 31: 0] sq25_update_ms ;
 wire [ 31: 0] sq26_update_ms ;
 wire [ 31: 0] sq27_update_ms ;
 wire [ 31: 0] sq28_update_ms ;
 wire [ 31: 0] sq29_update_ms ;
 wire [ 31: 0] sq30_update_ms ;
 wire [ 31: 0] sq31_update_ms ;
 wire [ 63: 0] sq00_new_price ;
 wire [ 63: 0] sq01_new_price ;
 wire [ 63: 0] sq02_new_price ;
 wire [ 63: 0] sq03_new_price ;
 wire [ 63: 0] sq04_new_price ;
 wire [ 63: 0] sq05_new_price ;
 wire [ 63: 0] sq06_new_price ;
 wire [ 63: 0] sq07_new_price ;
 wire [ 63: 0] sq08_new_price ;
 wire [ 63: 0] sq09_new_price ;
 wire [ 63: 0] sq10_new_price ;
 wire [ 63: 0] sq11_new_price ;
 wire [ 63: 0] sq12_new_price ;
 wire [ 63: 0] sq13_new_price ;
 wire [ 63: 0] sq14_new_price ;
 wire [ 63: 0] sq15_new_price ;
 wire [ 63: 0] sq16_new_price ;
 wire [ 63: 0] sq17_new_price ;
 wire [ 63: 0] sq18_new_price ;
 wire [ 63: 0] sq19_new_price ;
 wire [ 63: 0] sq20_new_price ;
 wire [ 63: 0] sq21_new_price ;
 wire [ 63: 0] sq22_new_price ;
 wire [ 63: 0] sq23_new_price ;
 wire [ 63: 0] sq24_new_price ;
 wire [ 63: 0] sq25_new_price ;
 wire [ 63: 0] sq26_new_price ;
 wire [ 63: 0] sq27_new_price ;
 wire [ 63: 0] sq28_new_price ;
 wire [ 63: 0] sq29_new_price ;
 wire [ 63: 0] sq30_new_price ;
 wire [ 63: 0] sq31_new_price ;
 wire [ 31: 0] sq00_turnover ;
 wire [ 31: 0] sq01_turnover ;
 wire [ 31: 0] sq02_turnover ;
 wire [ 31: 0] sq03_turnover ;
 wire [ 31: 0] sq04_turnover ;
 wire [ 31: 0] sq05_turnover ;
 wire [ 31: 0] sq06_turnover ;
 wire [ 31: 0] sq07_turnover ;
 wire [ 31: 0] sq08_turnover ;
 wire [ 31: 0] sq09_turnover ;
 wire [ 31: 0] sq10_turnover ;
 wire [ 31: 0] sq11_turnover ;
 wire [ 31: 0] sq12_turnover ;
 wire [ 31: 0] sq13_turnover ;
 wire [ 31: 0] sq14_turnover ;
 wire [ 31: 0] sq15_turnover ;
 wire [ 31: 0] sq16_turnover ;
 wire [ 31: 0] sq17_turnover ;
 wire [ 31: 0] sq18_turnover ;
 wire [ 31: 0] sq19_turnover ;
 wire [ 31: 0] sq20_turnover ;
 wire [ 31: 0] sq21_turnover ;
 wire [ 31: 0] sq22_turnover ;
 wire [ 31: 0] sq23_turnover ;
 wire [ 31: 0] sq24_turnover ;
 wire [ 31: 0] sq25_turnover ;
 wire [ 31: 0] sq26_turnover ;
 wire [ 31: 0] sq27_turnover ;
 wire [ 31: 0] sq28_turnover ;
 wire [ 31: 0] sq29_turnover ;
 wire [ 31: 0] sq30_turnover ;
 wire [ 31: 0] sq31_turnover ;
 wire [ 63: 0] sq00_volume ;
 wire [ 63: 0] sq01_volume ;
 wire [ 63: 0] sq02_volume ;
 wire [ 63: 0] sq03_volume ;
 wire [ 63: 0] sq04_volume ;
 wire [ 63: 0] sq05_volume ;
 wire [ 63: 0] sq06_volume ;
 wire [ 63: 0] sq07_volume ;
 wire [ 63: 0] sq08_volume ;
 wire [ 63: 0] sq09_volume ;
 wire [ 63: 0] sq10_volume ;
 wire [ 63: 0] sq11_volume ;
 wire [ 63: 0] sq12_volume ;
 wire [ 63: 0] sq13_volume ;
 wire [ 63: 0] sq14_volume ;
 wire [ 63: 0] sq15_volume ;
 wire [ 63: 0] sq16_volume ;
 wire [ 63: 0] sq17_volume ;
 wire [ 63: 0] sq18_volume ;
 wire [ 63: 0] sq19_volume ;
 wire [ 63: 0] sq20_volume ;
 wire [ 63: 0] sq21_volume ;
 wire [ 63: 0] sq22_volume ;
 wire [ 63: 0] sq23_volume ;
 wire [ 63: 0] sq24_volume ;
 wire [ 63: 0] sq25_volume ;
 wire [ 63: 0] sq26_volume ;
 wire [ 63: 0] sq27_volume ;
 wire [ 63: 0] sq28_volume ;
 wire [ 63: 0] sq29_volume ;
 wire [ 63: 0] sq30_volume ;
 wire [ 63: 0] sq31_volume ;
 wire [ 63: 0] sq00_position ;
 wire [ 63: 0] sq01_position ;
 wire [ 63: 0] sq02_position ;
 wire [ 63: 0] sq03_position ;
 wire [ 63: 0] sq04_position ;
 wire [ 63: 0] sq05_position ;
 wire [ 63: 0] sq06_position ;
 wire [ 63: 0] sq07_position ;
 wire [ 63: 0] sq08_position ;
 wire [ 63: 0] sq09_position ;
 wire [ 63: 0] sq10_position ;
 wire [ 63: 0] sq11_position ;
 wire [ 63: 0] sq12_position ;
 wire [ 63: 0] sq13_position ;
 wire [ 63: 0] sq14_position ;
 wire [ 63: 0] sq15_position ;
 wire [ 63: 0] sq16_position ;
 wire [ 63: 0] sq17_position ;
 wire [ 63: 0] sq18_position ;
 wire [ 63: 0] sq19_position ;
 wire [ 63: 0] sq20_position ;
 wire [ 63: 0] sq21_position ;
 wire [ 63: 0] sq22_position ;
 wire [ 63: 0] sq23_position ;
 wire [ 63: 0] sq24_position ;
 wire [ 63: 0] sq25_position ;
 wire [ 63: 0] sq26_position ;
 wire [ 63: 0] sq27_position ;
 wire [ 63: 0] sq28_position ;
 wire [ 63: 0] sq29_position ;
 wire [ 63: 0] sq30_position ;
 wire [ 63: 0] sq31_position ;
 wire [ 63: 0] sq00_purchase_price ;
 wire [ 63: 0] sq01_purchase_price ;
 wire [ 63: 0] sq02_purchase_price ;
 wire [ 63: 0] sq03_purchase_price ;
 wire [ 63: 0] sq04_purchase_price ;
 wire [ 63: 0] sq05_purchase_price ;
 wire [ 63: 0] sq06_purchase_price ;
 wire [ 63: 0] sq07_purchase_price ;
 wire [ 63: 0] sq08_purchase_price ;
 wire [ 63: 0] sq09_purchase_price ;
 wire [ 63: 0] sq10_purchase_price ;
 wire [ 63: 0] sq11_purchase_price ;
 wire [ 63: 0] sq12_purchase_price ;
 wire [ 63: 0] sq13_purchase_price ;
 wire [ 63: 0] sq14_purchase_price ;
 wire [ 63: 0] sq15_purchase_price ;
 wire [ 63: 0] sq16_purchase_price ;
 wire [ 63: 0] sq17_purchase_price ;
 wire [ 63: 0] sq18_purchase_price ;
 wire [ 63: 0] sq19_purchase_price ;
 wire [ 63: 0] sq20_purchase_price ;
 wire [ 63: 0] sq21_purchase_price ;
 wire [ 63: 0] sq22_purchase_price ;
 wire [ 63: 0] sq23_purchase_price ;
 wire [ 63: 0] sq24_purchase_price ;
 wire [ 63: 0] sq25_purchase_price ;
 wire [ 63: 0] sq26_purchase_price ;
 wire [ 63: 0] sq27_purchase_price ;
 wire [ 63: 0] sq28_purchase_price ;
 wire [ 63: 0] sq29_purchase_price ;
 wire [ 63: 0] sq30_purchase_price ;
 wire [ 63: 0] sq31_purchase_price ;
 wire [ 31: 0] sq00_buy_quantity ;
 wire [ 31: 0] sq01_buy_quantity ;
 wire [ 31: 0] sq02_buy_quantity ;
 wire [ 31: 0] sq03_buy_quantity ;
 wire [ 31: 0] sq04_buy_quantity ;
 wire [ 31: 0] sq05_buy_quantity ;
 wire [ 31: 0] sq06_buy_quantity ;
 wire [ 31: 0] sq07_buy_quantity ;
 wire [ 31: 0] sq08_buy_quantity ;
 wire [ 31: 0] sq09_buy_quantity ;
 wire [ 31: 0] sq10_buy_quantity ;
 wire [ 31: 0] sq11_buy_quantity ;
 wire [ 31: 0] sq12_buy_quantity ;
 wire [ 31: 0] sq13_buy_quantity ;
 wire [ 31: 0] sq14_buy_quantity ;
 wire [ 31: 0] sq15_buy_quantity ;
 wire [ 31: 0] sq16_buy_quantity ;
 wire [ 31: 0] sq17_buy_quantity ;
 wire [ 31: 0] sq18_buy_quantity ;
 wire [ 31: 0] sq19_buy_quantity ;
 wire [ 31: 0] sq20_buy_quantity ;
 wire [ 31: 0] sq21_buy_quantity ;
 wire [ 31: 0] sq22_buy_quantity ;
 wire [ 31: 0] sq23_buy_quantity ;
 wire [ 31: 0] sq24_buy_quantity ;
 wire [ 31: 0] sq25_buy_quantity ;
 wire [ 31: 0] sq26_buy_quantity ;
 wire [ 31: 0] sq27_buy_quantity ;
 wire [ 31: 0] sq28_buy_quantity ;
 wire [ 31: 0] sq29_buy_quantity ;
 wire [ 31: 0] sq30_buy_quantity ;
 wire [ 31: 0] sq31_buy_quantity ;
 wire [ 63: 0] sq00_sell_price ;
 wire [ 63: 0] sq01_sell_price ;
 wire [ 63: 0] sq02_sell_price ;
 wire [ 63: 0] sq03_sell_price ;
 wire [ 63: 0] sq04_sell_price ;
 wire [ 63: 0] sq05_sell_price ;
 wire [ 63: 0] sq06_sell_price ;
 wire [ 63: 0] sq07_sell_price ;
 wire [ 63: 0] sq08_sell_price ;
 wire [ 63: 0] sq09_sell_price ;
 wire [ 63: 0] sq10_sell_price ;
 wire [ 63: 0] sq11_sell_price ;
 wire [ 63: 0] sq12_sell_price ;
 wire [ 63: 0] sq13_sell_price ;
 wire [ 63: 0] sq14_sell_price ;
 wire [ 63: 0] sq15_sell_price ;
 wire [ 63: 0] sq16_sell_price ;
 wire [ 63: 0] sq17_sell_price ;
 wire [ 63: 0] sq18_sell_price ;
 wire [ 63: 0] sq19_sell_price ;
 wire [ 63: 0] sq20_sell_price ;
 wire [ 63: 0] sq21_sell_price ;
 wire [ 63: 0] sq22_sell_price ;
 wire [ 63: 0] sq23_sell_price ;
 wire [ 63: 0] sq24_sell_price ;
 wire [ 63: 0] sq25_sell_price ;
 wire [ 63: 0] sq26_sell_price ;
 wire [ 63: 0] sq27_sell_price ;
 wire [ 63: 0] sq28_sell_price ;
 wire [ 63: 0] sq29_sell_price ;
 wire [ 63: 0] sq30_sell_price ;
 wire [ 63: 0] sq31_sell_price ;
 wire [ 31: 0] sq00_sell_quantity ;
 wire [ 31: 0] sq01_sell_quantity ;
 wire [ 31: 0] sq02_sell_quantity ;
 wire [ 31: 0] sq03_sell_quantity ;
 wire [ 31: 0] sq04_sell_quantity ;
 wire [ 31: 0] sq05_sell_quantity ;
 wire [ 31: 0] sq06_sell_quantity ;
 wire [ 31: 0] sq07_sell_quantity ;
 wire [ 31: 0] sq08_sell_quantity ;
 wire [ 31: 0] sq09_sell_quantity ;
 wire [ 31: 0] sq10_sell_quantity ;
 wire [ 31: 0] sq11_sell_quantity ;
 wire [ 31: 0] sq12_sell_quantity ;
 wire [ 31: 0] sq13_sell_quantity ;
 wire [ 31: 0] sq14_sell_quantity ;
 wire [ 31: 0] sq15_sell_quantity ;
 wire [ 31: 0] sq16_sell_quantity ;
 wire [ 31: 0] sq17_sell_quantity ;
 wire [ 31: 0] sq18_sell_quantity ;
 wire [ 31: 0] sq19_sell_quantity ;
 wire [ 31: 0] sq20_sell_quantity ;
 wire [ 31: 0] sq21_sell_quantity ;
 wire [ 31: 0] sq22_sell_quantity ;
 wire [ 31: 0] sq23_sell_quantity ;
 wire [ 31: 0] sq24_sell_quantity ;
 wire [ 31: 0] sq25_sell_quantity ;
 wire [ 31: 0] sq26_sell_quantity ;
 wire [ 31: 0] sq27_sell_quantity ;
 wire [ 31: 0] sq28_sell_quantity ;
 wire [ 31: 0] sq29_sell_quantity ;
 wire [ 31: 0] sq30_sell_quantity ;
 wire [ 31: 0] sq31_sell_quantity ;
 wire sq00_market_rdy ;
 wire sq01_market_rdy ;
 wire sq02_market_rdy ;
 wire sq03_market_rdy ;
 wire sq04_market_rdy ;
 wire sq05_market_rdy ;
 wire sq06_market_rdy ;
 wire sq07_market_rdy ;
 wire sq08_market_rdy ;
 wire sq09_market_rdy ;
 wire sq10_market_rdy ;
 wire sq11_market_rdy ;
 wire sq12_market_rdy ;
 wire sq13_market_rdy ;
 wire sq14_market_rdy ;
 wire sq15_market_rdy ;
 wire sq16_market_rdy ;
 wire sq17_market_rdy ;
 wire sq18_market_rdy ;
 wire sq19_market_rdy ;
 wire sq20_market_rdy ;
 wire sq21_market_rdy ;
 wire sq22_market_rdy ;
 wire sq23_market_rdy ;
 wire sq24_market_rdy ;
 wire sq25_market_rdy ;
 wire sq26_market_rdy ;
 wire sq27_market_rdy ;
 wire sq28_market_rdy ;
 wire sq29_market_rdy ;
 wire sq30_market_rdy ;
 wire sq31_market_rdy ;
 wire [ 15: 0] sq_cut_len_reg ;
 wire sq_shift_full_flag ;
 wire [31:0] current_cut_now_sqid_reg_vld ;
 wire [31:0] current_cut_done_sq00id_reg ;
 wire [31:0] current_cut_done_sq01id_reg ;
 wire [31:0] current_cut_done_sq02id_reg ;
 wire [31:0] current_cut_done_sq03id_reg ;
 wire [31:0] current_cut_done_sq04id_reg ;
 wire [31:0] current_cut_done_sq05id_reg ;
 wire [31:0] current_cut_done_sq06id_reg ;
 wire [31:0] current_cut_done_sq07id_reg ;
 wire [31:0] current_cut_done_sq08id_reg ;
 wire [31:0] current_cut_done_sq09id_reg ;
 wire [31:0] current_cut_done_sq10id_reg ;
 wire [31:0] current_cut_done_sq11id_reg ;
 wire [31:0] current_cut_done_sq12id_reg ;
 wire [31:0] current_cut_done_sq13id_reg ;
 wire [31:0] current_cut_done_sq14id_reg ;
 wire [31:0] current_cut_done_sq15id_reg ;
 wire [31:0] current_cut_done_sq16id_reg ;
 wire [31:0] current_cut_done_sq17id_reg ;
 wire [31:0] current_cut_done_sq18id_reg ;
 wire [31:0] current_cut_done_sq19id_reg ;
 wire [31:0] current_cut_done_sq20id_reg ;
 wire [31:0] current_cut_done_sq21id_reg ;
 wire [31:0] current_cut_done_sq22id_reg ;
 wire [31:0] current_cut_done_sq23id_reg ;
 wire [31:0] current_cut_done_sq24id_reg ;
 wire [31:0] current_cut_done_sq25id_reg ;
 wire [31:0] current_cut_done_sq26id_reg ;
 wire [31:0] current_cut_done_sq27id_reg ;
 wire [31:0] current_cut_done_sq28id_reg ;
 wire [31:0] current_cut_done_sq29id_reg ;
 wire [31:0] current_cut_done_sq30id_reg ;
 wire [31:0] current_cut_done_sq31id_reg ;
 wire [31:0] current_sqcut_done ;
 wire [15:0] sub_sqcut_len_reg ;
 wire [31:0] sq_cut_on ;
 wire [31:0] sq_cut_first_on ;
 wire st_rx_start_dly ;
 wire [ 3:0] st_rx_offset_dly ;
 wire st_rx_end_dly ;
 wire st_rx_valid_dly ;
 wire [63:0] st_rx_data_dly ;
 wire [ 2:0] st_rx_empty_dly ;
 wire [15:0] st_rx_cnt_dly ;
 wire [15:0] first_sync_len_byte_dly;
 wire [31:0] tcp_sqmatch_flag_dly ;
 wire seq_err_flag_dly ;
 wire tcp_sqmatch_flag_1bit_dly ;
 wire [15:0] tcp_payload_len_dly ;
 wire [15:0] sq00_cut_len_reg ;
 wire [15:0] sq01_cut_len_reg ;
 wire [15:0] sq02_cut_len_reg ;
 wire [15:0] sq03_cut_len_reg ;
 wire [15:0] sq04_cut_len_reg ;
 wire [15:0] sq05_cut_len_reg ;
 wire [15:0] sq06_cut_len_reg ;
 wire [15:0] sq07_cut_len_reg ;
 wire [15:0] sq08_cut_len_reg ;
 wire [15:0] sq09_cut_len_reg ;
 wire [15:0] sq10_cut_len_reg ;
 wire [15:0] sq11_cut_len_reg ;
 wire [15:0] sq12_cut_len_reg ;
 wire [15:0] sq13_cut_len_reg ;
 wire [15:0] sq14_cut_len_reg ;
 wire [15:0] sq15_cut_len_reg ;
 wire [15:0] sq16_cut_len_reg ;
 wire [15:0] sq17_cut_len_reg ;
 wire [15:0] sq18_cut_len_reg ;
 wire [15:0] sq19_cut_len_reg ;
 wire [15:0] sq20_cut_len_reg ;
 wire [15:0] sq21_cut_len_reg ;
 wire [15:0] sq22_cut_len_reg ;
 wire [15:0] sq23_cut_len_reg ;
 wire [15:0] sq24_cut_len_reg ;
 wire [15:0] sq25_cut_len_reg ;
 wire [15:0] sq26_cut_len_reg ;
 wire [15:0] sq27_cut_len_reg ;
 wire [15:0] sq28_cut_len_reg ;
 wire [15:0] sq29_cut_len_reg ;
 wire [15:0] sq30_cut_len_reg ;
 wire [15:0] sq31_cut_len_reg ;
 wire current_sqid_reg_flag ;
 output [3:0] debug_discard_calc_cnt1 ;
 output debug_st_shift_full_flag ;
 output [5:0] debug_st_shift_scnt ;
 output debug_st_shift_en ;
 output [15:0] st_rx_cnt_reg ;
 output [ 5:0] st_shift_ccnt ;
 wire [3:0] debug_discard_calc_cnt1 ;
 wire debug_st_shift_full_flag ;
 wire [5:0] debug_st_shift_scnt ;
 wire debug_st_shift_en ;
 wire [15:0] st_rx_cnt_reg ;
 wire [ 5:0] st_shift_ccnt ;
 wire [15:0] sync_len_byte ;
 wire sq_frame_flag ;
 wire [ 15:0] sync_fisrt_byte ;
 wire [ 31:0] sync_four_byte ;
 wire sq00_shift_full_flag ;
 wire sq01_shift_full_flag ;
 wire sq02_shift_full_flag ;
 wire sq03_shift_full_flag ;
 wire sq04_shift_full_flag ;
 wire sq05_shift_full_flag ;
 wire sq06_shift_full_flag ;
 wire sq07_shift_full_flag ;
 wire sq08_shift_full_flag ;
 wire sq09_shift_full_flag ;
 wire sq10_shift_full_flag ;
 wire sq11_shift_full_flag ;
 wire sq12_shift_full_flag ;
 wire sq13_shift_full_flag ;
 wire sq14_shift_full_flag ;
 wire sq15_shift_full_flag ;
 wire sq16_shift_full_flag ;
 wire sq17_shift_full_flag ;
 wire sq18_shift_full_flag ;
 wire sq19_shift_full_flag ;
 wire sq20_shift_full_flag ;
 wire sq21_shift_full_flag ;
 wire sq22_shift_full_flag ;
 wire sq23_shift_full_flag ;
 wire sq24_shift_full_flag ;
 wire sq25_shift_full_flag ;
 wire sq26_shift_full_flag ;
 wire sq27_shift_full_flag ;
 wire sq28_shift_full_flag ;
 wire sq29_shift_full_flag ;
 wire sq30_shift_full_flag ;
 wire sq31_shift_full_flag ;
 wire [31:0] sq_market_rdy ;
 assign sq_market_rdy[ 0] = sq00_market_rdy ;
 assign sq_market_rdy[ 1] = sq01_market_rdy ;
 assign sq_market_rdy[ 2] = sq02_market_rdy ;
 assign sq_market_rdy[ 3] = sq03_market_rdy ;
 assign sq_market_rdy[ 4] = sq04_market_rdy ;
 assign sq_market_rdy[ 5] = sq05_market_rdy ;
 assign sq_market_rdy[ 6] = sq06_market_rdy ;
 assign sq_market_rdy[ 7] = sq07_market_rdy ;
 assign sq_market_rdy[ 8] = sq08_market_rdy ;
 assign sq_market_rdy[ 9] = sq09_market_rdy ;
 assign sq_market_rdy[10] = sq10_market_rdy ;
 assign sq_market_rdy[11] = sq11_market_rdy ;
 assign sq_market_rdy[12] = sq12_market_rdy ;
 assign sq_market_rdy[13] = sq13_market_rdy ;
 assign sq_market_rdy[14] = sq14_market_rdy ;
 assign sq_market_rdy[15] = sq15_market_rdy ;
 assign sq_market_rdy[16] = sq16_market_rdy ;
 assign sq_market_rdy[17] = sq17_market_rdy ;
 assign sq_market_rdy[18] = sq18_market_rdy ;
 assign sq_market_rdy[19] = sq19_market_rdy ;
 assign sq_market_rdy[20] = sq20_market_rdy ;
 assign sq_market_rdy[21] = sq21_market_rdy ;
 assign sq_market_rdy[22] = sq22_market_rdy ;
 assign sq_market_rdy[23] = sq23_market_rdy ;
 assign sq_market_rdy[24] = sq24_market_rdy ;
 assign sq_market_rdy[25] = sq25_market_rdy ;
 assign sq_market_rdy[26] = sq26_market_rdy ;
 assign sq_market_rdy[27] = sq27_market_rdy ;
 assign sq_market_rdy[28] = sq28_market_rdy ;
 assign sq_market_rdy[29] = sq29_market_rdy ;
 assign sq_market_rdy[30] = sq30_market_rdy ;
 assign sq_market_rdy[31] = sq31_market_rdy ;
 assign sq_shift_full_flag = sq00_shift_full_flag || sq01_shift_full_flag || sq02_shift_full_flag || sq03_shift_full_flag || sq04_shift_full_flag || sq05_shift_full_flag || sq06_shift_full_flag || sq07_shift_full_flag || sq08_shift_full_flag || sq09_shift_full_flag || sq10_shift_full_flag || sq11_shift_full_flag || sq12_shift_full_flag || sq13_shift_full_flag || sq14_shift_full_flag || sq15_shift_full_flag || sq16_shift_full_flag || sq17_shift_full_flag || sq18_shift_full_flag || sq19_shift_full_flag || sq20_shift_full_flag || sq21_shift_full_flag || sq22_shift_full_flag || sq23_shift_full_flag || sq24_shift_full_flag || sq25_shift_full_flag || sq26_shift_full_flag || sq27_shift_full_flag || sq28_shift_full_flag || sq29_shift_full_flag || sq30_shift_full_flag || sq31_shift_full_flag ;
 filter_rx_fsm filter_rx_fsm ( .clk ( clk ) , .rst_n ( rst_n ) , .params_current_sqid_reg_add (params_current_sqid_reg_add), .params_current_sqid_reg_cnt (params_current_sqid_reg_cnt), .params_current_sqid_reg_rst_cnt(params_current_sqid_reg_rst_cnt), .sq_market_rdy (sq_market_rdy ) , .debug_discard_calc_cnt1 (debug_discard_calc_cnt1), .debug_st_shift_full_flag(debug_st_shift_full_flag), .debug_st_shift_scnt(debug_st_shift_scnt) , .debug_st_shift_en (debug_st_shift_en) , .fir_rx_cstate (fir_rx_cstate ), .st_rx_cnt_reg (st_rx_cnt_reg ), .st_shift_ccnt (st_shift_ccnt ), .sync_len_byte (sync_len_byte ), .sync_fisrt_byte (sync_fisrt_byte), .sync_four_byte (sync_four_byte), .sq_frame_flag (sq_frame_flag ), .params_frame_type_byte (params_frame_type_byte ), .params_current_sqid_reg_ro (params_current_sqid_reg_ro), .params_filter_rst (params_filter_rst), .params_03e9_type (params_03e9_type), .params_1389_type (params_1389_type), .params_07d0_type (params_07d0_type), .sub_sqcut_len_reg (sub_sqcut_len_reg ), .current_sqid_reg_flag (current_sqid_reg_flag ), .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld), .current_cut_done_sq00id_reg (current_cut_done_sq00id_reg), .current_cut_done_sq01id_reg (current_cut_done_sq01id_reg), .current_cut_done_sq02id_reg (current_cut_done_sq02id_reg), .current_cut_done_sq03id_reg (current_cut_done_sq03id_reg), .current_cut_done_sq04id_reg (current_cut_done_sq04id_reg), .current_cut_done_sq05id_reg (current_cut_done_sq05id_reg), .current_cut_done_sq06id_reg (current_cut_done_sq06id_reg), .current_cut_done_sq07id_reg (current_cut_done_sq07id_reg), .current_cut_done_sq08id_reg (current_cut_done_sq08id_reg), .current_cut_done_sq09id_reg (current_cut_done_sq09id_reg), .current_cut_done_sq10id_reg (current_cut_done_sq10id_reg), .current_cut_done_sq11id_reg (current_cut_done_sq11id_reg), .current_cut_done_sq12id_reg (current_cut_done_sq12id_reg), .current_cut_done_sq13id_reg (current_cut_done_sq13id_reg), .current_cut_done_sq14id_reg (current_cut_done_sq14id_reg), .current_cut_done_sq15id_reg (current_cut_done_sq15id_reg), .current_cut_done_sq16id_reg (current_cut_done_sq16id_reg), .current_cut_done_sq17id_reg (current_cut_done_sq17id_reg), .current_cut_done_sq18id_reg (current_cut_done_sq18id_reg), .current_cut_done_sq19id_reg (current_cut_done_sq19id_reg), .current_cut_done_sq20id_reg (current_cut_done_sq20id_reg), .current_cut_done_sq21id_reg (current_cut_done_sq21id_reg), .current_cut_done_sq22id_reg (current_cut_done_sq22id_reg), .current_cut_done_sq23id_reg (current_cut_done_sq23id_reg), .current_cut_done_sq24id_reg (current_cut_done_sq24id_reg), .current_cut_done_sq25id_reg (current_cut_done_sq25id_reg), .current_cut_done_sq26id_reg (current_cut_done_sq26id_reg), .current_cut_done_sq27id_reg (current_cut_done_sq27id_reg), .current_cut_done_sq28id_reg (current_cut_done_sq28id_reg), .current_cut_done_sq29id_reg (current_cut_done_sq29id_reg), .current_cut_done_sq30id_reg (current_cut_done_sq30id_reg), .current_cut_done_sq31id_reg (current_cut_done_sq31id_reg), .current_sqcut_done (current_sqcut_done ), .sq_cut_on_reg (sq_cut_on ), .sq_cut_first_on (sq_cut_first_on ), .st_rx_start_pre ( st_rx_start&&st_rx_valid ) , .st_rx_start ( st_rx_start_dly ) , .st_rx_offset ( st_rx_offset_dly ) , .st_rx_end ( st_rx_end_dly ) , .st_rx_valid ( st_rx_valid_dly ) , .st_rx_ready ( st_rx_ready ) , .st_rx_data ( st_rx_data_dly ) , .st_rx_empty ( st_rx_empty_dly ) , .st_rx_cnt ( st_rx_cnt_dly ) , .first_sync_len_byte ( first_sync_len_byte_dly ) , .tcp_sqmatch_flag ( tcp_sqmatch_flag_1bit_dly ) , .tcp_sqmatch_flag_reg ( tcp_sqmatch_flag_dly ) , .tcp_payload_len ( tcp_payload_len_dly ) , .seq_err_flag (seq_err_flag_dly ) , .error_flag ( error_flag ) , .fir_r_idle_st ( fir_r_idle_st ) , .fir_r_sqcuth_st (fir_r_sqcuth_st ) , .fir_r_vsync_st (fir_r_vsync_st ) , .fir_r_sqcut_st (fir_r_sqcut_st ) , .fir_r_sqcut_end_st (fir_r_sqcut_end_st ) , .fir_r_sqrcut_st (fir_r_sqrcut_st ) , .fir_r_sqrcut_end_st (fir_r_sqrcut_end_st ) , .fir_r_rjudge_st (fir_r_rjudge_st ) , .sq_rx_start ( sq_rx_start ) , .sq_rx_end ( sq_rx_end ) , .sq_rx_valid ( sq_rx_valid ) , .sq_rx_data ( sq_rx_data ) , .sq_rx_empty ( sq_rx_empty ) , .sq_rx_empty_01 ( sq_rx_empty_01 ) , .sq_rx_empty_02 ( sq_rx_empty_02 ) , .sq_rx_empty_03 ( sq_rx_empty_03 ) , .sq_rx_empty_04 ( sq_rx_empty_04 ) , .sq_rx_empty_05 ( sq_rx_empty_05 ) , .sq_rx_empty_06 ( sq_rx_empty_06 ) , .sq_rx_empty_07 ( sq_rx_empty_07 ) , .sq_rx_empty_08 ( sq_rx_empty_08 ) , .sq_rx_empty_09 ( sq_rx_empty_09 ) , .sq_rx_empty_10 ( sq_rx_empty_10 ) , .sq_rx_empty_11 ( sq_rx_empty_11 ) , .sq_rx_empty_12 ( sq_rx_empty_12 ) , .sq_rx_empty_13 ( sq_rx_empty_13 ) , .sq_rx_empty_14 ( sq_rx_empty_14 ) , .sq_rx_empty_15 ( sq_rx_empty_15 ) , .sq_rx_empty_16 ( sq_rx_empty_16 ) , .sq_rx_empty_17 ( sq_rx_empty_17 ) , .sq_rx_empty_18 ( sq_rx_empty_18 ) , .sq_rx_empty_19 ( sq_rx_empty_19 ) , .sq_rx_empty_20 ( sq_rx_empty_20 ) , .sq_rx_empty_21 ( sq_rx_empty_21 ) , .sq_rx_empty_22 ( sq_rx_empty_22 ) , .sq_rx_empty_23 ( sq_rx_empty_23 ) , .sq_rx_empty_24 ( sq_rx_empty_24 ) , .sq_rx_empty_25 ( sq_rx_empty_25 ) , .sq_rx_empty_26 ( sq_rx_empty_26 ) , .sq_rx_empty_27 ( sq_rx_empty_27 ) , .sq_rx_empty_28 ( sq_rx_empty_28 ) , .sq_rx_empty_29 ( sq_rx_empty_29 ) , .sq_rx_empty_30 ( sq_rx_empty_30 ) , .sq_rx_empty_31 ( sq_rx_empty_31 ) , .current_sqid_reg ( current_sqid_reg ) , .current_sqid_reg_vld (current_sqid_reg_vld) , .sq_shift_full_flag ( sq_shift_full_flag ) , .market_explain ( market_explain ) , .info_classify ( info_classify ) , .dialog_num ( dialog_num ) , .contract_flag ( contract_flag ) , .contract_num ( contract_num ) , .contract_code ( contract_code ) , .update_time ( update_time ) , .update_ms ( update_ms ) , .new_price ( new_price ) , .turnover ( turnover ) , .volume ( volume ) , .position ( position ) , .purchase_price ( purchase_price ) , .buy_quantity ( buy_quantity ) , .sell_price ( sell_price ) , .sell_quantity ( sell_quantity ) , .market_rdy ( market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_00 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq00id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[0] ), .current_sqcut_done ( current_sqcut_done[0] ) , .st_rx_start ( sq_rx_start[0] ) , .st_rx_end ( sq_rx_end[0] ) , .st_rx_valid ( sq_rx_valid[0] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[0] ) , .sq_cut_reset ( sq_cut_reset[0] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq00_shift_full_flag ) , .sq_cut_len_reg ( sq00_cut_len_reg ) , .market_explain ( sq00_market_explain ) , .info_classify ( sq00_info_classify ) , .dialog_num ( sq00_dialog_num ) , .contract_flag ( sq00_contract_flag ) , .contract_num ( sq00_contract_num ) , .contract_code ( sq00_contract_code ) , .update_time ( sq00_update_time ) , .update_ms ( sq00_update_ms ) , .new_price ( sq00_new_price ) , .turnover ( sq00_turnover ) , .volume ( sq00_volume ) , .position ( sq00_position ) , .purchase_price ( sq00_purchase_price ) , .buy_quantity ( sq00_buy_quantity ) , .sell_price ( sq00_sell_price ) , .sell_quantity ( sq00_sell_quantity ) , .market_rdy ( sq00_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_01 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq01id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[1] ), .current_sqcut_done ( current_sqcut_done[1] ) , .st_rx_start ( sq_rx_start[1] ) , .st_rx_end ( sq_rx_end[1] ) , .st_rx_valid ( sq_rx_valid[1] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[1] ) , .sq_cut_reset ( sq_cut_reset[1] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_01 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq01_shift_full_flag ) , .sq_cut_len_reg ( sq01_cut_len_reg ) , .market_explain ( sq01_market_explain ) , .info_classify ( sq01_info_classify ) , .dialog_num ( sq01_dialog_num ) , .contract_flag ( sq01_contract_flag ) , .contract_num ( sq01_contract_num ) , .contract_code ( sq01_contract_code ) , .update_time ( sq01_update_time ) , .update_ms ( sq01_update_ms ) , .new_price ( sq01_new_price ) , .turnover ( sq01_turnover ) , .volume ( sq01_volume ) , .position ( sq01_position ) , .purchase_price ( sq01_purchase_price ) , .buy_quantity ( sq01_buy_quantity ) , .sell_price ( sq01_sell_price ) , .sell_quantity ( sq01_sell_quantity ) , .market_rdy ( sq01_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_02 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq02id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[2] ), .current_sqcut_done ( current_sqcut_done[2] ) , .st_rx_start ( sq_rx_start[2] ) , .st_rx_end ( sq_rx_end[2] ) , .st_rx_valid ( sq_rx_valid[2] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[2] ) , .sq_cut_reset ( sq_cut_reset[2] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_02 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq02_shift_full_flag ) , .sq_cut_len_reg ( sq02_cut_len_reg ) , .market_explain ( sq02_market_explain ) , .info_classify ( sq02_info_classify ) , .dialog_num ( sq02_dialog_num ) , .contract_flag ( sq02_contract_flag ) , .contract_num ( sq02_contract_num ) , .contract_code ( sq02_contract_code ) , .update_time ( sq02_update_time ) , .update_ms ( sq02_update_ms ) , .new_price ( sq02_new_price ) , .turnover ( sq02_turnover ) , .volume ( sq02_volume ) , .position ( sq02_position ) , .purchase_price ( sq02_purchase_price ) , .buy_quantity ( sq02_buy_quantity ) , .sell_price ( sq02_sell_price ) , .sell_quantity ( sq02_sell_quantity ) , .market_rdy ( sq02_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_03 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq03id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[3] ), .current_sqcut_done ( current_sqcut_done[3] ) , .st_rx_start ( sq_rx_start[3] ) , .st_rx_end ( sq_rx_end[3] ) , .st_rx_valid ( sq_rx_valid[3] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[3] ) , .sq_cut_reset ( sq_cut_reset[3] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_03 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq03_shift_full_flag ) , .sq_cut_len_reg ( sq03_cut_len_reg ) , .market_explain ( sq03_market_explain ) , .info_classify ( sq03_info_classify ) , .dialog_num ( sq03_dialog_num ) , .contract_flag ( sq03_contract_flag ) , .contract_num ( sq03_contract_num ) , .contract_code ( sq03_contract_code ) , .update_time ( sq03_update_time ) , .update_ms ( sq03_update_ms ) , .new_price ( sq03_new_price ) , .turnover ( sq03_turnover ) , .volume ( sq03_volume ) , .position ( sq03_position ) , .purchase_price ( sq03_purchase_price ) , .buy_quantity ( sq03_buy_quantity ) , .sell_price ( sq03_sell_price ) , .sell_quantity ( sq03_sell_quantity ) , .market_rdy ( sq03_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_04 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq04id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[4] ), .current_sqcut_done ( current_sqcut_done[4] ) , .st_rx_start ( sq_rx_start[4] ) , .st_rx_end ( sq_rx_end[4] ) , .st_rx_valid ( sq_rx_valid[4] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[4] ) , .sq_cut_reset ( sq_cut_reset[4] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_04 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq04_shift_full_flag ) , .sq_cut_len_reg ( sq04_cut_len_reg ) , .market_explain ( sq04_market_explain ) , .info_classify ( sq04_info_classify ) , .dialog_num ( sq04_dialog_num ) , .contract_flag ( sq04_contract_flag ) , .contract_num ( sq04_contract_num ) , .contract_code ( sq04_contract_code ) , .update_time ( sq04_update_time ) , .update_ms ( sq04_update_ms ) , .new_price ( sq04_new_price ) , .turnover ( sq04_turnover ) , .volume ( sq04_volume ) , .position ( sq04_position ) , .purchase_price ( sq04_purchase_price ) , .buy_quantity ( sq04_buy_quantity ) , .sell_price ( sq04_sell_price ) , .sell_quantity ( sq04_sell_quantity ) , .market_rdy ( sq04_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_05 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq05id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[5] ), .current_sqcut_done ( current_sqcut_done[5] ) , .st_rx_start ( sq_rx_start[5] ) , .st_rx_end ( sq_rx_end[5] ) , .st_rx_valid ( sq_rx_valid[5] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[5] ) , .sq_cut_reset ( sq_cut_reset[5] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_05 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq05_shift_full_flag ) , .sq_cut_len_reg ( sq05_cut_len_reg ) , .market_explain ( sq05_market_explain ) , .info_classify ( sq05_info_classify ) , .dialog_num ( sq05_dialog_num ) , .contract_flag ( sq05_contract_flag ) , .contract_num ( sq05_contract_num ) , .contract_code ( sq05_contract_code ) , .update_time ( sq05_update_time ) , .update_ms ( sq05_update_ms ) , .new_price ( sq05_new_price ) , .turnover ( sq05_turnover ) , .volume ( sq05_volume ) , .position ( sq05_position ) , .purchase_price ( sq05_purchase_price ) , .buy_quantity ( sq05_buy_quantity ) , .sell_price ( sq05_sell_price ) , .sell_quantity ( sq05_sell_quantity ) , .market_rdy ( sq05_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_06 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq06id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[6] ), .current_sqcut_done ( current_sqcut_done[6] ) , .st_rx_start ( sq_rx_start[6] ) , .st_rx_end ( sq_rx_end[6] ) , .st_rx_valid ( sq_rx_valid[6] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[6] ) , .sq_cut_reset ( sq_cut_reset[6] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_06 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq06_shift_full_flag ) , .sq_cut_len_reg ( sq06_cut_len_reg ) , .market_explain ( sq06_market_explain ) , .info_classify ( sq06_info_classify ) , .dialog_num ( sq06_dialog_num ) , .contract_flag ( sq06_contract_flag ) , .contract_num ( sq06_contract_num ) , .contract_code ( sq06_contract_code ) , .update_time ( sq06_update_time ) , .update_ms ( sq06_update_ms ) , .new_price ( sq06_new_price ) , .turnover ( sq06_turnover ) , .volume ( sq06_volume ) , .position ( sq06_position ) , .purchase_price ( sq06_purchase_price ) , .buy_quantity ( sq06_buy_quantity ) , .sell_price ( sq06_sell_price ) , .sell_quantity ( sq06_sell_quantity ) , .market_rdy ( sq06_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_07 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq07id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[7] ), .current_sqcut_done ( current_sqcut_done[7] ) , .st_rx_start ( sq_rx_start[7] ) , .st_rx_end ( sq_rx_end[7] ) , .st_rx_valid ( sq_rx_valid[7] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[7] ) , .sq_cut_reset ( sq_cut_reset[7] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_07 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq07_shift_full_flag ) , .sq_cut_len_reg ( sq07_cut_len_reg ) , .market_explain ( sq07_market_explain ) , .info_classify ( sq07_info_classify ) , .dialog_num ( sq07_dialog_num ) , .contract_flag ( sq07_contract_flag ) , .contract_num ( sq07_contract_num ) , .contract_code ( sq07_contract_code ) , .update_time ( sq07_update_time ) , .update_ms ( sq07_update_ms ) , .new_price ( sq07_new_price ) , .turnover ( sq07_turnover ) , .volume ( sq07_volume ) , .position ( sq07_position ) , .purchase_price ( sq07_purchase_price ) , .buy_quantity ( sq07_buy_quantity ) , .sell_price ( sq07_sell_price ) , .sell_quantity ( sq07_sell_quantity ) , .market_rdy ( sq07_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_08 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq08id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[8] ), .current_sqcut_done ( current_sqcut_done[8] ) , .st_rx_start ( sq_rx_start[8] ) , .st_rx_end ( sq_rx_end[8] ) , .st_rx_valid ( sq_rx_valid[8] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[8] ) , .sq_cut_reset ( sq_cut_reset[8] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_08 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq08_shift_full_flag ) , .sq_cut_len_reg ( sq08_cut_len_reg ) , .market_explain ( sq08_market_explain ) , .info_classify ( sq08_info_classify ) , .dialog_num ( sq08_dialog_num ) , .contract_flag ( sq08_contract_flag ) , .contract_num ( sq08_contract_num ) , .contract_code ( sq08_contract_code ) , .update_time ( sq08_update_time ) , .update_ms ( sq08_update_ms ) , .new_price ( sq08_new_price ) , .turnover ( sq08_turnover ) , .volume ( sq08_volume ) , .position ( sq08_position ) , .purchase_price ( sq08_purchase_price ) , .buy_quantity ( sq08_buy_quantity ) , .sell_price ( sq08_sell_price ) , .sell_quantity ( sq08_sell_quantity ) , .market_rdy ( sq08_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_09 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq09id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[9] ), .current_sqcut_done ( current_sqcut_done[9] ) , .st_rx_start ( sq_rx_start[9] ) , .st_rx_end ( sq_rx_end[9] ) , .st_rx_valid ( sq_rx_valid[9] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[9] ) , .sq_cut_reset ( sq_cut_reset[9] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_09 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq09_shift_full_flag ) , .sq_cut_len_reg ( sq09_cut_len_reg ) , .market_explain ( sq09_market_explain ) , .info_classify ( sq09_info_classify ) , .dialog_num ( sq09_dialog_num ) , .contract_flag ( sq09_contract_flag ) , .contract_num ( sq09_contract_num ) , .contract_code ( sq09_contract_code ) , .update_time ( sq09_update_time ) , .update_ms ( sq09_update_ms ) , .new_price ( sq09_new_price ) , .turnover ( sq09_turnover ) , .volume ( sq09_volume ) , .position ( sq09_position ) , .purchase_price ( sq09_purchase_price ) , .buy_quantity ( sq09_buy_quantity ) , .sell_price ( sq09_sell_price ) , .sell_quantity ( sq09_sell_quantity ) , .market_rdy ( sq09_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_10 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq10id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[10] ), .current_sqcut_done ( current_sqcut_done[10] ) , .st_rx_start ( sq_rx_start[10] ) , .st_rx_end ( sq_rx_end[10] ) , .st_rx_valid ( sq_rx_valid[10] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[10] ) , .sq_cut_reset ( sq_cut_reset[10] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_10 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq10_shift_full_flag ) , .sq_cut_len_reg ( sq10_cut_len_reg ) , .market_explain ( sq10_market_explain ) , .info_classify ( sq10_info_classify ) , .dialog_num ( sq10_dialog_num ) , .contract_flag ( sq10_contract_flag ) , .contract_num ( sq10_contract_num ) , .contract_code ( sq10_contract_code ) , .update_time ( sq10_update_time ) , .update_ms ( sq10_update_ms ) , .new_price ( sq10_new_price ) , .turnover ( sq10_turnover ) , .volume ( sq10_volume ) , .position ( sq10_position ) , .purchase_price ( sq10_purchase_price ) , .buy_quantity ( sq10_buy_quantity ) , .sell_price ( sq10_sell_price ) , .sell_quantity ( sq10_sell_quantity ) , .market_rdy ( sq10_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_11 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq11id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[11] ), .current_sqcut_done ( current_sqcut_done[11] ) , .st_rx_start ( sq_rx_start[11] ) , .st_rx_end ( sq_rx_end[11] ) , .st_rx_valid ( sq_rx_valid[11] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[11] ) , .sq_cut_reset ( sq_cut_reset[11] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_11 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq11_shift_full_flag ) , .sq_cut_len_reg ( sq11_cut_len_reg ) , .market_explain ( sq11_market_explain ) , .info_classify ( sq11_info_classify ) , .dialog_num ( sq11_dialog_num ) , .contract_flag ( sq11_contract_flag ) , .contract_num ( sq11_contract_num ) , .contract_code ( sq11_contract_code ) , .update_time ( sq11_update_time ) , .update_ms ( sq11_update_ms ) , .new_price ( sq11_new_price ) , .turnover ( sq11_turnover ) , .volume ( sq11_volume ) , .position ( sq11_position ) , .purchase_price ( sq11_purchase_price ) , .buy_quantity ( sq11_buy_quantity ) , .sell_price ( sq11_sell_price ) , .sell_quantity ( sq11_sell_quantity ) , .market_rdy ( sq11_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_12 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq12id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[12] ), .current_sqcut_done ( current_sqcut_done[12] ) , .st_rx_start ( sq_rx_start[12] ) , .st_rx_end ( sq_rx_end[12] ) , .st_rx_valid ( sq_rx_valid[12] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[12] ) , .sq_cut_reset ( sq_cut_reset[12] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_12 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq12_shift_full_flag ) , .sq_cut_len_reg ( sq12_cut_len_reg ) , .market_explain ( sq12_market_explain ) , .info_classify ( sq12_info_classify ) , .dialog_num ( sq12_dialog_num ) , .contract_flag ( sq12_contract_flag ) , .contract_num ( sq12_contract_num ) , .contract_code ( sq12_contract_code ) , .update_time ( sq12_update_time ) , .update_ms ( sq12_update_ms ) , .new_price ( sq12_new_price ) , .turnover ( sq12_turnover ) , .volume ( sq12_volume ) , .position ( sq12_position ) , .purchase_price ( sq12_purchase_price ) , .buy_quantity ( sq12_buy_quantity ) , .sell_price ( sq12_sell_price ) , .sell_quantity ( sq12_sell_quantity ) , .market_rdy ( sq12_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_13 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq13id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[13] ), .current_sqcut_done ( current_sqcut_done[13] ) , .st_rx_start ( sq_rx_start[13] ) , .st_rx_end ( sq_rx_end[13] ) , .st_rx_valid ( sq_rx_valid[13] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[13] ) , .sq_cut_reset ( sq_cut_reset[13] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_13 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq13_shift_full_flag ) , .sq_cut_len_reg ( sq13_cut_len_reg ) , .market_explain ( sq13_market_explain ) , .info_classify ( sq13_info_classify ) , .dialog_num ( sq13_dialog_num ) , .contract_flag ( sq13_contract_flag ) , .contract_num ( sq13_contract_num ) , .contract_code ( sq13_contract_code ) , .update_time ( sq13_update_time ) , .update_ms ( sq13_update_ms ) , .new_price ( sq13_new_price ) , .turnover ( sq13_turnover ) , .volume ( sq13_volume ) , .position ( sq13_position ) , .purchase_price ( sq13_purchase_price ) , .buy_quantity ( sq13_buy_quantity ) , .sell_price ( sq13_sell_price ) , .sell_quantity ( sq13_sell_quantity ) , .market_rdy ( sq13_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_14 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq14id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[14] ), .current_sqcut_done ( current_sqcut_done[14] ) , .st_rx_start ( sq_rx_start[14] ) , .st_rx_end ( sq_rx_end[14] ) , .st_rx_valid ( sq_rx_valid[14] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[14] ) , .sq_cut_reset ( sq_cut_reset[14] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_14 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq14_shift_full_flag ) , .sq_cut_len_reg ( sq14_cut_len_reg ) , .market_explain ( sq14_market_explain ) , .info_classify ( sq14_info_classify ) , .dialog_num ( sq14_dialog_num ) , .contract_flag ( sq14_contract_flag ) , .contract_num ( sq14_contract_num ) , .contract_code ( sq14_contract_code ) , .update_time ( sq14_update_time ) , .update_ms ( sq14_update_ms ) , .new_price ( sq14_new_price ) , .turnover ( sq14_turnover ) , .volume ( sq14_volume ) , .position ( sq14_position ) , .purchase_price ( sq14_purchase_price ) , .buy_quantity ( sq14_buy_quantity ) , .sell_price ( sq14_sell_price ) , .sell_quantity ( sq14_sell_quantity ) , .market_rdy ( sq14_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_15 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq15id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[15] ), .current_sqcut_done ( current_sqcut_done[15] ) , .st_rx_start ( sq_rx_start[15] ) , .st_rx_end ( sq_rx_end[15] ) , .st_rx_valid ( sq_rx_valid[15] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[15] ) , .sq_cut_reset ( sq_cut_reset[15] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_15 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq15_shift_full_flag ) , .sq_cut_len_reg ( sq15_cut_len_reg ) , .market_explain ( sq15_market_explain ) , .info_classify ( sq15_info_classify ) , .dialog_num ( sq15_dialog_num ) , .contract_flag ( sq15_contract_flag ) , .contract_num ( sq15_contract_num ) , .contract_code ( sq15_contract_code ) , .update_time ( sq15_update_time ) , .update_ms ( sq15_update_ms ) , .new_price ( sq15_new_price ) , .turnover ( sq15_turnover ) , .volume ( sq15_volume ) , .position ( sq15_position ) , .purchase_price ( sq15_purchase_price ) , .buy_quantity ( sq15_buy_quantity ) , .sell_price ( sq15_sell_price ) , .sell_quantity ( sq15_sell_quantity ) , .market_rdy ( sq15_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_16 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq16id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[16] ), .current_sqcut_done ( current_sqcut_done[16] ) , .st_rx_start ( sq_rx_start[16] ) , .st_rx_end ( sq_rx_end[16] ) , .st_rx_valid ( sq_rx_valid[16] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[16] ) , .sq_cut_reset ( sq_cut_reset[16] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_16 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq16_shift_full_flag ) , .sq_cut_len_reg ( sq16_cut_len_reg ) , .market_explain ( sq16_market_explain ) , .info_classify ( sq16_info_classify ) , .dialog_num ( sq16_dialog_num ) , .contract_flag ( sq16_contract_flag ) , .contract_num ( sq16_contract_num ) , .contract_code ( sq16_contract_code ) , .update_time ( sq16_update_time ) , .update_ms ( sq16_update_ms ) , .new_price ( sq16_new_price ) , .turnover ( sq16_turnover ) , .volume ( sq16_volume ) , .position ( sq16_position ) , .purchase_price ( sq16_purchase_price ) , .buy_quantity ( sq16_buy_quantity ) , .sell_price ( sq16_sell_price ) , .sell_quantity ( sq16_sell_quantity ) , .market_rdy ( sq16_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_17 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq17id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[17] ), .current_sqcut_done ( current_sqcut_done[17] ) , .st_rx_start ( sq_rx_start[17] ) , .st_rx_end ( sq_rx_end[17] ) , .st_rx_valid ( sq_rx_valid[17] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[17] ) , .sq_cut_reset ( sq_cut_reset[17] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_17 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq17_shift_full_flag ) , .sq_cut_len_reg ( sq17_cut_len_reg ) , .market_explain ( sq17_market_explain ) , .info_classify ( sq17_info_classify ) , .dialog_num ( sq17_dialog_num ) , .contract_flag ( sq17_contract_flag ) , .contract_num ( sq17_contract_num ) , .contract_code ( sq17_contract_code ) , .update_time ( sq17_update_time ) , .update_ms ( sq17_update_ms ) , .new_price ( sq17_new_price ) , .turnover ( sq17_turnover ) , .volume ( sq17_volume ) , .position ( sq17_position ) , .purchase_price ( sq17_purchase_price ) , .buy_quantity ( sq17_buy_quantity ) , .sell_price ( sq17_sell_price ) , .sell_quantity ( sq17_sell_quantity ) , .market_rdy ( sq17_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_18 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq18id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[18] ), .current_sqcut_done ( current_sqcut_done[18] ) , .st_rx_start ( sq_rx_start[18] ) , .st_rx_end ( sq_rx_end[18] ) , .st_rx_valid ( sq_rx_valid[18] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[18] ) , .sq_cut_reset ( sq_cut_reset[18] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_18 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq18_shift_full_flag ) , .sq_cut_len_reg ( sq18_cut_len_reg ) , .market_explain ( sq18_market_explain ) , .info_classify ( sq18_info_classify ) , .dialog_num ( sq18_dialog_num ) , .contract_flag ( sq18_contract_flag ) , .contract_num ( sq18_contract_num ) , .contract_code ( sq18_contract_code ) , .update_time ( sq18_update_time ) , .update_ms ( sq18_update_ms ) , .new_price ( sq18_new_price ) , .turnover ( sq18_turnover ) , .volume ( sq18_volume ) , .position ( sq18_position ) , .purchase_price ( sq18_purchase_price ) , .buy_quantity ( sq18_buy_quantity ) , .sell_price ( sq18_sell_price ) , .sell_quantity ( sq18_sell_quantity ) , .market_rdy ( sq18_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_19 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq19id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[19] ), .current_sqcut_done ( current_sqcut_done[19] ) , .st_rx_start ( sq_rx_start[19] ) , .st_rx_end ( sq_rx_end[19] ) , .st_rx_valid ( sq_rx_valid[19] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[19] ) , .sq_cut_reset ( sq_cut_reset[19] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_19 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq19_shift_full_flag ) , .sq_cut_len_reg ( sq19_cut_len_reg ) , .market_explain ( sq19_market_explain ) , .info_classify ( sq19_info_classify ) , .dialog_num ( sq19_dialog_num ) , .contract_flag ( sq19_contract_flag ) , .contract_num ( sq19_contract_num ) , .contract_code ( sq19_contract_code ) , .update_time ( sq19_update_time ) , .update_ms ( sq19_update_ms ) , .new_price ( sq19_new_price ) , .turnover ( sq19_turnover ) , .volume ( sq19_volume ) , .position ( sq19_position ) , .purchase_price ( sq19_purchase_price ) , .buy_quantity ( sq19_buy_quantity ) , .sell_price ( sq19_sell_price ) , .sell_quantity ( sq19_sell_quantity ) , .market_rdy ( sq19_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_20 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq20id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[20] ), .current_sqcut_done ( current_sqcut_done[20] ) , .st_rx_start ( sq_rx_start[20] ) , .st_rx_end ( sq_rx_end[20] ) , .st_rx_valid ( sq_rx_valid[20] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[20] ) , .sq_cut_reset ( sq_cut_reset[20] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_20 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq20_shift_full_flag ) , .sq_cut_len_reg ( sq20_cut_len_reg ) , .market_explain ( sq20_market_explain ) , .info_classify ( sq20_info_classify ) , .dialog_num ( sq20_dialog_num ) , .contract_flag ( sq20_contract_flag ) , .contract_num ( sq20_contract_num ) , .contract_code ( sq20_contract_code ) , .update_time ( sq20_update_time ) , .update_ms ( sq20_update_ms ) , .new_price ( sq20_new_price ) , .turnover ( sq20_turnover ) , .volume ( sq20_volume ) , .position ( sq20_position ) , .purchase_price ( sq20_purchase_price ) , .buy_quantity ( sq20_buy_quantity ) , .sell_price ( sq20_sell_price ) , .sell_quantity ( sq20_sell_quantity ) , .market_rdy ( sq20_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_21 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq21id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[21] ), .current_sqcut_done ( current_sqcut_done[21] ) , .st_rx_start ( sq_rx_start[21] ) , .st_rx_end ( sq_rx_end[21] ) , .st_rx_valid ( sq_rx_valid[21] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[21] ) , .sq_cut_reset ( sq_cut_reset[21] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_21 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq21_shift_full_flag ) , .sq_cut_len_reg ( sq21_cut_len_reg ) , .market_explain ( sq21_market_explain ) , .info_classify ( sq21_info_classify ) , .dialog_num ( sq21_dialog_num ) , .contract_flag ( sq21_contract_flag ) , .contract_num ( sq21_contract_num ) , .contract_code ( sq21_contract_code ) , .update_time ( sq21_update_time ) , .update_ms ( sq21_update_ms ) , .new_price ( sq21_new_price ) , .turnover ( sq21_turnover ) , .volume ( sq21_volume ) , .position ( sq21_position ) , .purchase_price ( sq21_purchase_price ) , .buy_quantity ( sq21_buy_quantity ) , .sell_price ( sq21_sell_price ) , .sell_quantity ( sq21_sell_quantity ) , .market_rdy ( sq21_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_22 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq22id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[22] ), .current_sqcut_done ( current_sqcut_done[22] ) , .st_rx_start ( sq_rx_start[22] ) , .st_rx_end ( sq_rx_end[22] ) , .st_rx_valid ( sq_rx_valid[22] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[22] ) , .sq_cut_reset ( sq_cut_reset[22] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_22 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq22_shift_full_flag ) , .sq_cut_len_reg ( sq22_cut_len_reg ) , .market_explain ( sq22_market_explain ) , .info_classify ( sq22_info_classify ) , .dialog_num ( sq22_dialog_num ) , .contract_flag ( sq22_contract_flag ) , .contract_num ( sq22_contract_num ) , .contract_code ( sq22_contract_code ) , .update_time ( sq22_update_time ) , .update_ms ( sq22_update_ms ) , .new_price ( sq22_new_price ) , .turnover ( sq22_turnover ) , .volume ( sq22_volume ) , .position ( sq22_position ) , .purchase_price ( sq22_purchase_price ) , .buy_quantity ( sq22_buy_quantity ) , .sell_price ( sq22_sell_price ) , .sell_quantity ( sq22_sell_quantity ) , .market_rdy ( sq22_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_23 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq23id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[23] ), .current_sqcut_done ( current_sqcut_done[23] ) , .st_rx_start ( sq_rx_start[23] ) , .st_rx_end ( sq_rx_end[23] ) , .st_rx_valid ( sq_rx_valid[23] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[23] ) , .sq_cut_reset ( sq_cut_reset[23] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_23 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq23_shift_full_flag ) , .sq_cut_len_reg ( sq23_cut_len_reg ) , .market_explain ( sq23_market_explain ) , .info_classify ( sq23_info_classify ) , .dialog_num ( sq23_dialog_num ) , .contract_flag ( sq23_contract_flag ) , .contract_num ( sq23_contract_num ) , .contract_code ( sq23_contract_code ) , .update_time ( sq23_update_time ) , .update_ms ( sq23_update_ms ) , .new_price ( sq23_new_price ) , .turnover ( sq23_turnover ) , .volume ( sq23_volume ) , .position ( sq23_position ) , .purchase_price ( sq23_purchase_price ) , .buy_quantity ( sq23_buy_quantity ) , .sell_price ( sq23_sell_price ) , .sell_quantity ( sq23_sell_quantity ) , .market_rdy ( sq23_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_24 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq24id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[24] ), .current_sqcut_done ( current_sqcut_done[24] ) , .st_rx_start ( sq_rx_start[24] ) , .st_rx_end ( sq_rx_end[24] ) , .st_rx_valid ( sq_rx_valid[24] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[24] ) , .sq_cut_reset ( sq_cut_reset[24] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_24 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq24_shift_full_flag ) , .sq_cut_len_reg ( sq24_cut_len_reg ) , .market_explain ( sq24_market_explain ) , .info_classify ( sq24_info_classify ) , .dialog_num ( sq24_dialog_num ) , .contract_flag ( sq24_contract_flag ) , .contract_num ( sq24_contract_num ) , .contract_code ( sq24_contract_code ) , .update_time ( sq24_update_time ) , .update_ms ( sq24_update_ms ) , .new_price ( sq24_new_price ) , .turnover ( sq24_turnover ) , .volume ( sq24_volume ) , .position ( sq24_position ) , .purchase_price ( sq24_purchase_price ) , .buy_quantity ( sq24_buy_quantity ) , .sell_price ( sq24_sell_price ) , .sell_quantity ( sq24_sell_quantity ) , .market_rdy ( sq24_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_25 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq25id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[25] ), .current_sqcut_done ( current_sqcut_done[25] ) , .st_rx_start ( sq_rx_start[25] ) , .st_rx_end ( sq_rx_end[25] ) , .st_rx_valid ( sq_rx_valid[25] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[25] ) , .sq_cut_reset ( sq_cut_reset[25] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_25 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq25_shift_full_flag ) , .sq_cut_len_reg ( sq25_cut_len_reg ) , .market_explain ( sq25_market_explain ) , .info_classify ( sq25_info_classify ) , .dialog_num ( sq25_dialog_num ) , .contract_flag ( sq25_contract_flag ) , .contract_num ( sq25_contract_num ) , .contract_code ( sq25_contract_code ) , .update_time ( sq25_update_time ) , .update_ms ( sq25_update_ms ) , .new_price ( sq25_new_price ) , .turnover ( sq25_turnover ) , .volume ( sq25_volume ) , .position ( sq25_position ) , .purchase_price ( sq25_purchase_price ) , .buy_quantity ( sq25_buy_quantity ) , .sell_price ( sq25_sell_price ) , .sell_quantity ( sq25_sell_quantity ) , .market_rdy ( sq25_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_26 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq26id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[26] ), .current_sqcut_done ( current_sqcut_done[26] ) , .st_rx_start ( sq_rx_start[26] ) , .st_rx_end ( sq_rx_end[26] ) , .st_rx_valid ( sq_rx_valid[26] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[26] ) , .sq_cut_reset ( sq_cut_reset[26] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_26 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq26_shift_full_flag ) , .sq_cut_len_reg ( sq26_cut_len_reg ) , .market_explain ( sq26_market_explain ) , .info_classify ( sq26_info_classify ) , .dialog_num ( sq26_dialog_num ) , .contract_flag ( sq26_contract_flag ) , .contract_num ( sq26_contract_num ) , .contract_code ( sq26_contract_code ) , .update_time ( sq26_update_time ) , .update_ms ( sq26_update_ms ) , .new_price ( sq26_new_price ) , .turnover ( sq26_turnover ) , .volume ( sq26_volume ) , .position ( sq26_position ) , .purchase_price ( sq26_purchase_price ) , .buy_quantity ( sq26_buy_quantity ) , .sell_price ( sq26_sell_price ) , .sell_quantity ( sq26_sell_quantity ) , .market_rdy ( sq26_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_27 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq27id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[27] ), .current_sqcut_done ( current_sqcut_done[27] ) , .st_rx_start ( sq_rx_start[27] ) , .st_rx_end ( sq_rx_end[27] ) , .st_rx_valid ( sq_rx_valid[27] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[27] ) , .sq_cut_reset ( sq_cut_reset[27] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_27 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq27_shift_full_flag ) , .sq_cut_len_reg ( sq27_cut_len_reg ) , .market_explain ( sq27_market_explain ) , .info_classify ( sq27_info_classify ) , .dialog_num ( sq27_dialog_num ) , .contract_flag ( sq27_contract_flag ) , .contract_num ( sq27_contract_num ) , .contract_code ( sq27_contract_code ) , .update_time ( sq27_update_time ) , .update_ms ( sq27_update_ms ) , .new_price ( sq27_new_price ) , .turnover ( sq27_turnover ) , .volume ( sq27_volume ) , .position ( sq27_position ) , .purchase_price ( sq27_purchase_price ) , .buy_quantity ( sq27_buy_quantity ) , .sell_price ( sq27_sell_price ) , .sell_quantity ( sq27_sell_quantity ) , .market_rdy ( sq27_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_28 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq28id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[28] ), .current_sqcut_done ( current_sqcut_done[28] ) , .st_rx_start ( sq_rx_start[28] ) , .st_rx_end ( sq_rx_end[28] ) , .st_rx_valid ( sq_rx_valid[28] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[28] ) , .sq_cut_reset ( sq_cut_reset[28] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_28 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq28_shift_full_flag ) , .sq_cut_len_reg ( sq28_cut_len_reg ) , .market_explain ( sq28_market_explain ) , .info_classify ( sq28_info_classify ) , .dialog_num ( sq28_dialog_num ) , .contract_flag ( sq28_contract_flag ) , .contract_num ( sq28_contract_num ) , .contract_code ( sq28_contract_code ) , .update_time ( sq28_update_time ) , .update_ms ( sq28_update_ms ) , .new_price ( sq28_new_price ) , .turnover ( sq28_turnover ) , .volume ( sq28_volume ) , .position ( sq28_position ) , .purchase_price ( sq28_purchase_price ) , .buy_quantity ( sq28_buy_quantity ) , .sell_price ( sq28_sell_price ) , .sell_quantity ( sq28_sell_quantity ) , .market_rdy ( sq28_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_29 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq29id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[29] ), .current_sqcut_done ( current_sqcut_done[29] ) , .st_rx_start ( sq_rx_start[29] ) , .st_rx_end ( sq_rx_end[29] ) , .st_rx_valid ( sq_rx_valid[29] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[29] ) , .sq_cut_reset ( sq_cut_reset[29] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_29 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq29_shift_full_flag ) , .sq_cut_len_reg ( sq29_cut_len_reg ) , .market_explain ( sq29_market_explain ) , .info_classify ( sq29_info_classify ) , .dialog_num ( sq29_dialog_num ) , .contract_flag ( sq29_contract_flag ) , .contract_num ( sq29_contract_num ) , .contract_code ( sq29_contract_code ) , .update_time ( sq29_update_time ) , .update_ms ( sq29_update_ms ) , .new_price ( sq29_new_price ) , .turnover ( sq29_turnover ) , .volume ( sq29_volume ) , .position ( sq29_position ) , .purchase_price ( sq29_purchase_price ) , .buy_quantity ( sq29_buy_quantity ) , .sell_price ( sq29_sell_price ) , .sell_quantity ( sq29_sell_quantity ) , .market_rdy ( sq29_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_30 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq30id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[30] ), .current_sqcut_done ( current_sqcut_done[30] ) , .st_rx_start ( sq_rx_start[30] ) , .st_rx_end ( sq_rx_end[30] ) , .st_rx_valid ( sq_rx_valid[30] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[30] ) , .sq_cut_reset ( sq_cut_reset[30] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_30 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq30_shift_full_flag ) , .sq_cut_len_reg ( sq30_cut_len_reg ) , .market_explain ( sq30_market_explain ) , .info_classify ( sq30_info_classify ) , .dialog_num ( sq30_dialog_num ) , .contract_flag ( sq30_contract_flag ) , .contract_num ( sq30_contract_num ) , .contract_code ( sq30_contract_code ) , .update_time ( sq30_update_time ) , .update_ms ( sq30_update_ms ) , .new_price ( sq30_new_price ) , .turnover ( sq30_turnover ) , .volume ( sq30_volume ) , .position ( sq30_position ) , .purchase_price ( sq30_purchase_price ) , .buy_quantity ( sq30_buy_quantity ) , .sell_price ( sq30_sell_price ) , .sell_quantity ( sq30_sell_quantity ) , .market_rdy ( sq30_market_rdy ) );
 filter_cut_rx_fsm sq_cut_rx_fsm_31 ( .clk ( clk ) , .rst_n ( rst_n ) , .params_frame_type_byte (params_frame_type_byte ) , .params_filter_rst (params_filter_rst ) , .current_cut_done_sqid_reg ( current_cut_done_sq31id_reg ) , .current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[31] ), .current_sqcut_done ( current_sqcut_done[31] ) , .st_rx_start ( sq_rx_start[31] ) , .st_rx_end ( sq_rx_end[31] ) , .st_rx_valid ( sq_rx_valid[31] ) , .sq_cut_reset_pre ( sq_cut_reset_pre[31] ) , .sq_cut_reset ( sq_cut_reset[31] ) , .st_rx_data ( sq_rx_data ) , .st_rx_empty ( sq_rx_empty_31 ) , .st_rx_offset ( 4'd0 ) , .st_rx_cnt ( 16'd0 ) , .sq_frame_flag ( 1'd1 ) , .sq_shift_full_flag ( sq31_shift_full_flag ) , .sq_cut_len_reg ( sq31_cut_len_reg ) , .market_explain ( sq31_market_explain ) , .info_classify ( sq31_info_classify ) , .dialog_num ( sq31_dialog_num ) , .contract_flag ( sq31_contract_flag ) , .contract_num ( sq31_contract_num ) , .contract_code ( sq31_contract_code ) , .update_time ( sq31_update_time ) , .update_ms ( sq31_update_ms ) , .new_price ( sq31_new_price ) , .turnover ( sq31_turnover ) , .volume ( sq31_volume ) , .position ( sq31_position ) , .purchase_price ( sq31_purchase_price ) , .buy_quantity ( sq31_buy_quantity ) , .sell_price ( sq31_sell_price ) , .sell_quantity ( sq31_sell_quantity ) , .market_rdy ( sq31_market_rdy ) );
 sq_cut_ctrl sq_cut_ctrl ( .clk (clk ) , .rst_n (rst_n ) , .params_filter_rst (params_filter_rst ) , .sq00_cut_len_reg (sq00_cut_len_reg ) , .sq01_cut_len_reg (sq01_cut_len_reg ) , .sq02_cut_len_reg (sq02_cut_len_reg ) , .sq03_cut_len_reg (sq03_cut_len_reg ) , .sq04_cut_len_reg (sq04_cut_len_reg ) , .sq05_cut_len_reg (sq05_cut_len_reg ) , .sq06_cut_len_reg (sq06_cut_len_reg ) , .sq07_cut_len_reg (sq07_cut_len_reg ) , .sq08_cut_len_reg (sq08_cut_len_reg ) , .sq09_cut_len_reg (sq09_cut_len_reg ) , .sq10_cut_len_reg (sq10_cut_len_reg ) , .sq11_cut_len_reg (sq11_cut_len_reg ) , .sq12_cut_len_reg (sq12_cut_len_reg ) , .sq13_cut_len_reg (sq13_cut_len_reg ) , .sq14_cut_len_reg (sq14_cut_len_reg ) , .sq15_cut_len_reg (sq15_cut_len_reg ) , .sq16_cut_len_reg (sq16_cut_len_reg ) , .sq17_cut_len_reg (sq17_cut_len_reg ) , .sq18_cut_len_reg (sq18_cut_len_reg ) , .sq19_cut_len_reg (sq19_cut_len_reg ) , .sq20_cut_len_reg (sq20_cut_len_reg ) , .sq21_cut_len_reg (sq21_cut_len_reg ) , .sq22_cut_len_reg (sq22_cut_len_reg ) , .sq23_cut_len_reg (sq23_cut_len_reg ) , .sq24_cut_len_reg (sq24_cut_len_reg ) , .sq25_cut_len_reg (sq25_cut_len_reg ) , .sq26_cut_len_reg (sq26_cut_len_reg ) , .sq27_cut_len_reg (sq27_cut_len_reg ) , .sq28_cut_len_reg (sq28_cut_len_reg ) , .sq29_cut_len_reg (sq29_cut_len_reg ) , .sq30_cut_len_reg (sq30_cut_len_reg ) , .sq31_cut_len_reg (sq31_cut_len_reg ) , .fir_r_idle_st (fir_r_idle_st ) , .fir_r_sqcuth_st (fir_r_sqcuth_st ) , .fir_r_vsync_st (fir_r_vsync_st ) , .fir_r_sqcut_st (fir_r_sqcut_st ) , .fir_r_sqcut_end_st (fir_r_sqcut_end_st ) , .fir_r_sqrcut_st (fir_r_sqrcut_st ) , .fir_r_sqrcut_end_st (fir_r_sqrcut_end_st ) , .fir_r_rjudge_st (fir_r_rjudge_st ) , .sq_cut_len_reg (sq_cut_len_reg ) , .st_rx_cnt_reg (st_rx_cnt_reg ) , .st_shift_ccnt (st_shift_ccnt ) , .sync_len_byte (sync_len_byte ) , .sync_fisrt_byte (sync_fisrt_byte), .sync_four_byte (sync_four_byte), .sq_frame_flag (sq_frame_flag ) , .current_sqid_reg_flag (current_sqid_reg_flag ) , .sq_cut_on (sq_cut_on ) , .sq_cut_first_on (sq_cut_first_on ) , .sub_sqcut_len_reg (sub_sqcut_len_reg ) , .st_rx_start (st_rx_start ) , .st_rx_offset (st_rx_offset ) , .st_rx_end (st_rx_end ) , .st_rx_valid (st_rx_valid ) , .st_rx_data (st_rx_data ) , .st_rx_empty (st_rx_empty ) , .st_rx_cnt (st_rx_cnt ) , .first_sync_len_byte (first_sync_len_byte ) , .tcp_sqmatch_flag (tcp_sqmatch_flag ) , .seq_err_flag (seq_err_flag ) , .seq_err_flag_dly (seq_err_flag_dly ) , .tcp_payload_len (tcp_payload_len ) , .st_rx_start_dly (st_rx_start_dly ) , .st_rx_offset_dly (st_rx_offset_dly ) , .st_rx_end_dly (st_rx_end_dly ) , .st_rx_valid_dly (st_rx_valid_dly ) , .st_rx_data_dly (st_rx_data_dly ) , .st_rx_empty_dly (st_rx_empty_dly ) , .st_rx_cnt_dly (st_rx_cnt_dly ) , .first_sync_len_byte_dly (first_sync_len_byte_dly ) , .tcp_sqmatch_flag_dly (tcp_sqmatch_flag_dly ) , .tcp_sqmatch_flag_1bit_dly (tcp_sqmatch_flag_1bit_dly ) , .tcp_payload_len_dly (tcp_payload_len_dly ) , .sq_cut_flag (sq_cut_flag ) , .sq_cut_reset (sq_cut_reset ) , .sq_cut_reset_pre (sq_cut_reset_pre ) , .current_cut_done_sq00id_reg (current_cut_done_sq00id_reg ) , .current_cut_done_sq01id_reg (current_cut_done_sq01id_reg ) , .current_cut_done_sq02id_reg (current_cut_done_sq02id_reg ) , .current_cut_done_sq03id_reg (current_cut_done_sq03id_reg ) , .current_cut_done_sq04id_reg (current_cut_done_sq04id_reg ) , .current_cut_done_sq05id_reg (current_cut_done_sq05id_reg ) , .current_cut_done_sq06id_reg (current_cut_done_sq06id_reg ) , .current_cut_done_sq07id_reg (current_cut_done_sq07id_reg ) , .current_cut_done_sq08id_reg (current_cut_done_sq08id_reg ) , .current_cut_done_sq09id_reg (current_cut_done_sq09id_reg ) , .current_cut_done_sq10id_reg (current_cut_done_sq10id_reg ) , .current_cut_done_sq11id_reg (current_cut_done_sq11id_reg ) , .current_cut_done_sq12id_reg (current_cut_done_sq12id_reg ) , .current_cut_done_sq13id_reg (current_cut_done_sq13id_reg ) , .current_cut_done_sq14id_reg (current_cut_done_sq14id_reg ) , .current_cut_done_sq15id_reg (current_cut_done_sq15id_reg ) , .current_cut_done_sq16id_reg (current_cut_done_sq16id_reg ) , .current_cut_done_sq17id_reg (current_cut_done_sq17id_reg ) , .current_cut_done_sq18id_reg (current_cut_done_sq18id_reg ) , .current_cut_done_sq19id_reg (current_cut_done_sq19id_reg ) , .current_cut_done_sq20id_reg (current_cut_done_sq20id_reg ) , .current_cut_done_sq21id_reg (current_cut_done_sq21id_reg ) , .current_cut_done_sq22id_reg (current_cut_done_sq22id_reg ) , .current_cut_done_sq23id_reg (current_cut_done_sq23id_reg ) , .current_cut_done_sq24id_reg (current_cut_done_sq24id_reg ) , .current_cut_done_sq25id_reg (current_cut_done_sq25id_reg ) , .current_cut_done_sq26id_reg (current_cut_done_sq26id_reg ) , .current_cut_done_sq27id_reg (current_cut_done_sq27id_reg ) , .current_cut_done_sq28id_reg (current_cut_done_sq28id_reg ) , .current_cut_done_sq29id_reg (current_cut_done_sq29id_reg ) , .current_cut_done_sq30id_reg (current_cut_done_sq30id_reg ) , .current_cut_done_sq31id_reg (current_cut_done_sq31id_reg ) , .current_sqcut_done (current_sqcut_done ) , .current_sqid_reg (current_sqid_reg ) , .current_sqid_reg_vld (current_sqid_reg_vld ) );
 filter_tlp_gen filter_tlp_gen ( .clk ( clk ) , .rst_n ( rst_n ) , .params_filter_rst (params_filter_rst ) , .market_explain ( market_explain ) , .info_classify ( info_classify ) , .dialog_num ( dialog_num ) , .contract_flag ( contract_flag ) , .contract_num ( contract_num ) , .contract_code ( contract_code ) , .update_time ( update_time ) , .update_ms ( update_ms ) , .new_price ( new_price ) , .turnover ( turnover ) , .volume ( volume ) , .position ( position ) , .purchase_price ( purchase_price ) , .buy_quantity ( buy_quantity ) , .sell_price ( sell_price ) , .sell_quantity ( sell_quantity ) , .market_rdy ( market_rdy ) , .sq00_market_explain ( sq00_market_explain ) , .sq00_info_classify ( sq00_info_classify ) , .sq00_dialog_num ( sq00_dialog_num ) , .sq00_contract_flag ( sq00_contract_flag ) , .sq00_contract_num ( sq00_contract_num ) , .sq00_contract_code ( sq00_contract_code ) , .sq00_update_time ( sq00_update_time ) , .sq00_update_ms ( sq00_update_ms ) , .sq00_new_price ( sq00_new_price ) , .sq00_turnover ( sq00_turnover ) , .sq00_volume ( sq00_volume ) , .sq00_position ( sq00_position ) , .sq00_purchase_price ( sq00_purchase_price ) , .sq00_buy_quantity ( sq00_buy_quantity ) , .sq00_sell_price ( sq00_sell_price ) , .sq00_sell_quantity ( sq00_sell_quantity ) , .sq00_market_rdy ( sq00_market_rdy ) , .sq01_market_explain ( sq01_market_explain ) , .sq01_info_classify ( sq01_info_classify ) , .sq01_dialog_num ( sq01_dialog_num ) , .sq01_contract_flag ( sq01_contract_flag ) , .sq01_contract_num ( sq01_contract_num ) , .sq01_contract_code ( sq01_contract_code ) , .sq01_update_time ( sq01_update_time ) , .sq01_update_ms ( sq01_update_ms ) , .sq01_new_price ( sq01_new_price ) , .sq01_turnover ( sq01_turnover ) , .sq01_volume ( sq01_volume ) , .sq01_position ( sq01_position ) , .sq01_purchase_price ( sq01_purchase_price ) , .sq01_buy_quantity ( sq01_buy_quantity ) , .sq01_sell_price ( sq01_sell_price ) , .sq01_sell_quantity ( sq01_sell_quantity ) , .sq01_market_rdy ( sq01_market_rdy ) , .sq02_market_explain ( sq02_market_explain ) , .sq02_info_classify ( sq02_info_classify ) , .sq02_dialog_num ( sq02_dialog_num ) , .sq02_contract_flag ( sq02_contract_flag ) , .sq02_contract_num ( sq02_contract_num ) , .sq02_contract_code ( sq02_contract_code ) , .sq02_update_time ( sq02_update_time ) , .sq02_update_ms ( sq02_update_ms ) , .sq02_new_price ( sq02_new_price ) , .sq02_turnover ( sq02_turnover ) , .sq02_volume ( sq02_volume ) , .sq02_position ( sq02_position ) , .sq02_purchase_price ( sq02_purchase_price ) , .sq02_buy_quantity ( sq02_buy_quantity ) , .sq02_sell_price ( sq02_sell_price ) , .sq02_sell_quantity ( sq02_sell_quantity ) , .sq02_market_rdy ( sq02_market_rdy ) , .sq03_market_explain ( sq03_market_explain ) , .sq03_info_classify ( sq03_info_classify ) , .sq03_dialog_num ( sq03_dialog_num ) , .sq03_contract_flag ( sq03_contract_flag ) , .sq03_contract_num ( sq03_contract_num ) , .sq03_contract_code ( sq03_contract_code ) , .sq03_update_time ( sq03_update_time ) , .sq03_update_ms ( sq03_update_ms ) , .sq03_new_price ( sq03_new_price ) , .sq03_turnover ( sq03_turnover ) , .sq03_volume ( sq03_volume ) , .sq03_position ( sq03_position ) , .sq03_purchase_price ( sq03_purchase_price ) , .sq03_buy_quantity ( sq03_buy_quantity ) , .sq03_sell_price ( sq03_sell_price ) , .sq03_sell_quantity ( sq03_sell_quantity ) , .sq03_market_rdy ( sq03_market_rdy ) , .sq04_market_explain ( sq04_market_explain ) , .sq04_info_classify ( sq04_info_classify ) , .sq04_dialog_num ( sq04_dialog_num ) , .sq04_contract_flag ( sq04_contract_flag ) , .sq04_contract_num ( sq04_contract_num ) , .sq04_contract_code ( sq04_contract_code ) , .sq04_update_time ( sq04_update_time ) , .sq04_update_ms ( sq04_update_ms ) , .sq04_new_price ( sq04_new_price ) , .sq04_turnover ( sq04_turnover ) , .sq04_volume ( sq04_volume ) , .sq04_position ( sq04_position ) , .sq04_purchase_price ( sq04_purchase_price ) , .sq04_buy_quantity ( sq04_buy_quantity ) , .sq04_sell_price ( sq04_sell_price ) , .sq04_sell_quantity ( sq04_sell_quantity ) , .sq04_market_rdy ( sq04_market_rdy ) , .sq05_market_explain ( sq05_market_explain ) , .sq05_info_classify ( sq05_info_classify ) , .sq05_dialog_num ( sq05_dialog_num ) , .sq05_contract_flag ( sq05_contract_flag ) , .sq05_contract_num ( sq05_contract_num ) , .sq05_contract_code ( sq05_contract_code ) , .sq05_update_time ( sq05_update_time ) , .sq05_update_ms ( sq05_update_ms ) , .sq05_new_price ( sq05_new_price ) , .sq05_turnover ( sq05_turnover ) , .sq05_volume ( sq05_volume ) , .sq05_position ( sq05_position ) , .sq05_purchase_price ( sq05_purchase_price ) , .sq05_buy_quantity ( sq05_buy_quantity ) , .sq05_sell_price ( sq05_sell_price ) , .sq05_sell_quantity ( sq05_sell_quantity ) , .sq05_market_rdy ( sq05_market_rdy ) , .sq06_market_explain ( sq06_market_explain ) , .sq06_info_classify ( sq06_info_classify ) , .sq06_dialog_num ( sq06_dialog_num ) , .sq06_contract_flag ( sq06_contract_flag ) , .sq06_contract_num ( sq06_contract_num ) , .sq06_contract_code ( sq06_contract_code ) , .sq06_update_time ( sq06_update_time ) , .sq06_update_ms ( sq06_update_ms ) , .sq06_new_price ( sq06_new_price ) , .sq06_turnover ( sq06_turnover ) , .sq06_volume ( sq06_volume ) , .sq06_position ( sq06_position ) , .sq06_purchase_price ( sq06_purchase_price ) , .sq06_buy_quantity ( sq06_buy_quantity ) , .sq06_sell_price ( sq06_sell_price ) , .sq06_sell_quantity ( sq06_sell_quantity ) , .sq06_market_rdy ( sq06_market_rdy ) , .sq07_market_explain ( sq07_market_explain ) , .sq07_info_classify ( sq07_info_classify ) , .sq07_dialog_num ( sq07_dialog_num ) , .sq07_contract_flag ( sq07_contract_flag ) , .sq07_contract_num ( sq07_contract_num ) , .sq07_contract_code ( sq07_contract_code ) , .sq07_update_time ( sq07_update_time ) , .sq07_update_ms ( sq07_update_ms ) , .sq07_new_price ( sq07_new_price ) , .sq07_turnover ( sq07_turnover ) , .sq07_volume ( sq07_volume ) , .sq07_position ( sq07_position ) , .sq07_purchase_price ( sq07_purchase_price ) , .sq07_buy_quantity ( sq07_buy_quantity ) , .sq07_sell_price ( sq07_sell_price ) , .sq07_sell_quantity ( sq07_sell_quantity ) , .sq07_market_rdy ( sq07_market_rdy ) , .sq08_market_explain ( sq08_market_explain ) , .sq08_info_classify ( sq08_info_classify ) , .sq08_dialog_num ( sq08_dialog_num ) , .sq08_contract_flag ( sq08_contract_flag ) , .sq08_contract_num ( sq08_contract_num ) , .sq08_contract_code ( sq08_contract_code ) , .sq08_update_time ( sq08_update_time ) , .sq08_update_ms ( sq08_update_ms ) , .sq08_new_price ( sq08_new_price ) , .sq08_turnover ( sq08_turnover ) , .sq08_volume ( sq08_volume ) , .sq08_position ( sq08_position ) , .sq08_purchase_price ( sq08_purchase_price ) , .sq08_buy_quantity ( sq08_buy_quantity ) , .sq08_sell_price ( sq08_sell_price ) , .sq08_sell_quantity ( sq08_sell_quantity ) , .sq08_market_rdy ( sq08_market_rdy ) , .sq09_market_explain ( sq09_market_explain ) , .sq09_info_classify ( sq09_info_classify ) , .sq09_dialog_num ( sq09_dialog_num ) , .sq09_contract_flag ( sq09_contract_flag ) , .sq09_contract_num ( sq09_contract_num ) , .sq09_contract_code ( sq09_contract_code ) , .sq09_update_time ( sq09_update_time ) , .sq09_update_ms ( sq09_update_ms ) , .sq09_new_price ( sq09_new_price ) , .sq09_turnover ( sq09_turnover ) , .sq09_volume ( sq09_volume ) , .sq09_position ( sq09_position ) , .sq09_purchase_price ( sq09_purchase_price ) , .sq09_buy_quantity ( sq09_buy_quantity ) , .sq09_sell_price ( sq09_sell_price ) , .sq09_sell_quantity ( sq09_sell_quantity ) , .sq09_market_rdy ( sq09_market_rdy ) , .sq10_market_explain ( sq10_market_explain ) , .sq10_info_classify ( sq10_info_classify ) , .sq10_dialog_num ( sq10_dialog_num ) , .sq10_contract_flag ( sq10_contract_flag ) , .sq10_contract_num ( sq10_contract_num ) , .sq10_contract_code ( sq10_contract_code ) , .sq10_update_time ( sq10_update_time ) , .sq10_update_ms ( sq10_update_ms ) , .sq10_new_price ( sq10_new_price ) , .sq10_turnover ( sq10_turnover ) , .sq10_volume ( sq10_volume ) , .sq10_position ( sq10_position ) , .sq10_purchase_price ( sq10_purchase_price ) , .sq10_buy_quantity ( sq10_buy_quantity ) , .sq10_sell_price ( sq10_sell_price ) , .sq10_sell_quantity ( sq10_sell_quantity ) , .sq10_market_rdy ( sq10_market_rdy ) , .sq11_market_explain ( sq11_market_explain ) , .sq11_info_classify ( sq11_info_classify ) , .sq11_dialog_num ( sq11_dialog_num ) , .sq11_contract_flag ( sq11_contract_flag ) , .sq11_contract_num ( sq11_contract_num ) , .sq11_contract_code ( sq11_contract_code ) , .sq11_update_time ( sq11_update_time ) , .sq11_update_ms ( sq11_update_ms ) , .sq11_new_price ( sq11_new_price ) , .sq11_turnover ( sq11_turnover ) , .sq11_volume ( sq11_volume ) , .sq11_position ( sq11_position ) , .sq11_purchase_price ( sq11_purchase_price ) , .sq11_buy_quantity ( sq11_buy_quantity ) , .sq11_sell_price ( sq11_sell_price ) , .sq11_sell_quantity ( sq11_sell_quantity ) , .sq11_market_rdy ( sq11_market_rdy ) , .sq12_market_explain ( sq12_market_explain ) , .sq12_info_classify ( sq12_info_classify ) , .sq12_dialog_num ( sq12_dialog_num ) , .sq12_contract_flag ( sq12_contract_flag ) , .sq12_contract_num ( sq12_contract_num ) , .sq12_contract_code ( sq12_contract_code ) , .sq12_update_time ( sq12_update_time ) , .sq12_update_ms ( sq12_update_ms ) , .sq12_new_price ( sq12_new_price ) , .sq12_turnover ( sq12_turnover ) , .sq12_volume ( sq12_volume ) , .sq12_position ( sq12_position ) , .sq12_purchase_price ( sq12_purchase_price ) , .sq12_buy_quantity ( sq12_buy_quantity ) , .sq12_sell_price ( sq12_sell_price ) , .sq12_sell_quantity ( sq12_sell_quantity ) , .sq12_market_rdy ( sq12_market_rdy ) , .sq13_market_explain ( sq13_market_explain ) , .sq13_info_classify ( sq13_info_classify ) , .sq13_dialog_num ( sq13_dialog_num ) , .sq13_contract_flag ( sq13_contract_flag ) , .sq13_contract_num ( sq13_contract_num ) , .sq13_contract_code ( sq13_contract_code ) , .sq13_update_time ( sq13_update_time ) , .sq13_update_ms ( sq13_update_ms ) , .sq13_new_price ( sq13_new_price ) , .sq13_turnover ( sq13_turnover ) , .sq13_volume ( sq13_volume ) , .sq13_position ( sq13_position ) , .sq13_purchase_price ( sq13_purchase_price ) , .sq13_buy_quantity ( sq13_buy_quantity ) , .sq13_sell_price ( sq13_sell_price ) , .sq13_sell_quantity ( sq13_sell_quantity ) , .sq13_market_rdy ( sq13_market_rdy ) , .sq14_market_explain ( sq14_market_explain ) , .sq14_info_classify ( sq14_info_classify ) , .sq14_dialog_num ( sq14_dialog_num ) , .sq14_contract_flag ( sq14_contract_flag ) , .sq14_contract_num ( sq14_contract_num ) , .sq14_contract_code ( sq14_contract_code ) , .sq14_update_time ( sq14_update_time ) , .sq14_update_ms ( sq14_update_ms ) , .sq14_new_price ( sq14_new_price ) , .sq14_turnover ( sq14_turnover ) , .sq14_volume ( sq14_volume ) , .sq14_position ( sq14_position ) , .sq14_purchase_price ( sq14_purchase_price ) , .sq14_buy_quantity ( sq14_buy_quantity ) , .sq14_sell_price ( sq14_sell_price ) , .sq14_sell_quantity ( sq14_sell_quantity ) , .sq14_market_rdy ( sq14_market_rdy ) , .sq15_market_explain ( sq15_market_explain ) , .sq15_info_classify ( sq15_info_classify ) , .sq15_dialog_num ( sq15_dialog_num ) , .sq15_contract_flag ( sq15_contract_flag ) , .sq15_contract_num ( sq15_contract_num ) , .sq15_contract_code ( sq15_contract_code ) , .sq15_update_time ( sq15_update_time ) , .sq15_update_ms ( sq15_update_ms ) , .sq15_new_price ( sq15_new_price ) , .sq15_turnover ( sq15_turnover ) , .sq15_volume ( sq15_volume ) , .sq15_position ( sq15_position ) , .sq15_purchase_price ( sq15_purchase_price ) , .sq15_buy_quantity ( sq15_buy_quantity ) , .sq15_sell_price ( sq15_sell_price ) , .sq15_sell_quantity ( sq15_sell_quantity ) , .sq15_market_rdy ( sq15_market_rdy ) , .sq16_market_explain ( sq16_market_explain ) , .sq16_info_classify ( sq16_info_classify ) , .sq16_dialog_num ( sq16_dialog_num ) , .sq16_contract_flag ( sq16_contract_flag ) , .sq16_contract_num ( sq16_contract_num ) , .sq16_contract_code ( sq16_contract_code ) , .sq16_update_time ( sq16_update_time ) , .sq16_update_ms ( sq16_update_ms ) , .sq16_new_price ( sq16_new_price ) , .sq16_turnover ( sq16_turnover ) , .sq16_volume ( sq16_volume ) , .sq16_position ( sq16_position ) , .sq16_purchase_price ( sq16_purchase_price ) , .sq16_buy_quantity ( sq16_buy_quantity ) , .sq16_sell_price ( sq16_sell_price ) , .sq16_sell_quantity ( sq16_sell_quantity ) , .sq16_market_rdy ( sq16_market_rdy ) , .sq17_market_explain ( sq17_market_explain ) , .sq17_info_classify ( sq17_info_classify ) , .sq17_dialog_num ( sq17_dialog_num ) , .sq17_contract_flag ( sq17_contract_flag ) , .sq17_contract_num ( sq17_contract_num ) , .sq17_contract_code ( sq17_contract_code ) , .sq17_update_time ( sq17_update_time ) , .sq17_update_ms ( sq17_update_ms ) , .sq17_new_price ( sq17_new_price ) , .sq17_turnover ( sq17_turnover ) , .sq17_volume ( sq17_volume ) , .sq17_position ( sq17_position ) , .sq17_purchase_price ( sq17_purchase_price ) , .sq17_buy_quantity ( sq17_buy_quantity ) , .sq17_sell_price ( sq17_sell_price ) , .sq17_sell_quantity ( sq17_sell_quantity ) , .sq17_market_rdy ( sq17_market_rdy ) , .sq18_market_explain ( sq18_market_explain ) , .sq18_info_classify ( sq18_info_classify ) , .sq18_dialog_num ( sq18_dialog_num ) , .sq18_contract_flag ( sq18_contract_flag ) , .sq18_contract_num ( sq18_contract_num ) , .sq18_contract_code ( sq18_contract_code ) , .sq18_update_time ( sq18_update_time ) , .sq18_update_ms ( sq18_update_ms ) , .sq18_new_price ( sq18_new_price ) , .sq18_turnover ( sq18_turnover ) , .sq18_volume ( sq18_volume ) , .sq18_position ( sq18_position ) , .sq18_purchase_price ( sq18_purchase_price ) , .sq18_buy_quantity ( sq18_buy_quantity ) , .sq18_sell_price ( sq18_sell_price ) , .sq18_sell_quantity ( sq18_sell_quantity ) , .sq18_market_rdy ( sq18_market_rdy ) , .sq19_market_explain ( sq19_market_explain ) , .sq19_info_classify ( sq19_info_classify ) , .sq19_dialog_num ( sq19_dialog_num ) , .sq19_contract_flag ( sq19_contract_flag ) , .sq19_contract_num ( sq19_contract_num ) , .sq19_contract_code ( sq19_contract_code ) , .sq19_update_time ( sq19_update_time ) , .sq19_update_ms ( sq19_update_ms ) , .sq19_new_price ( sq19_new_price ) , .sq19_turnover ( sq19_turnover ) , .sq19_volume ( sq19_volume ) , .sq19_position ( sq19_position ) , .sq19_purchase_price ( sq19_purchase_price ) , .sq19_buy_quantity ( sq19_buy_quantity ) , .sq19_sell_price ( sq19_sell_price ) , .sq19_sell_quantity ( sq19_sell_quantity ) , .sq19_market_rdy ( sq19_market_rdy ) , .sq20_market_explain ( sq20_market_explain ) , .sq20_info_classify ( sq20_info_classify ) , .sq20_dialog_num ( sq20_dialog_num ) , .sq20_contract_flag ( sq20_contract_flag ) , .sq20_contract_num ( sq20_contract_num ) , .sq20_contract_code ( sq20_contract_code ) , .sq20_update_time ( sq20_update_time ) , .sq20_update_ms ( sq20_update_ms ) , .sq20_new_price ( sq20_new_price ) , .sq20_turnover ( sq20_turnover ) , .sq20_volume ( sq20_volume ) , .sq20_position ( sq20_position ) , .sq20_purchase_price ( sq20_purchase_price ) , .sq20_buy_quantity ( sq20_buy_quantity ) , .sq20_sell_price ( sq20_sell_price ) , .sq20_sell_quantity ( sq20_sell_quantity ) , .sq20_market_rdy ( sq20_market_rdy ) , .sq21_market_explain ( sq21_market_explain ) , .sq21_info_classify ( sq21_info_classify ) , .sq21_dialog_num ( sq21_dialog_num ) , .sq21_contract_flag ( sq21_contract_flag ) , .sq21_contract_num ( sq21_contract_num ) , .sq21_contract_code ( sq21_contract_code ) , .sq21_update_time ( sq21_update_time ) , .sq21_update_ms ( sq21_update_ms ) , .sq21_new_price ( sq21_new_price ) , .sq21_turnover ( sq21_turnover ) , .sq21_volume ( sq21_volume ) , .sq21_position ( sq21_position ) , .sq21_purchase_price ( sq21_purchase_price ) , .sq21_buy_quantity ( sq21_buy_quantity ) , .sq21_sell_price ( sq21_sell_price ) , .sq21_sell_quantity ( sq21_sell_quantity ) , .sq21_market_rdy ( sq21_market_rdy ) , .sq22_market_explain ( sq22_market_explain ) , .sq22_info_classify ( sq22_info_classify ) , .sq22_dialog_num ( sq22_dialog_num ) , .sq22_contract_flag ( sq22_contract_flag ) , .sq22_contract_num ( sq22_contract_num ) , .sq22_contract_code ( sq22_contract_code ) , .sq22_update_time ( sq22_update_time ) , .sq22_update_ms ( sq22_update_ms ) , .sq22_new_price ( sq22_new_price ) , .sq22_turnover ( sq22_turnover ) , .sq22_volume ( sq22_volume ) , .sq22_position ( sq22_position ) , .sq22_purchase_price ( sq22_purchase_price ) , .sq22_buy_quantity ( sq22_buy_quantity ) , .sq22_sell_price ( sq22_sell_price ) , .sq22_sell_quantity ( sq22_sell_quantity ) , .sq22_market_rdy ( sq22_market_rdy ) , .sq23_market_explain ( sq23_market_explain ) , .sq23_info_classify ( sq23_info_classify ) , .sq23_dialog_num ( sq23_dialog_num ) , .sq23_contract_flag ( sq23_contract_flag ) , .sq23_contract_num ( sq23_contract_num ) , .sq23_contract_code ( sq23_contract_code ) , .sq23_update_time ( sq23_update_time ) , .sq23_update_ms ( sq23_update_ms ) , .sq23_new_price ( sq23_new_price ) , .sq23_turnover ( sq23_turnover ) , .sq23_volume ( sq23_volume ) , .sq23_position ( sq23_position ) , .sq23_purchase_price ( sq23_purchase_price ) , .sq23_buy_quantity ( sq23_buy_quantity ) , .sq23_sell_price ( sq23_sell_price ) , .sq23_sell_quantity ( sq23_sell_quantity ) , .sq23_market_rdy ( sq23_market_rdy ) , .sq24_market_explain ( sq24_market_explain ) , .sq24_info_classify ( sq24_info_classify ) , .sq24_dialog_num ( sq24_dialog_num ) , .sq24_contract_flag ( sq24_contract_flag ) , .sq24_contract_num ( sq24_contract_num ) , .sq24_contract_code ( sq24_contract_code ) , .sq24_update_time ( sq24_update_time ) , .sq24_update_ms ( sq24_update_ms ) , .sq24_new_price ( sq24_new_price ) , .sq24_turnover ( sq24_turnover ) , .sq24_volume ( sq24_volume ) , .sq24_position ( sq24_position ) , .sq24_purchase_price ( sq24_purchase_price ) , .sq24_buy_quantity ( sq24_buy_quantity ) , .sq24_sell_price ( sq24_sell_price ) , .sq24_sell_quantity ( sq24_sell_quantity ) , .sq24_market_rdy ( sq24_market_rdy ) , .sq25_market_explain ( sq25_market_explain ) , .sq25_info_classify ( sq25_info_classify ) , .sq25_dialog_num ( sq25_dialog_num ) , .sq25_contract_flag ( sq25_contract_flag ) , .sq25_contract_num ( sq25_contract_num ) , .sq25_contract_code ( sq25_contract_code ) , .sq25_update_time ( sq25_update_time ) , .sq25_update_ms ( sq25_update_ms ) , .sq25_new_price ( sq25_new_price ) , .sq25_turnover ( sq25_turnover ) , .sq25_volume ( sq25_volume ) , .sq25_position ( sq25_position ) , .sq25_purchase_price ( sq25_purchase_price ) , .sq25_buy_quantity ( sq25_buy_quantity ) , .sq25_sell_price ( sq25_sell_price ) , .sq25_sell_quantity ( sq25_sell_quantity ) , .sq25_market_rdy ( sq25_market_rdy ) , .sq26_market_explain ( sq26_market_explain ) , .sq26_info_classify ( sq26_info_classify ) , .sq26_dialog_num ( sq26_dialog_num ) , .sq26_contract_flag ( sq26_contract_flag ) , .sq26_contract_num ( sq26_contract_num ) , .sq26_contract_code ( sq26_contract_code ) , .sq26_update_time ( sq26_update_time ) , .sq26_update_ms ( sq26_update_ms ) , .sq26_new_price ( sq26_new_price ) , .sq26_turnover ( sq26_turnover ) , .sq26_volume ( sq26_volume ) , .sq26_position ( sq26_position ) , .sq26_purchase_price ( sq26_purchase_price ) , .sq26_buy_quantity ( sq26_buy_quantity ) , .sq26_sell_price ( sq26_sell_price ) , .sq26_sell_quantity ( sq26_sell_quantity ) , .sq26_market_rdy ( sq26_market_rdy ) , .sq27_market_explain ( sq27_market_explain ) , .sq27_info_classify ( sq27_info_classify ) , .sq27_dialog_num ( sq27_dialog_num ) , .sq27_contract_flag ( sq27_contract_flag ) , .sq27_contract_num ( sq27_contract_num ) , .sq27_contract_code ( sq27_contract_code ) , .sq27_update_time ( sq27_update_time ) , .sq27_update_ms ( sq27_update_ms ) , .sq27_new_price ( sq27_new_price ) , .sq27_turnover ( sq27_turnover ) , .sq27_volume ( sq27_volume ) , .sq27_position ( sq27_position ) , .sq27_purchase_price ( sq27_purchase_price ) , .sq27_buy_quantity ( sq27_buy_quantity ) , .sq27_sell_price ( sq27_sell_price ) , .sq27_sell_quantity ( sq27_sell_quantity ) , .sq27_market_rdy ( sq27_market_rdy ) , .sq28_market_explain ( sq28_market_explain ) , .sq28_info_classify ( sq28_info_classify ) , .sq28_dialog_num ( sq28_dialog_num ) , .sq28_contract_flag ( sq28_contract_flag ) , .sq28_contract_num ( sq28_contract_num ) , .sq28_contract_code ( sq28_contract_code ) , .sq28_update_time ( sq28_update_time ) , .sq28_update_ms ( sq28_update_ms ) , .sq28_new_price ( sq28_new_price ) , .sq28_turnover ( sq28_turnover ) , .sq28_volume ( sq28_volume ) , .sq28_position ( sq28_position ) , .sq28_purchase_price ( sq28_purchase_price ) , .sq28_buy_quantity ( sq28_buy_quantity ) , .sq28_sell_price ( sq28_sell_price ) , .sq28_sell_quantity ( sq28_sell_quantity ) , .sq28_market_rdy ( sq28_market_rdy ) , .sq29_market_explain ( sq29_market_explain ) , .sq29_info_classify ( sq29_info_classify ) , .sq29_dialog_num ( sq29_dialog_num ) , .sq29_contract_flag ( sq29_contract_flag ) , .sq29_contract_num ( sq29_contract_num ) , .sq29_contract_code ( sq29_contract_code ) , .sq29_update_time ( sq29_update_time ) , .sq29_update_ms ( sq29_update_ms ) , .sq29_new_price ( sq29_new_price ) , .sq29_turnover ( sq29_turnover ) , .sq29_volume ( sq29_volume ) , .sq29_position ( sq29_position ) , .sq29_purchase_price ( sq29_purchase_price ) , .sq29_buy_quantity ( sq29_buy_quantity ) , .sq29_sell_price ( sq29_sell_price ) , .sq29_sell_quantity ( sq29_sell_quantity ) , .sq29_market_rdy ( sq29_market_rdy ) , .sq30_market_explain ( sq30_market_explain ) , .sq30_info_classify ( sq30_info_classify ) , .sq30_dialog_num ( sq30_dialog_num ) , .sq30_contract_flag ( sq30_contract_flag ) , .sq30_contract_num ( sq30_contract_num ) , .sq30_contract_code ( sq30_contract_code ) , .sq30_update_time ( sq30_update_time ) , .sq30_update_ms ( sq30_update_ms ) , .sq30_new_price ( sq30_new_price ) , .sq30_turnover ( sq30_turnover ) , .sq30_volume ( sq30_volume ) , .sq30_position ( sq30_position ) , .sq30_purchase_price ( sq30_purchase_price ) , .sq30_buy_quantity ( sq30_buy_quantity ) , .sq30_sell_price ( sq30_sell_price ) , .sq30_sell_quantity ( sq30_sell_quantity ) , .sq30_market_rdy ( sq30_market_rdy ) , .sq31_market_explain ( sq31_market_explain ) , .sq31_info_classify ( sq31_info_classify ) , .sq31_dialog_num ( sq31_dialog_num ) , .sq31_contract_flag ( sq31_contract_flag ) , .sq31_contract_num ( sq31_contract_num ) , .sq31_contract_code ( sq31_contract_code ) , .sq31_update_time ( sq31_update_time ) , .sq31_update_ms ( sq31_update_ms ) , .sq31_new_price ( sq31_new_price ) , .sq31_turnover ( sq31_turnover ) , .sq31_volume ( sq31_volume ) , .sq31_position ( sq31_position ) , .sq31_purchase_price ( sq31_purchase_price ) , .sq31_buy_quantity ( sq31_buy_quantity ) , .sq31_sell_price ( sq31_sell_price ) , .sq31_sell_quantity ( sq31_sell_quantity ) , .sq31_market_rdy ( sq31_market_rdy ) , .tlp_fifo_empty (fifo_data_empty), .tlp_fifo_rdata (fifo_data_out ), .tlp_fifo_data_vld (fifo_data_vld), .fifo_ready (fifo_ready) );
 endmodule
 module filter_tlp_gen ( clk , rst_n , params_filter_rst , market_explain , info_classify , dialog_num , contract_flag , contract_num , contract_code , update_time , update_ms , new_price , turnover , volume , position , purchase_price , buy_quantity , sell_price , sell_quantity , market_rdy , sq00_market_explain , sq01_market_explain , sq02_market_explain , sq03_market_explain , sq04_market_explain , sq05_market_explain , sq06_market_explain , sq07_market_explain , sq08_market_explain , sq09_market_explain , sq10_market_explain , sq11_market_explain , sq12_market_explain , sq13_market_explain , sq14_market_explain , sq15_market_explain , sq16_market_explain , sq17_market_explain , sq18_market_explain , sq19_market_explain , sq20_market_explain , sq21_market_explain , sq22_market_explain , sq23_market_explain , sq24_market_explain , sq25_market_explain , sq26_market_explain , sq27_market_explain , sq28_market_explain , sq29_market_explain , sq30_market_explain , sq31_market_explain , sq00_info_classify , sq01_info_classify , sq02_info_classify , sq03_info_classify , sq04_info_classify , sq05_info_classify , sq06_info_classify , sq07_info_classify , sq08_info_classify , sq09_info_classify , sq10_info_classify , sq11_info_classify , sq12_info_classify , sq13_info_classify , sq14_info_classify , sq15_info_classify , sq16_info_classify , sq17_info_classify , sq18_info_classify , sq19_info_classify , sq20_info_classify , sq21_info_classify , sq22_info_classify , sq23_info_classify , sq24_info_classify , sq25_info_classify , sq26_info_classify , sq27_info_classify , sq28_info_classify , sq29_info_classify , sq30_info_classify , sq31_info_classify , sq00_dialog_num , sq01_dialog_num , sq02_dialog_num , sq03_dialog_num , sq04_dialog_num , sq05_dialog_num , sq06_dialog_num , sq07_dialog_num , sq08_dialog_num , sq09_dialog_num , sq10_dialog_num , sq11_dialog_num , sq12_dialog_num , sq13_dialog_num , sq14_dialog_num , sq15_dialog_num , sq16_dialog_num , sq17_dialog_num , sq18_dialog_num , sq19_dialog_num , sq20_dialog_num , sq21_dialog_num , sq22_dialog_num , sq23_dialog_num , sq24_dialog_num , sq25_dialog_num , sq26_dialog_num , sq27_dialog_num , sq28_dialog_num , sq29_dialog_num , sq30_dialog_num , sq31_dialog_num , sq00_contract_flag , sq01_contract_flag , sq02_contract_flag , sq03_contract_flag , sq04_contract_flag , sq05_contract_flag , sq06_contract_flag , sq07_contract_flag , sq08_contract_flag , sq09_contract_flag , sq10_contract_flag , sq11_contract_flag , sq12_contract_flag , sq13_contract_flag , sq14_contract_flag , sq15_contract_flag , sq16_contract_flag , sq17_contract_flag , sq18_contract_flag , sq19_contract_flag , sq20_contract_flag , sq21_contract_flag , sq22_contract_flag , sq23_contract_flag , sq24_contract_flag , sq25_contract_flag , sq26_contract_flag , sq27_contract_flag , sq28_contract_flag , sq29_contract_flag , sq30_contract_flag , sq31_contract_flag , sq00_contract_num , sq01_contract_num , sq02_contract_num , sq03_contract_num , sq04_contract_num , sq05_contract_num , sq06_contract_num , sq07_contract_num , sq08_contract_num , sq09_contract_num , sq10_contract_num , sq11_contract_num , sq12_contract_num , sq13_contract_num , sq14_contract_num , sq15_contract_num , sq16_contract_num , sq17_contract_num , sq18_contract_num , sq19_contract_num , sq20_contract_num , sq21_contract_num , sq22_contract_num , sq23_contract_num , sq24_contract_num , sq25_contract_num , sq26_contract_num , sq27_contract_num , sq28_contract_num , sq29_contract_num , sq30_contract_num , sq31_contract_num , sq00_contract_code , sq01_contract_code , sq02_contract_code , sq03_contract_code , sq04_contract_code , sq05_contract_code , sq06_contract_code , sq07_contract_code , sq08_contract_code , sq09_contract_code , sq10_contract_code , sq11_contract_code , sq12_contract_code , sq13_contract_code , sq14_contract_code , sq15_contract_code , sq16_contract_code , sq17_contract_code , sq18_contract_code , sq19_contract_code , sq20_contract_code , sq21_contract_code , sq22_contract_code , sq23_contract_code , sq24_contract_code , sq25_contract_code , sq26_contract_code , sq27_contract_code , sq28_contract_code , sq29_contract_code , sq30_contract_code , sq31_contract_code , sq00_update_time , sq01_update_time , sq02_update_time , sq03_update_time , sq04_update_time , sq05_update_time , sq06_update_time , sq07_update_time , sq08_update_time , sq09_update_time , sq10_update_time , sq11_update_time , sq12_update_time , sq13_update_time , sq14_update_time , sq15_update_time , sq16_update_time , sq17_update_time , sq18_update_time , sq19_update_time , sq20_update_time , sq21_update_time , sq22_update_time , sq23_update_time , sq24_update_time , sq25_update_time , sq26_update_time , sq27_update_time , sq28_update_time , sq29_update_time , sq30_update_time , sq31_update_time , sq00_update_ms , sq01_update_ms , sq02_update_ms , sq03_update_ms , sq04_update_ms , sq05_update_ms , sq06_update_ms , sq07_update_ms , sq08_update_ms , sq09_update_ms , sq10_update_ms , sq11_update_ms , sq12_update_ms , sq13_update_ms , sq14_update_ms , sq15_update_ms , sq16_update_ms , sq17_update_ms , sq18_update_ms , sq19_update_ms , sq20_update_ms , sq21_update_ms , sq22_update_ms , sq23_update_ms , sq24_update_ms , sq25_update_ms , sq26_update_ms , sq27_update_ms , sq28_update_ms , sq29_update_ms , sq30_update_ms , sq31_update_ms , sq00_new_price , sq01_new_price , sq02_new_price , sq03_new_price , sq04_new_price , sq05_new_price , sq06_new_price , sq07_new_price , sq08_new_price , sq09_new_price , sq10_new_price , sq11_new_price , sq12_new_price , sq13_new_price , sq14_new_price , sq15_new_price , sq16_new_price , sq17_new_price , sq18_new_price , sq19_new_price , sq20_new_price , sq21_new_price , sq22_new_price , sq23_new_price , sq24_new_price , sq25_new_price , sq26_new_price , sq27_new_price , sq28_new_price , sq29_new_price , sq30_new_price , sq31_new_price , sq00_turnover , sq01_turnover , sq02_turnover , sq03_turnover , sq04_turnover , sq05_turnover , sq06_turnover , sq07_turnover , sq08_turnover , sq09_turnover , sq10_turnover , sq11_turnover , sq12_turnover , sq13_turnover , sq14_turnover , sq15_turnover , sq16_turnover , sq17_turnover , sq18_turnover , sq19_turnover , sq20_turnover , sq21_turnover , sq22_turnover , sq23_turnover , sq24_turnover , sq25_turnover , sq26_turnover , sq27_turnover , sq28_turnover , sq29_turnover , sq30_turnover , sq31_turnover , sq00_volume , sq01_volume , sq02_volume , sq03_volume , sq04_volume , sq05_volume , sq06_volume , sq07_volume , sq08_volume , sq09_volume , sq10_volume , sq11_volume , sq12_volume , sq13_volume , sq14_volume , sq15_volume , sq16_volume , sq17_volume , sq18_volume , sq19_volume , sq20_volume , sq21_volume , sq22_volume , sq23_volume , sq24_volume , sq25_volume , sq26_volume , sq27_volume , sq28_volume , sq29_volume , sq30_volume , sq31_volume , sq00_position , sq01_position , sq02_position , sq03_position , sq04_position , sq05_position , sq06_position , sq07_position , sq08_position , sq09_position , sq10_position , sq11_position , sq12_position , sq13_position , sq14_position , sq15_position , sq16_position , sq17_position , sq18_position , sq19_position , sq20_position , sq21_position , sq22_position , sq23_position , sq24_position , sq25_position , sq26_position , sq27_position , sq28_position , sq29_position , sq30_position , sq31_position , sq00_purchase_price , sq01_purchase_price , sq02_purchase_price , sq03_purchase_price , sq04_purchase_price , sq05_purchase_price , sq06_purchase_price , sq07_purchase_price , sq08_purchase_price , sq09_purchase_price , sq10_purchase_price , sq11_purchase_price , sq12_purchase_price , sq13_purchase_price , sq14_purchase_price , sq15_purchase_price , sq16_purchase_price , sq17_purchase_price , sq18_purchase_price , sq19_purchase_price , sq20_purchase_price , sq21_purchase_price , sq22_purchase_price , sq23_purchase_price , sq24_purchase_price , sq25_purchase_price , sq26_purchase_price , sq27_purchase_price , sq28_purchase_price , sq29_purchase_price , sq30_purchase_price , sq31_purchase_price , sq00_buy_quantity , sq01_buy_quantity , sq02_buy_quantity , sq03_buy_quantity , sq04_buy_quantity , sq05_buy_quantity , sq06_buy_quantity , sq07_buy_quantity , sq08_buy_quantity , sq09_buy_quantity , sq10_buy_quantity , sq11_buy_quantity , sq12_buy_quantity , sq13_buy_quantity , sq14_buy_quantity , sq15_buy_quantity , sq16_buy_quantity , sq17_buy_quantity , sq18_buy_quantity , sq19_buy_quantity , sq20_buy_quantity , sq21_buy_quantity , sq22_buy_quantity , sq23_buy_quantity , sq24_buy_quantity , sq25_buy_quantity , sq26_buy_quantity , sq27_buy_quantity , sq28_buy_quantity , sq29_buy_quantity , sq30_buy_quantity , sq31_buy_quantity , sq00_sell_price , sq01_sell_price , sq02_sell_price , sq03_sell_price , sq04_sell_price , sq05_sell_price , sq06_sell_price , sq07_sell_price , sq08_sell_price , sq09_sell_price , sq10_sell_price , sq11_sell_price , sq12_sell_price , sq13_sell_price , sq14_sell_price , sq15_sell_price , sq16_sell_price , sq17_sell_price , sq18_sell_price , sq19_sell_price , sq20_sell_price , sq21_sell_price , sq22_sell_price , sq23_sell_price , sq24_sell_price , sq25_sell_price , sq26_sell_price , sq27_sell_price , sq28_sell_price , sq29_sell_price , sq30_sell_price , sq31_sell_price , sq00_sell_quantity , sq01_sell_quantity , sq02_sell_quantity , sq03_sell_quantity , sq04_sell_quantity , sq05_sell_quantity , sq06_sell_quantity , sq07_sell_quantity , sq08_sell_quantity , sq09_sell_quantity , sq10_sell_quantity , sq11_sell_quantity , sq12_sell_quantity , sq13_sell_quantity , sq14_sell_quantity , sq15_sell_quantity , sq16_sell_quantity , sq17_sell_quantity , sq18_sell_quantity , sq19_sell_quantity , sq20_sell_quantity , sq21_sell_quantity , sq22_sell_quantity , sq23_sell_quantity , sq24_sell_quantity , sq25_sell_quantity , sq26_sell_quantity , sq27_sell_quantity , sq28_sell_quantity , sq29_sell_quantity , sq30_sell_quantity , sq31_sell_quantity , sq00_market_rdy , sq01_market_rdy , sq02_market_rdy , sq03_market_rdy , sq04_market_rdy , sq05_market_rdy , sq06_market_rdy , sq07_market_rdy , sq08_market_rdy , sq09_market_rdy , sq10_market_rdy , sq11_market_rdy , sq12_market_rdy , sq13_market_rdy , sq14_market_rdy , sq15_market_rdy , sq16_market_rdy , sq17_market_rdy , sq18_market_rdy , sq19_market_rdy , sq20_market_rdy , sq21_market_rdy , sq22_market_rdy , sq23_market_rdy , sq24_market_rdy , sq25_market_rdy , sq26_market_rdy , sq27_market_rdy , sq28_market_rdy , sq29_market_rdy , sq30_market_rdy , sq31_market_rdy , tlp_fifo_empty, tlp_fifo_rdata , tlp_fifo_data_vld, fifo_ready );
 parameter TLPG_IDLE = 4'd0 ;
 parameter TLPG_DA0 = 4'd1 ;
 input clk ;
 input rst_n ;
 input [ 23: 0] market_explain ;
 input [ 7: 0] info_classify ;
 input [ 31: 0] dialog_num ;
 input [ 7: 0] contract_flag ;
 input [ 31: 0] contract_num ;
 input [175: 0] contract_code ;
 input [ 71: 0] update_time ;
 input [ 31: 0] update_ms ;
 input [ 63: 0] new_price ;
 input [ 31: 0] turnover ;
 input [ 63: 0] volume ;
 input [ 63: 0] position ;
 input [ 63: 0] purchase_price ;
 input [ 31: 0] buy_quantity ;
 input [ 63: 0] sell_price ;
 input [ 31: 0] sell_quantity ;
 input market_rdy ;
 input params_filter_rst ;
 input [ 23: 0] sq00_market_explain ;
 input [ 23: 0] sq01_market_explain ;
 input [ 23: 0] sq02_market_explain ;
 input [ 23: 0] sq03_market_explain ;
 input [ 23: 0] sq04_market_explain ;
 input [ 23: 0] sq05_market_explain ;
 input [ 23: 0] sq06_market_explain ;
 input [ 23: 0] sq07_market_explain ;
 input [ 23: 0] sq08_market_explain ;
 input [ 23: 0] sq09_market_explain ;
 input [ 23: 0] sq10_market_explain ;
 input [ 23: 0] sq11_market_explain ;
 input [ 23: 0] sq12_market_explain ;
 input [ 23: 0] sq13_market_explain ;
 input [ 23: 0] sq14_market_explain ;
 input [ 23: 0] sq15_market_explain ;
 input [ 23: 0] sq16_market_explain ;
 input [ 23: 0] sq17_market_explain ;
 input [ 23: 0] sq18_market_explain ;
 input [ 23: 0] sq19_market_explain ;
 input [ 23: 0] sq20_market_explain ;
 input [ 23: 0] sq21_market_explain ;
 input [ 23: 0] sq22_market_explain ;
 input [ 23: 0] sq23_market_explain ;
 input [ 23: 0] sq24_market_explain ;
 input [ 23: 0] sq25_market_explain ;
 input [ 23: 0] sq26_market_explain ;
 input [ 23: 0] sq27_market_explain ;
 input [ 23: 0] sq28_market_explain ;
 input [ 23: 0] sq29_market_explain ;
 input [ 23: 0] sq30_market_explain ;
 input [ 23: 0] sq31_market_explain ;
 input [ 7: 0] sq00_info_classify ;
 input [ 7: 0] sq01_info_classify ;
 input [ 7: 0] sq02_info_classify ;
 input [ 7: 0] sq03_info_classify ;
 input [ 7: 0] sq04_info_classify ;
 input [ 7: 0] sq05_info_classify ;
 input [ 7: 0] sq06_info_classify ;
 input [ 7: 0] sq07_info_classify ;
 input [ 7: 0] sq08_info_classify ;
 input [ 7: 0] sq09_info_classify ;
 input [ 7: 0] sq10_info_classify ;
 input [ 7: 0] sq11_info_classify ;
 input [ 7: 0] sq12_info_classify ;
 input [ 7: 0] sq13_info_classify ;
 input [ 7: 0] sq14_info_classify ;
 input [ 7: 0] sq15_info_classify ;
 input [ 7: 0] sq16_info_classify ;
 input [ 7: 0] sq17_info_classify ;
 input [ 7: 0] sq18_info_classify ;
 input [ 7: 0] sq19_info_classify ;
 input [ 7: 0] sq20_info_classify ;
 input [ 7: 0] sq21_info_classify ;
 input [ 7: 0] sq22_info_classify ;
 input [ 7: 0] sq23_info_classify ;
 input [ 7: 0] sq24_info_classify ;
 input [ 7: 0] sq25_info_classify ;
 input [ 7: 0] sq26_info_classify ;
 input [ 7: 0] sq27_info_classify ;
 input [ 7: 0] sq28_info_classify ;
 input [ 7: 0] sq29_info_classify ;
 input [ 7: 0] sq30_info_classify ;
 input [ 7: 0] sq31_info_classify ;
 input [ 31: 0] sq00_dialog_num ;
 input [ 31: 0] sq01_dialog_num ;
 input [ 31: 0] sq02_dialog_num ;
 input [ 31: 0] sq03_dialog_num ;
 input [ 31: 0] sq04_dialog_num ;
 input [ 31: 0] sq05_dialog_num ;
 input [ 31: 0] sq06_dialog_num ;
 input [ 31: 0] sq07_dialog_num ;
 input [ 31: 0] sq08_dialog_num ;
 input [ 31: 0] sq09_dialog_num ;
 input [ 31: 0] sq10_dialog_num ;
 input [ 31: 0] sq11_dialog_num ;
 input [ 31: 0] sq12_dialog_num ;
 input [ 31: 0] sq13_dialog_num ;
 input [ 31: 0] sq14_dialog_num ;
 input [ 31: 0] sq15_dialog_num ;
 input [ 31: 0] sq16_dialog_num ;
 input [ 31: 0] sq17_dialog_num ;
 input [ 31: 0] sq18_dialog_num ;
 input [ 31: 0] sq19_dialog_num ;
 input [ 31: 0] sq20_dialog_num ;
 input [ 31: 0] sq21_dialog_num ;
 input [ 31: 0] sq22_dialog_num ;
 input [ 31: 0] sq23_dialog_num ;
 input [ 31: 0] sq24_dialog_num ;
 input [ 31: 0] sq25_dialog_num ;
 input [ 31: 0] sq26_dialog_num ;
 input [ 31: 0] sq27_dialog_num ;
 input [ 31: 0] sq28_dialog_num ;
 input [ 31: 0] sq29_dialog_num ;
 input [ 31: 0] sq30_dialog_num ;
 input [ 31: 0] sq31_dialog_num ;
 input [ 7: 0] sq00_contract_flag ;
 input [ 7: 0] sq01_contract_flag ;
 input [ 7: 0] sq02_contract_flag ;
 input [ 7: 0] sq03_contract_flag ;
 input [ 7: 0] sq04_contract_flag ;
 input [ 7: 0] sq05_contract_flag ;
 input [ 7: 0] sq06_contract_flag ;
 input [ 7: 0] sq07_contract_flag ;
 input [ 7: 0] sq08_contract_flag ;
 input [ 7: 0] sq09_contract_flag ;
 input [ 7: 0] sq10_contract_flag ;
 input [ 7: 0] sq11_contract_flag ;
 input [ 7: 0] sq12_contract_flag ;
 input [ 7: 0] sq13_contract_flag ;
 input [ 7: 0] sq14_contract_flag ;
 input [ 7: 0] sq15_contract_flag ;
 input [ 7: 0] sq16_contract_flag ;
 input [ 7: 0] sq17_contract_flag ;
 input [ 7: 0] sq18_contract_flag ;
 input [ 7: 0] sq19_contract_flag ;
 input [ 7: 0] sq20_contract_flag ;
 input [ 7: 0] sq21_contract_flag ;
 input [ 7: 0] sq22_contract_flag ;
 input [ 7: 0] sq23_contract_flag ;
 input [ 7: 0] sq24_contract_flag ;
 input [ 7: 0] sq25_contract_flag ;
 input [ 7: 0] sq26_contract_flag ;
 input [ 7: 0] sq27_contract_flag ;
 input [ 7: 0] sq28_contract_flag ;
 input [ 7: 0] sq29_contract_flag ;
 input [ 7: 0] sq30_contract_flag ;
 input [ 7: 0] sq31_contract_flag ;
 input [ 31: 0] sq00_contract_num ;
 input [ 31: 0] sq01_contract_num ;
 input [ 31: 0] sq02_contract_num ;
 input [ 31: 0] sq03_contract_num ;
 input [ 31: 0] sq04_contract_num ;
 input [ 31: 0] sq05_contract_num ;
 input [ 31: 0] sq06_contract_num ;
 input [ 31: 0] sq07_contract_num ;
 input [ 31: 0] sq08_contract_num ;
 input [ 31: 0] sq09_contract_num ;
 input [ 31: 0] sq10_contract_num ;
 input [ 31: 0] sq11_contract_num ;
 input [ 31: 0] sq12_contract_num ;
 input [ 31: 0] sq13_contract_num ;
 input [ 31: 0] sq14_contract_num ;
 input [ 31: 0] sq15_contract_num ;
 input [ 31: 0] sq16_contract_num ;
 input [ 31: 0] sq17_contract_num ;
 input [ 31: 0] sq18_contract_num ;
 input [ 31: 0] sq19_contract_num ;
 input [ 31: 0] sq20_contract_num ;
 input [ 31: 0] sq21_contract_num ;
 input [ 31: 0] sq22_contract_num ;
 input [ 31: 0] sq23_contract_num ;
 input [ 31: 0] sq24_contract_num ;
 input [ 31: 0] sq25_contract_num ;
 input [ 31: 0] sq26_contract_num ;
 input [ 31: 0] sq27_contract_num ;
 input [ 31: 0] sq28_contract_num ;
 input [ 31: 0] sq29_contract_num ;
 input [ 31: 0] sq30_contract_num ;
 input [ 31: 0] sq31_contract_num ;
 input [175: 0] sq00_contract_code ;
 input [175: 0] sq01_contract_code ;
 input [175: 0] sq02_contract_code ;
 input [175: 0] sq03_contract_code ;
 input [175: 0] sq04_contract_code ;
 input [175: 0] sq05_contract_code ;
 input [175: 0] sq06_contract_code ;
 input [175: 0] sq07_contract_code ;
 input [175: 0] sq08_contract_code ;
 input [175: 0] sq09_contract_code ;
 input [175: 0] sq10_contract_code ;
 input [175: 0] sq11_contract_code ;
 input [175: 0] sq12_contract_code ;
 input [175: 0] sq13_contract_code ;
 input [175: 0] sq14_contract_code ;
 input [175: 0] sq15_contract_code ;
 input [175: 0] sq16_contract_code ;
 input [175: 0] sq17_contract_code ;
 input [175: 0] sq18_contract_code ;
 input [175: 0] sq19_contract_code ;
 input [175: 0] sq20_contract_code ;
 input [175: 0] sq21_contract_code ;
 input [175: 0] sq22_contract_code ;
 input [175: 0] sq23_contract_code ;
 input [175: 0] sq24_contract_code ;
 input [175: 0] sq25_contract_code ;
 input [175: 0] sq26_contract_code ;
 input [175: 0] sq27_contract_code ;
 input [175: 0] sq28_contract_code ;
 input [175: 0] sq29_contract_code ;
 input [175: 0] sq30_contract_code ;
 input [175: 0] sq31_contract_code ;
 input [ 71: 0] sq00_update_time ;
 input [ 71: 0] sq01_update_time ;
 input [ 71: 0] sq02_update_time ;
 input [ 71: 0] sq03_update_time ;
 input [ 71: 0] sq04_update_time ;
 input [ 71: 0] sq05_update_time ;
 input [ 71: 0] sq06_update_time ;
 input [ 71: 0] sq07_update_time ;
 input [ 71: 0] sq08_update_time ;
 input [ 71: 0] sq09_update_time ;
 input [ 71: 0] sq10_update_time ;
 input [ 71: 0] sq11_update_time ;
 input [ 71: 0] sq12_update_time ;
 input [ 71: 0] sq13_update_time ;
 input [ 71: 0] sq14_update_time ;
 input [ 71: 0] sq15_update_time ;
 input [ 71: 0] sq16_update_time ;
 input [ 71: 0] sq17_update_time ;
 input [ 71: 0] sq18_update_time ;
 input [ 71: 0] sq19_update_time ;
 input [ 71: 0] sq20_update_time ;
 input [ 71: 0] sq21_update_time ;
 input [ 71: 0] sq22_update_time ;
 input [ 71: 0] sq23_update_time ;
 input [ 71: 0] sq24_update_time ;
 input [ 71: 0] sq25_update_time ;
 input [ 71: 0] sq26_update_time ;
 input [ 71: 0] sq27_update_time ;
 input [ 71: 0] sq28_update_time ;
 input [ 71: 0] sq29_update_time ;
 input [ 71: 0] sq30_update_time ;
 input [ 71: 0] sq31_update_time ;
 input [ 31: 0] sq00_update_ms ;
 input [ 31: 0] sq01_update_ms ;
 input [ 31: 0] sq02_update_ms ;
 input [ 31: 0] sq03_update_ms ;
 input [ 31: 0] sq04_update_ms ;
 input [ 31: 0] sq05_update_ms ;
 input [ 31: 0] sq06_update_ms ;
 input [ 31: 0] sq07_update_ms ;
 input [ 31: 0] sq08_update_ms ;
 input [ 31: 0] sq09_update_ms ;
 input [ 31: 0] sq10_update_ms ;
 input [ 31: 0] sq11_update_ms ;
 input [ 31: 0] sq12_update_ms ;
 input [ 31: 0] sq13_update_ms ;
 input [ 31: 0] sq14_update_ms ;
 input [ 31: 0] sq15_update_ms ;
 input [ 31: 0] sq16_update_ms ;
 input [ 31: 0] sq17_update_ms ;
 input [ 31: 0] sq18_update_ms ;
 input [ 31: 0] sq19_update_ms ;
 input [ 31: 0] sq20_update_ms ;
 input [ 31: 0] sq21_update_ms ;
 input [ 31: 0] sq22_update_ms ;
 input [ 31: 0] sq23_update_ms ;
 input [ 31: 0] sq24_update_ms ;
 input [ 31: 0] sq25_update_ms ;
 input [ 31: 0] sq26_update_ms ;
 input [ 31: 0] sq27_update_ms ;
 input [ 31: 0] sq28_update_ms ;
 input [ 31: 0] sq29_update_ms ;
 input [ 31: 0] sq30_update_ms ;
 input [ 31: 0] sq31_update_ms ;
 input [ 63: 0] sq00_new_price ;
 input [ 63: 0] sq01_new_price ;
 input [ 63: 0] sq02_new_price ;
 input [ 63: 0] sq03_new_price ;
 input [ 63: 0] sq04_new_price ;
 input [ 63: 0] sq05_new_price ;
 input [ 63: 0] sq06_new_price ;
 input [ 63: 0] sq07_new_price ;
 input [ 63: 0] sq08_new_price ;
 input [ 63: 0] sq09_new_price ;
 input [ 63: 0] sq10_new_price ;
 input [ 63: 0] sq11_new_price ;
 input [ 63: 0] sq12_new_price ;
 input [ 63: 0] sq13_new_price ;
 input [ 63: 0] sq14_new_price ;
 input [ 63: 0] sq15_new_price ;
 input [ 63: 0] sq16_new_price ;
 input [ 63: 0] sq17_new_price ;
 input [ 63: 0] sq18_new_price ;
 input [ 63: 0] sq19_new_price ;
 input [ 63: 0] sq20_new_price ;
 input [ 63: 0] sq21_new_price ;
 input [ 63: 0] sq22_new_price ;
 input [ 63: 0] sq23_new_price ;
 input [ 63: 0] sq24_new_price ;
 input [ 63: 0] sq25_new_price ;
 input [ 63: 0] sq26_new_price ;
 input [ 63: 0] sq27_new_price ;
 input [ 63: 0] sq28_new_price ;
 input [ 63: 0] sq29_new_price ;
 input [ 63: 0] sq30_new_price ;
 input [ 63: 0] sq31_new_price ;
 input [ 31: 0] sq00_turnover ;
 input [ 31: 0] sq01_turnover ;
 input [ 31: 0] sq02_turnover ;
 input [ 31: 0] sq03_turnover ;
 input [ 31: 0] sq04_turnover ;
 input [ 31: 0] sq05_turnover ;
 input [ 31: 0] sq06_turnover ;
 input [ 31: 0] sq07_turnover ;
 input [ 31: 0] sq08_turnover ;
 input [ 31: 0] sq09_turnover ;
 input [ 31: 0] sq10_turnover ;
 input [ 31: 0] sq11_turnover ;
 input [ 31: 0] sq12_turnover ;
 input [ 31: 0] sq13_turnover ;
 input [ 31: 0] sq14_turnover ;
 input [ 31: 0] sq15_turnover ;
 input [ 31: 0] sq16_turnover ;
 input [ 31: 0] sq17_turnover ;
 input [ 31: 0] sq18_turnover ;
 input [ 31: 0] sq19_turnover ;
 input [ 31: 0] sq20_turnover ;
 input [ 31: 0] sq21_turnover ;
 input [ 31: 0] sq22_turnover ;
 input [ 31: 0] sq23_turnover ;
 input [ 31: 0] sq24_turnover ;
 input [ 31: 0] sq25_turnover ;
 input [ 31: 0] sq26_turnover ;
 input [ 31: 0] sq27_turnover ;
 input [ 31: 0] sq28_turnover ;
 input [ 31: 0] sq29_turnover ;
 input [ 31: 0] sq30_turnover ;
 input [ 31: 0] sq31_turnover ;
 input [ 63: 0] sq00_volume ;
 input [ 63: 0] sq01_volume ;
 input [ 63: 0] sq02_volume ;
 input [ 63: 0] sq03_volume ;
 input [ 63: 0] sq04_volume ;
 input [ 63: 0] sq05_volume ;
 input [ 63: 0] sq06_volume ;
 input [ 63: 0] sq07_volume ;
 input [ 63: 0] sq08_volume ;
 input [ 63: 0] sq09_volume ;
 input [ 63: 0] sq10_volume ;
 input [ 63: 0] sq11_volume ;
 input [ 63: 0] sq12_volume ;
 input [ 63: 0] sq13_volume ;
 input [ 63: 0] sq14_volume ;
 input [ 63: 0] sq15_volume ;
 input [ 63: 0] sq16_volume ;
 input [ 63: 0] sq17_volume ;
 input [ 63: 0] sq18_volume ;
 input [ 63: 0] sq19_volume ;
 input [ 63: 0] sq20_volume ;
 input [ 63: 0] sq21_volume ;
 input [ 63: 0] sq22_volume ;
 input [ 63: 0] sq23_volume ;
 input [ 63: 0] sq24_volume ;
 input [ 63: 0] sq25_volume ;
 input [ 63: 0] sq26_volume ;
 input [ 63: 0] sq27_volume ;
 input [ 63: 0] sq28_volume ;
 input [ 63: 0] sq29_volume ;
 input [ 63: 0] sq30_volume ;
 input [ 63: 0] sq31_volume ;
 input [ 63: 0] sq00_position ;
 input [ 63: 0] sq01_position ;
 input [ 63: 0] sq02_position ;
 input [ 63: 0] sq03_position ;
 input [ 63: 0] sq04_position ;
 input [ 63: 0] sq05_position ;
 input [ 63: 0] sq06_position ;
 input [ 63: 0] sq07_position ;
 input [ 63: 0] sq08_position ;
 input [ 63: 0] sq09_position ;
 input [ 63: 0] sq10_position ;
 input [ 63: 0] sq11_position ;
 input [ 63: 0] sq12_position ;
 input [ 63: 0] sq13_position ;
 input [ 63: 0] sq14_position ;
 input [ 63: 0] sq15_position ;
 input [ 63: 0] sq16_position ;
 input [ 63: 0] sq17_position ;
 input [ 63: 0] sq18_position ;
 input [ 63: 0] sq19_position ;
 input [ 63: 0] sq20_position ;
 input [ 63: 0] sq21_position ;
 input [ 63: 0] sq22_position ;
 input [ 63: 0] sq23_position ;
 input [ 63: 0] sq24_position ;
 input [ 63: 0] sq25_position ;
 input [ 63: 0] sq26_position ;
 input [ 63: 0] sq27_position ;
 input [ 63: 0] sq28_position ;
 input [ 63: 0] sq29_position ;
 input [ 63: 0] sq30_position ;
 input [ 63: 0] sq31_position ;
 input [ 63: 0] sq00_purchase_price ;
 input [ 63: 0] sq01_purchase_price ;
 input [ 63: 0] sq02_purchase_price ;
 input [ 63: 0] sq03_purchase_price ;
 input [ 63: 0] sq04_purchase_price ;
 input [ 63: 0] sq05_purchase_price ;
 input [ 63: 0] sq06_purchase_price ;
 input [ 63: 0] sq07_purchase_price ;
 input [ 63: 0] sq08_purchase_price ;
 input [ 63: 0] sq09_purchase_price ;
 input [ 63: 0] sq10_purchase_price ;
 input [ 63: 0] sq11_purchase_price ;
 input [ 63: 0] sq12_purchase_price ;
 input [ 63: 0] sq13_purchase_price ;
 input [ 63: 0] sq14_purchase_price ;
 input [ 63: 0] sq15_purchase_price ;
 input [ 63: 0] sq16_purchase_price ;
 input [ 63: 0] sq17_purchase_price ;
 input [ 63: 0] sq18_purchase_price ;
 input [ 63: 0] sq19_purchase_price ;
 input [ 63: 0] sq20_purchase_price ;
 input [ 63: 0] sq21_purchase_price ;
 input [ 63: 0] sq22_purchase_price ;
 input [ 63: 0] sq23_purchase_price ;
 input [ 63: 0] sq24_purchase_price ;
 input [ 63: 0] sq25_purchase_price ;
 input [ 63: 0] sq26_purchase_price ;
 input [ 63: 0] sq27_purchase_price ;
 input [ 63: 0] sq28_purchase_price ;
 input [ 63: 0] sq29_purchase_price ;
 input [ 63: 0] sq30_purchase_price ;
 input [ 63: 0] sq31_purchase_price ;
 input [ 31: 0] sq00_buy_quantity ;
 input [ 31: 0] sq01_buy_quantity ;
 input [ 31: 0] sq02_buy_quantity ;
 input [ 31: 0] sq03_buy_quantity ;
 input [ 31: 0] sq04_buy_quantity ;
 input [ 31: 0] sq05_buy_quantity ;
 input [ 31: 0] sq06_buy_quantity ;
 input [ 31: 0] sq07_buy_quantity ;
 input [ 31: 0] sq08_buy_quantity ;
 input [ 31: 0] sq09_buy_quantity ;
 input [ 31: 0] sq10_buy_quantity ;
 input [ 31: 0] sq11_buy_quantity ;
 input [ 31: 0] sq12_buy_quantity ;
 input [ 31: 0] sq13_buy_quantity ;
 input [ 31: 0] sq14_buy_quantity ;
 input [ 31: 0] sq15_buy_quantity ;
 input [ 31: 0] sq16_buy_quantity ;
 input [ 31: 0] sq17_buy_quantity ;
 input [ 31: 0] sq18_buy_quantity ;
 input [ 31: 0] sq19_buy_quantity ;
 input [ 31: 0] sq20_buy_quantity ;
 input [ 31: 0] sq21_buy_quantity ;
 input [ 31: 0] sq22_buy_quantity ;
 input [ 31: 0] sq23_buy_quantity ;
 input [ 31: 0] sq24_buy_quantity ;
 input [ 31: 0] sq25_buy_quantity ;
 input [ 31: 0] sq26_buy_quantity ;
 input [ 31: 0] sq27_buy_quantity ;
 input [ 31: 0] sq28_buy_quantity ;
 input [ 31: 0] sq29_buy_quantity ;
 input [ 31: 0] sq30_buy_quantity ;
 input [ 31: 0] sq31_buy_quantity ;
 input [ 63: 0] sq00_sell_price ;
 input [ 63: 0] sq01_sell_price ;
 input [ 63: 0] sq02_sell_price ;
 input [ 63: 0] sq03_sell_price ;
 input [ 63: 0] sq04_sell_price ;
 input [ 63: 0] sq05_sell_price ;
 input [ 63: 0] sq06_sell_price ;
 input [ 63: 0] sq07_sell_price ;
 input [ 63: 0] sq08_sell_price ;
 input [ 63: 0] sq09_sell_price ;
 input [ 63: 0] sq10_sell_price ;
 input [ 63: 0] sq11_sell_price ;
 input [ 63: 0] sq12_sell_price ;
 input [ 63: 0] sq13_sell_price ;
 input [ 63: 0] sq14_sell_price ;
 input [ 63: 0] sq15_sell_price ;
 input [ 63: 0] sq16_sell_price ;
 input [ 63: 0] sq17_sell_price ;
 input [ 63: 0] sq18_sell_price ;
 input [ 63: 0] sq19_sell_price ;
 input [ 63: 0] sq20_sell_price ;
 input [ 63: 0] sq21_sell_price ;
 input [ 63: 0] sq22_sell_price ;
 input [ 63: 0] sq23_sell_price ;
 input [ 63: 0] sq24_sell_price ;
 input [ 63: 0] sq25_sell_price ;
 input [ 63: 0] sq26_sell_price ;
 input [ 63: 0] sq27_sell_price ;
 input [ 63: 0] sq28_sell_price ;
 input [ 63: 0] sq29_sell_price ;
 input [ 63: 0] sq30_sell_price ;
 input [ 63: 0] sq31_sell_price ;
 input [ 31: 0] sq00_sell_quantity ;
 input [ 31: 0] sq01_sell_quantity ;
 input [ 31: 0] sq02_sell_quantity ;
 input [ 31: 0] sq03_sell_quantity ;
 input [ 31: 0] sq04_sell_quantity ;
 input [ 31: 0] sq05_sell_quantity ;
 input [ 31: 0] sq06_sell_quantity ;
 input [ 31: 0] sq07_sell_quantity ;
 input [ 31: 0] sq08_sell_quantity ;
 input [ 31: 0] sq09_sell_quantity ;
 input [ 31: 0] sq10_sell_quantity ;
 input [ 31: 0] sq11_sell_quantity ;
 input [ 31: 0] sq12_sell_quantity ;
 input [ 31: 0] sq13_sell_quantity ;
 input [ 31: 0] sq14_sell_quantity ;
 input [ 31: 0] sq15_sell_quantity ;
 input [ 31: 0] sq16_sell_quantity ;
 input [ 31: 0] sq17_sell_quantity ;
 input [ 31: 0] sq18_sell_quantity ;
 input [ 31: 0] sq19_sell_quantity ;
 input [ 31: 0] sq20_sell_quantity ;
 input [ 31: 0] sq21_sell_quantity ;
 input [ 31: 0] sq22_sell_quantity ;
 input [ 31: 0] sq23_sell_quantity ;
 input [ 31: 0] sq24_sell_quantity ;
 input [ 31: 0] sq25_sell_quantity ;
 input [ 31: 0] sq26_sell_quantity ;
 input [ 31: 0] sq27_sell_quantity ;
 input [ 31: 0] sq28_sell_quantity ;
 input [ 31: 0] sq29_sell_quantity ;
 input [ 31: 0] sq30_sell_quantity ;
 input [ 31: 0] sq31_sell_quantity ;
 input sq00_market_rdy ;
 input sq01_market_rdy ;
 input sq02_market_rdy ;
 input sq03_market_rdy ;
 input sq04_market_rdy ;
 input sq05_market_rdy ;
 input sq06_market_rdy ;
 input sq07_market_rdy ;
 input sq08_market_rdy ;
 input sq09_market_rdy ;
 input sq10_market_rdy ;
 input sq11_market_rdy ;
 input sq12_market_rdy ;
 input sq13_market_rdy ;
 input sq14_market_rdy ;
 input sq15_market_rdy ;
 input sq16_market_rdy ;
 input sq17_market_rdy ;
 input sq18_market_rdy ;
 input sq19_market_rdy ;
 input sq20_market_rdy ;
 input sq21_market_rdy ;
 input sq22_market_rdy ;
 input sq23_market_rdy ;
 input sq24_market_rdy ;
 input sq25_market_rdy ;
 input sq26_market_rdy ;
 input sq27_market_rdy ;
 input sq28_market_rdy ;
 input sq29_market_rdy ;
 input sq30_market_rdy ;
 input sq31_market_rdy ;
 output tlp_fifo_empty;
 output reg [255:0] tlp_fifo_rdata ;
 output reg tlp_fifo_data_vld;
 input fifo_ready;
 wire [255:0] rmem_data0 ;
 wire [255:0] rmem_data1 ;
 wire [255:0] rmem_data2 ;
 wire [ 31:0] rmem_data3 ;
 wire rmem_vld ;
 wire [255:0] rmem_data0_0 ;
 wire [255:0] rmem_data0_1 ;
 wire rmem_data0_0_vld ;
 wire rmem_data0_1_vld ;
 wire [255:0] rmem_data0_2 ;
 wire [255:0] rmem_data0_3 ;
 wire rmem_data0_2_vld ;
 wire rmem_data0_3_vld ;
 filter_tlp_reg_gen filter_tlp_reg_gen ( .clk ( clk ) , .rst_n ( rst_n ) , .params_filter_rst (params_filter_rst ) , .market_explain ( market_explain ) , .info_classify ( info_classify ) , .dialog_num ( dialog_num ) , .contract_flag ( contract_flag ) , .contract_num ( contract_num ) , .contract_code ( contract_code ) , .update_time ( update_time ) , .update_ms ( update_ms ) , .new_price ( new_price ) , .turnover ( turnover ) , .volume ( volume ) , .position ( position ) , .purchase_price ( purchase_price ) , .buy_quantity ( buy_quantity ) , .sell_price ( sell_price ) , .sell_quantity ( sell_quantity ) , .market_rdy ( market_rdy ) , .sq00_market_explain ( sq00_market_explain ) , .sq00_info_classify ( sq00_info_classify ) , .sq00_dialog_num ( sq00_dialog_num ) , .sq00_contract_flag ( sq00_contract_flag ) , .sq00_contract_num ( sq00_contract_num ) , .sq00_contract_code ( sq00_contract_code ) , .sq00_update_time ( sq00_update_time ) , .sq00_update_ms ( sq00_update_ms ) , .sq00_new_price ( sq00_new_price ) , .sq00_turnover ( sq00_turnover ) , .sq00_volume ( sq00_volume ) , .sq00_position ( sq00_position ) , .sq00_purchase_price ( sq00_purchase_price ) , .sq00_buy_quantity ( sq00_buy_quantity ) , .sq00_sell_price ( sq00_sell_price ) , .sq00_sell_quantity ( sq00_sell_quantity ) , .sq00_market_rdy ( sq00_market_rdy ) , .sq01_market_explain ( sq01_market_explain ) , .sq01_info_classify ( sq01_info_classify ) , .sq01_dialog_num ( sq01_dialog_num ) , .sq01_contract_flag ( sq01_contract_flag ) , .sq01_contract_num ( sq01_contract_num ) , .sq01_contract_code ( sq01_contract_code ) , .sq01_update_time ( sq01_update_time ) , .sq01_update_ms ( sq01_update_ms ) , .sq01_new_price ( sq01_new_price ) , .sq01_turnover ( sq01_turnover ) , .sq01_volume ( sq01_volume ) , .sq01_position ( sq01_position ) , .sq01_purchase_price ( sq01_purchase_price ) , .sq01_buy_quantity ( sq01_buy_quantity ) , .sq01_sell_price ( sq01_sell_price ) , .sq01_sell_quantity ( sq01_sell_quantity ) , .sq01_market_rdy ( sq01_market_rdy ) , .sq02_market_explain ( sq02_market_explain ) , .sq02_info_classify ( sq02_info_classify ) , .sq02_dialog_num ( sq02_dialog_num ) , .sq02_contract_flag ( sq02_contract_flag ) , .sq02_contract_num ( sq02_contract_num ) , .sq02_contract_code ( sq02_contract_code ) , .sq02_update_time ( sq02_update_time ) , .sq02_update_ms ( sq02_update_ms ) , .sq02_new_price ( sq02_new_price ) , .sq02_turnover ( sq02_turnover ) , .sq02_volume ( sq02_volume ) , .sq02_position ( sq02_position ) , .sq02_purchase_price ( sq02_purchase_price ) , .sq02_buy_quantity ( sq02_buy_quantity ) , .sq02_sell_price ( sq02_sell_price ) , .sq02_sell_quantity ( sq02_sell_quantity ) , .sq02_market_rdy ( sq02_market_rdy ) , .sq03_market_explain ( sq03_market_explain ) , .sq03_info_classify ( sq03_info_classify ) , .sq03_dialog_num ( sq03_dialog_num ) , .sq03_contract_flag ( sq03_contract_flag ) , .sq03_contract_num ( sq03_contract_num ) , .sq03_contract_code ( sq03_contract_code ) , .sq03_update_time ( sq03_update_time ) , .sq03_update_ms ( sq03_update_ms ) , .sq03_new_price ( sq03_new_price ) , .sq03_turnover ( sq03_turnover ) , .sq03_volume ( sq03_volume ) , .sq03_position ( sq03_position ) , .sq03_purchase_price ( sq03_purchase_price ) , .sq03_buy_quantity ( sq03_buy_quantity ) , .sq03_sell_price ( sq03_sell_price ) , .sq03_sell_quantity ( sq03_sell_quantity ) , .sq03_market_rdy ( sq03_market_rdy ) , .sq04_market_explain ( sq04_market_explain ) , .sq04_info_classify ( sq04_info_classify ) , .sq04_dialog_num ( sq04_dialog_num ) , .sq04_contract_flag ( sq04_contract_flag ) , .sq04_contract_num ( sq04_contract_num ) , .sq04_contract_code ( sq04_contract_code ) , .sq04_update_time ( sq04_update_time ) , .sq04_update_ms ( sq04_update_ms ) , .sq04_new_price ( sq04_new_price ) , .sq04_turnover ( sq04_turnover ) , .sq04_volume ( sq04_volume ) , .sq04_position ( sq04_position ) , .sq04_purchase_price ( sq04_purchase_price ) , .sq04_buy_quantity ( sq04_buy_quantity ) , .sq04_sell_price ( sq04_sell_price ) , .sq04_sell_quantity ( sq04_sell_quantity ) , .sq04_market_rdy ( sq04_market_rdy ) , .sq05_market_explain ( sq05_market_explain ) , .sq05_info_classify ( sq05_info_classify ) , .sq05_dialog_num ( sq05_dialog_num ) , .sq05_contract_flag ( sq05_contract_flag ) , .sq05_contract_num ( sq05_contract_num ) , .sq05_contract_code ( sq05_contract_code ) , .sq05_update_time ( sq05_update_time ) , .sq05_update_ms ( sq05_update_ms ) , .sq05_new_price ( sq05_new_price ) , .sq05_turnover ( sq05_turnover ) , .sq05_volume ( sq05_volume ) , .sq05_position ( sq05_position ) , .sq05_purchase_price ( sq05_purchase_price ) , .sq05_buy_quantity ( sq05_buy_quantity ) , .sq05_sell_price ( sq05_sell_price ) , .sq05_sell_quantity ( sq05_sell_quantity ) , .sq05_market_rdy ( sq05_market_rdy ) , .sq06_market_explain ( sq06_market_explain ) , .sq06_info_classify ( sq06_info_classify ) , .sq06_dialog_num ( sq06_dialog_num ) , .sq06_contract_flag ( sq06_contract_flag ) , .sq06_contract_num ( sq06_contract_num ) , .sq06_contract_code ( sq06_contract_code ) , .sq06_update_time ( sq06_update_time ) , .sq06_update_ms ( sq06_update_ms ) , .sq06_new_price ( sq06_new_price ) , .sq06_turnover ( sq06_turnover ) , .sq06_volume ( sq06_volume ) , .sq06_position ( sq06_position ) , .sq06_purchase_price ( sq06_purchase_price ) , .sq06_buy_quantity ( sq06_buy_quantity ) , .sq06_sell_price ( sq06_sell_price ) , .sq06_sell_quantity ( sq06_sell_quantity ) , .sq06_market_rdy ( sq06_market_rdy ) , .sq07_market_explain ( sq07_market_explain ) , .sq07_info_classify ( sq07_info_classify ) , .sq07_dialog_num ( sq07_dialog_num ) , .sq07_contract_flag ( sq07_contract_flag ) , .sq07_contract_num ( sq07_contract_num ) , .sq07_contract_code ( sq07_contract_code ) , .sq07_update_time ( sq07_update_time ) , .sq07_update_ms ( sq07_update_ms ) , .sq07_new_price ( sq07_new_price ) , .sq07_turnover ( sq07_turnover ) , .sq07_volume ( sq07_volume ) , .sq07_position ( sq07_position ) , .sq07_purchase_price ( sq07_purchase_price ) , .sq07_buy_quantity ( sq07_buy_quantity ) , .sq07_sell_price ( sq07_sell_price ) , .sq07_sell_quantity ( sq07_sell_quantity ) , .sq07_market_rdy ( sq07_market_rdy ) , .sq08_market_explain ( sq08_market_explain ) , .sq08_info_classify ( sq08_info_classify ) , .sq08_dialog_num ( sq08_dialog_num ) , .sq08_contract_flag ( sq08_contract_flag ) , .sq08_contract_num ( sq08_contract_num ) , .sq08_contract_code ( sq08_contract_code ) , .sq08_update_time ( sq08_update_time ) , .sq08_update_ms ( sq08_update_ms ) , .sq08_new_price ( sq08_new_price ) , .sq08_turnover ( sq08_turnover ) , .sq08_volume ( sq08_volume ) , .sq08_position ( sq08_position ) , .sq08_purchase_price ( sq08_purchase_price ) , .sq08_buy_quantity ( sq08_buy_quantity ) , .sq08_sell_price ( sq08_sell_price ) , .sq08_sell_quantity ( sq08_sell_quantity ) , .sq08_market_rdy ( sq08_market_rdy ) , .sq09_market_explain ( sq09_market_explain ) , .sq09_info_classify ( sq09_info_classify ) , .sq09_dialog_num ( sq09_dialog_num ) , .sq09_contract_flag ( sq09_contract_flag ) , .sq09_contract_num ( sq09_contract_num ) , .sq09_contract_code ( sq09_contract_code ) , .sq09_update_time ( sq09_update_time ) , .sq09_update_ms ( sq09_update_ms ) , .sq09_new_price ( sq09_new_price ) , .sq09_turnover ( sq09_turnover ) , .sq09_volume ( sq09_volume ) , .sq09_position ( sq09_position ) , .sq09_purchase_price ( sq09_purchase_price ) , .sq09_buy_quantity ( sq09_buy_quantity ) , .sq09_sell_price ( sq09_sell_price ) , .sq09_sell_quantity ( sq09_sell_quantity ) , .sq09_market_rdy ( sq09_market_rdy ) , .sq10_market_explain ( sq10_market_explain ) , .sq10_info_classify ( sq10_info_classify ) , .sq10_dialog_num ( sq10_dialog_num ) , .sq10_contract_flag ( sq10_contract_flag ) , .sq10_contract_num ( sq10_contract_num ) , .sq10_contract_code ( sq10_contract_code ) , .sq10_update_time ( sq10_update_time ) , .sq10_update_ms ( sq10_update_ms ) , .sq10_new_price ( sq10_new_price ) , .sq10_turnover ( sq10_turnover ) , .sq10_volume ( sq10_volume ) , .sq10_position ( sq10_position ) , .sq10_purchase_price ( sq10_purchase_price ) , .sq10_buy_quantity ( sq10_buy_quantity ) , .sq10_sell_price ( sq10_sell_price ) , .sq10_sell_quantity ( sq10_sell_quantity ) , .sq10_market_rdy ( sq10_market_rdy ) , .sq11_market_explain ( sq11_market_explain ) , .sq11_info_classify ( sq11_info_classify ) , .sq11_dialog_num ( sq11_dialog_num ) , .sq11_contract_flag ( sq11_contract_flag ) , .sq11_contract_num ( sq11_contract_num ) , .sq11_contract_code ( sq11_contract_code ) , .sq11_update_time ( sq11_update_time ) , .sq11_update_ms ( sq11_update_ms ) , .sq11_new_price ( sq11_new_price ) , .sq11_turnover ( sq11_turnover ) , .sq11_volume ( sq11_volume ) , .sq11_position ( sq11_position ) , .sq11_purchase_price ( sq11_purchase_price ) , .sq11_buy_quantity ( sq11_buy_quantity ) , .sq11_sell_price ( sq11_sell_price ) , .sq11_sell_quantity ( sq11_sell_quantity ) , .sq11_market_rdy ( sq11_market_rdy ) , .sq12_market_explain ( sq12_market_explain ) , .sq12_info_classify ( sq12_info_classify ) , .sq12_dialog_num ( sq12_dialog_num ) , .sq12_contract_flag ( sq12_contract_flag ) , .sq12_contract_num ( sq12_contract_num ) , .sq12_contract_code ( sq12_contract_code ) , .sq12_update_time ( sq12_update_time ) , .sq12_update_ms ( sq12_update_ms ) , .sq12_new_price ( sq12_new_price ) , .sq12_turnover ( sq12_turnover ) , .sq12_volume ( sq12_volume ) , .sq12_position ( sq12_position ) , .sq12_purchase_price ( sq12_purchase_price ) , .sq12_buy_quantity ( sq12_buy_quantity ) , .sq12_sell_price ( sq12_sell_price ) , .sq12_sell_quantity ( sq12_sell_quantity ) , .sq12_market_rdy ( sq12_market_rdy ) , .sq13_market_explain ( sq13_market_explain ) , .sq13_info_classify ( sq13_info_classify ) , .sq13_dialog_num ( sq13_dialog_num ) , .sq13_contract_flag ( sq13_contract_flag ) , .sq13_contract_num ( sq13_contract_num ) , .sq13_contract_code ( sq13_contract_code ) , .sq13_update_time ( sq13_update_time ) , .sq13_update_ms ( sq13_update_ms ) , .sq13_new_price ( sq13_new_price ) , .sq13_turnover ( sq13_turnover ) , .sq13_volume ( sq13_volume ) , .sq13_position ( sq13_position ) , .sq13_purchase_price ( sq13_purchase_price ) , .sq13_buy_quantity ( sq13_buy_quantity ) , .sq13_sell_price ( sq13_sell_price ) , .sq13_sell_quantity ( sq13_sell_quantity ) , .sq13_market_rdy ( sq13_market_rdy ) , .sq14_market_explain ( sq14_market_explain ) , .sq14_info_classify ( sq14_info_classify ) , .sq14_dialog_num ( sq14_dialog_num ) , .sq14_contract_flag ( sq14_contract_flag ) , .sq14_contract_num ( sq14_contract_num ) , .sq14_contract_code ( sq14_contract_code ) , .sq14_update_time ( sq14_update_time ) , .sq14_update_ms ( sq14_update_ms ) , .sq14_new_price ( sq14_new_price ) , .sq14_turnover ( sq14_turnover ) , .sq14_volume ( sq14_volume ) , .sq14_position ( sq14_position ) , .sq14_purchase_price ( sq14_purchase_price ) , .sq14_buy_quantity ( sq14_buy_quantity ) , .sq14_sell_price ( sq14_sell_price ) , .sq14_sell_quantity ( sq14_sell_quantity ) , .sq14_market_rdy ( sq14_market_rdy ) , .sq15_market_explain ( sq15_market_explain ) , .sq15_info_classify ( sq15_info_classify ) , .sq15_dialog_num ( sq15_dialog_num ) , .sq15_contract_flag ( sq15_contract_flag ) , .sq15_contract_num ( sq15_contract_num ) , .sq15_contract_code ( sq15_contract_code ) , .sq15_update_time ( sq15_update_time ) , .sq15_update_ms ( sq15_update_ms ) , .sq15_new_price ( sq15_new_price ) , .sq15_turnover ( sq15_turnover ) , .sq15_volume ( sq15_volume ) , .sq15_position ( sq15_position ) , .sq15_purchase_price ( sq15_purchase_price ) , .sq15_buy_quantity ( sq15_buy_quantity ) , .sq15_sell_price ( sq15_sell_price ) , .sq15_sell_quantity ( sq15_sell_quantity ) , .sq15_market_rdy ( sq15_market_rdy ) , .sq16_market_explain ( sq16_market_explain ) , .sq16_info_classify ( sq16_info_classify ) , .sq16_dialog_num ( sq16_dialog_num ) , .sq16_contract_flag ( sq16_contract_flag ) , .sq16_contract_num ( sq16_contract_num ) , .sq16_contract_code ( sq16_contract_code ) , .sq16_update_time ( sq16_update_time ) , .sq16_update_ms ( sq16_update_ms ) , .sq16_new_price ( sq16_new_price ) , .sq16_turnover ( sq16_turnover ) , .sq16_volume ( sq16_volume ) , .sq16_position ( sq16_position ) , .sq16_purchase_price ( sq16_purchase_price ) , .sq16_buy_quantity ( sq16_buy_quantity ) , .sq16_sell_price ( sq16_sell_price ) , .sq16_sell_quantity ( sq16_sell_quantity ) , .sq16_market_rdy ( sq16_market_rdy ) , .sq17_market_explain ( sq17_market_explain ) , .sq17_info_classify ( sq17_info_classify ) , .sq17_dialog_num ( sq17_dialog_num ) , .sq17_contract_flag ( sq17_contract_flag ) , .sq17_contract_num ( sq17_contract_num ) , .sq17_contract_code ( sq17_contract_code ) , .sq17_update_time ( sq17_update_time ) , .sq17_update_ms ( sq17_update_ms ) , .sq17_new_price ( sq17_new_price ) , .sq17_turnover ( sq17_turnover ) , .sq17_volume ( sq17_volume ) , .sq17_position ( sq17_position ) , .sq17_purchase_price ( sq17_purchase_price ) , .sq17_buy_quantity ( sq17_buy_quantity ) , .sq17_sell_price ( sq17_sell_price ) , .sq17_sell_quantity ( sq17_sell_quantity ) , .sq17_market_rdy ( sq17_market_rdy ) , .sq18_market_explain ( sq18_market_explain ) , .sq18_info_classify ( sq18_info_classify ) , .sq18_dialog_num ( sq18_dialog_num ) , .sq18_contract_flag ( sq18_contract_flag ) , .sq18_contract_num ( sq18_contract_num ) , .sq18_contract_code ( sq18_contract_code ) , .sq18_update_time ( sq18_update_time ) , .sq18_update_ms ( sq18_update_ms ) , .sq18_new_price ( sq18_new_price ) , .sq18_turnover ( sq18_turnover ) , .sq18_volume ( sq18_volume ) , .sq18_position ( sq18_position ) , .sq18_purchase_price ( sq18_purchase_price ) , .sq18_buy_quantity ( sq18_buy_quantity ) , .sq18_sell_price ( sq18_sell_price ) , .sq18_sell_quantity ( sq18_sell_quantity ) , .sq18_market_rdy ( sq18_market_rdy ) , .sq19_market_explain ( sq19_market_explain ) , .sq19_info_classify ( sq19_info_classify ) , .sq19_dialog_num ( sq19_dialog_num ) , .sq19_contract_flag ( sq19_contract_flag ) , .sq19_contract_num ( sq19_contract_num ) , .sq19_contract_code ( sq19_contract_code ) , .sq19_update_time ( sq19_update_time ) , .sq19_update_ms ( sq19_update_ms ) , .sq19_new_price ( sq19_new_price ) , .sq19_turnover ( sq19_turnover ) , .sq19_volume ( sq19_volume ) , .sq19_position ( sq19_position ) , .sq19_purchase_price ( sq19_purchase_price ) , .sq19_buy_quantity ( sq19_buy_quantity ) , .sq19_sell_price ( sq19_sell_price ) , .sq19_sell_quantity ( sq19_sell_quantity ) , .sq19_market_rdy ( sq19_market_rdy ) , .sq20_market_explain ( sq20_market_explain ) , .sq20_info_classify ( sq20_info_classify ) , .sq20_dialog_num ( sq20_dialog_num ) , .sq20_contract_flag ( sq20_contract_flag ) , .sq20_contract_num ( sq20_contract_num ) , .sq20_contract_code ( sq20_contract_code ) , .sq20_update_time ( sq20_update_time ) , .sq20_update_ms ( sq20_update_ms ) , .sq20_new_price ( sq20_new_price ) , .sq20_turnover ( sq20_turnover ) , .sq20_volume ( sq20_volume ) , .sq20_position ( sq20_position ) , .sq20_purchase_price ( sq20_purchase_price ) , .sq20_buy_quantity ( sq20_buy_quantity ) , .sq20_sell_price ( sq20_sell_price ) , .sq20_sell_quantity ( sq20_sell_quantity ) , .sq20_market_rdy ( sq20_market_rdy ) , .sq21_market_explain ( sq21_market_explain ) , .sq21_info_classify ( sq21_info_classify ) , .sq21_dialog_num ( sq21_dialog_num ) , .sq21_contract_flag ( sq21_contract_flag ) , .sq21_contract_num ( sq21_contract_num ) , .sq21_contract_code ( sq21_contract_code ) , .sq21_update_time ( sq21_update_time ) , .sq21_update_ms ( sq21_update_ms ) , .sq21_new_price ( sq21_new_price ) , .sq21_turnover ( sq21_turnover ) , .sq21_volume ( sq21_volume ) , .sq21_position ( sq21_position ) , .sq21_purchase_price ( sq21_purchase_price ) , .sq21_buy_quantity ( sq21_buy_quantity ) , .sq21_sell_price ( sq21_sell_price ) , .sq21_sell_quantity ( sq21_sell_quantity ) , .sq21_market_rdy ( sq21_market_rdy ) , .sq22_market_explain ( sq22_market_explain ) , .sq22_info_classify ( sq22_info_classify ) , .sq22_dialog_num ( sq22_dialog_num ) , .sq22_contract_flag ( sq22_contract_flag ) , .sq22_contract_num ( sq22_contract_num ) , .sq22_contract_code ( sq22_contract_code ) , .sq22_update_time ( sq22_update_time ) , .sq22_update_ms ( sq22_update_ms ) , .sq22_new_price ( sq22_new_price ) , .sq22_turnover ( sq22_turnover ) , .sq22_volume ( sq22_volume ) , .sq22_position ( sq22_position ) , .sq22_purchase_price ( sq22_purchase_price ) , .sq22_buy_quantity ( sq22_buy_quantity ) , .sq22_sell_price ( sq22_sell_price ) , .sq22_sell_quantity ( sq22_sell_quantity ) , .sq22_market_rdy ( sq22_market_rdy ) , .sq23_market_explain ( sq23_market_explain ) , .sq23_info_classify ( sq23_info_classify ) , .sq23_dialog_num ( sq23_dialog_num ) , .sq23_contract_flag ( sq23_contract_flag ) , .sq23_contract_num ( sq23_contract_num ) , .sq23_contract_code ( sq23_contract_code ) , .sq23_update_time ( sq23_update_time ) , .sq23_update_ms ( sq23_update_ms ) , .sq23_new_price ( sq23_new_price ) , .sq23_turnover ( sq23_turnover ) , .sq23_volume ( sq23_volume ) , .sq23_position ( sq23_position ) , .sq23_purchase_price ( sq23_purchase_price ) , .sq23_buy_quantity ( sq23_buy_quantity ) , .sq23_sell_price ( sq23_sell_price ) , .sq23_sell_quantity ( sq23_sell_quantity ) , .sq23_market_rdy ( sq23_market_rdy ) , .sq24_market_explain ( sq24_market_explain ) , .sq24_info_classify ( sq24_info_classify ) , .sq24_dialog_num ( sq24_dialog_num ) , .sq24_contract_flag ( sq24_contract_flag ) , .sq24_contract_num ( sq24_contract_num ) , .sq24_contract_code ( sq24_contract_code ) , .sq24_update_time ( sq24_update_time ) , .sq24_update_ms ( sq24_update_ms ) , .sq24_new_price ( sq24_new_price ) , .sq24_turnover ( sq24_turnover ) , .sq24_volume ( sq24_volume ) , .sq24_position ( sq24_position ) , .sq24_purchase_price ( sq24_purchase_price ) , .sq24_buy_quantity ( sq24_buy_quantity ) , .sq24_sell_price ( sq24_sell_price ) , .sq24_sell_quantity ( sq24_sell_quantity ) , .sq24_market_rdy ( sq24_market_rdy ) , .sq25_market_explain ( sq25_market_explain ) , .sq25_info_classify ( sq25_info_classify ) , .sq25_dialog_num ( sq25_dialog_num ) , .sq25_contract_flag ( sq25_contract_flag ) , .sq25_contract_num ( sq25_contract_num ) , .sq25_contract_code ( sq25_contract_code ) , .sq25_update_time ( sq25_update_time ) , .sq25_update_ms ( sq25_update_ms ) , .sq25_new_price ( sq25_new_price ) , .sq25_turnover ( sq25_turnover ) , .sq25_volume ( sq25_volume ) , .sq25_position ( sq25_position ) , .sq25_purchase_price ( sq25_purchase_price ) , .sq25_buy_quantity ( sq25_buy_quantity ) , .sq25_sell_price ( sq25_sell_price ) , .sq25_sell_quantity ( sq25_sell_quantity ) , .sq25_market_rdy ( sq25_market_rdy ) , .sq26_market_explain ( sq26_market_explain ) , .sq26_info_classify ( sq26_info_classify ) , .sq26_dialog_num ( sq26_dialog_num ) , .sq26_contract_flag ( sq26_contract_flag ) , .sq26_contract_num ( sq26_contract_num ) , .sq26_contract_code ( sq26_contract_code ) , .sq26_update_time ( sq26_update_time ) , .sq26_update_ms ( sq26_update_ms ) , .sq26_new_price ( sq26_new_price ) , .sq26_turnover ( sq26_turnover ) , .sq26_volume ( sq26_volume ) , .sq26_position ( sq26_position ) , .sq26_purchase_price ( sq26_purchase_price ) , .sq26_buy_quantity ( sq26_buy_quantity ) , .sq26_sell_price ( sq26_sell_price ) , .sq26_sell_quantity ( sq26_sell_quantity ) , .sq26_market_rdy ( sq26_market_rdy ) , .sq27_market_explain ( sq27_market_explain ) , .sq27_info_classify ( sq27_info_classify ) , .sq27_dialog_num ( sq27_dialog_num ) , .sq27_contract_flag ( sq27_contract_flag ) , .sq27_contract_num ( sq27_contract_num ) , .sq27_contract_code ( sq27_contract_code ) , .sq27_update_time ( sq27_update_time ) , .sq27_update_ms ( sq27_update_ms ) , .sq27_new_price ( sq27_new_price ) , .sq27_turnover ( sq27_turnover ) , .sq27_volume ( sq27_volume ) , .sq27_position ( sq27_position ) , .sq27_purchase_price ( sq27_purchase_price ) , .sq27_buy_quantity ( sq27_buy_quantity ) , .sq27_sell_price ( sq27_sell_price ) , .sq27_sell_quantity ( sq27_sell_quantity ) , .sq27_market_rdy ( sq27_market_rdy ) , .sq28_market_explain ( sq28_market_explain ) , .sq28_info_classify ( sq28_info_classify ) , .sq28_dialog_num ( sq28_dialog_num ) , .sq28_contract_flag ( sq28_contract_flag ) , .sq28_contract_num ( sq28_contract_num ) , .sq28_contract_code ( sq28_contract_code ) , .sq28_update_time ( sq28_update_time ) , .sq28_update_ms ( sq28_update_ms ) , .sq28_new_price ( sq28_new_price ) , .sq28_turnover ( sq28_turnover ) , .sq28_volume ( sq28_volume ) , .sq28_position ( sq28_position ) , .sq28_purchase_price ( sq28_purchase_price ) , .sq28_buy_quantity ( sq28_buy_quantity ) , .sq28_sell_price ( sq28_sell_price ) , .sq28_sell_quantity ( sq28_sell_quantity ) , .sq28_market_rdy ( sq28_market_rdy ) , .sq29_market_explain ( sq29_market_explain ) , .sq29_info_classify ( sq29_info_classify ) , .sq29_dialog_num ( sq29_dialog_num ) , .sq29_contract_flag ( sq29_contract_flag ) , .sq29_contract_num ( sq29_contract_num ) , .sq29_contract_code ( sq29_contract_code ) , .sq29_update_time ( sq29_update_time ) , .sq29_update_ms ( sq29_update_ms ) , .sq29_new_price ( sq29_new_price ) , .sq29_turnover ( sq29_turnover ) , .sq29_volume ( sq29_volume ) , .sq29_position ( sq29_position ) , .sq29_purchase_price ( sq29_purchase_price ) , .sq29_buy_quantity ( sq29_buy_quantity ) , .sq29_sell_price ( sq29_sell_price ) , .sq29_sell_quantity ( sq29_sell_quantity ) , .sq29_market_rdy ( sq29_market_rdy ) , .sq30_market_explain ( sq30_market_explain ) , .sq30_info_classify ( sq30_info_classify ) , .sq30_dialog_num ( sq30_dialog_num ) , .sq30_contract_flag ( sq30_contract_flag ) , .sq30_contract_num ( sq30_contract_num ) , .sq30_contract_code ( sq30_contract_code ) , .sq30_update_time ( sq30_update_time ) , .sq30_update_ms ( sq30_update_ms ) , .sq30_new_price ( sq30_new_price ) , .sq30_turnover ( sq30_turnover ) , .sq30_volume ( sq30_volume ) , .sq30_position ( sq30_position ) , .sq30_purchase_price ( sq30_purchase_price ) , .sq30_buy_quantity ( sq30_buy_quantity ) , .sq30_sell_price ( sq30_sell_price ) , .sq30_sell_quantity ( sq30_sell_quantity ) , .sq30_market_rdy ( sq30_market_rdy ) , .sq31_market_explain ( sq31_market_explain ) , .sq31_info_classify ( sq31_info_classify ) , .sq31_dialog_num ( sq31_dialog_num ) , .sq31_contract_flag ( sq31_contract_flag ) , .sq31_contract_num ( sq31_contract_num ) , .sq31_contract_code ( sq31_contract_code ) , .sq31_update_time ( sq31_update_time ) , .sq31_update_ms ( sq31_update_ms ) , .sq31_new_price ( sq31_new_price ) , .sq31_turnover ( sq31_turnover ) , .sq31_volume ( sq31_volume ) , .sq31_position ( sq31_position ) , .sq31_purchase_price ( sq31_purchase_price ) , .sq31_buy_quantity ( sq31_buy_quantity ) , .sq31_sell_price ( sq31_sell_price ) , .sq31_sell_quantity ( sq31_sell_quantity ) , .sq31_market_rdy ( sq31_market_rdy ) , .rmem_data0_0 (rmem_data0_0 ) , .rmem_data0_1 (rmem_data0_1 ) , .rmem_data0_0_vld (rmem_data0_0_vld ) , .rmem_data0_1_vld (rmem_data0_1_vld ) , .rmem_data0_2 (rmem_data0_2 ) , .rmem_data0_3 (rmem_data0_3 ) , .rmem_data0_2_vld (rmem_data0_2_vld ) , .rmem_data0_3_vld (rmem_data0_3_vld ) , .rmem_data0 ( rmem_data0 ) , .rmem_data1 ( rmem_data1 ) , .rmem_data2 ( rmem_data2 ) , .rmem_data3 ( rmem_data3 ) , .rmem_vld ( rmem_vld ) );
 reg tlp_fifo_wr;
 reg [255:0] tlp_fifo_wdata;
 reg [255:0] tlp_fifo_data;
 wire tlp_fifo_rd;
 wire tlp_fifo_full;
 wire [255:0] tlp_fifo_data_out;
 wire [255:0] rmem_data0_0_wire = { rmem_data0_0[ 7: 0], rmem_data0_0[ 15: 8],rmem_data0_0[ 23: 16],rmem_data0_0[ 31: 24], rmem_data0_0[ 39: 32], rmem_data0_0[ 47: 40],rmem_data0_0[ 55: 48],rmem_data0_0[ 63: 56], rmem_data0_0[ 71: 64], rmem_data0_0[ 79: 72],rmem_data0_0[ 87: 80],rmem_data0_0[ 95: 88], rmem_data0_0[103: 96], rmem_data0_0[111:104],rmem_data0_0[119:112],rmem_data0_0[127:120], rmem_data0_0[135:128], rmem_data0_0[143:136],rmem_data0_0[151:144],rmem_data0_0[159:152], rmem_data0_0[167:160], rmem_data0_0[175:168],rmem_data0_0[183:176],rmem_data0_0[191:184], rmem_data0_0[199:192], rmem_data0_0[207:200],rmem_data0_0[215:208],rmem_data0_0[223:216], rmem_data0_0[231:224], rmem_data0_0[239:232],rmem_data0_0[247:240],rmem_data0_0[255:248] };
 wire [255:0] rmem_data0_1_wire = { rmem_data0_1[ 7: 0], rmem_data0_1[ 15: 8],rmem_data0_1[ 23: 16],rmem_data0_1[ 31: 24], rmem_data0_1[ 39: 32], rmem_data0_1[ 47: 40],rmem_data0_1[ 55: 48],rmem_data0_1[ 63: 56], rmem_data0_1[ 71: 64], rmem_data0_1[ 79: 72],rmem_data0_1[ 87: 80],rmem_data0_1[ 95: 88], rmem_data0_1[103: 96], rmem_data0_1[111:104],rmem_data0_1[119:112],rmem_data0_1[127:120], rmem_data0_1[135:128], rmem_data0_1[143:136],rmem_data0_1[151:144],rmem_data0_1[159:152], rmem_data0_1[167:160], rmem_data0_1[175:168],rmem_data0_1[183:176],rmem_data0_1[191:184], rmem_data0_1[199:192], rmem_data0_1[207:200],rmem_data0_1[215:208],rmem_data0_1[223:216], rmem_data0_1[231:224], rmem_data0_1[239:232],rmem_data0_1[247:240],rmem_data0_1[255:248] };
 wire [255:0] rmem_data0_2_wire = { rmem_data0_2[ 7: 0], rmem_data0_2[ 15: 8],rmem_data0_2[ 23: 16],rmem_data0_2[ 31: 24], rmem_data0_2[ 39: 32], rmem_data0_2[ 47: 40],rmem_data0_2[ 55: 48],rmem_data0_2[ 63: 56], rmem_data0_2[ 71: 64], rmem_data0_2[ 79: 72],rmem_data0_2[ 87: 80],rmem_data0_2[ 95: 88], rmem_data0_2[103: 96], rmem_data0_2[111:104],rmem_data0_2[119:112],rmem_data0_2[127:120], rmem_data0_2[135:128], rmem_data0_2[143:136],rmem_data0_2[151:144],rmem_data0_2[159:152], rmem_data0_2[167:160], rmem_data0_2[175:168],rmem_data0_2[183:176],rmem_data0_2[191:184], rmem_data0_2[199:192], rmem_data0_2[207:200],rmem_data0_2[215:208],rmem_data0_2[223:216], rmem_data0_2[231:224], rmem_data0_2[239:232],rmem_data0_2[247:240],rmem_data0_2[255:248] };
 wire [255:0] rmem_data0_3_wire = { rmem_data0_3[ 7: 0], rmem_data0_3[ 15: 8],rmem_data0_3[ 23: 16],rmem_data0_3[ 31: 24], rmem_data0_3[ 39: 32], rmem_data0_3[ 47: 40],rmem_data0_3[ 55: 48],rmem_data0_3[ 63: 56], rmem_data0_3[ 71: 64], rmem_data0_3[ 79: 72],rmem_data0_3[ 87: 80],rmem_data0_3[ 95: 88], rmem_data0_3[103: 96], rmem_data0_3[111:104],rmem_data0_3[119:112],rmem_data0_3[127:120], rmem_data0_3[135:128], rmem_data0_3[143:136],rmem_data0_3[151:144],rmem_data0_3[159:152], rmem_data0_3[167:160], rmem_data0_3[175:168],rmem_data0_3[183:176],rmem_data0_3[191:184], rmem_data0_3[199:192], rmem_data0_3[207:200],rmem_data0_3[215:208],rmem_data0_3[223:216], rmem_data0_3[231:224], rmem_data0_3[239:232],rmem_data0_3[247:240],rmem_data0_3[255:248] };
 wire [255:0] rmem_data1_wire = { rmem_data1[ 7: 0], rmem_data1[ 15: 8],rmem_data1[ 23: 16],rmem_data1[ 31: 24], rmem_data1[ 39: 32], rmem_data1[ 47: 40],rmem_data1[ 55: 48],rmem_data1[ 63: 56], rmem_data1[ 71: 64], rmem_data1[ 79: 72],rmem_data1[ 87: 80],rmem_data1[ 95: 88], rmem_data1[103: 96], rmem_data1[111:104],rmem_data1[119:112],rmem_data1[127:120], rmem_data1[135:128], rmem_data1[143:136],rmem_data1[151:144],rmem_data1[159:152], rmem_data1[167:160], rmem_data1[175:168],rmem_data1[183:176],rmem_data1[191:184], rmem_data1[199:192], rmem_data1[207:200],rmem_data1[215:208],rmem_data1[223:216], rmem_data1[231:224], rmem_data1[239:232],rmem_data1[247:240],rmem_data1[255:248] };
 wire [255:0] rmem_data2_wire = { rmem_data2[ 7: 0], rmem_data2[ 15: 8],rmem_data2[ 23: 16],rmem_data2[ 31: 24], rmem_data2[ 39: 32], rmem_data2[ 47: 40],rmem_data2[ 55: 48],rmem_data2[ 63: 56], rmem_data2[ 71: 64], rmem_data2[ 79: 72],rmem_data2[ 87: 80],rmem_data2[ 95: 88], rmem_data2[103: 96], rmem_data2[111:104],rmem_data2[119:112],rmem_data2[127:120], rmem_data2[135:128], rmem_data2[143:136],rmem_data2[151:144],rmem_data2[159:152], rmem_data2[167:160], rmem_data2[175:168],rmem_data2[183:176],rmem_data2[191:184], rmem_data2[199:192], rmem_data2[207:200],rmem_data2[215:208],rmem_data2[223:216], rmem_data2[231:224], rmem_data2[239:232],rmem_data2[247:240],rmem_data2[255:248] };
 wire [31:0] rmem_data3_wire = { rmem_data3[ 7: 0], rmem_data3[ 15: 8],rmem_data3[ 23: 16],rmem_data3[ 31: 24] };
 reg [1:0] rmem_vld_cnt = 2'b0;
 always@ ( posedge clk) tlp_fifo_wr <= rmem_vld;
 assign tlp_fifo_rd = tlp_fifo_wr ;
 always@ ( posedge clk) if(rmem_vld) rmem_vld_cnt <= rmem_vld_cnt + 1'b1;
 always@ ( posedge clk) if(rmem_vld && (rmem_vld_cnt == 2'b0) ) begin
 if(rmem_data0_0_vld) tlp_fifo_wdata <= rmem_data0_0_wire;
 else if(rmem_data0_1_vld) tlp_fifo_wdata <= rmem_data0_1_wire;
 else if(rmem_data0_2_vld) tlp_fifo_wdata <= rmem_data0_2_wire;
 else if(rmem_data0_3_vld) tlp_fifo_wdata <= rmem_data0_3_wire;
 end
 else if(rmem_vld && (rmem_vld_cnt == 2'b1)) tlp_fifo_wdata <= rmem_data1_wire;
 else if(rmem_vld && (rmem_vld_cnt == 2'd2)) tlp_fifo_wdata <= rmem_data2_wire;
 else if(rmem_vld && (rmem_vld_cnt == 2'd3)) tlp_fifo_wdata <= rmem_data3_wire;
 always@ ( posedge clk) if(!rst_n) tlp_fifo_data_vld <= 1'b0;
 else tlp_fifo_data_vld <= tlp_fifo_rd;
 always@ ( posedge clk) tlp_fifo_rdata <= tlp_fifo_wdata ;
 assign tlp_fifo_empty = 1'd0 ;
 /* */ /* */ endmodule
 module filter_tlp_reg_gen ( clk , rst_n , params_filter_rst , market_explain , info_classify , dialog_num , contract_flag , contract_num , contract_code , update_time , update_ms , new_price , turnover , volume , position , purchase_price , buy_quantity , sell_price , sell_quantity , market_rdy , sq00_market_explain , sq01_market_explain , sq02_market_explain , sq03_market_explain , sq04_market_explain , sq05_market_explain , sq06_market_explain , sq07_market_explain , sq08_market_explain , sq09_market_explain , sq10_market_explain , sq11_market_explain , sq12_market_explain , sq13_market_explain , sq14_market_explain , sq15_market_explain , sq16_market_explain , sq17_market_explain , sq18_market_explain , sq19_market_explain , sq20_market_explain , sq21_market_explain , sq22_market_explain , sq23_market_explain , sq24_market_explain , sq25_market_explain , sq26_market_explain , sq27_market_explain , sq28_market_explain , sq29_market_explain , sq30_market_explain , sq31_market_explain , sq00_info_classify , sq01_info_classify , sq02_info_classify , sq03_info_classify , sq04_info_classify , sq05_info_classify , sq06_info_classify , sq07_info_classify , sq08_info_classify , sq09_info_classify , sq10_info_classify , sq11_info_classify , sq12_info_classify , sq13_info_classify , sq14_info_classify , sq15_info_classify , sq16_info_classify , sq17_info_classify , sq18_info_classify , sq19_info_classify , sq20_info_classify , sq21_info_classify , sq22_info_classify , sq23_info_classify , sq24_info_classify , sq25_info_classify , sq26_info_classify , sq27_info_classify , sq28_info_classify , sq29_info_classify , sq30_info_classify , sq31_info_classify , sq00_dialog_num , sq01_dialog_num , sq02_dialog_num , sq03_dialog_num , sq04_dialog_num , sq05_dialog_num , sq06_dialog_num , sq07_dialog_num , sq08_dialog_num , sq09_dialog_num , sq10_dialog_num , sq11_dialog_num , sq12_dialog_num , sq13_dialog_num , sq14_dialog_num , sq15_dialog_num , sq16_dialog_num , sq17_dialog_num , sq18_dialog_num , sq19_dialog_num , sq20_dialog_num , sq21_dialog_num , sq22_dialog_num , sq23_dialog_num , sq24_dialog_num , sq25_dialog_num , sq26_dialog_num , sq27_dialog_num , sq28_dialog_num , sq29_dialog_num , sq30_dialog_num , sq31_dialog_num , sq00_contract_flag , sq01_contract_flag , sq02_contract_flag , sq03_contract_flag , sq04_contract_flag , sq05_contract_flag , sq06_contract_flag , sq07_contract_flag , sq08_contract_flag , sq09_contract_flag , sq10_contract_flag , sq11_contract_flag , sq12_contract_flag , sq13_contract_flag , sq14_contract_flag , sq15_contract_flag , sq16_contract_flag , sq17_contract_flag , sq18_contract_flag , sq19_contract_flag , sq20_contract_flag , sq21_contract_flag , sq22_contract_flag , sq23_contract_flag , sq24_contract_flag , sq25_contract_flag , sq26_contract_flag , sq27_contract_flag , sq28_contract_flag , sq29_contract_flag , sq30_contract_flag , sq31_contract_flag , sq00_contract_num , sq01_contract_num , sq02_contract_num , sq03_contract_num , sq04_contract_num , sq05_contract_num , sq06_contract_num , sq07_contract_num , sq08_contract_num , sq09_contract_num , sq10_contract_num , sq11_contract_num , sq12_contract_num , sq13_contract_num , sq14_contract_num , sq15_contract_num , sq16_contract_num , sq17_contract_num , sq18_contract_num , sq19_contract_num , sq20_contract_num , sq21_contract_num , sq22_contract_num , sq23_contract_num , sq24_contract_num , sq25_contract_num , sq26_contract_num , sq27_contract_num , sq28_contract_num , sq29_contract_num , sq30_contract_num , sq31_contract_num , sq00_contract_code , sq01_contract_code , sq02_contract_code , sq03_contract_code , sq04_contract_code , sq05_contract_code , sq06_contract_code , sq07_contract_code , sq08_contract_code , sq09_contract_code , sq10_contract_code , sq11_contract_code , sq12_contract_code , sq13_contract_code , sq14_contract_code , sq15_contract_code , sq16_contract_code , sq17_contract_code , sq18_contract_code , sq19_contract_code , sq20_contract_code , sq21_contract_code , sq22_contract_code , sq23_contract_code , sq24_contract_code , sq25_contract_code , sq26_contract_code , sq27_contract_code , sq28_contract_code , sq29_contract_code , sq30_contract_code , sq31_contract_code , sq00_update_time , sq01_update_time , sq02_update_time , sq03_update_time , sq04_update_time , sq05_update_time , sq06_update_time , sq07_update_time , sq08_update_time , sq09_update_time , sq10_update_time , sq11_update_time , sq12_update_time , sq13_update_time , sq14_update_time , sq15_update_time , sq16_update_time , sq17_update_time , sq18_update_time , sq19_update_time , sq20_update_time , sq21_update_time , sq22_update_time , sq23_update_time , sq24_update_time , sq25_update_time , sq26_update_time , sq27_update_time , sq28_update_time , sq29_update_time , sq30_update_time , sq31_update_time , sq00_update_ms , sq01_update_ms , sq02_update_ms , sq03_update_ms , sq04_update_ms , sq05_update_ms , sq06_update_ms , sq07_update_ms , sq08_update_ms , sq09_update_ms , sq10_update_ms , sq11_update_ms , sq12_update_ms , sq13_update_ms , sq14_update_ms , sq15_update_ms , sq16_update_ms , sq17_update_ms , sq18_update_ms , sq19_update_ms , sq20_update_ms , sq21_update_ms , sq22_update_ms , sq23_update_ms , sq24_update_ms , sq25_update_ms , sq26_update_ms , sq27_update_ms , sq28_update_ms , sq29_update_ms , sq30_update_ms , sq31_update_ms , sq00_new_price , sq01_new_price , sq02_new_price , sq03_new_price , sq04_new_price , sq05_new_price , sq06_new_price , sq07_new_price , sq08_new_price , sq09_new_price , sq10_new_price , sq11_new_price , sq12_new_price , sq13_new_price , sq14_new_price , sq15_new_price , sq16_new_price , sq17_new_price , sq18_new_price , sq19_new_price , sq20_new_price , sq21_new_price , sq22_new_price , sq23_new_price , sq24_new_price , sq25_new_price , sq26_new_price , sq27_new_price , sq28_new_price , sq29_new_price , sq30_new_price , sq31_new_price , sq00_turnover , sq01_turnover , sq02_turnover , sq03_turnover , sq04_turnover , sq05_turnover , sq06_turnover , sq07_turnover , sq08_turnover , sq09_turnover , sq10_turnover , sq11_turnover , sq12_turnover , sq13_turnover , sq14_turnover , sq15_turnover , sq16_turnover , sq17_turnover , sq18_turnover , sq19_turnover , sq20_turnover , sq21_turnover , sq22_turnover , sq23_turnover , sq24_turnover , sq25_turnover , sq26_turnover , sq27_turnover , sq28_turnover , sq29_turnover , sq30_turnover , sq31_turnover , sq00_volume , sq01_volume , sq02_volume , sq03_volume , sq04_volume , sq05_volume , sq06_volume , sq07_volume , sq08_volume , sq09_volume , sq10_volume , sq11_volume , sq12_volume , sq13_volume , sq14_volume , sq15_volume , sq16_volume , sq17_volume , sq18_volume , sq19_volume , sq20_volume , sq21_volume , sq22_volume , sq23_volume , sq24_volume , sq25_volume , sq26_volume , sq27_volume , sq28_volume , sq29_volume , sq30_volume , sq31_volume , sq00_position , sq01_position , sq02_position , sq03_position , sq04_position , sq05_position , sq06_position , sq07_position , sq08_position , sq09_position , sq10_position , sq11_position , sq12_position , sq13_position , sq14_position , sq15_position , sq16_position , sq17_position , sq18_position , sq19_position , sq20_position , sq21_position , sq22_position , sq23_position , sq24_position , sq25_position , sq26_position , sq27_position , sq28_position , sq29_position , sq30_position , sq31_position , sq00_purchase_price , sq01_purchase_price , sq02_purchase_price , sq03_purchase_price , sq04_purchase_price , sq05_purchase_price , sq06_purchase_price , sq07_purchase_price , sq08_purchase_price , sq09_purchase_price , sq10_purchase_price , sq11_purchase_price , sq12_purchase_price , sq13_purchase_price , sq14_purchase_price , sq15_purchase_price , sq16_purchase_price , sq17_purchase_price , sq18_purchase_price , sq19_purchase_price , sq20_purchase_price , sq21_purchase_price , sq22_purchase_price , sq23_purchase_price , sq24_purchase_price , sq25_purchase_price , sq26_purchase_price , sq27_purchase_price , sq28_purchase_price , sq29_purchase_price , sq30_purchase_price , sq31_purchase_price , sq00_buy_quantity , sq01_buy_quantity , sq02_buy_quantity , sq03_buy_quantity , sq04_buy_quantity , sq05_buy_quantity , sq06_buy_quantity , sq07_buy_quantity , sq08_buy_quantity , sq09_buy_quantity , sq10_buy_quantity , sq11_buy_quantity , sq12_buy_quantity , sq13_buy_quantity , sq14_buy_quantity , sq15_buy_quantity , sq16_buy_quantity , sq17_buy_quantity , sq18_buy_quantity , sq19_buy_quantity , sq20_buy_quantity , sq21_buy_quantity , sq22_buy_quantity , sq23_buy_quantity , sq24_buy_quantity , sq25_buy_quantity , sq26_buy_quantity , sq27_buy_quantity , sq28_buy_quantity , sq29_buy_quantity , sq30_buy_quantity , sq31_buy_quantity , sq00_sell_price , sq01_sell_price , sq02_sell_price , sq03_sell_price , sq04_sell_price , sq05_sell_price , sq06_sell_price , sq07_sell_price , sq08_sell_price , sq09_sell_price , sq10_sell_price , sq11_sell_price , sq12_sell_price , sq13_sell_price , sq14_sell_price , sq15_sell_price , sq16_sell_price , sq17_sell_price , sq18_sell_price , sq19_sell_price , sq20_sell_price , sq21_sell_price , sq22_sell_price , sq23_sell_price , sq24_sell_price , sq25_sell_price , sq26_sell_price , sq27_sell_price , sq28_sell_price , sq29_sell_price , sq30_sell_price , sq31_sell_price , sq00_sell_quantity , sq01_sell_quantity , sq02_sell_quantity , sq03_sell_quantity , sq04_sell_quantity , sq05_sell_quantity , sq06_sell_quantity , sq07_sell_quantity , sq08_sell_quantity , sq09_sell_quantity , sq10_sell_quantity , sq11_sell_quantity , sq12_sell_quantity , sq13_sell_quantity , sq14_sell_quantity , sq15_sell_quantity , sq16_sell_quantity , sq17_sell_quantity , sq18_sell_quantity , sq19_sell_quantity , sq20_sell_quantity , sq21_sell_quantity , sq22_sell_quantity , sq23_sell_quantity , sq24_sell_quantity , sq25_sell_quantity , sq26_sell_quantity , sq27_sell_quantity , sq28_sell_quantity , sq29_sell_quantity , sq30_sell_quantity , sq31_sell_quantity , sq00_market_rdy , sq01_market_rdy , sq02_market_rdy , sq03_market_rdy , sq04_market_rdy , sq05_market_rdy , sq06_market_rdy , sq07_market_rdy , sq08_market_rdy , sq09_market_rdy , sq10_market_rdy , sq11_market_rdy , sq12_market_rdy , sq13_market_rdy , sq14_market_rdy , sq15_market_rdy , sq16_market_rdy , sq17_market_rdy , sq18_market_rdy , sq19_market_rdy , sq20_market_rdy , sq21_market_rdy , sq22_market_rdy , sq23_market_rdy , sq24_market_rdy , sq25_market_rdy , sq26_market_rdy , sq27_market_rdy , sq28_market_rdy , sq29_market_rdy , sq30_market_rdy , sq31_market_rdy , rmem_data0_0 , rmem_data0_1 , rmem_data0_0_vld , rmem_data0_1_vld , rmem_data0_2 , rmem_data0_3 , rmem_data0_2_vld , rmem_data0_3_vld , rmem_data0 , rmem_data1 , rmem_data2 , rmem_data3 , rmem_vld );
 input clk ;
 input rst_n ;
 input params_filter_rst ;
 input [ 23: 0] market_explain ;
 input [ 7: 0] info_classify ;
 input [ 31: 0] dialog_num ;
 input [ 7: 0] contract_flag ;
 input [ 31: 0] contract_num ;
 input [175: 0] contract_code ;
 input [ 71: 0] update_time ;
 input [ 31: 0] update_ms ;
 input [ 63: 0] new_price ;
 input [ 31: 0] turnover ;
 input [ 63: 0] volume ;
 input [ 63: 0] position ;
 input [ 63: 0] purchase_price ;
 input [ 31: 0] buy_quantity ;
 input [ 63: 0] sell_price ;
 input [ 31: 0] sell_quantity ;
 input market_rdy ;
 input [ 23: 0] sq00_market_explain ;
 input [ 23: 0] sq01_market_explain ;
 input [ 23: 0] sq02_market_explain ;
 input [ 23: 0] sq03_market_explain ;
 input [ 23: 0] sq04_market_explain ;
 input [ 23: 0] sq05_market_explain ;
 input [ 23: 0] sq06_market_explain ;
 input [ 23: 0] sq07_market_explain ;
 input [ 23: 0] sq08_market_explain ;
 input [ 23: 0] sq09_market_explain ;
 input [ 23: 0] sq10_market_explain ;
 input [ 23: 0] sq11_market_explain ;
 input [ 23: 0] sq12_market_explain ;
 input [ 23: 0] sq13_market_explain ;
 input [ 23: 0] sq14_market_explain ;
 input [ 23: 0] sq15_market_explain ;
 input [ 23: 0] sq16_market_explain ;
 input [ 23: 0] sq17_market_explain ;
 input [ 23: 0] sq18_market_explain ;
 input [ 23: 0] sq19_market_explain ;
 input [ 23: 0] sq20_market_explain ;
 input [ 23: 0] sq21_market_explain ;
 input [ 23: 0] sq22_market_explain ;
 input [ 23: 0] sq23_market_explain ;
 input [ 23: 0] sq24_market_explain ;
 input [ 23: 0] sq25_market_explain ;
 input [ 23: 0] sq26_market_explain ;
 input [ 23: 0] sq27_market_explain ;
 input [ 23: 0] sq28_market_explain ;
 input [ 23: 0] sq29_market_explain ;
 input [ 23: 0] sq30_market_explain ;
 input [ 23: 0] sq31_market_explain ;
 input [ 7: 0] sq00_info_classify ;
 input [ 7: 0] sq01_info_classify ;
 input [ 7: 0] sq02_info_classify ;
 input [ 7: 0] sq03_info_classify ;
 input [ 7: 0] sq04_info_classify ;
 input [ 7: 0] sq05_info_classify ;
 input [ 7: 0] sq06_info_classify ;
 input [ 7: 0] sq07_info_classify ;
 input [ 7: 0] sq08_info_classify ;
 input [ 7: 0] sq09_info_classify ;
 input [ 7: 0] sq10_info_classify ;
 input [ 7: 0] sq11_info_classify ;
 input [ 7: 0] sq12_info_classify ;
 input [ 7: 0] sq13_info_classify ;
 input [ 7: 0] sq14_info_classify ;
 input [ 7: 0] sq15_info_classify ;
 input [ 7: 0] sq16_info_classify ;
 input [ 7: 0] sq17_info_classify ;
 input [ 7: 0] sq18_info_classify ;
 input [ 7: 0] sq19_info_classify ;
 input [ 7: 0] sq20_info_classify ;
 input [ 7: 0] sq21_info_classify ;
 input [ 7: 0] sq22_info_classify ;
 input [ 7: 0] sq23_info_classify ;
 input [ 7: 0] sq24_info_classify ;
 input [ 7: 0] sq25_info_classify ;
 input [ 7: 0] sq26_info_classify ;
 input [ 7: 0] sq27_info_classify ;
 input [ 7: 0] sq28_info_classify ;
 input [ 7: 0] sq29_info_classify ;
 input [ 7: 0] sq30_info_classify ;
 input [ 7: 0] sq31_info_classify ;
 input [ 31: 0] sq00_dialog_num ;
 input [ 31: 0] sq01_dialog_num ;
 input [ 31: 0] sq02_dialog_num ;
 input [ 31: 0] sq03_dialog_num ;
 input [ 31: 0] sq04_dialog_num ;
 input [ 31: 0] sq05_dialog_num ;
 input [ 31: 0] sq06_dialog_num ;
 input [ 31: 0] sq07_dialog_num ;
 input [ 31: 0] sq08_dialog_num ;
 input [ 31: 0] sq09_dialog_num ;
 input [ 31: 0] sq10_dialog_num ;
 input [ 31: 0] sq11_dialog_num ;
 input [ 31: 0] sq12_dialog_num ;
 input [ 31: 0] sq13_dialog_num ;
 input [ 31: 0] sq14_dialog_num ;
 input [ 31: 0] sq15_dialog_num ;
 input [ 31: 0] sq16_dialog_num ;
 input [ 31: 0] sq17_dialog_num ;
 input [ 31: 0] sq18_dialog_num ;
 input [ 31: 0] sq19_dialog_num ;
 input [ 31: 0] sq20_dialog_num ;
 input [ 31: 0] sq21_dialog_num ;
 input [ 31: 0] sq22_dialog_num ;
 input [ 31: 0] sq23_dialog_num ;
 input [ 31: 0] sq24_dialog_num ;
 input [ 31: 0] sq25_dialog_num ;
 input [ 31: 0] sq26_dialog_num ;
 input [ 31: 0] sq27_dialog_num ;
 input [ 31: 0] sq28_dialog_num ;
 input [ 31: 0] sq29_dialog_num ;
 input [ 31: 0] sq30_dialog_num ;
 input [ 31: 0] sq31_dialog_num ;
 input [ 7: 0] sq00_contract_flag ;
 input [ 7: 0] sq01_contract_flag ;
 input [ 7: 0] sq02_contract_flag ;
 input [ 7: 0] sq03_contract_flag ;
 input [ 7: 0] sq04_contract_flag ;
 input [ 7: 0] sq05_contract_flag ;
 input [ 7: 0] sq06_contract_flag ;
 input [ 7: 0] sq07_contract_flag ;
 input [ 7: 0] sq08_contract_flag ;
 input [ 7: 0] sq09_contract_flag ;
 input [ 7: 0] sq10_contract_flag ;
 input [ 7: 0] sq11_contract_flag ;
 input [ 7: 0] sq12_contract_flag ;
 input [ 7: 0] sq13_contract_flag ;
 input [ 7: 0] sq14_contract_flag ;
 input [ 7: 0] sq15_contract_flag ;
 input [ 7: 0] sq16_contract_flag ;
 input [ 7: 0] sq17_contract_flag ;
 input [ 7: 0] sq18_contract_flag ;
 input [ 7: 0] sq19_contract_flag ;
 input [ 7: 0] sq20_contract_flag ;
 input [ 7: 0] sq21_contract_flag ;
 input [ 7: 0] sq22_contract_flag ;
 input [ 7: 0] sq23_contract_flag ;
 input [ 7: 0] sq24_contract_flag ;
 input [ 7: 0] sq25_contract_flag ;
 input [ 7: 0] sq26_contract_flag ;
 input [ 7: 0] sq27_contract_flag ;
 input [ 7: 0] sq28_contract_flag ;
 input [ 7: 0] sq29_contract_flag ;
 input [ 7: 0] sq30_contract_flag ;
 input [ 7: 0] sq31_contract_flag ;
 input [ 31: 0] sq00_contract_num ;
 input [ 31: 0] sq01_contract_num ;
 input [ 31: 0] sq02_contract_num ;
 input [ 31: 0] sq03_contract_num ;
 input [ 31: 0] sq04_contract_num ;
 input [ 31: 0] sq05_contract_num ;
 input [ 31: 0] sq06_contract_num ;
 input [ 31: 0] sq07_contract_num ;
 input [ 31: 0] sq08_contract_num ;
 input [ 31: 0] sq09_contract_num ;
 input [ 31: 0] sq10_contract_num ;
 input [ 31: 0] sq11_contract_num ;
 input [ 31: 0] sq12_contract_num ;
 input [ 31: 0] sq13_contract_num ;
 input [ 31: 0] sq14_contract_num ;
 input [ 31: 0] sq15_contract_num ;
 input [ 31: 0] sq16_contract_num ;
 input [ 31: 0] sq17_contract_num ;
 input [ 31: 0] sq18_contract_num ;
 input [ 31: 0] sq19_contract_num ;
 input [ 31: 0] sq20_contract_num ;
 input [ 31: 0] sq21_contract_num ;
 input [ 31: 0] sq22_contract_num ;
 input [ 31: 0] sq23_contract_num ;
 input [ 31: 0] sq24_contract_num ;
 input [ 31: 0] sq25_contract_num ;
 input [ 31: 0] sq26_contract_num ;
 input [ 31: 0] sq27_contract_num ;
 input [ 31: 0] sq28_contract_num ;
 input [ 31: 0] sq29_contract_num ;
 input [ 31: 0] sq30_contract_num ;
 input [ 31: 0] sq31_contract_num ;
 input [175: 0] sq00_contract_code ;
 input [175: 0] sq01_contract_code ;
 input [175: 0] sq02_contract_code ;
 input [175: 0] sq03_contract_code ;
 input [175: 0] sq04_contract_code ;
 input [175: 0] sq05_contract_code ;
 input [175: 0] sq06_contract_code ;
 input [175: 0] sq07_contract_code ;
 input [175: 0] sq08_contract_code ;
 input [175: 0] sq09_contract_code ;
 input [175: 0] sq10_contract_code ;
 input [175: 0] sq11_contract_code ;
 input [175: 0] sq12_contract_code ;
 input [175: 0] sq13_contract_code ;
 input [175: 0] sq14_contract_code ;
 input [175: 0] sq15_contract_code ;
 input [175: 0] sq16_contract_code ;
 input [175: 0] sq17_contract_code ;
 input [175: 0] sq18_contract_code ;
 input [175: 0] sq19_contract_code ;
 input [175: 0] sq20_contract_code ;
 input [175: 0] sq21_contract_code ;
 input [175: 0] sq22_contract_code ;
 input [175: 0] sq23_contract_code ;
 input [175: 0] sq24_contract_code ;
 input [175: 0] sq25_contract_code ;
 input [175: 0] sq26_contract_code ;
 input [175: 0] sq27_contract_code ;
 input [175: 0] sq28_contract_code ;
 input [175: 0] sq29_contract_code ;
 input [175: 0] sq30_contract_code ;
 input [175: 0] sq31_contract_code ;
 input [ 71: 0] sq00_update_time ;
 input [ 71: 0] sq01_update_time ;
 input [ 71: 0] sq02_update_time ;
 input [ 71: 0] sq03_update_time ;
 input [ 71: 0] sq04_update_time ;
 input [ 71: 0] sq05_update_time ;
 input [ 71: 0] sq06_update_time ;
 input [ 71: 0] sq07_update_time ;
 input [ 71: 0] sq08_update_time ;
 input [ 71: 0] sq09_update_time ;
 input [ 71: 0] sq10_update_time ;
 input [ 71: 0] sq11_update_time ;
 input [ 71: 0] sq12_update_time ;
 input [ 71: 0] sq13_update_time ;
 input [ 71: 0] sq14_update_time ;
 input [ 71: 0] sq15_update_time ;
 input [ 71: 0] sq16_update_time ;
 input [ 71: 0] sq17_update_time ;
 input [ 71: 0] sq18_update_time ;
 input [ 71: 0] sq19_update_time ;
 input [ 71: 0] sq20_update_time ;
 input [ 71: 0] sq21_update_time ;
 input [ 71: 0] sq22_update_time ;
 input [ 71: 0] sq23_update_time ;
 input [ 71: 0] sq24_update_time ;
 input [ 71: 0] sq25_update_time ;
 input [ 71: 0] sq26_update_time ;
 input [ 71: 0] sq27_update_time ;
 input [ 71: 0] sq28_update_time ;
 input [ 71: 0] sq29_update_time ;
 input [ 71: 0] sq30_update_time ;
 input [ 71: 0] sq31_update_time ;
 input [ 31: 0] sq00_update_ms ;
 input [ 31: 0] sq01_update_ms ;
 input [ 31: 0] sq02_update_ms ;
 input [ 31: 0] sq03_update_ms ;
 input [ 31: 0] sq04_update_ms ;
 input [ 31: 0] sq05_update_ms ;
 input [ 31: 0] sq06_update_ms ;
 input [ 31: 0] sq07_update_ms ;
 input [ 31: 0] sq08_update_ms ;
 input [ 31: 0] sq09_update_ms ;
 input [ 31: 0] sq10_update_ms ;
 input [ 31: 0] sq11_update_ms ;
 input [ 31: 0] sq12_update_ms ;
 input [ 31: 0] sq13_update_ms ;
 input [ 31: 0] sq14_update_ms ;
 input [ 31: 0] sq15_update_ms ;
 input [ 31: 0] sq16_update_ms ;
 input [ 31: 0] sq17_update_ms ;
 input [ 31: 0] sq18_update_ms ;
 input [ 31: 0] sq19_update_ms ;
 input [ 31: 0] sq20_update_ms ;
 input [ 31: 0] sq21_update_ms ;
 input [ 31: 0] sq22_update_ms ;
 input [ 31: 0] sq23_update_ms ;
 input [ 31: 0] sq24_update_ms ;
 input [ 31: 0] sq25_update_ms ;
 input [ 31: 0] sq26_update_ms ;
 input [ 31: 0] sq27_update_ms ;
 input [ 31: 0] sq28_update_ms ;
 input [ 31: 0] sq29_update_ms ;
 input [ 31: 0] sq30_update_ms ;
 input [ 31: 0] sq31_update_ms ;
 input [ 63: 0] sq00_new_price ;
 input [ 63: 0] sq01_new_price ;
 input [ 63: 0] sq02_new_price ;
 input [ 63: 0] sq03_new_price ;
 input [ 63: 0] sq04_new_price ;
 input [ 63: 0] sq05_new_price ;
 input [ 63: 0] sq06_new_price ;
 input [ 63: 0] sq07_new_price ;
 input [ 63: 0] sq08_new_price ;
 input [ 63: 0] sq09_new_price ;
 input [ 63: 0] sq10_new_price ;
 input [ 63: 0] sq11_new_price ;
 input [ 63: 0] sq12_new_price ;
 input [ 63: 0] sq13_new_price ;
 input [ 63: 0] sq14_new_price ;
 input [ 63: 0] sq15_new_price ;
 input [ 63: 0] sq16_new_price ;
 input [ 63: 0] sq17_new_price ;
 input [ 63: 0] sq18_new_price ;
 input [ 63: 0] sq19_new_price ;
 input [ 63: 0] sq20_new_price ;
 input [ 63: 0] sq21_new_price ;
 input [ 63: 0] sq22_new_price ;
 input [ 63: 0] sq23_new_price ;
 input [ 63: 0] sq24_new_price ;
 input [ 63: 0] sq25_new_price ;
 input [ 63: 0] sq26_new_price ;
 input [ 63: 0] sq27_new_price ;
 input [ 63: 0] sq28_new_price ;
 input [ 63: 0] sq29_new_price ;
 input [ 63: 0] sq30_new_price ;
 input [ 63: 0] sq31_new_price ;
 input [ 31: 0] sq00_turnover ;
 input [ 31: 0] sq01_turnover ;
 input [ 31: 0] sq02_turnover ;
 input [ 31: 0] sq03_turnover ;
 input [ 31: 0] sq04_turnover ;
 input [ 31: 0] sq05_turnover ;
 input [ 31: 0] sq06_turnover ;
 input [ 31: 0] sq07_turnover ;
 input [ 31: 0] sq08_turnover ;
 input [ 31: 0] sq09_turnover ;
 input [ 31: 0] sq10_turnover ;
 input [ 31: 0] sq11_turnover ;
 input [ 31: 0] sq12_turnover ;
 input [ 31: 0] sq13_turnover ;
 input [ 31: 0] sq14_turnover ;
 input [ 31: 0] sq15_turnover ;
 input [ 31: 0] sq16_turnover ;
 input [ 31: 0] sq17_turnover ;
 input [ 31: 0] sq18_turnover ;
 input [ 31: 0] sq19_turnover ;
 input [ 31: 0] sq20_turnover ;
 input [ 31: 0] sq21_turnover ;
 input [ 31: 0] sq22_turnover ;
 input [ 31: 0] sq23_turnover ;
 input [ 31: 0] sq24_turnover ;
 input [ 31: 0] sq25_turnover ;
 input [ 31: 0] sq26_turnover ;
 input [ 31: 0] sq27_turnover ;
 input [ 31: 0] sq28_turnover ;
 input [ 31: 0] sq29_turnover ;
 input [ 31: 0] sq30_turnover ;
 input [ 31: 0] sq31_turnover ;
 input [ 63: 0] sq00_volume ;
 input [ 63: 0] sq01_volume ;
 input [ 63: 0] sq02_volume ;
 input [ 63: 0] sq03_volume ;
 input [ 63: 0] sq04_volume ;
 input [ 63: 0] sq05_volume ;
 input [ 63: 0] sq06_volume ;
 input [ 63: 0] sq07_volume ;
 input [ 63: 0] sq08_volume ;
 input [ 63: 0] sq09_volume ;
 input [ 63: 0] sq10_volume ;
 input [ 63: 0] sq11_volume ;
 input [ 63: 0] sq12_volume ;
 input [ 63: 0] sq13_volume ;
 input [ 63: 0] sq14_volume ;
 input [ 63: 0] sq15_volume ;
 input [ 63: 0] sq16_volume ;
 input [ 63: 0] sq17_volume ;
 input [ 63: 0] sq18_volume ;
 input [ 63: 0] sq19_volume ;
 input [ 63: 0] sq20_volume ;
 input [ 63: 0] sq21_volume ;
 input [ 63: 0] sq22_volume ;
 input [ 63: 0] sq23_volume ;
 input [ 63: 0] sq24_volume ;
 input [ 63: 0] sq25_volume ;
 input [ 63: 0] sq26_volume ;
 input [ 63: 0] sq27_volume ;
 input [ 63: 0] sq28_volume ;
 input [ 63: 0] sq29_volume ;
 input [ 63: 0] sq30_volume ;
 input [ 63: 0] sq31_volume ;
 input [ 63: 0] sq00_position ;
 input [ 63: 0] sq01_position ;
 input [ 63: 0] sq02_position ;
 input [ 63: 0] sq03_position ;
 input [ 63: 0] sq04_position ;
 input [ 63: 0] sq05_position ;
 input [ 63: 0] sq06_position ;
 input [ 63: 0] sq07_position ;
 input [ 63: 0] sq08_position ;
 input [ 63: 0] sq09_position ;
 input [ 63: 0] sq10_position ;
 input [ 63: 0] sq11_position ;
 input [ 63: 0] sq12_position ;
 input [ 63: 0] sq13_position ;
 input [ 63: 0] sq14_position ;
 input [ 63: 0] sq15_position ;
 input [ 63: 0] sq16_position ;
 input [ 63: 0] sq17_position ;
 input [ 63: 0] sq18_position ;
 input [ 63: 0] sq19_position ;
 input [ 63: 0] sq20_position ;
 input [ 63: 0] sq21_position ;
 input [ 63: 0] sq22_position ;
 input [ 63: 0] sq23_position ;
 input [ 63: 0] sq24_position ;
 input [ 63: 0] sq25_position ;
 input [ 63: 0] sq26_position ;
 input [ 63: 0] sq27_position ;
 input [ 63: 0] sq28_position ;
 input [ 63: 0] sq29_position ;
 input [ 63: 0] sq30_position ;
 input [ 63: 0] sq31_position ;
 input [ 63: 0] sq00_purchase_price ;
 input [ 63: 0] sq01_purchase_price ;
 input [ 63: 0] sq02_purchase_price ;
 input [ 63: 0] sq03_purchase_price ;
 input [ 63: 0] sq04_purchase_price ;
 input [ 63: 0] sq05_purchase_price ;
 input [ 63: 0] sq06_purchase_price ;
 input [ 63: 0] sq07_purchase_price ;
 input [ 63: 0] sq08_purchase_price ;
 input [ 63: 0] sq09_purchase_price ;
 input [ 63: 0] sq10_purchase_price ;
 input [ 63: 0] sq11_purchase_price ;
 input [ 63: 0] sq12_purchase_price ;
 input [ 63: 0] sq13_purchase_price ;
 input [ 63: 0] sq14_purchase_price ;
 input [ 63: 0] sq15_purchase_price ;
 input [ 63: 0] sq16_purchase_price ;
 input [ 63: 0] sq17_purchase_price ;
 input [ 63: 0] sq18_purchase_price ;
 input [ 63: 0] sq19_purchase_price ;
 input [ 63: 0] sq20_purchase_price ;
 input [ 63: 0] sq21_purchase_price ;
 input [ 63: 0] sq22_purchase_price ;
 input [ 63: 0] sq23_purchase_price ;
 input [ 63: 0] sq24_purchase_price ;
 input [ 63: 0] sq25_purchase_price ;
 input [ 63: 0] sq26_purchase_price ;
 input [ 63: 0] sq27_purchase_price ;
 input [ 63: 0] sq28_purchase_price ;
 input [ 63: 0] sq29_purchase_price ;
 input [ 63: 0] sq30_purchase_price ;
 input [ 63: 0] sq31_purchase_price ;
 input [ 31: 0] sq00_buy_quantity ;
 input [ 31: 0] sq01_buy_quantity ;
 input [ 31: 0] sq02_buy_quantity ;
 input [ 31: 0] sq03_buy_quantity ;
 input [ 31: 0] sq04_buy_quantity ;
 input [ 31: 0] sq05_buy_quantity ;
 input [ 31: 0] sq06_buy_quantity ;
 input [ 31: 0] sq07_buy_quantity ;
 input [ 31: 0] sq08_buy_quantity ;
 input [ 31: 0] sq09_buy_quantity ;
 input [ 31: 0] sq10_buy_quantity ;
 input [ 31: 0] sq11_buy_quantity ;
 input [ 31: 0] sq12_buy_quantity ;
 input [ 31: 0] sq13_buy_quantity ;
 input [ 31: 0] sq14_buy_quantity ;
 input [ 31: 0] sq15_buy_quantity ;
 input [ 31: 0] sq16_buy_quantity ;
 input [ 31: 0] sq17_buy_quantity ;
 input [ 31: 0] sq18_buy_quantity ;
 input [ 31: 0] sq19_buy_quantity ;
 input [ 31: 0] sq20_buy_quantity ;
 input [ 31: 0] sq21_buy_quantity ;
 input [ 31: 0] sq22_buy_quantity ;
 input [ 31: 0] sq23_buy_quantity ;
 input [ 31: 0] sq24_buy_quantity ;
 input [ 31: 0] sq25_buy_quantity ;
 input [ 31: 0] sq26_buy_quantity ;
 input [ 31: 0] sq27_buy_quantity ;
 input [ 31: 0] sq28_buy_quantity ;
 input [ 31: 0] sq29_buy_quantity ;
 input [ 31: 0] sq30_buy_quantity ;
 input [ 31: 0] sq31_buy_quantity ;
 input [ 63: 0] sq00_sell_price ;
 input [ 63: 0] sq01_sell_price ;
 input [ 63: 0] sq02_sell_price ;
 input [ 63: 0] sq03_sell_price ;
 input [ 63: 0] sq04_sell_price ;
 input [ 63: 0] sq05_sell_price ;
 input [ 63: 0] sq06_sell_price ;
 input [ 63: 0] sq07_sell_price ;
 input [ 63: 0] sq08_sell_price ;
 input [ 63: 0] sq09_sell_price ;
 input [ 63: 0] sq10_sell_price ;
 input [ 63: 0] sq11_sell_price ;
 input [ 63: 0] sq12_sell_price ;
 input [ 63: 0] sq13_sell_price ;
 input [ 63: 0] sq14_sell_price ;
 input [ 63: 0] sq15_sell_price ;
 input [ 63: 0] sq16_sell_price ;
 input [ 63: 0] sq17_sell_price ;
 input [ 63: 0] sq18_sell_price ;
 input [ 63: 0] sq19_sell_price ;
 input [ 63: 0] sq20_sell_price ;
 input [ 63: 0] sq21_sell_price ;
 input [ 63: 0] sq22_sell_price ;
 input [ 63: 0] sq23_sell_price ;
 input [ 63: 0] sq24_sell_price ;
 input [ 63: 0] sq25_sell_price ;
 input [ 63: 0] sq26_sell_price ;
 input [ 63: 0] sq27_sell_price ;
 input [ 63: 0] sq28_sell_price ;
 input [ 63: 0] sq29_sell_price ;
 input [ 63: 0] sq30_sell_price ;
 input [ 63: 0] sq31_sell_price ;
 input [ 31: 0] sq00_sell_quantity ;
 input [ 31: 0] sq01_sell_quantity ;
 input [ 31: 0] sq02_sell_quantity ;
 input [ 31: 0] sq03_sell_quantity ;
 input [ 31: 0] sq04_sell_quantity ;
 input [ 31: 0] sq05_sell_quantity ;
 input [ 31: 0] sq06_sell_quantity ;
 input [ 31: 0] sq07_sell_quantity ;
 input [ 31: 0] sq08_sell_quantity ;
 input [ 31: 0] sq09_sell_quantity ;
 input [ 31: 0] sq10_sell_quantity ;
 input [ 31: 0] sq11_sell_quantity ;
 input [ 31: 0] sq12_sell_quantity ;
 input [ 31: 0] sq13_sell_quantity ;
 input [ 31: 0] sq14_sell_quantity ;
 input [ 31: 0] sq15_sell_quantity ;
 input [ 31: 0] sq16_sell_quantity ;
 input [ 31: 0] sq17_sell_quantity ;
 input [ 31: 0] sq18_sell_quantity ;
 input [ 31: 0] sq19_sell_quantity ;
 input [ 31: 0] sq20_sell_quantity ;
 input [ 31: 0] sq21_sell_quantity ;
 input [ 31: 0] sq22_sell_quantity ;
 input [ 31: 0] sq23_sell_quantity ;
 input [ 31: 0] sq24_sell_quantity ;
 input [ 31: 0] sq25_sell_quantity ;
 input [ 31: 0] sq26_sell_quantity ;
 input [ 31: 0] sq27_sell_quantity ;
 input [ 31: 0] sq28_sell_quantity ;
 input [ 31: 0] sq29_sell_quantity ;
 input [ 31: 0] sq30_sell_quantity ;
 input [ 31: 0] sq31_sell_quantity ;
 input sq00_market_rdy ;
 input sq01_market_rdy ;
 input sq02_market_rdy ;
 input sq03_market_rdy ;
 input sq04_market_rdy ;
 input sq05_market_rdy ;
 input sq06_market_rdy ;
 input sq07_market_rdy ;
 input sq08_market_rdy ;
 input sq09_market_rdy ;
 input sq10_market_rdy ;
 input sq11_market_rdy ;
 input sq12_market_rdy ;
 input sq13_market_rdy ;
 input sq14_market_rdy ;
 input sq15_market_rdy ;
 input sq16_market_rdy ;
 input sq17_market_rdy ;
 input sq18_market_rdy ;
 input sq19_market_rdy ;
 input sq20_market_rdy ;
 input sq21_market_rdy ;
 input sq22_market_rdy ;
 input sq23_market_rdy ;
 input sq24_market_rdy ;
 input sq25_market_rdy ;
 input sq26_market_rdy ;
 input sq27_market_rdy ;
 input sq28_market_rdy ;
 input sq29_market_rdy ;
 input sq30_market_rdy ;
 input sq31_market_rdy ;
 output [255:0] rmem_data0 ;
 output [255:0] rmem_data1 ;
 output [255:0] rmem_data2 ;
 output [ 31:0] rmem_data3 ;
 output rmem_vld ;
 output [255:0] rmem_data0_0 ;
 output [255:0] rmem_data0_1 ;
 output rmem_data0_0_vld ;
 output rmem_data0_1_vld ;
 output [255:0] rmem_data0_2 ;
 output [255:0] rmem_data0_3 ;
 output rmem_data0_2_vld ;
 output rmem_data0_3_vld ;
 reg [ 1:0] rmem_cnt ;
 reg [255:0] rmem_data0 ;
 reg [255:0] rmem_data1 ;
 reg [255:0] rmem_data2 ;
 reg [ 31:0] rmem_data3 ;
 reg rmem_vld ;
 reg [255:0] rmem_data0_0 ;
 reg [255:0] rmem_data1_0 ;
 reg [255:0] rmem_data2_0 ;
 reg [255:0] rmem_data0_1 ;
 reg [255:0] rmem_data1_1 ;
 reg [255:0] rmem_data2_1 ;
 reg [255:0] rmem_data0_2 ;
 reg [255:0] rmem_data1_2 ;
 reg [255:0] rmem_data2_2 ;
 reg [255:0] rmem_data0_3 ;
 reg [255:0] rmem_data1_3 ;
 reg [255:0] rmem_data2_3 ;
 reg rmem_data0_0_vld ;
 reg rmem_data1_0_vld ;
 reg rmem_data2_0_vld ;
 reg rmem_data0_1_vld ;
 reg rmem_data1_1_vld ;
 reg rmem_data2_1_vld ;
 reg rmem_data0_2_vld ;
 reg rmem_data1_2_vld ;
 reg rmem_data2_2_vld ;
 reg rmem_data0_3_vld ;
 reg rmem_data1_3_vld ;
 reg rmem_data2_3_vld ;
 reg [ 31: 0] contract_num_cnt ;
 wire [ 31: 0] contract_num_wire ;
 wire [ 31: 0] sq_market_rdy ;
 assign sq_market_rdy = { sq31_market_rdy, sq30_market_rdy, sq29_market_rdy, sq28_market_rdy, sq27_market_rdy, sq26_market_rdy, sq25_market_rdy, sq24_market_rdy, sq23_market_rdy, sq22_market_rdy, sq21_market_rdy, sq20_market_rdy, sq19_market_rdy, sq18_market_rdy, sq17_market_rdy, sq16_market_rdy, sq15_market_rdy, sq14_market_rdy, sq13_market_rdy, sq12_market_rdy, sq11_market_rdy, sq10_market_rdy, sq09_market_rdy, sq08_market_rdy, sq07_market_rdy, sq06_market_rdy, sq05_market_rdy, sq04_market_rdy, sq03_market_rdy, sq02_market_rdy, sq01_market_rdy, sq00_market_rdy };
 reg market_rdy_dly ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 market_rdy_dly <= 1'd0 ;
 end
 else if ( market_rdy|| (|sq_market_rdy) ) begin
 market_rdy_dly <= 1'd1 ;
 end
 else begin
 market_rdy_dly <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 contract_num_cnt <= 32'd1 ;
 end
 else if (params_filter_rst) begin
 contract_num_cnt <= 32'd1 ;
 end
 else if ( market_rdy_dly ) begin
 contract_num_cnt <= (contract_num_cnt==32'hffff_ffff) ? 32'd1 : contract_num_cnt + 32'd1 ;
 end
 end
 assign contract_num_wire = { contract_num_cnt[7:0],contract_num_cnt[15:8],contract_num_cnt[23:16],contract_num_cnt[31:24] };
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data0_0 <= 256'd0 ;
 rmem_data0_0_vld <= 1'd0 ;
 end
 else begin
 rmem_data0_0_vld <= |sq_market_rdy[ 7:0] ;
 case (sq_market_rdy[7:0]) 8'h01: rmem_data0_0 <= {sq00_market_explain[23:0] ,sq00_info_classify[7:0] ,sq00_dialog_num[31:0] ,sq00_contract_flag[7:0] ,contract_num_wire[31:0] ,sq00_contract_code[22*8-1:3*8]} ;
 8'h02: rmem_data0_0 <= {sq01_market_explain[23:0] ,sq01_info_classify[7:0] ,sq01_dialog_num[31:0] ,sq01_contract_flag[7:0] ,contract_num_wire[31:0] ,sq01_contract_code[22*8-1:3*8]} ;
 8'h04: rmem_data0_0 <= {sq02_market_explain[23:0] ,sq02_info_classify[7:0] ,sq02_dialog_num[31:0] ,sq02_contract_flag[7:0] ,contract_num_wire[31:0] ,sq02_contract_code[22*8-1:3*8]} ;
 8'h08: rmem_data0_0 <= {sq03_market_explain[23:0] ,sq03_info_classify[7:0] ,sq03_dialog_num[31:0] ,sq03_contract_flag[7:0] ,contract_num_wire[31:0] ,sq03_contract_code[22*8-1:3*8]} ;
 8'h10: rmem_data0_0 <= {sq04_market_explain[23:0] ,sq04_info_classify[7:0] ,sq04_dialog_num[31:0] ,sq04_contract_flag[7:0] ,contract_num_wire[31:0] ,sq04_contract_code[22*8-1:3*8]} ;
 8'h20: rmem_data0_0 <= {sq05_market_explain[23:0] ,sq05_info_classify[7:0] ,sq05_dialog_num[31:0] ,sq05_contract_flag[7:0] ,contract_num_wire[31:0] ,sq05_contract_code[22*8-1:3*8]} ;
 8'h40: rmem_data0_0 <= {sq06_market_explain[23:0] ,sq06_info_classify[7:0] ,sq06_dialog_num[31:0] ,sq06_contract_flag[7:0] ,contract_num_wire[31:0] ,sq06_contract_code[22*8-1:3*8]} ;
 8'h80: rmem_data0_0 <= {sq07_market_explain[23:0] ,sq07_info_classify[7:0] ,sq07_dialog_num[31:0] ,sq07_contract_flag[7:0] ,contract_num_wire[31:0] ,sq07_contract_code[22*8-1:3*8]} ;
 default: rmem_data0_0 <= rmem_data0_0 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data0_2 <= 256'd0 ;
 rmem_data0_2_vld <= 1'd0 ;
 end
 else begin
 rmem_data0_2_vld <= |sq_market_rdy[15:8] ;
 case (sq_market_rdy[15:8]) 8'h01: rmem_data0_2 <= {sq08_market_explain[23:0] ,sq08_info_classify[7:0] ,sq08_dialog_num[31:0] ,sq08_contract_flag[7:0] ,contract_num_wire[31:0] ,sq08_contract_code[22*8-1:3*8]} ;
 8'h02: rmem_data0_2 <= {sq09_market_explain[23:0] ,sq09_info_classify[7:0] ,sq09_dialog_num[31:0] ,sq09_contract_flag[7:0] ,contract_num_wire[31:0] ,sq09_contract_code[22*8-1:3*8]} ;
 8'h04: rmem_data0_2 <= {sq10_market_explain[23:0] ,sq10_info_classify[7:0] ,sq10_dialog_num[31:0] ,sq10_contract_flag[7:0] ,contract_num_wire[31:0] ,sq10_contract_code[22*8-1:3*8]} ;
 8'h08: rmem_data0_2 <= {sq11_market_explain[23:0] ,sq11_info_classify[7:0] ,sq11_dialog_num[31:0] ,sq11_contract_flag[7:0] ,contract_num_wire[31:0] ,sq11_contract_code[22*8-1:3*8]} ;
 8'h10: rmem_data0_2 <= {sq12_market_explain[23:0] ,sq12_info_classify[7:0] ,sq12_dialog_num[31:0] ,sq12_contract_flag[7:0] ,contract_num_wire[31:0] ,sq12_contract_code[22*8-1:3*8]} ;
 8'h20: rmem_data0_2 <= {sq13_market_explain[23:0] ,sq13_info_classify[7:0] ,sq13_dialog_num[31:0] ,sq13_contract_flag[7:0] ,contract_num_wire[31:0] ,sq13_contract_code[22*8-1:3*8]} ;
 8'h40: rmem_data0_2 <= {sq14_market_explain[23:0] ,sq14_info_classify[7:0] ,sq14_dialog_num[31:0] ,sq14_contract_flag[7:0] ,contract_num_wire[31:0] ,sq14_contract_code[22*8-1:3*8]} ;
 8'h80: rmem_data0_2 <= {sq15_market_explain[23:0] ,sq15_info_classify[7:0] ,sq15_dialog_num[31:0] ,sq15_contract_flag[7:0] ,contract_num_wire[31:0] ,sq15_contract_code[22*8-1:3*8]} ;
 default: rmem_data0_2 <= rmem_data0_2 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data0_1 <= 256'd0 ;
 rmem_data0_1_vld <= 1'd0 ;
 end
 else begin
 rmem_data0_1_vld <= |{market_rdy,sq_market_rdy[31:24]} ;
 case ({market_rdy,sq_market_rdy[31:24]}) 9'h0_01: rmem_data0_1 <= {sq24_market_explain[23:0] ,sq24_info_classify[7:0] ,sq24_dialog_num[31:0] ,sq24_contract_flag[7:0] ,contract_num_wire[31:0] ,sq24_contract_code[22*8-1:3*8]} ;
 9'h0_02: rmem_data0_1 <= {sq25_market_explain[23:0] ,sq25_info_classify[7:0] ,sq25_dialog_num[31:0] ,sq25_contract_flag[7:0] ,contract_num_wire[31:0] ,sq25_contract_code[22*8-1:3*8]} ;
 9'h0_04: rmem_data0_1 <= {sq26_market_explain[23:0] ,sq26_info_classify[7:0] ,sq26_dialog_num[31:0] ,sq26_contract_flag[7:0] ,contract_num_wire[31:0] ,sq26_contract_code[22*8-1:3*8]} ;
 9'h0_08: rmem_data0_1 <= {sq27_market_explain[23:0] ,sq27_info_classify[7:0] ,sq27_dialog_num[31:0] ,sq27_contract_flag[7:0] ,contract_num_wire[31:0] ,sq27_contract_code[22*8-1:3*8]} ;
 9'h0_10: rmem_data0_1 <= {sq28_market_explain[23:0] ,sq28_info_classify[7:0] ,sq28_dialog_num[31:0] ,sq28_contract_flag[7:0] ,contract_num_wire[31:0] ,sq28_contract_code[22*8-1:3*8]} ;
 9'h0_20: rmem_data0_1 <= {sq29_market_explain[23:0] ,sq29_info_classify[7:0] ,sq29_dialog_num[31:0] ,sq29_contract_flag[7:0] ,contract_num_wire[31:0] ,sq29_contract_code[22*8-1:3*8]} ;
 9'h0_40: rmem_data0_1 <= {sq30_market_explain[23:0] ,sq30_info_classify[7:0] ,sq30_dialog_num[31:0] ,sq30_contract_flag[7:0] ,contract_num_wire[31:0] ,sq30_contract_code[22*8-1:3*8]} ;
 9'h0_80: rmem_data0_1 <= {sq31_market_explain[23:0] ,sq31_info_classify[7:0] ,sq31_dialog_num[31:0] ,sq31_contract_flag[7:0] ,contract_num_wire[31:0] ,sq31_contract_code[22*8-1:3*8]} ;
 9'h1_00 : rmem_data0_1 <= {market_explain[23:0] ,info_classify[7:0] ,dialog_num[31:0] ,contract_flag[7:0] ,contract_num_wire[31:0] ,contract_code[22*8-1:3*8]} ;
 default : rmem_data0_1 <= rmem_data0_1 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data0_3 <= 256'd0 ;
 rmem_data0_3_vld <= 1'd0 ;
 end
 else begin
 rmem_data0_3_vld <= |sq_market_rdy[23:16] ;
 case (sq_market_rdy[23:16]) 8'h01: rmem_data0_3 <= {sq16_market_explain[23:0] ,sq16_info_classify[7:0] ,sq16_dialog_num[31:0] ,sq16_contract_flag[7:0] ,contract_num_wire[31:0] ,sq16_contract_code[22*8-1:3*8]} ;
 8'h02: rmem_data0_3 <= {sq17_market_explain[23:0] ,sq17_info_classify[7:0] ,sq17_dialog_num[31:0] ,sq17_contract_flag[7:0] ,contract_num_wire[31:0] ,sq17_contract_code[22*8-1:3*8]} ;
 8'h04: rmem_data0_3 <= {sq18_market_explain[23:0] ,sq18_info_classify[7:0] ,sq18_dialog_num[31:0] ,sq18_contract_flag[7:0] ,contract_num_wire[31:0] ,sq18_contract_code[22*8-1:3*8]} ;
 8'h08: rmem_data0_3 <= {sq19_market_explain[23:0] ,sq19_info_classify[7:0] ,sq19_dialog_num[31:0] ,sq19_contract_flag[7:0] ,contract_num_wire[31:0] ,sq19_contract_code[22*8-1:3*8]} ;
 8'h10: rmem_data0_3 <= {sq20_market_explain[23:0] ,sq20_info_classify[7:0] ,sq20_dialog_num[31:0] ,sq20_contract_flag[7:0] ,contract_num_wire[31:0] ,sq20_contract_code[22*8-1:3*8]} ;
 8'h20: rmem_data0_3 <= {sq21_market_explain[23:0] ,sq21_info_classify[7:0] ,sq21_dialog_num[31:0] ,sq21_contract_flag[7:0] ,contract_num_wire[31:0] ,sq21_contract_code[22*8-1:3*8]} ;
 8'h40: rmem_data0_3 <= {sq22_market_explain[23:0] ,sq22_info_classify[7:0] ,sq22_dialog_num[31:0] ,sq22_contract_flag[7:0] ,contract_num_wire[31:0] ,sq22_contract_code[22*8-1:3*8]} ;
 8'h80: rmem_data0_3 <= {sq23_market_explain[23:0] ,sq23_info_classify[7:0] ,sq23_dialog_num[31:0] ,sq23_contract_flag[7:0] ,contract_num_wire[31:0] ,sq23_contract_code[22*8-1:3*8]} ;
 default: rmem_data0_3 <= rmem_data0_3 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data0 <= 256'd0 ;
 end
 else if ( rmem_data0_0_vld ) begin
 rmem_data0 <= rmem_data0_0 ;
 end
 else if ( rmem_data0_1_vld ) begin
 rmem_data0 <= rmem_data0_1 ;
 end
 else if ( rmem_data0_2_vld ) begin
 rmem_data0 <= rmem_data0_2 ;
 end
 else if ( rmem_data0_3_vld ) begin
 rmem_data0 <= rmem_data0_3 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data1_0 <= 256'd0 ;
 rmem_data1_0_vld <= 1'd0 ;
 end
 else begin
 rmem_data1_0_vld <= |sq_market_rdy[7:0] ;
 case (sq_market_rdy[7:0]) 8'h01: rmem_data1_0 <= {sq00_contract_code[3*8-1:0] ,sq00_update_time[71:0] ,sq00_update_ms[31:0] ,sq00_new_price[63:0] ,sq00_turnover[31:0] ,sq00_volume[8*8-1:4*8] } ;
 8'h02: rmem_data1_0 <= {sq01_contract_code[3*8-1:0] ,sq01_update_time[71:0] ,sq01_update_ms[31:0] ,sq01_new_price[63:0] ,sq01_turnover[31:0] ,sq01_volume[8*8-1:4*8] } ;
 8'h04: rmem_data1_0 <= {sq02_contract_code[3*8-1:0] ,sq02_update_time[71:0] ,sq02_update_ms[31:0] ,sq02_new_price[63:0] ,sq02_turnover[31:0] ,sq02_volume[8*8-1:4*8] } ;
 8'h08: rmem_data1_0 <= {sq03_contract_code[3*8-1:0] ,sq03_update_time[71:0] ,sq03_update_ms[31:0] ,sq03_new_price[63:0] ,sq03_turnover[31:0] ,sq03_volume[8*8-1:4*8] } ;
 8'h10: rmem_data1_0 <= {sq04_contract_code[3*8-1:0] ,sq04_update_time[71:0] ,sq04_update_ms[31:0] ,sq04_new_price[63:0] ,sq04_turnover[31:0] ,sq04_volume[8*8-1:4*8] } ;
 8'h20: rmem_data1_0 <= {sq05_contract_code[3*8-1:0] ,sq05_update_time[71:0] ,sq05_update_ms[31:0] ,sq05_new_price[63:0] ,sq05_turnover[31:0] ,sq05_volume[8*8-1:4*8] } ;
 8'h40: rmem_data1_0 <= {sq06_contract_code[3*8-1:0] ,sq06_update_time[71:0] ,sq06_update_ms[31:0] ,sq06_new_price[63:0] ,sq06_turnover[31:0] ,sq06_volume[8*8-1:4*8] } ;
 8'h80 : rmem_data1_0 <= {sq07_contract_code[3*8-1:0] ,sq07_update_time[71:0] ,sq07_update_ms[31:0] ,sq07_new_price[63:0] ,sq07_turnover[31:0] ,sq07_volume[8*8-1:4*8] } ;
 default : rmem_data1_0 <= rmem_data1_0 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data1_2 <= 256'd0 ;
 rmem_data1_2_vld <= 1'd0 ;
 end
 else begin
 rmem_data1_2_vld <= |sq_market_rdy[15:8] ;
 case (sq_market_rdy[15:8]) 8'h01: rmem_data1_2 <= {sq08_contract_code[3*8-1:0] ,sq08_update_time[71:0] ,sq08_update_ms[31:0] ,sq08_new_price[63:0] ,sq08_turnover[31:0] ,sq08_volume[8*8-1:4*8] } ;
 8'h02: rmem_data1_2 <= {sq09_contract_code[3*8-1:0] ,sq09_update_time[71:0] ,sq09_update_ms[31:0] ,sq09_new_price[63:0] ,sq09_turnover[31:0] ,sq09_volume[8*8-1:4*8] } ;
 8'h04: rmem_data1_2 <= {sq10_contract_code[3*8-1:0] ,sq10_update_time[71:0] ,sq10_update_ms[31:0] ,sq10_new_price[63:0] ,sq10_turnover[31:0] ,sq10_volume[8*8-1:4*8] } ;
 8'h08: rmem_data1_2 <= {sq11_contract_code[3*8-1:0] ,sq11_update_time[71:0] ,sq11_update_ms[31:0] ,sq11_new_price[63:0] ,sq11_turnover[31:0] ,sq11_volume[8*8-1:4*8] } ;
 8'h10: rmem_data1_2 <= {sq12_contract_code[3*8-1:0] ,sq12_update_time[71:0] ,sq12_update_ms[31:0] ,sq12_new_price[63:0] ,sq12_turnover[31:0] ,sq12_volume[8*8-1:4*8] } ;
 8'h20: rmem_data1_2 <= {sq13_contract_code[3*8-1:0] ,sq13_update_time[71:0] ,sq13_update_ms[31:0] ,sq13_new_price[63:0] ,sq13_turnover[31:0] ,sq13_volume[8*8-1:4*8] } ;
 8'h40: rmem_data1_2 <= {sq14_contract_code[3*8-1:0] ,sq14_update_time[71:0] ,sq14_update_ms[31:0] ,sq14_new_price[63:0] ,sq14_turnover[31:0] ,sq14_volume[8*8-1:4*8] } ;
 8'h80 : rmem_data1_2 <= {sq15_contract_code[3*8-1:0] ,sq15_update_time[71:0] ,sq15_update_ms[31:0] ,sq15_new_price[63:0] ,sq15_turnover[31:0] ,sq15_volume[8*8-1:4*8] } ;
 default : rmem_data1_2 <= rmem_data1_2 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data1_1 <= 256'd0 ;
 rmem_data1_1_vld <= 1'd0 ;
 end
 else begin
 rmem_data1_1_vld <= |sq_market_rdy[23:16] ;
 case (sq_market_rdy[23:16]) 8'h01: rmem_data1_1 <= {sq16_contract_code[3*8-1:0] ,sq16_update_time[71:0] ,sq16_update_ms[31:0] ,sq16_new_price[63:0] ,sq16_turnover[31:0] ,sq16_volume[8*8-1:4*8] } ;
 8'h02: rmem_data1_1 <= {sq17_contract_code[3*8-1:0] ,sq17_update_time[71:0] ,sq17_update_ms[31:0] ,sq17_new_price[63:0] ,sq17_turnover[31:0] ,sq17_volume[8*8-1:4*8] } ;
 8'h04: rmem_data1_1 <= {sq18_contract_code[3*8-1:0] ,sq18_update_time[71:0] ,sq18_update_ms[31:0] ,sq18_new_price[63:0] ,sq18_turnover[31:0] ,sq18_volume[8*8-1:4*8] } ;
 8'h08: rmem_data1_1 <= {sq19_contract_code[3*8-1:0] ,sq19_update_time[71:0] ,sq19_update_ms[31:0] ,sq19_new_price[63:0] ,sq19_turnover[31:0] ,sq19_volume[8*8-1:4*8] } ;
 8'h10: rmem_data1_1 <= {sq20_contract_code[3*8-1:0] ,sq20_update_time[71:0] ,sq20_update_ms[31:0] ,sq20_new_price[63:0] ,sq20_turnover[31:0] ,sq20_volume[8*8-1:4*8] } ;
 8'h20: rmem_data1_1 <= {sq21_contract_code[3*8-1:0] ,sq21_update_time[71:0] ,sq21_update_ms[31:0] ,sq21_new_price[63:0] ,sq21_turnover[31:0] ,sq21_volume[8*8-1:4*8] } ;
 8'h40: rmem_data1_1 <= {sq22_contract_code[3*8-1:0] ,sq22_update_time[71:0] ,sq22_update_ms[31:0] ,sq22_new_price[63:0] ,sq22_turnover[31:0] ,sq22_volume[8*8-1:4*8] } ;
 8'h80: rmem_data1_1 <= {sq23_contract_code[3*8-1:0] ,sq23_update_time[71:0] ,sq23_update_ms[31:0] ,sq23_new_price[63:0] ,sq23_turnover[31:0] ,sq23_volume[8*8-1:4*8] } ;
 default : rmem_data1_1 <= rmem_data1_1 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data1_3 <= 256'd0 ;
 rmem_data1_3_vld <= 1'd0 ;
 end
 else begin
 rmem_data1_3_vld <= |{market_rdy,sq_market_rdy[31:24]} ;
 case ({market_rdy,sq_market_rdy[31:24]}) 9'h0_01: rmem_data1_3 <= {sq24_contract_code[3*8-1:0] ,sq24_update_time[71:0] ,sq24_update_ms[31:0] ,sq24_new_price[63:0] ,sq24_turnover[31:0] ,sq24_volume[8*8-1:4*8] } ;
 9'h0_02: rmem_data1_3 <= {sq25_contract_code[3*8-1:0] ,sq25_update_time[71:0] ,sq25_update_ms[31:0] ,sq25_new_price[63:0] ,sq25_turnover[31:0] ,sq25_volume[8*8-1:4*8] } ;
 9'h0_04: rmem_data1_3 <= {sq26_contract_code[3*8-1:0] ,sq26_update_time[71:0] ,sq26_update_ms[31:0] ,sq26_new_price[63:0] ,sq26_turnover[31:0] ,sq26_volume[8*8-1:4*8] } ;
 9'h0_08: rmem_data1_3 <= {sq27_contract_code[3*8-1:0] ,sq27_update_time[71:0] ,sq27_update_ms[31:0] ,sq27_new_price[63:0] ,sq27_turnover[31:0] ,sq27_volume[8*8-1:4*8] } ;
 9'h0_10: rmem_data1_3 <= {sq28_contract_code[3*8-1:0] ,sq28_update_time[71:0] ,sq28_update_ms[31:0] ,sq28_new_price[63:0] ,sq28_turnover[31:0] ,sq28_volume[8*8-1:4*8] } ;
 9'h0_20: rmem_data1_3 <= {sq29_contract_code[3*8-1:0] ,sq29_update_time[71:0] ,sq29_update_ms[31:0] ,sq29_new_price[63:0] ,sq29_turnover[31:0] ,sq29_volume[8*8-1:4*8] } ;
 9'h0_40: rmem_data1_3 <= {sq30_contract_code[3*8-1:0] ,sq30_update_time[71:0] ,sq30_update_ms[31:0] ,sq30_new_price[63:0] ,sq30_turnover[31:0] ,sq30_volume[8*8-1:4*8] } ;
 9'h0_80: rmem_data1_3 <= {sq31_contract_code[3*8-1:0] ,sq31_update_time[71:0] ,sq31_update_ms[31:0] ,sq31_new_price[63:0] ,sq31_turnover[31:0] ,sq31_volume[8*8-1:4*8] } ;
 9'h1_00: rmem_data1_3 <= {contract_code[3*8-1:0] ,update_time[71:0] ,update_ms[31:0] ,new_price[63:0] ,turnover[31:0] ,volume[8*8-1:4*8] } ;
 default : rmem_data1_3 <= rmem_data1_3 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data1 <= 256'd0 ;
 end
 else if ( rmem_data1_0_vld ) begin
 rmem_data1 <= rmem_data1_0 ;
 end
 else if ( rmem_data1_1_vld ) begin
 rmem_data1 <= rmem_data1_1 ;
 end
 else if ( rmem_data1_2_vld ) begin
 rmem_data1 <= rmem_data1_2 ;
 end
 else if ( rmem_data1_3_vld ) begin
 rmem_data1 <= rmem_data1_3 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data2_1 <= 256'd0 ;
 rmem_data2_1_vld <= 1'd0 ;
 end
 else begin
 rmem_data2_1_vld <= |sq_market_rdy[23:16] ;
 case ( sq_market_rdy[23:16] ) 8'h01: rmem_data2_1 <= {sq16_volume[4*8-1:0] ,sq16_position[8*8-1:0] ,sq16_purchase_price[8*8-1:0] ,sq16_buy_quantity[31:0] ,sq16_sell_price[63:0] } ;
 8'h02: rmem_data2_1 <= {sq17_volume[4*8-1:0] ,sq17_position[8*8-1:0] ,sq17_purchase_price[8*8-1:0] ,sq17_buy_quantity[31:0] ,sq17_sell_price[63:0] } ;
 8'h04: rmem_data2_1 <= {sq18_volume[4*8-1:0] ,sq18_position[8*8-1:0] ,sq18_purchase_price[8*8-1:0] ,sq18_buy_quantity[31:0] ,sq18_sell_price[63:0] } ;
 8'h08: rmem_data2_1 <= {sq19_volume[4*8-1:0] ,sq19_position[8*8-1:0] ,sq19_purchase_price[8*8-1:0] ,sq19_buy_quantity[31:0] ,sq19_sell_price[63:0] } ;
 8'h10: rmem_data2_1 <= {sq20_volume[4*8-1:0] ,sq20_position[8*8-1:0] ,sq20_purchase_price[8*8-1:0] ,sq20_buy_quantity[31:0] ,sq20_sell_price[63:0] } ;
 8'h20: rmem_data2_1 <= {sq21_volume[4*8-1:0] ,sq21_position[8*8-1:0] ,sq21_purchase_price[8*8-1:0] ,sq21_buy_quantity[31:0] ,sq21_sell_price[63:0] } ;
 8'h40: rmem_data2_1 <= {sq22_volume[4*8-1:0] ,sq22_position[8*8-1:0] ,sq22_purchase_price[8*8-1:0] ,sq22_buy_quantity[31:0] ,sq22_sell_price[63:0] } ;
 8'h80 : rmem_data2_1 <= {sq23_volume[4*8-1:0] ,sq23_position[8*8-1:0] ,sq23_purchase_price[8*8-1:0] ,sq23_buy_quantity[31:0] ,sq23_sell_price[63:0] } ;
 default : rmem_data2_1 <= rmem_data2_1 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data2_3 <= 256'd0 ;
 rmem_data2_3_vld <= 1'd0 ;
 end
 else begin
 rmem_data2_3_vld <= |{market_rdy,sq_market_rdy[31:24]} ;
 case ({market_rdy,sq_market_rdy[31:24]}) 9'h0_01: rmem_data2_3 <= {sq24_volume[4*8-1:0] ,sq24_position[8*8-1:0] ,sq24_purchase_price[8*8-1:0] ,sq24_buy_quantity[31:0] ,sq24_sell_price[63:0] } ;
 9'h0_02: rmem_data2_3 <= {sq25_volume[4*8-1:0] ,sq25_position[8*8-1:0] ,sq25_purchase_price[8*8-1:0] ,sq25_buy_quantity[31:0] ,sq25_sell_price[63:0] } ;
 9'h0_04: rmem_data2_3 <= {sq26_volume[4*8-1:0] ,sq26_position[8*8-1:0] ,sq26_purchase_price[8*8-1:0] ,sq26_buy_quantity[31:0] ,sq26_sell_price[63:0] } ;
 9'h0_08: rmem_data2_3 <= {sq27_volume[4*8-1:0] ,sq27_position[8*8-1:0] ,sq27_purchase_price[8*8-1:0] ,sq27_buy_quantity[31:0] ,sq27_sell_price[63:0] } ;
 9'h0_10: rmem_data2_3 <= {sq28_volume[4*8-1:0] ,sq28_position[8*8-1:0] ,sq28_purchase_price[8*8-1:0] ,sq28_buy_quantity[31:0] ,sq28_sell_price[63:0] } ;
 9'h0_20: rmem_data2_3 <= {sq29_volume[4*8-1:0] ,sq29_position[8*8-1:0] ,sq29_purchase_price[8*8-1:0] ,sq29_buy_quantity[31:0] ,sq29_sell_price[63:0] } ;
 9'h0_40: rmem_data2_3 <= {sq30_volume[4*8-1:0] ,sq30_position[8*8-1:0] ,sq30_purchase_price[8*8-1:0] ,sq30_buy_quantity[31:0] ,sq30_sell_price[63:0] } ;
 9'h0_80: rmem_data2_3 <= {sq31_volume[4*8-1:0] ,sq31_position[8*8-1:0] ,sq31_purchase_price[8*8-1:0] ,sq31_buy_quantity[31:0] ,sq31_sell_price[63:0] } ;
 9'h1_00 : rmem_data2_3 <= {volume[4*8-1:0] ,position[8*8-1:0] ,purchase_price[8*8-1:0] ,buy_quantity[31:0] ,sell_price[63:0] } ;
 default : rmem_data2_3 <= rmem_data2_3 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data2_0 <= 256'd0 ;
 rmem_data2_0_vld <= 1'd0 ;
 end
 else begin
 rmem_data2_0_vld <= |sq_market_rdy[7:0] ;
 case ( sq_market_rdy[7:0]) 8'h01: rmem_data2_0 <= {sq00_volume[4*8-1:0] ,sq00_position[8*8-1:0] ,sq00_purchase_price[8*8-1:0] ,sq00_buy_quantity[31:0] ,sq00_sell_price[63:0] } ;
 8'h02: rmem_data2_0 <= {sq01_volume[4*8-1:0] ,sq01_position[8*8-1:0] ,sq01_purchase_price[8*8-1:0] ,sq01_buy_quantity[31:0] ,sq01_sell_price[63:0] } ;
 8'h04: rmem_data2_0 <= {sq02_volume[4*8-1:0] ,sq02_position[8*8-1:0] ,sq02_purchase_price[8*8-1:0] ,sq02_buy_quantity[31:0] ,sq02_sell_price[63:0] } ;
 8'h08: rmem_data2_0 <= {sq03_volume[4*8-1:0] ,sq03_position[8*8-1:0] ,sq03_purchase_price[8*8-1:0] ,sq03_buy_quantity[31:0] ,sq03_sell_price[63:0] } ;
 8'h10: rmem_data2_0 <= {sq04_volume[4*8-1:0] ,sq04_position[8*8-1:0] ,sq04_purchase_price[8*8-1:0] ,sq04_buy_quantity[31:0] ,sq04_sell_price[63:0] } ;
 8'h20: rmem_data2_0 <= {sq05_volume[4*8-1:0] ,sq05_position[8*8-1:0] ,sq05_purchase_price[8*8-1:0] ,sq05_buy_quantity[31:0] ,sq05_sell_price[63:0] } ;
 8'h40: rmem_data2_0 <= {sq06_volume[4*8-1:0] ,sq06_position[8*8-1:0] ,sq06_purchase_price[8*8-1:0] ,sq06_buy_quantity[31:0] ,sq06_sell_price[63:0] } ;
 8'h80 : rmem_data2_0 <= {sq07_volume[4*8-1:0] ,sq07_position[8*8-1:0] ,sq07_purchase_price[8*8-1:0] ,sq07_buy_quantity[31:0] ,sq07_sell_price[63:0] } ;
 default : rmem_data2_0 <= rmem_data2_0 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data2_2 <= 256'd0 ;
 rmem_data2_2_vld <= 1'd0 ;
 end
 else begin
 rmem_data2_2_vld <= |sq_market_rdy[15:8] ;
 case ( sq_market_rdy[15:8]) 8'h01: rmem_data2_2 <= {sq08_volume[4*8-1:0] ,sq08_position[8*8-1:0] ,sq08_purchase_price[8*8-1:0] ,sq08_buy_quantity[31:0] ,sq08_sell_price[63:0] } ;
 8'h02: rmem_data2_2 <= {sq09_volume[4*8-1:0] ,sq09_position[8*8-1:0] ,sq09_purchase_price[8*8-1:0] ,sq09_buy_quantity[31:0] ,sq09_sell_price[63:0] } ;
 8'h04: rmem_data2_2 <= {sq10_volume[4*8-1:0] ,sq10_position[8*8-1:0] ,sq10_purchase_price[8*8-1:0] ,sq10_buy_quantity[31:0] ,sq10_sell_price[63:0] } ;
 8'h08: rmem_data2_2 <= {sq11_volume[4*8-1:0] ,sq11_position[8*8-1:0] ,sq11_purchase_price[8*8-1:0] ,sq11_buy_quantity[31:0] ,sq11_sell_price[63:0] } ;
 8'h10: rmem_data2_2 <= {sq12_volume[4*8-1:0] ,sq12_position[8*8-1:0] ,sq12_purchase_price[8*8-1:0] ,sq12_buy_quantity[31:0] ,sq12_sell_price[63:0] } ;
 8'h20: rmem_data2_2 <= {sq13_volume[4*8-1:0] ,sq13_position[8*8-1:0] ,sq13_purchase_price[8*8-1:0] ,sq13_buy_quantity[31:0] ,sq13_sell_price[63:0] } ;
 8'h40: rmem_data2_2 <= {sq14_volume[4*8-1:0] ,sq14_position[8*8-1:0] ,sq14_purchase_price[8*8-1:0] ,sq14_buy_quantity[31:0] ,sq14_sell_price[63:0] } ;
 8'h80 : rmem_data2_2 <= {sq15_volume[4*8-1:0] ,sq15_position[8*8-1:0] ,sq15_purchase_price[8*8-1:0] ,sq15_buy_quantity[31:0] ,sq15_sell_price[63:0] } ;
 default : rmem_data2_2 <= rmem_data2_2 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data2 <= 256'd0 ;
 end
 else if ( rmem_data2_0_vld ) begin
 rmem_data2 <= rmem_data2_0 ;
 end
 else if ( rmem_data2_1_vld ) begin
 rmem_data2 <= rmem_data2_1 ;
 end
 else if ( rmem_data2_2_vld ) begin
 rmem_data2 <= rmem_data2_2 ;
 end
 else if ( rmem_data2_3_vld ) begin
 rmem_data2 <= rmem_data2_3 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_data3 <= 32'd0 ;
 end
 else begin
 case ({market_rdy,sq_market_rdy}) 33'h0_0000_0001: rmem_data3 <= {sq00_sell_quantity[31:0]} ;
 33'h0_0000_0002: rmem_data3 <= {sq01_sell_quantity[31:0]} ;
 33'h0_0000_0004: rmem_data3 <= {sq02_sell_quantity[31:0]} ;
 33'h0_0000_0008: rmem_data3 <= {sq03_sell_quantity[31:0]} ;
 33'h0_0000_0010: rmem_data3 <= {sq04_sell_quantity[31:0]} ;
 33'h0_0000_0020: rmem_data3 <= {sq05_sell_quantity[31:0]} ;
 33'h0_0000_0040: rmem_data3 <= {sq06_sell_quantity[31:0]} ;
 33'h0_0000_0080: rmem_data3 <= {sq07_sell_quantity[31:0]} ;
 33'h0_0000_0100: rmem_data3 <= {sq08_sell_quantity[31:0]} ;
 33'h0_0000_0200: rmem_data3 <= {sq09_sell_quantity[31:0]} ;
 33'h0_0000_0400: rmem_data3 <= {sq10_sell_quantity[31:0]} ;
 33'h0_0000_0800: rmem_data3 <= {sq11_sell_quantity[31:0]} ;
 33'h0_0000_1000: rmem_data3 <= {sq12_sell_quantity[31:0]} ;
 33'h0_0000_2000: rmem_data3 <= {sq13_sell_quantity[31:0]} ;
 33'h0_0000_4000: rmem_data3 <= {sq14_sell_quantity[31:0]} ;
 33'h0_0000_8000: rmem_data3 <= {sq15_sell_quantity[31:0]} ;
 33'h0_0001_0000: rmem_data3 <= {sq16_sell_quantity[31:0]} ;
 33'h0_0002_0000: rmem_data3 <= {sq17_sell_quantity[31:0]} ;
 33'h0_0004_0000: rmem_data3 <= {sq18_sell_quantity[31:0]} ;
 33'h0_0008_0000: rmem_data3 <= {sq19_sell_quantity[31:0]} ;
 33'h0_0010_0000: rmem_data3 <= {sq20_sell_quantity[31:0]} ;
 33'h0_0020_0000: rmem_data3 <= {sq21_sell_quantity[31:0]} ;
 33'h0_0040_0000: rmem_data3 <= {sq22_sell_quantity[31:0]} ;
 33'h0_0080_0000: rmem_data3 <= {sq23_sell_quantity[31:0]} ;
 33'h0_0100_0000: rmem_data3 <= {sq24_sell_quantity[31:0]} ;
 33'h0_0200_0000: rmem_data3 <= {sq25_sell_quantity[31:0]} ;
 33'h0_0400_0000: rmem_data3 <= {sq26_sell_quantity[31:0]} ;
 33'h0_0800_0000: rmem_data3 <= {sq27_sell_quantity[31:0]} ;
 33'h0_1000_0000: rmem_data3 <= {sq28_sell_quantity[31:0]} ;
 33'h0_2000_0000: rmem_data3 <= {sq29_sell_quantity[31:0]} ;
 33'h0_4000_0000: rmem_data3 <= {sq30_sell_quantity[31:0]} ;
 33'h0_8000_0000: rmem_data3 <= {sq31_sell_quantity[31:0]} ;
 33'h1_0000_0000: rmem_data3 <= {sell_quantity[31:0] } ;
 default : rmem_data3 <= rmem_data3 ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_vld <= 1'd0 ;
 end
 else if (market_rdy|| (|sq_market_rdy) ) begin
 rmem_vld <= 1'd1 ;
 end
 else if ( rmem_vld &&(rmem_cnt==2'd3)) begin
 rmem_vld <= 1'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 rmem_cnt <= 2'd0 ;
 end
 else if ( rmem_vld ) begin
 rmem_cnt <= rmem_cnt + 1'd1 ;
 end
 else begin
 rmem_cnt <= 2'd0 ;
 end
 end
 endmodule
 `timescale 1ns/1ns module fir_cut_out ( sq_cut_on , sq_cut_first_on , tcp_sqmatch_flag , current_sqid_reg_flag , sync_len_byte , sync_fisrt_byte , sync_four_byte , sq_rx_start , sq_rx_end , sq_rx_valid , sq_rx_data , sq_rx_empty , sq_rx_empty_01 , sq_rx_empty_02 , sq_rx_empty_03 , sq_rx_empty_04 , sq_rx_empty_05 , sq_rx_empty_06 , sq_rx_empty_07 , sq_rx_empty_08 , sq_rx_empty_09 , sq_rx_empty_10 , sq_rx_empty_11 , sq_rx_empty_12 , sq_rx_empty_13 , sq_rx_empty_14 , sq_rx_empty_15 , sq_rx_empty_16 , sq_rx_empty_17 , sq_rx_empty_18 , sq_rx_empty_19 , sq_rx_empty_20 , sq_rx_empty_21 , sq_rx_empty_22 , sq_rx_empty_23 , sq_rx_empty_24 , sq_rx_empty_25 , sq_rx_empty_26 , sq_rx_empty_27 , sq_rx_empty_28 , sq_rx_empty_29 , sq_rx_empty_30 , sq_rx_empty_31 , fir_r_sqcuth_st , fir_r_vsync_st , fir_r_sqrcut_st , fir_r_sqrcut_end_st , fir_r_sqcut_st , fir_r_sqcut_end_st , sub_sqcut_len_reg , st_shift_ccnt , st_rx_cnt_reg , sq_frame_flag , st_shift_reg , clk , rst_n );
 input clk ;
 input rst_n ;
 input [31:0] sq_cut_on ;
 input [31:0] sq_cut_first_on ;
 input [31:0] tcp_sqmatch_flag ;
 input current_sqid_reg_flag ;
 output [31:0] sq_rx_start ;
 output [31:0] sq_rx_end ;
 output [31:0] sq_rx_valid ;
 output [63:0] sq_rx_data ;
 output [ 2:0] sq_rx_empty ;
 output [ 2:0] sq_rx_empty_01 ;
 output [ 2:0] sq_rx_empty_02 ;
 output [ 2:0] sq_rx_empty_03 ;
 output [ 2:0] sq_rx_empty_04 ;
 output [ 2:0] sq_rx_empty_05 ;
 output [ 2:0] sq_rx_empty_06 ;
 output [ 2:0] sq_rx_empty_07 ;
 output [ 2:0] sq_rx_empty_08 ;
 output [ 2:0] sq_rx_empty_09 ;
 output [ 2:0] sq_rx_empty_10 ;
 output [ 2:0] sq_rx_empty_11 ;
 output [ 2:0] sq_rx_empty_12 ;
 output [ 2:0] sq_rx_empty_13 ;
 output [ 2:0] sq_rx_empty_14 ;
 output [ 2:0] sq_rx_empty_15 ;
 output [ 2:0] sq_rx_empty_16 ;
 output [ 2:0] sq_rx_empty_17 ;
 output [ 2:0] sq_rx_empty_18 ;
 output [ 2:0] sq_rx_empty_19 ;
 output [ 2:0] sq_rx_empty_20 ;
 output [ 2:0] sq_rx_empty_21 ;
 output [ 2:0] sq_rx_empty_22 ;
 output [ 2:0] sq_rx_empty_23 ;
 output [ 2:0] sq_rx_empty_24 ;
 output [ 2:0] sq_rx_empty_25 ;
 output [ 2:0] sq_rx_empty_26 ;
 output [ 2:0] sq_rx_empty_27 ;
 output [ 2:0] sq_rx_empty_28 ;
 output [ 2:0] sq_rx_empty_29 ;
 output [ 2:0] sq_rx_empty_30 ;
 output [ 2:0] sq_rx_empty_31 ;
 input fir_r_sqcuth_st ;
 input fir_r_vsync_st ;
 input fir_r_sqrcut_st ;
 input fir_r_sqrcut_end_st ;
 input [ 5:0] sub_sqcut_len_reg ;
 input fir_r_sqcut_st ;
 input fir_r_sqcut_end_st ;
 input [ 5:0] st_shift_ccnt ;
 input [ 15:0] st_rx_cnt_reg ;
 input sq_frame_flag ;
 input [191:0] st_shift_reg ;
 input [ 15:0] sync_len_byte ;
 input [ 15:0] sync_fisrt_byte ;
 input [ 31:0] sync_four_byte ;
 reg [31:0] sq_rx_start ;
 reg [31:0] sq_rx_valid ;
 reg [63:0] sq_rx_data ;
 reg [ 2:0] sq_rx_empty ;
 reg [ 2:0] sq_rx_empty_01 ;
 reg [ 2:0] sq_rx_empty_02 ;
 reg [ 2:0] sq_rx_empty_03 ;
 reg [ 2:0] sq_rx_empty_04 ;
 reg [ 2:0] sq_rx_empty_05 ;
 reg [ 2:0] sq_rx_empty_06 ;
 reg [ 2:0] sq_rx_empty_07 ;
 reg [ 2:0] sq_rx_empty_08 ;
 reg [ 2:0] sq_rx_empty_09 ;
 reg [ 2:0] sq_rx_empty_10 ;
 reg [ 2:0] sq_rx_empty_11 ;
 reg [ 2:0] sq_rx_empty_12 ;
 reg [ 2:0] sq_rx_empty_13 ;
 reg [ 2:0] sq_rx_empty_14 ;
 reg [ 2:0] sq_rx_empty_15 ;
 reg [ 2:0] sq_rx_empty_16 ;
 reg [ 2:0] sq_rx_empty_17 ;
 reg [ 2:0] sq_rx_empty_18 ;
 reg [ 2:0] sq_rx_empty_19 ;
 reg [ 2:0] sq_rx_empty_20 ;
 reg [ 2:0] sq_rx_empty_21 ;
 reg [ 2:0] sq_rx_empty_22 ;
 reg [ 2:0] sq_rx_empty_23 ;
 reg [ 2:0] sq_rx_empty_24 ;
 reg [ 2:0] sq_rx_empty_25 ;
 reg [ 2:0] sq_rx_empty_26 ;
 reg [ 2:0] sq_rx_empty_27 ;
 reg [ 2:0] sq_rx_empty_28 ;
 reg [ 2:0] sq_rx_empty_29 ;
 reg [ 2:0] sq_rx_empty_30 ;
 reg [ 2:0] sq_rx_empty_31 ;
 wire [31:0] sq_rx_end = 32'd0 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_rx_start <= 32'd0 ;
 end
 else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 sq_rx_start[ 0] <= sq_cut_first_on[ 0];
 sq_rx_start[ 1] <= sq_cut_first_on[ 1];
 sq_rx_start[ 2] <= sq_cut_first_on[ 2];
 sq_rx_start[ 3] <= sq_cut_first_on[ 3];
 sq_rx_start[ 4] <= sq_cut_first_on[ 4];
 sq_rx_start[ 5] <= sq_cut_first_on[ 5];
 sq_rx_start[ 6] <= sq_cut_first_on[ 6];
 sq_rx_start[ 7] <= sq_cut_first_on[ 7];
 sq_rx_start[ 8] <= sq_cut_first_on[ 8];
 sq_rx_start[ 9] <= sq_cut_first_on[ 9];
 sq_rx_start[10] <= sq_cut_first_on[10];
 sq_rx_start[11] <= sq_cut_first_on[11];
 sq_rx_start[12] <= sq_cut_first_on[12];
 sq_rx_start[13] <= sq_cut_first_on[13];
 sq_rx_start[14] <= sq_cut_first_on[14];
 sq_rx_start[15] <= sq_cut_first_on[15];
 sq_rx_start[16] <= sq_cut_first_on[16];
 sq_rx_start[17] <= sq_cut_first_on[17];
 sq_rx_start[18] <= sq_cut_first_on[18];
 sq_rx_start[19] <= sq_cut_first_on[19];
 sq_rx_start[20] <= sq_cut_first_on[20];
 sq_rx_start[21] <= sq_cut_first_on[21];
 sq_rx_start[22] <= sq_cut_first_on[22];
 sq_rx_start[23] <= sq_cut_first_on[23];
 sq_rx_start[24] <= sq_cut_first_on[24];
 sq_rx_start[25] <= sq_cut_first_on[25];
 sq_rx_start[26] <= sq_cut_first_on[26];
 sq_rx_start[27] <= sq_cut_first_on[27];
 sq_rx_start[28] <= sq_cut_first_on[28];
 sq_rx_start[29] <= sq_cut_first_on[29];
 sq_rx_start[30] <= sq_cut_first_on[30];
 sq_rx_start[31] <= sq_cut_first_on[31];
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) && ( st_rx_cnt_reg<(sync_len_byte+16'd4) ) && sq_frame_flag && current_sqid_reg_flag && (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 sq_rx_start[ 0] <= ~sq_cut_on[ 0] ;
 sq_rx_start[ 1] <= ~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ;
 sq_rx_start[ 2] <= ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ;
 sq_rx_start[ 3] <= ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ;
 sq_rx_start[ 4] <= ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ;
 sq_rx_start[ 5] <= ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ;
 sq_rx_start[ 6] <= ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ;
 sq_rx_start[ 7] <= ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ;
 sq_rx_start[ 8] <= ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ;
 sq_rx_start[ 9] <= ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ;
 sq_rx_start[10] <= ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ;
 sq_rx_start[11] <= ~sq_cut_on[11] && (&sq_cut_on[10:0]) ;
 sq_rx_start[12] <= ~sq_cut_on[12] && (&sq_cut_on[11:0]) ;
 sq_rx_start[13] <= ~sq_cut_on[13] && (&sq_cut_on[12:0]) ;
 sq_rx_start[14] <= ~sq_cut_on[14] && (&sq_cut_on[13:0]) ;
 sq_rx_start[15] <= ~sq_cut_on[15] && (&sq_cut_on[14:0]) ;
 sq_rx_start[16] <= ~sq_cut_on[16] && (&sq_cut_on[15:0]) ;
 sq_rx_start[17] <= ~sq_cut_on[17] && (&sq_cut_on[16:0]) ;
 sq_rx_start[18] <= ~sq_cut_on[18] && (&sq_cut_on[17:0]) ;
 sq_rx_start[19] <= ~sq_cut_on[19] && (&sq_cut_on[18:0]) ;
 sq_rx_start[20] <= ~sq_cut_on[20] && (&sq_cut_on[19:0]) ;
 sq_rx_start[21] <= ~sq_cut_on[21] && (&sq_cut_on[20:0]) ;
 sq_rx_start[22] <= ~sq_cut_on[22] && (&sq_cut_on[21:0]) ;
 sq_rx_start[23] <= ~sq_cut_on[23] && (&sq_cut_on[22:0]) ;
 sq_rx_start[24] <= ~sq_cut_on[24] && (&sq_cut_on[23:0]) ;
 sq_rx_start[25] <= ~sq_cut_on[25] && (&sq_cut_on[24:0]) ;
 sq_rx_start[26] <= ~sq_cut_on[26] && (&sq_cut_on[25:0]) ;
 sq_rx_start[27] <= ~sq_cut_on[27] && (&sq_cut_on[26:0]) ;
 sq_rx_start[28] <= ~sq_cut_on[28] && (&sq_cut_on[27:0]) ;
 sq_rx_start[29] <= ~sq_cut_on[29] && (&sq_cut_on[28:0]) ;
 sq_rx_start[30] <= ~sq_cut_on[30] && (&sq_cut_on[29:0]) ;
 sq_rx_start[31] <= ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;
 end
 else begin
 sq_rx_start <= 32'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_rx_valid <= 32'd0 ;
 end
 else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 sq_rx_valid[ 0] <= sq_cut_first_on[ 0];
 sq_rx_valid[ 1] <= sq_cut_first_on[ 1];
 sq_rx_valid[ 2] <= sq_cut_first_on[ 2];
 sq_rx_valid[ 3] <= sq_cut_first_on[ 3];
 sq_rx_valid[ 4] <= sq_cut_first_on[ 4];
 sq_rx_valid[ 5] <= sq_cut_first_on[ 5];
 sq_rx_valid[ 6] <= sq_cut_first_on[ 6];
 sq_rx_valid[ 7] <= sq_cut_first_on[ 7];
 sq_rx_valid[ 8] <= sq_cut_first_on[ 8];
 sq_rx_valid[ 9] <= sq_cut_first_on[ 9];
 sq_rx_valid[10] <= sq_cut_first_on[10];
 sq_rx_valid[11] <= sq_cut_first_on[11];
 sq_rx_valid[12] <= sq_cut_first_on[12];
 sq_rx_valid[13] <= sq_cut_first_on[13];
 sq_rx_valid[14] <= sq_cut_first_on[14];
 sq_rx_valid[15] <= sq_cut_first_on[15];
 sq_rx_valid[16] <= sq_cut_first_on[16];
 sq_rx_valid[17] <= sq_cut_first_on[17];
 sq_rx_valid[18] <= sq_cut_first_on[18];
 sq_rx_valid[19] <= sq_cut_first_on[19];
 sq_rx_valid[20] <= sq_cut_first_on[20];
 sq_rx_valid[21] <= sq_cut_first_on[21];
 sq_rx_valid[22] <= sq_cut_first_on[22];
 sq_rx_valid[23] <= sq_cut_first_on[23];
 sq_rx_valid[24] <= sq_cut_first_on[24];
 sq_rx_valid[25] <= sq_cut_first_on[25];
 sq_rx_valid[26] <= sq_cut_first_on[26];
 sq_rx_valid[27] <= sq_cut_first_on[27];
 sq_rx_valid[28] <= sq_cut_first_on[28];
 sq_rx_valid[29] <= sq_cut_first_on[29];
 sq_rx_valid[30] <= sq_cut_first_on[30];
 sq_rx_valid[31] <= sq_cut_first_on[31];
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) && ( st_rx_cnt_reg<(sync_len_byte+16'd4) ) && sq_frame_flag && current_sqid_reg_flag ) begin
 sq_rx_valid[ 0] <= ~sq_cut_on[ 0] ;
 sq_rx_valid[ 1] <= ~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ;
 sq_rx_valid[ 2] <= ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ;
 sq_rx_valid[ 3] <= ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ;
 sq_rx_valid[ 4] <= ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ;
 sq_rx_valid[ 5] <= ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ;
 sq_rx_valid[ 6] <= ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ;
 sq_rx_valid[ 7] <= ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ;
 sq_rx_valid[ 8] <= ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ;
 sq_rx_valid[ 9] <= ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ;
 sq_rx_valid[10] <= ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ;
 sq_rx_valid[11] <= ~sq_cut_on[11] && (&sq_cut_on[10:0]) ;
 sq_rx_valid[12] <= ~sq_cut_on[12] && (&sq_cut_on[11:0]) ;
 sq_rx_valid[13] <= ~sq_cut_on[13] && (&sq_cut_on[12:0]) ;
 sq_rx_valid[14] <= ~sq_cut_on[14] && (&sq_cut_on[13:0]) ;
 sq_rx_valid[15] <= ~sq_cut_on[15] && (&sq_cut_on[14:0]) ;
 sq_rx_valid[16] <= ~sq_cut_on[16] && (&sq_cut_on[15:0]) ;
 sq_rx_valid[17] <= ~sq_cut_on[17] && (&sq_cut_on[16:0]) ;
 sq_rx_valid[18] <= ~sq_cut_on[18] && (&sq_cut_on[17:0]) ;
 sq_rx_valid[19] <= ~sq_cut_on[19] && (&sq_cut_on[18:0]) ;
 sq_rx_valid[20] <= ~sq_cut_on[20] && (&sq_cut_on[19:0]) ;
 sq_rx_valid[21] <= ~sq_cut_on[21] && (&sq_cut_on[20:0]) ;
 sq_rx_valid[22] <= ~sq_cut_on[22] && (&sq_cut_on[21:0]) ;
 sq_rx_valid[23] <= ~sq_cut_on[23] && (&sq_cut_on[22:0]) ;
 sq_rx_valid[24] <= ~sq_cut_on[24] && (&sq_cut_on[23:0]) ;
 sq_rx_valid[25] <= ~sq_cut_on[25] && (&sq_cut_on[24:0]) ;
 sq_rx_valid[26] <= ~sq_cut_on[26] && (&sq_cut_on[25:0]) ;
 sq_rx_valid[27] <= ~sq_cut_on[27] && (&sq_cut_on[26:0]) ;
 sq_rx_valid[28] <= ~sq_cut_on[28] && (&sq_cut_on[27:0]) ;
 sq_rx_valid[29] <= ~sq_cut_on[29] && (&sq_cut_on[28:0]) ;
 sq_rx_valid[30] <= ~sq_cut_on[30] && (&sq_cut_on[29:0]) ;
 sq_rx_valid[31] <= ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;
 end
 else if ( fir_r_sqcut_st && (st_shift_ccnt>=6'd8) ) begin
 sq_rx_valid[ 0] <= sq_cut_first_on[ 0];
 sq_rx_valid[ 1] <= sq_cut_first_on[ 1];
 sq_rx_valid[ 2] <= sq_cut_first_on[ 2];
 sq_rx_valid[ 3] <= sq_cut_first_on[ 3];
 sq_rx_valid[ 4] <= sq_cut_first_on[ 4];
 sq_rx_valid[ 5] <= sq_cut_first_on[ 5];
 sq_rx_valid[ 6] <= sq_cut_first_on[ 6];
 sq_rx_valid[ 7] <= sq_cut_first_on[ 7];
 sq_rx_valid[ 8] <= sq_cut_first_on[ 8];
 sq_rx_valid[ 9] <= sq_cut_first_on[ 9];
 sq_rx_valid[10] <= sq_cut_first_on[10];
 sq_rx_valid[11] <= sq_cut_first_on[11];
 sq_rx_valid[12] <= sq_cut_first_on[12];
 sq_rx_valid[13] <= sq_cut_first_on[13];
 sq_rx_valid[14] <= sq_cut_first_on[14];
 sq_rx_valid[15] <= sq_cut_first_on[15];
 sq_rx_valid[16] <= sq_cut_first_on[16];
 sq_rx_valid[17] <= sq_cut_first_on[17];
 sq_rx_valid[18] <= sq_cut_first_on[18];
 sq_rx_valid[19] <= sq_cut_first_on[19];
 sq_rx_valid[20] <= sq_cut_first_on[20];
 sq_rx_valid[21] <= sq_cut_first_on[21];
 sq_rx_valid[22] <= sq_cut_first_on[22];
 sq_rx_valid[23] <= sq_cut_first_on[23];
 sq_rx_valid[24] <= sq_cut_first_on[24];
 sq_rx_valid[25] <= sq_cut_first_on[25];
 sq_rx_valid[26] <= sq_cut_first_on[26];
 sq_rx_valid[27] <= sq_cut_first_on[27];
 sq_rx_valid[28] <= sq_cut_first_on[28];
 sq_rx_valid[29] <= sq_cut_first_on[29];
 sq_rx_valid[30] <= sq_cut_first_on[30];
 sq_rx_valid[31] <= sq_cut_first_on[31];
 end
 else if ( fir_r_sqcut_end_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 sq_rx_valid[ 0] <= sq_cut_first_on[ 0];
 sq_rx_valid[ 1] <= sq_cut_first_on[ 1];
 sq_rx_valid[ 2] <= sq_cut_first_on[ 2];
 sq_rx_valid[ 3] <= sq_cut_first_on[ 3];
 sq_rx_valid[ 4] <= sq_cut_first_on[ 4];
 sq_rx_valid[ 5] <= sq_cut_first_on[ 5];
 sq_rx_valid[ 6] <= sq_cut_first_on[ 6];
 sq_rx_valid[ 7] <= sq_cut_first_on[ 7];
 sq_rx_valid[ 8] <= sq_cut_first_on[ 8];
 sq_rx_valid[ 9] <= sq_cut_first_on[ 9];
 sq_rx_valid[10] <= sq_cut_first_on[10];
 sq_rx_valid[11] <= sq_cut_first_on[11];
 sq_rx_valid[12] <= sq_cut_first_on[12];
 sq_rx_valid[13] <= sq_cut_first_on[13];
 sq_rx_valid[14] <= sq_cut_first_on[14];
 sq_rx_valid[15] <= sq_cut_first_on[15];
 sq_rx_valid[16] <= sq_cut_first_on[16];
 sq_rx_valid[17] <= sq_cut_first_on[17];
 sq_rx_valid[18] <= sq_cut_first_on[18];
 sq_rx_valid[19] <= sq_cut_first_on[19];
 sq_rx_valid[20] <= sq_cut_first_on[20];
 sq_rx_valid[21] <= sq_cut_first_on[21];
 sq_rx_valid[22] <= sq_cut_first_on[22];
 sq_rx_valid[23] <= sq_cut_first_on[23];
 sq_rx_valid[24] <= sq_cut_first_on[24];
 sq_rx_valid[25] <= sq_cut_first_on[25];
 sq_rx_valid[26] <= sq_cut_first_on[26];
 sq_rx_valid[27] <= sq_cut_first_on[27];
 sq_rx_valid[28] <= sq_cut_first_on[28];
 sq_rx_valid[29] <= sq_cut_first_on[29];
 sq_rx_valid[30] <= sq_cut_first_on[30];
 sq_rx_valid[31] <= sq_cut_first_on[31];
 end
 else if ( fir_r_sqrcut_st && (st_shift_ccnt>=6'd8) ) begin
 sq_rx_valid[ 0] <= tcp_sqmatch_flag[ 0] ;
 sq_rx_valid[ 1] <= tcp_sqmatch_flag[ 1] ;
 sq_rx_valid[ 2] <= tcp_sqmatch_flag[ 2] ;
 sq_rx_valid[ 3] <= tcp_sqmatch_flag[ 3] ;
 sq_rx_valid[ 4] <= tcp_sqmatch_flag[ 4] ;
 sq_rx_valid[ 5] <= tcp_sqmatch_flag[ 5] ;
 sq_rx_valid[ 6] <= tcp_sqmatch_flag[ 6] ;
 sq_rx_valid[ 7] <= tcp_sqmatch_flag[ 7] ;
 sq_rx_valid[ 8] <= tcp_sqmatch_flag[ 8] ;
 sq_rx_valid[ 9] <= tcp_sqmatch_flag[ 9] ;
 sq_rx_valid[10] <= tcp_sqmatch_flag[10] ;
 sq_rx_valid[11] <= tcp_sqmatch_flag[11] ;
 sq_rx_valid[12] <= tcp_sqmatch_flag[12] ;
 sq_rx_valid[13] <= tcp_sqmatch_flag[13] ;
 sq_rx_valid[14] <= tcp_sqmatch_flag[14] ;
 sq_rx_valid[15] <= tcp_sqmatch_flag[15] ;
 sq_rx_valid[16] <= tcp_sqmatch_flag[16] ;
 sq_rx_valid[17] <= tcp_sqmatch_flag[17] ;
 sq_rx_valid[18] <= tcp_sqmatch_flag[18] ;
 sq_rx_valid[19] <= tcp_sqmatch_flag[19] ;
 sq_rx_valid[20] <= tcp_sqmatch_flag[20] ;
 sq_rx_valid[21] <= tcp_sqmatch_flag[21] ;
 sq_rx_valid[22] <= tcp_sqmatch_flag[22] ;
 sq_rx_valid[23] <= tcp_sqmatch_flag[23] ;
 sq_rx_valid[24] <= tcp_sqmatch_flag[24] ;
 sq_rx_valid[25] <= tcp_sqmatch_flag[25] ;
 sq_rx_valid[26] <= tcp_sqmatch_flag[26] ;
 sq_rx_valid[27] <= tcp_sqmatch_flag[27] ;
 sq_rx_valid[28] <= tcp_sqmatch_flag[28] ;
 sq_rx_valid[29] <= tcp_sqmatch_flag[29] ;
 sq_rx_valid[30] <= tcp_sqmatch_flag[30] ;
 sq_rx_valid[31] <= tcp_sqmatch_flag[31] ;
 end
 else if ( fir_r_sqrcut_end_st && (st_shift_ccnt>= sub_sqcut_len_reg[5:0] ) ) begin
 sq_rx_valid[ 0] <= tcp_sqmatch_flag[ 0] ;
 sq_rx_valid[ 1] <= tcp_sqmatch_flag[ 1] ;
 sq_rx_valid[ 2] <= tcp_sqmatch_flag[ 2] ;
 sq_rx_valid[ 3] <= tcp_sqmatch_flag[ 3] ;
 sq_rx_valid[ 4] <= tcp_sqmatch_flag[ 4] ;
 sq_rx_valid[ 5] <= tcp_sqmatch_flag[ 5] ;
 sq_rx_valid[ 6] <= tcp_sqmatch_flag[ 6] ;
 sq_rx_valid[ 7] <= tcp_sqmatch_flag[ 7] ;
 sq_rx_valid[ 8] <= tcp_sqmatch_flag[ 8] ;
 sq_rx_valid[ 9] <= tcp_sqmatch_flag[ 9] ;
 sq_rx_valid[10] <= tcp_sqmatch_flag[10] ;
 sq_rx_valid[11] <= tcp_sqmatch_flag[11] ;
 sq_rx_valid[12] <= tcp_sqmatch_flag[12] ;
 sq_rx_valid[13] <= tcp_sqmatch_flag[13] ;
 sq_rx_valid[14] <= tcp_sqmatch_flag[14] ;
 sq_rx_valid[15] <= tcp_sqmatch_flag[15] ;
 sq_rx_valid[16] <= tcp_sqmatch_flag[16] ;
 sq_rx_valid[17] <= tcp_sqmatch_flag[17] ;
 sq_rx_valid[18] <= tcp_sqmatch_flag[18] ;
 sq_rx_valid[19] <= tcp_sqmatch_flag[19] ;
 sq_rx_valid[20] <= tcp_sqmatch_flag[20] ;
 sq_rx_valid[21] <= tcp_sqmatch_flag[21] ;
 sq_rx_valid[22] <= tcp_sqmatch_flag[22] ;
 sq_rx_valid[23] <= tcp_sqmatch_flag[23] ;
 sq_rx_valid[24] <= tcp_sqmatch_flag[24] ;
 sq_rx_valid[25] <= tcp_sqmatch_flag[25] ;
 sq_rx_valid[26] <= tcp_sqmatch_flag[26] ;
 sq_rx_valid[27] <= tcp_sqmatch_flag[27] ;
 sq_rx_valid[28] <= tcp_sqmatch_flag[28] ;
 sq_rx_valid[29] <= tcp_sqmatch_flag[29] ;
 sq_rx_valid[30] <= tcp_sqmatch_flag[30] ;
 sq_rx_valid[31] <= tcp_sqmatch_flag[31] ;
 end
 else begin
 sq_rx_valid <= 32'd0 ;
 end
 end
 wire [63: 0] sq_rx_data_wire = st_shift_reg[127+64:64+64];
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_rx_data <= 64'd0 ;
 end
 else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 sq_rx_data <= sq_rx_data_wire ;
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) ) begin
 sq_rx_data <= sq_rx_data_wire ;
 end
 else if ( ( fir_r_sqcut_st || fir_r_sqrcut_st) && (st_shift_ccnt>=6'd8) ) begin
 sq_rx_data <= sq_rx_data_wire ;
 end
 else if ( fir_r_sqcut_end_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 sq_rx_data <= sq_rx_data_wire ;
 end
 else if ( fir_r_sqrcut_end_st ) begin
 sq_rx_data <= sq_rx_data_wire ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_rx_empty <= 3'd0 ;
 sq_rx_empty_01 <= 3'd0 ;
 sq_rx_empty_02 <= 3'd0 ;
 sq_rx_empty_03 <= 3'd0 ;
 sq_rx_empty_04 <= 3'd0 ;
 sq_rx_empty_05 <= 3'd0 ;
 sq_rx_empty_06 <= 3'd0 ;
 sq_rx_empty_07 <= 3'd0 ;
 sq_rx_empty_08 <= 3'd0 ;
 sq_rx_empty_09 <= 3'd0 ;
 sq_rx_empty_10 <= 3'd0 ;
 sq_rx_empty_11 <= 3'd0 ;
 sq_rx_empty_12 <= 3'd0 ;
 sq_rx_empty_13 <= 3'd0 ;
 sq_rx_empty_14 <= 3'd0 ;
 sq_rx_empty_15 <= 3'd0 ;
 sq_rx_empty_16 <= 3'd0 ;
 sq_rx_empty_17 <= 3'd0 ;
 sq_rx_empty_18 <= 3'd0 ;
 sq_rx_empty_19 <= 3'd0 ;
 sq_rx_empty_20 <= 3'd0 ;
 sq_rx_empty_21 <= 3'd0 ;
 sq_rx_empty_22 <= 3'd0 ;
 sq_rx_empty_23 <= 3'd0 ;
 sq_rx_empty_24 <= 3'd0 ;
 sq_rx_empty_25 <= 3'd0 ;
 sq_rx_empty_26 <= 3'd0 ;
 sq_rx_empty_27 <= 3'd0 ;
 sq_rx_empty_28 <= 3'd0 ;
 sq_rx_empty_29 <= 3'd0 ;
 sq_rx_empty_30 <= 3'd0 ;
 sq_rx_empty_31 <= 3'd0 ;
 end
 else if ( (fir_r_sqcuth_st || fir_r_sqcut_end_st) && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 sq_rx_empty <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_01 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_02 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_03 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_04 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_05 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_06 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_07 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_08 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_09 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_10 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_11 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_12 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_13 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_14 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_15 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_16 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_17 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_18 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_19 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_20 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_21 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_22 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_23 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_24 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_25 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_26 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_27 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_28 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_29 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_30 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 sq_rx_empty_31 <= 4'd8 - st_rx_cnt_reg[3:0] ;
 end
 else begin
 sq_rx_empty <= 3'd0 ;
 sq_rx_empty_01 <= 3'd0 ;
 sq_rx_empty_02 <= 3'd0 ;
 sq_rx_empty_03 <= 3'd0 ;
 sq_rx_empty_04 <= 3'd0 ;
 sq_rx_empty_05 <= 3'd0 ;
 sq_rx_empty_06 <= 3'd0 ;
 sq_rx_empty_07 <= 3'd0 ;
 sq_rx_empty_08 <= 3'd0 ;
 sq_rx_empty_09 <= 3'd0 ;
 sq_rx_empty_10 <= 3'd0 ;
 sq_rx_empty_11 <= 3'd0 ;
 sq_rx_empty_12 <= 3'd0 ;
 sq_rx_empty_13 <= 3'd0 ;
 sq_rx_empty_14 <= 3'd0 ;
 sq_rx_empty_15 <= 3'd0 ;
 sq_rx_empty_16 <= 3'd0 ;
 sq_rx_empty_17 <= 3'd0 ;
 sq_rx_empty_18 <= 3'd0 ;
 sq_rx_empty_19 <= 3'd0 ;
 sq_rx_empty_20 <= 3'd0 ;
 sq_rx_empty_21 <= 3'd0 ;
 sq_rx_empty_22 <= 3'd0 ;
 sq_rx_empty_23 <= 3'd0 ;
 sq_rx_empty_24 <= 3'd0 ;
 sq_rx_empty_25 <= 3'd0 ;
 sq_rx_empty_26 <= 3'd0 ;
 sq_rx_empty_27 <= 3'd0 ;
 sq_rx_empty_28 <= 3'd0 ;
 sq_rx_empty_29 <= 3'd0 ;
 sq_rx_empty_30 <= 3'd0 ;
 sq_rx_empty_31 <= 3'd0 ;
 end
 end
 endmodule
 module fir_shift_reg_192 ( fir_rx_cstate , st_rx_start , st_rx_offset , st_rx_end , st_rx_valid , st_rx_data , st_rx_ready , st_rx_empty , fir_r_idle_st , st_shift_reg , st_shift_ccnt , st_shift_scnt , st_shift_en , st_shift_full_flag , clk , rst_n );
 input [4:0] fir_rx_cstate ;
 input clk ;
 input rst_n ;
 input st_rx_start ;
 input [ 3:0] st_rx_offset ;
 input st_rx_end ;
 input st_rx_valid ;
 input [63:0] st_rx_data ;
 input [2:0] st_rx_empty ;
 input st_rx_ready ;
 input fir_r_idle_st ;
 output [191:0] st_shift_reg ;
 output [ 5:0] st_shift_ccnt ;
 input [ 5:0] st_shift_scnt ;
 input st_shift_en ;
 output st_shift_full_flag ;
 reg [191:0] st_shift_reg ;
 reg [ 5:0] st_shift_ccnt;
 wire [ 5:0] st_shift_ccnt_wire ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_ccnt <= 6'd0 ;
 end
 else if (st_rx_start) begin
 st_shift_ccnt <= 6'd8 - st_rx_offset - st_rx_empty ;
 end
 else if (fir_r_idle_st) begin
 st_shift_ccnt <= 6'd0 ;
 end
 else if ( (st_rx_valid&&st_rx_ready)&&(st_shift_en) ) begin
 st_shift_ccnt <= st_shift_ccnt + 6'd8 - st_shift_scnt - st_rx_empty;
 end
 else if ( st_rx_valid&&st_rx_ready ) begin
 st_shift_ccnt <= st_shift_ccnt + 6'd8 - st_rx_empty ;
 end
 else if ( st_shift_en ) begin
 st_shift_ccnt <= st_shift_ccnt - st_shift_scnt ;
 end
 end
 assign st_shift_ccnt_wire = st_shift_en ? ( st_shift_ccnt-st_shift_scnt ) : st_shift_ccnt ;
 reg [191:0] st_shift_reg_1;
 wire [191:0] st_shift_reg_2;
 reg [191:0] st_shift_reg_3;
 wire [191:0] st_shift_reg_4;
 assign st_shift_reg_2 = st_shift_en ? st_shift_reg_1 : st_shift_reg ;
 always@ (*) begin
 case ( st_shift_scnt ) 5'd0 : st_shift_reg_1 = { st_shift_reg[127+64: 0] } ;
 5'd1 : st_shift_reg_1 = { st_shift_reg[119+64: 0] , 8'd0 } ;
 5'd2 : st_shift_reg_1 = { st_shift_reg[111+64: 0] , 16'd0 } ;
 5'd3 : st_shift_reg_1 = { st_shift_reg[103+64: 0] , 24'd0 } ;
 5'd4 : st_shift_reg_1 = { st_shift_reg[ 95+64: 0] , 32'd0 } ;
 5'd5 : st_shift_reg_1 = { st_shift_reg[ 87+64: 0] , 40'd0 } ;
 5'd6 : st_shift_reg_1 = { st_shift_reg[ 79+64: 0] , 48'd0 } ;
 5'd7 : st_shift_reg_1 = { st_shift_reg[ 71+64: 0] , 56'd0 } ;
 5'd8 : st_shift_reg_1 = { st_shift_reg[ 63+64: 0] , 64'd0 } ;
 5'd9 : st_shift_reg_1 = { st_shift_reg[ 55+64: 0] , 72'd0 } ;
 5'd10 : st_shift_reg_1 = { st_shift_reg[ 47+64: 0] , 80'd0 } ;
 5'd11 : st_shift_reg_1 = { st_shift_reg[ 39+64: 0] , 88'd0 } ;
 5'd12 : st_shift_reg_1 = { st_shift_reg[ 31+64: 0] , 96'd0 } ;
 5'd13 : st_shift_reg_1 = { st_shift_reg[ 23+64: 0] ,104'd0 } ;
 5'd14 : st_shift_reg_1 = { st_shift_reg[ 15+64: 0] ,112'd0 } ;
 5'd15 : st_shift_reg_1 = { st_shift_reg[ 7+64: 0] ,120'd0 } ;
 5'd16 : st_shift_reg_1 = { st_shift_reg[ 63: 0] ,128'd0 } ;
 5'd17 : st_shift_reg_1 = { st_shift_reg[ 55: 0] ,136'd0 } ;
 5'd18 : st_shift_reg_1 = { st_shift_reg[ 47: 0] ,144'd0 } ;
 5'd19 : st_shift_reg_1 = { st_shift_reg[ 39: 0] ,152'd0 } ;
 5'd20 : st_shift_reg_1 = { st_shift_reg[ 31: 0] ,160'd0 } ;
 5'd21 : st_shift_reg_1 = { st_shift_reg[ 23: 0] ,168'd0 } ;
 5'd22 : st_shift_reg_1 = { st_shift_reg[ 15: 0] ,176'd0 } ;
 5'd23 : st_shift_reg_1 = { st_shift_reg[ 7: 0] ,184'd0 } ;
 5'd24 : st_shift_reg_1 = { 192'd0 } ;
 default : st_shift_reg_1 = { 192'd0 } ;
 endcase end
 always@ (*) begin
 case ( st_shift_ccnt_wire ) 5'd0 : st_shift_reg_3 = { st_rx_data[63:0] ,128'd0 } ;
 5'd1 : st_shift_reg_3 = { st_shift_reg_2[127+64:120+64],st_rx_data[63:0] ,120'd0 } ;
 5'd2 : st_shift_reg_3 = { st_shift_reg_2[127+64:112+64],st_rx_data[63:0] ,112'd0 } ;
 5'd3 : st_shift_reg_3 = { st_shift_reg_2[127+64:104+64],st_rx_data[63:0] ,104'd0 } ;
 5'd4 : st_shift_reg_3 = { st_shift_reg_2[127+64: 96+64],st_rx_data[63:0] , 96'd0 } ;
 5'd5 : st_shift_reg_3 = { st_shift_reg_2[127+64: 88+64],st_rx_data[63:0] , 88'd0 } ;
 5'd6 : st_shift_reg_3 = { st_shift_reg_2[127+64: 80+64],st_rx_data[63:0] , 80'd0 } ;
 5'd7 : st_shift_reg_3 = { st_shift_reg_2[127+64: 72+64],st_rx_data[63:0] , 72'd0 } ;
 5'd8 : st_shift_reg_3 = { st_shift_reg_2[127+64: 64+64],st_rx_data[63:0] , 64'd0 } ;
 5'd9 : st_shift_reg_3 = { st_shift_reg_2[127+64: 56+64],st_rx_data[63:0] , 56'd0 } ;
 5'd10 : st_shift_reg_3 = { st_shift_reg_2[127+64: 48+64],st_rx_data[63:0] , 48'd0 } ;
 5'd11 : st_shift_reg_3 = { st_shift_reg_2[127+64: 40+64],st_rx_data[63:0] , 40'd0 } ;
 5'd12 : st_shift_reg_3 = { st_shift_reg_2[127+64: 32+64],st_rx_data[63:0] , 32'd0 } ;
 5'd13 : st_shift_reg_3 = { st_shift_reg_2[127+64: 24+64],st_rx_data[63:0] , 24'd0 } ;
 5'd14 : st_shift_reg_3 = { st_shift_reg_2[127+64: 16+64],st_rx_data[63:0] , 16'd0 } ;
 5'd15 : st_shift_reg_3 = { st_shift_reg_2[127+64: 8+64],st_rx_data[63:0] , 8'd0 } ;
 5'd16 : st_shift_reg_3 = { st_shift_reg_2[127+64: 64],st_rx_data[63:0] } ;
 default : st_shift_reg_3 = { st_shift_reg_2[127+64: 64],st_rx_data[63:0] } ;
 endcase end
 assign st_shift_reg_4 = st_rx_valid&&st_rx_ready ? st_shift_reg_3 : st_shift_reg_2 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_reg <= 192'd0 ;
 end
 else if (st_rx_start) begin
 case ( st_rx_offset ) 3'd0 : st_shift_reg <= { st_rx_data[63:0] ,64'd0 ,64'd0 } ;
 3'd1 : st_shift_reg <= { st_rx_data[55:0] , 8'd0 ,64'd0 ,64'd0 } ;
 3'd2 : st_shift_reg <= { st_rx_data[47:0] , 16'd0 ,64'd0 ,64'd0 } ;
 3'd3 : st_shift_reg <= { st_rx_data[39:0] , 24'd0 ,64'd0 ,64'd0 } ;
 3'd4 : st_shift_reg <= { st_rx_data[31:0] , 32'd0 ,64'd0 ,64'd0 } ;
 3'd5 : st_shift_reg <= { st_rx_data[23:0] , 40'd0 ,64'd0 ,64'd0 } ;
 3'd6 : st_shift_reg <= { st_rx_data[15:0] , 48'd0 ,64'd0 ,64'd0 } ;
 3'd7 : st_shift_reg <= { st_rx_data[ 7:0] , 56'd0 ,64'd0 ,64'd0 } ;
 default : st_shift_reg <= { 64'd0 ,64'd0 ,64'd0 } ;
 endcase end
 else if (fir_r_idle_st) begin
 st_shift_reg <= 192'd0 ;
 end
 else if ( (st_rx_valid&&st_rx_ready) || (st_shift_en) ) begin
 st_shift_reg <= st_shift_reg_4 ;
 end
 end
 /* reg [23:0] st_shift_start_reg ;
 reg [23:0] st_shift_end_reg ;
 reg [23:0] st_shift_start_reg_1;
 wire [23:0] st_shift_start_reg_2;
 reg [23:0] st_shift_start_reg_3;
 wire [23:0] st_shift_start_reg_4;
 assign st_shift_start_reg_2 = st_shift_en ? st_shift_start_reg_1 : st_shift_start_reg ;
 always@ (*) begin
 case ( st_shift_scnt ) 6'd0 : st_shift_start_reg_1 = { st_shift_start_reg[ 15+8: 0] } ;
 6'd1 : st_shift_start_reg_1 = { st_shift_start_reg[ 14+8: 0] , 1'd0 } ;
 6'd2 : st_shift_start_reg_1 = { st_shift_start_reg[ 13+8: 0] , 2'd0 } ;
 6'd3 : st_shift_start_reg_1 = { st_shift_start_reg[ 12+8: 0] , 3'd0 } ;
 6'd4 : st_shift_start_reg_1 = { st_shift_start_reg[ 11+8: 0] , 4'd0 } ;
 6'd5 : st_shift_start_reg_1 = { st_shift_start_reg[ 10+8: 0] , 5'd0 } ;
 6'd6 : st_shift_start_reg_1 = { st_shift_start_reg[ 9+8: 0] , 6'd0 } ;
 6'd7 : st_shift_start_reg_1 = { st_shift_start_reg[ 8+8: 0] , 7'd0 } ;
 6'd8 : st_shift_start_reg_1 = { st_shift_start_reg[ 7+8: 0] , 8'd0 } ;
 6'd9 : st_shift_start_reg_1 = { st_shift_start_reg[ 6+8: 0] , 9'd0 } ;
 6'd10 : st_shift_start_reg_1 = { st_shift_start_reg[ 5+8: 0] ,10'd0 } ;
 6'd11 : st_shift_start_reg_1 = { st_shift_start_reg[ 4+8: 0] ,11'd0 } ;
 6'd12 : st_shift_start_reg_1 = { st_shift_start_reg[ 3+8: 0] ,12'd0 } ;
 6'd13 : st_shift_start_reg_1 = { st_shift_start_reg[ 2+8: 0] ,13'd0 } ;
 6'd14 : st_shift_start_reg_1 = { st_shift_start_reg[ 1+8: 0] ,14'd0 } ;
 6'd15 : st_shift_start_reg_1 = { st_shift_start_reg[ 8: 0] ,15'd0 } ;
 6'd16 : st_shift_start_reg_1 = { st_shift_start_reg[ 7: 0] ,16'd0 } ;
 6'd17 : st_shift_start_reg_1 = { st_shift_start_reg[ 6: 0] ,17'd0 } ;
 6'd18 : st_shift_start_reg_1 = { st_shift_start_reg[ 5: 0] ,18'd0 } ;
 6'd19 : st_shift_start_reg_1 = { st_shift_start_reg[ 4: 0] ,19'd0 } ;
 6'd20 : st_shift_start_reg_1 = { st_shift_start_reg[ 3: 0] ,20'd0 } ;
 6'd21 : st_shift_start_reg_1 = { st_shift_start_reg[ 2: 0] ,21'd0 } ;
 6'd22 : st_shift_start_reg_1 = { st_shift_start_reg[ 1: 0] ,22'd0 } ;
 6'd23 : st_shift_start_reg_1 = { st_shift_start_reg[ 0] ,23'd0 } ;
 6'd24 : st_shift_start_reg_1 = { 23'd0 } ;
 default : st_shift_start_reg_1 = { 23'd0 } ;
 endcase end
 always@ (*) begin
 case ( st_shift_ccnt_wire ) 5'd0 : st_shift_start_reg_3 = { {8{st_rx_start}} , 8'd0 ,8'd0 } ;
 5'd1 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8 ],{8{st_rx_start}} , 7'd0 ,8'd0 } ;
 5'd2 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8:14+8],{8{st_rx_start}} , 6'd0 ,8'd0 } ;
 5'd3 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8:13+8],{8{st_rx_start}} , 5'd0 ,8'd0 } ;
 5'd4 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8:12+8],{8{st_rx_start}} , 4'd0 ,8'd0 } ;
 5'd5 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8:11+8],{8{st_rx_start}} , 3'd0 ,8'd0 } ;
 5'd6 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8:10+8],{8{st_rx_start}} , 2'd0 ,8'd0 } ;
 5'd7 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 9+8],{8{st_rx_start}} , 1'd0 ,8'd0 } ;
 5'd8 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 8+8],{8{st_rx_start}} ,8'd0 } ;
 5'd9 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 7+8],{8{st_rx_start}} ,7'd0 } ;
 5'd10 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 6+8],{8{st_rx_start}} ,6'd0 } ;
 5'd11 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 5+8],{8{st_rx_start}} ,5'd0 } ;
 5'd12 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 4+8],{8{st_rx_start}} ,4'd0 } ;
 5'd13 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 3+8],{8{st_rx_start}} ,3'd0 } ;
 5'd14 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 2+8],{8{st_rx_start}} ,2'd0 } ;
 5'd15 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 1+8],{8{st_rx_start}} ,1'd0 } ;
 5'd16 : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 8],{8{st_rx_start}} } ;
 default : st_shift_start_reg_3 = { st_shift_start_reg_2[15+8: 8+8],{8{st_rx_start}} } ;
 endcase end
 assign st_shift_start_reg_4 = st_rx_valid&&st_rx_ready ? st_shift_start_reg_3 : st_shift_start_reg_2 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_start_reg <= 16'd0 ;
 end
 else if (st_rx_start) begin
 case ( st_rx_offset ) 3'd0 : st_shift_start_reg <= { 8'hff , 8'd0,8'd0 } ;
 3'd1 : st_shift_start_reg <= { 7'h7f , 9'd0,8'd0 } ;
 3'd2 : st_shift_start_reg <= { 6'h3f , 10'd0,8'd0 } ;
 3'd3 : st_shift_start_reg <= { 5'h1f , 11'd0,8'd0 } ;
 3'd4 : st_shift_start_reg <= { 4'hf , 12'd0,8'd0 } ;
 3'd5 : st_shift_start_reg <= { 3'h3 , 13'd0,8'd0 } ;
 3'd6 : st_shift_start_reg <= { 2'h2 , 14'd0,8'd0 } ;
 3'd7 : st_shift_start_reg <= { 1'h1 , 15'd0,8'd0 } ;
 default : st_shift_start_reg <= { 16'd0,8'd0 } ;
 endcase end
 else if (fir_r_idle_st) begin
 st_shift_start_reg <= 'd0 ;
 end
 else if ( (st_rx_valid&&st_rx_ready) || (st_shift_en) ) begin
 st_shift_start_reg <= st_shift_start_reg_4 ;
 end
 end
 reg [23:0] st_shift_end_reg_1;
 wire [23:0] st_shift_end_reg_2;
 reg [23:0] st_shift_end_reg_3;
 wire [23:0] st_shift_end_reg_4;
 assign st_shift_end_reg_2 = st_shift_en ? st_shift_end_reg_1 : st_shift_end_reg ;
 always@ (*) begin
 case ( st_shift_scnt ) 5'd0 : st_shift_end_reg_1 = { st_shift_end_reg[ 15+8: 0] } ;
 5'd1 : st_shift_end_reg_1 = { st_shift_end_reg[ 14+8: 0] , 1'd0 } ;
 5'd2 : st_shift_end_reg_1 = { st_shift_end_reg[ 13+8: 0] , 2'd0 } ;
 5'd3 : st_shift_end_reg_1 = { st_shift_end_reg[ 12+8: 0] , 3'd0 } ;
 5'd4 : st_shift_end_reg_1 = { st_shift_end_reg[ 11+8: 0] , 4'd0 } ;
 5'd5 : st_shift_end_reg_1 = { st_shift_end_reg[ 10+8: 0] , 5'd0 } ;
 5'd6 : st_shift_end_reg_1 = { st_shift_end_reg[ 9+8: 0] , 6'd0 } ;
 5'd7 : st_shift_end_reg_1 = { st_shift_end_reg[ 8+8: 0] , 7'd0 } ;
 5'd8 : st_shift_end_reg_1 = { st_shift_end_reg[ 7+8: 0] , 8'd0 } ;
 5'd9 : st_shift_end_reg_1 = { st_shift_end_reg[ 6+8: 0] , 9'd0 } ;
 5'd10 : st_shift_end_reg_1 = { st_shift_end_reg[ 5+8: 0] ,10'd0 } ;
 5'd11 : st_shift_end_reg_1 = { st_shift_end_reg[ 4+8: 0] ,11'd0 } ;
 5'd12 : st_shift_end_reg_1 = { st_shift_end_reg[ 3+8: 0] ,12'd0 } ;
 5'd13 : st_shift_end_reg_1 = { st_shift_end_reg[ 2+8: 0] ,13'd0 } ;
 5'd14 : st_shift_end_reg_1 = { st_shift_end_reg[ 1+8: 0] ,14'd0 } ;
 5'd15 : st_shift_end_reg_1 = { st_shift_end_reg[ 0+8: 0] ,15'd0 } ;
 5'd16 : st_shift_end_reg_1 = { st_shift_end_reg[ 7: 0] ,16'd0 } ;
 6'd17 : st_shift_end_reg_1 = { st_shift_end_reg[ 6: 0] ,17'd0 } ;
 6'd18 : st_shift_end_reg_1 = { st_shift_end_reg[ 5: 0] ,18'd0 } ;
 6'd19 : st_shift_end_reg_1 = { st_shift_end_reg[ 4: 0] ,19'd0 } ;
 6'd20 : st_shift_end_reg_1 = { st_shift_end_reg[ 3: 0] ,20'd0 } ;
 6'd21 : st_shift_end_reg_1 = { st_shift_end_reg[ 2: 0] ,21'd0 } ;
 6'd22 : st_shift_end_reg_1 = { st_shift_end_reg[ 1: 0] ,22'd0 } ;
 6'd23 : st_shift_end_reg_1 = { st_shift_end_reg[ 0] ,23'd0 } ;
 6'd24 : st_shift_end_reg_1 = { 23'd0 } ;
 default : st_shift_end_reg_1 = { 23'd0 } ;
 endcase end
 always@ (*) begin
 case ( st_shift_ccnt_wire ) 5'd0 : st_shift_end_reg_3 = { {8{st_rx_end}} , 8'd0 ,8'd0 } ;
 5'd1 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8 ],{8{st_rx_end}} , 7'd0 ,8'd0 } ;
 5'd2 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8:14+8],{8{st_rx_end}} , 6'd0 ,8'd0 } ;
 5'd3 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8:13+8],{8{st_rx_end}} , 5'd0 ,8'd0 } ;
 5'd4 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8:12+8],{8{st_rx_end}} , 4'd0 ,8'd0 } ;
 5'd5 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8:11+8],{8{st_rx_end}} , 3'd0 ,8'd0 } ;
 5'd6 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8:10+8],{8{st_rx_end}} , 2'd0 ,8'd0 } ;
 5'd7 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 9+8],{8{st_rx_end}} , 1'd0 ,8'd0 } ;
 5'd8 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 8+8],{8{st_rx_end}} ,8'd0 } ;
 5'd9 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 7+8],{8{st_rx_end}} ,7'd0 } ;
 5'd10 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 6+8],{8{st_rx_end}} ,6'd0 } ;
 5'd11 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 5+8],{8{st_rx_end}} ,5'd0 } ;
 5'd12 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 4+8],{8{st_rx_end}} ,4'd0 } ;
 5'd13 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 3+8],{8{st_rx_end}} ,3'd0 } ;
 5'd14 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 2+8],{8{st_rx_end}} ,2'd0 } ;
 5'd15 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 1+8],{8{st_rx_end}} ,1'd0 } ;
 5'd16 : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 8],{8{st_rx_end}} } ;
 default : st_shift_end_reg_3 = { st_shift_end_reg_2[15+8: 8],{8{st_rx_end}} } ;
 endcase end
 assign st_shift_end_reg_4 = st_rx_valid&&st_rx_ready ? st_shift_end_reg_3 : st_shift_end_reg_2 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_end_reg <= 24'd0 ;
 end
 else if (st_rx_start) begin
 st_shift_end_reg <= {8'h00,8'h00,8'h00} ;
 end
 else if (fir_r_idle_st) begin
 st_shift_end_reg <= 'd0 ;
 end
 else if ( (st_rx_valid&&st_rx_ready) || (st_shift_en) ) begin
 st_shift_end_reg <= st_shift_end_reg_4 ;
 end
 end
 */ reg st_shift_full_flag ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_shift_full_flag <= 1'd0 ;
 end
 else if (st_shift_ccnt>6'd24) begin
 /* synthesis translate_off */ $display("%m Error buffer is full !!!!! cnt is %d fir_rx_cstate is %h \n ", st_shift_ccnt, fir_rx_cstate );
 /* synthesis translate_on */ st_shift_full_flag <= 1'd1 ;
 end
 else begin
 st_shift_full_flag <= 1'd0 ;
 end
 end
 /* synthesis translate_off */ reg [15:0] byte_wcnt_all ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 byte_wcnt_all <= 16'd0 ;
 end
 else if (st_rx_start) begin
 byte_wcnt_all <= 16'd8 - st_rx_offset ;
 end
 else if ( st_rx_valid && st_rx_ready ) begin
 byte_wcnt_all <= byte_wcnt_all + 16'd8 - st_rx_empty ;
 end
 end
 reg [15:0] byte_rcnt_all ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 byte_rcnt_all <= 16'd0 ;
 end
 else if (st_rx_start) begin
 byte_rcnt_all <= 16'd0 ;
 end
 else if ( st_shift_en ) begin
 byte_rcnt_all <= byte_rcnt_all + st_shift_scnt ;
 end
 end
 /* synthesis translate_on */ endmodule
 module sq_cut_ctrl ( clk , rst_n , params_filter_rst , sq00_cut_len_reg , sq01_cut_len_reg , sq02_cut_len_reg , sq03_cut_len_reg , sq04_cut_len_reg , sq05_cut_len_reg , sq06_cut_len_reg , sq07_cut_len_reg , sq08_cut_len_reg , sq09_cut_len_reg , sq10_cut_len_reg , sq11_cut_len_reg , sq12_cut_len_reg , sq13_cut_len_reg , sq14_cut_len_reg , sq15_cut_len_reg , sq16_cut_len_reg , sq17_cut_len_reg , sq18_cut_len_reg , sq19_cut_len_reg , sq20_cut_len_reg , sq21_cut_len_reg , sq22_cut_len_reg , sq23_cut_len_reg , sq24_cut_len_reg , sq25_cut_len_reg , sq26_cut_len_reg , sq27_cut_len_reg , sq28_cut_len_reg , sq29_cut_len_reg , sq30_cut_len_reg , sq31_cut_len_reg , fir_r_idle_st , fir_r_sqcuth_st , fir_r_vsync_st , fir_r_sqcut_st , fir_r_sqcut_end_st , fir_r_sqrcut_st , fir_r_sqrcut_end_st , fir_r_rjudge_st , sq_cut_len_reg , st_rx_cnt_reg , st_shift_ccnt , sync_len_byte , sync_fisrt_byte , sync_four_byte , sq_frame_flag , current_sqid_reg_flag , sq_cut_on , sq_cut_first_on , sub_sqcut_len_reg , st_rx_start , st_rx_offset , st_rx_end , st_rx_valid , st_rx_data , st_rx_empty , st_rx_cnt , first_sync_len_byte, tcp_sqmatch_flag , seq_err_flag , seq_err_flag_dly , tcp_payload_len , st_rx_start_dly , st_rx_offset_dly , st_rx_end_dly , st_rx_valid_dly , st_rx_data_dly , st_rx_empty_dly , st_rx_cnt_dly , first_sync_len_byte_dly, tcp_sqmatch_flag_dly , tcp_sqmatch_flag_1bit_dly , tcp_payload_len_dly , sq_cut_flag , sq_cut_reset , sq_cut_reset_pre , current_cut_done_sq00id_reg , current_cut_done_sq01id_reg , current_cut_done_sq02id_reg , current_cut_done_sq03id_reg , current_cut_done_sq04id_reg , current_cut_done_sq05id_reg , current_cut_done_sq06id_reg , current_cut_done_sq07id_reg , current_cut_done_sq08id_reg , current_cut_done_sq09id_reg , current_cut_done_sq10id_reg , current_cut_done_sq11id_reg , current_cut_done_sq12id_reg , current_cut_done_sq13id_reg , current_cut_done_sq14id_reg , current_cut_done_sq15id_reg , current_cut_done_sq16id_reg , current_cut_done_sq17id_reg , current_cut_done_sq18id_reg , current_cut_done_sq19id_reg , current_cut_done_sq20id_reg , current_cut_done_sq21id_reg , current_cut_done_sq22id_reg , current_cut_done_sq23id_reg , current_cut_done_sq24id_reg , current_cut_done_sq25id_reg , current_cut_done_sq26id_reg , current_cut_done_sq27id_reg , current_cut_done_sq28id_reg , current_cut_done_sq29id_reg , current_cut_done_sq30id_reg , current_cut_done_sq31id_reg , current_sqcut_done , current_sqid_reg , current_sqid_reg_vld );
 input clk ;
 input rst_n ;
 input params_filter_rst ;
 input [15:0] sq00_cut_len_reg ;
 input [15:0] sq01_cut_len_reg ;
 input [15:0] sq02_cut_len_reg ;
 input [15:0] sq03_cut_len_reg ;
 input [15:0] sq04_cut_len_reg ;
 input [15:0] sq05_cut_len_reg ;
 input [15:0] sq06_cut_len_reg ;
 input [15:0] sq07_cut_len_reg ;
 input [15:0] sq08_cut_len_reg ;
 input [15:0] sq09_cut_len_reg ;
 input [15:0] sq10_cut_len_reg ;
 input [15:0] sq11_cut_len_reg ;
 input [15:0] sq12_cut_len_reg ;
 input [15:0] sq13_cut_len_reg ;
 input [15:0] sq14_cut_len_reg ;
 input [15:0] sq15_cut_len_reg ;
 input [15:0] sq16_cut_len_reg ;
 input [15:0] sq17_cut_len_reg ;
 input [15:0] sq18_cut_len_reg ;
 input [15:0] sq19_cut_len_reg ;
 input [15:0] sq20_cut_len_reg ;
 input [15:0] sq21_cut_len_reg ;
 input [15:0] sq22_cut_len_reg ;
 input [15:0] sq23_cut_len_reg ;
 input [15:0] sq24_cut_len_reg ;
 input [15:0] sq25_cut_len_reg ;
 input [15:0] sq26_cut_len_reg ;
 input [15:0] sq27_cut_len_reg ;
 input [15:0] sq28_cut_len_reg ;
 input [15:0] sq29_cut_len_reg ;
 input [15:0] sq30_cut_len_reg ;
 input [15:0] sq31_cut_len_reg ;
 input fir_r_idle_st ;
 input fir_r_sqcuth_st ;
 input fir_r_vsync_st ;
 input fir_r_sqcut_st ;
 input fir_r_sqcut_end_st ;
 input fir_r_sqrcut_st ;
 input fir_r_sqrcut_end_st ;
 input fir_r_rjudge_st ;
 input [15:0] st_rx_cnt_reg ;
 input [ 5:0] st_shift_ccnt ;
 input [15:0] sync_len_byte ;
 input [ 15:0] sync_fisrt_byte ;
 input [ 31:0] sync_four_byte ;
 input sq_frame_flag ;
 input current_sqid_reg_flag ;
 output [31:0] sq_cut_on ;
 output [15:0] sub_sqcut_len_reg ;
 output [31:0] sq_cut_first_on ;
 input st_rx_start ;
 input [ 3:0] st_rx_offset ;
 input st_rx_end ;
 input st_rx_valid ;
 input [63:0] st_rx_data ;
 input [ 2:0] st_rx_empty ;
 input [15:0] st_rx_cnt ;
 input [15:0] first_sync_len_byte;
 input [31:0] tcp_sqmatch_flag ;
 input [31:0] seq_err_flag ;
 output seq_err_flag_dly ;
 input [15:0] tcp_payload_len ;
 output st_rx_start_dly ;
 output [ 3:0] st_rx_offset_dly ;
 output st_rx_end_dly ;
 output st_rx_valid_dly ;
 output [63:0] st_rx_data_dly ;
 output [ 2:0] st_rx_empty_dly ;
 output [15:0] st_rx_cnt_dly ;
 output [15:0] first_sync_len_byte_dly;
 output [31:0] tcp_sqmatch_flag_dly ;
 output tcp_sqmatch_flag_1bit_dly ;
 output [15:0] tcp_payload_len_dly ;
 output [31:0] sq_cut_flag ;
 input [31:0] sq_cut_reset ;
 output [31:0] sq_cut_reset_pre ;
 input [31:0] current_cut_done_sq00id_reg ;
 input [31:0] current_cut_done_sq01id_reg ;
 input [31:0] current_cut_done_sq02id_reg ;
 input [31:0] current_cut_done_sq03id_reg ;
 input [31:0] current_cut_done_sq04id_reg ;
 input [31:0] current_cut_done_sq05id_reg ;
 input [31:0] current_cut_done_sq06id_reg ;
 input [31:0] current_cut_done_sq07id_reg ;
 input [31:0] current_cut_done_sq08id_reg ;
 input [31:0] current_cut_done_sq09id_reg ;
 input [31:0] current_cut_done_sq10id_reg ;
 input [31:0] current_cut_done_sq11id_reg ;
 input [31:0] current_cut_done_sq12id_reg ;
 input [31:0] current_cut_done_sq13id_reg ;
 input [31:0] current_cut_done_sq14id_reg ;
 input [31:0] current_cut_done_sq15id_reg ;
 input [31:0] current_cut_done_sq16id_reg ;
 input [31:0] current_cut_done_sq17id_reg ;
 input [31:0] current_cut_done_sq18id_reg ;
 input [31:0] current_cut_done_sq19id_reg ;
 input [31:0] current_cut_done_sq20id_reg ;
 input [31:0] current_cut_done_sq21id_reg ;
 input [31:0] current_cut_done_sq22id_reg ;
 input [31:0] current_cut_done_sq23id_reg ;
 input [31:0] current_cut_done_sq24id_reg ;
 input [31:0] current_cut_done_sq25id_reg ;
 input [31:0] current_cut_done_sq26id_reg ;
 input [31:0] current_cut_done_sq27id_reg ;
 input [31:0] current_cut_done_sq28id_reg ;
 input [31:0] current_cut_done_sq29id_reg ;
 input [31:0] current_cut_done_sq30id_reg ;
 input [31:0] current_cut_done_sq31id_reg ;
 input [31:0] current_sqcut_done ;
 input [31:0] current_sqid_reg ;
 input current_sqid_reg_vld ;
 output [15:0] sq_cut_len_reg ;
 reg st_rx_start_dly ;
 reg [ 3:0] st_rx_offset_dly ;
 reg st_rx_end_dly ;
 reg st_rx_valid_dly ;
 reg [63:0] st_rx_data_dly ;
 reg [ 2:0] st_rx_empty_dly ;
 reg [15:0] st_rx_cnt_dly ;
 reg [15:0] first_sync_len_byte_dly;
 reg [31:0] tcp_sqmatch_flag_dly ;
 reg tcp_sqmatch_flag_1bit_dly ;
 reg [15:0] tcp_payload_len_dly ;
 reg seq_err_flag_dly ;
 reg [31:0] sq_cut_on ;
 reg [31:0] sq_cut_on_dly ;
 reg [31:0] sq_cut_reset_pre ;
 reg [31:0] sq_cut_flag ;
 reg [31:0] sq_cut_flag_dly ;
 reg [15:0] st_rq00_cut_cnt ;
 reg [15:0] st_rq01_cut_cnt ;
 reg [15:0] st_rq02_cut_cnt ;
 reg [15:0] st_rq03_cut_cnt ;
 reg [15:0] st_rq04_cut_cnt ;
 reg [15:0] st_rq05_cut_cnt ;
 reg [15:0] st_rq06_cut_cnt ;
 reg [15:0] st_rq07_cut_cnt ;
 reg [15:0] st_rq08_cut_cnt ;
 reg [15:0] st_rq09_cut_cnt ;
 reg [15:0] st_rq10_cut_cnt ;
 reg [15:0] st_rq11_cut_cnt ;
 reg [15:0] st_rq12_cut_cnt ;
 reg [15:0] st_rq13_cut_cnt ;
 reg [15:0] st_rq14_cut_cnt ;
 reg [15:0] st_rq15_cut_cnt ;
 reg [15:0] st_rq16_cut_cnt ;
 reg [15:0] st_rq17_cut_cnt ;
 reg [15:0] st_rq18_cut_cnt ;
 reg [15:0] st_rq19_cut_cnt ;
 reg [15:0] st_rq20_cut_cnt ;
 reg [15:0] st_rq21_cut_cnt ;
 reg [15:0] st_rq22_cut_cnt ;
 reg [15:0] st_rq23_cut_cnt ;
 reg [15:0] st_rq24_cut_cnt ;
 reg [15:0] st_rq25_cut_cnt ;
 reg [15:0] st_rq26_cut_cnt ;
 reg [15:0] st_rq27_cut_cnt ;
 reg [15:0] st_rq28_cut_cnt ;
 reg [15:0] st_rq29_cut_cnt ;
 reg [15:0] st_rq30_cut_cnt ;
 reg [15:0] st_rq31_cut_cnt ;
 reg [15:0] sq_cut_len_reg ;
 reg [31:0] current_cut_sq00id_reg ;
 reg [31:0] current_cut_sq01id_reg ;
 reg [31:0] current_cut_sq02id_reg ;
 reg [31:0] current_cut_sq03id_reg ;
 reg [31:0] current_cut_sq04id_reg ;
 reg [31:0] current_cut_sq05id_reg ;
 reg [31:0] current_cut_sq06id_reg ;
 reg [31:0] current_cut_sq07id_reg ;
 reg [31:0] current_cut_sq08id_reg ;
 reg [31:0] current_cut_sq09id_reg ;
 reg [31:0] current_cut_sq10id_reg ;
 reg [31:0] current_cut_sq11id_reg ;
 reg [31:0] current_cut_sq12id_reg ;
 reg [31:0] current_cut_sq13id_reg ;
 reg [31:0] current_cut_sq14id_reg ;
 reg [31:0] current_cut_sq15id_reg ;
 reg [31:0] current_cut_sq16id_reg ;
 reg [31:0] current_cut_sq17id_reg ;
 reg [31:0] current_cut_sq18id_reg ;
 reg [31:0] current_cut_sq19id_reg ;
 reg [31:0] current_cut_sq20id_reg ;
 reg [31:0] current_cut_sq21id_reg ;
 reg [31:0] current_cut_sq22id_reg ;
 reg [31:0] current_cut_sq23id_reg ;
 reg [31:0] current_cut_sq24id_reg ;
 reg [31:0] current_cut_sq25id_reg ;
 reg [31:0] current_cut_sq26id_reg ;
 reg [31:0] current_cut_sq27id_reg ;
 reg [31:0] current_cut_sq28id_reg ;
 reg [31:0] current_cut_sq29id_reg ;
 reg [31:0] current_cut_sq30id_reg ;
 reg [31:0] current_cut_sq31id_reg ;
 reg [31:0] current_cut_done_sqid_reg ;
 reg [31:0] sq_cut_first_on ;
 reg [15:0] st_rq_cut_cnt ;
 wire [15:0] sub_sqcut_len_reg = (sq_cut_len_reg - st_rq_cut_cnt) ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rq00_cut_cnt <= 16'd0 ;
 st_rq01_cut_cnt <= 16'd0 ;
 st_rq02_cut_cnt <= 16'd0 ;
 st_rq03_cut_cnt <= 16'd0 ;
 st_rq04_cut_cnt <= 16'd0 ;
 st_rq05_cut_cnt <= 16'd0 ;
 st_rq06_cut_cnt <= 16'd0 ;
 st_rq07_cut_cnt <= 16'd0 ;
 st_rq08_cut_cnt <= 16'd0 ;
 st_rq09_cut_cnt <= 16'd0 ;
 st_rq10_cut_cnt <= 16'd0 ;
 st_rq11_cut_cnt <= 16'd0 ;
 st_rq12_cut_cnt <= 16'd0 ;
 st_rq13_cut_cnt <= 16'd0 ;
 st_rq14_cut_cnt <= 16'd0 ;
 st_rq15_cut_cnt <= 16'd0 ;
 st_rq16_cut_cnt <= 16'd0 ;
 st_rq17_cut_cnt <= 16'd0 ;
 st_rq18_cut_cnt <= 16'd0 ;
 st_rq19_cut_cnt <= 16'd0 ;
 st_rq20_cut_cnt <= 16'd0 ;
 st_rq21_cut_cnt <= 16'd0 ;
 st_rq22_cut_cnt <= 16'd0 ;
 st_rq23_cut_cnt <= 16'd0 ;
 st_rq24_cut_cnt <= 16'd0 ;
 st_rq25_cut_cnt <= 16'd0 ;
 st_rq26_cut_cnt <= 16'd0 ;
 st_rq27_cut_cnt <= 16'd0 ;
 st_rq28_cut_cnt <= 16'd0 ;
 st_rq29_cut_cnt <= 16'd0 ;
 st_rq30_cut_cnt <= 16'd0 ;
 st_rq31_cut_cnt <= 16'd0 ;
 end
 else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 if (~sq_cut_on_dly[ 0] ) st_rq00_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 1] && ( sq_cut_on_dly[ 0]) ) st_rq01_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 2] && (&sq_cut_on_dly[ 1:0]) ) st_rq02_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 3] && (&sq_cut_on_dly[ 2:0]) ) st_rq03_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 4] && (&sq_cut_on_dly[ 3:0]) ) st_rq04_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 5] && (&sq_cut_on_dly[ 4:0]) ) st_rq05_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 6] && (&sq_cut_on_dly[ 5:0]) ) st_rq06_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 7] && (&sq_cut_on_dly[ 6:0]) ) st_rq07_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 8] && (&sq_cut_on_dly[ 7:0]) ) st_rq08_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[ 9] && (&sq_cut_on_dly[ 8:0]) ) st_rq09_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[10] && (&sq_cut_on_dly[ 9:0]) ) st_rq10_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[11] && (&sq_cut_on_dly[10:0]) ) st_rq11_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[12] && (&sq_cut_on_dly[11:0]) ) st_rq12_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[13] && (&sq_cut_on_dly[12:0]) ) st_rq13_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[14] && (&sq_cut_on_dly[13:0]) ) st_rq14_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[15] && (&sq_cut_on_dly[14:0]) ) st_rq15_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[16] && (&sq_cut_on_dly[15:0]) ) st_rq16_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[17] && (&sq_cut_on_dly[16:0]) ) st_rq17_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[18] && (&sq_cut_on_dly[17:0]) ) st_rq18_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[19] && (&sq_cut_on_dly[18:0]) ) st_rq19_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[20] && (&sq_cut_on_dly[19:0]) ) st_rq20_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[21] && (&sq_cut_on_dly[20:0]) ) st_rq21_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[22] && (&sq_cut_on_dly[21:0]) ) st_rq22_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[23] && (&sq_cut_on_dly[22:0]) ) st_rq23_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[24] && (&sq_cut_on_dly[23:0]) ) st_rq24_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[25] && (&sq_cut_on_dly[24:0]) ) st_rq25_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[26] && (&sq_cut_on_dly[25:0]) ) st_rq26_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[27] && (&sq_cut_on_dly[26:0]) ) st_rq27_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[28] && (&sq_cut_on_dly[27:0]) ) st_rq28_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[29] && (&sq_cut_on_dly[28:0]) ) st_rq29_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[30] && (&sq_cut_on_dly[29:0]) ) st_rq30_cut_cnt <= st_rx_cnt_reg ;
 if (~sq_cut_on_dly[31] && (&sq_cut_on_dly[30:0]) ) st_rq31_cut_cnt <= st_rx_cnt_reg ;
 end
 else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) && sq_frame_flag && current_sqid_reg_flag ) begin
 if (~sq_cut_on[ 0] ) st_rq00_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ) st_rq01_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ) st_rq02_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ) st_rq03_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ) st_rq04_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ) st_rq05_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ) st_rq06_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ) st_rq07_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ) st_rq08_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ) st_rq09_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ) st_rq10_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[11] && (&sq_cut_on[10:0]) ) st_rq11_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[12] && (&sq_cut_on[11:0]) ) st_rq12_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[13] && (&sq_cut_on[12:0]) ) st_rq13_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[14] && (&sq_cut_on[13:0]) ) st_rq14_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[15] && (&sq_cut_on[14:0]) ) st_rq15_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[16] && (&sq_cut_on[15:0]) ) st_rq16_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[17] && (&sq_cut_on[16:0]) ) st_rq17_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[18] && (&sq_cut_on[17:0]) ) st_rq18_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[19] && (&sq_cut_on[18:0]) ) st_rq19_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[20] && (&sq_cut_on[19:0]) ) st_rq20_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[21] && (&sq_cut_on[20:0]) ) st_rq21_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[22] && (&sq_cut_on[21:0]) ) st_rq22_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[23] && (&sq_cut_on[22:0]) ) st_rq23_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[24] && (&sq_cut_on[23:0]) ) st_rq24_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[25] && (&sq_cut_on[24:0]) ) st_rq25_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[26] && (&sq_cut_on[25:0]) ) st_rq26_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[27] && (&sq_cut_on[26:0]) ) st_rq27_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[28] && (&sq_cut_on[27:0]) ) st_rq28_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[29] && (&sq_cut_on[28:0]) ) st_rq29_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[30] && (&sq_cut_on[29:0]) ) st_rq30_cut_cnt <= 16'd8 ;
 if (~sq_cut_on[31] && (&sq_cut_on[30:0]) ) st_rq31_cut_cnt <= 16'd8 ;
 end
 else if ( (fir_r_sqcut_st ) && (st_shift_ccnt>=6'd8) ) begin
 if (sq_cut_first_on[ 0] ) st_rq00_cut_cnt <= st_rq00_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 1] ) st_rq01_cut_cnt <= st_rq01_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 2] ) st_rq02_cut_cnt <= st_rq02_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 3] ) st_rq03_cut_cnt <= st_rq03_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 4] ) st_rq04_cut_cnt <= st_rq04_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 5] ) st_rq05_cut_cnt <= st_rq05_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 6] ) st_rq06_cut_cnt <= st_rq06_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 7] ) st_rq07_cut_cnt <= st_rq07_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 8] ) st_rq08_cut_cnt <= st_rq08_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[ 9] ) st_rq09_cut_cnt <= st_rq09_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[10] ) st_rq10_cut_cnt <= st_rq10_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[11] ) st_rq11_cut_cnt <= st_rq11_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[12] ) st_rq12_cut_cnt <= st_rq12_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[13] ) st_rq13_cut_cnt <= st_rq13_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[14] ) st_rq14_cut_cnt <= st_rq14_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[15] ) st_rq15_cut_cnt <= st_rq15_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[16] ) st_rq16_cut_cnt <= st_rq16_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[17] ) st_rq17_cut_cnt <= st_rq17_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[18] ) st_rq18_cut_cnt <= st_rq18_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[19] ) st_rq19_cut_cnt <= st_rq19_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[20] ) st_rq20_cut_cnt <= st_rq20_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[21] ) st_rq21_cut_cnt <= st_rq21_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[22] ) st_rq22_cut_cnt <= st_rq22_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[23] ) st_rq23_cut_cnt <= st_rq23_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[24] ) st_rq24_cut_cnt <= st_rq24_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[25] ) st_rq25_cut_cnt <= st_rq25_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[26] ) st_rq26_cut_cnt <= st_rq26_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[27] ) st_rq27_cut_cnt <= st_rq27_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[28] ) st_rq28_cut_cnt <= st_rq28_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[29] ) st_rq29_cut_cnt <= st_rq29_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[30] ) st_rq30_cut_cnt <= st_rq30_cut_cnt + 16'd8 ;
 if (sq_cut_first_on[31] ) st_rq31_cut_cnt <= st_rq31_cut_cnt + 16'd8 ;
 end
 else if ((fir_r_sqcut_end_st ) && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
 if (sq_cut_first_on[ 0] ) st_rq00_cut_cnt <= st_rq00_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 1] ) st_rq01_cut_cnt <= st_rq01_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 2] ) st_rq02_cut_cnt <= st_rq02_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 3] ) st_rq03_cut_cnt <= st_rq03_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 4] ) st_rq04_cut_cnt <= st_rq04_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 5] ) st_rq05_cut_cnt <= st_rq05_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 6] ) st_rq06_cut_cnt <= st_rq06_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 7] ) st_rq07_cut_cnt <= st_rq07_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 8] ) st_rq08_cut_cnt <= st_rq08_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[ 9] ) st_rq09_cut_cnt <= st_rq09_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[10] ) st_rq10_cut_cnt <= st_rq10_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[11] ) st_rq11_cut_cnt <= st_rq11_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[12] ) st_rq12_cut_cnt <= st_rq12_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[13] ) st_rq13_cut_cnt <= st_rq13_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[14] ) st_rq14_cut_cnt <= st_rq14_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[15] ) st_rq15_cut_cnt <= st_rq15_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[16] ) st_rq16_cut_cnt <= st_rq16_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[17] ) st_rq17_cut_cnt <= st_rq17_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[18] ) st_rq18_cut_cnt <= st_rq18_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[19] ) st_rq19_cut_cnt <= st_rq19_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[20] ) st_rq20_cut_cnt <= st_rq20_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[21] ) st_rq21_cut_cnt <= st_rq21_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[22] ) st_rq22_cut_cnt <= st_rq22_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[23] ) st_rq23_cut_cnt <= st_rq23_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[24] ) st_rq24_cut_cnt <= st_rq24_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[25] ) st_rq25_cut_cnt <= st_rq25_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[26] ) st_rq26_cut_cnt <= st_rq26_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[27] ) st_rq27_cut_cnt <= st_rq27_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[28] ) st_rq28_cut_cnt <= st_rq28_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[29] ) st_rq29_cut_cnt <= st_rq29_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[30] ) st_rq30_cut_cnt <= st_rq30_cut_cnt + st_rx_cnt_reg ;
 if (sq_cut_first_on[31] ) st_rq31_cut_cnt <= st_rq31_cut_cnt + st_rx_cnt_reg ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rq_cut_cnt <= 16'd0 ;
 end
 else if ( st_rx_start&&st_rx_valid&&(|tcp_sqmatch_flag) ) begin
 case (tcp_sqmatch_flag) 32'h0000_0001: st_rq_cut_cnt <= st_rq00_cut_cnt ;
 32'h0000_0002: st_rq_cut_cnt <= st_rq01_cut_cnt ;
 32'h0000_0004: st_rq_cut_cnt <= st_rq02_cut_cnt ;
 32'h0000_0008: st_rq_cut_cnt <= st_rq03_cut_cnt ;
 32'h0000_0010: st_rq_cut_cnt <= st_rq04_cut_cnt ;
 32'h0000_0020: st_rq_cut_cnt <= st_rq05_cut_cnt ;
 32'h0000_0040: st_rq_cut_cnt <= st_rq06_cut_cnt ;
 32'h0000_0080: st_rq_cut_cnt <= st_rq07_cut_cnt ;
 32'h0000_0100: st_rq_cut_cnt <= st_rq08_cut_cnt ;
 32'h0000_0200: st_rq_cut_cnt <= st_rq09_cut_cnt ;
 32'h0000_0400: st_rq_cut_cnt <= st_rq10_cut_cnt ;
 32'h0000_0800: st_rq_cut_cnt <= st_rq11_cut_cnt ;
 32'h0000_1000: st_rq_cut_cnt <= st_rq12_cut_cnt ;
 32'h0000_2000: st_rq_cut_cnt <= st_rq13_cut_cnt ;
 32'h0000_4000: st_rq_cut_cnt <= st_rq14_cut_cnt ;
 32'h0000_8000: st_rq_cut_cnt <= st_rq15_cut_cnt ;
 32'h0001_0000: st_rq_cut_cnt <= st_rq16_cut_cnt ;
 32'h0002_0000: st_rq_cut_cnt <= st_rq17_cut_cnt ;
 32'h0004_0000: st_rq_cut_cnt <= st_rq18_cut_cnt ;
 32'h0008_0000: st_rq_cut_cnt <= st_rq19_cut_cnt ;
 32'h0010_0000: st_rq_cut_cnt <= st_rq20_cut_cnt ;
 32'h0020_0000: st_rq_cut_cnt <= st_rq21_cut_cnt ;
 32'h0040_0000: st_rq_cut_cnt <= st_rq22_cut_cnt ;
 32'h0080_0000: st_rq_cut_cnt <= st_rq23_cut_cnt ;
 32'h0100_0000: st_rq_cut_cnt <= st_rq24_cut_cnt ;
 32'h0200_0000: st_rq_cut_cnt <= st_rq25_cut_cnt ;
 32'h0400_0000: st_rq_cut_cnt <= st_rq26_cut_cnt ;
 32'h0800_0000: st_rq_cut_cnt <= st_rq27_cut_cnt ;
 32'h1000_0000: st_rq_cut_cnt <= st_rq28_cut_cnt ;
 32'h2000_0000: st_rq_cut_cnt <= st_rq29_cut_cnt ;
 32'h4000_0000: st_rq_cut_cnt <= st_rq30_cut_cnt ;
 default : st_rq_cut_cnt <= st_rq31_cut_cnt ;
 endcase end
 else if (fir_r_sqrcut_st && (st_shift_ccnt>=16'd8) ) begin
 st_rq_cut_cnt <= st_rq_cut_cnt + 16'd8 ;
 end
 else if (fir_r_sqrcut_end_st && (st_shift_ccnt>=sub_sqcut_len_reg) ) begin
 st_rq_cut_cnt <= st_rq_cut_cnt + sub_sqcut_len_reg ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_len_reg <= 16'd0 ;
 end
 else if ( |tcp_sqmatch_flag ) begin
 case (tcp_sqmatch_flag) 32'h0000_0001: sq_cut_len_reg <= sq00_cut_len_reg ;
 32'h0000_0002: sq_cut_len_reg <= sq01_cut_len_reg ;
 32'h0000_0004: sq_cut_len_reg <= sq02_cut_len_reg ;
 32'h0000_0008: sq_cut_len_reg <= sq03_cut_len_reg ;
 32'h0000_0010: sq_cut_len_reg <= sq04_cut_len_reg ;
 32'h0000_0020: sq_cut_len_reg <= sq05_cut_len_reg ;
 32'h0000_0040: sq_cut_len_reg <= sq06_cut_len_reg ;
 32'h0000_0080: sq_cut_len_reg <= sq07_cut_len_reg ;
 32'h0000_0100: sq_cut_len_reg <= sq08_cut_len_reg ;
 32'h0000_0200: sq_cut_len_reg <= sq09_cut_len_reg ;
 32'h0000_0400: sq_cut_len_reg <= sq10_cut_len_reg ;
 32'h0000_0800: sq_cut_len_reg <= sq11_cut_len_reg ;
 32'h0000_1000: sq_cut_len_reg <= sq12_cut_len_reg ;
 32'h0000_2000: sq_cut_len_reg <= sq13_cut_len_reg ;
 32'h0000_4000: sq_cut_len_reg <= sq14_cut_len_reg ;
 32'h0000_8000: sq_cut_len_reg <= sq15_cut_len_reg ;
 32'h0001_0000: sq_cut_len_reg <= sq16_cut_len_reg ;
 32'h0002_0000: sq_cut_len_reg <= sq17_cut_len_reg ;
 32'h0004_0000: sq_cut_len_reg <= sq18_cut_len_reg ;
 32'h0008_0000: sq_cut_len_reg <= sq19_cut_len_reg ;
 32'h0010_0000: sq_cut_len_reg <= sq20_cut_len_reg ;
 32'h0020_0000: sq_cut_len_reg <= sq21_cut_len_reg ;
 32'h0040_0000: sq_cut_len_reg <= sq22_cut_len_reg ;
 32'h0080_0000: sq_cut_len_reg <= sq23_cut_len_reg ;
 32'h0100_0000: sq_cut_len_reg <= sq24_cut_len_reg ;
 32'h0200_0000: sq_cut_len_reg <= sq25_cut_len_reg ;
 32'h0400_0000: sq_cut_len_reg <= sq26_cut_len_reg ;
 32'h0800_0000: sq_cut_len_reg <= sq27_cut_len_reg ;
 32'h1000_0000: sq_cut_len_reg <= sq28_cut_len_reg ;
 32'h2000_0000: sq_cut_len_reg <= sq29_cut_len_reg ;
 32'h4000_0000: sq_cut_len_reg <= sq30_cut_len_reg ;
 default : sq_cut_len_reg <= sq31_cut_len_reg ;
 endcase end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 st_rx_start_dly <= 1'd0 ;
 st_rx_offset_dly <= 4'd0 ;
 st_rx_end_dly <= 1'd0 ;
 st_rx_valid_dly <= 1'd0 ;
 st_rx_data_dly <= 64'd0 ;
 st_rx_cnt_dly <= 16'd0 ;
 first_sync_len_byte_dly <= 16'd0 ;
 tcp_sqmatch_flag_dly <= 32'd0 ;
 tcp_sqmatch_flag_1bit_dly <= 1'd0 ;
 tcp_payload_len_dly <= 32'd0 ;
 seq_err_flag_dly <= 1'd0 ;
 st_rx_empty_dly <= 'd0 ;
 end
 else begin
 st_rx_start_dly <= st_rx_start && st_rx_valid ;
 st_rx_offset_dly <= st_rx_valid ? st_rx_offset : st_rx_offset_dly ;
 st_rx_end_dly <= st_rx_end && st_rx_valid ;
 st_rx_valid_dly <= st_rx_valid ;
 st_rx_data_dly <= st_rx_valid ? st_rx_data : st_rx_data_dly ;
 st_rx_empty_dly <= st_rx_valid ? st_rx_empty : st_rx_empty_dly ;
 st_rx_cnt_dly <= st_rx_valid ? st_rx_cnt : st_rx_cnt_dly ;
 first_sync_len_byte_dly <= st_rx_start && st_rx_valid ? first_sync_len_byte : first_sync_len_byte_dly ;
 tcp_sqmatch_flag_dly <= st_rx_start && st_rx_valid ? tcp_sqmatch_flag : tcp_sqmatch_flag_dly ;
 tcp_sqmatch_flag_1bit_dly <= st_rx_start && st_rx_valid ? (|tcp_sqmatch_flag) : tcp_sqmatch_flag_1bit_dly ;
 tcp_payload_len_dly <= st_rx_start && st_rx_valid ? tcp_payload_len : tcp_payload_len_dly ;
 seq_err_flag_dly <= st_rx_start && st_rx_valid ? (|seq_err_flag) : seq_err_flag_dly ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_first_on <= 32'd0 ;
 end
 else if ( fir_r_vsync_st && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && (st_shift_ccnt>=6'd8) && sq_frame_flag && current_sqid_reg_flag && (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 sq_cut_first_on[ 0] <= ~sq_cut_on[ 0] ;
 sq_cut_first_on[ 1] <= ~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ;
 sq_cut_first_on[ 2] <= ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ;
 sq_cut_first_on[ 3] <= ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ;
 sq_cut_first_on[ 4] <= ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ;
 sq_cut_first_on[ 5] <= ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ;
 sq_cut_first_on[ 6] <= ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ;
 sq_cut_first_on[ 7] <= ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ;
 sq_cut_first_on[ 8] <= ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ;
 sq_cut_first_on[ 9] <= ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ;
 sq_cut_first_on[10] <= ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ;
 sq_cut_first_on[11] <= ~sq_cut_on[11] && (&sq_cut_on[10:0]) ;
 sq_cut_first_on[12] <= ~sq_cut_on[12] && (&sq_cut_on[11:0]) ;
 sq_cut_first_on[13] <= ~sq_cut_on[13] && (&sq_cut_on[12:0]) ;
 sq_cut_first_on[14] <= ~sq_cut_on[14] && (&sq_cut_on[13:0]) ;
 sq_cut_first_on[15] <= ~sq_cut_on[15] && (&sq_cut_on[14:0]) ;
 sq_cut_first_on[16] <= ~sq_cut_on[16] && (&sq_cut_on[15:0]) ;
 sq_cut_first_on[17] <= ~sq_cut_on[17] && (&sq_cut_on[16:0]) ;
 sq_cut_first_on[18] <= ~sq_cut_on[18] && (&sq_cut_on[17:0]) ;
 sq_cut_first_on[19] <= ~sq_cut_on[19] && (&sq_cut_on[18:0]) ;
 sq_cut_first_on[20] <= ~sq_cut_on[20] && (&sq_cut_on[19:0]) ;
 sq_cut_first_on[21] <= ~sq_cut_on[21] && (&sq_cut_on[20:0]) ;
 sq_cut_first_on[22] <= ~sq_cut_on[22] && (&sq_cut_on[21:0]) ;
 sq_cut_first_on[23] <= ~sq_cut_on[23] && (&sq_cut_on[22:0]) ;
 sq_cut_first_on[24] <= ~sq_cut_on[24] && (&sq_cut_on[23:0]) ;
 sq_cut_first_on[25] <= ~sq_cut_on[25] && (&sq_cut_on[24:0]) ;
 sq_cut_first_on[26] <= ~sq_cut_on[26] && (&sq_cut_on[25:0]) ;
 sq_cut_first_on[27] <= ~sq_cut_on[27] && (&sq_cut_on[26:0]) ;
 sq_cut_first_on[28] <= ~sq_cut_on[28] && (&sq_cut_on[27:0]) ;
 sq_cut_first_on[29] <= ~sq_cut_on[29] && (&sq_cut_on[28:0]) ;
 sq_cut_first_on[30] <= ~sq_cut_on[30] && (&sq_cut_on[29:0]) ;
 sq_cut_first_on[31] <= ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;
 end
 else if (fir_r_rjudge_st && sq_frame_flag && current_sqid_reg_flag && (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ) begin
 sq_cut_first_on[ 0] <= ~sq_cut_on[ 0] ;
 sq_cut_first_on[ 1] <= ~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ;
 sq_cut_first_on[ 2] <= ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ;
 sq_cut_first_on[ 3] <= ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ;
 sq_cut_first_on[ 4] <= ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ;
 sq_cut_first_on[ 5] <= ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ;
 sq_cut_first_on[ 6] <= ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ;
 sq_cut_first_on[ 7] <= ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ;
 sq_cut_first_on[ 8] <= ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ;
 sq_cut_first_on[ 9] <= ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ;
 sq_cut_first_on[10] <= ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ;
 sq_cut_first_on[11] <= ~sq_cut_on[11] && (&sq_cut_on[10:0]) ;
 sq_cut_first_on[12] <= ~sq_cut_on[12] && (&sq_cut_on[11:0]) ;
 sq_cut_first_on[13] <= ~sq_cut_on[13] && (&sq_cut_on[12:0]) ;
 sq_cut_first_on[14] <= ~sq_cut_on[14] && (&sq_cut_on[13:0]) ;
 sq_cut_first_on[15] <= ~sq_cut_on[15] && (&sq_cut_on[14:0]) ;
 sq_cut_first_on[16] <= ~sq_cut_on[16] && (&sq_cut_on[15:0]) ;
 sq_cut_first_on[17] <= ~sq_cut_on[17] && (&sq_cut_on[16:0]) ;
 sq_cut_first_on[18] <= ~sq_cut_on[18] && (&sq_cut_on[17:0]) ;
 sq_cut_first_on[19] <= ~sq_cut_on[19] && (&sq_cut_on[18:0]) ;
 sq_cut_first_on[20] <= ~sq_cut_on[20] && (&sq_cut_on[19:0]) ;
 sq_cut_first_on[21] <= ~sq_cut_on[21] && (&sq_cut_on[20:0]) ;
 sq_cut_first_on[22] <= ~sq_cut_on[22] && (&sq_cut_on[21:0]) ;
 sq_cut_first_on[23] <= ~sq_cut_on[23] && (&sq_cut_on[22:0]) ;
 sq_cut_first_on[24] <= ~sq_cut_on[24] && (&sq_cut_on[23:0]) ;
 sq_cut_first_on[25] <= ~sq_cut_on[25] && (&sq_cut_on[24:0]) ;
 sq_cut_first_on[26] <= ~sq_cut_on[26] && (&sq_cut_on[25:0]) ;
 sq_cut_first_on[27] <= ~sq_cut_on[27] && (&sq_cut_on[26:0]) ;
 sq_cut_first_on[28] <= ~sq_cut_on[28] && (&sq_cut_on[27:0]) ;
 sq_cut_first_on[29] <= ~sq_cut_on[29] && (&sq_cut_on[28:0]) ;
 sq_cut_first_on[30] <= ~sq_cut_on[30] && (&sq_cut_on[29:0]) ;
 sq_cut_first_on[31] <= ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;
 end
 else if (fir_r_idle_st) begin
 sq_cut_first_on <= 32'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_flag <= 32'd0 ;
 end
 else if ( fir_r_vsync_st && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && (st_shift_ccnt>=6'd8) && sq_frame_flag && current_sqid_reg_flag && (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 sq_cut_flag[ 0] <= ~sq_cut_on[ 0] ;
 sq_cut_flag[ 1] <= ~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ;
 sq_cut_flag[ 2] <= ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ;
 sq_cut_flag[ 3] <= ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ;
 sq_cut_flag[ 4] <= ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ;
 sq_cut_flag[ 5] <= ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ;
 sq_cut_flag[ 6] <= ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ;
 sq_cut_flag[ 7] <= ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ;
 sq_cut_flag[ 8] <= ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ;
 sq_cut_flag[ 9] <= ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ;
 sq_cut_flag[10] <= ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ;
 sq_cut_flag[11] <= ~sq_cut_on[11] && (&sq_cut_on[10:0]) ;
 sq_cut_flag[12] <= ~sq_cut_on[12] && (&sq_cut_on[11:0]) ;
 sq_cut_flag[13] <= ~sq_cut_on[13] && (&sq_cut_on[12:0]) ;
 sq_cut_flag[14] <= ~sq_cut_on[14] && (&sq_cut_on[13:0]) ;
 sq_cut_flag[15] <= ~sq_cut_on[15] && (&sq_cut_on[14:0]) ;
 sq_cut_flag[16] <= ~sq_cut_on[16] && (&sq_cut_on[15:0]) ;
 sq_cut_flag[17] <= ~sq_cut_on[17] && (&sq_cut_on[16:0]) ;
 sq_cut_flag[18] <= ~sq_cut_on[18] && (&sq_cut_on[17:0]) ;
 sq_cut_flag[19] <= ~sq_cut_on[19] && (&sq_cut_on[18:0]) ;
 sq_cut_flag[20] <= ~sq_cut_on[20] && (&sq_cut_on[19:0]) ;
 sq_cut_flag[21] <= ~sq_cut_on[21] && (&sq_cut_on[20:0]) ;
 sq_cut_flag[22] <= ~sq_cut_on[22] && (&sq_cut_on[21:0]) ;
 sq_cut_flag[23] <= ~sq_cut_on[23] && (&sq_cut_on[22:0]) ;
 sq_cut_flag[24] <= ~sq_cut_on[24] && (&sq_cut_on[23:0]) ;
 sq_cut_flag[25] <= ~sq_cut_on[25] && (&sq_cut_on[24:0]) ;
 sq_cut_flag[26] <= ~sq_cut_on[26] && (&sq_cut_on[25:0]) ;
 sq_cut_flag[27] <= ~sq_cut_on[27] && (&sq_cut_on[26:0]) ;
 sq_cut_flag[28] <= ~sq_cut_on[28] && (&sq_cut_on[27:0]) ;
 sq_cut_flag[29] <= ~sq_cut_on[29] && (&sq_cut_on[28:0]) ;
 sq_cut_flag[30] <= ~sq_cut_on[30] && (&sq_cut_on[29:0]) ;
 sq_cut_flag[31] <= ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;
 end
 else if (fir_r_rjudge_st && sq_frame_flag && current_sqid_reg_flag && (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ) begin
 sq_cut_flag[ 0] <= ~sq_cut_on[ 0] ;
 sq_cut_flag[ 1] <= ~sq_cut_on[ 1] && ( sq_cut_on[ 0]) ;
 sq_cut_flag[ 2] <= ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ;
 sq_cut_flag[ 3] <= ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ;
 sq_cut_flag[ 4] <= ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ;
 sq_cut_flag[ 5] <= ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ;
 sq_cut_flag[ 6] <= ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ;
 sq_cut_flag[ 7] <= ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ;
 sq_cut_flag[ 8] <= ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ;
 sq_cut_flag[ 9] <= ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ;
 sq_cut_flag[10] <= ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ;
 sq_cut_flag[11] <= ~sq_cut_on[11] && (&sq_cut_on[10:0]) ;
 sq_cut_flag[12] <= ~sq_cut_on[12] && (&sq_cut_on[11:0]) ;
 sq_cut_flag[13] <= ~sq_cut_on[13] && (&sq_cut_on[12:0]) ;
 sq_cut_flag[14] <= ~sq_cut_on[14] && (&sq_cut_on[13:0]) ;
 sq_cut_flag[15] <= ~sq_cut_on[15] && (&sq_cut_on[14:0]) ;
 sq_cut_flag[16] <= ~sq_cut_on[16] && (&sq_cut_on[15:0]) ;
 sq_cut_flag[17] <= ~sq_cut_on[17] && (&sq_cut_on[16:0]) ;
 sq_cut_flag[18] <= ~sq_cut_on[18] && (&sq_cut_on[17:0]) ;
 sq_cut_flag[19] <= ~sq_cut_on[19] && (&sq_cut_on[18:0]) ;
 sq_cut_flag[20] <= ~sq_cut_on[20] && (&sq_cut_on[19:0]) ;
 sq_cut_flag[21] <= ~sq_cut_on[21] && (&sq_cut_on[20:0]) ;
 sq_cut_flag[22] <= ~sq_cut_on[22] && (&sq_cut_on[21:0]) ;
 sq_cut_flag[23] <= ~sq_cut_on[23] && (&sq_cut_on[22:0]) ;
 sq_cut_flag[24] <= ~sq_cut_on[24] && (&sq_cut_on[23:0]) ;
 sq_cut_flag[25] <= ~sq_cut_on[25] && (&sq_cut_on[24:0]) ;
 sq_cut_flag[26] <= ~sq_cut_on[26] && (&sq_cut_on[25:0]) ;
 sq_cut_flag[27] <= ~sq_cut_on[27] && (&sq_cut_on[26:0]) ;
 sq_cut_flag[28] <= ~sq_cut_on[28] && (&sq_cut_on[27:0]) ;
 sq_cut_flag[29] <= ~sq_cut_on[29] && (&sq_cut_on[28:0]) ;
 sq_cut_flag[30] <= ~sq_cut_on[30] && (&sq_cut_on[29:0]) ;
 sq_cut_flag[31] <= ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;
 end
 else begin
 sq_cut_flag <= 32'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_flag_dly <= 32'd0 ;
 end
 else if ( fir_r_vsync_st && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && (st_shift_ccnt>=6'd8) && sq_frame_flag && current_sqid_reg_flag && (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c) ) begin
 sq_cut_flag_dly[ 0] <= ~sq_cut_on_dly[ 0] ;
 sq_cut_flag_dly[ 1] <= ~sq_cut_on_dly[ 1] && ( sq_cut_on_dly[ 0]) ;
 sq_cut_flag_dly[ 2] <= ~sq_cut_on_dly[ 2] && (&sq_cut_on_dly[ 1:0]) ;
 sq_cut_flag_dly[ 3] <= ~sq_cut_on_dly[ 3] && (&sq_cut_on_dly[ 2:0]) ;
 sq_cut_flag_dly[ 4] <= ~sq_cut_on_dly[ 4] && (&sq_cut_on_dly[ 3:0]) ;
 sq_cut_flag_dly[ 5] <= ~sq_cut_on_dly[ 5] && (&sq_cut_on_dly[ 4:0]) ;
 sq_cut_flag_dly[ 6] <= ~sq_cut_on_dly[ 6] && (&sq_cut_on_dly[ 5:0]) ;
 sq_cut_flag_dly[ 7] <= ~sq_cut_on_dly[ 7] && (&sq_cut_on_dly[ 6:0]) ;
 sq_cut_flag_dly[ 8] <= ~sq_cut_on_dly[ 8] && (&sq_cut_on_dly[ 7:0]) ;
 sq_cut_flag_dly[ 9] <= ~sq_cut_on_dly[ 9] && (&sq_cut_on_dly[ 8:0]) ;
 sq_cut_flag_dly[10] <= ~sq_cut_on_dly[10] && (&sq_cut_on_dly[ 9:0]) ;
 sq_cut_flag_dly[11] <= ~sq_cut_on_dly[11] && (&sq_cut_on_dly[10:0]) ;
 sq_cut_flag_dly[12] <= ~sq_cut_on_dly[12] && (&sq_cut_on_dly[11:0]) ;
 sq_cut_flag_dly[13] <= ~sq_cut_on_dly[13] && (&sq_cut_on_dly[12:0]) ;
 sq_cut_flag_dly[14] <= ~sq_cut_on_dly[14] && (&sq_cut_on_dly[13:0]) ;
 sq_cut_flag_dly[15] <= ~sq_cut_on_dly[15] && (&sq_cut_on_dly[14:0]) ;
 sq_cut_flag_dly[16] <= ~sq_cut_on_dly[16] && (&sq_cut_on_dly[15:0]) ;
 sq_cut_flag_dly[17] <= ~sq_cut_on_dly[17] && (&sq_cut_on_dly[16:0]) ;
 sq_cut_flag_dly[18] <= ~sq_cut_on_dly[18] && (&sq_cut_on_dly[17:0]) ;
 sq_cut_flag_dly[19] <= ~sq_cut_on_dly[19] && (&sq_cut_on_dly[18:0]) ;
 sq_cut_flag_dly[20] <= ~sq_cut_on_dly[20] && (&sq_cut_on_dly[19:0]) ;
 sq_cut_flag_dly[21] <= ~sq_cut_on_dly[21] && (&sq_cut_on_dly[20:0]) ;
 sq_cut_flag_dly[22] <= ~sq_cut_on_dly[22] && (&sq_cut_on_dly[21:0]) ;
 sq_cut_flag_dly[23] <= ~sq_cut_on_dly[23] && (&sq_cut_on_dly[22:0]) ;
 sq_cut_flag_dly[24] <= ~sq_cut_on_dly[24] && (&sq_cut_on_dly[23:0]) ;
 sq_cut_flag_dly[25] <= ~sq_cut_on_dly[25] && (&sq_cut_on_dly[24:0]) ;
 sq_cut_flag_dly[26] <= ~sq_cut_on_dly[26] && (&sq_cut_on_dly[25:0]) ;
 sq_cut_flag_dly[27] <= ~sq_cut_on_dly[27] && (&sq_cut_on_dly[26:0]) ;
 sq_cut_flag_dly[28] <= ~sq_cut_on_dly[28] && (&sq_cut_on_dly[27:0]) ;
 sq_cut_flag_dly[29] <= ~sq_cut_on_dly[29] && (&sq_cut_on_dly[28:0]) ;
 sq_cut_flag_dly[30] <= ~sq_cut_on_dly[30] && (&sq_cut_on_dly[29:0]) ;
 sq_cut_flag_dly[31] <= ~sq_cut_on_dly[31] && (&sq_cut_on_dly[30:0]) ;
 end
 else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg ) ) begin
 sq_cut_flag_dly[ 0] <= ~sq_cut_on_dly[ 0] ;
 sq_cut_flag_dly[ 1] <= ~sq_cut_on_dly[ 1] && ( sq_cut_on_dly[ 0]) ;
 sq_cut_flag_dly[ 2] <= ~sq_cut_on_dly[ 2] && (&sq_cut_on_dly[ 1:0]) ;
 sq_cut_flag_dly[ 3] <= ~sq_cut_on_dly[ 3] && (&sq_cut_on_dly[ 2:0]) ;
 sq_cut_flag_dly[ 4] <= ~sq_cut_on_dly[ 4] && (&sq_cut_on_dly[ 3:0]) ;
 sq_cut_flag_dly[ 5] <= ~sq_cut_on_dly[ 5] && (&sq_cut_on_dly[ 4:0]) ;
 sq_cut_flag_dly[ 6] <= ~sq_cut_on_dly[ 6] && (&sq_cut_on_dly[ 5:0]) ;
 sq_cut_flag_dly[ 7] <= ~sq_cut_on_dly[ 7] && (&sq_cut_on_dly[ 6:0]) ;
 sq_cut_flag_dly[ 8] <= ~sq_cut_on_dly[ 8] && (&sq_cut_on_dly[ 7:0]) ;
 sq_cut_flag_dly[ 9] <= ~sq_cut_on_dly[ 9] && (&sq_cut_on_dly[ 8:0]) ;
 sq_cut_flag_dly[10] <= ~sq_cut_on_dly[10] && (&sq_cut_on_dly[ 9:0]) ;
 sq_cut_flag_dly[11] <= ~sq_cut_on_dly[11] && (&sq_cut_on_dly[10:0]) ;
 sq_cut_flag_dly[12] <= ~sq_cut_on_dly[12] && (&sq_cut_on_dly[11:0]) ;
 sq_cut_flag_dly[13] <= ~sq_cut_on_dly[13] && (&sq_cut_on_dly[12:0]) ;
 sq_cut_flag_dly[14] <= ~sq_cut_on_dly[14] && (&sq_cut_on_dly[13:0]) ;
 sq_cut_flag_dly[15] <= ~sq_cut_on_dly[15] && (&sq_cut_on_dly[14:0]) ;
 sq_cut_flag_dly[16] <= ~sq_cut_on_dly[16] && (&sq_cut_on_dly[15:0]) ;
 sq_cut_flag_dly[17] <= ~sq_cut_on_dly[17] && (&sq_cut_on_dly[16:0]) ;
 sq_cut_flag_dly[18] <= ~sq_cut_on_dly[18] && (&sq_cut_on_dly[17:0]) ;
 sq_cut_flag_dly[19] <= ~sq_cut_on_dly[19] && (&sq_cut_on_dly[18:0]) ;
 sq_cut_flag_dly[20] <= ~sq_cut_on_dly[20] && (&sq_cut_on_dly[19:0]) ;
 sq_cut_flag_dly[21] <= ~sq_cut_on_dly[21] && (&sq_cut_on_dly[20:0]) ;
 sq_cut_flag_dly[22] <= ~sq_cut_on_dly[22] && (&sq_cut_on_dly[21:0]) ;
 sq_cut_flag_dly[23] <= ~sq_cut_on_dly[23] && (&sq_cut_on_dly[22:0]) ;
 sq_cut_flag_dly[24] <= ~sq_cut_on_dly[24] && (&sq_cut_on_dly[23:0]) ;
 sq_cut_flag_dly[25] <= ~sq_cut_on_dly[25] && (&sq_cut_on_dly[24:0]) ;
 sq_cut_flag_dly[26] <= ~sq_cut_on_dly[26] && (&sq_cut_on_dly[25:0]) ;
 sq_cut_flag_dly[27] <= ~sq_cut_on_dly[27] && (&sq_cut_on_dly[26:0]) ;
 sq_cut_flag_dly[28] <= ~sq_cut_on_dly[28] && (&sq_cut_on_dly[27:0]) ;
 sq_cut_flag_dly[29] <= ~sq_cut_on_dly[29] && (&sq_cut_on_dly[28:0]) ;
 sq_cut_flag_dly[30] <= ~sq_cut_on_dly[30] && (&sq_cut_on_dly[29:0]) ;
 sq_cut_flag_dly[31] <= ~sq_cut_on_dly[31] && (&sq_cut_on_dly[30:0]) ;
 end
 else begin
 sq_cut_flag_dly <= 32'd0 ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_on <= 32'd0 ;
 end
 else if ( |sq_cut_flag ) begin
 sq_cut_on[ 0] <= sq_cut_flag[ 0] ? 1'd1 : sq_cut_on[ 0] ;
 sq_cut_on[ 1] <= sq_cut_flag[ 1] ? 1'd1 : sq_cut_on[ 1] ;
 sq_cut_on[ 2] <= sq_cut_flag[ 2] ? 1'd1 : sq_cut_on[ 2] ;
 sq_cut_on[ 3] <= sq_cut_flag[ 3] ? 1'd1 : sq_cut_on[ 3] ;
 sq_cut_on[ 4] <= sq_cut_flag[ 4] ? 1'd1 : sq_cut_on[ 4] ;
 sq_cut_on[ 5] <= sq_cut_flag[ 5] ? 1'd1 : sq_cut_on[ 5] ;
 sq_cut_on[ 6] <= sq_cut_flag[ 6] ? 1'd1 : sq_cut_on[ 6] ;
 sq_cut_on[ 7] <= sq_cut_flag[ 7] ? 1'd1 : sq_cut_on[ 7] ;
 sq_cut_on[ 8] <= sq_cut_flag[ 8] ? 1'd1 : sq_cut_on[ 8] ;
 sq_cut_on[ 9] <= sq_cut_flag[ 9] ? 1'd1 : sq_cut_on[ 9] ;
 sq_cut_on[10] <= sq_cut_flag[10] ? 1'd1 : sq_cut_on[10] ;
 sq_cut_on[11] <= sq_cut_flag[11] ? 1'd1 : sq_cut_on[11] ;
 sq_cut_on[12] <= sq_cut_flag[12] ? 1'd1 : sq_cut_on[12] ;
 sq_cut_on[13] <= sq_cut_flag[13] ? 1'd1 : sq_cut_on[13] ;
 sq_cut_on[14] <= sq_cut_flag[14] ? 1'd1 : sq_cut_on[14] ;
 sq_cut_on[15] <= sq_cut_flag[15] ? 1'd1 : sq_cut_on[15] ;
 sq_cut_on[16] <= sq_cut_flag[16] ? 1'd1 : sq_cut_on[16] ;
 sq_cut_on[17] <= sq_cut_flag[17] ? 1'd1 : sq_cut_on[17] ;
 sq_cut_on[18] <= sq_cut_flag[18] ? 1'd1 : sq_cut_on[18] ;
 sq_cut_on[19] <= sq_cut_flag[19] ? 1'd1 : sq_cut_on[19] ;
 sq_cut_on[20] <= sq_cut_flag[20] ? 1'd1 : sq_cut_on[20] ;
 sq_cut_on[21] <= sq_cut_flag[21] ? 1'd1 : sq_cut_on[21] ;
 sq_cut_on[22] <= sq_cut_flag[22] ? 1'd1 : sq_cut_on[22] ;
 sq_cut_on[23] <= sq_cut_flag[23] ? 1'd1 : sq_cut_on[23] ;
 sq_cut_on[24] <= sq_cut_flag[24] ? 1'd1 : sq_cut_on[24] ;
 sq_cut_on[25] <= sq_cut_flag[25] ? 1'd1 : sq_cut_on[25] ;
 sq_cut_on[26] <= sq_cut_flag[26] ? 1'd1 : sq_cut_on[26] ;
 sq_cut_on[27] <= sq_cut_flag[27] ? 1'd1 : sq_cut_on[27] ;
 sq_cut_on[28] <= sq_cut_flag[28] ? 1'd1 : sq_cut_on[28] ;
 sq_cut_on[29] <= sq_cut_flag[29] ? 1'd1 : sq_cut_on[29] ;
 sq_cut_on[30] <= sq_cut_flag[30] ? 1'd1 : sq_cut_on[30] ;
 sq_cut_on[31] <= sq_cut_flag[31] ? 1'd1 : sq_cut_on[31] ;
 end
 else if ( |sq_cut_reset ) begin
 sq_cut_on[ 0] <= sq_cut_reset[ 0] ? 1'd0 : sq_cut_on[ 0] ;
 sq_cut_on[ 1] <= sq_cut_reset[ 1] ? 1'd0 : sq_cut_on[ 1] ;
 sq_cut_on[ 2] <= sq_cut_reset[ 2] ? 1'd0 : sq_cut_on[ 2] ;
 sq_cut_on[ 3] <= sq_cut_reset[ 3] ? 1'd0 : sq_cut_on[ 3] ;
 sq_cut_on[ 4] <= sq_cut_reset[ 4] ? 1'd0 : sq_cut_on[ 4] ;
 sq_cut_on[ 5] <= sq_cut_reset[ 5] ? 1'd0 : sq_cut_on[ 5] ;
 sq_cut_on[ 6] <= sq_cut_reset[ 6] ? 1'd0 : sq_cut_on[ 6] ;
 sq_cut_on[ 7] <= sq_cut_reset[ 7] ? 1'd0 : sq_cut_on[ 7] ;
 sq_cut_on[ 8] <= sq_cut_reset[ 8] ? 1'd0 : sq_cut_on[ 8] ;
 sq_cut_on[ 9] <= sq_cut_reset[ 9] ? 1'd0 : sq_cut_on[ 9] ;
 sq_cut_on[10] <= sq_cut_reset[10] ? 1'd0 : sq_cut_on[10] ;
 sq_cut_on[11] <= sq_cut_reset[11] ? 1'd0 : sq_cut_on[11] ;
 sq_cut_on[12] <= sq_cut_reset[12] ? 1'd0 : sq_cut_on[12] ;
 sq_cut_on[13] <= sq_cut_reset[13] ? 1'd0 : sq_cut_on[13] ;
 sq_cut_on[14] <= sq_cut_reset[14] ? 1'd0 : sq_cut_on[14] ;
 sq_cut_on[15] <= sq_cut_reset[15] ? 1'd0 : sq_cut_on[15] ;
 sq_cut_on[16] <= sq_cut_reset[16] ? 1'd0 : sq_cut_on[16] ;
 sq_cut_on[17] <= sq_cut_reset[17] ? 1'd0 : sq_cut_on[17] ;
 sq_cut_on[18] <= sq_cut_reset[18] ? 1'd0 : sq_cut_on[18] ;
 sq_cut_on[19] <= sq_cut_reset[19] ? 1'd0 : sq_cut_on[19] ;
 sq_cut_on[20] <= sq_cut_reset[20] ? 1'd0 : sq_cut_on[20] ;
 sq_cut_on[21] <= sq_cut_reset[21] ? 1'd0 : sq_cut_on[21] ;
 sq_cut_on[22] <= sq_cut_reset[22] ? 1'd0 : sq_cut_on[22] ;
 sq_cut_on[23] <= sq_cut_reset[23] ? 1'd0 : sq_cut_on[23] ;
 sq_cut_on[24] <= sq_cut_reset[24] ? 1'd0 : sq_cut_on[24] ;
 sq_cut_on[25] <= sq_cut_reset[25] ? 1'd0 : sq_cut_on[25] ;
 sq_cut_on[26] <= sq_cut_reset[26] ? 1'd0 : sq_cut_on[26] ;
 sq_cut_on[27] <= sq_cut_reset[27] ? 1'd0 : sq_cut_on[27] ;
 sq_cut_on[28] <= sq_cut_reset[28] ? 1'd0 : sq_cut_on[28] ;
 sq_cut_on[29] <= sq_cut_reset[29] ? 1'd0 : sq_cut_on[29] ;
 sq_cut_on[30] <= sq_cut_reset[30] ? 1'd0 : sq_cut_on[30] ;
 sq_cut_on[31] <= sq_cut_reset[31] ? 1'd0 : sq_cut_on[31] ;
 end
 else if ( st_rx_start && (|tcp_sqmatch_flag) ) begin
 sq_cut_on[ 0] <= tcp_sqmatch_flag[ 0] ? 1'd0 : sq_cut_on[ 0] ;
 sq_cut_on[ 1] <= tcp_sqmatch_flag[ 1] ? 1'd0 : sq_cut_on[ 1] ;
 sq_cut_on[ 2] <= tcp_sqmatch_flag[ 2] ? 1'd0 : sq_cut_on[ 2] ;
 sq_cut_on[ 3] <= tcp_sqmatch_flag[ 3] ? 1'd0 : sq_cut_on[ 3] ;
 sq_cut_on[ 4] <= tcp_sqmatch_flag[ 4] ? 1'd0 : sq_cut_on[ 4] ;
 sq_cut_on[ 5] <= tcp_sqmatch_flag[ 5] ? 1'd0 : sq_cut_on[ 5] ;
 sq_cut_on[ 6] <= tcp_sqmatch_flag[ 6] ? 1'd0 : sq_cut_on[ 6] ;
 sq_cut_on[ 7] <= tcp_sqmatch_flag[ 7] ? 1'd0 : sq_cut_on[ 7] ;
 sq_cut_on[ 8] <= tcp_sqmatch_flag[ 8] ? 1'd0 : sq_cut_on[ 8] ;
 sq_cut_on[ 9] <= tcp_sqmatch_flag[ 9] ? 1'd0 : sq_cut_on[ 9] ;
 sq_cut_on[10] <= tcp_sqmatch_flag[10] ? 1'd0 : sq_cut_on[10] ;
 sq_cut_on[11] <= tcp_sqmatch_flag[11] ? 1'd0 : sq_cut_on[11] ;
 sq_cut_on[12] <= tcp_sqmatch_flag[12] ? 1'd0 : sq_cut_on[12] ;
 sq_cut_on[13] <= tcp_sqmatch_flag[13] ? 1'd0 : sq_cut_on[13] ;
 sq_cut_on[14] <= tcp_sqmatch_flag[14] ? 1'd0 : sq_cut_on[14] ;
 sq_cut_on[15] <= tcp_sqmatch_flag[15] ? 1'd0 : sq_cut_on[15] ;
 sq_cut_on[16] <= tcp_sqmatch_flag[16] ? 1'd0 : sq_cut_on[16] ;
 sq_cut_on[17] <= tcp_sqmatch_flag[17] ? 1'd0 : sq_cut_on[17] ;
 sq_cut_on[18] <= tcp_sqmatch_flag[18] ? 1'd0 : sq_cut_on[18] ;
 sq_cut_on[19] <= tcp_sqmatch_flag[19] ? 1'd0 : sq_cut_on[19] ;
 sq_cut_on[20] <= tcp_sqmatch_flag[20] ? 1'd0 : sq_cut_on[20] ;
 sq_cut_on[21] <= tcp_sqmatch_flag[21] ? 1'd0 : sq_cut_on[21] ;
 sq_cut_on[22] <= tcp_sqmatch_flag[22] ? 1'd0 : sq_cut_on[22] ;
 sq_cut_on[23] <= tcp_sqmatch_flag[23] ? 1'd0 : sq_cut_on[23] ;
 sq_cut_on[24] <= tcp_sqmatch_flag[24] ? 1'd0 : sq_cut_on[24] ;
 sq_cut_on[25] <= tcp_sqmatch_flag[25] ? 1'd0 : sq_cut_on[25] ;
 sq_cut_on[26] <= tcp_sqmatch_flag[26] ? 1'd0 : sq_cut_on[26] ;
 sq_cut_on[27] <= tcp_sqmatch_flag[27] ? 1'd0 : sq_cut_on[27] ;
 sq_cut_on[28] <= tcp_sqmatch_flag[28] ? 1'd0 : sq_cut_on[28] ;
 sq_cut_on[29] <= tcp_sqmatch_flag[29] ? 1'd0 : sq_cut_on[29] ;
 sq_cut_on[30] <= tcp_sqmatch_flag[30] ? 1'd0 : sq_cut_on[30] ;
 sq_cut_on[31] <= tcp_sqmatch_flag[31] ? 1'd0 : sq_cut_on[31] ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_on_dly <= 32'd0 ;
 end
 else if ( |sq_cut_flag_dly ) begin
 sq_cut_on_dly[ 0] <= sq_cut_flag_dly[ 0] ? 1'd1 : sq_cut_on_dly[ 0] ;
 sq_cut_on_dly[ 1] <= sq_cut_flag_dly[ 1] ? 1'd1 : sq_cut_on_dly[ 1] ;
 sq_cut_on_dly[ 2] <= sq_cut_flag_dly[ 2] ? 1'd1 : sq_cut_on_dly[ 2] ;
 sq_cut_on_dly[ 3] <= sq_cut_flag_dly[ 3] ? 1'd1 : sq_cut_on_dly[ 3] ;
 sq_cut_on_dly[ 4] <= sq_cut_flag_dly[ 4] ? 1'd1 : sq_cut_on_dly[ 4] ;
 sq_cut_on_dly[ 5] <= sq_cut_flag_dly[ 5] ? 1'd1 : sq_cut_on_dly[ 5] ;
 sq_cut_on_dly[ 6] <= sq_cut_flag_dly[ 6] ? 1'd1 : sq_cut_on_dly[ 6] ;
 sq_cut_on_dly[ 7] <= sq_cut_flag_dly[ 7] ? 1'd1 : sq_cut_on_dly[ 7] ;
 sq_cut_on_dly[ 8] <= sq_cut_flag_dly[ 8] ? 1'd1 : sq_cut_on_dly[ 8] ;
 sq_cut_on_dly[ 9] <= sq_cut_flag_dly[ 9] ? 1'd1 : sq_cut_on_dly[ 9] ;
 sq_cut_on_dly[10] <= sq_cut_flag_dly[10] ? 1'd1 : sq_cut_on_dly[10] ;
 sq_cut_on_dly[11] <= sq_cut_flag_dly[11] ? 1'd1 : sq_cut_on_dly[11] ;
 sq_cut_on_dly[12] <= sq_cut_flag_dly[12] ? 1'd1 : sq_cut_on_dly[12] ;
 sq_cut_on_dly[13] <= sq_cut_flag_dly[13] ? 1'd1 : sq_cut_on_dly[13] ;
 sq_cut_on_dly[14] <= sq_cut_flag_dly[14] ? 1'd1 : sq_cut_on_dly[14] ;
 sq_cut_on_dly[15] <= sq_cut_flag_dly[15] ? 1'd1 : sq_cut_on_dly[15] ;
 sq_cut_on_dly[16] <= sq_cut_flag_dly[16] ? 1'd1 : sq_cut_on_dly[16] ;
 sq_cut_on_dly[17] <= sq_cut_flag_dly[17] ? 1'd1 : sq_cut_on_dly[17] ;
 sq_cut_on_dly[18] <= sq_cut_flag_dly[18] ? 1'd1 : sq_cut_on_dly[18] ;
 sq_cut_on_dly[19] <= sq_cut_flag_dly[19] ? 1'd1 : sq_cut_on_dly[19] ;
 sq_cut_on_dly[20] <= sq_cut_flag_dly[20] ? 1'd1 : sq_cut_on_dly[20] ;
 sq_cut_on_dly[21] <= sq_cut_flag_dly[21] ? 1'd1 : sq_cut_on_dly[21] ;
 sq_cut_on_dly[22] <= sq_cut_flag_dly[22] ? 1'd1 : sq_cut_on_dly[22] ;
 sq_cut_on_dly[23] <= sq_cut_flag_dly[23] ? 1'd1 : sq_cut_on_dly[23] ;
 sq_cut_on_dly[24] <= sq_cut_flag_dly[24] ? 1'd1 : sq_cut_on_dly[24] ;
 sq_cut_on_dly[25] <= sq_cut_flag_dly[25] ? 1'd1 : sq_cut_on_dly[25] ;
 sq_cut_on_dly[26] <= sq_cut_flag_dly[26] ? 1'd1 : sq_cut_on_dly[26] ;
 sq_cut_on_dly[27] <= sq_cut_flag_dly[27] ? 1'd1 : sq_cut_on_dly[27] ;
 sq_cut_on_dly[28] <= sq_cut_flag_dly[28] ? 1'd1 : sq_cut_on_dly[28] ;
 sq_cut_on_dly[29] <= sq_cut_flag_dly[29] ? 1'd1 : sq_cut_on_dly[29] ;
 sq_cut_on_dly[30] <= sq_cut_flag_dly[30] ? 1'd1 : sq_cut_on_dly[30] ;
 sq_cut_on_dly[31] <= sq_cut_flag_dly[31] ? 1'd1 : sq_cut_on_dly[31] ;
 end
 else if ( |sq_cut_reset ) begin
 sq_cut_on_dly[ 0] <= sq_cut_reset[ 0] ? 1'd0 : sq_cut_on_dly[ 0] ;
 sq_cut_on_dly[ 1] <= sq_cut_reset[ 1] ? 1'd0 : sq_cut_on_dly[ 1] ;
 sq_cut_on_dly[ 2] <= sq_cut_reset[ 2] ? 1'd0 : sq_cut_on_dly[ 2] ;
 sq_cut_on_dly[ 3] <= sq_cut_reset[ 3] ? 1'd0 : sq_cut_on_dly[ 3] ;
 sq_cut_on_dly[ 4] <= sq_cut_reset[ 4] ? 1'd0 : sq_cut_on_dly[ 4] ;
 sq_cut_on_dly[ 5] <= sq_cut_reset[ 5] ? 1'd0 : sq_cut_on_dly[ 5] ;
 sq_cut_on_dly[ 6] <= sq_cut_reset[ 6] ? 1'd0 : sq_cut_on_dly[ 6] ;
 sq_cut_on_dly[ 7] <= sq_cut_reset[ 7] ? 1'd0 : sq_cut_on_dly[ 7] ;
 sq_cut_on_dly[ 8] <= sq_cut_reset[ 8] ? 1'd0 : sq_cut_on_dly[ 8] ;
 sq_cut_on_dly[ 9] <= sq_cut_reset[ 9] ? 1'd0 : sq_cut_on_dly[ 9] ;
 sq_cut_on_dly[10] <= sq_cut_reset[10] ? 1'd0 : sq_cut_on_dly[10] ;
 sq_cut_on_dly[11] <= sq_cut_reset[11] ? 1'd0 : sq_cut_on_dly[11] ;
 sq_cut_on_dly[12] <= sq_cut_reset[12] ? 1'd0 : sq_cut_on_dly[12] ;
 sq_cut_on_dly[13] <= sq_cut_reset[13] ? 1'd0 : sq_cut_on_dly[13] ;
 sq_cut_on_dly[14] <= sq_cut_reset[14] ? 1'd0 : sq_cut_on_dly[14] ;
 sq_cut_on_dly[15] <= sq_cut_reset[15] ? 1'd0 : sq_cut_on_dly[15] ;
 sq_cut_on_dly[16] <= sq_cut_reset[16] ? 1'd0 : sq_cut_on_dly[16] ;
 sq_cut_on_dly[17] <= sq_cut_reset[17] ? 1'd0 : sq_cut_on_dly[17] ;
 sq_cut_on_dly[18] <= sq_cut_reset[18] ? 1'd0 : sq_cut_on_dly[18] ;
 sq_cut_on_dly[19] <= sq_cut_reset[19] ? 1'd0 : sq_cut_on_dly[19] ;
 sq_cut_on_dly[20] <= sq_cut_reset[20] ? 1'd0 : sq_cut_on_dly[20] ;
 sq_cut_on_dly[21] <= sq_cut_reset[21] ? 1'd0 : sq_cut_on_dly[21] ;
 sq_cut_on_dly[22] <= sq_cut_reset[22] ? 1'd0 : sq_cut_on_dly[22] ;
 sq_cut_on_dly[23] <= sq_cut_reset[23] ? 1'd0 : sq_cut_on_dly[23] ;
 sq_cut_on_dly[24] <= sq_cut_reset[24] ? 1'd0 : sq_cut_on_dly[24] ;
 sq_cut_on_dly[25] <= sq_cut_reset[25] ? 1'd0 : sq_cut_on_dly[25] ;
 sq_cut_on_dly[26] <= sq_cut_reset[26] ? 1'd0 : sq_cut_on_dly[26] ;
 sq_cut_on_dly[27] <= sq_cut_reset[27] ? 1'd0 : sq_cut_on_dly[27] ;
 sq_cut_on_dly[28] <= sq_cut_reset[28] ? 1'd0 : sq_cut_on_dly[28] ;
 sq_cut_on_dly[29] <= sq_cut_reset[29] ? 1'd0 : sq_cut_on_dly[29] ;
 sq_cut_on_dly[30] <= sq_cut_reset[30] ? 1'd0 : sq_cut_on_dly[30] ;
 sq_cut_on_dly[31] <= sq_cut_reset[31] ? 1'd0 : sq_cut_on_dly[31] ;
 end
 else if ( st_rx_start && (|tcp_sqmatch_flag) ) begin
 sq_cut_on_dly[ 0] <= tcp_sqmatch_flag[ 0] ? 1'd0 : sq_cut_on_dly[ 0] ;
 sq_cut_on_dly[ 1] <= tcp_sqmatch_flag[ 1] ? 1'd0 : sq_cut_on_dly[ 1] ;
 sq_cut_on_dly[ 2] <= tcp_sqmatch_flag[ 2] ? 1'd0 : sq_cut_on_dly[ 2] ;
 sq_cut_on_dly[ 3] <= tcp_sqmatch_flag[ 3] ? 1'd0 : sq_cut_on_dly[ 3] ;
 sq_cut_on_dly[ 4] <= tcp_sqmatch_flag[ 4] ? 1'd0 : sq_cut_on_dly[ 4] ;
 sq_cut_on_dly[ 5] <= tcp_sqmatch_flag[ 5] ? 1'd0 : sq_cut_on_dly[ 5] ;
 sq_cut_on_dly[ 6] <= tcp_sqmatch_flag[ 6] ? 1'd0 : sq_cut_on_dly[ 6] ;
 sq_cut_on_dly[ 7] <= tcp_sqmatch_flag[ 7] ? 1'd0 : sq_cut_on_dly[ 7] ;
 sq_cut_on_dly[ 8] <= tcp_sqmatch_flag[ 8] ? 1'd0 : sq_cut_on_dly[ 8] ;
 sq_cut_on_dly[ 9] <= tcp_sqmatch_flag[ 9] ? 1'd0 : sq_cut_on_dly[ 9] ;
 sq_cut_on_dly[10] <= tcp_sqmatch_flag[10] ? 1'd0 : sq_cut_on_dly[10] ;
 sq_cut_on_dly[11] <= tcp_sqmatch_flag[11] ? 1'd0 : sq_cut_on_dly[11] ;
 sq_cut_on_dly[12] <= tcp_sqmatch_flag[12] ? 1'd0 : sq_cut_on_dly[12] ;
 sq_cut_on_dly[13] <= tcp_sqmatch_flag[13] ? 1'd0 : sq_cut_on_dly[13] ;
 sq_cut_on_dly[14] <= tcp_sqmatch_flag[14] ? 1'd0 : sq_cut_on_dly[14] ;
 sq_cut_on_dly[15] <= tcp_sqmatch_flag[15] ? 1'd0 : sq_cut_on_dly[15] ;
 sq_cut_on_dly[16] <= tcp_sqmatch_flag[16] ? 1'd0 : sq_cut_on_dly[16] ;
 sq_cut_on_dly[17] <= tcp_sqmatch_flag[17] ? 1'd0 : sq_cut_on_dly[17] ;
 sq_cut_on_dly[18] <= tcp_sqmatch_flag[18] ? 1'd0 : sq_cut_on_dly[18] ;
 sq_cut_on_dly[19] <= tcp_sqmatch_flag[19] ? 1'd0 : sq_cut_on_dly[19] ;
 sq_cut_on_dly[20] <= tcp_sqmatch_flag[20] ? 1'd0 : sq_cut_on_dly[20] ;
 sq_cut_on_dly[21] <= tcp_sqmatch_flag[21] ? 1'd0 : sq_cut_on_dly[21] ;
 sq_cut_on_dly[22] <= tcp_sqmatch_flag[22] ? 1'd0 : sq_cut_on_dly[22] ;
 sq_cut_on_dly[23] <= tcp_sqmatch_flag[23] ? 1'd0 : sq_cut_on_dly[23] ;
 sq_cut_on_dly[24] <= tcp_sqmatch_flag[24] ? 1'd0 : sq_cut_on_dly[24] ;
 sq_cut_on_dly[25] <= tcp_sqmatch_flag[25] ? 1'd0 : sq_cut_on_dly[25] ;
 sq_cut_on_dly[26] <= tcp_sqmatch_flag[26] ? 1'd0 : sq_cut_on_dly[26] ;
 sq_cut_on_dly[27] <= tcp_sqmatch_flag[27] ? 1'd0 : sq_cut_on_dly[27] ;
 sq_cut_on_dly[28] <= tcp_sqmatch_flag[28] ? 1'd0 : sq_cut_on_dly[28] ;
 sq_cut_on_dly[29] <= tcp_sqmatch_flag[29] ? 1'd0 : sq_cut_on_dly[29] ;
 sq_cut_on_dly[30] <= tcp_sqmatch_flag[30] ? 1'd0 : sq_cut_on_dly[30] ;
 sq_cut_on_dly[31] <= tcp_sqmatch_flag[31] ? 1'd0 : sq_cut_on_dly[31] ;
 end
 end
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_cut_sq00id_reg <= 32'd0 ;
 current_cut_sq01id_reg <= 32'd0 ;
 current_cut_sq02id_reg <= 32'd0 ;
 current_cut_sq03id_reg <= 32'd0 ;
 current_cut_sq04id_reg <= 32'd0 ;
 current_cut_sq05id_reg <= 32'd0 ;
 current_cut_sq06id_reg <= 32'd0 ;
 current_cut_sq07id_reg <= 32'd0 ;
 current_cut_sq08id_reg <= 32'd0 ;
 current_cut_sq09id_reg <= 32'd0 ;
 current_cut_sq10id_reg <= 32'd0 ;
 current_cut_sq11id_reg <= 32'd0 ;
 current_cut_sq12id_reg <= 32'd0 ;
 current_cut_sq13id_reg <= 32'd0 ;
 current_cut_sq14id_reg <= 32'd0 ;
 current_cut_sq15id_reg <= 32'd0 ;
 current_cut_sq16id_reg <= 32'd0 ;
 current_cut_sq17id_reg <= 32'd0 ;
 current_cut_sq18id_reg <= 32'd0 ;
 current_cut_sq19id_reg <= 32'd0 ;
 current_cut_sq20id_reg <= 32'd0 ;
 current_cut_sq21id_reg <= 32'd0 ;
 current_cut_sq22id_reg <= 32'd0 ;
 current_cut_sq23id_reg <= 32'd0 ;
 current_cut_sq24id_reg <= 32'd0 ;
 current_cut_sq25id_reg <= 32'd0 ;
 current_cut_sq26id_reg <= 32'd0 ;
 current_cut_sq27id_reg <= 32'd0 ;
 current_cut_sq28id_reg <= 32'd0 ;
 current_cut_sq29id_reg <= 32'd0 ;
 current_cut_sq30id_reg <= 32'd0 ;
 current_cut_sq31id_reg <= 32'd0 ;
 end
 else if ( |sq_cut_flag ) begin
 current_cut_sq00id_reg <= (sq_cut_flag[ 0]) ? current_sqid_reg + 1'd1 : current_cut_sq00id_reg ;
 current_cut_sq01id_reg <= (sq_cut_flag[ 1]) ? current_sqid_reg + 1'd1 : current_cut_sq01id_reg ;
 current_cut_sq02id_reg <= (sq_cut_flag[ 2]) ? current_sqid_reg + 1'd1 : current_cut_sq02id_reg ;
 current_cut_sq03id_reg <= (sq_cut_flag[ 3]) ? current_sqid_reg + 1'd1 : current_cut_sq03id_reg ;
 current_cut_sq04id_reg <= (sq_cut_flag[ 4]) ? current_sqid_reg + 1'd1 : current_cut_sq04id_reg ;
 current_cut_sq05id_reg <= (sq_cut_flag[ 5]) ? current_sqid_reg + 1'd1 : current_cut_sq05id_reg ;
 current_cut_sq06id_reg <= (sq_cut_flag[ 6]) ? current_sqid_reg + 1'd1 : current_cut_sq06id_reg ;
 current_cut_sq07id_reg <= (sq_cut_flag[ 7]) ? current_sqid_reg + 1'd1 : current_cut_sq07id_reg ;
 current_cut_sq08id_reg <= (sq_cut_flag[ 8]) ? current_sqid_reg + 1'd1 : current_cut_sq08id_reg ;
 current_cut_sq09id_reg <= (sq_cut_flag[ 9]) ? current_sqid_reg + 1'd1 : current_cut_sq09id_reg ;
 current_cut_sq10id_reg <= (sq_cut_flag[10]) ? current_sqid_reg + 1'd1 : current_cut_sq10id_reg ;
 current_cut_sq11id_reg <= (sq_cut_flag[11]) ? current_sqid_reg + 1'd1 : current_cut_sq11id_reg ;
 current_cut_sq12id_reg <= (sq_cut_flag[12]) ? current_sqid_reg + 1'd1 : current_cut_sq12id_reg ;
 current_cut_sq13id_reg <= (sq_cut_flag[13]) ? current_sqid_reg + 1'd1 : current_cut_sq13id_reg ;
 current_cut_sq14id_reg <= (sq_cut_flag[14]) ? current_sqid_reg + 1'd1 : current_cut_sq14id_reg ;
 current_cut_sq15id_reg <= (sq_cut_flag[15]) ? current_sqid_reg + 1'd1 : current_cut_sq15id_reg ;
 current_cut_sq16id_reg <= (sq_cut_flag[16]) ? current_sqid_reg + 1'd1 : current_cut_sq16id_reg ;
 current_cut_sq17id_reg <= (sq_cut_flag[17]) ? current_sqid_reg + 1'd1 : current_cut_sq17id_reg ;
 current_cut_sq18id_reg <= (sq_cut_flag[18]) ? current_sqid_reg + 1'd1 : current_cut_sq18id_reg ;
 current_cut_sq19id_reg <= (sq_cut_flag[19]) ? current_sqid_reg + 1'd1 : current_cut_sq19id_reg ;
 current_cut_sq20id_reg <= (sq_cut_flag[20]) ? current_sqid_reg + 1'd1 : current_cut_sq20id_reg ;
 current_cut_sq21id_reg <= (sq_cut_flag[21]) ? current_sqid_reg + 1'd1 : current_cut_sq21id_reg ;
 current_cut_sq22id_reg <= (sq_cut_flag[22]) ? current_sqid_reg + 1'd1 : current_cut_sq22id_reg ;
 current_cut_sq23id_reg <= (sq_cut_flag[23]) ? current_sqid_reg + 1'd1 : current_cut_sq23id_reg ;
 current_cut_sq24id_reg <= (sq_cut_flag[24]) ? current_sqid_reg + 1'd1 : current_cut_sq24id_reg ;
 current_cut_sq25id_reg <= (sq_cut_flag[25]) ? current_sqid_reg + 1'd1 : current_cut_sq25id_reg ;
 current_cut_sq26id_reg <= (sq_cut_flag[26]) ? current_sqid_reg + 1'd1 : current_cut_sq26id_reg ;
 current_cut_sq27id_reg <= (sq_cut_flag[27]) ? current_sqid_reg + 1'd1 : current_cut_sq27id_reg ;
 current_cut_sq28id_reg <= (sq_cut_flag[28]) ? current_sqid_reg + 1'd1 : current_cut_sq28id_reg ;
 current_cut_sq29id_reg <= (sq_cut_flag[29]) ? current_sqid_reg + 1'd1 : current_cut_sq29id_reg ;
 current_cut_sq30id_reg <= (sq_cut_flag[30]) ? current_sqid_reg + 1'd1 : current_cut_sq30id_reg ;
 current_cut_sq31id_reg <= (sq_cut_flag[31]) ? current_sqid_reg + 1'd1 : current_cut_sq31id_reg ;
 end
 end
 reg current_sqcut_done_dly ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 current_cut_done_sqid_reg <= 32'd0 ;
 current_sqcut_done_dly <= 1'd0 ;
 end
 else begin
 current_sqcut_done_dly <= |current_sqcut_done ;
 case (current_sqcut_done) 32'h0000_0001: current_cut_done_sqid_reg <= (current_cut_done_sq00id_reg) ;
 32'h0000_0002: current_cut_done_sqid_reg <= (current_cut_done_sq01id_reg) ;
 32'h0000_0004: current_cut_done_sqid_reg <= (current_cut_done_sq02id_reg) ;
 32'h0000_0008: current_cut_done_sqid_reg <= (current_cut_done_sq03id_reg) ;
 32'h0000_0010: current_cut_done_sqid_reg <= (current_cut_done_sq04id_reg) ;
 32'h0000_0020: current_cut_done_sqid_reg <= (current_cut_done_sq05id_reg) ;
 32'h0000_0040: current_cut_done_sqid_reg <= (current_cut_done_sq06id_reg) ;
 32'h0000_0080: current_cut_done_sqid_reg <= (current_cut_done_sq07id_reg) ;
 32'h0000_0100: current_cut_done_sqid_reg <= (current_cut_done_sq08id_reg) ;
 32'h0000_0200: current_cut_done_sqid_reg <= (current_cut_done_sq09id_reg) ;
 32'h0000_0400: current_cut_done_sqid_reg <= (current_cut_done_sq10id_reg) ;
 32'h0000_0800: current_cut_done_sqid_reg <= (current_cut_done_sq11id_reg) ;
 32'h0000_1000: current_cut_done_sqid_reg <= (current_cut_done_sq12id_reg) ;
 32'h0000_2000: current_cut_done_sqid_reg <= (current_cut_done_sq13id_reg) ;
 32'h0000_4000: current_cut_done_sqid_reg <= (current_cut_done_sq14id_reg) ;
 32'h0000_8000: current_cut_done_sqid_reg <= (current_cut_done_sq15id_reg) ;
 32'h0001_0000: current_cut_done_sqid_reg <= (current_cut_done_sq16id_reg) ;
 32'h0002_0000: current_cut_done_sqid_reg <= (current_cut_done_sq17id_reg) ;
 32'h0004_0000: current_cut_done_sqid_reg <= (current_cut_done_sq18id_reg) ;
 32'h0008_0000: current_cut_done_sqid_reg <= (current_cut_done_sq19id_reg) ;
 32'h0010_0000: current_cut_done_sqid_reg <= (current_cut_done_sq20id_reg) ;
 32'h0020_0000: current_cut_done_sqid_reg <= (current_cut_done_sq21id_reg) ;
 32'h0040_0000: current_cut_done_sqid_reg <= (current_cut_done_sq22id_reg) ;
 32'h0080_0000: current_cut_done_sqid_reg <= (current_cut_done_sq23id_reg) ;
 32'h0100_0000: current_cut_done_sqid_reg <= (current_cut_done_sq24id_reg) ;
 32'h0200_0000: current_cut_done_sqid_reg <= (current_cut_done_sq25id_reg) ;
 32'h0400_0000: current_cut_done_sqid_reg <= (current_cut_done_sq26id_reg) ;
 32'h0800_0000: current_cut_done_sqid_reg <= (current_cut_done_sq27id_reg) ;
 32'h1000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq28id_reg) ;
 32'h2000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq29id_reg) ;
 32'h4000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq30id_reg) ;
 32'h8000_0000: current_cut_done_sqid_reg <= (current_cut_done_sq31id_reg) ;
 default : current_cut_done_sqid_reg <= current_cut_done_sqid_reg ;
 endcase end
 end
 reg [1:0] sq_cut_reset_cnt_00 ;
 reg [1:0] sq_cut_reset_cnt_01 ;
 reg [1:0] sq_cut_reset_cnt_02 ;
 reg [1:0] sq_cut_reset_cnt_03 ;
 reg [1:0] sq_cut_reset_cnt_04 ;
 reg [1:0] sq_cut_reset_cnt_05 ;
 reg [1:0] sq_cut_reset_cnt_06 ;
 reg [1:0] sq_cut_reset_cnt_07 ;
 reg [1:0] sq_cut_reset_cnt_08 ;
 reg [1:0] sq_cut_reset_cnt_09 ;
 reg [1:0] sq_cut_reset_cnt_10 ;
 reg [1:0] sq_cut_reset_cnt_11 ;
 reg [1:0] sq_cut_reset_cnt_12 ;
 reg [1:0] sq_cut_reset_cnt_13 ;
 reg [1:0] sq_cut_reset_cnt_14 ;
 reg [1:0] sq_cut_reset_cnt_15 ;
 reg [1:0] sq_cut_reset_cnt_16 ;
 reg [1:0] sq_cut_reset_cnt_17 ;
 reg [1:0] sq_cut_reset_cnt_18 ;
 reg [1:0] sq_cut_reset_cnt_19 ;
 reg [1:0] sq_cut_reset_cnt_20 ;
 reg [1:0] sq_cut_reset_cnt_21 ;
 reg [1:0] sq_cut_reset_cnt_22 ;
 reg [1:0] sq_cut_reset_cnt_23 ;
 reg [1:0] sq_cut_reset_cnt_24 ;
 reg [1:0] sq_cut_reset_cnt_25 ;
 reg [1:0] sq_cut_reset_cnt_26 ;
 reg [1:0] sq_cut_reset_cnt_27 ;
 reg [1:0] sq_cut_reset_cnt_28 ;
 reg [1:0] sq_cut_reset_cnt_29 ;
 reg [1:0] sq_cut_reset_cnt_30 ;
 reg [1:0] sq_cut_reset_cnt_31 ;
 always@ ( negedge rst_n or posedge clk) begin
 if (~rst_n) begin
 sq_cut_reset_pre <= 32'd0 ;
 sq_cut_reset_cnt_00 <= 2'd0 ;
 sq_cut_reset_cnt_01 <= 2'd0 ;
 sq_cut_reset_cnt_02 <= 2'd0 ;
 sq_cut_reset_cnt_03 <= 2'd0 ;
 sq_cut_reset_cnt_04 <= 2'd0 ;
 sq_cut_reset_cnt_05 <= 2'd0 ;
 sq_cut_reset_cnt_06 <= 2'd0 ;
 sq_cut_reset_cnt_07 <= 2'd0 ;
 sq_cut_reset_cnt_08 <= 2'd0 ;
 sq_cut_reset_cnt_09 <= 2'd0 ;
 sq_cut_reset_cnt_10 <= 2'd0 ;
 sq_cut_reset_cnt_11 <= 2'd0 ;
 sq_cut_reset_cnt_12 <= 2'd0 ;
 sq_cut_reset_cnt_13 <= 2'd0 ;
 sq_cut_reset_cnt_14 <= 2'd0 ;
 sq_cut_reset_cnt_15 <= 2'd0 ;
 sq_cut_reset_cnt_16 <= 2'd0 ;
 sq_cut_reset_cnt_17 <= 2'd0 ;
 sq_cut_reset_cnt_18 <= 2'd0 ;
 sq_cut_reset_cnt_19 <= 2'd0 ;
 sq_cut_reset_cnt_20 <= 2'd0 ;
 sq_cut_reset_cnt_21 <= 2'd0 ;
 sq_cut_reset_cnt_22 <= 2'd0 ;
 sq_cut_reset_cnt_23 <= 2'd0 ;
 sq_cut_reset_cnt_24 <= 2'd0 ;
 sq_cut_reset_cnt_25 <= 2'd0 ;
 sq_cut_reset_cnt_26 <= 2'd0 ;
 sq_cut_reset_cnt_27 <= 2'd0 ;
 sq_cut_reset_cnt_28 <= 2'd0 ;
 sq_cut_reset_cnt_29 <= 2'd0 ;
 sq_cut_reset_cnt_30 <= 2'd0 ;
 sq_cut_reset_cnt_31 <= 2'd0 ;
 end
 else if (params_filter_rst) begin
 sq_cut_reset_pre <= 32'h0000_0000 ;
 sq_cut_reset_cnt_00 <= 2'd0 ;
 sq_cut_reset_cnt_01 <= 2'd0 ;
 sq_cut_reset_cnt_02 <= 2'd0 ;
 sq_cut_reset_cnt_03 <= 2'd0 ;
 sq_cut_reset_cnt_04 <= 2'd0 ;
 sq_cut_reset_cnt_05 <= 2'd0 ;
 sq_cut_reset_cnt_06 <= 2'd0 ;
 sq_cut_reset_cnt_07 <= 2'd0 ;
 sq_cut_reset_cnt_08 <= 2'd0 ;
 sq_cut_reset_cnt_09 <= 2'd0 ;
 sq_cut_reset_cnt_10 <= 2'd0 ;
 sq_cut_reset_cnt_11 <= 2'd0 ;
 sq_cut_reset_cnt_12 <= 2'd0 ;
 sq_cut_reset_cnt_13 <= 2'd0 ;
 sq_cut_reset_cnt_14 <= 2'd0 ;
 sq_cut_reset_cnt_15 <= 2'd0 ;
 sq_cut_reset_cnt_16 <= 2'd0 ;
 sq_cut_reset_cnt_17 <= 2'd0 ;
 sq_cut_reset_cnt_18 <= 2'd0 ;
 sq_cut_reset_cnt_19 <= 2'd0 ;
 sq_cut_reset_cnt_20 <= 2'd0 ;
 sq_cut_reset_cnt_21 <= 2'd0 ;
 sq_cut_reset_cnt_22 <= 2'd0 ;
 sq_cut_reset_cnt_23 <= 2'd0 ;
 sq_cut_reset_cnt_24 <= 2'd0 ;
 sq_cut_reset_cnt_25 <= 2'd0 ;
 sq_cut_reset_cnt_26 <= 2'd0 ;
 sq_cut_reset_cnt_27 <= 2'd0 ;
 sq_cut_reset_cnt_28 <= 2'd0 ;
 sq_cut_reset_cnt_29 <= 2'd0 ;
 sq_cut_reset_cnt_30 <= 2'd0 ;
 sq_cut_reset_cnt_31 <= 2'd0 ;
 end
 else if ( current_sqcut_done_dly ) begin
 sq_cut_reset_pre[ 0] <= ( sq_cut_on[ 0] && ( (current_cut_sq00id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq00id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_00>=2'd1) ) )) ;
 sq_cut_reset_pre[ 1] <= ( sq_cut_on[ 1] && ( (current_cut_sq01id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq01id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_01>=2'd1) ) )) ;
 sq_cut_reset_pre[ 2] <= ( sq_cut_on[ 2] && ( (current_cut_sq02id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq02id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_02>=2'd1) ) )) ;
 sq_cut_reset_pre[ 3] <= ( sq_cut_on[ 3] && ( (current_cut_sq03id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq03id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_03>=2'd1) ) )) ;
 sq_cut_reset_pre[ 4] <= ( sq_cut_on[ 4] && ( (current_cut_sq04id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq04id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_04>=2'd1) ) )) ;
 sq_cut_reset_pre[ 5] <= ( sq_cut_on[ 5] && ( (current_cut_sq05id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq05id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_05>=2'd1) ) )) ;
 sq_cut_reset_pre[ 6] <= ( sq_cut_on[ 6] && ( (current_cut_sq06id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq06id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_06>=2'd1) ) )) ;
 sq_cut_reset_pre[ 7] <= ( sq_cut_on[ 7] && ( (current_cut_sq07id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq07id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_07>=2'd1) ) )) ;
 sq_cut_reset_pre[ 8] <= ( sq_cut_on[ 8] && ( (current_cut_sq08id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq08id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_08>=2'd1) ) )) ;
 sq_cut_reset_pre[ 9] <= ( sq_cut_on[ 9] && ( (current_cut_sq09id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq09id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_09>=2'd1) ) )) ;
 sq_cut_reset_pre[10] <= ( sq_cut_on[10] && ( (current_cut_sq10id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq10id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_10>=2'd1) ) )) ;
 sq_cut_reset_pre[11] <= ( sq_cut_on[11] && ( (current_cut_sq11id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq11id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_11>=2'd1) ) )) ;
 sq_cut_reset_pre[12] <= ( sq_cut_on[12] && ( (current_cut_sq12id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq12id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_12>=2'd1) ) )) ;
 sq_cut_reset_pre[13] <= ( sq_cut_on[13] && ( (current_cut_sq13id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq13id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_13>=2'd1) ) )) ;
 sq_cut_reset_pre[14] <= ( sq_cut_on[14] && ( (current_cut_sq14id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq14id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_14>=2'd1) ) )) ;
 sq_cut_reset_pre[15] <= ( sq_cut_on[15] && ( (current_cut_sq15id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq15id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_15>=2'd1) ) )) ;
 sq_cut_reset_pre[16] <= ( sq_cut_on[16] && ( (current_cut_sq16id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq16id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_16>=2'd1) ) )) ;
 sq_cut_reset_pre[17] <= ( sq_cut_on[17] && ( (current_cut_sq17id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq17id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_17>=2'd1) ) )) ;
 sq_cut_reset_pre[18] <= ( sq_cut_on[18] && ( (current_cut_sq18id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq18id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_18>=2'd1) ) )) ;
 sq_cut_reset_pre[19] <= ( sq_cut_on[19] && ( (current_cut_sq19id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq19id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_19>=2'd1) ) )) ;
 sq_cut_reset_pre[20] <= ( sq_cut_on[20] && ( (current_cut_sq20id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq20id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_20>=2'd1) ) )) ;
 sq_cut_reset_pre[21] <= ( sq_cut_on[21] && ( (current_cut_sq21id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq21id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_21>=2'd1) ) )) ;
 sq_cut_reset_pre[22] <= ( sq_cut_on[22] && ( (current_cut_sq22id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq22id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_22>=2'd1) ) )) ;
 sq_cut_reset_pre[23] <= ( sq_cut_on[23] && ( (current_cut_sq23id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq23id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_23>=2'd1) ) )) ;
 sq_cut_reset_pre[24] <= ( sq_cut_on[24] && ( (current_cut_sq24id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq24id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_24>=2'd1) ) )) ;
 sq_cut_reset_pre[25] <= ( sq_cut_on[25] && ( (current_cut_sq25id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq25id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_25>=2'd1) ) )) ;
 sq_cut_reset_pre[26] <= ( sq_cut_on[26] && ( (current_cut_sq26id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq26id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_26>=2'd1) ) )) ;
 sq_cut_reset_pre[27] <= ( sq_cut_on[27] && ( (current_cut_sq27id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq27id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_27>=2'd1) ) )) ;
 sq_cut_reset_pre[28] <= ( sq_cut_on[28] && ( (current_cut_sq28id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq28id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_28>=2'd1) ) )) ;
 sq_cut_reset_pre[29] <= ( sq_cut_on[29] && ( (current_cut_sq29id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq29id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_29>=2'd1) ) )) ;
 sq_cut_reset_pre[30] <= ( sq_cut_on[30] && ( (current_cut_sq30id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq30id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_30>=2'd1) ) )) ;
 sq_cut_reset_pre[31] <= ( sq_cut_on[31] && ( (current_cut_sq31id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq31id_reg<current_cut_done_sqid_reg) && (sq_cut_reset_cnt_31>=2'd1) ) )) ;
 sq_cut_reset_cnt_00 <= (current_cut_sq00id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq00id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_00>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_00+1'd1) ) : sq_cut_reset_cnt_00 ;
 sq_cut_reset_cnt_01 <= (current_cut_sq01id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq01id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_01>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_01+1'd1) ) : sq_cut_reset_cnt_01 ;
 sq_cut_reset_cnt_02 <= (current_cut_sq02id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq02id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_02>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_02+1'd1) ) : sq_cut_reset_cnt_02 ;
 sq_cut_reset_cnt_03 <= (current_cut_sq03id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq03id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_03>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_03+1'd1) ) : sq_cut_reset_cnt_03 ;
 sq_cut_reset_cnt_04 <= (current_cut_sq04id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq04id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_04>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_04+1'd1) ) : sq_cut_reset_cnt_04 ;
 sq_cut_reset_cnt_05 <= (current_cut_sq05id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq05id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_05>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_05+1'd1) ) : sq_cut_reset_cnt_05 ;
 sq_cut_reset_cnt_06 <= (current_cut_sq06id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq06id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_06>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_06+1'd1) ) : sq_cut_reset_cnt_06 ;
 sq_cut_reset_cnt_07 <= (current_cut_sq07id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq07id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_07>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_07+1'd1) ) : sq_cut_reset_cnt_07 ;
 sq_cut_reset_cnt_08 <= (current_cut_sq08id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq08id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_08>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_08+1'd1) ) : sq_cut_reset_cnt_08 ;
 sq_cut_reset_cnt_09 <= (current_cut_sq09id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq09id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_09>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_09+1'd1) ) : sq_cut_reset_cnt_09 ;
 sq_cut_reset_cnt_10 <= (current_cut_sq10id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq10id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_10>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_10+1'd1) ) : sq_cut_reset_cnt_10 ;
 sq_cut_reset_cnt_11 <= (current_cut_sq11id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq11id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_11>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_11+1'd1) ) : sq_cut_reset_cnt_11 ;
 sq_cut_reset_cnt_12 <= (current_cut_sq12id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq12id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_12>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_12+1'd1) ) : sq_cut_reset_cnt_12 ;
 sq_cut_reset_cnt_13 <= (current_cut_sq13id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq13id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_13>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_13+1'd1) ) : sq_cut_reset_cnt_13 ;
 sq_cut_reset_cnt_14 <= (current_cut_sq14id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq14id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_14>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_14+1'd1) ) : sq_cut_reset_cnt_14 ;
 sq_cut_reset_cnt_15 <= (current_cut_sq15id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq15id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_15>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_15+1'd1) ) : sq_cut_reset_cnt_15 ;
 sq_cut_reset_cnt_16 <= (current_cut_sq16id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq16id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_16>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_16+1'd1) ) : sq_cut_reset_cnt_16 ;
 sq_cut_reset_cnt_17 <= (current_cut_sq17id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq17id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_17>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_17+1'd1) ) : sq_cut_reset_cnt_17 ;
 sq_cut_reset_cnt_18 <= (current_cut_sq18id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq18id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_18>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_18+1'd1) ) : sq_cut_reset_cnt_18 ;
 sq_cut_reset_cnt_19 <= (current_cut_sq19id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq19id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_19>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_19+1'd1) ) : sq_cut_reset_cnt_19 ;
 sq_cut_reset_cnt_20 <= (current_cut_sq20id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq20id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_20>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_20+1'd1) ) : sq_cut_reset_cnt_20 ;
 sq_cut_reset_cnt_21 <= (current_cut_sq21id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq21id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_21>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_21+1'd1) ) : sq_cut_reset_cnt_21 ;
 sq_cut_reset_cnt_22 <= (current_cut_sq22id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq22id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_22>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_22+1'd1) ) : sq_cut_reset_cnt_22 ;
 sq_cut_reset_cnt_23 <= (current_cut_sq23id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq23id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_23>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_23+1'd1) ) : sq_cut_reset_cnt_23 ;
 sq_cut_reset_cnt_24 <= (current_cut_sq24id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq24id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_24>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_24+1'd1) ) : sq_cut_reset_cnt_24 ;
 sq_cut_reset_cnt_25 <= (current_cut_sq25id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq25id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_25>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_25+1'd1) ) : sq_cut_reset_cnt_25 ;
 sq_cut_reset_cnt_26 <= (current_cut_sq26id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq26id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_26>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_26+1'd1) ) : sq_cut_reset_cnt_26 ;
 sq_cut_reset_cnt_27 <= (current_cut_sq27id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq27id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_27>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_27+1'd1) ) : sq_cut_reset_cnt_27 ;
 sq_cut_reset_cnt_28 <= (current_cut_sq28id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq28id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_28>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_28+1'd1) ) : sq_cut_reset_cnt_28 ;
 sq_cut_reset_cnt_29 <= (current_cut_sq29id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq29id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_29>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_29+1'd1) ) : sq_cut_reset_cnt_29 ;
 sq_cut_reset_cnt_30 <= (current_cut_sq30id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq30id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_30>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_30+1'd1) ) : sq_cut_reset_cnt_30 ;
 sq_cut_reset_cnt_31 <= (current_cut_sq31id_reg==current_cut_done_sqid_reg) ? 2'd0 : (current_cut_sq31id_reg<current_cut_done_sqid_reg) ? ((sq_cut_reset_cnt_31>=2'd1) ? 2'd0 : ( sq_cut_reset_cnt_31+1'd1) ) : sq_cut_reset_cnt_31 ;
 end
 else begin
 sq_cut_reset_pre[ 0] <= (current_cut_sq00id_reg==current_sqid_reg)&& sq_cut_on[ 0] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 1] <= (current_cut_sq01id_reg==current_sqid_reg)&& sq_cut_on[ 1] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 2] <= (current_cut_sq02id_reg==current_sqid_reg)&& sq_cut_on[ 2] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 3] <= (current_cut_sq03id_reg==current_sqid_reg)&& sq_cut_on[ 3] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 4] <= (current_cut_sq04id_reg==current_sqid_reg)&& sq_cut_on[ 4] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 5] <= (current_cut_sq05id_reg==current_sqid_reg)&& sq_cut_on[ 5] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 6] <= (current_cut_sq06id_reg==current_sqid_reg)&& sq_cut_on[ 6] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 7] <= (current_cut_sq07id_reg==current_sqid_reg)&& sq_cut_on[ 7] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 8] <= (current_cut_sq08id_reg==current_sqid_reg)&& sq_cut_on[ 8] && current_sqid_reg_vld ;
 sq_cut_reset_pre[ 9] <= (current_cut_sq09id_reg==current_sqid_reg)&& sq_cut_on[ 9] && current_sqid_reg_vld ;
 sq_cut_reset_pre[10] <= (current_cut_sq10id_reg==current_sqid_reg)&& sq_cut_on[10] && current_sqid_reg_vld ;
 sq_cut_reset_pre[11] <= (current_cut_sq11id_reg==current_sqid_reg)&& sq_cut_on[11] && current_sqid_reg_vld ;
 sq_cut_reset_pre[12] <= (current_cut_sq12id_reg==current_sqid_reg)&& sq_cut_on[12] && current_sqid_reg_vld ;
 sq_cut_reset_pre[13] <= (current_cut_sq13id_reg==current_sqid_reg)&& sq_cut_on[13] && current_sqid_reg_vld ;
 sq_cut_reset_pre[14] <= (current_cut_sq14id_reg==current_sqid_reg)&& sq_cut_on[14] && current_sqid_reg_vld ;
 sq_cut_reset_pre[15] <= (current_cut_sq15id_reg==current_sqid_reg)&& sq_cut_on[15] && current_sqid_reg_vld ;
 sq_cut_reset_pre[16] <= (current_cut_sq16id_reg==current_sqid_reg)&& sq_cut_on[16] && current_sqid_reg_vld ;
 sq_cut_reset_pre[17] <= (current_cut_sq17id_reg==current_sqid_reg)&& sq_cut_on[17] && current_sqid_reg_vld ;
 sq_cut_reset_pre[18] <= (current_cut_sq18id_reg==current_sqid_reg)&& sq_cut_on[18] && current_sqid_reg_vld ;
 sq_cut_reset_pre[19] <= (current_cut_sq19id_reg==current_sqid_reg)&& sq_cut_on[19] && current_sqid_reg_vld ;
 sq_cut_reset_pre[20] <= (current_cut_sq20id_reg==current_sqid_reg)&& sq_cut_on[20] && current_sqid_reg_vld ;
 sq_cut_reset_pre[21] <= (current_cut_sq21id_reg==current_sqid_reg)&& sq_cut_on[21] && current_sqid_reg_vld ;
 sq_cut_reset_pre[22] <= (current_cut_sq22id_reg==current_sqid_reg)&& sq_cut_on[22] && current_sqid_reg_vld ;
 sq_cut_reset_pre[23] <= (current_cut_sq23id_reg==current_sqid_reg)&& sq_cut_on[23] && current_sqid_reg_vld ;
 sq_cut_reset_pre[24] <= (current_cut_sq24id_reg==current_sqid_reg)&& sq_cut_on[24] && current_sqid_reg_vld ;
 sq_cut_reset_pre[25] <= (current_cut_sq25id_reg==current_sqid_reg)&& sq_cut_on[25] && current_sqid_reg_vld ;
 sq_cut_reset_pre[26] <= (current_cut_sq26id_reg==current_sqid_reg)&& sq_cut_on[26] && current_sqid_reg_vld ;
 sq_cut_reset_pre[27] <= (current_cut_sq27id_reg==current_sqid_reg)&& sq_cut_on[27] && current_sqid_reg_vld ;
 sq_cut_reset_pre[28] <= (current_cut_sq28id_reg==current_sqid_reg)&& sq_cut_on[28] && current_sqid_reg_vld ;
 sq_cut_reset_pre[29] <= (current_cut_sq29id_reg==current_sqid_reg)&& sq_cut_on[29] && current_sqid_reg_vld ;
 sq_cut_reset_pre[30] <= (current_cut_sq30id_reg==current_sqid_reg)&& sq_cut_on[30] && current_sqid_reg_vld ;
 sq_cut_reset_pre[31] <= (current_cut_sq31id_reg==current_sqid_reg)&& sq_cut_on[31] && current_sqid_reg_vld ;
 end
 end
 endmodule
 module wrapper_filter_rx_top ( clk , rst_n , clk_322 , rst_n_322 , params_current_sqid_reg_add, params_current_sqid_reg_cnt, params_current_sqid_reg_rst_cnt , params_current_sqid_reg_ro , params_filter_rst , tlp_cnt, params_frame_type_byte , market_pkt_cnt_o, mac_in_tcp_cnt, params_03e9_type , params_1389_type , params_07d0_type , rq_tlp_cnt, mac_rx_sop , mac_rx_eop , mac_rx_valid , mac_rx_data , mac_rx_empty , /* rmem_descriptor_reg , requestor_id , tlp_StData_o , tlp_StSop_o , tlp_StEop_o , tlp_StEmpty_o , tlp_StValid_o , tlp_StReady_i , st_fifo_hfull , st_fifo_full , st_fifo_empty , error_flag */ fifo_data_empty, fifo_data_out , fifo_data_vld, fifo_ready );
 input clk ;
 input rst_n ;
 input clk_322 ;
 input rst_n_322 ;
 input [3:0] params_current_sqid_reg_add ;
 input [3:0] params_current_sqid_reg_cnt ;
 input [31:0] params_current_sqid_reg_rst_cnt ;
 output [31:0] params_current_sqid_reg_ro ;
 input params_filter_rst ;
 output [31:0] tlp_cnt;
 input [ 15: 0] params_frame_type_byte ;
 input [15:0] params_03e9_type ;
 input [15:0] params_1389_type ;
 input [15:0] params_07d0_type ;
 input mac_rx_sop ;
 input mac_rx_eop ;
 input mac_rx_valid ;
 input [ 31: 0] mac_rx_data ;
 input [ 1: 0] mac_rx_empty ;
 /* input [159: 0] rmem_descriptor_reg ;
 input [ 15: 0] requestor_id ;
 output [255: 0] tlp_StData_o ;
 output tlp_StSop_o ;
 output tlp_StEop_o ;
 output [ 1: 0] tlp_StEmpty_o ;
 output tlp_StValid_o ;
 input tlp_StReady_i ;
 output st_fifo_hfull ;
 output st_fifo_full ;
 output st_fifo_empty ;
 output error_flag ;
 */ output fifo_data_empty;
 output [255:0] fifo_data_out ;
 output fifo_data_vld;
 input fifo_ready;
 output [63:0] market_pkt_cnt_o;
 output [31:0] mac_in_tcp_cnt;
 input [31:0] rq_tlp_cnt;
 wire [31:0] params_current_sqid_reg_ro ;
 wire [31:0] current_sqid_reg;
 wire current_sqid_reg_vld;
 wire [63:0] pkt_in_cnt_o;
 wire [63:0] market_pkt_cnt_o;
 wire [31:0] mac_in_tcp_cnt;
 wire [15:0] tcp_payload_len ;
 wire [31:0] sq_cut_flag ;
 wire [31:0] sq_cut_reset ;
 wire [31:0] tcp_sqmatch_flag ;
 wire [31:0] seq_err_flag ;
 wire [15:0] first_sync_len_byte ;
 wire st_rx_start ;
 wire [ 3: 0] st_rx_offset ;
 wire st_rx_end ;
 wire st_rx_valid ;
 wire [ 63: 0] st_rx_data ;
 wire [ 2: 0] st_rx_empty ;
 wire [ 15: 0] st_rx_cnt ;
 wire st_rx_ready ;
 wire [4:0] fir_rx_cstate;
 wire debug_st_shift_full_flag ;
 wire [3:0] debug_discard_calc_cnt1 ;
 wire [5:0] debug_st_shift_scnt ;
 wire debug_st_shift_en ;
 wire [31:0] error_flag ;
 wire [15:0] st_rx_cnt_reg ;
 wire [ 5:0] st_shift_ccnt ;
 parse_top_32ch parse_search_top ( .clk_322 ( clk_322 ) , .rst_n_322 ( rst_n_322 ) , .clk ( clk ) , .rst_n ( rst_n ) , .params_filter_rst (params_filter_rst), .mac_rx_sop ( mac_rx_sop ) , .mac_rx_eop ( mac_rx_eop ) , .mac_rx_vld ( mac_rx_valid ) , .mac_rx_data ( mac_rx_data ) , .mac_rx_byte ( mac_rx_empty ) , .cut_flag ( sq_cut_flag ) , .cut_reset ( sq_cut_reset), .fivetuplematch_o ( tcp_sqmatch_flag ) , .seq_err_flag_o ( seq_err_flag ) , .first_market_byte_o ( first_sync_len_byte ) , .market_pkt_vld_o (st_rx_valid ), .market_pkt_sop_o (st_rx_start ), .market_pkt_eop_o (st_rx_end ), .market_pkt_offset_o (st_rx_offset ), .market_pkt_byte_o (st_rx_empty ), .market_pkt_data_o (st_rx_data ), .market_pkt_ready (st_rx_ready ), .tcp_payload_len_o ( tcp_payload_len ) , .tcp_payload_byte_cnt_o ( st_rx_cnt ) , .fir_rx_cstate (fir_rx_cstate), .debug_discard_calc_cnt1(debug_discard_calc_cnt1), .debug_st_shift_full_flag(debug_st_shift_full_flag), .params_current_sqid_reg_ro (params_current_sqid_reg_ro), .current_sqid_reg (current_sqid_reg), .current_sqid_reg_vld (current_sqid_reg_vld), .debug_st_shift_scnt(debug_st_shift_scnt) , .debug_st_shift_en (debug_st_shift_en) , .error_flag ( error_flag ) , .st_rx_cnt_reg (st_rx_cnt_reg), .st_shift_ccnt (st_shift_ccnt), .pkt_in_cnt_o (pkt_in_cnt_o), .mac_in_tcp_cnt (mac_in_tcp_cnt), .rq_tlp_cnt (rq_tlp_cnt), .tlp_cnt(tlp_cnt), .market_pkt_cnt_o (market_pkt_cnt_o) );
 filter_rx_top filter_rx_top ( .clk ( clk ) , .rst_n ( rst_n ) , .params_current_sqid_reg_add (params_current_sqid_reg_add), .params_current_sqid_reg_cnt (params_current_sqid_reg_cnt), .params_current_sqid_reg_rst_cnt (params_current_sqid_reg_rst_cnt), .fir_rx_cstate (fir_rx_cstate), .debug_discard_calc_cnt1(debug_discard_calc_cnt1), .debug_st_shift_full_flag(debug_st_shift_full_flag), .tlp_cnt(tlp_cnt), .debug_st_shift_scnt(debug_st_shift_scnt) , .debug_st_shift_en (debug_st_shift_en) , .st_rx_cnt_reg (st_rx_cnt_reg), .st_shift_ccnt (st_shift_ccnt), .params_current_sqid_reg_ro (params_current_sqid_reg_ro), .current_sqid_reg (current_sqid_reg), .current_sqid_reg_vld (current_sqid_reg_vld), .params_filter_rst (params_filter_rst), .params_frame_type_byte (params_frame_type_byte ) , .params_03e9_type (params_03e9_type), .params_1389_type (params_1389_type), .params_07d0_type (params_07d0_type), .st_rx_start ( st_rx_start ) , .st_rx_offset ( st_rx_offset ) , .st_rx_end ( st_rx_end ) , .st_rx_valid ( st_rx_valid ) , .st_rx_data ( st_rx_data ) , .st_rx_empty ( st_rx_empty ) , .st_rx_cnt ( st_rx_cnt ) , .st_rx_ready ( st_rx_ready ) , .first_sync_len_byte ( first_sync_len_byte ) , .tcp_sqmatch_flag ( tcp_sqmatch_flag ) , .seq_err_flag ( seq_err_flag ) , .error_flag ( error_flag ) , .sq_cut_flag ( sq_cut_flag ) , .sq_cut_reset ( sq_cut_reset), .tcp_payload_len ( tcp_payload_len ) , .fifo_data_empty (fifo_data_empty), .fifo_data_out (fifo_data_out ), .fifo_data_vld (fifo_data_vld), .fifo_ready (fifo_ready) );
 endmodule
 module parse_search_32ch ( clk, rst_n, mac_st_rx_vld, mac_st_rx_data, mac_st_rx_sop, mac_st_rx_eop, mac_st_rx_byte, cut_flag, cut_reset, tcp_payload_len_o, tcp_payload_byte_cnt_o, fivetuplematch_o, seq_err_flag_o, market_pkt_vld_o, market_pkt_data_o, market_pkt_sop_o, market_pkt_offset_o, market_pkt_eop_o, market_pkt_byte_o, first_market_byte_o, wfir_rx_cstate, wdebug_st_shift_full_flag , wdebug_discard_calc_cnt1 , wst_rx_cnt_reg , wst_shift_ccnt , wdebug_st_shift_scnt , wdebug_st_shift_en , error_flag , params_current_sqid_reg_ro , current_sqid_reg , current_sqid_reg_vld , pkt_in_cnt_o, mac_in_tcp_cnt, tlp_cnt, rq_tlp_cnt, market_pkt_cnt_o );
 localparam [2:0] IDLE = 3'b000;
 localparam [2:0] PARSE = 3'b001;
 localparam [2:0] PAYLOAD_OUT = 3'b011;
 localparam [2:0] SEARCH = 3'b010;
 input clk;
 input rst_n;
 input mac_st_rx_vld;
 input [63:0] mac_st_rx_data;
 input mac_st_rx_sop;
 input mac_st_rx_eop;
 input [2:0] mac_st_rx_byte;
 input [31:0] cut_flag;
 input [31:0] cut_reset;
 output [15:0] tcp_payload_len_o;
 output [15:0] tcp_payload_byte_cnt_o;
 output [31:0] fivetuplematch_o;
 output [31:0] seq_err_flag_o;
 output market_pkt_vld_o;
 output [63:0] market_pkt_data_o;
 output market_pkt_sop_o;
 output [3:0] market_pkt_offset_o;
 output market_pkt_eop_o;
 output [2:0] market_pkt_byte_o;
 output [15:0] first_market_byte_o;
 input [4:0] wfir_rx_cstate;
 input wdebug_st_shift_full_flag ;
 input [3:0] wdebug_discard_calc_cnt1 ;
 input [15:0] wst_rx_cnt_reg ;
 input [ 5:0] wst_shift_ccnt ;
 input [5:0] wdebug_st_shift_scnt ;
 input wdebug_st_shift_en ;
 input [31:0] error_flag ;
 input [31:0 ] params_current_sqid_reg_ro ;
 input [31:0 ] current_sqid_reg ;
 input current_sqid_reg_vld ;
 output [63:0] pkt_in_cnt_o;
 output [31:0] mac_in_tcp_cnt;
 input [31:0] tlp_cnt;
 input [31:0] rq_tlp_cnt;
 output [63:0] market_pkt_cnt_o;
 reg [63:0] pkt_in_cnt_o;
 reg [31:0] mac_in_tcp_cnt;
 reg [63:0] market_pkt_cnt_o;
 reg [15:0] tcp_payload_byte_cnt_o;
 reg [31:0] fivetuplematch_o;
 reg [31:0] seq_err_flag_o;
 reg market_pkt_vld_o;
 reg [63:0] market_pkt_data_o;
 reg market_pkt_sop_o;
 reg [3:0] market_pkt_offset_o;
 reg market_pkt_eop_o;
 reg [2:0] market_pkt_byte_o;
 reg [15:0] first_market_byte_o;
 reg [2:0] cur_state;
 reg [2:0] next_state;
 reg [103:0] fivetuple_pre [0:31] ;
 reg [103:0] fivetuple_cur = 104'b0;
 reg [135:0] fivetuple_seq_pre [0:31] ;
 wire [135:0] fivetuple_seq_cur ;
 reg [135:0] fivetuple_cur_nex_seq;
 reg [31:0] cut_keep = {32{1'b0}};
 reg [31:0] cut_start = {32{1'b0}};
 wire [31:0] match_flag;
 wire [31:0] seq_err_flag;
 reg is_ipv4;
 reg is_tcp_norm;
 reg is_tcp_vlan;
 wire is_tcp;
 reg is_vlan;
 reg is_ipv4_flag = 1'd0 ;
 reg is_tcp_flag = 1'd0 ;
 reg short_pkt;
 reg [31:0] sip;
 reg [31:0] dip;
 reg [7:0] pro;
 reg [15:0] sp;
 reg [15:0] dp;
 reg parse_fivetuple_done;
 wire [15:0] pkt_total_len;
 reg [15:0] ip_total_len;
 reg [5:0] ip_head_len;
 reg [5:0] tcp_head_len;
 reg [6:0] tcp_head_offset;
 reg tcp_head_start;
 reg [6:0] payload_head_offset;
 reg payload_head_start;
 reg payload_head_flag;
 reg [31:0] tcp_seq;
 reg [31:0] tcp_seq_reg;
 wire [31:0] next_seq;
 reg [5:0] tcp_head_len_seq;
 reg tcp_head_start_dly ;
 reg tcp_head_start_dly2;
 reg [63:0] payload;
 reg [63:0] payload_dly;
 reg payload_start;
 reg [63:0] mac_st_rx_data_dly;
 reg [63:0] mac_st_rx_data_dly2;
 wire mac_rx_sop;
 wire mac_rx_eop;
 reg [15:0] first_market_byte;
 reg search_sop;
 reg [2:0] search_offset;
 reg [11:0] pkt_byte_cnt = 12'd0;
 assign mac_rx_sop = mac_st_rx_vld & mac_st_rx_sop;
 assign mac_rx_eop = mac_st_rx_vld & mac_st_rx_eop;
 always @ (posedge clk) if(mac_st_rx_vld) begin
 mac_st_rx_data_dly <= mac_st_rx_data;
 mac_st_rx_data_dly2 <= mac_st_rx_data_dly;
 end
 always @ (posedge clk) if(mac_rx_eop) pkt_byte_cnt <= 12'd0;
 else if(mac_st_rx_vld) pkt_byte_cnt <= pkt_byte_cnt + 12'd8;
 reg [15:0] tcp_payload_len;
 assign tcp_payload_len_o = ip_total_len - ip_head_len - tcp_head_len;
 always @(posedge clk) if(!rst_n) cur_state <= IDLE;
 else cur_state <= next_state;
 always @(*) case(cur_state) IDLE: begin
 if(mac_rx_sop) next_state = PARSE;
 else next_state = IDLE;
 end
 PARSE: begin
 if(!is_ipv4_flag || !is_tcp_flag ) next_state = IDLE;
 else if(parse_fivetuple_done&&mac_st_rx_vld) begin
 if(|match_flag) next_state = PAYLOAD_OUT;
 else next_state = SEARCH;
 end
 else next_state = PARSE;
 end
 PAYLOAD_OUT: begin
 if(mac_rx_eop) next_state = IDLE;
 else next_state = PAYLOAD_OUT;
 end
 SEARCH: begin
 if(mac_rx_eop) next_state = IDLE;
 else next_state = SEARCH;
 end
 default: next_state = IDLE;
 endcase generate genvar ch;
 for(ch = 0;
 ch < 32;
 ch=ch+1) begin
: gen_fivetuplematch always @(posedge clk) begin
 if((fivetuple_seq_pre[ch] == fivetuple_seq_cur)&& cut_start[ch]&&mac_st_rx_vld) cut_keep[ch] <= 1'b0;
 else if (cut_reset[ch]) cut_keep[ch] <= 1'b0;
 else if(cut_flag[ch]) cut_keep[ch] <= 1'b1;
 end
 always @(posedge clk) begin
 if(cut_flag[ch]) fivetuple_seq_pre[ch] <= fivetuple_cur_nex_seq;
 end
 assign match_flag[ch] = cut_keep[ch] && (fivetuple_seq_pre[ch] == fivetuple_seq_cur) && cut_start[ch]&&mac_st_rx_vld;
 assign seq_err_flag[ch] = cut_keep[ch] && (fivetuple_seq_pre[ch][103:0] == fivetuple_seq_cur[103:0])&&(fivetuple_seq_pre[ch][135:104] != fivetuple_seq_cur[135:104]) && cut_start[ch]&& mac_st_rx_vld;
 always @(posedge clk) begin
 if(!rst_n) fivetuplematch_o[ch] <= 1'b0;
 else if(market_pkt_eop_o&&market_pkt_vld_o) fivetuplematch_o[ch] <= 1'b0;
 else if(match_flag[ch]) fivetuplematch_o[ch] <= 1'b1;
 end
 always @(posedge clk) begin
 if(!rst_n) seq_err_flag_o[ch] <= 1'b0;
 else if(market_pkt_eop_o&&market_pkt_vld_o) seq_err_flag_o[ch] <= 1'b0;
 else if(seq_err_flag[ch]) seq_err_flag_o[ch] <= 1'b1;
 end
 end
 endgenerate reg [7:0] pkt_cycle_cnt = 8'b0;
 always @(posedge clk) begin
 if(mac_rx_eop) pkt_cycle_cnt <= 8'b0;
 else if(mac_st_rx_vld) pkt_cycle_cnt <= pkt_cycle_cnt + 1'b1;
 end
 always @(posedge clk) begin
 if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd1)) begin
 if(mac_st_rx_data[31:16]==16'h8100) is_vlan <= 1'b1;
 else is_vlan <= 1'b0;
 end
 end
 always @(posedge clk) begin
 if(mac_rx_eop) is_ipv4 <= 1'b0;
 else if(is_vlan && mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2)&& (mac_st_rx_data[63:48]== 16'h0800)) is_ipv4 <= 1'b1;
 else if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd1) && (mac_st_rx_data[31:16]== 16'h0800)) is_ipv4 <= 1'b1;
 end
 always @(posedge clk) begin
 if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd3)) begin
 if(!is_ipv4) is_ipv4_flag <= 1'b0;
 else is_ipv4_flag <= 1'b1;
 end
 else is_ipv4_flag <= 1'b1;
 end
 always @(posedge clk) begin
 if(mac_rx_eop) is_tcp_norm <= 1'b0;
 else if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2)&&(mac_st_rx_data[7:0]== 8'h06)) is_tcp_norm <= 1'b1;
 end
 reg is_tcp_vlan_flag;
 always @(*) begin
 if(is_vlan && mac_st_rx_vld &&(pkt_cycle_cnt == 8'd3)&&(mac_st_rx_data[39:32]== 8'h06)) is_tcp_vlan_flag = 1'b1;
 else is_tcp_vlan_flag = 1'b0;
 end
 always @ (posedge clk) if(mac_rx_eop) is_tcp_vlan <= 1'b0;
 else if(is_tcp_vlan_flag) is_tcp_vlan <= 1'b1;
 assign is_tcp = is_tcp_vlan | is_tcp_vlan_flag | is_tcp_norm;
 always @(posedge clk) begin
 if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd3)) begin
 if(!is_tcp) is_tcp_flag <= 1'b0;
 else is_tcp_flag <= 1'b1;
 end
 else begin
 is_tcp_flag <= 1'b1;
 end
 end
 wire is_ipv4_norm;
 assign is_ipv4_norm = is_ipv4 && !is_vlan;
 always @(posedge clk) begin
 if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd1) && (mac_st_rx_data[31:16]== 16'h0800))begin
 tcp_head_offset <= {mac_st_rx_data[11:8],2'b00} + 7'd14;
 ip_head_len <= {mac_st_rx_data[11:8],2'b00};
 end
 else if(is_vlan && mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2) && (mac_st_rx_data[63:48]== 16'h0800)) begin
 ip_head_len <= {mac_st_rx_data[43:40],2'b00};
 tcp_head_offset <= {mac_st_rx_data[43:40],2'b00} + 7'd18;
 end
 end
 always @(posedge clk) if(is_ipv4_norm) begin
 if(mac_st_rx_vld) begin
 if(pkt_cycle_cnt == 8'd2) begin
 pro <= mac_st_rx_data[7:0];
 ip_total_len <= mac_st_rx_data[63:48];
 end
 else if(pkt_cycle_cnt == 8'd3) begin
 sip <= mac_st_rx_data[47:16];
 end
 else if(pkt_cycle_cnt == 8'd4) begin
 dip <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 end
 end
 else if(is_vlan) begin
 if(mac_st_rx_vld) begin
 if(pkt_cycle_cnt == 8'd2) begin
 ip_total_len <= mac_st_rx_data[31:16];
 end
 else if(pkt_cycle_cnt == 8'd3) begin
 pro <= mac_st_rx_data[39:32];
 end
 else if(pkt_cycle_cnt == 8'd4) begin
 dip <= mac_st_rx_data[47:16];
 sip <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 end
 end
 always @(posedge clk) begin
 if ( ~is_tcp || ~is_ipv4 ) begin
 tcp_head_start <= 1'd0 ;
 end
 else begin
 case(tcp_head_offset[6:3]) 4'd4: begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd3)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 4'd5: begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd4)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 4'd6: begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd5)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 4'd7: begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd6)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 4'd8: begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd7)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 4'd9: begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd8)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 default : begin
 if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd3)) tcp_head_start <= 1'b1;
 else if(mac_st_rx_vld) tcp_head_start <= 1'b0;
 end
 endcase end
 end
 always @(posedge clk) if(!rst_n) begin
 tcp_head_start_dly <= 1'b0;
 tcp_head_start_dly2 <= 1'b0;
 end
 else if(mac_st_rx_vld) begin
 tcp_head_start_dly <= tcp_head_start ;
 tcp_head_start_dly2 <= tcp_head_start_dly;
 end
 always @(posedge clk) case(tcp_head_offset[2:0]) 3'b010: begin
 if(tcp_head_start & mac_st_rx_vld) begin
 if(pkt_cycle_cnt == 8'd4) fivetuple_cur <= {sip,mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48],pro,mac_st_rx_data[47:16]};
 else fivetuple_cur <= {sip,dip,pro,mac_st_rx_data[47:16]};
 end
 end
 3'b110: begin
 if(tcp_head_start_dly & mac_st_rx_vld) begin
 fivetuple_cur <= {sip,dip,pro,mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 end
 default: begin
 if(tcp_head_start & mac_st_rx_vld) begin
 fivetuple_cur <= {sip,dip,pro,mac_st_rx_data[47:16]};
 end
 end
 endcase always @(*) case(tcp_head_offset[2:0]) 3'b010: begin
 if(tcp_head_start_dly & mac_st_rx_vld) begin
 tcp_seq = {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 else begin
 tcp_seq = 32'd0;
 end
 end
 3'b110: begin
 if(tcp_head_start_dly2 & mac_st_rx_vld) begin
 tcp_seq= {mac_st_rx_data_dly[47:16]};
 end
 else begin
 tcp_seq = 32'd0;
 end
 end
 default: begin
 if(tcp_head_start_dly & mac_st_rx_vld) begin
 tcp_seq = {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 else begin
 tcp_seq = 32'd0;
 end
 end
 endcase assign next_seq = tcp_seq_reg + tcp_payload_len_o;
 assign fivetuple_seq_cur = {fivetuple_cur,tcp_seq};
 always @(posedge clk) fivetuple_cur_nex_seq <= {fivetuple_cur,next_seq};
 always @(posedge clk) if(mac_rx_eop) parse_fivetuple_done <= 1'b0;
 else begin
 case(tcp_head_offset[2:0]) 3'b010: begin
 if(tcp_head_start & mac_st_rx_vld) begin
 parse_fivetuple_done <= 1'b1;
 end
 end
 3'b110: begin
 if(tcp_head_start_dly&&mac_st_rx_vld) begin
 parse_fivetuple_done <= 1'b1;
 end
 end
 default: begin
 if(tcp_head_start & mac_st_rx_vld) begin
 parse_fivetuple_done <= 1'b1;
 end
 end
 endcase end
 reg [6:0] tcp_head_offset_dly;
 always @ (posedge clk) begin
 tcp_head_offset_dly <= tcp_head_offset;
 end
 generate genvar chn;
 for(chn = 0;
 chn < 32;
 chn=chn+1) begin
: gen_cut_start always @(posedge clk) if(cut_flag[chn] && !tcp_head_start) cut_start[chn] <= 1'b0;
 else if(cut_keep[chn] | cut_flag[chn]) begin
 case(tcp_head_offset[2:0]) 3'b010: begin
 if(tcp_head_start & mac_st_rx_vld) begin
 cut_start[chn] <= 1'b1;
 end
 end
 3'b110: begin
 if(tcp_head_start_dly&&mac_st_rx_vld) begin
 cut_start[chn] <= 1'b1;
 end
 end
 default: begin
 if(tcp_head_start & mac_st_rx_vld ) begin
 cut_start[chn] <= 1'b1;
 end
 end
 endcase end
 else cut_start[chn] <= 1'b0;
 end
 endgenerate always @(posedge clk) if(mac_rx_eop) begin
 payload_head_flag <= 1'b0;
 end
 else begin
 case(tcp_head_offset[2:0]) 3'b010: begin
 if(tcp_head_start_dly & mac_st_rx_vld) begin
 sp <= mac_st_rx_data_dly[47:32];
 dp <= mac_st_rx_data_dly[31:16];
 payload_head_offset <= {mac_st_rx_data[15:12],2'b00} + tcp_head_offset;
 payload_head_flag <= 1'b1;
 tcp_head_len <= {mac_st_rx_data[15:12],2'b00};
 tcp_seq_reg <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 end
 3'b110: begin
 if(tcp_head_start_dly2 & mac_st_rx_vld) begin
 sp <= mac_st_rx_data_dly2[15:0];
 dp <= mac_st_rx_data_dly[63:48];
 payload_head_offset <= {mac_st_rx_data[47:44],2'b00} + tcp_head_offset;
 payload_head_flag <= 1'b1;
 tcp_head_len <= {mac_st_rx_data[47:44],2'b00};
 tcp_seq_reg <= {mac_st_rx_data_dly[47:16]};
 end
 end
 default: begin
 if(tcp_head_start_dly & mac_st_rx_vld ) begin
 sp <= mac_st_rx_data_dly[47:32];
 dp <= mac_st_rx_data_dly[31:16];
 payload_head_offset <= {mac_st_rx_data[15:12],2'b00} + tcp_head_offset;
 payload_head_flag <= 1'b1;
 tcp_head_len <= {mac_st_rx_data[15:12],2'b00};
 tcp_seq_reg <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
 end
 end
 endcase end
 always @(*) begin
 case(payload_head_offset[6:3]) 4'd6: begin
 if(payload_head_flag && mac_st_rx_vld && (pkt_cycle_cnt == 8'd6)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd7: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd7)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd8: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd8)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd9: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd9)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd10: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd10)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd11: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd11)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd4: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd4)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd5: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd5)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd12: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd12)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 4'd13: begin
 if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd13)) payload_head_start = 1'b1;
 else payload_head_start = 1'b0;
 end
 default : begin
 payload_head_start = 1'b0;
 end
 endcase end
 always @(posedge clk) if(mac_rx_eop & payload_head_start & mac_st_rx_vld) tcp_payload_byte_cnt_o <= 4'd8 - mac_st_rx_byte - payload_head_offset[2:0];
 else if(mac_rx_eop) tcp_payload_byte_cnt_o <= tcp_payload_byte_cnt_o + (4'd8 - mac_st_rx_byte);
 else if(payload_head_start & mac_st_rx_vld) tcp_payload_byte_cnt_o <= 4'd8 - payload_head_offset[2:0];
 else if(mac_st_rx_vld) tcp_payload_byte_cnt_o <= tcp_payload_byte_cnt_o + 4'd8;
 always @(*) if(cur_state == SEARCH) begin
 if(mac_st_rx_vld && ({mac_st_rx_data_dly[47:32],mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd2;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[39:24],mac_st_rx_data_dly[7:0],mac_st_rx_data[63:40]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd3;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[31:16],mac_st_rx_data[63:32]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd4;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[23:8],mac_st_rx_data[55:24]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd5;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[15:0],mac_st_rx_data[47:16]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd6;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[7:0],mac_st_rx_data[63:56],mac_st_rx_data[39:8]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd7;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[63:48],mac_st_rx_data_dly[31:0]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd0;
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[55:40],mac_st_rx_data_dly[23:0],mac_st_rx_data[63:56]}== 48'h02000100044c)) begin
 search_sop = 1'b1;
 search_offset = 3'd1;
 end
 else begin
 search_sop = 1'b0;
 search_offset = 3'd0;
 end
 end
 else begin
 search_sop = 1'b0;
 search_offset = 3'd0;
 end
 always @(posedge clk) if(mac_st_rx_vld && ({mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data_dly[31:16];
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[7:0],mac_st_rx_data[63:40]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data_dly[23:8];
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data[63:32]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data_dly[15:0];
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data[55:24]}== 32'h0100044c)) begin
 first_market_byte_o <= {mac_st_rx_data_dly[7:0],mac_st_rx_data[63:56]};
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data[47:16]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data[63:48];
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data[39:8]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data[55:40];
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[31:0]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data_dly[47:32];
 end
 else if(mac_st_rx_vld && ({mac_st_rx_data_dly[23:0],mac_st_rx_data[63:56]}== 32'h0100044c)) begin
 first_market_byte_o <= mac_st_rx_data_dly[39:24];
 end
 reg search_sop_inv = 1'b0;
 always @(posedge clk) if(cur_state == PAYLOAD_OUT) begin
 market_pkt_sop_o <= payload_head_start;
 market_pkt_offset_o <= payload_head_offset[2:0];
 market_pkt_vld_o <= mac_st_rx_vld & (payload_start|payload_head_start);
 market_pkt_data_o <= mac_st_rx_data;
 end
 else if(cur_state == SEARCH) begin
 market_pkt_sop_o <= search_sop & mac_st_rx_vld && (search_sop_inv == 1'b0);
 market_pkt_offset_o <= search_offset;
 market_pkt_vld_o <= mac_st_rx_vld & (payload_start | search_sop );
 market_pkt_data_o <= mac_st_rx_data;
 end
 else begin
 market_pkt_sop_o <= 1'b0;
 market_pkt_offset_o <= 3'b0;
 market_pkt_vld_o <= 1'b0;
 market_pkt_data_o <= 64'b0;
 end
 always @(posedge clk) if(cur_state == SEARCH) begin
 if(search_sop & mac_st_rx_vld) search_sop_inv <= 1'b1;
 end
 else search_sop_inv <= 5'b0;
 wire payload_flag;
 always @(posedge clk) if(mac_rx_eop) payload_start <= 1'b0;
 else if((cur_state == PAYLOAD_OUT) && payload_head_start) payload_start <= 1'b1;
 else if((cur_state == SEARCH) && search_sop) payload_start <= 1'b1;
 assign payload_flag = payload_start || ((cur_state == PAYLOAD_OUT) && payload_head_start) || ((cur_state == SEARCH) && search_sop);
 always @(posedge clk) begin
 market_pkt_eop_o <= mac_st_rx_eop ;
 market_pkt_byte_o <= mac_st_rx_byte;
 end
 always @(posedge clk) if(!rst_n) pkt_in_cnt_o <= 'd0;
 else if(mac_rx_sop) pkt_in_cnt_o <= pkt_in_cnt_o + 1'b1;
 always @(posedge clk) if(!rst_n) market_pkt_cnt_o <= 64'd0;
 else if(market_pkt_sop_o&&market_pkt_vld_o) market_pkt_cnt_o <= market_pkt_cnt_o + 1'b1;
 always @(posedge clk) if(!rst_n) mac_in_tcp_cnt <= 32'd0;
 else if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2)&&(mac_st_rx_data[7:0]==8'h06)) mac_in_tcp_cnt <= mac_in_tcp_cnt + 1'b1;
 endmodule
 module parse_top_32ch ( clk_322, rst_n_322, clk, rst_n, params_filter_rst, mac_rx_vld, mac_rx_data, mac_rx_sop, mac_rx_eop, mac_rx_byte, cut_flag, cut_reset, tcp_payload_len_o, tcp_payload_byte_cnt_o, fivetuplematch_o, seq_err_flag_o, market_pkt_ready, market_pkt_vld_o, market_pkt_data_o, market_pkt_sop_o, market_pkt_offset_o, market_pkt_eop_o, market_pkt_byte_o, first_market_byte_o, tlp_cnt, rq_tlp_cnt, fir_rx_cstate, debug_st_shift_full_flag , debug_discard_calc_cnt1 , st_rx_cnt_reg , st_shift_ccnt , debug_st_shift_scnt , debug_st_shift_en , params_current_sqid_reg_ro , current_sqid_reg , current_sqid_reg_vld , error_flag, pkt_in_cnt_o, mac_in_tcp_cnt, market_pkt_cnt_o );
 input clk_322;
 input rst_n_322;
 input clk;
 input rst_n;
 input params_filter_rst;
 input mac_rx_vld;
 input [31:0] mac_rx_data;
 input mac_rx_sop;
 input mac_rx_eop;
 input [1:0] mac_rx_byte;
 input [31:0] cut_flag;
 input [31:0] cut_reset;
 output [15:0] tcp_payload_len_o;
 output [15:0] tcp_payload_byte_cnt_o;
 output [31:0] fivetuplematch_o;
 output [31:0] seq_err_flag_o;
 input market_pkt_ready;
 output market_pkt_vld_o;
 output [63:0] market_pkt_data_o;
 output market_pkt_sop_o;
 output [3:0] market_pkt_offset_o;
 output market_pkt_eop_o;
 output [2:0] market_pkt_byte_o;
 output [15:0] first_market_byte_o;
 input [31:0] tlp_cnt;
 input [31:0] rq_tlp_cnt;
 input [4:0] fir_rx_cstate;
 input debug_st_shift_full_flag ;
 input [3:0] debug_discard_calc_cnt1 ;
 input [15:0] st_rx_cnt_reg ;
 input [ 5:0] st_shift_ccnt ;
 input [5:0] debug_st_shift_scnt ;
 input debug_st_shift_en ;
 input [31:0 ] params_current_sqid_reg_ro ;
 input [31:0 ] current_sqid_reg ;
 input current_sqid_reg_vld ;
 input [31:0] error_flag;
 output [63:0] pkt_in_cnt_o;
 output [31:0] mac_in_tcp_cnt;
 output [63:0] market_pkt_cnt_o;
 wire st_rx_vld;
 wire [63:0] st_rx_data;
 wire st_rx_sop;
 wire st_rx_eop;
 wire [2:0] st_rx_byte;
 wire soft_rstn_322;
 wire soft_rstn;
 reg [11:0] soft_rstn_keep;
 reg [11:0] soft_rstn_322_keep;
 always @ (posedge clk) if(params_filter_rst) soft_rstn_keep <= 12'h0;
 else soft_rstn_keep <= {soft_rstn_keep[10:0],1'b1};
 assign soft_rstn = soft_rstn_keep[11];
 always @ (posedge clk_322) if(params_filter_rst) soft_rstn_322_keep <= 12'h0;
 else soft_rstn_322_keep <= {soft_rstn_322_keep[10:0],1'b1};
 assign soft_rstn_322 = soft_rstn_322_keep[11];
 wrapper_mac_rx_fifo u_wrapper_mac_rx_fifo ( .clk_322 (clk_322), .rst_n_322 (rst_n_322&&soft_rstn_322), .mac_rx_data (mac_rx_data), .mac_rx_bytes (mac_rx_byte), .mac_rx_vld (mac_rx_vld), .mac_rx_sop (mac_rx_sop), .mac_rx_eop (mac_rx_eop), .clk_250 (clk), .market_pkt_ready (market_pkt_ready), .rx_fifo_data_o (st_rx_data), .rx_fifo_bytes_o (st_rx_byte), .rx_fifo_vld_o (st_rx_vld), .rx_fifo_sop_o (st_rx_sop), .rx_fifo_eop_o (st_rx_eop) );
 parse_search_32ch u_parse_search( .clk (clk), .rst_n (rst_n&&soft_rstn), .wfir_rx_cstate (fir_rx_cstate), .wdebug_st_shift_full_flag( debug_st_shift_full_flag) , .wdebug_discard_calc_cnt1 (debug_discard_calc_cnt1), .wst_rx_cnt_reg (st_rx_cnt_reg), .wst_shift_ccnt (st_shift_ccnt), .wdebug_st_shift_scnt (debug_st_shift_scnt), .wdebug_st_shift_en (debug_st_shift_en), .error_flag (error_flag), .params_current_sqid_reg_ro ( params_current_sqid_reg_ro ), .current_sqid_reg (current_sqid_reg ), .current_sqid_reg_vld (current_sqid_reg_vld), .mac_st_rx_vld (st_rx_vld), .mac_st_rx_data (st_rx_data), .mac_st_rx_sop (st_rx_sop), .mac_st_rx_eop (st_rx_eop), .mac_st_rx_byte (st_rx_byte), .cut_flag (cut_flag), .cut_reset (cut_reset), .tcp_payload_len_o (tcp_payload_len_o), .tcp_payload_byte_cnt_o (tcp_payload_byte_cnt_o), .fivetuplematch_o (fivetuplematch_o), .seq_err_flag_o (seq_err_flag_o), .market_pkt_vld_o (market_pkt_vld_o), .market_pkt_data_o (market_pkt_data_o), .market_pkt_sop_o (market_pkt_sop_o), .market_pkt_offset_o (market_pkt_offset_o), .market_pkt_eop_o (market_pkt_eop_o), .market_pkt_byte_o (market_pkt_byte_o), .first_market_byte_o (first_market_byte_o), .pkt_in_cnt_o (pkt_in_cnt_o), .tlp_cnt (tlp_cnt), .rq_tlp_cnt(rq_tlp_cnt), .mac_in_tcp_cnt (mac_in_tcp_cnt), .market_pkt_cnt_o (market_pkt_cnt_o) );
 endmodule
 module wrapper_mac_rx_fifo( clk_322, rst_n_322, mac_rx_data, mac_rx_bytes, mac_rx_vld, mac_rx_sop, mac_rx_eop, clk_250, market_pkt_ready, rx_fifo_data_o, rx_fifo_bytes_o, rx_fifo_vld_o, rx_fifo_sop_o, rx_fifo_eop_o );
 input clk_322;
 input rst_n_322;
 input [31:0] mac_rx_data;
 input [1:0] mac_rx_bytes;
 input mac_rx_vld;
 input mac_rx_sop;
 input mac_rx_eop;
 input clk_250;
 input market_pkt_ready;
 output [63:0] rx_fifo_data_o;
 output [2:0] rx_fifo_bytes_o;
 output rx_fifo_vld_o;
 output rx_fifo_sop_o;
 output rx_fifo_eop_o;
 wire rx_fifo_full;
 wire rx_fifo_empty;
 wire [69:0] rx_fifo_wrdata;
 wire [69:0] rx_fifo_rddata;
 reg rx_fifo_wren;
 wire rx_fifo_rden;
 reg vld_flag;
 reg [35:0] data_keep;
 reg [2:0] rx_fifo_byte;
 reg [63:0] rx_fifo_data;
 wire [1:0] mac_rx_empty;
 reg rx_fifo_eop;
 reg rx_fifo_sop;
 assign mac_rx_empty = 3'd4 - mac_rx_bytes;
 always @ (posedge clk_322) if(!rst_n_322) vld_flag <= 1'b0;
 else if(mac_rx_vld & mac_rx_eop) vld_flag <= 1'b0;
 else if(mac_rx_vld) vld_flag <= ~vld_flag;
 always @ (posedge clk_322) if(mac_rx_vld && !vld_flag) data_keep <= {mac_rx_sop,mac_rx_eop,mac_rx_empty,mac_rx_data};
 always @ (posedge clk_322) if(mac_rx_vld && mac_rx_eop && vld_flag) rx_fifo_byte <= {1'b0,mac_rx_empty};
 else if(mac_rx_vld && mac_rx_eop) rx_fifo_byte <= {1'b1,mac_rx_empty};
 else rx_fifo_byte <= 3'b0;
 always @ (posedge clk_322) if(mac_rx_vld && mac_rx_eop && vld_flag) rx_fifo_data <= {data_keep[31:0],mac_rx_data};
 else if(mac_rx_vld && mac_rx_eop) rx_fifo_data <= {mac_rx_data,32'b0};
 else rx_fifo_data <= {data_keep[31:0],mac_rx_data};
 always @ (posedge clk_322) begin
 if(!rst_n_322) rx_fifo_wren <= 1'b0;
 else rx_fifo_wren <= mac_rx_vld & vld_flag | mac_rx_vld & mac_rx_eop;
 end
 always @ (posedge clk_322) if(!rst_n_322) begin
 rx_fifo_sop <= 1'b0;
 rx_fifo_eop <= 1'b0;
 end
 else begin
 rx_fifo_sop <= data_keep[35];
 rx_fifo_eop <= mac_rx_eop;
 end
 assign rx_fifo_wrdata = {1'b0,rx_fifo_sop,rx_fifo_eop,rx_fifo_byte,rx_fifo_data};
 assign rx_fifo_rden = !rx_fifo_empty && market_pkt_ready;
 assign rx_fifo_data_o = rx_fifo_rddata[63:0];
 assign rx_fifo_bytes_o = rx_fifo_rddata[66:64];
 assign rx_fifo_sop_o = rx_fifo_rddata[68];
 assign rx_fifo_eop_o = rx_fifo_rddata[67];
 assign rx_fifo_vld_o = rx_fifo_rden;
 mac_rx_fifo wrapper_mac_rx_fifo( .data (rx_fifo_wrdata), .wrreq (rx_fifo_wren), .rdreq (rx_fifo_rden), .wrclk (clk_322), .rdclk (clk_250), .q (rx_fifo_rddata), .rdempty (rx_fifo_empty), .wrfull (rx_fifo_full) );
 endmodule
 