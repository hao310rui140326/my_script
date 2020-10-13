
`timescale 1ns/1ns

module fir_cut_out (
sq_cut_on          ,
sq_cut_first_on    ,
tcp_sqmatch_flag   ,
current_sqid_reg_flag ,
sync_len_byte      ,
sync_fisrt_byte    ,
sync_four_byte     ,
sq_rx_start        , 
sq_rx_end          ,
sq_rx_valid        , 
sq_rx_data         , 
sq_rx_empty        ,
sq_rx_empty_01     ,     
sq_rx_empty_02     ,
sq_rx_empty_03     ,
sq_rx_empty_04     ,
sq_rx_empty_05     ,
sq_rx_empty_06     ,
sq_rx_empty_07     ,
sq_rx_empty_08     ,
sq_rx_empty_09     ,
sq_rx_empty_10     ,
sq_rx_empty_11     ,
sq_rx_empty_12     ,
sq_rx_empty_13     ,
sq_rx_empty_14     ,
sq_rx_empty_15     ,
sq_rx_empty_16     ,
sq_rx_empty_17     ,
sq_rx_empty_18     ,
sq_rx_empty_19     ,
sq_rx_empty_20     ,
sq_rx_empty_21     ,
sq_rx_empty_22     ,
sq_rx_empty_23     ,
sq_rx_empty_24     ,
sq_rx_empty_25     ,
sq_rx_empty_26     ,
sq_rx_empty_27     ,
sq_rx_empty_28     ,
sq_rx_empty_29     ,
sq_rx_empty_30     ,
sq_rx_empty_31     ,

fir_r_sqcuth_st     ,
fir_r_vsync_st      ,
fir_r_sqrcut_st     ,
fir_r_sqrcut_end_st ,

fir_r_sqcut_st     ,
fir_r_sqcut_end_st ,
sub_sqcut_len_reg  ,


st_shift_ccnt      ,  
st_rx_cnt_reg      ,
sq_frame_flag      ,
st_shift_reg       ,
clk                ,
rst_n
);

input                      clk              ;
input                      rst_n          ;

input   [31:0]             sq_cut_on          ;
input   [31:0]             sq_cut_first_on    ;
input   [31:0]             tcp_sqmatch_flag   ;

input                      current_sqid_reg_flag ;

output  [31:0]             sq_rx_start        ; 
output  [31:0]             sq_rx_end          ;
output  [31:0]             sq_rx_valid        ; 
output  [63:0]             sq_rx_data         ; 
output  [ 2:0]             sq_rx_empty        ;
output  [ 2:0]             sq_rx_empty_01        ; 
output  [ 2:0]             sq_rx_empty_02        ; 
output  [ 2:0]             sq_rx_empty_03        ; 
output  [ 2:0]             sq_rx_empty_04        ; 
output  [ 2:0]             sq_rx_empty_05        ; 
output  [ 2:0]             sq_rx_empty_06        ; 
output  [ 2:0]             sq_rx_empty_07        ; 
output  [ 2:0]             sq_rx_empty_08        ; 
output  [ 2:0]             sq_rx_empty_09        ; 
output  [ 2:0]             sq_rx_empty_10        ; 
output  [ 2:0]             sq_rx_empty_11        ; 
output  [ 2:0]             sq_rx_empty_12        ; 
output  [ 2:0]             sq_rx_empty_13        ; 
output  [ 2:0]             sq_rx_empty_14        ; 
output  [ 2:0]             sq_rx_empty_15        ; 
output  [ 2:0]             sq_rx_empty_16        ; 
output  [ 2:0]             sq_rx_empty_17        ; 
output  [ 2:0]             sq_rx_empty_18        ; 
output  [ 2:0]             sq_rx_empty_19        ; 
output  [ 2:0]             sq_rx_empty_20        ; 
output  [ 2:0]             sq_rx_empty_21        ; 
output  [ 2:0]             sq_rx_empty_22        ; 
output  [ 2:0]             sq_rx_empty_23        ; 
output  [ 2:0]             sq_rx_empty_24        ; 
output  [ 2:0]             sq_rx_empty_25        ; 
output  [ 2:0]             sq_rx_empty_26        ; 
output  [ 2:0]             sq_rx_empty_27        ; 
output  [ 2:0]             sq_rx_empty_28        ; 
output  [ 2:0]             sq_rx_empty_29        ; 
output  [ 2:0]             sq_rx_empty_30        ;
output  [ 2:0]             sq_rx_empty_31        ; 

 
input                      fir_r_sqcuth_st    ;
input                      fir_r_vsync_st     ;
input                      fir_r_sqrcut_st     ;
input                      fir_r_sqrcut_end_st ;

input   [  5:0]            sub_sqcut_len_reg  ;
input                      fir_r_sqcut_st     ;
input                      fir_r_sqcut_end_st ;



input   [  5:0]            st_shift_ccnt      ;  
input   [ 15:0]            st_rx_cnt_reg      ;
input                      sq_frame_flag      ;
input   [191:0]            st_shift_reg       ;
input   [ 15:0]            sync_len_byte      ;
input   [ 15:0]            sync_fisrt_byte     ;
input   [ 31:0]            sync_four_byte      ;

//output  [15:0]             sq_rx_cnt          ;

//////////////////////////////////////////////////////////////////////////////////////////////////
reg     [31:0]            sq_rx_start        ; 
reg     [31:0]            sq_rx_valid        ; 
reg     [63:0]            sq_rx_data         ; 
reg     [ 2:0]            sq_rx_empty        ; 
reg     [ 2:0]            sq_rx_empty_01        ; 
reg     [ 2:0]            sq_rx_empty_02        ; 
reg     [ 2:0]            sq_rx_empty_03        ; 
reg     [ 2:0]            sq_rx_empty_04        ; 
reg     [ 2:0]            sq_rx_empty_05        ; 
reg     [ 2:0]            sq_rx_empty_06        ; 
reg     [ 2:0]            sq_rx_empty_07        ; 
reg     [ 2:0]            sq_rx_empty_08        ; 
reg     [ 2:0]            sq_rx_empty_09        ; 
reg     [ 2:0]            sq_rx_empty_10        ; 
reg     [ 2:0]            sq_rx_empty_11        ; 
reg     [ 2:0]            sq_rx_empty_12        ; 
reg     [ 2:0]            sq_rx_empty_13        ; 
reg     [ 2:0]            sq_rx_empty_14        ; 
reg     [ 2:0]            sq_rx_empty_15        ; 
reg     [ 2:0]            sq_rx_empty_16        ; 
reg     [ 2:0]            sq_rx_empty_17        ; 
reg     [ 2:0]            sq_rx_empty_18        ; 
reg     [ 2:0]            sq_rx_empty_19        ; 
reg     [ 2:0]            sq_rx_empty_20        ; 
reg     [ 2:0]            sq_rx_empty_21        ; 
reg     [ 2:0]            sq_rx_empty_22        ; 
reg     [ 2:0]            sq_rx_empty_23        ; 
reg     [ 2:0]            sq_rx_empty_24        ; 
reg     [ 2:0]            sq_rx_empty_25        ; 
reg     [ 2:0]            sq_rx_empty_26        ; 
reg     [ 2:0]            sq_rx_empty_27        ; 
reg     [ 2:0]            sq_rx_empty_28        ; 
reg     [ 2:0]            sq_rx_empty_29        ; 
reg     [ 2:0]            sq_rx_empty_30        ;
reg     [ 2:0]            sq_rx_empty_31        ; 



wire   [31:0]             sq_rx_end      = 32'd0     ;

//////////////////////////////////////////////////////////////////////////////////////////////////

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_rx_start   <=  32'd0    ;
  end
  else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg)  ) begin
      sq_rx_start[ 0]   <=     sq_cut_first_on[ 0]; 
	  sq_rx_start[ 1]   <=     sq_cut_first_on[ 1]; 
	  sq_rx_start[ 2]   <=     sq_cut_first_on[ 2]; 
	  sq_rx_start[ 3]   <=     sq_cut_first_on[ 3]; 
	  sq_rx_start[ 4]   <=     sq_cut_first_on[ 4]; 
	  sq_rx_start[ 5]   <=     sq_cut_first_on[ 5]; 
	  sq_rx_start[ 6]   <=     sq_cut_first_on[ 6]; 
	  sq_rx_start[ 7]   <=     sq_cut_first_on[ 7]; 
	  sq_rx_start[ 8]   <=     sq_cut_first_on[ 8]; 
	  sq_rx_start[ 9]   <=     sq_cut_first_on[ 9]; 
	  sq_rx_start[10]   <=     sq_cut_first_on[10]; 
	  sq_rx_start[11]   <=     sq_cut_first_on[11]; 
	  sq_rx_start[12]   <=     sq_cut_first_on[12]; 
	  sq_rx_start[13]   <=     sq_cut_first_on[13]; 
	  sq_rx_start[14]   <=     sq_cut_first_on[14]; 
	  sq_rx_start[15]   <=     sq_cut_first_on[15]; 
	  sq_rx_start[16]   <=     sq_cut_first_on[16]; 
	  sq_rx_start[17]   <=     sq_cut_first_on[17]; 
	  sq_rx_start[18]   <=     sq_cut_first_on[18]; 
	  sq_rx_start[19]   <=     sq_cut_first_on[19]; 
	  sq_rx_start[20]   <=     sq_cut_first_on[20]; 
	  sq_rx_start[21]   <=     sq_cut_first_on[21]; 
	  sq_rx_start[22]   <=     sq_cut_first_on[22]; 
	  sq_rx_start[23]   <=     sq_cut_first_on[23]; 
	  sq_rx_start[24]   <=     sq_cut_first_on[24]; 
	  sq_rx_start[25]   <=     sq_cut_first_on[25]; 
	  sq_rx_start[26]   <=     sq_cut_first_on[26]; 
	  sq_rx_start[27]   <=     sq_cut_first_on[27]; 
	  sq_rx_start[28]   <=     sq_cut_first_on[28]; 
	  sq_rx_start[29]   <=     sq_cut_first_on[29]; 
	  sq_rx_start[30]   <=     sq_cut_first_on[30]; 
	  sq_rx_start[31]   <=     sq_cut_first_on[31]; 
  end
  else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) &&   ( st_rx_cnt_reg<(sync_len_byte+16'd4) ) &&  sq_frame_flag &&  current_sqid_reg_flag &&  (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)  ) begin
      sq_rx_start[ 0]   <=    ~sq_cut_on[ 0]                       ; 
	  sq_rx_start[ 1]   <=    ~sq_cut_on[ 1] && ( sq_cut_on[   0]) ; 
	  sq_rx_start[ 2]   <=    ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ; 
	  sq_rx_start[ 3]   <=    ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ; 
	  sq_rx_start[ 4]   <=    ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ; 
	  sq_rx_start[ 5]   <=    ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ; 
	  sq_rx_start[ 6]   <=    ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ; 
	  sq_rx_start[ 7]   <=    ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ; 
	  sq_rx_start[ 8]   <=    ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ; 
	  sq_rx_start[ 9]   <=    ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ; 
	  sq_rx_start[10]   <=    ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ; 
	  sq_rx_start[11]   <=    ~sq_cut_on[11] && (&sq_cut_on[10:0]) ; 
	  sq_rx_start[12]   <=    ~sq_cut_on[12] && (&sq_cut_on[11:0]) ; 
	  sq_rx_start[13]   <=    ~sq_cut_on[13] && (&sq_cut_on[12:0]) ; 
	  sq_rx_start[14]   <=    ~sq_cut_on[14] && (&sq_cut_on[13:0]) ; 
	  sq_rx_start[15]   <=    ~sq_cut_on[15] && (&sq_cut_on[14:0]) ; 
	  sq_rx_start[16]   <=    ~sq_cut_on[16] && (&sq_cut_on[15:0]) ; 
	  sq_rx_start[17]   <=    ~sq_cut_on[17] && (&sq_cut_on[16:0]) ; 
	  sq_rx_start[18]   <=    ~sq_cut_on[18] && (&sq_cut_on[17:0]) ; 
	  sq_rx_start[19]   <=    ~sq_cut_on[19] && (&sq_cut_on[18:0]) ; 
	  sq_rx_start[20]   <=    ~sq_cut_on[20] && (&sq_cut_on[19:0]) ; 
	  sq_rx_start[21]   <=    ~sq_cut_on[21] && (&sq_cut_on[20:0]) ; 
	  sq_rx_start[22]   <=    ~sq_cut_on[22] && (&sq_cut_on[21:0]) ; 
	  sq_rx_start[23]   <=    ~sq_cut_on[23] && (&sq_cut_on[22:0]) ; 
	  sq_rx_start[24]   <=    ~sq_cut_on[24] && (&sq_cut_on[23:0]) ; 
	  sq_rx_start[25]   <=    ~sq_cut_on[25] && (&sq_cut_on[24:0]) ; 
	  sq_rx_start[26]   <=    ~sq_cut_on[26] && (&sq_cut_on[25:0]) ; 
	  sq_rx_start[27]   <=    ~sq_cut_on[27] && (&sq_cut_on[26:0]) ; 
	  sq_rx_start[28]   <=    ~sq_cut_on[28] && (&sq_cut_on[27:0]) ; 
	  sq_rx_start[29]   <=    ~sq_cut_on[29] && (&sq_cut_on[28:0]) ; 
	  sq_rx_start[30]   <=    ~sq_cut_on[30] && (&sq_cut_on[29:0]) ; 
	  sq_rx_start[31]   <=    ~sq_cut_on[31] && (&sq_cut_on[30:0]) ;        
  end 
  else begin
      sq_rx_start   <=  32'd0    ;
  end
end
//sq_rx_valid
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_rx_valid   <=  32'd0    ;
  end
  else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg)  ) begin
	  sq_rx_valid[ 0]   <=     sq_cut_first_on[ 0]; 
	  sq_rx_valid[ 1]   <=     sq_cut_first_on[ 1]; 
	  sq_rx_valid[ 2]   <=     sq_cut_first_on[ 2]; 
	  sq_rx_valid[ 3]   <=     sq_cut_first_on[ 3]; 
	  sq_rx_valid[ 4]   <=     sq_cut_first_on[ 4]; 
	  sq_rx_valid[ 5]   <=     sq_cut_first_on[ 5]; 
	  sq_rx_valid[ 6]   <=     sq_cut_first_on[ 6]; 
	  sq_rx_valid[ 7]   <=     sq_cut_first_on[ 7]; 
	  sq_rx_valid[ 8]   <=     sq_cut_first_on[ 8]; 
	  sq_rx_valid[ 9]   <=     sq_cut_first_on[ 9]; 
	  sq_rx_valid[10]   <=     sq_cut_first_on[10]; 
	  sq_rx_valid[11]   <=     sq_cut_first_on[11]; 
	  sq_rx_valid[12]   <=     sq_cut_first_on[12]; 
	  sq_rx_valid[13]   <=     sq_cut_first_on[13]; 
	  sq_rx_valid[14]   <=     sq_cut_first_on[14]; 
	  sq_rx_valid[15]   <=     sq_cut_first_on[15]; 
	  sq_rx_valid[16]   <=     sq_cut_first_on[16]; 
	  sq_rx_valid[17]   <=     sq_cut_first_on[17]; 
	  sq_rx_valid[18]   <=     sq_cut_first_on[18]; 
	  sq_rx_valid[19]   <=     sq_cut_first_on[19]; 
	  sq_rx_valid[20]   <=     sq_cut_first_on[20]; 
	  sq_rx_valid[21]   <=     sq_cut_first_on[21]; 
	  sq_rx_valid[22]   <=     sq_cut_first_on[22]; 
	  sq_rx_valid[23]   <=     sq_cut_first_on[23]; 
	  sq_rx_valid[24]   <=     sq_cut_first_on[24]; 
	  sq_rx_valid[25]   <=     sq_cut_first_on[25]; 
	  sq_rx_valid[26]   <=     sq_cut_first_on[26]; 
	  sq_rx_valid[27]   <=     sq_cut_first_on[27]; 
	  sq_rx_valid[28]   <=     sq_cut_first_on[28]; 
	  sq_rx_valid[29]   <=     sq_cut_first_on[29]; 
	  sq_rx_valid[30]   <=     sq_cut_first_on[30]; 
	  sq_rx_valid[31]   <=     sq_cut_first_on[31]; 
  end
  else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8)   &&   ( st_rx_cnt_reg<(sync_len_byte+16'd4) )  &&   sq_frame_flag &&  current_sqid_reg_flag ) begin
	  sq_rx_valid[ 0]   <=    ~sq_cut_on[ 0]                       ; 
	  sq_rx_valid[ 1]   <=    ~sq_cut_on[ 1] && ( sq_cut_on[   0]) ; 
	  sq_rx_valid[ 2]   <=    ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ; 
	  sq_rx_valid[ 3]   <=    ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ; 
	  sq_rx_valid[ 4]   <=    ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ; 
	  sq_rx_valid[ 5]   <=    ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ; 
	  sq_rx_valid[ 6]   <=    ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ; 
	  sq_rx_valid[ 7]   <=    ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ; 
	  sq_rx_valid[ 8]   <=    ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ; 
	  sq_rx_valid[ 9]   <=    ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ; 
	  sq_rx_valid[10]   <=    ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ; 
	  sq_rx_valid[11]   <=    ~sq_cut_on[11] && (&sq_cut_on[10:0]) ; 
	  sq_rx_valid[12]   <=    ~sq_cut_on[12] && (&sq_cut_on[11:0]) ; 
	  sq_rx_valid[13]   <=    ~sq_cut_on[13] && (&sq_cut_on[12:0]) ; 
	  sq_rx_valid[14]   <=    ~sq_cut_on[14] && (&sq_cut_on[13:0]) ; 
	  sq_rx_valid[15]   <=    ~sq_cut_on[15] && (&sq_cut_on[14:0]) ; 
	  sq_rx_valid[16]   <=    ~sq_cut_on[16] && (&sq_cut_on[15:0]) ; 
	  sq_rx_valid[17]   <=    ~sq_cut_on[17] && (&sq_cut_on[16:0]) ; 
	  sq_rx_valid[18]   <=    ~sq_cut_on[18] && (&sq_cut_on[17:0]) ; 
	  sq_rx_valid[19]   <=    ~sq_cut_on[19] && (&sq_cut_on[18:0]) ; 
	  sq_rx_valid[20]   <=    ~sq_cut_on[20] && (&sq_cut_on[19:0]) ; 
	  sq_rx_valid[21]   <=    ~sq_cut_on[21] && (&sq_cut_on[20:0]) ; 
	  sq_rx_valid[22]   <=    ~sq_cut_on[22] && (&sq_cut_on[21:0]) ; 
	  sq_rx_valid[23]   <=    ~sq_cut_on[23] && (&sq_cut_on[22:0]) ; 
	  sq_rx_valid[24]   <=    ~sq_cut_on[24] && (&sq_cut_on[23:0]) ; 
	  sq_rx_valid[25]   <=    ~sq_cut_on[25] && (&sq_cut_on[24:0]) ; 
	  sq_rx_valid[26]   <=    ~sq_cut_on[26] && (&sq_cut_on[25:0]) ; 
	  sq_rx_valid[27]   <=    ~sq_cut_on[27] && (&sq_cut_on[26:0]) ; 
	  sq_rx_valid[28]   <=    ~sq_cut_on[28] && (&sq_cut_on[27:0]) ; 
	  sq_rx_valid[29]   <=    ~sq_cut_on[29] && (&sq_cut_on[28:0]) ; 
	  sq_rx_valid[30]   <=    ~sq_cut_on[30] && (&sq_cut_on[29:0]) ; 
	  sq_rx_valid[31]   <=    ~sq_cut_on[31] && (&sq_cut_on[30:0]) ; 
  end 
  else if ( fir_r_sqcut_st   && (st_shift_ccnt>=6'd8)   ) begin
      sq_rx_valid[ 0]   <=     sq_cut_first_on[ 0]; 
	  sq_rx_valid[ 1]   <=     sq_cut_first_on[ 1]; 
	  sq_rx_valid[ 2]   <=     sq_cut_first_on[ 2]; 
	  sq_rx_valid[ 3]   <=     sq_cut_first_on[ 3]; 
	  sq_rx_valid[ 4]   <=     sq_cut_first_on[ 4]; 
	  sq_rx_valid[ 5]   <=     sq_cut_first_on[ 5]; 
	  sq_rx_valid[ 6]   <=     sq_cut_first_on[ 6]; 
	  sq_rx_valid[ 7]   <=     sq_cut_first_on[ 7]; 
	  sq_rx_valid[ 8]   <=     sq_cut_first_on[ 8]; 
	  sq_rx_valid[ 9]   <=     sq_cut_first_on[ 9]; 
	  sq_rx_valid[10]   <=     sq_cut_first_on[10]; 
	  sq_rx_valid[11]   <=     sq_cut_first_on[11]; 
	  sq_rx_valid[12]   <=     sq_cut_first_on[12]; 
	  sq_rx_valid[13]   <=     sq_cut_first_on[13]; 
	  sq_rx_valid[14]   <=     sq_cut_first_on[14]; 
	  sq_rx_valid[15]   <=     sq_cut_first_on[15]; 
	  sq_rx_valid[16]   <=     sq_cut_first_on[16]; 
	  sq_rx_valid[17]   <=     sq_cut_first_on[17]; 
	  sq_rx_valid[18]   <=     sq_cut_first_on[18]; 
	  sq_rx_valid[19]   <=     sq_cut_first_on[19]; 
	  sq_rx_valid[20]   <=     sq_cut_first_on[20]; 
	  sq_rx_valid[21]   <=     sq_cut_first_on[21]; 
	  sq_rx_valid[22]   <=     sq_cut_first_on[22]; 
	  sq_rx_valid[23]   <=     sq_cut_first_on[23]; 
	  sq_rx_valid[24]   <=     sq_cut_first_on[24]; 
	  sq_rx_valid[25]   <=     sq_cut_first_on[25]; 
	  sq_rx_valid[26]   <=     sq_cut_first_on[26]; 
	  sq_rx_valid[27]   <=     sq_cut_first_on[27]; 
	  sq_rx_valid[28]   <=     sq_cut_first_on[28]; 
	  sq_rx_valid[29]   <=     sq_cut_first_on[29]; 
	  sq_rx_valid[30]   <=     sq_cut_first_on[30]; 
	  sq_rx_valid[31]   <=     sq_cut_first_on[31]; 
  end 
  else if ( fir_r_sqcut_end_st && (st_shift_ccnt>=st_rx_cnt_reg)   ) begin
      sq_rx_valid[ 0]   <=     sq_cut_first_on[ 0]; 
	  sq_rx_valid[ 1]   <=     sq_cut_first_on[ 1]; 
	  sq_rx_valid[ 2]   <=     sq_cut_first_on[ 2]; 
	  sq_rx_valid[ 3]   <=     sq_cut_first_on[ 3]; 
	  sq_rx_valid[ 4]   <=     sq_cut_first_on[ 4]; 
	  sq_rx_valid[ 5]   <=     sq_cut_first_on[ 5]; 
	  sq_rx_valid[ 6]   <=     sq_cut_first_on[ 6]; 
	  sq_rx_valid[ 7]   <=     sq_cut_first_on[ 7]; 
	  sq_rx_valid[ 8]   <=     sq_cut_first_on[ 8]; 
	  sq_rx_valid[ 9]   <=     sq_cut_first_on[ 9]; 
	  sq_rx_valid[10]   <=     sq_cut_first_on[10]; 
	  sq_rx_valid[11]   <=     sq_cut_first_on[11]; 
	  sq_rx_valid[12]   <=     sq_cut_first_on[12]; 
	  sq_rx_valid[13]   <=     sq_cut_first_on[13]; 
	  sq_rx_valid[14]   <=     sq_cut_first_on[14]; 
	  sq_rx_valid[15]   <=     sq_cut_first_on[15]; 
	  sq_rx_valid[16]   <=     sq_cut_first_on[16]; 
	  sq_rx_valid[17]   <=     sq_cut_first_on[17]; 
	  sq_rx_valid[18]   <=     sq_cut_first_on[18]; 
	  sq_rx_valid[19]   <=     sq_cut_first_on[19]; 
	  sq_rx_valid[20]   <=     sq_cut_first_on[20]; 
	  sq_rx_valid[21]   <=     sq_cut_first_on[21]; 
	  sq_rx_valid[22]   <=     sq_cut_first_on[22]; 
	  sq_rx_valid[23]   <=     sq_cut_first_on[23]; 
	  sq_rx_valid[24]   <=     sq_cut_first_on[24]; 
	  sq_rx_valid[25]   <=     sq_cut_first_on[25]; 
	  sq_rx_valid[26]   <=     sq_cut_first_on[26]; 
	  sq_rx_valid[27]   <=     sq_cut_first_on[27]; 
	  sq_rx_valid[28]   <=     sq_cut_first_on[28]; 
	  sq_rx_valid[29]   <=     sq_cut_first_on[29]; 
	  sq_rx_valid[30]   <=     sq_cut_first_on[30]; 
	  sq_rx_valid[31]   <=     sq_cut_first_on[31]; 
  end
  else if ( fir_r_sqrcut_st  && (st_shift_ccnt>=6'd8)   ) begin
	  sq_rx_valid[ 0]   <=  tcp_sqmatch_flag[ 0] ;
	  sq_rx_valid[ 1]   <=  tcp_sqmatch_flag[ 1] ;
	  sq_rx_valid[ 2]   <=  tcp_sqmatch_flag[ 2] ;
	  sq_rx_valid[ 3]   <=  tcp_sqmatch_flag[ 3] ;
	  sq_rx_valid[ 4]   <=  tcp_sqmatch_flag[ 4] ;
	  sq_rx_valid[ 5]   <=  tcp_sqmatch_flag[ 5] ;
	  sq_rx_valid[ 6]   <=  tcp_sqmatch_flag[ 6] ;
	  sq_rx_valid[ 7]   <=  tcp_sqmatch_flag[ 7] ;
	  sq_rx_valid[ 8]   <=  tcp_sqmatch_flag[ 8] ;
	  sq_rx_valid[ 9]   <=  tcp_sqmatch_flag[ 9] ;
	  sq_rx_valid[10]   <=  tcp_sqmatch_flag[10] ;
	  sq_rx_valid[11]   <=  tcp_sqmatch_flag[11] ;
	  sq_rx_valid[12]   <=  tcp_sqmatch_flag[12] ;
	  sq_rx_valid[13]   <=  tcp_sqmatch_flag[13] ;
	  sq_rx_valid[14]   <=  tcp_sqmatch_flag[14] ;
	  sq_rx_valid[15]   <=  tcp_sqmatch_flag[15] ;
	  sq_rx_valid[16]   <=  tcp_sqmatch_flag[16] ;
	  sq_rx_valid[17]   <=  tcp_sqmatch_flag[17] ;
	  sq_rx_valid[18]   <=  tcp_sqmatch_flag[18] ;
	  sq_rx_valid[19]   <=  tcp_sqmatch_flag[19] ;
	  sq_rx_valid[20]   <=  tcp_sqmatch_flag[20] ;
	  sq_rx_valid[21]   <=  tcp_sqmatch_flag[21] ;
	  sq_rx_valid[22]   <=  tcp_sqmatch_flag[22] ;
	  sq_rx_valid[23]   <=  tcp_sqmatch_flag[23] ;
	  sq_rx_valid[24]   <=  tcp_sqmatch_flag[24] ;
	  sq_rx_valid[25]   <=  tcp_sqmatch_flag[25] ;
	  sq_rx_valid[26]   <=  tcp_sqmatch_flag[26] ;
	  sq_rx_valid[27]   <=  tcp_sqmatch_flag[27] ;
	  sq_rx_valid[28]   <=  tcp_sqmatch_flag[28] ;
	  sq_rx_valid[29]   <=  tcp_sqmatch_flag[29] ;
	  sq_rx_valid[30]   <=  tcp_sqmatch_flag[30] ;
	  sq_rx_valid[31]   <=  tcp_sqmatch_flag[31] ;
  end 
  else if ( fir_r_sqrcut_end_st && (st_shift_ccnt>= sub_sqcut_len_reg[5:0]   )   ) begin
	  sq_rx_valid[ 0]   <=  tcp_sqmatch_flag[ 0] ;
	  sq_rx_valid[ 1]   <=  tcp_sqmatch_flag[ 1] ;
	  sq_rx_valid[ 2]   <=  tcp_sqmatch_flag[ 2] ;
	  sq_rx_valid[ 3]   <=  tcp_sqmatch_flag[ 3] ;
	  sq_rx_valid[ 4]   <=  tcp_sqmatch_flag[ 4] ;
	  sq_rx_valid[ 5]   <=  tcp_sqmatch_flag[ 5] ;
	  sq_rx_valid[ 6]   <=  tcp_sqmatch_flag[ 6] ;
	  sq_rx_valid[ 7]   <=  tcp_sqmatch_flag[ 7] ;
	  sq_rx_valid[ 8]   <=  tcp_sqmatch_flag[ 8] ;
	  sq_rx_valid[ 9]   <=  tcp_sqmatch_flag[ 9] ;
	  sq_rx_valid[10]   <=  tcp_sqmatch_flag[10] ;
	  sq_rx_valid[11]   <=  tcp_sqmatch_flag[11] ;
	  sq_rx_valid[12]   <=  tcp_sqmatch_flag[12] ;
	  sq_rx_valid[13]   <=  tcp_sqmatch_flag[13] ;
	  sq_rx_valid[14]   <=  tcp_sqmatch_flag[14] ;
	  sq_rx_valid[15]   <=  tcp_sqmatch_flag[15] ;
	  sq_rx_valid[16]   <=  tcp_sqmatch_flag[16] ;
	  sq_rx_valid[17]   <=  tcp_sqmatch_flag[17] ;
	  sq_rx_valid[18]   <=  tcp_sqmatch_flag[18] ;
	  sq_rx_valid[19]   <=  tcp_sqmatch_flag[19] ;
	  sq_rx_valid[20]   <=  tcp_sqmatch_flag[20] ;
	  sq_rx_valid[21]   <=  tcp_sqmatch_flag[21] ;
	  sq_rx_valid[22]   <=  tcp_sqmatch_flag[22] ;
	  sq_rx_valid[23]   <=  tcp_sqmatch_flag[23] ;
	  sq_rx_valid[24]   <=  tcp_sqmatch_flag[24] ;
	  sq_rx_valid[25]   <=  tcp_sqmatch_flag[25] ;
	  sq_rx_valid[26]   <=  tcp_sqmatch_flag[26] ;
	  sq_rx_valid[27]   <=  tcp_sqmatch_flag[27] ;
	  sq_rx_valid[28]   <=  tcp_sqmatch_flag[28] ;
	  sq_rx_valid[29]   <=  tcp_sqmatch_flag[29] ;
	  sq_rx_valid[30]   <=  tcp_sqmatch_flag[30] ;
	  sq_rx_valid[31]   <=  tcp_sqmatch_flag[31] ;
  end

  else begin
      sq_rx_valid   <=  32'd0    ;
  end
end
//sq_rx_data
wire    [63: 0]  sq_rx_data_wire   =   st_shift_reg[127+64:64+64];
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_rx_data   <=  64'd0    ;
  end

 else if ( fir_r_sqcuth_st && (st_shift_ccnt>=st_rx_cnt_reg)  ) begin
      sq_rx_data   <=  sq_rx_data_wire ;
  end
//  else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8) && sq_frame_flag &&  current_sqid_reg_flag    &&   ( st_rx_cnt_reg<(sync_len_byte+16'd4) )  ) begin
  else if ( fir_r_vsync_st && (st_shift_ccnt>=6'd8)  ) begin  
    sq_rx_data   <=  sq_rx_data_wire ;
  end   
  else if ( ( fir_r_sqcut_st || fir_r_sqrcut_st)  && (st_shift_ccnt>=6'd8)   ) begin
      sq_rx_data   <=  sq_rx_data_wire ;
  end 
  else if ( fir_r_sqcut_end_st && (st_shift_ccnt>=st_rx_cnt_reg)   ) begin
      sq_rx_data   <=  sq_rx_data_wire ;
  end
//  else if ( fir_r_sqrcut_end_st && (st_shift_ccnt>=  sub_sqcut_len_reg[5:0]  )   ) begin
  else if ( fir_r_sqrcut_end_st   ) begin  
      sq_rx_data   <=  sq_rx_data_wire ;
  end

end
//sq_rx_empty
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_rx_empty       <=  3'd0    ;
      sq_rx_empty_01    <=  3'd0    ;      
      sq_rx_empty_02    <=  3'd0    ;
      sq_rx_empty_03    <=  3'd0    ;
      sq_rx_empty_04    <=  3'd0    ;
      sq_rx_empty_05    <=  3'd0    ;
      sq_rx_empty_06    <=  3'd0    ;
      sq_rx_empty_07    <=  3'd0    ;
      sq_rx_empty_08    <=  3'd0    ;
      sq_rx_empty_09    <=  3'd0    ;
      sq_rx_empty_10    <=  3'd0    ;
      sq_rx_empty_11    <=  3'd0    ;
      sq_rx_empty_12    <=  3'd0    ;
      sq_rx_empty_13    <=  3'd0    ;
      sq_rx_empty_14    <=  3'd0    ;
      sq_rx_empty_15    <=  3'd0    ;
      sq_rx_empty_16    <=  3'd0    ;
      sq_rx_empty_17    <=  3'd0    ;
      sq_rx_empty_18    <=  3'd0    ;
      sq_rx_empty_19    <=  3'd0    ;
      sq_rx_empty_20    <=  3'd0    ;
      sq_rx_empty_21    <=  3'd0    ;
      sq_rx_empty_22    <=  3'd0    ;
      sq_rx_empty_23    <=  3'd0    ;
      sq_rx_empty_24    <=  3'd0    ;
      sq_rx_empty_25    <=  3'd0    ;
      sq_rx_empty_26    <=  3'd0    ;
      sq_rx_empty_27    <=  3'd0    ;
      sq_rx_empty_28    <=  3'd0    ;
      sq_rx_empty_29    <=  3'd0    ;
      sq_rx_empty_30    <=  3'd0    ;
      sq_rx_empty_31    <=  3'd0    ;
  end
  else if ( (fir_r_sqcuth_st || fir_r_sqcut_end_st) && (st_shift_ccnt>=st_rx_cnt_reg)  ) begin
      sq_rx_empty       <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_01    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;      
      sq_rx_empty_02    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_03    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_04    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_05    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_06    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_07    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_08    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_09    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_10    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_11    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_12    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_13    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_14    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_15    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_16    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_17    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_18    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_19    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_20    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_21    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_22    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_23    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_24    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_25    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_26    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_27    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_28    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_29    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_30    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
      sq_rx_empty_31    <=  4'd8  -  st_rx_cnt_reg[3:0]    ;
  end 
  else begin
      sq_rx_empty   <=  3'd0    ;
      sq_rx_empty_01    <=  3'd0    ;      
      sq_rx_empty_02    <=  3'd0    ;
      sq_rx_empty_03    <=  3'd0    ;
      sq_rx_empty_04    <=  3'd0    ;
      sq_rx_empty_05    <=  3'd0    ;
      sq_rx_empty_06    <=  3'd0    ;
      sq_rx_empty_07    <=  3'd0    ;
      sq_rx_empty_08    <=  3'd0    ;
      sq_rx_empty_09    <=  3'd0    ;
      sq_rx_empty_10    <=  3'd0    ;
      sq_rx_empty_11    <=  3'd0    ;
      sq_rx_empty_12    <=  3'd0    ;
      sq_rx_empty_13    <=  3'd0    ;
      sq_rx_empty_14    <=  3'd0    ;
      sq_rx_empty_15    <=  3'd0    ;
      sq_rx_empty_16    <=  3'd0    ;
      sq_rx_empty_17    <=  3'd0    ;
      sq_rx_empty_18    <=  3'd0    ;
      sq_rx_empty_19    <=  3'd0    ;
      sq_rx_empty_20    <=  3'd0    ;
      sq_rx_empty_21    <=  3'd0    ;
      sq_rx_empty_22    <=  3'd0    ;
      sq_rx_empty_23    <=  3'd0    ;
      sq_rx_empty_24    <=  3'd0    ;
      sq_rx_empty_25    <=  3'd0    ;
      sq_rx_empty_26    <=  3'd0    ;
      sq_rx_empty_27    <=  3'd0    ;
      sq_rx_empty_28    <=  3'd0    ;
      sq_rx_empty_29    <=  3'd0    ;
      sq_rx_empty_30    <=  3'd0    ;
      sq_rx_empty_31    <=  3'd0    ;
  end
end
/////////////////////////////////////////////////////////////////////////////////////
// reg     [15:0]     sq_rx_len    ;
// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // sq_rx_len   <=  16'd81    ;
  // end
  // else if ( sq_rx_start && sq_rx_valid ) begin
      // sq_rx_len   <=   16'd81    ;
  // end 
// end
//reg     [15:0]     sq_rx_cnt    ;
//always@ ( negedge rst_n  or posedge clk)
//begin
//  if (~rst_n) begin
//      sq_rx_cnt   <=  16'd0    ;
//  end
//  else if (sq_rx_start && sq_rx_valid) begin
//      sq_rx_cnt   <=  16'd8 - sq_rx_empty ;
//  end
//  else if ( sq_rx_valid ) begin
//      sq_rx_cnt   <=  sq_rx_cnt +  16'd8 - sq_rx_empty ;
//  end 
//end






endmodule



