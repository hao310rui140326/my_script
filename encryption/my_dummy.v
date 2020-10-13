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
  FIR_R_HEADER_STATE : begin
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
    FIR_R_ERROR_STATE : begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 default : begin
 fir_rx_nstate = FIR_R_IDLE_STATE ;
 end
 endcase end
    reg [3:0] sq_cut_reset_pre_cnt ;
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
  else if (st_rx_start && st_rx_data_en && (st_rx_empty==3'd0) ) begin
 st_shift_scnt <= 6'd8 ;
 st_shift_en <= 1'd1 ;
 end
  else if (fir_r_sync_st ) begin
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
  else if (fir_r_check_st) begin
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
  else if (fir_r_header_st) begin
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
   always@ ( negedge rst_n or posedge clk) begin
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
  always@ ( negedge rst_n or posedge clk) begin
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
   fir_shift_reg_192 fir_shift_reg_192 ( .fir_rx_cstate (fir_rx_cstate ) , .st_shift_full_flag (sq_shift_full_flag ) , .st_rx_start (st_rx_start ) , .st_rx_offset (4'd0 ) , .st_rx_end (st_rx_end ) , .st_rx_valid (st_rx_valid ) , .st_rx_data (st_rx_data ) , .st_rx_ready (1'd1 ) , .st_rx_empty (st_rx_empty ) , .fir_r_idle_st (fir_r_idle_st ) , .st_shift_reg (st_shift_reg ) , .st_shift_ccnt (st_shift_ccnt ) , .st_shift_scnt (st_shift_scnt ) , .st_shift_en (st_shift_en ) , .clk (clk ) , .rst_n (rst_n ) );
 endmodule 