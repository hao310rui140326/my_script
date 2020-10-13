module  sq_cut_ctrl  (
clk                ,
rst_n              ,
params_filter_rst   ,
sq00_cut_len_reg    ,
sq01_cut_len_reg    ,
sq02_cut_len_reg    ,
sq03_cut_len_reg    ,
sq04_cut_len_reg    ,
sq05_cut_len_reg    ,
sq06_cut_len_reg    ,
sq07_cut_len_reg    ,
sq08_cut_len_reg    ,
sq09_cut_len_reg    ,
sq10_cut_len_reg    ,
sq11_cut_len_reg    ,
sq12_cut_len_reg    ,
sq13_cut_len_reg    ,
sq14_cut_len_reg    ,
sq15_cut_len_reg    ,
sq16_cut_len_reg    ,
sq17_cut_len_reg    ,
sq18_cut_len_reg    ,
sq19_cut_len_reg    ,
sq20_cut_len_reg    ,
sq21_cut_len_reg    ,
sq22_cut_len_reg    ,
sq23_cut_len_reg    ,
sq24_cut_len_reg    ,
sq25_cut_len_reg    ,
sq26_cut_len_reg    ,
sq27_cut_len_reg    ,
sq28_cut_len_reg    ,
sq29_cut_len_reg    ,
sq30_cut_len_reg    ,
sq31_cut_len_reg    ,
fir_r_idle_st       ,
fir_r_sqcuth_st     ,
fir_r_vsync_st      ,
fir_r_sqcut_st      ,
fir_r_sqcut_end_st  ,
fir_r_sqrcut_st     ,
fir_r_sqrcut_end_st ,
fir_r_rjudge_st     ,
sq_cut_len_reg      ,
st_rx_cnt_reg       , 
st_shift_ccnt       ,
sync_len_byte       ,
sync_fisrt_byte    ,
sync_four_byte     ,
sq_frame_flag       ,
current_sqid_reg_flag ,
sq_cut_on           ,
sq_cut_first_on     ,
sub_sqcut_len_reg   ,                                         
st_rx_start        , 
st_rx_offset       ,
st_rx_end          , 
st_rx_valid        , 
st_rx_data         , 
st_rx_empty        , 
st_rx_cnt          , 
first_sync_len_byte,                                      
tcp_sqmatch_flag   ,  //match with pre  SQ tcp frame 
seq_err_flag       ,
seq_err_flag_dly   ,
tcp_payload_len    ,
st_rx_start_dly        , 
st_rx_offset_dly       ,
st_rx_end_dly          , 
st_rx_valid_dly        , 
st_rx_data_dly         , 
st_rx_empty_dly        , 
st_rx_cnt_dly          , 
first_sync_len_byte_dly,                                      
tcp_sqmatch_flag_dly   ,  //match with pre  SQ tcp frame 
tcp_sqmatch_flag_1bit_dly ,
tcp_payload_len_dly    ,                                           
sq_cut_flag        ,  //cut _flag                          
sq_cut_reset       ,  //cut _flag
sq_cut_reset_pre   ,
current_cut_done_sq00id_reg   ,
current_cut_done_sq01id_reg   ,
current_cut_done_sq02id_reg   ,
current_cut_done_sq03id_reg   ,
current_cut_done_sq04id_reg   ,
current_cut_done_sq05id_reg   ,
current_cut_done_sq06id_reg   ,
current_cut_done_sq07id_reg   ,
current_cut_done_sq08id_reg   ,
current_cut_done_sq09id_reg   ,
current_cut_done_sq10id_reg   ,
current_cut_done_sq11id_reg   ,
current_cut_done_sq12id_reg   ,
current_cut_done_sq13id_reg   ,
current_cut_done_sq14id_reg   ,
current_cut_done_sq15id_reg   ,
current_cut_done_sq16id_reg   ,
current_cut_done_sq17id_reg   ,
current_cut_done_sq18id_reg   ,
current_cut_done_sq19id_reg   ,
current_cut_done_sq20id_reg   ,
current_cut_done_sq21id_reg   ,
current_cut_done_sq22id_reg   ,
current_cut_done_sq23id_reg   ,
current_cut_done_sq24id_reg   ,
current_cut_done_sq25id_reg   ,
current_cut_done_sq26id_reg   ,
current_cut_done_sq27id_reg   ,
current_cut_done_sq28id_reg   ,
current_cut_done_sq29id_reg   ,
current_cut_done_sq30id_reg   ,
current_cut_done_sq31id_reg   ,
current_sqcut_done            ,
current_sqid_reg              ,
current_sqid_reg_vld          
);

input                      clk                ;
input                      rst_n              ;

input                      params_filter_rst   ;

input    [15:0]            sq00_cut_len_reg    ;
input    [15:0]            sq01_cut_len_reg    ;
input    [15:0]            sq02_cut_len_reg    ;
input    [15:0]            sq03_cut_len_reg    ;
input    [15:0]            sq04_cut_len_reg    ;
input    [15:0]            sq05_cut_len_reg    ;
input    [15:0]            sq06_cut_len_reg    ;
input    [15:0]            sq07_cut_len_reg    ;
input    [15:0]            sq08_cut_len_reg    ;
input    [15:0]            sq09_cut_len_reg    ;
input    [15:0]            sq10_cut_len_reg    ;
input    [15:0]            sq11_cut_len_reg    ;
input    [15:0]            sq12_cut_len_reg    ;
input    [15:0]            sq13_cut_len_reg    ;
input    [15:0]            sq14_cut_len_reg    ;
input    [15:0]            sq15_cut_len_reg    ;
input    [15:0]            sq16_cut_len_reg    ;
input    [15:0]            sq17_cut_len_reg    ;
input    [15:0]            sq18_cut_len_reg    ;
input    [15:0]            sq19_cut_len_reg    ;
input    [15:0]            sq20_cut_len_reg    ;
input    [15:0]            sq21_cut_len_reg    ;
input    [15:0]            sq22_cut_len_reg    ;
input    [15:0]            sq23_cut_len_reg    ;
input    [15:0]            sq24_cut_len_reg    ;
input    [15:0]            sq25_cut_len_reg    ;
input    [15:0]            sq26_cut_len_reg    ;
input    [15:0]            sq27_cut_len_reg    ;
input    [15:0]            sq28_cut_len_reg    ;
input    [15:0]            sq29_cut_len_reg    ;
input    [15:0]            sq30_cut_len_reg    ;
input    [15:0]            sq31_cut_len_reg    ;

input                      fir_r_idle_st       ;
input                      fir_r_sqcuth_st     ;
input                      fir_r_vsync_st      ;
input                      fir_r_sqcut_st      ;
input                      fir_r_sqcut_end_st  ;
input                      fir_r_sqrcut_st     ;
input                      fir_r_sqrcut_end_st ;
input                      fir_r_rjudge_st     ;

input    [15:0]            st_rx_cnt_reg       ; 
input    [ 5:0]            st_shift_ccnt       ;
input    [15:0]            sync_len_byte       ;
input   [ 15:0]            sync_fisrt_byte     ;
input   [ 31:0]            sync_four_byte      ;
input                      sq_frame_flag       ;
input                      current_sqid_reg_flag ;

output   [31:0]            sq_cut_on           ;
output   [15:0]            sub_sqcut_len_reg   ;
output   [31:0]            sq_cut_first_on     ;
                                          
input                      st_rx_start        ; 
input    [ 3:0]            st_rx_offset       ;
input                      st_rx_end          ; 
input                      st_rx_valid        ; 
input    [63:0]            st_rx_data         ; 
input    [ 2:0]            st_rx_empty        ; 
input    [15:0]            st_rx_cnt          ; 
input    [15:0]            first_sync_len_byte;                                      
input    [31:0]            tcp_sqmatch_flag   ;  //match with pre  SQ tcp frame 

input    [31:0]            seq_err_flag        ;
output                     seq_err_flag_dly    ;
input    [15:0]            tcp_payload_len    ;

output                      st_rx_start_dly        ; 
output    [ 3:0]            st_rx_offset_dly       ;
output                      st_rx_end_dly          ; 
output                      st_rx_valid_dly        ; 
output    [63:0]            st_rx_data_dly         ; 
output    [ 2:0]            st_rx_empty_dly        ; 
output    [15:0]            st_rx_cnt_dly          ; 
output    [15:0]            first_sync_len_byte_dly;                                      
output    [31:0]            tcp_sqmatch_flag_dly   ;  //match with pre  SQ tcp frame 
output                      tcp_sqmatch_flag_1bit_dly ;
output    [15:0]            tcp_payload_len_dly    ;
                                            
output     [31:0]          sq_cut_flag        ;  //cut _flag                          
input      [31:0]          sq_cut_reset       ;  //cut _flag
output     [31:0]          sq_cut_reset_pre   ;  //cut _flag


input    [31:0]            current_cut_done_sq00id_reg   ;
input    [31:0]            current_cut_done_sq01id_reg   ;
input    [31:0]            current_cut_done_sq02id_reg   ;
input    [31:0]            current_cut_done_sq03id_reg   ;
input    [31:0]            current_cut_done_sq04id_reg   ;
input    [31:0]            current_cut_done_sq05id_reg   ;
input    [31:0]            current_cut_done_sq06id_reg   ;
input    [31:0]            current_cut_done_sq07id_reg   ;
input    [31:0]            current_cut_done_sq08id_reg   ;
input    [31:0]            current_cut_done_sq09id_reg   ;
input    [31:0]            current_cut_done_sq10id_reg   ;
input    [31:0]            current_cut_done_sq11id_reg   ;
input    [31:0]            current_cut_done_sq12id_reg   ;
input    [31:0]            current_cut_done_sq13id_reg   ;
input    [31:0]            current_cut_done_sq14id_reg   ;
input    [31:0]            current_cut_done_sq15id_reg   ;
input    [31:0]            current_cut_done_sq16id_reg   ;
input    [31:0]            current_cut_done_sq17id_reg   ;
input    [31:0]            current_cut_done_sq18id_reg   ;
input    [31:0]            current_cut_done_sq19id_reg   ;
input    [31:0]            current_cut_done_sq20id_reg   ;
input    [31:0]            current_cut_done_sq21id_reg   ;
input    [31:0]            current_cut_done_sq22id_reg   ;
input    [31:0]            current_cut_done_sq23id_reg   ;
input    [31:0]            current_cut_done_sq24id_reg   ;
input    [31:0]            current_cut_done_sq25id_reg   ;
input    [31:0]            current_cut_done_sq26id_reg   ;
input    [31:0]            current_cut_done_sq27id_reg   ;
input    [31:0]            current_cut_done_sq28id_reg   ;
input    [31:0]            current_cut_done_sq29id_reg   ;
input    [31:0]            current_cut_done_sq30id_reg   ;
input    [31:0]            current_cut_done_sq31id_reg   ;
input    [31:0]            current_sqcut_done            ;

input    [31:0]            current_sqid_reg              ;
input                      current_sqid_reg_vld          ;

output   [15:0]            sq_cut_len_reg                ;


/////////////////////////////////////////////////////////////////////////////////////
reg                        st_rx_start_dly        ; 
reg      [ 3:0]            st_rx_offset_dly       ;
reg                        st_rx_end_dly          ; 
reg                        st_rx_valid_dly        ; 
reg      [63:0]            st_rx_data_dly         ; 
reg      [ 2:0]            st_rx_empty_dly        ; 
reg      [15:0]            st_rx_cnt_dly          ; 
reg      [15:0]            first_sync_len_byte_dly;                                      
reg      [31:0]            tcp_sqmatch_flag_dly   ;  //match with pre  SQ tcp frame 
reg                        tcp_sqmatch_flag_1bit_dly ;
reg      [15:0]            tcp_payload_len_dly    ;
reg                        seq_err_flag_dly     ;
                  

reg      [31:0]            sq_cut_on           ;
reg      [31:0]            sq_cut_on_dly       ;


reg      [31:0]            sq_cut_reset_pre   ;  //cut _flag
reg      [31:0]            sq_cut_flag        ;  //cut _flag                          

reg      [31:0]            sq_cut_flag_dly   ;  //cut _flag                          

 
/////////////////////////////////////////////////////////////////////////////////////
reg      [15:0]            st_rq00_cut_cnt     ;
reg      [15:0]            st_rq01_cut_cnt     ;
reg      [15:0]            st_rq02_cut_cnt     ;
reg      [15:0]            st_rq03_cut_cnt     ;
reg      [15:0]            st_rq04_cut_cnt     ;
reg      [15:0]            st_rq05_cut_cnt     ;
reg      [15:0]            st_rq06_cut_cnt     ;
reg      [15:0]            st_rq07_cut_cnt     ;
reg      [15:0]            st_rq08_cut_cnt     ;
reg      [15:0]            st_rq09_cut_cnt     ;
reg      [15:0]            st_rq10_cut_cnt     ;
reg      [15:0]            st_rq11_cut_cnt     ;
reg      [15:0]            st_rq12_cut_cnt     ;
reg      [15:0]            st_rq13_cut_cnt     ;
reg      [15:0]            st_rq14_cut_cnt     ;
reg      [15:0]            st_rq15_cut_cnt     ;
reg      [15:0]            st_rq16_cut_cnt     ;
reg      [15:0]            st_rq17_cut_cnt     ;
reg      [15:0]            st_rq18_cut_cnt     ;
reg      [15:0]            st_rq19_cut_cnt     ;
reg      [15:0]            st_rq20_cut_cnt     ;
reg      [15:0]            st_rq21_cut_cnt     ;
reg      [15:0]            st_rq22_cut_cnt     ;
reg      [15:0]            st_rq23_cut_cnt     ;
reg      [15:0]            st_rq24_cut_cnt     ;
reg      [15:0]            st_rq25_cut_cnt     ;
reg      [15:0]            st_rq26_cut_cnt     ;
reg      [15:0]            st_rq27_cut_cnt     ;
reg      [15:0]            st_rq28_cut_cnt     ;
reg      [15:0]            st_rq29_cut_cnt     ;
reg      [15:0]            st_rq30_cut_cnt     ;
reg      [15:0]            st_rq31_cut_cnt     ;

reg      [15:0]            sq_cut_len_reg      ;

reg      [31:0]            current_cut_sq00id_reg   ;
reg      [31:0]            current_cut_sq01id_reg   ;
reg      [31:0]            current_cut_sq02id_reg   ;
reg      [31:0]            current_cut_sq03id_reg   ;
reg      [31:0]            current_cut_sq04id_reg   ;
reg      [31:0]            current_cut_sq05id_reg   ;
reg      [31:0]            current_cut_sq06id_reg   ;
reg      [31:0]            current_cut_sq07id_reg   ;
reg      [31:0]            current_cut_sq08id_reg   ;
reg      [31:0]            current_cut_sq09id_reg   ;
reg      [31:0]            current_cut_sq10id_reg   ;
reg      [31:0]            current_cut_sq11id_reg   ;
reg      [31:0]            current_cut_sq12id_reg   ;
reg      [31:0]            current_cut_sq13id_reg   ;
reg      [31:0]            current_cut_sq14id_reg   ;
reg      [31:0]            current_cut_sq15id_reg   ;
reg      [31:0]            current_cut_sq16id_reg   ;
reg      [31:0]            current_cut_sq17id_reg   ;
reg      [31:0]            current_cut_sq18id_reg   ;
reg      [31:0]            current_cut_sq19id_reg   ;
reg      [31:0]            current_cut_sq20id_reg   ;
reg      [31:0]            current_cut_sq21id_reg   ;
reg      [31:0]            current_cut_sq22id_reg   ;
reg      [31:0]            current_cut_sq23id_reg   ;
reg      [31:0]            current_cut_sq24id_reg   ;
reg      [31:0]            current_cut_sq25id_reg   ;
reg      [31:0]            current_cut_sq26id_reg   ;
reg      [31:0]            current_cut_sq27id_reg   ;
reg      [31:0]            current_cut_sq28id_reg   ;
reg      [31:0]            current_cut_sq29id_reg   ;
reg      [31:0]            current_cut_sq30id_reg   ;
reg      [31:0]            current_cut_sq31id_reg   ;


reg      [31:0]            current_cut_done_sqid_reg   ;
//////////////////////////////////////////////////////////////////////////////////////////////
reg      [31:0]            sq_cut_first_on     ;

reg      [15:0]            st_rq_cut_cnt       ;
         
wire     [15:0]   sub_sqcut_len_reg  =  (sq_cut_len_reg - st_rq_cut_cnt) ;

//////////////////////////////////////////////////////////////////////////////////////////////

// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // st_rq00_cut_cnt   <=   16'd0    ;
  // end
  // else if ( fir_r_sqcuth_st  &&  ~sq_cut_on[0] )  begin
      // st_rq00_cut_cnt   <=   st_rx_cnt_reg ;
  // end
  // else if ( fir_r_vsync_st &&  (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sq_frame_flag && current_sqid_reg_flag &&  ~sq_cut_on[0] ) begin
      // st_rq00_cut_cnt  <=    16'd8   ;   
  // end
  // else if ( (fir_r_sqcut_st )  && (st_shift_ccnt>=6'd8) &&  sq_cut_first_on[0] ) begin
      // st_rq00_cut_cnt  <=    st_rq00_cut_cnt +  16'd8   ;   
  // end
  // else if ((fir_r_sqcut_end_st )  && (st_shift_ccnt>=st_rx_cnt_reg) &&  sq_cut_first_on[0] ) begin
      // st_rq00_cut_cnt  <=    st_rq00_cut_cnt +  st_rx_cnt_reg   ;        
  // end
  // else if (fir_r_sqrcut_st &&  (st_shift_ccnt>=16'd8)  ) begin
     // st_rq00_cut_cnt  <=    st_rq00_cut_cnt +  16'd8   ;   
  // end
  // else if (fir_r_sqrcut_end_st &&  (st_shift_ccnt>=sub_sqcut_len_reg)  ) begin
     // st_rq00_cut_cnt  <=    st_rq00_cut_cnt +  sub_sqcut_len_reg   ;   
  // end
// end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rq00_cut_cnt   <=   16'd0    ;
	  st_rq01_cut_cnt   <=   16'd0    ;
	  st_rq02_cut_cnt   <=   16'd0    ;
	  st_rq03_cut_cnt   <=   16'd0    ;
	  st_rq04_cut_cnt   <=   16'd0    ;
	  st_rq05_cut_cnt   <=   16'd0    ;
	  st_rq06_cut_cnt   <=   16'd0    ;
	  st_rq07_cut_cnt   <=   16'd0    ;
	  st_rq08_cut_cnt   <=   16'd0    ;
	  st_rq09_cut_cnt   <=   16'd0    ;
	  st_rq10_cut_cnt   <=   16'd0    ;
	  st_rq11_cut_cnt   <=   16'd0    ;
	  st_rq12_cut_cnt   <=   16'd0    ;
	  st_rq13_cut_cnt   <=   16'd0    ;
	  st_rq14_cut_cnt   <=   16'd0    ;
	  st_rq15_cut_cnt   <=   16'd0    ;
	  st_rq16_cut_cnt   <=   16'd0    ;
	  st_rq17_cut_cnt   <=   16'd0    ;
	  st_rq18_cut_cnt   <=   16'd0    ;
	  st_rq19_cut_cnt   <=   16'd0    ;
	  st_rq20_cut_cnt   <=   16'd0    ;
	  st_rq21_cut_cnt   <=   16'd0    ;
	  st_rq22_cut_cnt   <=   16'd0    ;
	  st_rq23_cut_cnt   <=   16'd0    ;
	  st_rq24_cut_cnt   <=   16'd0    ;
	  st_rq25_cut_cnt   <=   16'd0    ;
	  st_rq26_cut_cnt   <=   16'd0    ;
	  st_rq27_cut_cnt   <=   16'd0    ;
	  st_rq28_cut_cnt   <=   16'd0    ;
	  st_rq29_cut_cnt   <=   16'd0    ;
	  st_rq30_cut_cnt   <=   16'd0    ;
	  st_rq31_cut_cnt   <=   16'd0    ;
  end
  else if ( fir_r_sqcuth_st  && (st_shift_ccnt>=st_rx_cnt_reg)   )  begin
	  if (~sq_cut_on_dly[ 0]                           )   st_rq00_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 1] && ( sq_cut_on_dly[   0]) )   st_rq01_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 2] && (&sq_cut_on_dly[ 1:0]) )   st_rq02_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 3] && (&sq_cut_on_dly[ 2:0]) )   st_rq03_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 4] && (&sq_cut_on_dly[ 3:0]) )   st_rq04_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 5] && (&sq_cut_on_dly[ 4:0]) )   st_rq05_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 6] && (&sq_cut_on_dly[ 5:0]) )   st_rq06_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 7] && (&sq_cut_on_dly[ 6:0]) )   st_rq07_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 8] && (&sq_cut_on_dly[ 7:0]) )   st_rq08_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[ 9] && (&sq_cut_on_dly[ 8:0]) )   st_rq09_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[10] && (&sq_cut_on_dly[ 9:0]) )   st_rq10_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[11] && (&sq_cut_on_dly[10:0]) )   st_rq11_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[12] && (&sq_cut_on_dly[11:0]) )   st_rq12_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[13] && (&sq_cut_on_dly[12:0]) )   st_rq13_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[14] && (&sq_cut_on_dly[13:0]) )   st_rq14_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[15] && (&sq_cut_on_dly[14:0]) )   st_rq15_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[16] && (&sq_cut_on_dly[15:0]) )   st_rq16_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[17] && (&sq_cut_on_dly[16:0]) )   st_rq17_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[18] && (&sq_cut_on_dly[17:0]) )   st_rq18_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[19] && (&sq_cut_on_dly[18:0]) )   st_rq19_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[20] && (&sq_cut_on_dly[19:0]) )   st_rq20_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[21] && (&sq_cut_on_dly[20:0]) )   st_rq21_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[22] && (&sq_cut_on_dly[21:0]) )   st_rq22_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[23] && (&sq_cut_on_dly[22:0]) )   st_rq23_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[24] && (&sq_cut_on_dly[23:0]) )   st_rq24_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[25] && (&sq_cut_on_dly[24:0]) )   st_rq25_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[26] && (&sq_cut_on_dly[25:0]) )   st_rq26_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[27] && (&sq_cut_on_dly[26:0]) )   st_rq27_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[28] && (&sq_cut_on_dly[27:0]) )   st_rq28_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[29] && (&sq_cut_on_dly[28:0]) )   st_rq29_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[30] && (&sq_cut_on_dly[29:0]) )   st_rq30_cut_cnt   <=   st_rx_cnt_reg    ;
	  if (~sq_cut_on_dly[31] && (&sq_cut_on_dly[30:0]) )   st_rq31_cut_cnt   <=   st_rx_cnt_reg    ;
  end
//  else if ( fir_r_vsync_st &&  (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sq_frame_flag && current_sqid_reg_flag  ) begin
  else if ( fir_r_vsync_st &&  (st_shift_ccnt>=6'd8) && sq_frame_flag && current_sqid_reg_flag  ) begin
          if (~sq_cut_on[ 0]                       )   st_rq00_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 1] && ( sq_cut_on[   0]) )   st_rq01_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) )   st_rq02_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) )   st_rq03_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) )   st_rq04_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) )   st_rq05_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) )   st_rq06_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) )   st_rq07_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) )   st_rq08_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) )   st_rq09_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[10] && (&sq_cut_on[ 9:0]) )   st_rq10_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[11] && (&sq_cut_on[10:0]) )   st_rq11_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[12] && (&sq_cut_on[11:0]) )   st_rq12_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[13] && (&sq_cut_on[12:0]) )   st_rq13_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[14] && (&sq_cut_on[13:0]) )   st_rq14_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[15] && (&sq_cut_on[14:0]) )   st_rq15_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[16] && (&sq_cut_on[15:0]) )   st_rq16_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[17] && (&sq_cut_on[16:0]) )   st_rq17_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[18] && (&sq_cut_on[17:0]) )   st_rq18_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[19] && (&sq_cut_on[18:0]) )   st_rq19_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[20] && (&sq_cut_on[19:0]) )   st_rq20_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[21] && (&sq_cut_on[20:0]) )   st_rq21_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[22] && (&sq_cut_on[21:0]) )   st_rq22_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[23] && (&sq_cut_on[22:0]) )   st_rq23_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[24] && (&sq_cut_on[23:0]) )   st_rq24_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[25] && (&sq_cut_on[24:0]) )   st_rq25_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[26] && (&sq_cut_on[25:0]) )   st_rq26_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[27] && (&sq_cut_on[26:0]) )   st_rq27_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[28] && (&sq_cut_on[27:0]) )   st_rq28_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[29] && (&sq_cut_on[28:0]) )   st_rq29_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[30] && (&sq_cut_on[29:0]) )   st_rq30_cut_cnt   <=   16'd8  ;
	  if (~sq_cut_on[31] && (&sq_cut_on[30:0]) )   st_rq31_cut_cnt   <=   16'd8  ;	  
  end
  else if ( (fir_r_sqcut_st )  && (st_shift_ccnt>=6'd8)  ) begin
	  if (sq_cut_first_on[ 0] )   st_rq00_cut_cnt   <=   st_rq00_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 1] )   st_rq01_cut_cnt   <=   st_rq01_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 2] )   st_rq02_cut_cnt   <=   st_rq02_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 3] )   st_rq03_cut_cnt   <=   st_rq03_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 4] )   st_rq04_cut_cnt   <=   st_rq04_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 5] )   st_rq05_cut_cnt   <=   st_rq05_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 6] )   st_rq06_cut_cnt   <=   st_rq06_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 7] )   st_rq07_cut_cnt   <=   st_rq07_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 8] )   st_rq08_cut_cnt   <=   st_rq08_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[ 9] )   st_rq09_cut_cnt   <=   st_rq09_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[10] )   st_rq10_cut_cnt   <=   st_rq10_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[11] )   st_rq11_cut_cnt   <=   st_rq11_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[12] )   st_rq12_cut_cnt   <=   st_rq12_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[13] )   st_rq13_cut_cnt   <=   st_rq13_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[14] )   st_rq14_cut_cnt   <=   st_rq14_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[15] )   st_rq15_cut_cnt   <=   st_rq15_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[16] )   st_rq16_cut_cnt   <=   st_rq16_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[17] )   st_rq17_cut_cnt   <=   st_rq17_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[18] )   st_rq18_cut_cnt   <=   st_rq18_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[19] )   st_rq19_cut_cnt   <=   st_rq19_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[20] )   st_rq20_cut_cnt   <=   st_rq20_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[21] )   st_rq21_cut_cnt   <=   st_rq21_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[22] )   st_rq22_cut_cnt   <=   st_rq22_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[23] )   st_rq23_cut_cnt   <=   st_rq23_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[24] )   st_rq24_cut_cnt   <=   st_rq24_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[25] )   st_rq25_cut_cnt   <=   st_rq25_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[26] )   st_rq26_cut_cnt   <=   st_rq26_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[27] )   st_rq27_cut_cnt   <=   st_rq27_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[28] )   st_rq28_cut_cnt   <=   st_rq28_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[29] )   st_rq29_cut_cnt   <=   st_rq29_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[30] )   st_rq30_cut_cnt   <=   st_rq30_cut_cnt +  16'd8  ;
	  if (sq_cut_first_on[31] )   st_rq31_cut_cnt   <=   st_rq31_cut_cnt +  16'd8  ;	
  end
  else if ((fir_r_sqcut_end_st )  && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
      if (sq_cut_first_on[ 0] )   st_rq00_cut_cnt   <=   st_rq00_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 1] )   st_rq01_cut_cnt   <=   st_rq01_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 2] )   st_rq02_cut_cnt   <=   st_rq02_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 3] )   st_rq03_cut_cnt   <=   st_rq03_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 4] )   st_rq04_cut_cnt   <=   st_rq04_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 5] )   st_rq05_cut_cnt   <=   st_rq05_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 6] )   st_rq06_cut_cnt   <=   st_rq06_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 7] )   st_rq07_cut_cnt   <=   st_rq07_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 8] )   st_rq08_cut_cnt   <=   st_rq08_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[ 9] )   st_rq09_cut_cnt   <=   st_rq09_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[10] )   st_rq10_cut_cnt   <=   st_rq10_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[11] )   st_rq11_cut_cnt   <=   st_rq11_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[12] )   st_rq12_cut_cnt   <=   st_rq12_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[13] )   st_rq13_cut_cnt   <=   st_rq13_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[14] )   st_rq14_cut_cnt   <=   st_rq14_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[15] )   st_rq15_cut_cnt   <=   st_rq15_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[16] )   st_rq16_cut_cnt   <=   st_rq16_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[17] )   st_rq17_cut_cnt   <=   st_rq17_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[18] )   st_rq18_cut_cnt   <=   st_rq18_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[19] )   st_rq19_cut_cnt   <=   st_rq19_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[20] )   st_rq20_cut_cnt   <=   st_rq20_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[21] )   st_rq21_cut_cnt   <=   st_rq21_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[22] )   st_rq22_cut_cnt   <=   st_rq22_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[23] )   st_rq23_cut_cnt   <=   st_rq23_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[24] )   st_rq24_cut_cnt   <=   st_rq24_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[25] )   st_rq25_cut_cnt   <=   st_rq25_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[26] )   st_rq26_cut_cnt   <=   st_rq26_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[27] )   st_rq27_cut_cnt   <=   st_rq27_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[28] )   st_rq28_cut_cnt   <=   st_rq28_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[29] )   st_rq29_cut_cnt   <=   st_rq29_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[30] )   st_rq30_cut_cnt   <=   st_rq30_cut_cnt +  st_rx_cnt_reg ;
	  if (sq_cut_first_on[31] )   st_rq31_cut_cnt   <=   st_rq31_cut_cnt +  st_rx_cnt_reg ;		  
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rq_cut_cnt   <=   16'd0    ;
  end
  else if ( st_rx_start&&st_rx_valid&&(|tcp_sqmatch_flag) )  begin
      case (tcp_sqmatch_flag)
	  32'h0000_0001: st_rq_cut_cnt   <=   st_rq00_cut_cnt ;
	  32'h0000_0002: st_rq_cut_cnt   <=   st_rq01_cut_cnt ;
	  32'h0000_0004: st_rq_cut_cnt   <=   st_rq02_cut_cnt ;
	  32'h0000_0008: st_rq_cut_cnt   <=   st_rq03_cut_cnt ;
	  32'h0000_0010: st_rq_cut_cnt   <=   st_rq04_cut_cnt ;
	  32'h0000_0020: st_rq_cut_cnt   <=   st_rq05_cut_cnt ;
	  32'h0000_0040: st_rq_cut_cnt   <=   st_rq06_cut_cnt ;
	  32'h0000_0080: st_rq_cut_cnt   <=   st_rq07_cut_cnt ;
	  32'h0000_0100: st_rq_cut_cnt   <=   st_rq08_cut_cnt ;
	  32'h0000_0200: st_rq_cut_cnt   <=   st_rq09_cut_cnt ;
	  32'h0000_0400: st_rq_cut_cnt   <=   st_rq10_cut_cnt ;
	  32'h0000_0800: st_rq_cut_cnt   <=   st_rq11_cut_cnt ;
	  32'h0000_1000: st_rq_cut_cnt   <=   st_rq12_cut_cnt ;
	  32'h0000_2000: st_rq_cut_cnt   <=   st_rq13_cut_cnt ;
	  32'h0000_4000: st_rq_cut_cnt   <=   st_rq14_cut_cnt ;
	  32'h0000_8000: st_rq_cut_cnt   <=   st_rq15_cut_cnt ;
	  32'h0001_0000: st_rq_cut_cnt   <=   st_rq16_cut_cnt ;
	  32'h0002_0000: st_rq_cut_cnt   <=   st_rq17_cut_cnt ;
	  32'h0004_0000: st_rq_cut_cnt   <=   st_rq18_cut_cnt ;
	  32'h0008_0000: st_rq_cut_cnt   <=   st_rq19_cut_cnt ;
	  32'h0010_0000: st_rq_cut_cnt   <=   st_rq20_cut_cnt ;
	  32'h0020_0000: st_rq_cut_cnt   <=   st_rq21_cut_cnt ;
	  32'h0040_0000: st_rq_cut_cnt   <=   st_rq22_cut_cnt ;
	  32'h0080_0000: st_rq_cut_cnt   <=   st_rq23_cut_cnt ;
	  32'h0100_0000: st_rq_cut_cnt   <=   st_rq24_cut_cnt ;
	  32'h0200_0000: st_rq_cut_cnt   <=   st_rq25_cut_cnt ;
	  32'h0400_0000: st_rq_cut_cnt   <=   st_rq26_cut_cnt ;
	  32'h0800_0000: st_rq_cut_cnt   <=   st_rq27_cut_cnt ;
	  32'h1000_0000: st_rq_cut_cnt   <=   st_rq28_cut_cnt ;
	  32'h2000_0000: st_rq_cut_cnt   <=   st_rq29_cut_cnt ;
	  32'h4000_0000: st_rq_cut_cnt   <=   st_rq30_cut_cnt ;
	  default      : st_rq_cut_cnt   <=   st_rq31_cut_cnt ;
	  endcase
  end
  else if (fir_r_sqrcut_st &&  (st_shift_ccnt>=16'd8)  ) begin
      st_rq_cut_cnt  <=    st_rq_cut_cnt +  16'd8   ;   
  end
  else if (fir_r_sqrcut_end_st &&  (st_shift_ccnt>=sub_sqcut_len_reg)  ) begin
      st_rq_cut_cnt  <=    st_rq_cut_cnt +  sub_sqcut_len_reg   ;   
  end
end
//sq_cut_len_reg
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_len_reg   <=   16'd0    ;
  end
//  else if ( st_rx_start&&st_rx_valid&&(|tcp_sqmatch_flag) )  begin
  else if ( |tcp_sqmatch_flag )  begin
      case (tcp_sqmatch_flag)
	  32'h0000_0001: sq_cut_len_reg   <=   sq00_cut_len_reg ;
	  32'h0000_0002: sq_cut_len_reg   <=   sq01_cut_len_reg ;
	  32'h0000_0004: sq_cut_len_reg   <=   sq02_cut_len_reg ;
	  32'h0000_0008: sq_cut_len_reg   <=   sq03_cut_len_reg ;
	  32'h0000_0010: sq_cut_len_reg   <=   sq04_cut_len_reg ;
	  32'h0000_0020: sq_cut_len_reg   <=   sq05_cut_len_reg ;
	  32'h0000_0040: sq_cut_len_reg   <=   sq06_cut_len_reg ;
	  32'h0000_0080: sq_cut_len_reg   <=   sq07_cut_len_reg ;
	  32'h0000_0100: sq_cut_len_reg   <=   sq08_cut_len_reg ;
	  32'h0000_0200: sq_cut_len_reg   <=   sq09_cut_len_reg ;
	  32'h0000_0400: sq_cut_len_reg   <=   sq10_cut_len_reg ;
	  32'h0000_0800: sq_cut_len_reg   <=   sq11_cut_len_reg ;
	  32'h0000_1000: sq_cut_len_reg   <=   sq12_cut_len_reg ;
	  32'h0000_2000: sq_cut_len_reg   <=   sq13_cut_len_reg ;
	  32'h0000_4000: sq_cut_len_reg   <=   sq14_cut_len_reg ;
	  32'h0000_8000: sq_cut_len_reg   <=   sq15_cut_len_reg ;
	  32'h0001_0000: sq_cut_len_reg   <=   sq16_cut_len_reg ;
	  32'h0002_0000: sq_cut_len_reg   <=   sq17_cut_len_reg ;
	  32'h0004_0000: sq_cut_len_reg   <=   sq18_cut_len_reg ;
	  32'h0008_0000: sq_cut_len_reg   <=   sq19_cut_len_reg ;
	  32'h0010_0000: sq_cut_len_reg   <=   sq20_cut_len_reg ;
	  32'h0020_0000: sq_cut_len_reg   <=   sq21_cut_len_reg ;
	  32'h0040_0000: sq_cut_len_reg   <=   sq22_cut_len_reg ;
	  32'h0080_0000: sq_cut_len_reg   <=   sq23_cut_len_reg ;
	  32'h0100_0000: sq_cut_len_reg   <=   sq24_cut_len_reg ;
	  32'h0200_0000: sq_cut_len_reg   <=   sq25_cut_len_reg ;
	  32'h0400_0000: sq_cut_len_reg   <=   sq26_cut_len_reg ;
	  32'h0800_0000: sq_cut_len_reg   <=   sq27_cut_len_reg ;
	  32'h1000_0000: sq_cut_len_reg   <=   sq28_cut_len_reg ;
	  32'h2000_0000: sq_cut_len_reg   <=   sq29_cut_len_reg ;
	  32'h4000_0000: sq_cut_len_reg   <=   sq30_cut_len_reg ;
	  default :      sq_cut_len_reg   <=   sq31_cut_len_reg ;
	  endcase
  end
end


///////////////////////////////////////////////////////////////////////////////////////////////////
//reg                        st_rx_start_dly        ; 
//reg      [ 3:0]            st_rx_offset_dly       ;
//reg                        st_rx_end_dly          ; 
//reg                        st_rx_valid_dly        ; 
//reg      [63:0]            st_rx_data_dly         ; 
//reg      [ 2:0]            st_rx_empty_dly        ; 
//reg      [15:0]            st_rx_cnt_dly          ; 
//reg      [15:0]            first_sync_len_byte_dly;                                      
//reg      [31:0]            tcp_sqmatch_flag_dly   ;  //match with pre  SQ tcp frame 
//reg      [15:0]            tcp_payload_len_dly    ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rx_start_dly   <=   1'd0    ;
	  st_rx_offset_dly  <=   4'd0    ;
	  st_rx_end_dly     <=   1'd0    ;
	  st_rx_valid_dly   <=   1'd0    ;
	  st_rx_data_dly    <=  64'd0    ;
	  st_rx_cnt_dly     <=  16'd0    ;
	  first_sync_len_byte_dly <= 16'd0 ;
	  tcp_sqmatch_flag_dly    <= 32'd0 ;
	  tcp_sqmatch_flag_1bit_dly <= 1'd0 ;
	  tcp_payload_len_dly     <= 32'd0 ;
	  seq_err_flag_dly    <=  1'd0  ;
	  st_rx_empty_dly  <= 'd0 ;
  end
  else  begin
      st_rx_start_dly   <=   st_rx_start && st_rx_valid    ;
	  st_rx_offset_dly  <=   st_rx_valid ?  st_rx_offset  :   st_rx_offset_dly                ;
	  st_rx_end_dly     <=   st_rx_end   && st_rx_valid    ;
	  st_rx_valid_dly   <=   st_rx_valid                   ;
	  st_rx_data_dly    <=   st_rx_valid ?  st_rx_data :  st_rx_data_dly    ;
	  st_rx_empty_dly   <=   st_rx_valid ?  st_rx_empty   :  st_rx_empty_dly ;
	  st_rx_cnt_dly     <=   st_rx_valid ?  st_rx_cnt     :  st_rx_cnt_dly ;
	  first_sync_len_byte_dly <= st_rx_start && st_rx_valid ?  first_sync_len_byte     :  first_sync_len_byte_dly ;
	  tcp_sqmatch_flag_dly    <= st_rx_start && st_rx_valid ?  tcp_sqmatch_flag        :  tcp_sqmatch_flag_dly    ;
	  tcp_sqmatch_flag_1bit_dly <= st_rx_start && st_rx_valid ?  (|tcp_sqmatch_flag)        :  tcp_sqmatch_flag_1bit_dly    ;
	  tcp_payload_len_dly     <= st_rx_start && st_rx_valid ?  tcp_payload_len         :  tcp_payload_len_dly    ;
	  seq_err_flag_dly    <= st_rx_start && st_rx_valid ?  (|seq_err_flag)   :    seq_err_flag_dly  ;
  end
end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_first_on       <=   32'd0 ; 
  end
  else if ( fir_r_vsync_st  &&   (st_rx_cnt_reg<(sync_len_byte+16'd4))  &&  (st_shift_ccnt>=6'd8)  &&  sq_frame_flag  &&  current_sqid_reg_flag &&  (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)   ) begin 
      sq_cut_first_on[ 0]   <=    ~sq_cut_on[ 0]                       ; 
	  sq_cut_first_on[ 1]   <=    ~sq_cut_on[ 1] && ( sq_cut_on[   0]) ; 
	  sq_cut_first_on[ 2]   <=    ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ; 
	  sq_cut_first_on[ 3]   <=    ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ; 
	  sq_cut_first_on[ 4]   <=    ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ; 
	  sq_cut_first_on[ 5]   <=    ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ; 
	  sq_cut_first_on[ 6]   <=    ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ; 
	  sq_cut_first_on[ 7]   <=    ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ; 
	  sq_cut_first_on[ 8]   <=    ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ; 
	  sq_cut_first_on[ 9]   <=    ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ; 
	  sq_cut_first_on[10]   <=    ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ; 
	  sq_cut_first_on[11]   <=    ~sq_cut_on[11] && (&sq_cut_on[10:0]) ; 
	  sq_cut_first_on[12]   <=    ~sq_cut_on[12] && (&sq_cut_on[11:0]) ; 
	  sq_cut_first_on[13]   <=    ~sq_cut_on[13] && (&sq_cut_on[12:0]) ; 
	  sq_cut_first_on[14]   <=    ~sq_cut_on[14] && (&sq_cut_on[13:0]) ; 
	  sq_cut_first_on[15]   <=    ~sq_cut_on[15] && (&sq_cut_on[14:0]) ; 
	  sq_cut_first_on[16]   <=    ~sq_cut_on[16] && (&sq_cut_on[15:0]) ; 
	  sq_cut_first_on[17]   <=    ~sq_cut_on[17] && (&sq_cut_on[16:0]) ; 
	  sq_cut_first_on[18]   <=    ~sq_cut_on[18] && (&sq_cut_on[17:0]) ; 
	  sq_cut_first_on[19]   <=    ~sq_cut_on[19] && (&sq_cut_on[18:0]) ; 
	  sq_cut_first_on[20]   <=    ~sq_cut_on[20] && (&sq_cut_on[19:0]) ; 
	  sq_cut_first_on[21]   <=    ~sq_cut_on[21] && (&sq_cut_on[20:0]) ; 
	  sq_cut_first_on[22]   <=    ~sq_cut_on[22] && (&sq_cut_on[21:0]) ; 
	  sq_cut_first_on[23]   <=    ~sq_cut_on[23] && (&sq_cut_on[22:0]) ; 
	  sq_cut_first_on[24]   <=    ~sq_cut_on[24] && (&sq_cut_on[23:0]) ; 
	  sq_cut_first_on[25]   <=    ~sq_cut_on[25] && (&sq_cut_on[24:0]) ; 
	  sq_cut_first_on[26]   <=    ~sq_cut_on[26] && (&sq_cut_on[25:0]) ; 
	  sq_cut_first_on[27]   <=    ~sq_cut_on[27] && (&sq_cut_on[26:0]) ; 
	  sq_cut_first_on[28]   <=    ~sq_cut_on[28] && (&sq_cut_on[27:0]) ; 
	  sq_cut_first_on[29]   <=    ~sq_cut_on[29] && (&sq_cut_on[28:0]) ; 
	  sq_cut_first_on[30]   <=    ~sq_cut_on[30] && (&sq_cut_on[29:0]) ; 
	  sq_cut_first_on[31]   <=    ~sq_cut_on[31] && (&sq_cut_on[30:0]) ; 
  end
  else if (fir_r_rjudge_st &&  sq_frame_flag  &&  current_sqid_reg_flag &&  (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ) begin
      sq_cut_first_on[ 0]   <=    ~sq_cut_on[ 0]                       ; 
	  sq_cut_first_on[ 1]   <=    ~sq_cut_on[ 1] && ( sq_cut_on[   0]) ; 
	  sq_cut_first_on[ 2]   <=    ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ; 
	  sq_cut_first_on[ 3]   <=    ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ; 
	  sq_cut_first_on[ 4]   <=    ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ; 
	  sq_cut_first_on[ 5]   <=    ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ; 
	  sq_cut_first_on[ 6]   <=    ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ; 
	  sq_cut_first_on[ 7]   <=    ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ; 
	  sq_cut_first_on[ 8]   <=    ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ; 
	  sq_cut_first_on[ 9]   <=    ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ; 
	  sq_cut_first_on[10]   <=    ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ; 
	  sq_cut_first_on[11]   <=    ~sq_cut_on[11] && (&sq_cut_on[10:0]) ; 
	  sq_cut_first_on[12]   <=    ~sq_cut_on[12] && (&sq_cut_on[11:0]) ; 
	  sq_cut_first_on[13]   <=    ~sq_cut_on[13] && (&sq_cut_on[12:0]) ; 
	  sq_cut_first_on[14]   <=    ~sq_cut_on[14] && (&sq_cut_on[13:0]) ; 
	  sq_cut_first_on[15]   <=    ~sq_cut_on[15] && (&sq_cut_on[14:0]) ; 
	  sq_cut_first_on[16]   <=    ~sq_cut_on[16] && (&sq_cut_on[15:0]) ; 
	  sq_cut_first_on[17]   <=    ~sq_cut_on[17] && (&sq_cut_on[16:0]) ; 
	  sq_cut_first_on[18]   <=    ~sq_cut_on[18] && (&sq_cut_on[17:0]) ; 
	  sq_cut_first_on[19]   <=    ~sq_cut_on[19] && (&sq_cut_on[18:0]) ; 
	  sq_cut_first_on[20]   <=    ~sq_cut_on[20] && (&sq_cut_on[19:0]) ; 
	  sq_cut_first_on[21]   <=    ~sq_cut_on[21] && (&sq_cut_on[20:0]) ; 
	  sq_cut_first_on[22]   <=    ~sq_cut_on[22] && (&sq_cut_on[21:0]) ; 
	  sq_cut_first_on[23]   <=    ~sq_cut_on[23] && (&sq_cut_on[22:0]) ; 
	  sq_cut_first_on[24]   <=    ~sq_cut_on[24] && (&sq_cut_on[23:0]) ; 
	  sq_cut_first_on[25]   <=    ~sq_cut_on[25] && (&sq_cut_on[24:0]) ; 
	  sq_cut_first_on[26]   <=    ~sq_cut_on[26] && (&sq_cut_on[25:0]) ; 
	  sq_cut_first_on[27]   <=    ~sq_cut_on[27] && (&sq_cut_on[26:0]) ; 
	  sq_cut_first_on[28]   <=    ~sq_cut_on[28] && (&sq_cut_on[27:0]) ; 
	  sq_cut_first_on[29]   <=    ~sq_cut_on[29] && (&sq_cut_on[28:0]) ; 
	  sq_cut_first_on[30]   <=    ~sq_cut_on[30] && (&sq_cut_on[29:0]) ; 
	  sq_cut_first_on[31]   <=    ~sq_cut_on[31] && (&sq_cut_on[30:0]) ; 
  end 
  else if  (fir_r_idle_st)  begin
      sq_cut_first_on   <=  32'd0    ;
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_flag       <=   32'd0 ; 
  end
  else if ( fir_r_vsync_st  &&   (st_rx_cnt_reg<(sync_len_byte+16'd4))  &&  (st_shift_ccnt>=6'd8)  &&  sq_frame_flag  &&  current_sqid_reg_flag &&  (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)   ) begin 
      sq_cut_flag[ 0]   <=    ~sq_cut_on[ 0]                       ; 
	  sq_cut_flag[ 1]   <=    ~sq_cut_on[ 1] && ( sq_cut_on[   0]) ; 
	  sq_cut_flag[ 2]   <=    ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ; 
	  sq_cut_flag[ 3]   <=    ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ; 
	  sq_cut_flag[ 4]   <=    ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ; 
	  sq_cut_flag[ 5]   <=    ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ; 
	  sq_cut_flag[ 6]   <=    ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ; 
	  sq_cut_flag[ 7]   <=    ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ; 
	  sq_cut_flag[ 8]   <=    ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ; 
	  sq_cut_flag[ 9]   <=    ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ; 
	  sq_cut_flag[10]   <=    ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ; 
	  sq_cut_flag[11]   <=    ~sq_cut_on[11] && (&sq_cut_on[10:0]) ; 
	  sq_cut_flag[12]   <=    ~sq_cut_on[12] && (&sq_cut_on[11:0]) ; 
	  sq_cut_flag[13]   <=    ~sq_cut_on[13] && (&sq_cut_on[12:0]) ; 
	  sq_cut_flag[14]   <=    ~sq_cut_on[14] && (&sq_cut_on[13:0]) ; 
	  sq_cut_flag[15]   <=    ~sq_cut_on[15] && (&sq_cut_on[14:0]) ; 
	  sq_cut_flag[16]   <=    ~sq_cut_on[16] && (&sq_cut_on[15:0]) ; 
	  sq_cut_flag[17]   <=    ~sq_cut_on[17] && (&sq_cut_on[16:0]) ; 
	  sq_cut_flag[18]   <=    ~sq_cut_on[18] && (&sq_cut_on[17:0]) ; 
	  sq_cut_flag[19]   <=    ~sq_cut_on[19] && (&sq_cut_on[18:0]) ; 
	  sq_cut_flag[20]   <=    ~sq_cut_on[20] && (&sq_cut_on[19:0]) ; 
	  sq_cut_flag[21]   <=    ~sq_cut_on[21] && (&sq_cut_on[20:0]) ; 
	  sq_cut_flag[22]   <=    ~sq_cut_on[22] && (&sq_cut_on[21:0]) ; 
	  sq_cut_flag[23]   <=    ~sq_cut_on[23] && (&sq_cut_on[22:0]) ; 
	  sq_cut_flag[24]   <=    ~sq_cut_on[24] && (&sq_cut_on[23:0]) ; 
	  sq_cut_flag[25]   <=    ~sq_cut_on[25] && (&sq_cut_on[24:0]) ; 
	  sq_cut_flag[26]   <=    ~sq_cut_on[26] && (&sq_cut_on[25:0]) ; 
	  sq_cut_flag[27]   <=    ~sq_cut_on[27] && (&sq_cut_on[26:0]) ; 
	  sq_cut_flag[28]   <=    ~sq_cut_on[28] && (&sq_cut_on[27:0]) ; 
	  sq_cut_flag[29]   <=    ~sq_cut_on[29] && (&sq_cut_on[28:0]) ; 
	  sq_cut_flag[30]   <=    ~sq_cut_on[30] && (&sq_cut_on[29:0]) ; 
	  sq_cut_flag[31]   <=    ~sq_cut_on[31] && (&sq_cut_on[30:0]) ; 
  end
  else if (fir_r_rjudge_st &&  sq_frame_flag  &&  current_sqid_reg_flag &&  (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ) begin
      sq_cut_flag[ 0]   <=    ~sq_cut_on[ 0]                       ; 
	  sq_cut_flag[ 1]   <=    ~sq_cut_on[ 1] && ( sq_cut_on[   0]) ; 
	  sq_cut_flag[ 2]   <=    ~sq_cut_on[ 2] && (&sq_cut_on[ 1:0]) ; 
	  sq_cut_flag[ 3]   <=    ~sq_cut_on[ 3] && (&sq_cut_on[ 2:0]) ; 
	  sq_cut_flag[ 4]   <=    ~sq_cut_on[ 4] && (&sq_cut_on[ 3:0]) ; 
	  sq_cut_flag[ 5]   <=    ~sq_cut_on[ 5] && (&sq_cut_on[ 4:0]) ; 
	  sq_cut_flag[ 6]   <=    ~sq_cut_on[ 6] && (&sq_cut_on[ 5:0]) ; 
	  sq_cut_flag[ 7]   <=    ~sq_cut_on[ 7] && (&sq_cut_on[ 6:0]) ; 
	  sq_cut_flag[ 8]   <=    ~sq_cut_on[ 8] && (&sq_cut_on[ 7:0]) ; 
	  sq_cut_flag[ 9]   <=    ~sq_cut_on[ 9] && (&sq_cut_on[ 8:0]) ; 
	  sq_cut_flag[10]   <=    ~sq_cut_on[10] && (&sq_cut_on[ 9:0]) ; 
	  sq_cut_flag[11]   <=    ~sq_cut_on[11] && (&sq_cut_on[10:0]) ; 
	  sq_cut_flag[12]   <=    ~sq_cut_on[12] && (&sq_cut_on[11:0]) ; 
	  sq_cut_flag[13]   <=    ~sq_cut_on[13] && (&sq_cut_on[12:0]) ; 
	  sq_cut_flag[14]   <=    ~sq_cut_on[14] && (&sq_cut_on[13:0]) ; 
	  sq_cut_flag[15]   <=    ~sq_cut_on[15] && (&sq_cut_on[14:0]) ; 
	  sq_cut_flag[16]   <=    ~sq_cut_on[16] && (&sq_cut_on[15:0]) ; 
	  sq_cut_flag[17]   <=    ~sq_cut_on[17] && (&sq_cut_on[16:0]) ; 
	  sq_cut_flag[18]   <=    ~sq_cut_on[18] && (&sq_cut_on[17:0]) ; 
	  sq_cut_flag[19]   <=    ~sq_cut_on[19] && (&sq_cut_on[18:0]) ; 
	  sq_cut_flag[20]   <=    ~sq_cut_on[20] && (&sq_cut_on[19:0]) ; 
	  sq_cut_flag[21]   <=    ~sq_cut_on[21] && (&sq_cut_on[20:0]) ; 
	  sq_cut_flag[22]   <=    ~sq_cut_on[22] && (&sq_cut_on[21:0]) ; 
	  sq_cut_flag[23]   <=    ~sq_cut_on[23] && (&sq_cut_on[22:0]) ; 
	  sq_cut_flag[24]   <=    ~sq_cut_on[24] && (&sq_cut_on[23:0]) ; 
	  sq_cut_flag[25]   <=    ~sq_cut_on[25] && (&sq_cut_on[24:0]) ; 
	  sq_cut_flag[26]   <=    ~sq_cut_on[26] && (&sq_cut_on[25:0]) ; 
	  sq_cut_flag[27]   <=    ~sq_cut_on[27] && (&sq_cut_on[26:0]) ; 
	  sq_cut_flag[28]   <=    ~sq_cut_on[28] && (&sq_cut_on[27:0]) ; 
	  sq_cut_flag[29]   <=    ~sq_cut_on[29] && (&sq_cut_on[28:0]) ; 
	  sq_cut_flag[30]   <=    ~sq_cut_on[30] && (&sq_cut_on[29:0]) ; 
	  sq_cut_flag[31]   <=    ~sq_cut_on[31] && (&sq_cut_on[30:0]) ; 
  end 
  else begin
      sq_cut_flag   <=  32'd0    ;
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_flag_dly       <=   32'd0 ; 
  end
  else if ( fir_r_vsync_st  &&   (st_rx_cnt_reg<(sync_len_byte+16'd4))  &&  (st_shift_ccnt>=6'd8)  &&  sq_frame_flag  &&  current_sqid_reg_flag &&  (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)   ) begin 
          sq_cut_flag_dly[ 0]   <=    ~sq_cut_on_dly[ 0]                       ; 
	  sq_cut_flag_dly[ 1]   <=    ~sq_cut_on_dly[ 1] && ( sq_cut_on_dly[   0]) ; 
	  sq_cut_flag_dly[ 2]   <=    ~sq_cut_on_dly[ 2] && (&sq_cut_on_dly[ 1:0]) ; 
	  sq_cut_flag_dly[ 3]   <=    ~sq_cut_on_dly[ 3] && (&sq_cut_on_dly[ 2:0]) ; 
	  sq_cut_flag_dly[ 4]   <=    ~sq_cut_on_dly[ 4] && (&sq_cut_on_dly[ 3:0]) ; 
	  sq_cut_flag_dly[ 5]   <=    ~sq_cut_on_dly[ 5] && (&sq_cut_on_dly[ 4:0]) ; 
	  sq_cut_flag_dly[ 6]   <=    ~sq_cut_on_dly[ 6] && (&sq_cut_on_dly[ 5:0]) ; 
	  sq_cut_flag_dly[ 7]   <=    ~sq_cut_on_dly[ 7] && (&sq_cut_on_dly[ 6:0]) ; 
	  sq_cut_flag_dly[ 8]   <=    ~sq_cut_on_dly[ 8] && (&sq_cut_on_dly[ 7:0]) ; 
	  sq_cut_flag_dly[ 9]   <=    ~sq_cut_on_dly[ 9] && (&sq_cut_on_dly[ 8:0]) ; 
	  sq_cut_flag_dly[10]   <=    ~sq_cut_on_dly[10] && (&sq_cut_on_dly[ 9:0]) ; 
	  sq_cut_flag_dly[11]   <=    ~sq_cut_on_dly[11] && (&sq_cut_on_dly[10:0]) ; 
	  sq_cut_flag_dly[12]   <=    ~sq_cut_on_dly[12] && (&sq_cut_on_dly[11:0]) ; 
	  sq_cut_flag_dly[13]   <=    ~sq_cut_on_dly[13] && (&sq_cut_on_dly[12:0]) ; 
	  sq_cut_flag_dly[14]   <=    ~sq_cut_on_dly[14] && (&sq_cut_on_dly[13:0]) ; 
	  sq_cut_flag_dly[15]   <=    ~sq_cut_on_dly[15] && (&sq_cut_on_dly[14:0]) ; 
	  sq_cut_flag_dly[16]   <=    ~sq_cut_on_dly[16] && (&sq_cut_on_dly[15:0]) ; 
	  sq_cut_flag_dly[17]   <=    ~sq_cut_on_dly[17] && (&sq_cut_on_dly[16:0]) ; 
	  sq_cut_flag_dly[18]   <=    ~sq_cut_on_dly[18] && (&sq_cut_on_dly[17:0]) ; 
	  sq_cut_flag_dly[19]   <=    ~sq_cut_on_dly[19] && (&sq_cut_on_dly[18:0]) ; 
	  sq_cut_flag_dly[20]   <=    ~sq_cut_on_dly[20] && (&sq_cut_on_dly[19:0]) ; 
	  sq_cut_flag_dly[21]   <=    ~sq_cut_on_dly[21] && (&sq_cut_on_dly[20:0]) ; 
	  sq_cut_flag_dly[22]   <=    ~sq_cut_on_dly[22] && (&sq_cut_on_dly[21:0]) ; 
	  sq_cut_flag_dly[23]   <=    ~sq_cut_on_dly[23] && (&sq_cut_on_dly[22:0]) ; 
	  sq_cut_flag_dly[24]   <=    ~sq_cut_on_dly[24] && (&sq_cut_on_dly[23:0]) ; 
	  sq_cut_flag_dly[25]   <=    ~sq_cut_on_dly[25] && (&sq_cut_on_dly[24:0]) ; 
	  sq_cut_flag_dly[26]   <=    ~sq_cut_on_dly[26] && (&sq_cut_on_dly[25:0]) ; 
	  sq_cut_flag_dly[27]   <=    ~sq_cut_on_dly[27] && (&sq_cut_on_dly[26:0]) ; 
	  sq_cut_flag_dly[28]   <=    ~sq_cut_on_dly[28] && (&sq_cut_on_dly[27:0]) ; 
	  sq_cut_flag_dly[29]   <=    ~sq_cut_on_dly[29] && (&sq_cut_on_dly[28:0]) ; 
	  sq_cut_flag_dly[30]   <=    ~sq_cut_on_dly[30] && (&sq_cut_on_dly[29:0]) ; 
	  sq_cut_flag_dly[31]   <=    ~sq_cut_on_dly[31] && (&sq_cut_on_dly[30:0]) ; 
  end
  //else if (fir_r_rjudge_st &&  sq_frame_flag  &&  current_sqid_reg_flag &&  (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ) begin
  else if ( fir_r_sqcuth_st  &&  (st_shift_ccnt>=st_rx_cnt_reg )   ) begin
          sq_cut_flag_dly[ 0]   <=    ~sq_cut_on_dly[ 0]                       ; 
	  sq_cut_flag_dly[ 1]   <=    ~sq_cut_on_dly[ 1] && ( sq_cut_on_dly[   0]) ; 
	  sq_cut_flag_dly[ 2]   <=    ~sq_cut_on_dly[ 2] && (&sq_cut_on_dly[ 1:0]) ; 
	  sq_cut_flag_dly[ 3]   <=    ~sq_cut_on_dly[ 3] && (&sq_cut_on_dly[ 2:0]) ; 
	  sq_cut_flag_dly[ 4]   <=    ~sq_cut_on_dly[ 4] && (&sq_cut_on_dly[ 3:0]) ; 
	  sq_cut_flag_dly[ 5]   <=    ~sq_cut_on_dly[ 5] && (&sq_cut_on_dly[ 4:0]) ; 
	  sq_cut_flag_dly[ 6]   <=    ~sq_cut_on_dly[ 6] && (&sq_cut_on_dly[ 5:0]) ; 
	  sq_cut_flag_dly[ 7]   <=    ~sq_cut_on_dly[ 7] && (&sq_cut_on_dly[ 6:0]) ; 
	  sq_cut_flag_dly[ 8]   <=    ~sq_cut_on_dly[ 8] && (&sq_cut_on_dly[ 7:0]) ; 
	  sq_cut_flag_dly[ 9]   <=    ~sq_cut_on_dly[ 9] && (&sq_cut_on_dly[ 8:0]) ; 
	  sq_cut_flag_dly[10]   <=    ~sq_cut_on_dly[10] && (&sq_cut_on_dly[ 9:0]) ; 
	  sq_cut_flag_dly[11]   <=    ~sq_cut_on_dly[11] && (&sq_cut_on_dly[10:0]) ; 
	  sq_cut_flag_dly[12]   <=    ~sq_cut_on_dly[12] && (&sq_cut_on_dly[11:0]) ; 
	  sq_cut_flag_dly[13]   <=    ~sq_cut_on_dly[13] && (&sq_cut_on_dly[12:0]) ; 
	  sq_cut_flag_dly[14]   <=    ~sq_cut_on_dly[14] && (&sq_cut_on_dly[13:0]) ; 
	  sq_cut_flag_dly[15]   <=    ~sq_cut_on_dly[15] && (&sq_cut_on_dly[14:0]) ; 
	  sq_cut_flag_dly[16]   <=    ~sq_cut_on_dly[16] && (&sq_cut_on_dly[15:0]) ; 
	  sq_cut_flag_dly[17]   <=    ~sq_cut_on_dly[17] && (&sq_cut_on_dly[16:0]) ; 
	  sq_cut_flag_dly[18]   <=    ~sq_cut_on_dly[18] && (&sq_cut_on_dly[17:0]) ; 
	  sq_cut_flag_dly[19]   <=    ~sq_cut_on_dly[19] && (&sq_cut_on_dly[18:0]) ; 
	  sq_cut_flag_dly[20]   <=    ~sq_cut_on_dly[20] && (&sq_cut_on_dly[19:0]) ; 
	  sq_cut_flag_dly[21]   <=    ~sq_cut_on_dly[21] && (&sq_cut_on_dly[20:0]) ; 
	  sq_cut_flag_dly[22]   <=    ~sq_cut_on_dly[22] && (&sq_cut_on_dly[21:0]) ; 
	  sq_cut_flag_dly[23]   <=    ~sq_cut_on_dly[23] && (&sq_cut_on_dly[22:0]) ; 
	  sq_cut_flag_dly[24]   <=    ~sq_cut_on_dly[24] && (&sq_cut_on_dly[23:0]) ; 
	  sq_cut_flag_dly[25]   <=    ~sq_cut_on_dly[25] && (&sq_cut_on_dly[24:0]) ; 
	  sq_cut_flag_dly[26]   <=    ~sq_cut_on_dly[26] && (&sq_cut_on_dly[25:0]) ; 
	  sq_cut_flag_dly[27]   <=    ~sq_cut_on_dly[27] && (&sq_cut_on_dly[26:0]) ; 
	  sq_cut_flag_dly[28]   <=    ~sq_cut_on_dly[28] && (&sq_cut_on_dly[27:0]) ; 
	  sq_cut_flag_dly[29]   <=    ~sq_cut_on_dly[29] && (&sq_cut_on_dly[28:0]) ; 
	  sq_cut_flag_dly[30]   <=    ~sq_cut_on_dly[30] && (&sq_cut_on_dly[29:0]) ; 
	  sq_cut_flag_dly[31]   <=    ~sq_cut_on_dly[31] && (&sq_cut_on_dly[30:0]) ; 
  end 
  else begin
      sq_cut_flag_dly   <=  32'd0    ;
  end
end




always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_on    <=  32'd0    ;
  end
  else if ( |sq_cut_flag   ) begin
          sq_cut_on[ 0]   <=  sq_cut_flag[ 0]   ?   1'd1  :  sq_cut_on[ 0]  ;
	  sq_cut_on[ 1]   <=  sq_cut_flag[ 1]   ?   1'd1  :  sq_cut_on[ 1]  ;
	  sq_cut_on[ 2]   <=  sq_cut_flag[ 2]   ?   1'd1  :  sq_cut_on[ 2]  ;
	  sq_cut_on[ 3]   <=  sq_cut_flag[ 3]   ?   1'd1  :  sq_cut_on[ 3]  ;
	  sq_cut_on[ 4]   <=  sq_cut_flag[ 4]   ?   1'd1  :  sq_cut_on[ 4]  ;
	  sq_cut_on[ 5]   <=  sq_cut_flag[ 5]   ?   1'd1  :  sq_cut_on[ 5]  ;
	  sq_cut_on[ 6]   <=  sq_cut_flag[ 6]   ?   1'd1  :  sq_cut_on[ 6]  ;
	  sq_cut_on[ 7]   <=  sq_cut_flag[ 7]   ?   1'd1  :  sq_cut_on[ 7]  ;
	  sq_cut_on[ 8]   <=  sq_cut_flag[ 8]   ?   1'd1  :  sq_cut_on[ 8]  ;
	  sq_cut_on[ 9]   <=  sq_cut_flag[ 9]   ?   1'd1  :  sq_cut_on[ 9]  ;
	  sq_cut_on[10]   <=  sq_cut_flag[10]   ?   1'd1  :  sq_cut_on[10]  ;
	  sq_cut_on[11]   <=  sq_cut_flag[11]   ?   1'd1  :  sq_cut_on[11]  ;
	  sq_cut_on[12]   <=  sq_cut_flag[12]   ?   1'd1  :  sq_cut_on[12]  ;
	  sq_cut_on[13]   <=  sq_cut_flag[13]   ?   1'd1  :  sq_cut_on[13]  ;
	  sq_cut_on[14]   <=  sq_cut_flag[14]   ?   1'd1  :  sq_cut_on[14]  ;
	  sq_cut_on[15]   <=  sq_cut_flag[15]   ?   1'd1  :  sq_cut_on[15]  ;
	  sq_cut_on[16]   <=  sq_cut_flag[16]   ?   1'd1  :  sq_cut_on[16]  ;
	  sq_cut_on[17]   <=  sq_cut_flag[17]   ?   1'd1  :  sq_cut_on[17]  ;
	  sq_cut_on[18]   <=  sq_cut_flag[18]   ?   1'd1  :  sq_cut_on[18]  ;
	  sq_cut_on[19]   <=  sq_cut_flag[19]   ?   1'd1  :  sq_cut_on[19]  ;
	  sq_cut_on[20]   <=  sq_cut_flag[20]   ?   1'd1  :  sq_cut_on[20]  ;
	  sq_cut_on[21]   <=  sq_cut_flag[21]   ?   1'd1  :  sq_cut_on[21]  ;
	  sq_cut_on[22]   <=  sq_cut_flag[22]   ?   1'd1  :  sq_cut_on[22]  ;
	  sq_cut_on[23]   <=  sq_cut_flag[23]   ?   1'd1  :  sq_cut_on[23]  ;
	  sq_cut_on[24]   <=  sq_cut_flag[24]   ?   1'd1  :  sq_cut_on[24]  ;
	  sq_cut_on[25]   <=  sq_cut_flag[25]   ?   1'd1  :  sq_cut_on[25]  ;
	  sq_cut_on[26]   <=  sq_cut_flag[26]   ?   1'd1  :  sq_cut_on[26]  ;
	  sq_cut_on[27]   <=  sq_cut_flag[27]   ?   1'd1  :  sq_cut_on[27]  ;
	  sq_cut_on[28]   <=  sq_cut_flag[28]   ?   1'd1  :  sq_cut_on[28]  ;
	  sq_cut_on[29]   <=  sq_cut_flag[29]   ?   1'd1  :  sq_cut_on[29]  ;
	  sq_cut_on[30]   <=  sq_cut_flag[30]   ?   1'd1  :  sq_cut_on[30]  ;
	  sq_cut_on[31]   <=  sq_cut_flag[31]   ?   1'd1  :  sq_cut_on[31]  ;
  end 
  else if ( |sq_cut_reset  ) begin
          sq_cut_on[ 0]   <=  sq_cut_reset[ 0] ?   1'd0  :  sq_cut_on[ 0]   ;
	  sq_cut_on[ 1]   <=  sq_cut_reset[ 1] ?   1'd0  :  sq_cut_on[ 1]   ;
	  sq_cut_on[ 2]   <=  sq_cut_reset[ 2] ?   1'd0  :  sq_cut_on[ 2]   ;
	  sq_cut_on[ 3]   <=  sq_cut_reset[ 3] ?   1'd0  :  sq_cut_on[ 3]   ;
	  sq_cut_on[ 4]   <=  sq_cut_reset[ 4] ?   1'd0  :  sq_cut_on[ 4]   ;
	  sq_cut_on[ 5]   <=  sq_cut_reset[ 5] ?   1'd0  :  sq_cut_on[ 5]   ;
	  sq_cut_on[ 6]   <=  sq_cut_reset[ 6] ?   1'd0  :  sq_cut_on[ 6]   ;
	  sq_cut_on[ 7]   <=  sq_cut_reset[ 7] ?   1'd0  :  sq_cut_on[ 7]   ;
	  sq_cut_on[ 8]   <=  sq_cut_reset[ 8] ?   1'd0  :  sq_cut_on[ 8]   ;
	  sq_cut_on[ 9]   <=  sq_cut_reset[ 9] ?   1'd0  :  sq_cut_on[ 9]   ;
	  sq_cut_on[10]   <=  sq_cut_reset[10] ?   1'd0  :  sq_cut_on[10]   ;
	  sq_cut_on[11]   <=  sq_cut_reset[11] ?   1'd0  :  sq_cut_on[11]   ;
	  sq_cut_on[12]   <=  sq_cut_reset[12] ?   1'd0  :  sq_cut_on[12]   ;
	  sq_cut_on[13]   <=  sq_cut_reset[13] ?   1'd0  :  sq_cut_on[13]   ;
	  sq_cut_on[14]   <=  sq_cut_reset[14] ?   1'd0  :  sq_cut_on[14]   ;
	  sq_cut_on[15]   <=  sq_cut_reset[15] ?   1'd0  :  sq_cut_on[15]   ;
	  sq_cut_on[16]   <=  sq_cut_reset[16] ?   1'd0  :  sq_cut_on[16]   ;
	  sq_cut_on[17]   <=  sq_cut_reset[17] ?   1'd0  :  sq_cut_on[17]   ;
	  sq_cut_on[18]   <=  sq_cut_reset[18] ?   1'd0  :  sq_cut_on[18]   ;
	  sq_cut_on[19]   <=  sq_cut_reset[19] ?   1'd0  :  sq_cut_on[19]   ;
	  sq_cut_on[20]   <=  sq_cut_reset[20] ?   1'd0  :  sq_cut_on[20]   ;
	  sq_cut_on[21]   <=  sq_cut_reset[21] ?   1'd0  :  sq_cut_on[21]   ;
	  sq_cut_on[22]   <=  sq_cut_reset[22] ?   1'd0  :  sq_cut_on[22]   ;
	  sq_cut_on[23]   <=  sq_cut_reset[23] ?   1'd0  :  sq_cut_on[23]   ;
	  sq_cut_on[24]   <=  sq_cut_reset[24] ?   1'd0  :  sq_cut_on[24]   ;
	  sq_cut_on[25]   <=  sq_cut_reset[25] ?   1'd0  :  sq_cut_on[25]   ;
	  sq_cut_on[26]   <=  sq_cut_reset[26] ?   1'd0  :  sq_cut_on[26]   ;
	  sq_cut_on[27]   <=  sq_cut_reset[27] ?   1'd0  :  sq_cut_on[27]   ;
	  sq_cut_on[28]   <=  sq_cut_reset[28] ?   1'd0  :  sq_cut_on[28]   ;
	  sq_cut_on[29]   <=  sq_cut_reset[29] ?   1'd0  :  sq_cut_on[29]   ;
	  sq_cut_on[30]   <=  sq_cut_reset[30] ?   1'd0  :  sq_cut_on[30]   ;
	  sq_cut_on[31]   <=  sq_cut_reset[31] ?   1'd0  :  sq_cut_on[31]   ;
  end 
  else if ( st_rx_start && (|tcp_sqmatch_flag) ) begin
          sq_cut_on[ 0]   <=  tcp_sqmatch_flag[ 0]  ?    1'd0  : sq_cut_on[ 0]   ;
	  sq_cut_on[ 1]   <=  tcp_sqmatch_flag[ 1]  ?    1'd0  : sq_cut_on[ 1]   ;
	  sq_cut_on[ 2]   <=  tcp_sqmatch_flag[ 2]  ?    1'd0  : sq_cut_on[ 2]   ;
	  sq_cut_on[ 3]   <=  tcp_sqmatch_flag[ 3]  ?    1'd0  : sq_cut_on[ 3]   ;
	  sq_cut_on[ 4]   <=  tcp_sqmatch_flag[ 4]  ?    1'd0  : sq_cut_on[ 4]   ;
	  sq_cut_on[ 5]   <=  tcp_sqmatch_flag[ 5]  ?    1'd0  : sq_cut_on[ 5]   ;
	  sq_cut_on[ 6]   <=  tcp_sqmatch_flag[ 6]  ?    1'd0  : sq_cut_on[ 6]   ;
	  sq_cut_on[ 7]   <=  tcp_sqmatch_flag[ 7]  ?    1'd0  : sq_cut_on[ 7]   ;
	  sq_cut_on[ 8]   <=  tcp_sqmatch_flag[ 8]  ?    1'd0  : sq_cut_on[ 8]   ;
	  sq_cut_on[ 9]   <=  tcp_sqmatch_flag[ 9]  ?    1'd0  : sq_cut_on[ 9]   ;
	  sq_cut_on[10]   <=  tcp_sqmatch_flag[10]  ?    1'd0  : sq_cut_on[10]   ;
	  sq_cut_on[11]   <=  tcp_sqmatch_flag[11]  ?    1'd0  : sq_cut_on[11]   ;
	  sq_cut_on[12]   <=  tcp_sqmatch_flag[12]  ?    1'd0  : sq_cut_on[12]   ;
	  sq_cut_on[13]   <=  tcp_sqmatch_flag[13]  ?    1'd0  : sq_cut_on[13]   ;
	  sq_cut_on[14]   <=  tcp_sqmatch_flag[14]  ?    1'd0  : sq_cut_on[14]   ;
	  sq_cut_on[15]   <=  tcp_sqmatch_flag[15]  ?    1'd0  : sq_cut_on[15]   ;
	  sq_cut_on[16]   <=  tcp_sqmatch_flag[16]  ?    1'd0  : sq_cut_on[16]   ;
	  sq_cut_on[17]   <=  tcp_sqmatch_flag[17]  ?    1'd0  : sq_cut_on[17]   ;
	  sq_cut_on[18]   <=  tcp_sqmatch_flag[18]  ?    1'd0  : sq_cut_on[18]   ;
	  sq_cut_on[19]   <=  tcp_sqmatch_flag[19]  ?    1'd0  : sq_cut_on[19]   ;
	  sq_cut_on[20]   <=  tcp_sqmatch_flag[20]  ?    1'd0  : sq_cut_on[20]   ;
	  sq_cut_on[21]   <=  tcp_sqmatch_flag[21]  ?    1'd0  : sq_cut_on[21]   ;
	  sq_cut_on[22]   <=  tcp_sqmatch_flag[22]  ?    1'd0  : sq_cut_on[22]   ;
	  sq_cut_on[23]   <=  tcp_sqmatch_flag[23]  ?    1'd0  : sq_cut_on[23]   ;
	  sq_cut_on[24]   <=  tcp_sqmatch_flag[24]  ?    1'd0  : sq_cut_on[24]   ;
	  sq_cut_on[25]   <=  tcp_sqmatch_flag[25]  ?    1'd0  : sq_cut_on[25]   ;
	  sq_cut_on[26]   <=  tcp_sqmatch_flag[26]  ?    1'd0  : sq_cut_on[26]   ;
	  sq_cut_on[27]   <=  tcp_sqmatch_flag[27]  ?    1'd0  : sq_cut_on[27]   ;
	  sq_cut_on[28]   <=  tcp_sqmatch_flag[28]  ?    1'd0  : sq_cut_on[28]   ;
	  sq_cut_on[29]   <=  tcp_sqmatch_flag[29]  ?    1'd0  : sq_cut_on[29]   ;
	  sq_cut_on[30]   <=  tcp_sqmatch_flag[30]  ?    1'd0  : sq_cut_on[30]   ;
	  sq_cut_on[31]   <=  tcp_sqmatch_flag[31]  ?    1'd0  : sq_cut_on[31]   ;
  end 
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_on_dly    <=  32'd0    ;
  end
  else if ( |sq_cut_flag_dly   ) begin
          sq_cut_on_dly[ 0]   <=  sq_cut_flag_dly[ 0]   ?   1'd1  :  sq_cut_on_dly[ 0]  ;
	  sq_cut_on_dly[ 1]   <=  sq_cut_flag_dly[ 1]   ?   1'd1  :  sq_cut_on_dly[ 1]  ;
	  sq_cut_on_dly[ 2]   <=  sq_cut_flag_dly[ 2]   ?   1'd1  :  sq_cut_on_dly[ 2]  ;
	  sq_cut_on_dly[ 3]   <=  sq_cut_flag_dly[ 3]   ?   1'd1  :  sq_cut_on_dly[ 3]  ;
	  sq_cut_on_dly[ 4]   <=  sq_cut_flag_dly[ 4]   ?   1'd1  :  sq_cut_on_dly[ 4]  ;
	  sq_cut_on_dly[ 5]   <=  sq_cut_flag_dly[ 5]   ?   1'd1  :  sq_cut_on_dly[ 5]  ;
	  sq_cut_on_dly[ 6]   <=  sq_cut_flag_dly[ 6]   ?   1'd1  :  sq_cut_on_dly[ 6]  ;
	  sq_cut_on_dly[ 7]   <=  sq_cut_flag_dly[ 7]   ?   1'd1  :  sq_cut_on_dly[ 7]  ;
	  sq_cut_on_dly[ 8]   <=  sq_cut_flag_dly[ 8]   ?   1'd1  :  sq_cut_on_dly[ 8]  ;
	  sq_cut_on_dly[ 9]   <=  sq_cut_flag_dly[ 9]   ?   1'd1  :  sq_cut_on_dly[ 9]  ;
	  sq_cut_on_dly[10]   <=  sq_cut_flag_dly[10]   ?   1'd1  :  sq_cut_on_dly[10]  ;
	  sq_cut_on_dly[11]   <=  sq_cut_flag_dly[11]   ?   1'd1  :  sq_cut_on_dly[11]  ;
	  sq_cut_on_dly[12]   <=  sq_cut_flag_dly[12]   ?   1'd1  :  sq_cut_on_dly[12]  ;
	  sq_cut_on_dly[13]   <=  sq_cut_flag_dly[13]   ?   1'd1  :  sq_cut_on_dly[13]  ;
	  sq_cut_on_dly[14]   <=  sq_cut_flag_dly[14]   ?   1'd1  :  sq_cut_on_dly[14]  ;
	  sq_cut_on_dly[15]   <=  sq_cut_flag_dly[15]   ?   1'd1  :  sq_cut_on_dly[15]  ;
	  sq_cut_on_dly[16]   <=  sq_cut_flag_dly[16]   ?   1'd1  :  sq_cut_on_dly[16]  ;
	  sq_cut_on_dly[17]   <=  sq_cut_flag_dly[17]   ?   1'd1  :  sq_cut_on_dly[17]  ;
	  sq_cut_on_dly[18]   <=  sq_cut_flag_dly[18]   ?   1'd1  :  sq_cut_on_dly[18]  ;
	  sq_cut_on_dly[19]   <=  sq_cut_flag_dly[19]   ?   1'd1  :  sq_cut_on_dly[19]  ;
	  sq_cut_on_dly[20]   <=  sq_cut_flag_dly[20]   ?   1'd1  :  sq_cut_on_dly[20]  ;
	  sq_cut_on_dly[21]   <=  sq_cut_flag_dly[21]   ?   1'd1  :  sq_cut_on_dly[21]  ;
	  sq_cut_on_dly[22]   <=  sq_cut_flag_dly[22]   ?   1'd1  :  sq_cut_on_dly[22]  ;
	  sq_cut_on_dly[23]   <=  sq_cut_flag_dly[23]   ?   1'd1  :  sq_cut_on_dly[23]  ;
	  sq_cut_on_dly[24]   <=  sq_cut_flag_dly[24]   ?   1'd1  :  sq_cut_on_dly[24]  ;
	  sq_cut_on_dly[25]   <=  sq_cut_flag_dly[25]   ?   1'd1  :  sq_cut_on_dly[25]  ;
	  sq_cut_on_dly[26]   <=  sq_cut_flag_dly[26]   ?   1'd1  :  sq_cut_on_dly[26]  ;
	  sq_cut_on_dly[27]   <=  sq_cut_flag_dly[27]   ?   1'd1  :  sq_cut_on_dly[27]  ;
	  sq_cut_on_dly[28]   <=  sq_cut_flag_dly[28]   ?   1'd1  :  sq_cut_on_dly[28]  ;
	  sq_cut_on_dly[29]   <=  sq_cut_flag_dly[29]   ?   1'd1  :  sq_cut_on_dly[29]  ;
	  sq_cut_on_dly[30]   <=  sq_cut_flag_dly[30]   ?   1'd1  :  sq_cut_on_dly[30]  ;
	  sq_cut_on_dly[31]   <=  sq_cut_flag_dly[31]   ?   1'd1  :  sq_cut_on_dly[31]  ;
  end 
  else if ( |sq_cut_reset  ) begin
          sq_cut_on_dly[ 0]   <=  sq_cut_reset[ 0] ?   1'd0  :  sq_cut_on_dly[ 0]   ;
	  sq_cut_on_dly[ 1]   <=  sq_cut_reset[ 1] ?   1'd0  :  sq_cut_on_dly[ 1]   ;
	  sq_cut_on_dly[ 2]   <=  sq_cut_reset[ 2] ?   1'd0  :  sq_cut_on_dly[ 2]   ;
	  sq_cut_on_dly[ 3]   <=  sq_cut_reset[ 3] ?   1'd0  :  sq_cut_on_dly[ 3]   ;
	  sq_cut_on_dly[ 4]   <=  sq_cut_reset[ 4] ?   1'd0  :  sq_cut_on_dly[ 4]   ;
	  sq_cut_on_dly[ 5]   <=  sq_cut_reset[ 5] ?   1'd0  :  sq_cut_on_dly[ 5]   ;
	  sq_cut_on_dly[ 6]   <=  sq_cut_reset[ 6] ?   1'd0  :  sq_cut_on_dly[ 6]   ;
	  sq_cut_on_dly[ 7]   <=  sq_cut_reset[ 7] ?   1'd0  :  sq_cut_on_dly[ 7]   ;
	  sq_cut_on_dly[ 8]   <=  sq_cut_reset[ 8] ?   1'd0  :  sq_cut_on_dly[ 8]   ;
	  sq_cut_on_dly[ 9]   <=  sq_cut_reset[ 9] ?   1'd0  :  sq_cut_on_dly[ 9]   ;
	  sq_cut_on_dly[10]   <=  sq_cut_reset[10] ?   1'd0  :  sq_cut_on_dly[10]   ;
	  sq_cut_on_dly[11]   <=  sq_cut_reset[11] ?   1'd0  :  sq_cut_on_dly[11]   ;
	  sq_cut_on_dly[12]   <=  sq_cut_reset[12] ?   1'd0  :  sq_cut_on_dly[12]   ;
	  sq_cut_on_dly[13]   <=  sq_cut_reset[13] ?   1'd0  :  sq_cut_on_dly[13]   ;
	  sq_cut_on_dly[14]   <=  sq_cut_reset[14] ?   1'd0  :  sq_cut_on_dly[14]   ;
	  sq_cut_on_dly[15]   <=  sq_cut_reset[15] ?   1'd0  :  sq_cut_on_dly[15]   ;
	  sq_cut_on_dly[16]   <=  sq_cut_reset[16] ?   1'd0  :  sq_cut_on_dly[16]   ;
	  sq_cut_on_dly[17]   <=  sq_cut_reset[17] ?   1'd0  :  sq_cut_on_dly[17]   ;
	  sq_cut_on_dly[18]   <=  sq_cut_reset[18] ?   1'd0  :  sq_cut_on_dly[18]   ;
	  sq_cut_on_dly[19]   <=  sq_cut_reset[19] ?   1'd0  :  sq_cut_on_dly[19]   ;
	  sq_cut_on_dly[20]   <=  sq_cut_reset[20] ?   1'd0  :  sq_cut_on_dly[20]   ;
	  sq_cut_on_dly[21]   <=  sq_cut_reset[21] ?   1'd0  :  sq_cut_on_dly[21]   ;
	  sq_cut_on_dly[22]   <=  sq_cut_reset[22] ?   1'd0  :  sq_cut_on_dly[22]   ;
	  sq_cut_on_dly[23]   <=  sq_cut_reset[23] ?   1'd0  :  sq_cut_on_dly[23]   ;
	  sq_cut_on_dly[24]   <=  sq_cut_reset[24] ?   1'd0  :  sq_cut_on_dly[24]   ;
	  sq_cut_on_dly[25]   <=  sq_cut_reset[25] ?   1'd0  :  sq_cut_on_dly[25]   ;
	  sq_cut_on_dly[26]   <=  sq_cut_reset[26] ?   1'd0  :  sq_cut_on_dly[26]   ;
	  sq_cut_on_dly[27]   <=  sq_cut_reset[27] ?   1'd0  :  sq_cut_on_dly[27]   ;
	  sq_cut_on_dly[28]   <=  sq_cut_reset[28] ?   1'd0  :  sq_cut_on_dly[28]   ;
	  sq_cut_on_dly[29]   <=  sq_cut_reset[29] ?   1'd0  :  sq_cut_on_dly[29]   ;
	  sq_cut_on_dly[30]   <=  sq_cut_reset[30] ?   1'd0  :  sq_cut_on_dly[30]   ;
	  sq_cut_on_dly[31]   <=  sq_cut_reset[31] ?   1'd0  :  sq_cut_on_dly[31]   ;
  end 
  else if ( st_rx_start && (|tcp_sqmatch_flag) ) begin
          sq_cut_on_dly[ 0]   <=  tcp_sqmatch_flag[ 0]  ?    1'd0  : sq_cut_on_dly[ 0]   ;
	  sq_cut_on_dly[ 1]   <=  tcp_sqmatch_flag[ 1]  ?    1'd0  : sq_cut_on_dly[ 1]   ;
	  sq_cut_on_dly[ 2]   <=  tcp_sqmatch_flag[ 2]  ?    1'd0  : sq_cut_on_dly[ 2]   ;
	  sq_cut_on_dly[ 3]   <=  tcp_sqmatch_flag[ 3]  ?    1'd0  : sq_cut_on_dly[ 3]   ;
	  sq_cut_on_dly[ 4]   <=  tcp_sqmatch_flag[ 4]  ?    1'd0  : sq_cut_on_dly[ 4]   ;
	  sq_cut_on_dly[ 5]   <=  tcp_sqmatch_flag[ 5]  ?    1'd0  : sq_cut_on_dly[ 5]   ;
	  sq_cut_on_dly[ 6]   <=  tcp_sqmatch_flag[ 6]  ?    1'd0  : sq_cut_on_dly[ 6]   ;
	  sq_cut_on_dly[ 7]   <=  tcp_sqmatch_flag[ 7]  ?    1'd0  : sq_cut_on_dly[ 7]   ;
	  sq_cut_on_dly[ 8]   <=  tcp_sqmatch_flag[ 8]  ?    1'd0  : sq_cut_on_dly[ 8]   ;
	  sq_cut_on_dly[ 9]   <=  tcp_sqmatch_flag[ 9]  ?    1'd0  : sq_cut_on_dly[ 9]   ;
	  sq_cut_on_dly[10]   <=  tcp_sqmatch_flag[10]  ?    1'd0  : sq_cut_on_dly[10]   ;
	  sq_cut_on_dly[11]   <=  tcp_sqmatch_flag[11]  ?    1'd0  : sq_cut_on_dly[11]   ;
	  sq_cut_on_dly[12]   <=  tcp_sqmatch_flag[12]  ?    1'd0  : sq_cut_on_dly[12]   ;
	  sq_cut_on_dly[13]   <=  tcp_sqmatch_flag[13]  ?    1'd0  : sq_cut_on_dly[13]   ;
	  sq_cut_on_dly[14]   <=  tcp_sqmatch_flag[14]  ?    1'd0  : sq_cut_on_dly[14]   ;
	  sq_cut_on_dly[15]   <=  tcp_sqmatch_flag[15]  ?    1'd0  : sq_cut_on_dly[15]   ;
	  sq_cut_on_dly[16]   <=  tcp_sqmatch_flag[16]  ?    1'd0  : sq_cut_on_dly[16]   ;
	  sq_cut_on_dly[17]   <=  tcp_sqmatch_flag[17]  ?    1'd0  : sq_cut_on_dly[17]   ;
	  sq_cut_on_dly[18]   <=  tcp_sqmatch_flag[18]  ?    1'd0  : sq_cut_on_dly[18]   ;
	  sq_cut_on_dly[19]   <=  tcp_sqmatch_flag[19]  ?    1'd0  : sq_cut_on_dly[19]   ;
	  sq_cut_on_dly[20]   <=  tcp_sqmatch_flag[20]  ?    1'd0  : sq_cut_on_dly[20]   ;
	  sq_cut_on_dly[21]   <=  tcp_sqmatch_flag[21]  ?    1'd0  : sq_cut_on_dly[21]   ;
	  sq_cut_on_dly[22]   <=  tcp_sqmatch_flag[22]  ?    1'd0  : sq_cut_on_dly[22]   ;
	  sq_cut_on_dly[23]   <=  tcp_sqmatch_flag[23]  ?    1'd0  : sq_cut_on_dly[23]   ;
	  sq_cut_on_dly[24]   <=  tcp_sqmatch_flag[24]  ?    1'd0  : sq_cut_on_dly[24]   ;
	  sq_cut_on_dly[25]   <=  tcp_sqmatch_flag[25]  ?    1'd0  : sq_cut_on_dly[25]   ;
	  sq_cut_on_dly[26]   <=  tcp_sqmatch_flag[26]  ?    1'd0  : sq_cut_on_dly[26]   ;
	  sq_cut_on_dly[27]   <=  tcp_sqmatch_flag[27]  ?    1'd0  : sq_cut_on_dly[27]   ;
	  sq_cut_on_dly[28]   <=  tcp_sqmatch_flag[28]  ?    1'd0  : sq_cut_on_dly[28]   ;
	  sq_cut_on_dly[29]   <=  tcp_sqmatch_flag[29]  ?    1'd0  : sq_cut_on_dly[29]   ;
	  sq_cut_on_dly[30]   <=  tcp_sqmatch_flag[30]  ?    1'd0  : sq_cut_on_dly[30]   ;
	  sq_cut_on_dly[31]   <=  tcp_sqmatch_flag[31]  ?    1'd0  : sq_cut_on_dly[31]   ;
  end 
end




//
//always@ ( negedge rst_n  or posedge clk)
//begin
//  if (~rst_n) begin
//     current_cut_sq00id_reg   <=  32'd0    ;
//	  current_cut_sq01id_reg   <=  32'd0    ;
//	  current_cut_sq02id_reg   <=  32'd0    ;
//	  current_cut_sq03id_reg   <=  32'd0    ;
//	  current_cut_sq04id_reg   <=  32'd0    ;
//	  current_cut_sq05id_reg   <=  32'd0    ;
//	  current_cut_sq06id_reg   <=  32'd0    ;
//	  current_cut_sq07id_reg   <=  32'd0    ;
//	  current_cut_sq08id_reg   <=  32'd0    ;
//	  current_cut_sq09id_reg   <=  32'd0    ;
//	  current_cut_sq10id_reg   <=  32'd0    ;
//	  current_cut_sq11id_reg   <=  32'd0    ;
//	  current_cut_sq12id_reg   <=  32'd0    ;
//	  current_cut_sq13id_reg   <=  32'd0    ;
//	  current_cut_sq14id_reg   <=  32'd0    ;
//	  current_cut_sq15id_reg   <=  32'd0    ;
//	  current_cut_sq16id_reg   <=  32'd0    ;
//	  current_cut_sq17id_reg   <=  32'd0    ;
//	  current_cut_sq18id_reg   <=  32'd0    ;
//	  current_cut_sq19id_reg   <=  32'd0    ;
//	  current_cut_sq20id_reg   <=  32'd0    ;
//	  current_cut_sq21id_reg   <=  32'd0    ;
//	  current_cut_sq22id_reg   <=  32'd0    ;
//	  current_cut_sq23id_reg   <=  32'd0    ;
//	  current_cut_sq24id_reg   <=  32'd0    ;
//	  current_cut_sq25id_reg   <=  32'd0    ;
//	  current_cut_sq26id_reg   <=  32'd0    ;
//	  current_cut_sq27id_reg   <=  32'd0    ;
//	  current_cut_sq28id_reg   <=  32'd0    ;
//	  current_cut_sq29id_reg   <=  32'd0    ;
//	  current_cut_sq30id_reg   <=  32'd0    ;
//	  current_cut_sq31id_reg   <=  32'd0    ;
//  end
//  else if ( fir_r_sqcut_end_st  &&   (st_shift_ccnt>=st_rx_cnt_reg)   ) begin 
//      current_cut_sq00id_reg   <=  (sq_cut_on[ 0]||sq_cut_flag[ 0])  ?      current_sqid_reg + 1'd1  :    current_cut_sq00id_reg ;
//	  current_cut_sq01id_reg   <=  (sq_cut_on[ 1]||sq_cut_flag[ 1])  ?      current_sqid_reg + 1'd1  :    current_cut_sq01id_reg ;
//	  current_cut_sq02id_reg   <=  (sq_cut_on[ 2]||sq_cut_flag[ 2])  ?      current_sqid_reg + 1'd1  :    current_cut_sq02id_reg ;
//	  current_cut_sq03id_reg   <=  (sq_cut_on[ 3]||sq_cut_flag[ 3])  ?      current_sqid_reg + 1'd1  :    current_cut_sq03id_reg ;
//	  current_cut_sq04id_reg   <=  (sq_cut_on[ 4]||sq_cut_flag[ 4])  ?      current_sqid_reg + 1'd1  :    current_cut_sq04id_reg ;
//	  current_cut_sq05id_reg   <=  (sq_cut_on[ 5]||sq_cut_flag[ 5])  ?      current_sqid_reg + 1'd1  :    current_cut_sq05id_reg ;
//	  current_cut_sq06id_reg   <=  (sq_cut_on[ 6]||sq_cut_flag[ 6])  ?      current_sqid_reg + 1'd1  :    current_cut_sq06id_reg ;
//	  current_cut_sq07id_reg   <=  (sq_cut_on[ 7]||sq_cut_flag[ 7])  ?      current_sqid_reg + 1'd1  :    current_cut_sq07id_reg ;
//	  current_cut_sq08id_reg   <=  (sq_cut_on[ 8]||sq_cut_flag[ 8])  ?      current_sqid_reg + 1'd1  :    current_cut_sq08id_reg ;
//	  current_cut_sq09id_reg   <=  (sq_cut_on[ 9]||sq_cut_flag[ 9])  ?      current_sqid_reg + 1'd1  :    current_cut_sq09id_reg ;
//	  current_cut_sq10id_reg   <=  (sq_cut_on[10]||sq_cut_flag[10])  ?      current_sqid_reg + 1'd1  :    current_cut_sq10id_reg ;
//	  current_cut_sq11id_reg   <=  (sq_cut_on[11]||sq_cut_flag[11])  ?      current_sqid_reg + 1'd1  :    current_cut_sq11id_reg ;
//	  current_cut_sq12id_reg   <=  (sq_cut_on[12]||sq_cut_flag[12])  ?      current_sqid_reg + 1'd1  :    current_cut_sq12id_reg ;
//	  current_cut_sq13id_reg   <=  (sq_cut_on[13]||sq_cut_flag[13])  ?      current_sqid_reg + 1'd1  :    current_cut_sq13id_reg ;
//	  current_cut_sq14id_reg   <=  (sq_cut_on[14]||sq_cut_flag[14])  ?      current_sqid_reg + 1'd1  :    current_cut_sq14id_reg ;
//	  current_cut_sq15id_reg   <=  (sq_cut_on[15]||sq_cut_flag[15])  ?      current_sqid_reg + 1'd1  :    current_cut_sq15id_reg ;
//	  current_cut_sq16id_reg   <=  (sq_cut_on[16]||sq_cut_flag[16])  ?      current_sqid_reg + 1'd1  :    current_cut_sq16id_reg ;
//	  current_cut_sq17id_reg   <=  (sq_cut_on[17]||sq_cut_flag[17])  ?      current_sqid_reg + 1'd1  :    current_cut_sq17id_reg ;
//	  current_cut_sq18id_reg   <=  (sq_cut_on[18]||sq_cut_flag[18])  ?      current_sqid_reg + 1'd1  :    current_cut_sq18id_reg ;
//	  current_cut_sq19id_reg   <=  (sq_cut_on[19]||sq_cut_flag[19])  ?      current_sqid_reg + 1'd1  :    current_cut_sq19id_reg ;
//	  current_cut_sq20id_reg   <=  (sq_cut_on[20]||sq_cut_flag[20])  ?      current_sqid_reg + 1'd1  :    current_cut_sq20id_reg ;
//	  current_cut_sq21id_reg   <=  (sq_cut_on[21]||sq_cut_flag[21])  ?      current_sqid_reg + 1'd1  :    current_cut_sq21id_reg ;
//	  current_cut_sq22id_reg   <=  (sq_cut_on[22]||sq_cut_flag[22])  ?      current_sqid_reg + 1'd1  :    current_cut_sq22id_reg ;
//	  current_cut_sq23id_reg   <=  (sq_cut_on[23]||sq_cut_flag[23])  ?      current_sqid_reg + 1'd1  :    current_cut_sq23id_reg ;
//	  current_cut_sq24id_reg   <=  (sq_cut_on[24]||sq_cut_flag[24])  ?      current_sqid_reg + 1'd1  :    current_cut_sq24id_reg ;
//	  current_cut_sq25id_reg   <=  (sq_cut_on[25]||sq_cut_flag[25])  ?      current_sqid_reg + 1'd1  :    current_cut_sq25id_reg ;
//	  current_cut_sq26id_reg   <=  (sq_cut_on[26]||sq_cut_flag[26])  ?      current_sqid_reg + 1'd1  :    current_cut_sq26id_reg ;
//	  current_cut_sq27id_reg   <=  (sq_cut_on[27]||sq_cut_flag[27])  ?      current_sqid_reg + 1'd1  :    current_cut_sq27id_reg ;
//	  current_cut_sq28id_reg   <=  (sq_cut_on[28]||sq_cut_flag[28])  ?      current_sqid_reg + 1'd1  :    current_cut_sq28id_reg ;
//	  current_cut_sq29id_reg   <=  (sq_cut_on[29]||sq_cut_flag[29])  ?      current_sqid_reg + 1'd1  :    current_cut_sq29id_reg ;
//	  current_cut_sq30id_reg   <=  (sq_cut_on[30]||sq_cut_flag[30])  ?      current_sqid_reg + 1'd1  :    current_cut_sq30id_reg ;
//	  current_cut_sq31id_reg   <=  (sq_cut_on[31]||sq_cut_flag[31])  ?      current_sqid_reg + 1'd1  :    current_cut_sq31id_reg ;
//  end
//  else if ( fir_r_sqcuth_st  &&  (st_shift_ccnt>=st_rx_cnt_reg)   ) begin 
//      current_cut_sq00id_reg   <=  (sq_cut_on[ 0]||sq_cut_flag[ 0])  ?      current_sqid_reg + 1'd1  :    current_cut_sq00id_reg ;
//	  current_cut_sq01id_reg   <=  (sq_cut_on[ 1]||sq_cut_flag[ 1])  ?      current_sqid_reg + 1'd1  :    current_cut_sq01id_reg ;
//	  current_cut_sq02id_reg   <=  (sq_cut_on[ 2]||sq_cut_flag[ 2])  ?      current_sqid_reg + 1'd1  :    current_cut_sq02id_reg ;
//	  current_cut_sq03id_reg   <=  (sq_cut_on[ 3]||sq_cut_flag[ 3])  ?      current_sqid_reg + 1'd1  :    current_cut_sq03id_reg ;
//	  current_cut_sq04id_reg   <=  (sq_cut_on[ 4]||sq_cut_flag[ 4])  ?      current_sqid_reg + 1'd1  :    current_cut_sq04id_reg ;
//	  current_cut_sq05id_reg   <=  (sq_cut_on[ 5]||sq_cut_flag[ 5])  ?      current_sqid_reg + 1'd1  :    current_cut_sq05id_reg ;
//	  current_cut_sq06id_reg   <=  (sq_cut_on[ 6]||sq_cut_flag[ 6])  ?      current_sqid_reg + 1'd1  :    current_cut_sq06id_reg ;
//	  current_cut_sq07id_reg   <=  (sq_cut_on[ 7]||sq_cut_flag[ 7])  ?      current_sqid_reg + 1'd1  :    current_cut_sq07id_reg ;
//	  current_cut_sq08id_reg   <=  (sq_cut_on[ 8]||sq_cut_flag[ 8])  ?      current_sqid_reg + 1'd1  :    current_cut_sq08id_reg ;
//	  current_cut_sq09id_reg   <=  (sq_cut_on[ 9]||sq_cut_flag[ 9])  ?      current_sqid_reg + 1'd1  :    current_cut_sq09id_reg ;
//	  current_cut_sq10id_reg   <=  (sq_cut_on[10]||sq_cut_flag[10])  ?      current_sqid_reg + 1'd1  :    current_cut_sq10id_reg ;
//	  current_cut_sq11id_reg   <=  (sq_cut_on[11]||sq_cut_flag[11])  ?      current_sqid_reg + 1'd1  :    current_cut_sq11id_reg ;
//	  current_cut_sq12id_reg   <=  (sq_cut_on[12]||sq_cut_flag[12])  ?      current_sqid_reg + 1'd1  :    current_cut_sq12id_reg ;
//	  current_cut_sq13id_reg   <=  (sq_cut_on[13]||sq_cut_flag[13])  ?      current_sqid_reg + 1'd1  :    current_cut_sq13id_reg ;
//	  current_cut_sq14id_reg   <=  (sq_cut_on[14]||sq_cut_flag[14])  ?      current_sqid_reg + 1'd1  :    current_cut_sq14id_reg ;
//	  current_cut_sq15id_reg   <=  (sq_cut_on[15]||sq_cut_flag[15])  ?      current_sqid_reg + 1'd1  :    current_cut_sq15id_reg ;
//	  current_cut_sq16id_reg   <=  (sq_cut_on[16]||sq_cut_flag[16])  ?      current_sqid_reg + 1'd1  :    current_cut_sq16id_reg ;
//	  current_cut_sq17id_reg   <=  (sq_cut_on[17]||sq_cut_flag[17])  ?      current_sqid_reg + 1'd1  :    current_cut_sq17id_reg ;
//	  current_cut_sq18id_reg   <=  (sq_cut_on[18]||sq_cut_flag[18])  ?      current_sqid_reg + 1'd1  :    current_cut_sq18id_reg ;
//	  current_cut_sq19id_reg   <=  (sq_cut_on[19]||sq_cut_flag[19])  ?      current_sqid_reg + 1'd1  :    current_cut_sq19id_reg ;
//	  current_cut_sq20id_reg   <=  (sq_cut_on[20]||sq_cut_flag[20])  ?      current_sqid_reg + 1'd1  :    current_cut_sq20id_reg ;
//	  current_cut_sq21id_reg   <=  (sq_cut_on[21]||sq_cut_flag[21])  ?      current_sqid_reg + 1'd1  :    current_cut_sq21id_reg ;
//	  current_cut_sq22id_reg   <=  (sq_cut_on[22]||sq_cut_flag[22])  ?      current_sqid_reg + 1'd1  :    current_cut_sq22id_reg ;
//	  current_cut_sq23id_reg   <=  (sq_cut_on[23]||sq_cut_flag[23])  ?      current_sqid_reg + 1'd1  :    current_cut_sq23id_reg ;
//	  current_cut_sq24id_reg   <=  (sq_cut_on[24]||sq_cut_flag[24])  ?      current_sqid_reg + 1'd1  :    current_cut_sq24id_reg ;
//	  current_cut_sq25id_reg   <=  (sq_cut_on[25]||sq_cut_flag[25])  ?      current_sqid_reg + 1'd1  :    current_cut_sq25id_reg ;
//	  current_cut_sq26id_reg   <=  (sq_cut_on[26]||sq_cut_flag[26])  ?      current_sqid_reg + 1'd1  :    current_cut_sq26id_reg ;
//	  current_cut_sq27id_reg   <=  (sq_cut_on[27]||sq_cut_flag[27])  ?      current_sqid_reg + 1'd1  :    current_cut_sq27id_reg ;
//	  current_cut_sq28id_reg   <=  (sq_cut_on[28]||sq_cut_flag[28])  ?      current_sqid_reg + 1'd1  :    current_cut_sq28id_reg ;
//	  current_cut_sq29id_reg   <=  (sq_cut_on[29]||sq_cut_flag[29])  ?      current_sqid_reg + 1'd1  :    current_cut_sq29id_reg ;
//	  current_cut_sq30id_reg   <=  (sq_cut_on[30]||sq_cut_flag[30])  ?      current_sqid_reg + 1'd1  :    current_cut_sq30id_reg ;
//	  current_cut_sq31id_reg   <=  (sq_cut_on[31]||sq_cut_flag[31])  ?      current_sqid_reg + 1'd1  :    current_cut_sq31id_reg ;
//  end
//end
//

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
          current_cut_sq00id_reg   <=  32'd0    ;
	  current_cut_sq01id_reg   <=  32'd0    ;
	  current_cut_sq02id_reg   <=  32'd0    ;
	  current_cut_sq03id_reg   <=  32'd0    ;
	  current_cut_sq04id_reg   <=  32'd0    ;
	  current_cut_sq05id_reg   <=  32'd0    ;
	  current_cut_sq06id_reg   <=  32'd0    ;
	  current_cut_sq07id_reg   <=  32'd0    ;
	  current_cut_sq08id_reg   <=  32'd0    ;
	  current_cut_sq09id_reg   <=  32'd0    ;
	  current_cut_sq10id_reg   <=  32'd0    ;
	  current_cut_sq11id_reg   <=  32'd0    ;
	  current_cut_sq12id_reg   <=  32'd0    ;
	  current_cut_sq13id_reg   <=  32'd0    ;
	  current_cut_sq14id_reg   <=  32'd0    ;
	  current_cut_sq15id_reg   <=  32'd0    ;
	  current_cut_sq16id_reg   <=  32'd0    ;
	  current_cut_sq17id_reg   <=  32'd0    ;
	  current_cut_sq18id_reg   <=  32'd0    ;
	  current_cut_sq19id_reg   <=  32'd0    ;
	  current_cut_sq20id_reg   <=  32'd0    ;
	  current_cut_sq21id_reg   <=  32'd0    ;
	  current_cut_sq22id_reg   <=  32'd0    ;
	  current_cut_sq23id_reg   <=  32'd0    ;
	  current_cut_sq24id_reg   <=  32'd0    ;
	  current_cut_sq25id_reg   <=  32'd0    ;
	  current_cut_sq26id_reg   <=  32'd0    ;
	  current_cut_sq27id_reg   <=  32'd0    ;
	  current_cut_sq28id_reg   <=  32'd0    ;
	  current_cut_sq29id_reg   <=  32'd0    ;
	  current_cut_sq30id_reg   <=  32'd0    ;
	  current_cut_sq31id_reg   <=  32'd0    ;
  end
  else if ( |sq_cut_flag   ) begin 
          current_cut_sq00id_reg   <=  (sq_cut_flag[ 0])  ?      current_sqid_reg + 1'd1  :    current_cut_sq00id_reg ;
	  current_cut_sq01id_reg   <=  (sq_cut_flag[ 1])  ?      current_sqid_reg + 1'd1  :    current_cut_sq01id_reg ;
	  current_cut_sq02id_reg   <=  (sq_cut_flag[ 2])  ?      current_sqid_reg + 1'd1  :    current_cut_sq02id_reg ;
	  current_cut_sq03id_reg   <=  (sq_cut_flag[ 3])  ?      current_sqid_reg + 1'd1  :    current_cut_sq03id_reg ;
	  current_cut_sq04id_reg   <=  (sq_cut_flag[ 4])  ?      current_sqid_reg + 1'd1  :    current_cut_sq04id_reg ;
	  current_cut_sq05id_reg   <=  (sq_cut_flag[ 5])  ?      current_sqid_reg + 1'd1  :    current_cut_sq05id_reg ;
	  current_cut_sq06id_reg   <=  (sq_cut_flag[ 6])  ?      current_sqid_reg + 1'd1  :    current_cut_sq06id_reg ;
	  current_cut_sq07id_reg   <=  (sq_cut_flag[ 7])  ?      current_sqid_reg + 1'd1  :    current_cut_sq07id_reg ;
	  current_cut_sq08id_reg   <=  (sq_cut_flag[ 8])  ?      current_sqid_reg + 1'd1  :    current_cut_sq08id_reg ;
	  current_cut_sq09id_reg   <=  (sq_cut_flag[ 9])  ?      current_sqid_reg + 1'd1  :    current_cut_sq09id_reg ;
	  current_cut_sq10id_reg   <=  (sq_cut_flag[10])  ?      current_sqid_reg + 1'd1  :    current_cut_sq10id_reg ;
	  current_cut_sq11id_reg   <=  (sq_cut_flag[11])  ?      current_sqid_reg + 1'd1  :    current_cut_sq11id_reg ;
	  current_cut_sq12id_reg   <=  (sq_cut_flag[12])  ?      current_sqid_reg + 1'd1  :    current_cut_sq12id_reg ;
	  current_cut_sq13id_reg   <=  (sq_cut_flag[13])  ?      current_sqid_reg + 1'd1  :    current_cut_sq13id_reg ;
	  current_cut_sq14id_reg   <=  (sq_cut_flag[14])  ?      current_sqid_reg + 1'd1  :    current_cut_sq14id_reg ;
	  current_cut_sq15id_reg   <=  (sq_cut_flag[15])  ?      current_sqid_reg + 1'd1  :    current_cut_sq15id_reg ;
	  current_cut_sq16id_reg   <=  (sq_cut_flag[16])  ?      current_sqid_reg + 1'd1  :    current_cut_sq16id_reg ;
	  current_cut_sq17id_reg   <=  (sq_cut_flag[17])  ?      current_sqid_reg + 1'd1  :    current_cut_sq17id_reg ;
	  current_cut_sq18id_reg   <=  (sq_cut_flag[18])  ?      current_sqid_reg + 1'd1  :    current_cut_sq18id_reg ;
	  current_cut_sq19id_reg   <=  (sq_cut_flag[19])  ?      current_sqid_reg + 1'd1  :    current_cut_sq19id_reg ;
	  current_cut_sq20id_reg   <=  (sq_cut_flag[20])  ?      current_sqid_reg + 1'd1  :    current_cut_sq20id_reg ;
	  current_cut_sq21id_reg   <=  (sq_cut_flag[21])  ?      current_sqid_reg + 1'd1  :    current_cut_sq21id_reg ;
	  current_cut_sq22id_reg   <=  (sq_cut_flag[22])  ?      current_sqid_reg + 1'd1  :    current_cut_sq22id_reg ;
	  current_cut_sq23id_reg   <=  (sq_cut_flag[23])  ?      current_sqid_reg + 1'd1  :    current_cut_sq23id_reg ;
	  current_cut_sq24id_reg   <=  (sq_cut_flag[24])  ?      current_sqid_reg + 1'd1  :    current_cut_sq24id_reg ;
	  current_cut_sq25id_reg   <=  (sq_cut_flag[25])  ?      current_sqid_reg + 1'd1  :    current_cut_sq25id_reg ;
	  current_cut_sq26id_reg   <=  (sq_cut_flag[26])  ?      current_sqid_reg + 1'd1  :    current_cut_sq26id_reg ;
	  current_cut_sq27id_reg   <=  (sq_cut_flag[27])  ?      current_sqid_reg + 1'd1  :    current_cut_sq27id_reg ;
	  current_cut_sq28id_reg   <=  (sq_cut_flag[28])  ?      current_sqid_reg + 1'd1  :    current_cut_sq28id_reg ;
	  current_cut_sq29id_reg   <=  (sq_cut_flag[29])  ?      current_sqid_reg + 1'd1  :    current_cut_sq29id_reg ;
	  current_cut_sq30id_reg   <=  (sq_cut_flag[30])  ?      current_sqid_reg + 1'd1  :    current_cut_sq30id_reg ;
	  current_cut_sq31id_reg   <=  (sq_cut_flag[31])  ?      current_sqid_reg + 1'd1  :    current_cut_sq31id_reg ;
  end
end






//current_cut_done_sqid_reg
//always@ (  *  )
reg    current_sqcut_done_dly  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
       current_cut_done_sqid_reg   <=   32'd0  ;
       current_sqcut_done_dly      <=    1'd0  ;
  end
//  else if  (|current_sqcut_done)   begin
  else begin
       current_sqcut_done_dly      <=    |current_sqcut_done  ;      
      case (current_sqcut_done)
	  32'h0000_0001: current_cut_done_sqid_reg   <=   (current_cut_done_sq00id_reg) ;
	  32'h0000_0002: current_cut_done_sqid_reg   <=   (current_cut_done_sq01id_reg) ;
	  32'h0000_0004: current_cut_done_sqid_reg   <=   (current_cut_done_sq02id_reg) ;
	  32'h0000_0008: current_cut_done_sqid_reg   <=   (current_cut_done_sq03id_reg) ;
	  32'h0000_0010: current_cut_done_sqid_reg   <=   (current_cut_done_sq04id_reg) ;
	  32'h0000_0020: current_cut_done_sqid_reg   <=   (current_cut_done_sq05id_reg) ;
	  32'h0000_0040: current_cut_done_sqid_reg   <=   (current_cut_done_sq06id_reg) ;
	  32'h0000_0080: current_cut_done_sqid_reg   <=   (current_cut_done_sq07id_reg) ;
	  32'h0000_0100: current_cut_done_sqid_reg   <=   (current_cut_done_sq08id_reg) ;
	  32'h0000_0200: current_cut_done_sqid_reg   <=   (current_cut_done_sq09id_reg) ;
	  32'h0000_0400: current_cut_done_sqid_reg   <=   (current_cut_done_sq10id_reg) ;
	  32'h0000_0800: current_cut_done_sqid_reg   <=   (current_cut_done_sq11id_reg) ;
	  32'h0000_1000: current_cut_done_sqid_reg   <=   (current_cut_done_sq12id_reg) ;
	  32'h0000_2000: current_cut_done_sqid_reg   <=   (current_cut_done_sq13id_reg) ;
	  32'h0000_4000: current_cut_done_sqid_reg   <=   (current_cut_done_sq14id_reg) ;
	  32'h0000_8000: current_cut_done_sqid_reg   <=   (current_cut_done_sq15id_reg) ;
	  32'h0001_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq16id_reg) ;
	  32'h0002_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq17id_reg) ;
	  32'h0004_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq18id_reg) ;
	  32'h0008_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq19id_reg) ;
	  32'h0010_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq20id_reg) ;
	  32'h0020_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq21id_reg) ;
	  32'h0040_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq22id_reg) ;
	  32'h0080_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq23id_reg) ;
	  32'h0100_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq24id_reg) ;
	  32'h0200_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq25id_reg) ;
	  32'h0400_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq26id_reg) ;
	  32'h0800_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq27id_reg) ;
	  32'h1000_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq28id_reg) ;
	  32'h2000_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq29id_reg) ;
	  32'h4000_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq30id_reg) ;
	  32'h8000_0000: current_cut_done_sqid_reg   <=   (current_cut_done_sq31id_reg) ;
          default      : current_cut_done_sqid_reg   <=   current_cut_done_sqid_reg     ;
      endcase	  
   end
end

reg   [1:0]      sq_cut_reset_cnt_00 ;    
reg   [1:0]      sq_cut_reset_cnt_01 ;
reg   [1:0]      sq_cut_reset_cnt_02 ;
reg   [1:0]      sq_cut_reset_cnt_03 ;
reg   [1:0]      sq_cut_reset_cnt_04 ;
reg   [1:0]      sq_cut_reset_cnt_05 ;
reg   [1:0]      sq_cut_reset_cnt_06 ;
reg   [1:0]      sq_cut_reset_cnt_07 ;
reg   [1:0]      sq_cut_reset_cnt_08 ;
reg   [1:0]      sq_cut_reset_cnt_09 ;
reg   [1:0]      sq_cut_reset_cnt_10 ;
reg   [1:0]      sq_cut_reset_cnt_11 ;
reg   [1:0]      sq_cut_reset_cnt_12 ;
reg   [1:0]      sq_cut_reset_cnt_13 ;
reg   [1:0]      sq_cut_reset_cnt_14 ;
reg   [1:0]      sq_cut_reset_cnt_15 ;
reg   [1:0]      sq_cut_reset_cnt_16 ;
reg   [1:0]      sq_cut_reset_cnt_17 ;
reg   [1:0]      sq_cut_reset_cnt_18 ;
reg   [1:0]      sq_cut_reset_cnt_19 ;
reg   [1:0]      sq_cut_reset_cnt_20 ;
reg   [1:0]      sq_cut_reset_cnt_21 ;
reg   [1:0]      sq_cut_reset_cnt_22 ;
reg   [1:0]      sq_cut_reset_cnt_23 ;
reg   [1:0]      sq_cut_reset_cnt_24 ;
reg   [1:0]      sq_cut_reset_cnt_25 ;
reg   [1:0]      sq_cut_reset_cnt_26 ;
reg   [1:0]      sq_cut_reset_cnt_27 ;
reg   [1:0]      sq_cut_reset_cnt_28 ;
reg   [1:0]      sq_cut_reset_cnt_29 ;
reg   [1:0]      sq_cut_reset_cnt_30 ;
reg   [1:0]      sq_cut_reset_cnt_31 ;

//sq_cut_reset
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_reset_pre   <=  32'd0    ;
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
      sq_cut_reset_pre   <=  32'h0000_0000   ;
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
  else if ( current_sqcut_done_dly   )  begin  
	   sq_cut_reset_pre[ 0]   <= (  sq_cut_on[ 0] && ( (current_cut_sq00id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq00id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_00>=2'd1)   )  ))    ;    // ||   (current_cut_sq00id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 1]   <= (  sq_cut_on[ 1] && ( (current_cut_sq01id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq01id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_01>=2'd1)   )  ))    ;    // ||   (current_cut_sq01id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 2]   <= (  sq_cut_on[ 2] && ( (current_cut_sq02id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq02id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_02>=2'd1)   )  ))    ;    // ||   (current_cut_sq02id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 3]   <= (  sq_cut_on[ 3] && ( (current_cut_sq03id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq03id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_03>=2'd1)   )  ))    ;    // ||   (current_cut_sq03id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 4]   <= (  sq_cut_on[ 4] && ( (current_cut_sq04id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq04id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_04>=2'd1)   )  ))    ;    // ||   (current_cut_sq04id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 5]   <= (  sq_cut_on[ 5] && ( (current_cut_sq05id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq05id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_05>=2'd1)   )  ))    ;    // ||   (current_cut_sq05id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 6]   <= (  sq_cut_on[ 6] && ( (current_cut_sq06id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq06id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_06>=2'd1)   )  ))    ;    // ||   (current_cut_sq06id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 7]   <= (  sq_cut_on[ 7] && ( (current_cut_sq07id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq07id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_07>=2'd1)   )  ))    ;    // ||   (current_cut_sq07id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 8]   <= (  sq_cut_on[ 8] && ( (current_cut_sq08id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq08id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_08>=2'd1)   )  ))    ;    // ||   (current_cut_sq08id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[ 9]   <= (  sq_cut_on[ 9] && ( (current_cut_sq09id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq09id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_09>=2'd1)   )  ))    ;    // ||   (current_cut_sq09id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[10]   <= (  sq_cut_on[10] && ( (current_cut_sq10id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq10id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_10>=2'd1)   )  ))    ;    // ||   (current_cut_sq10id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[11]   <= (  sq_cut_on[11] && ( (current_cut_sq11id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq11id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_11>=2'd1)   )  ))    ;    // ||   (current_cut_sq11id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[12]   <= (  sq_cut_on[12] && ( (current_cut_sq12id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq12id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_12>=2'd1)   )  ))    ;    // ||   (current_cut_sq12id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[13]   <= (  sq_cut_on[13] && ( (current_cut_sq13id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq13id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_13>=2'd1)   )  ))    ;    // ||   (current_cut_sq13id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[14]   <= (  sq_cut_on[14] && ( (current_cut_sq14id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq14id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_14>=2'd1)   )  ))    ;    // ||   (current_cut_sq14id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[15]   <= (  sq_cut_on[15] && ( (current_cut_sq15id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq15id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_15>=2'd1)   )  ))    ;    // ||   (current_cut_sq15id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[16]   <= (  sq_cut_on[16] && ( (current_cut_sq16id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq16id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_16>=2'd1)   )  ))    ;    // ||   (current_cut_sq16id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[17]   <= (  sq_cut_on[17] && ( (current_cut_sq17id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq17id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_17>=2'd1)   )  ))    ;    // ||   (current_cut_sq17id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[18]   <= (  sq_cut_on[18] && ( (current_cut_sq18id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq18id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_18>=2'd1)   )  ))    ;    // ||   (current_cut_sq18id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[19]   <= (  sq_cut_on[19] && ( (current_cut_sq19id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq19id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_19>=2'd1)   )  ))    ;    // ||   (current_cut_sq19id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[20]   <= (  sq_cut_on[20] && ( (current_cut_sq20id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq20id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_20>=2'd1)   )  ))    ;    // ||   (current_cut_sq20id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[21]   <= (  sq_cut_on[21] && ( (current_cut_sq21id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq21id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_21>=2'd1)   )  ))    ;    // ||   (current_cut_sq21id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[22]   <= (  sq_cut_on[22] && ( (current_cut_sq22id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq22id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_22>=2'd1)   )  ))    ;    // ||   (current_cut_sq22id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[23]   <= (  sq_cut_on[23] && ( (current_cut_sq23id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq23id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_23>=2'd1)   )  ))    ;    // ||   (current_cut_sq23id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[24]   <= (  sq_cut_on[24] && ( (current_cut_sq24id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq24id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_24>=2'd1)   )  ))    ;    // ||   (current_cut_sq24id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[25]   <= (  sq_cut_on[25] && ( (current_cut_sq25id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq25id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_25>=2'd1)   )  ))    ;    // ||   (current_cut_sq25id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[26]   <= (  sq_cut_on[26] && ( (current_cut_sq26id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq26id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_26>=2'd1)   )  ))    ;    // ||   (current_cut_sq26id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[27]   <= (  sq_cut_on[27] && ( (current_cut_sq27id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq27id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_27>=2'd1)   )  ))    ;    // ||   (current_cut_sq27id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[28]   <= (  sq_cut_on[28] && ( (current_cut_sq28id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq28id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_28>=2'd1)   )  ))    ;    // ||   (current_cut_sq28id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[29]   <= (  sq_cut_on[29] && ( (current_cut_sq29id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq29id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_29>=2'd1)   )  ))    ;    // ||   (current_cut_sq29id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[30]   <= (  sq_cut_on[30] && ( (current_cut_sq30id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq30id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_30>=2'd1)   )  ))    ;    // ||   (current_cut_sq30id_reg[31]&&~current_cut_done_sqid_reg[31]) ;
	   sq_cut_reset_pre[31]   <= (  sq_cut_on[31] && ( (current_cut_sq31id_reg==current_cut_done_sqid_reg) || ( (current_cut_sq31id_reg<current_cut_done_sqid_reg) &&  (sq_cut_reset_cnt_31>=2'd1)   )  ))    ;    // ||   (current_cut_sq31id_reg[31]&&~current_cut_done_sqid_reg[31]) ;

       sq_cut_reset_cnt_00   <=   (current_cut_sq00id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq00id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_00>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_00+1'd1) ) :  sq_cut_reset_cnt_00 ;     
       sq_cut_reset_cnt_01   <=   (current_cut_sq01id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq01id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_01>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_01+1'd1) ) :  sq_cut_reset_cnt_01 ;
       sq_cut_reset_cnt_02   <=   (current_cut_sq02id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq02id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_02>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_02+1'd1) ) :  sq_cut_reset_cnt_02 ;
       sq_cut_reset_cnt_03   <=   (current_cut_sq03id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq03id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_03>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_03+1'd1) ) :  sq_cut_reset_cnt_03 ;
       sq_cut_reset_cnt_04   <=   (current_cut_sq04id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq04id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_04>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_04+1'd1) ) :  sq_cut_reset_cnt_04 ;
       sq_cut_reset_cnt_05   <=   (current_cut_sq05id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq05id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_05>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_05+1'd1) ) :  sq_cut_reset_cnt_05 ;
       sq_cut_reset_cnt_06   <=   (current_cut_sq06id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq06id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_06>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_06+1'd1) ) :  sq_cut_reset_cnt_06 ;
       sq_cut_reset_cnt_07   <=   (current_cut_sq07id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq07id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_07>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_07+1'd1) ) :  sq_cut_reset_cnt_07 ;
       sq_cut_reset_cnt_08   <=   (current_cut_sq08id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq08id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_08>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_08+1'd1) ) :  sq_cut_reset_cnt_08 ;
       sq_cut_reset_cnt_09   <=   (current_cut_sq09id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq09id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_09>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_09+1'd1) ) :  sq_cut_reset_cnt_09 ;
       sq_cut_reset_cnt_10   <=   (current_cut_sq10id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq10id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_10>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_10+1'd1) ) :  sq_cut_reset_cnt_10 ;
       sq_cut_reset_cnt_11   <=   (current_cut_sq11id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq11id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_11>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_11+1'd1) ) :  sq_cut_reset_cnt_11 ;
       sq_cut_reset_cnt_12   <=   (current_cut_sq12id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq12id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_12>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_12+1'd1) ) :  sq_cut_reset_cnt_12 ;
       sq_cut_reset_cnt_13   <=   (current_cut_sq13id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq13id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_13>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_13+1'd1) ) :  sq_cut_reset_cnt_13 ;
       sq_cut_reset_cnt_14   <=   (current_cut_sq14id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq14id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_14>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_14+1'd1) ) :  sq_cut_reset_cnt_14 ;
       sq_cut_reset_cnt_15   <=   (current_cut_sq15id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq15id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_15>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_15+1'd1) ) :  sq_cut_reset_cnt_15 ;
       sq_cut_reset_cnt_16   <=   (current_cut_sq16id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq16id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_16>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_16+1'd1) ) :  sq_cut_reset_cnt_16 ;
       sq_cut_reset_cnt_17   <=   (current_cut_sq17id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq17id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_17>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_17+1'd1) ) :  sq_cut_reset_cnt_17 ;
       sq_cut_reset_cnt_18   <=   (current_cut_sq18id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq18id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_18>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_18+1'd1) ) :  sq_cut_reset_cnt_18 ;
       sq_cut_reset_cnt_19   <=   (current_cut_sq19id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq19id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_19>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_19+1'd1) ) :  sq_cut_reset_cnt_19 ;
       sq_cut_reset_cnt_20   <=   (current_cut_sq20id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq20id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_20>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_20+1'd1) ) :  sq_cut_reset_cnt_20 ;
       sq_cut_reset_cnt_21   <=   (current_cut_sq21id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq21id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_21>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_21+1'd1) ) :  sq_cut_reset_cnt_21 ;
       sq_cut_reset_cnt_22   <=   (current_cut_sq22id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq22id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_22>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_22+1'd1) ) :  sq_cut_reset_cnt_22 ;
       sq_cut_reset_cnt_23   <=   (current_cut_sq23id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq23id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_23>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_23+1'd1) ) :  sq_cut_reset_cnt_23 ;
       sq_cut_reset_cnt_24   <=   (current_cut_sq24id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq24id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_24>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_24+1'd1) ) :  sq_cut_reset_cnt_24 ;
       sq_cut_reset_cnt_25   <=   (current_cut_sq25id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq25id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_25>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_25+1'd1) ) :  sq_cut_reset_cnt_25 ;
       sq_cut_reset_cnt_26   <=   (current_cut_sq26id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq26id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_26>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_26+1'd1) ) :  sq_cut_reset_cnt_26 ;
       sq_cut_reset_cnt_27   <=   (current_cut_sq27id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq27id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_27>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_27+1'd1) ) :  sq_cut_reset_cnt_27 ;
       sq_cut_reset_cnt_28   <=   (current_cut_sq28id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq28id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_28>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_28+1'd1) ) :  sq_cut_reset_cnt_28 ;
       sq_cut_reset_cnt_29   <=   (current_cut_sq29id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq29id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_29>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_29+1'd1) ) :  sq_cut_reset_cnt_29 ;
       sq_cut_reset_cnt_30   <=   (current_cut_sq30id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq30id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_30>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_30+1'd1) ) :  sq_cut_reset_cnt_30 ;
       sq_cut_reset_cnt_31   <=   (current_cut_sq31id_reg==current_cut_done_sqid_reg)  ?   2'd0   :    (current_cut_sq31id_reg<current_cut_done_sqid_reg)  ? ((sq_cut_reset_cnt_31>=2'd1)  ?  2'd0  :    ( sq_cut_reset_cnt_31+1'd1) ) :  sq_cut_reset_cnt_31 ;
  end
  else begin
           sq_cut_reset_pre[ 0]   <=   (current_cut_sq00id_reg==current_sqid_reg)&& sq_cut_on[ 0] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 1]   <=   (current_cut_sq01id_reg==current_sqid_reg)&& sq_cut_on[ 1] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 2]   <=   (current_cut_sq02id_reg==current_sqid_reg)&& sq_cut_on[ 2] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 3]   <=   (current_cut_sq03id_reg==current_sqid_reg)&& sq_cut_on[ 3] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 4]   <=   (current_cut_sq04id_reg==current_sqid_reg)&& sq_cut_on[ 4] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 5]   <=   (current_cut_sq05id_reg==current_sqid_reg)&& sq_cut_on[ 5] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 6]   <=   (current_cut_sq06id_reg==current_sqid_reg)&& sq_cut_on[ 6] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 7]   <=   (current_cut_sq07id_reg==current_sqid_reg)&& sq_cut_on[ 7] && current_sqid_reg_vld ;
	   sq_cut_reset_pre[ 8]   <=   (current_cut_sq08id_reg==current_sqid_reg)&& sq_cut_on[ 8] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[ 9]   <=   (current_cut_sq09id_reg==current_sqid_reg)&& sq_cut_on[ 9] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[10]   <=   (current_cut_sq10id_reg==current_sqid_reg)&& sq_cut_on[10] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[11]   <=   (current_cut_sq11id_reg==current_sqid_reg)&& sq_cut_on[11] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[12]   <=   (current_cut_sq12id_reg==current_sqid_reg)&& sq_cut_on[12] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[13]   <=   (current_cut_sq13id_reg==current_sqid_reg)&& sq_cut_on[13] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[14]   <=   (current_cut_sq14id_reg==current_sqid_reg)&& sq_cut_on[14] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[15]   <=   (current_cut_sq15id_reg==current_sqid_reg)&& sq_cut_on[15] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[16]   <=   (current_cut_sq16id_reg==current_sqid_reg)&& sq_cut_on[16] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[17]   <=   (current_cut_sq17id_reg==current_sqid_reg)&& sq_cut_on[17] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[18]   <=   (current_cut_sq18id_reg==current_sqid_reg)&& sq_cut_on[18] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[19]   <=   (current_cut_sq19id_reg==current_sqid_reg)&& sq_cut_on[19] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[20]   <=   (current_cut_sq20id_reg==current_sqid_reg)&& sq_cut_on[20] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[21]   <=   (current_cut_sq21id_reg==current_sqid_reg)&& sq_cut_on[21] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[22]   <=   (current_cut_sq22id_reg==current_sqid_reg)&& sq_cut_on[22] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[23]   <=   (current_cut_sq23id_reg==current_sqid_reg)&& sq_cut_on[23] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[24]   <=   (current_cut_sq24id_reg==current_sqid_reg)&& sq_cut_on[24] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[25]   <=   (current_cut_sq25id_reg==current_sqid_reg)&& sq_cut_on[25] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[26]   <=   (current_cut_sq26id_reg==current_sqid_reg)&& sq_cut_on[26] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[27]   <=   (current_cut_sq27id_reg==current_sqid_reg)&& sq_cut_on[27] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[28]   <=   (current_cut_sq28id_reg==current_sqid_reg)&& sq_cut_on[28] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[29]   <=   (current_cut_sq29id_reg==current_sqid_reg)&& sq_cut_on[29] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[30]   <=   (current_cut_sq30id_reg==current_sqid_reg)&& sq_cut_on[30] && current_sqid_reg_vld  ;
	   sq_cut_reset_pre[31]   <=   (current_cut_sq31id_reg==current_sqid_reg)&& sq_cut_on[31] && current_sqid_reg_vld  ;
  end
end


// sq_cut_reset
// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // sq_cut_reset   <=  1'd0    ;
  // end
  // else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  &&  sq_frame_flag ) begin 
      // if ( (current_id_wire==current_cut_sqid_reg)   ) begin
             // sq_cut_reset  <=    1'd1  ;
      // end
////       sync_len_byte_reg
      // else if (  ( (current_id_wire+1'd1)==current_cut_sqid_reg)  &&  ((st_rx_cnt_reg+6'd10)>sync_len_byte_reg)      ) begin
             // sq_cut_reset  <=    1'd1  ;             
      // end
      // else if (  ( (current_id_wire)>current_cut_sqid_reg)  &&  ((st_rx_cnt_reg+6'd10)>sync_len_byte_reg) &&  ( (st_rx_cnt_reg+6'd10-sync_len_byte_reg) < 7'd81  )      ) begin
             // sq_cut_reset  <=    1'd1  ;             
      // end 
 
      // else begin
             // sq_cut_reset  <=    1'd0  ;            
      // end
  // end
  // else begin
             // sq_cut_reset  <=    1'd0  ;                  
  // end
// end




endmodule

