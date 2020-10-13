module  filter_rx_fsm  (
clk                ,
rst_n              ,  


params_current_sqid_reg_add ,
params_current_sqid_reg_cnt ,
params_current_sqid_reg_rst_cnt ,

sq_market_rdy       ,

debug_discard_calc_cnt1  ,
debug_st_shift_full_flag ,
debug_st_shift_scnt      ,
debug_st_shift_en        ,


st_rx_cnt_reg      ,
st_shift_ccnt      ,
sync_len_byte      ,
sq_frame_flag      ,
sync_fisrt_byte    ,
sync_four_byte     ,

params_frame_type_byte      ,

params_03e9_type            ,
params_1389_type            ,
params_07d0_type            ,

sub_sqcut_len_reg           ,

current_sqid_reg_flag         ,

current_cut_now_sqid_reg_vld  ,
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

sq_cut_on_reg                 ,
sq_cut_first_on               ,

st_rx_start_pre        , 

st_rx_start        , 
st_rx_offset       ,
st_rx_end          , 
st_rx_valid        , 
st_rx_ready        ,
st_rx_data         , 
st_rx_empty        , 
st_rx_cnt          ,
first_sync_len_byte,                 
tcp_sqmatch_flag_reg   ,  //match with pre  SQ tcp frame 
tcp_sqmatch_flag       ,
seq_err_flag           ,
tcp_payload_len    ,


error_flag         ,
//sq_cut_flag        ,  //cut _flag   

//sq_cut_reset       ,     
         
fir_r_idle_st      ,   
fir_r_sqcuth_st     ,
fir_r_vsync_st      ,
fir_r_sqcut_st      ,
fir_r_sqcut_end_st  ,
fir_r_sqrcut_st     ,
fir_r_sqrcut_end_st ,
fir_r_rjudge_st     ,
                
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
current_sqid_reg   ,
current_sqid_reg_vld ,

params_current_sqid_reg_ro   ,
params_filter_rst            ,


sq_shift_full_flag ,

market_explain     , //市场说明 3
info_classify      , //信息分类 1
dialog_num         , //会话编号 4
contract_flag      , //合约标志 1
contract_num       , //合约编号 4
contract_code      , //合约代码 22
update_time        , //更新时间 9
update_ms          , //更新毫秒 4
new_price          , //�?新价 8
turnover           , //成交�? 4
volume             , //成交�? 8   
position           , //持仓�? 8
purchase_price     , //申买�? 8
buy_quantity       , //申买�? 4
sell_price         , //申买�? 8
sell_quantity      , //申卖�? 4
market_rdy        , 
fir_rx_cstate
);

parameter   FIR_R_IDLE_STATE         =    5'd0  ;    
parameter   FIR_R_VSYNC_STATE        =    5'd2  ;    
parameter   FIR_R_CHECK_STATE        =    5'd4  ;    
parameter   FIR_R_ID_STATE           =    5'd5  ;    
parameter   FIR_R_HEADER_STATE       =    5'd6  ;    
parameter   FIR_R_RDATA0_STATE       =    5'd7  ;            
parameter   FIR_R_REND_STATE         =    5'd8  ;
parameter   FIR_R_RJUDGE_STATE       =    5'd9  ;       
parameter   FIR_R_DISCARD_STATE      =    5'd10 ;       
parameter   FIR_R_DISEND_STATE       =    5'd11 ;      
parameter   FIR_RSQ_SEGMT_STATE      =    5'd12 ;     
parameter   FIR_RSQ_SEGMT_END_STATE  =    5'd14 ;     
parameter   FIR_RSQ_SEGMT_H_STATE    =    5'd16 ;
parameter   FIR_R_SQRCUT_STATE       =    5'd18 ;
parameter   FIR_R_SQRCUT_END_STATE   =    5'd20 ;
parameter   FIR_R_ERROR_STATE        =    5'd22 ; 


//add debug 

input    [31:0]          params_current_sqid_reg_rst_cnt ;  // 1min  'h38000


input    [31:0]    sq_market_rdy      ;


output   [3:0]         debug_discard_calc_cnt1  ;

output                 debug_st_shift_full_flag ;


output   [  5:0]       debug_st_shift_scnt      ;
output                 debug_st_shift_en        ;




//add debug 




input                      clk                ;
input                      rst_n              ;

input    [15:0]            sub_sqcut_len_reg    ;

input    [15:0]            params_frame_type_byte   ;

input    [15:0]            params_03e9_type            ;
input    [15:0]            params_1389_type            ;
input    [15:0]            params_07d0_type            ;

output                     current_sqid_reg_flag         ;

output   [31:0]            params_current_sqid_reg_ro    ;
input                      params_filter_rst             ;

input    [31:0]            current_cut_now_sqid_reg_vld   ;
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
input    [31:0]            current_sqcut_done   ;

input    [31:0]            sq_cut_on_reg    ;
input    [31:0]            sq_cut_first_on  ;
                                 
input                      st_rx_start_pre        ; 
          
input                      st_rx_start        ; 
input    [ 3:0]            st_rx_offset       ;
input                      st_rx_end          ; 
input                      st_rx_valid        ; 
input    [63:0]            st_rx_data         ; 
input    [ 2:0]            st_rx_empty        ; 
input    [15:0]            st_rx_cnt          ; 
output                     st_rx_ready        ;
input    [15:0]            first_sync_len_byte;
                                              
//tcp                                         
input    [31:0]            tcp_sqmatch_flag_reg  ;  //match with pre  SQ tcp frame 
input                      tcp_sqmatch_flag      ;
input                      seq_err_flag          ;
                                              
output     [31:0]           error_flag         ;
//output     [31:0]          sq_cut_flag        ;  //cut _flag
                           
//output                     sq_cut_reset        ;  //cut _flag
                   
output                     fir_r_idle_st       ;
output                     fir_r_sqcuth_st     ;
output                     fir_r_vsync_st      ;
output                     fir_r_sqcut_st      ;
output                     fir_r_sqcut_end_st  ;
output                     fir_r_sqrcut_st     ;
output                     fir_r_sqrcut_end_st ;
output                     fir_r_rjudge_st     ;            

                                              
input    [15:0]            tcp_payload_len    ;

input                      sq_shift_full_flag ;

/////////////////////////////////////////////////////////////////////////////////////

output    [31:0]           sq_rx_start        ; 
output    [31:0]           sq_rx_end          ; 
output    [31:0]           sq_rx_valid        ; 
output    [63:0]           sq_rx_data         ; 
output    [ 2:0]           sq_rx_empty        ; 

output     [ 2:0]           sq_rx_empty_01        ; 
output     [ 2:0]           sq_rx_empty_02        ; 
output     [ 2:0]           sq_rx_empty_03        ; 
output     [ 2:0]           sq_rx_empty_04        ; 
output     [ 2:0]           sq_rx_empty_05        ; 
output     [ 2:0]           sq_rx_empty_06        ; 
output     [ 2:0]           sq_rx_empty_07        ; 
output     [ 2:0]           sq_rx_empty_08        ; 
output     [ 2:0]           sq_rx_empty_09        ; 
output     [ 2:0]           sq_rx_empty_10        ; 
output     [ 2:0]           sq_rx_empty_11        ; 
output     [ 2:0]           sq_rx_empty_12        ; 
output     [ 2:0]           sq_rx_empty_13        ; 
output     [ 2:0]           sq_rx_empty_14        ; 
output     [ 2:0]           sq_rx_empty_15        ; 
output     [ 2:0]           sq_rx_empty_16        ; 
output     [ 2:0]           sq_rx_empty_17        ; 
output     [ 2:0]           sq_rx_empty_18        ; 
output     [ 2:0]           sq_rx_empty_19        ; 
output     [ 2:0]           sq_rx_empty_20        ; 
output     [ 2:0]           sq_rx_empty_21        ; 
output     [ 2:0]           sq_rx_empty_22        ; 
output     [ 2:0]           sq_rx_empty_23        ; 
output     [ 2:0]           sq_rx_empty_24        ; 
output     [ 2:0]           sq_rx_empty_25        ; 
output     [ 2:0]           sq_rx_empty_26        ; 
output     [ 2:0]           sq_rx_empty_27        ; 
output     [ 2:0]           sq_rx_empty_28        ; 
output     [ 2:0]           sq_rx_empty_29        ; 
output     [ 2:0]           sq_rx_empty_30        ;
output     [ 2:0]           sq_rx_empty_31        ; 


output    [31:0]           current_sqid_reg   ;
output                     current_sqid_reg_vld ;

output    [ 23: 0]         market_explain ; //市场说明 3
output    [  7: 0]         info_classify  ; //信息分类 1
output    [ 31: 0]         dialog_num     ; //会话编号 4
output    [  7: 0]         contract_flag  ; //合约标志 1
output    [ 31: 0]         contract_num   ; //合约编号 4
output    [175: 0]         contract_code  ; //合约代码 22
output    [ 71: 0]         update_time    ; //更新时间 9
output    [ 31: 0]         update_ms      ; //更新毫秒 4
output    [ 63: 0]         new_price      ; //�?新价 8
output    [ 31: 0]         turnover       ; //成交�? 4
output    [ 63: 0]         volume         ; //成交�? 8   
output    [ 63: 0]         position       ; //持仓�? 8
output    [ 63: 0]         purchase_price ; //申买�? 8
output    [ 31: 0]         buy_quantity   ; //申买�? 4
output    [ 63: 0]         sell_price     ; //申买�? 8
output    [ 31: 0]         sell_quantity  ; //申卖�? 4
output                     market_rdy     ;

output    [ 15: 0]         st_rx_cnt_reg       ; 
output    [  5: 0]         st_shift_ccnt      ;
output    [ 15: 0]         sync_len_byte      ;


output   [ 15:0]            sync_fisrt_byte     ;
output   [ 31:0]            sync_four_byte      ;

 
output                     sq_frame_flag      ;
output                    fir_rx_cstate;




input      [3:0]            params_current_sqid_reg_add   ;
input      [3:0]            params_current_sqid_reg_cnt   ;



//////////////////////////////////////////////////////////////////////////////////////////////
reg                frame_type_rdy   ;


wire                       st_shift_full_flag ;


wire  debug_st_shift_full_flag = st_shift_full_flag ;

reg       [31:0]            error_flag        ;

wire                       st_rx_ready        ;

reg      [  5:0]           st_shift_scnt      ;
reg                        st_shift_en        ; 


wire      [  5:0]           debug_st_shift_scnt  =   st_shift_scnt   ;
wire                        debug_st_shift_en    =   st_shift_en  ;



//reg      [31:0]            sq_cut_flag        ;  //cut _flag

wire     [31:0]            sq_rx_start        ; 
wire     [31:0]            sq_rx_end          ; 
wire     [31:0]            sq_rx_valid        ; 
wire     [63:0]            sq_rx_data         ; 
wire     [ 2:0]            sq_rx_empty        ; 

wire      [ 2:0]           sq_rx_empty_01        ; 
wire      [ 2:0]           sq_rx_empty_02        ; 
wire      [ 2:0]           sq_rx_empty_03        ; 
wire      [ 2:0]           sq_rx_empty_04        ; 
wire      [ 2:0]           sq_rx_empty_05        ; 
wire      [ 2:0]           sq_rx_empty_06        ; 
wire      [ 2:0]           sq_rx_empty_07        ; 
wire      [ 2:0]           sq_rx_empty_08        ; 
wire      [ 2:0]           sq_rx_empty_09        ; 
wire      [ 2:0]           sq_rx_empty_10        ; 
wire      [ 2:0]           sq_rx_empty_11        ; 
wire      [ 2:0]           sq_rx_empty_12        ; 
wire      [ 2:0]           sq_rx_empty_13        ; 
wire      [ 2:0]           sq_rx_empty_14        ; 
wire      [ 2:0]           sq_rx_empty_15        ; 
wire      [ 2:0]           sq_rx_empty_16        ; 
wire      [ 2:0]           sq_rx_empty_17        ; 
wire      [ 2:0]           sq_rx_empty_18        ; 
wire      [ 2:0]           sq_rx_empty_19        ; 
wire      [ 2:0]           sq_rx_empty_20        ; 
wire      [ 2:0]           sq_rx_empty_21        ; 
wire      [ 2:0]           sq_rx_empty_22        ; 
wire      [ 2:0]           sq_rx_empty_23        ; 
wire      [ 2:0]           sq_rx_empty_24        ; 
wire      [ 2:0]           sq_rx_empty_25        ; 
wire      [ 2:0]           sq_rx_empty_26        ; 
wire      [ 2:0]           sq_rx_empty_27        ; 
wire      [ 2:0]           sq_rx_empty_28        ; 
wire      [ 2:0]           sq_rx_empty_29        ; 
wire      [ 2:0]           sq_rx_empty_30        ;
wire      [ 2:0]           sq_rx_empty_31        ; 

//wire     [ 23:0]           st_shift_start_reg ;
//wire     [ 23:0]           st_shift_end_reg   ;    
wire     [191:0]           st_shift_reg       ;
wire     [  5:0]           st_shift_ccnt      ;
wire     [  5:0]           debug_st_shift_ccnt    =  st_shift_ccnt   ;




////////////////////////////////////////////////////////////////////////////////////
reg      [31:0]            current_sqid_reg       ;
reg      [31:0]            current_sqid_reg_max   ;

reg                        current_sqid_reg_rst   ;


reg                        current_sqid_reg_vld ;

reg      [31:0]            params_current_sqid_reg_ro ;
reg                        params_current_sqid_reg_ro_vld ; 
reg                        current_sqid_reg_match_flag    ;

reg                        current_sqid_reg_match_flag1    ;
reg                        current_sqid_reg_match_flag2    ;
reg                        current_sqid_reg_match_flag3    ;
reg                        current_sqid_reg_match_flag4    ;


//reg      [31:0]            current_cut_sqid_reg   ;

reg                        current_sqid_reg_flag ;

reg      [31:0]            current_sqid_reg_match_00 ;
reg      [31:0]            current_sqid_reg_match_01 ;
reg      [31:0]            current_sqid_reg_match_02 ;
reg      [31:0]            current_sqid_reg_match_03 ;
reg      [31:0]            current_sqid_reg_match_04 ;
reg      [31:0]            current_sqid_reg_match_05 ;
reg      [31:0]            current_sqid_reg_match_06 ;
reg      [31:0]            current_sqid_reg_match_07 ;
reg      [31:0]            current_sqid_reg_match_08 ;
reg      [31:0]            current_sqid_reg_match_09 ;
reg      [31:0]            current_sqid_reg_match_0a ;
reg      [31:0]            current_sqid_reg_match_0b ;
reg      [31:0]            current_sqid_reg_match_0c ;
reg      [31:0]            current_sqid_reg_match_0d ;
reg      [31:0]            current_sqid_reg_match_0e ;
reg      [31:0]            current_sqid_reg_match_0f ;
reg      [31:0]            current_sqid_reg_match_10 ;
reg      [31:0]            current_sqid_reg_match_11 ;
reg      [31:0]            current_sqid_reg_match_12 ;
reg      [31:0]            current_sqid_reg_match_13 ;
reg      [31:0]            current_sqid_reg_match_14 ;
reg      [31:0]            current_sqid_reg_match_15 ;
reg      [31:0]            current_sqid_reg_match_16 ;
reg      [31:0]            current_sqid_reg_match_17 ;
reg      [31:0]            current_sqid_reg_match_18 ;
reg      [31:0]            current_sqid_reg_match_19 ;
reg      [31:0]            current_sqid_reg_match_1a ;
reg      [31:0]            current_sqid_reg_match_1b ;
reg      [31:0]            current_sqid_reg_match_1c ;
reg      [31:0]            current_sqid_reg_match_1d ;
reg      [31:0]            current_sqid_reg_match_1e ;
reg      [31:0]            current_sqid_reg_match_1f ;




//reg                        sq_cut_reset           ;

////////////////////////////////////////////////////////////////////////////////////
wire     [15:0]   sync_fisrt_byte    =  st_shift_reg[127+64:112+64];
wire     [15:0]   sync_len_byte      =  st_shift_reg[111+64: 96+64];
wire     [31:0]   sync_four_byte     =  st_shift_reg[ 95+64: 64+64];

wire     [15:0]   frame_type_byte    =  st_shift_reg[127+64:112+64];
wire     [31:0]   frame_sync_byte    =  st_shift_reg[111+64: 80+64];

wire     [31:0]    current_id_wire   =  st_shift_reg[127+64:96+64] ;
wire     [15:0]    patition_cnt_wire =  st_shift_reg[ 95+64:80+64] ;
wire     [15:0]    patition_len_wire =  st_shift_reg[ 79+64:64+64] ;

wire     [15:0]    segm_type_wire    =  st_shift_reg[127+64:112+64];   
wire     [15:0]    segm_len_wire     =  st_shift_reg[111+64: 96+64];   

wire     [15:0]    segm_min_len      =   16'd81 ; 

//reg    [15:0]   st_rq_cut_cnt  ;
//wire   [15:0]   sub_sqcut_len_reg  =  (sq_cut_len_reg - st_rq_cut_cnt) ;

reg     [31:0]            current_cut_done_sqid_reg   ;

///////////////////////////////////////////////////////////////////////////////////////
reg       [15:0]   st_rx_cnt_reg       ; 

reg                sq_frame_flag       ;

reg       [15:0]   sync_len_byte_reg   ;
reg       [15:0]   sync_len_rest_reg   ;
wire      [11:0]   discard_calc_cnt0   ;
wire      [ 3:0]   discard_calc_cnt1   ;
reg       [11:0]   discard_data_cnt    ;
assign  discard_calc_cnt0 = sync_len_rest_reg[15:4] ;
assign  discard_calc_cnt1 = sync_len_rest_reg[ 3:0] ;


wire  [3:0]  debug_discard_calc_cnt1 = sync_len_rest_reg[ 3:0] ;



reg       [15:0]    patition_cnt_reg  ;
reg       [15:0]    patition_len_reg  ;

reg       [15:0]    patition_cnt      ;          

reg       [15:0]   segm_len            ;
reg       [15:0]   segm_type           ;
wire      [11:0]   segm_cnt0_wire      ;
wire      [ 3:0]   segm_cnt1_wire      ;
assign     segm_cnt0_wire = segm_len[15:4] ;
assign     segm_cnt1_wire = segm_len[ 3:0] ;
reg       [11:0]   segm_cnt            ;

reg       [15:0]   st_rx_cut_cnt       ;

wire               st_rx_data_en = st_rx_valid && st_rx_ready ;

reg                        sq_cut_on        ;  //cut _flag


//assign   sq_cut_on = (&sq_cut_on_reg)  ;

assign   st_rx_ready  = 1'b1       ;

reg      type_03e9_flag    ;
reg      type_1389_flag    ;
///////////////////////////////////////////////////////////////////////////////////////

//input    [15:0]            params_frame_type_byte   ;
//input    [15:0]            params_03e9_type            ;
//input    [15:0]            params_1389_type            ;
//input    [15:0]            params_07d0_type            ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     type_03e9_flag  <=  1'd0 ;
     type_1389_flag  <=  1'd0 ;     
  end
  else begin 
     type_03e9_flag  <=   (params_frame_type_byte==params_03e9_type)|| (params_frame_type_byte==params_07d0_type);
     type_1389_flag  <=   (params_frame_type_byte==params_1389_type);     
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     sq_cut_on  <=  5'd0 ;
  end
  else begin 
     sq_cut_on  <=  (&sq_cut_on_reg)  ;
  end
end

////////////////////////////////////////////////////////////////////////////////////
reg     [ 4:0]     fir_rx_cstate ;
reg     [ 4:0]     fir_rx_nstate ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     fir_rx_cstate  <=  5'd0 ;
  end
  else if ( (st_rx_start_pre&&~fir_r_idle_st)||params_filter_rst ) begin
     fir_rx_cstate  <=  5'd0 ;
  end
  else begin 
     fir_rx_cstate  <=  fir_rx_nstate ;
  end
end

wire  fir_r_idle_st      =  (  fir_rx_cstate== FIR_R_IDLE_STATE        );    
wire  fir_r_vsync_st     =  (  fir_rx_cstate== FIR_R_VSYNC_STATE       );    
wire  fir_r_check_st     =  (  fir_rx_cstate== FIR_R_CHECK_STATE       );    
wire  fir_r_id_st        =  (  fir_rx_cstate== FIR_R_ID_STATE          );    
wire  fir_r_header_st    =  (  fir_rx_cstate== FIR_R_HEADER_STATE      );    
wire  fir_r_rdata0_st    =  (  fir_rx_cstate== FIR_R_RDATA0_STATE      );            
wire  fir_r_rend_st      =  (  fir_rx_cstate== FIR_R_REND_STATE        );
wire  fir_r_rjudge_st    =  (  fir_rx_cstate== FIR_R_RJUDGE_STATE      );       
wire  fir_r_discard_st   =  (  fir_rx_cstate== FIR_R_DISCARD_STATE     );       
wire  fir_r_disend_st    =  (  fir_rx_cstate== FIR_R_DISEND_STATE      );      
wire  fir_r_sqcut_st     =  (  fir_rx_cstate== FIR_RSQ_SEGMT_STATE     );     

wire  fir_r_sqcut_end_st =  (  fir_rx_cstate== FIR_RSQ_SEGMT_END_STATE );     
    
wire  fir_r_sqcuth_st    =  (  fir_rx_cstate== FIR_RSQ_SEGMT_H_STATE   );
wire  fir_r_sqrcut_st    =  (  fir_rx_cstate== FIR_R_SQRCUT_STATE       );

wire  fir_r_sqrcut_end_st    =  (  fir_rx_cstate== FIR_R_SQRCUT_END_STATE       );

wire  fir_r_error_st         =  (  fir_rx_cstate== FIR_R_ERROR_STATE  )  ;

always@ ( * )
begin
  fir_rx_nstate = fir_rx_cstate;
  case(fir_rx_cstate)
  FIR_R_IDLE_STATE : begin  
      if (st_rx_start&&~tcp_sqmatch_flag&&st_rx_data_en)  begin
	     fir_rx_nstate =      FIR_R_CHECK_STATE ;
	  end
	  else if (st_rx_start&&tcp_sqmatch_flag) begin
	     fir_rx_nstate =  ( sub_sqcut_len_reg>16'd8 )  ?  FIR_R_SQRCUT_STATE   :  FIR_R_SQRCUT_END_STATE  ;
	  end
  end
  
  FIR_R_SQRCUT_STATE : begin
       if ( (st_shift_ccnt>=6'd8) &&  (sub_sqcut_len_reg<=16'd16) ) begin
          fir_rx_nstate  =   FIR_R_SQRCUT_END_STATE  ;   
       end
  end
  
  FIR_R_SQRCUT_END_STATE : begin
       if ( st_shift_ccnt>=sub_sqcut_len_reg[5:0]) begin
          fir_rx_nstate  =   ( st_rx_cnt_reg>(sub_sqcut_len_reg[5:0]+6'd8)  )  ?    FIR_R_VSYNC_STATE  :  FIR_R_RJUDGE_STATE  ;   
       end
  end
  
  FIR_R_VSYNC_STATE : begin
      if (st_shift_ccnt>=6'd8) begin
	      if  ( (st_rx_cnt_reg<(sync_len_byte+16'd4)) &&  (sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)  ) begin
                        if (  sq_frame_flag&&~sq_cut_on    )  begin
                             fir_rx_nstate = current_sqid_reg_flag  ?   (st_rx_cnt_reg<= (16'd8+16'd8) ) ?  FIR_RSQ_SEGMT_END_STATE  :   FIR_RSQ_SEGMT_STATE   :   FIR_R_IDLE_STATE  ;
                        end
                        else begin
                             fir_rx_nstate = FIR_R_IDLE_STATE ;
                        end
		  end
          else if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)) begin
                fir_rx_nstate  =   FIR_R_CHECK_STATE   ;                   
          end
          else begin
                fir_rx_nstate =  FIR_R_ERROR_STATE ;
          end
      end
  end
  //type_03e9_flag
  //type_1389_flag
  //params_03e9_type            ,
  //params_1389_type            ,
  //params_07d0_type            ,
  FIR_R_CHECK_STATE : begin
      if (st_shift_ccnt>=6'd6   ) begin
          //if (  ( (frame_type_byte==16'h1389) || (frame_type_byte==16'h03e9) )  &&(frame_sync_byte==32'h0000_5902)    ) begin  //
          if ( ( ((frame_type_byte==params_1389_type)&&type_1389_flag) ||  ( type_03e9_flag&&((frame_type_byte==params_03e9_type)||(frame_type_byte==params_07d0_type)) )  )     &&    (frame_sync_byte==32'h0000_5902)    ) begin 
                fir_rx_nstate =  FIR_R_ID_STATE    ; 
          end
          else begin
                fir_rx_nstate =  FIR_R_ERROR_STATE ;
          end
      end
  end 

  FIR_R_ID_STATE : begin
    if (  st_shift_ccnt>=6'd12  )  begin
//        if ( ((current_id_wire<=current_sqid_reg) )   ) begin
//             fir_rx_nstate  =    FIR_R_DISCARD_STATE   ;
//        end 
//        else if (patition_cnt_wire<=16'h0001)  begin
//             fir_rx_nstate  =    FIR_R_DISCARD_STATE   ;
//        end
//        else if (  ~frame_type_rdy   ) begin
//             fir_rx_nstate  =    FIR_R_DISCARD_STATE   ;             
//        end
//        else  begin
//             fir_rx_nstate  =      FIR_R_HEADER_STATE   ;
//        end
//

          if ( (patition_cnt_wire<=16'h0001)  ||  ~frame_type_rdy ) begin
               fir_rx_nstate  =    FIR_R_DISCARD_STATE   ;  
          end
//          else if (  (current_id_wire<=current_sqid_reg) &&  (  (current_id_wire[31])  || (~current_sqid_reg[31]) )   ) begin
          else if (  current_id_wire<=current_sqid_reg   ) begin
               fir_rx_nstate  =    FIR_R_DISCARD_STATE   ;
          end
          //else if (  (~current_sqid_reg[31]) && (current_id_wire[31])  ) begin
          //     fir_rx_nstate  =    FIR_R_DISCARD_STATE   ;  
          //end
          else begin
               fir_rx_nstate  =    FIR_R_HEADER_STATE    ;                                           
          end
 
    end 
  end
  
  
  FIR_R_DISCARD_STATE : begin
       if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
           if ( discard_calc_cnt1==4'd0 ) begin
               if (st_rx_cnt_reg==6'd16 )  begin
                   fir_rx_nstate = FIR_R_IDLE_STATE ;
               end
               else if (st_rx_cnt_reg<=(16'd16+16'd8)) begin
                   fir_rx_nstate =  ( (current_sqid_reg_flag&&sq_frame_flag)      ) ?  FIR_R_RJUDGE_STATE : FIR_R_IDLE_STATE ;                   
               end
               else if ( st_rx_cnt_reg<(16'd16+ segm_min_len   )  ) begin  //16'd81  the length of ( header + 2439 )
                   fir_rx_nstate =  ( (current_sqid_reg_flag&&sq_frame_flag)      ) ?  FIR_R_VSYNC_STATE : FIR_R_IDLE_STATE ;
               end
               else begin
                   fir_rx_nstate =  FIR_R_VSYNC_STATE ;
               end
           end
           else begin 
               fir_rx_nstate  =    FIR_R_DISEND_STATE  ;                
           end
       end
  end
  FIR_R_DISEND_STATE: begin
      if (  st_shift_ccnt>=discard_calc_cnt1    ) begin
           if (st_rx_cnt_reg==discard_calc_cnt1)  begin
                fir_rx_nstate  =     FIR_R_IDLE_STATE    ;                        
           end
           else if (st_rx_cnt_reg<=(discard_calc_cnt1+16'd8)) begin
                   fir_rx_nstate =  ( (current_sqid_reg_flag&&sq_frame_flag)      ) ?  FIR_R_RJUDGE_STATE : FIR_R_IDLE_STATE ;                   
           end
           else if ( st_rx_cnt_reg<( discard_calc_cnt1  +  segm_min_len )) begin
                fir_rx_nstate  =   ( (current_sqid_reg_flag&&sq_frame_flag)       ) ?  FIR_R_VSYNC_STATE :  FIR_R_IDLE_STATE    ;                                        
           end
           else begin
                fir_rx_nstate  =     FIR_R_VSYNC_STATE   ;                                        
           end
      end   
  end
 
  FIR_R_HEADER_STATE : begin
       if (  st_shift_ccnt>=6'd4 )begin
            fir_rx_nstate  =    FIR_R_RDATA0_STATE   ;
       end 
  end
  FIR_R_RDATA0_STATE : begin  
       if (  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1) )   )begin
            if (segm_cnt1_wire==4'd0)  begin
                  if (patition_cnt>=patition_cnt_reg) begin
					if (st_rx_cnt_reg>( 16'd16  +  16'd8 ) )
					  fir_rx_nstate  =    FIR_R_VSYNC_STATE  ;  
                                        else   
					  fir_rx_nstate  =    FIR_R_RJUDGE_STATE  ;  
                  end
                  else begin
                      fir_rx_nstate  =   FIR_R_HEADER_STATE    ; 
                  end
            end
            else begin
                  fir_rx_nstate  =   FIR_R_REND_STATE    ;                  
            end
       end 
  end
  FIR_R_REND_STATE : begin  
       if (  st_shift_ccnt>=segm_cnt1_wire)begin
            if (patition_cnt>=patition_cnt_reg) begin
				if (st_rx_cnt_reg>( segm_cnt1_wire  +  16'd8 ) )
					  fir_rx_nstate  =    FIR_R_VSYNC_STATE  ;  
                                else 
				          fir_rx_nstate  =    FIR_R_RJUDGE_STATE  ;  
            end
            else begin
                fir_rx_nstate  =  FIR_R_HEADER_STATE     ;                
            end 
       end 
  end
  
  
  FIR_R_RJUDGE_STATE : begin
      if  ( (st_rx_cnt_reg==16'd0)   ||   (sq_cut_on&&sq_frame_flag)   )  begin
	       fir_rx_nstate  =    FIR_R_IDLE_STATE     ; 
	   end
	   else   begin
	       fir_rx_nstate  =    sq_frame_flag  ?    FIR_RSQ_SEGMT_H_STATE   :    FIR_R_IDLE_STATE  ; 
	   end
  end
  
  FIR_RSQ_SEGMT_H_STATE : begin
        if ( st_shift_ccnt>=st_rx_cnt_reg )  begin
            fir_rx_nstate  =  FIR_R_IDLE_STATE     ;                
        end 
  end 
  
  FIR_RSQ_SEGMT_STATE : begin
		if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
		   fir_rx_nstate  =  FIR_RSQ_SEGMT_END_STATE     ;  
		end
  end
  FIR_RSQ_SEGMT_END_STATE : begin
     if (  st_shift_ccnt>=st_rx_cnt_reg ) begin
			    fir_rx_nstate  =  FIR_R_IDLE_STATE     ;  
     end
  end
  

   FIR_R_ERROR_STATE : begin
       fir_rx_nstate = FIR_R_IDLE_STATE ;
   end
	

  default : begin
      fir_rx_nstate = FIR_R_IDLE_STATE ;
  end
  endcase

end	


////////////////////////////////////////////////////////////////////////////////////////////////////////
//sq_frame_flag

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_frame_flag  <=  1'd0    ;
      frame_type_rdy <=  1'd0    ;
  end
  else if (st_rx_start) begin
      sq_frame_flag  <=  tcp_sqmatch_flag     ;
      frame_type_rdy <=  tcp_sqmatch_flag     ;
  end
  else if (  fir_r_check_st ) begin 
      //sq_frame_flag  <=   (frame_type_byte==16'h03e9)    ;   
      //sc_frame_flag  <=   (frame_type_byte==16'h1389)    ;
//	  sq_frame_flag  <=   (frame_type_byte==params_frame_type_byte)    ;
        sq_frame_flag  <=     ( ((frame_type_byte==params_1389_type)&&type_1389_flag) ||  ( type_03e9_flag&&((frame_type_byte==params_03e9_type)||(frame_type_byte==params_07d0_type)) )  )  ;
        frame_type_rdy <=   (frame_type_byte==params_frame_type_byte)    ;
  end
end

//sync_len_byte_reg
 always@ ( negedge rst_n  or posedge clk)
 begin
    if (~rst_n) begin
        sync_len_byte_reg  <=  16'd0    ;
    end
    else if ( (  fir_r_vsync_st )  &&  (st_shift_ccnt>=6'd8)  ) begin 
        sync_len_byte_reg  <=    sync_len_byte       ;
    end
 end
//sync_len_rest_reg 
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sync_len_rest_reg  <=  16'd0    ;
  end
  else if (st_rx_start&&~tcp_sqmatch_flag) begin
      sync_len_rest_reg  <=    first_sync_len_byte - 16'd22     ;
  end
  else if (  ( fir_r_vsync_st )   &&   (st_shift_ccnt>=6'd8)   ) begin 
      sync_len_rest_reg  <=    sync_len_byte - 16'd22     ;
  end
end


reg         first_sync_len_error    ; 
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      first_sync_len_error <= 1'd0 ;
  end
  else if (st_rx_start&&~tcp_sqmatch_flag) begin
      if (first_sync_len_byte==16'd0)  begin
          first_sync_len_error <= 1'd1 ;
          /* synthesis translate_off */
              $display("%m      first_sync_len_byte = %d   Error   !!!!!   \n   ",    first_sync_len_byte  );                       
          /* synthesis translate_on */
      end
      else   begin
           first_sync_len_error <= 1'd0 ;
      end
  end
  else begin
           first_sync_len_error <= 1'd0 ;    
  end
end




//fir_r_sqcut_st
//fir_r_sccut_st
//fir_r_sqcuth_st
//fir_r_sccuth_st

//st_rx_cnt_reg
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rx_cnt_reg  <=  16'd0    ;
  end
  else if (  st_rx_start  && ~tcp_sqmatch_flag   ) begin 
//	  st_rx_cnt_reg  <=    (tcp_payload_len -  st_rx_cnt - st_rx_offset )    ;
	  st_rx_cnt_reg  <=   (st_rx_cnt<=16'd8)   ?       (tcp_payload_len  - st_rx_offset )   :     (tcp_payload_len -  st_rx_cnt - st_rx_offset + 16'd8  )    ;          
  end
  else if (  st_rx_start  && tcp_sqmatch_flag  ) begin 
	  st_rx_cnt_reg  <=    (tcp_payload_len )    ;
  end

  else if ( fir_r_discard_st &&   (st_shift_ccnt>=16'd16)    )  begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd16   ;      
  end
  else if ( fir_r_disend_st && (   st_shift_ccnt>=discard_calc_cnt1    )   )  begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  discard_calc_cnt1   ;            
  end 
  else if (  fir_r_vsync_st  &&  (st_shift_ccnt>=16'd8) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd8   ;
  end
  else if (fir_r_check_st  &&  (st_shift_ccnt>=16'd6)  ) begin   
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd6   ;
  end
  else if (fir_r_id_st &&  (st_shift_ccnt>=16'd12)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd12   ;
  end
  else if (fir_r_header_st &&  (st_shift_ccnt>=16'd4) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd4   ;
  end
  else if ( fir_r_rdata0_st &&  (st_shift_ccnt>=6'd16)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd16   ;      
  end
  else if (fir_r_rend_st &&  (st_shift_ccnt>=segm_cnt1_wire)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  segm_cnt1_wire   ;            
  end
  else if ( fir_r_sqcut_st   && (st_shift_ccnt>=6'd8) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd8   ;   
  end
  else if ( fir_r_sqcut_end_st   && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  st_rx_cnt_reg   ;   
  end
  else if ( (fir_r_sqcuth_st )  && (st_shift_ccnt>=st_rx_cnt_reg)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  st_rx_cnt_reg   ;   
  end
  
  else if ((fir_r_sqrcut_st) &&  (st_shift_ccnt>=16'd8)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd8    ;  
  end
  else if ((fir_r_sqrcut_end_st) &&  (st_shift_ccnt>=sub_sqcut_len_reg)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  sub_sqcut_len_reg    ;  
  end
  
end

////////////////////////////////////////////////////////////////////////////////////////////////////
//discard_ddiscard_data_cntata_cnt
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      discard_data_cnt  <=  12'd0    ;
  end
  else if ( fir_r_discard_st||fir_r_rdata0_st  ) begin 
      discard_data_cnt  <=   (st_shift_ccnt>=6'd16)  ?     discard_data_cnt + 1'd1 :  discard_data_cnt    ;
  end
  else  begin
      discard_data_cnt  <=  12'd0    ;     
  end
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////segm_len


reg      segm_type_2439  ;
reg      segm_type_2433  ;
reg      segm_type_2434  ;


reg      segm_type_2433_flag  ;
reg      segm_type_2434_flag  ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      segm_len   <=  16'd0    ;
      segm_type  <=  16'd0    ;
      segm_type_2439 <=  1'd0    ;
      segm_type_2433 <=  1'd0    ;
      segm_type_2434 <=  1'd0    ;
  end
  else if ( fir_r_header_st  &&  (st_shift_ccnt>=6'd4)  ) begin 
      segm_len   <=   segm_len_wire   ;
      segm_type  <=   segm_type_wire  ;  
      segm_type_2439 <=  (segm_type_wire==16'h2439)    ;
      segm_type_2433 <=  (segm_type_wire==16'h2433)    ;
      segm_type_2434 <=  (segm_type_wire==16'h2434)    ;       
  end
end


//fir_r_id_st
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      segm_type_2433_flag <=  1'd0    ;
      segm_type_2434_flag <=  1'd0    ;
  end
  else if (fir_r_id_st) begin 
      segm_type_2433_flag <=  1'd0    ;
      segm_type_2434_flag <=  1'd0    ;
  end
  else if ( fir_r_header_st  &&  (st_shift_ccnt>=6'd4)  ) begin 
      segm_type_2433_flag <=  (segm_type_wire==16'h2433)   ?   1'd1  :   segm_type_2433_flag  ;
      segm_type_2434_flag <=  (segm_type_wire==16'h2434)   ?   1'd1  :   segm_type_2434_flag ;       
  end
end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//reg       [15:0]    patition_cnt_reg  ;
//reg       [15:0]    patition_len_reg  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      patition_cnt_reg   <=  16'd0    ;
      patition_len_reg   <=  16'd0    ;
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  ) begin 
      patition_cnt_reg   <=   patition_cnt_wire   ;
      patition_len_reg   <=   patition_len_wire   ;      
  end
end
//patition_cnt
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      patition_cnt       <=  16'd0    ;
  end
  else if (fir_r_id_st) begin
      patition_cnt       <=  16'd0    ;
  end
  else if ( fir_r_header_st  &&  (st_shift_ccnt>=6'd4 )  ) begin 
      patition_cnt    <=   patition_cnt + 1'd1  ;      
  end
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//reg      [  5:0]           st_shift_scnt      ;
//reg                        st_shift_en        ; 


//wire  fir_r_idle_st      =  (  fir_rx_cstate== FIR_R_IDLE_STATE        );    
//wire  fir_r_sync_st      =  (  fir_rx_cstate== FIR_R_SYNC_STATE        );    
//wire  fir_r_check_st     =  (  fir_rx_cstate== FIR_R_CHECK_STATE       );    
//wire  fir_r_id_st        =  (  fir_rx_cstate== FIR_R_ID_STATE          );    
//wire  fir_r_header_st    =  (  fir_rx_cstate== FIR_R_HEADER_STATE      );    
//wire  fir_r_rdata0_st    =  (  fir_rx_cstate== FIR_R_RDATA0_STATE      );       
//wire  fir_r_rdata1_st    =  (  fir_rx_cstate== FIR_R_RDATA1_STATE      );       
//wire  fir_r_rdata2_st    =  (  fir_rx_cstate== FIR_R_RDATA2_STATE      );       
//wire  fir_r_rdata3_st    =  (  fir_rx_cstate== FIR_R_RDATA3_STATE      );       
//wire  fir_r_rend_st      =  (  fir_rx_cstate== FIR_R_REND_STATE        );       
//wire  fir_r_discard_st   =  (  fir_rx_cstate== FIR_R_DISCARD_STATE     );       
//wire  fir_r_disend_st    =  (  fir_rx_cstate== FIR_R_DISEND_STATE      );       

always@ ( negedge rst_n  or posedge clk)
begin
  if  (~rst_n) begin
       st_shift_scnt  <= 6'd0  ;
       st_shift_en    <= 1'd0  ;
  end
  //else if  ( fir_r_check_st &&  (st_shift_ccnt>=6'd6) )  begin
  else if (st_rx_start&&~tcp_sqmatch_flag && st_rx_data_en) begin  
       st_shift_scnt  <= (st_rx_offset<=3'd2) ?  6'd6  :  6'd0  ;
       st_shift_en    <= (st_rx_offset<=3'd2) ?  1'd1  :  1'd0  ;
  end
  else if (st_rx_start&&tcp_sqmatch_flag && st_rx_data_en) begin
	   st_shift_scnt  <= (sub_sqcut_len_reg>16'd8)  ? ( (st_rx_offset==3'd0) ?   6'd8 : 6'd0 ) :   ((sub_sqcut_len_reg[3:0]+st_rx_offset)>4'd8) ?  6'd0 : sub_sqcut_len_reg[3:0]   ;
       st_shift_en    <= (sub_sqcut_len_reg>16'd8)  ? ( (st_rx_offset==3'd0) ?   1'd1 : 1'd0 ) :   ((sub_sqcut_len_reg[3:0]+st_rx_offset)>4'd8) ?  1'd0 : 1'd1                     ;
  end
  
  else if (fir_r_sqrcut_st) begin
      if  ( (st_shift_ccnt>=6'd8) &&  (sub_sqcut_len_reg<=16'd16)  )  begin
          st_shift_scnt  <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sqcut_len_reg[5:0])))  ? sub_sqcut_len_reg[5:0] - 6'd8  : 6'd0 ;
          st_shift_en    <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sqcut_len_reg[5:0])))  ? 1'd1   :  1'd0;
      end
      else if (st_rx_data_en ) begin
	      st_shift_scnt  <= 6'd8  ;
              st_shift_en    <= 1'd1  ;
	  end
	  else begin
	      st_shift_scnt  <= 6'd0  ;
              st_shift_en    <= 1'd0  ;
	  end
  end
  else if (fir_r_sqrcut_end_st &&   ( st_shift_ccnt>=sub_sqcut_len_reg[5:0] ) ) begin
	  st_shift_scnt  <= ((st_rx_data_en ||  (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8)))&&(st_rx_cnt_reg>(sub_sqcut_len_reg[5:0]+6'd8)))  ?  6'd8   :  6'd0  ;
          st_shift_en    <= ((st_rx_data_en ||  (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8)))&&(st_rx_cnt_reg>(sub_sqcut_len_reg[5:0]+6'd8)))  ?  1'd1   :  1'd0  ;
  end
  else if (fir_r_sqrcut_end_st &&  st_rx_data_en        ) begin
	  st_shift_scnt  <=    sub_sqcut_len_reg[5:0]    ;
          st_shift_en    <=   1'd1     ;
  end
  
  else if (fir_r_vsync_st ) begin
      if (st_shift_ccnt>=6'd8) begin
	  if ( st_rx_cnt_reg<(sync_len_byte+16'd4  )  ) begin
                if (  (sq_frame_flag&&current_sqid_reg_flag&&~sq_cut_on  )      &&(st_rx_cnt_reg<=(16'd8+16'd8) ))  begin 
                     st_shift_scnt  <= ((st_shift_ccnt>=st_rx_cnt_reg[5:0])||st_rx_data_en) ? (st_rx_cnt_reg[5:0]-6'd8) : 6'd0  ;
                     st_shift_en    <= ((st_shift_ccnt>=st_rx_cnt_reg[5:0])||st_rx_data_en) ? 1'd1 : 1'd0  ;
                end
                else begin
	   	           st_shift_scnt  <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 6'd8 : 6'd0  ;
                   st_shift_en    <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 1'd1 : 1'd0  ;
                end
          end
          else if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)  ) begin  //check
                st_shift_scnt  <= ((st_shift_ccnt>=6'd14)||st_rx_data_en) ?  6'd6 : 6'd0 ;
                st_shift_en    <= ((st_shift_ccnt>=6'd14)||st_rx_data_en) ?  1'd1 : 1'd0 ;              
          end
          else begin
                st_shift_scnt  <= 6'd0  ;
                st_shift_en    <= 1'd0  ;
          end
      end
	  else if (st_rx_data_en) begin
	     st_shift_scnt  <= 6'd8  ;
         st_shift_en    <= 1'd1  ;
	  end
	  else begin
	     st_shift_scnt  <= 6'd0  ;
         st_shift_en    <= 1'd0  ;
	  end
  end
  
  else if (fir_r_check_st)  begin
      if (st_shift_ccnt>=6'd6   ) begin
         st_shift_scnt  <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&(st_shift_ccnt>=6'd10))) ?    6'd12   :  6'd0  ;
         st_shift_en    <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&(st_shift_ccnt>=6'd10))) ?     1'd1   :  1'd0  ; 
      end
	  else if (st_rx_data_en) begin
	     st_shift_scnt  <= 6'd6  ;
             st_shift_en    <= 1'd1  ;
	  end
	  else begin
	      st_shift_scnt  <= 6'd0  ;
          st_shift_en    <= 1'd0  ;
	  end
  end
  
  else if (fir_r_id_st) begin
    if (  st_shift_ccnt>=6'd12  )  begin
        //if ( ((current_id_wire<=current_sqid_reg) )  ||   (patition_cnt_wire<=16'h0001)  ||  ~frame_type_rdy  ) begin
        //    st_shift_scnt  <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ?    6'd16   :  6'd0  ;
        //    st_shift_en    <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ?     1'd1   :  1'd0  ; 
        //end 
        //else  begin
        //    st_shift_scnt  <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ?     6'd4   :  6'd0  ;
        //    st_shift_en    <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ?     1'd1   :  1'd0  ; 
        //end
       
        //if ( ((current_id_wire<=current_sqid_reg)  &&  (  (current_id_wire[31])  || (~current_sqid_reg[31]) )  )  ||  (  (~current_sqid_reg[31]) && (current_id_wire[31])  )    ||   (patition_cnt_wire<=16'h0001)  ||  ~frame_type_rdy  ) begin
        if ( (current_id_wire<=current_sqid_reg)  ||   (patition_cnt_wire<=16'h0001)  ||  ~frame_type_rdy  ) begin

            st_shift_scnt  <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ?    6'd16   :  6'd0  ;
            st_shift_en    <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ?     1'd1   :  1'd0  ; 
        end 
        else  begin
            st_shift_scnt  <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ?     6'd4   :  6'd0  ;
            st_shift_en    <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ?     1'd1   :  1'd0  ; 
        end
 
    end 
	else if (st_rx_data_en&&(st_shift_ccnt>=6'd4)) begin
	    st_shift_scnt  <= 6'd12  ;
        st_shift_en    <= 1'd1  ;
	end
    else begin
	    st_shift_scnt  <= 6'd0  ;
        st_shift_en    <= 1'd0  ;
    end
  end
  
  else if (  fir_r_discard_st ) begin
        if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
           if ( discard_calc_cnt1==4'd0 ) begin
                if (st_rx_cnt_reg<=(16'd16+16'd8))  begin
                    st_shift_scnt  <= 6'd0  ;
                    st_shift_en    <= 1'd0  ;
                end
                else begin
                   st_shift_scnt  <= ((st_shift_ccnt>=6'd24)|| st_rx_data_en ) ?     6'd8   :  6'd0  ;
                   st_shift_en    <= ((st_shift_ccnt>=6'd24)|| st_rx_data_en ) ?     1'd1   :  1'd0  ; 
                end
           end
           else begin 
               st_shift_scnt  <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ?     discard_calc_cnt1   :  6'd0  ;
               st_shift_en    <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ?     1'd1   :  1'd0  ;        
           end
        end
	    else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
	        st_shift_scnt  <= st_shift_en ?  6'd0 :  6'd16   ;
                st_shift_en    <= st_shift_en ?  1'd0 :  1'd1   ;
	    end
	    else  begin
		    st_shift_scnt  <= 6'd0  ;
            st_shift_en    <= 1'd0  ;
		end
  end
  
  else if (fir_r_disend_st) begin
        if (  st_shift_ccnt>=discard_calc_cnt1    ) begin
            if (st_rx_cnt_reg<=( discard_calc_cnt1 +16'd8))  begin  //judge
                   st_shift_scnt  <=   6'd0  ;
                   st_shift_en    <=   1'd0  ;   
            end
            else begin        //vsync          
                st_shift_scnt  <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))|| st_rx_data_en ) ?     6'd8   :  6'd0  ;
               st_shift_en     <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))|| st_rx_data_en ) ?     1'd1   :  1'd0  ;        
            end
        end   
		else if (st_rx_data_en  &&  ( (st_shift_ccnt+6'd8)>= discard_calc_cnt1 )    ) begin
		    st_shift_scnt  <= discard_calc_cnt1  ;
                    st_shift_en    <= 1'd1  ;
		end
		else begin
		    st_shift_scnt  <= 6'd0  ;
            st_shift_en    <= 1'd0  ;
		end
  end
  
  else if (fir_r_header_st) begin
       if (  st_shift_ccnt>=6'd4 )begin
            st_shift_scnt  <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&&(st_shift_ccnt>=6'd12))) ?     6'd16   :  6'd0  ;
            st_shift_en    <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&&(st_shift_ccnt>=6'd12))) ?     1'd1    :  1'd0  ; 
       end 
       else if ( st_rx_data_en   ) begin
            st_shift_scnt  <= 6'd4  ;
            st_shift_en    <= 1'd1  ;
       end
	   else begin
              st_shift_scnt  <= 6'd0  ;
              st_shift_en    <= 1'd0  ;
	   end
  end
  
  else if (fir_r_rdata0_st) begin
       if (  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1) )   )begin
            if (segm_cnt1_wire==4'd0)  begin
                  if (patition_cnt<patition_cnt_reg) begin
                      st_shift_scnt  <= ((st_shift_ccnt>=6'd20)||st_rx_data_en) ?     6'd4    :  6'd0  ;
                      st_shift_en    <= ((st_shift_ccnt>=6'd20)||st_rx_data_en) ?     1'd1    :  1'd0  ; 
                  end
                  else if (  st_rx_cnt_reg>( 16'd16  +  16'd8 )     ) begin
                      st_shift_scnt  <= ((st_shift_ccnt>=6'd24)||st_rx_data_en) ?     6'd8    :  6'd0  ;
                      st_shift_en    <= ((st_shift_ccnt>=6'd24)||st_rx_data_en) ?     1'd1    :  1'd0  ; 
                  end
				  else begin
				      st_shift_scnt  <= 6'd0  ;
                      st_shift_en    <= 1'd0  ;
				  end
            end
            else begin
                  if  (st_shift_ccnt>=(6'd16+segm_cnt1_wire))  begin 
                          st_shift_scnt <= segm_cnt1_wire ;
                          st_shift_en   <= 1'd1           ;
                  end  
                  else if (st_rx_data_en  && ((st_shift_ccnt-6'd8 )>= segm_cnt1_wire)  ) begin
                          st_shift_scnt <= segm_cnt1_wire ;
                          st_shift_en   <= 1'd1           ;
                  end
                  else begin
                         st_shift_scnt <= 6'd0           ;
                         st_shift_en   <= 1'd0           ;
                  end

            end
	   end
	   else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
	       st_shift_scnt  <= st_shift_en  ?   6'd0  : 6'd16  ;
               st_shift_en    <= st_shift_en  ?   1'd0  : 1'd1   ;
	   end
	   else  begin
	        st_shift_scnt  <= 6'd0  ;
                st_shift_en    <= 1'd0  ;
	   end
  end
 

  else if ( fir_r_rend_st   ) begin
       if (  st_shift_ccnt>=segm_cnt1_wire)begin
            if (patition_cnt>=patition_cnt_reg) begin

                if (  st_rx_cnt_reg>( segm_cnt1_wire  +  16'd8 )     ) begin
                      st_shift_scnt  <= ((st_shift_ccnt>=(segm_cnt1_wire+16'd8) )||st_rx_data_en) ?     6'd8    :  6'd0  ;
                      st_shift_en    <= ((st_shift_ccnt>=(segm_cnt1_wire+16'd8) )||st_rx_data_en) ?     1'd1    :  1'd0  ; 
                end
                else begin
                   st_shift_scnt  <= 6'd0  ;
                   st_shift_en    <= 1'd0  ;
                end
            end
            else   begin
                st_shift_scnt  <= ((st_shift_ccnt>=(6'd4+segm_cnt1_wire))||st_rx_data_en) ?     6'd4             :  6'd0  ;
                st_shift_en    <= ((st_shift_ccnt>=(6'd4+segm_cnt1_wire))||st_rx_data_en) ?     1'd1             :  1'd0  ;                  
            end 
       end
       else if ( st_rx_data_en&&  ( (st_shift_ccnt+6'd8) >=  segm_cnt1_wire )  )  begin 
           st_shift_scnt  <= segm_cnt1_wire  ;
           st_shift_en    <= 1'd1  ;
       end
       else begin
           st_shift_scnt  <= 6'd0  ;
           st_shift_en    <= 1'd0  ;
       end 
  end
   
  else if (fir_r_rjudge_st)  begin
      // if ( (st_rx_cnt_reg==16'd0)  ||   (sq_cut_on&&sq_frame_flag)   )  begin
      //         st_shift_scnt  <= 6'd0  ;
      //     st_shift_en    <= 1'd0  ;
      //     end
      //     else if (st_rx_cnt_reg<=16'd8)  begin
      //         //st_shift_scnt  <= ((st_shift_ccnt>=st_rx_cnt_reg[5:0])||st_rx_data_en) ?  st_rx_cnt_reg[5:0]  :  6'd0 ;
      //         //st_shift_en    <= ((st_shift_ccnt>=st_rx_cnt_reg[5:0])||st_rx_data_en) ?  1'd1                :  1'd0 ;
      //         st_shift_scnt  <=   6'd0 ;
      //         st_shift_en    <=   1'd0 ;
      //     end
      //else begin
      //         st_shift_scnt  <= ((st_shift_ccnt>=6'd8)||st_rx_data_en) ?     6'd8   :  6'd0  ;
      //         st_shift_en    <= ((st_shift_ccnt>=6'd8)||st_rx_data_en) ?     1'd1   :  1'd0  ;     
      //end

       st_shift_scnt  <=   6'd0 ;
       st_shift_en    <=   1'd0 ;

  end
  
  else if ( fir_r_sqcut_st ) begin
    if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
	   st_shift_scnt  <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ?     (st_rx_cnt_reg[5:0]-6'd8)   :  6'd0  ;
           st_shift_en    <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ?     1'd1                        :  1'd0  ;    
    end
	else if (st_rx_data_en) begin
	       st_shift_scnt  <= 6'd8  ;
               st_shift_en    <= 1'd1   ;
	end
	else if ((st_shift_ccnt>=6'd16)&&st_shift_en) begin
	    st_shift_scnt  <= 6'd8  ;
               st_shift_en    <= 1'd1   ;
	end
	else begin
           st_shift_scnt  <= 6'd0  ;
           st_shift_en    <= 1'd0  ;
    end
  end

  else begin
      st_shift_scnt  <= 6'd0  ;
      st_shift_en    <= 1'd0  ;
  end
  
end



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire      [ 23: 0]       market_explain ; //市场说明 3
wire      [  7: 0]       info_classify  ; //信息分类 1
reg       [ 31: 0]       dialog_num     ; //会话编号 4
wire      [  7: 0]       contract_flag  ; //合约标志 1
wire      [ 31: 0]       contract_num   ; //合约编号 4
reg       [175: 0]       contract_code  ; //合约代码 22
reg       [ 71: 0]       update_time    ; //更新时间 9
reg       [ 31: 0]       update_ms      ; //更新毫秒 4
reg       [ 63: 0]       new_price      ; //�?新价 8
reg       [ 31: 0]       turnover       ; //成交�? 4
reg       [ 63: 0]       volume         ; //成交�? 8   
reg       [ 63: 0]       position       ; //持仓�? 8
reg       [ 63: 0]       purchase_price ; //申买�? 8
reg       [ 31: 0]       buy_quantity   ; //申买�? 4
reg       [ 63: 0]       sell_price     ; //申买�? 8
reg       [ 31: 0]       sell_quantity  ; //申卖�? 4
reg                      market_rdy     ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      dialog_num   <=  32'd0    ;
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  ) begin 
      dialog_num   <=   {current_id_wire[7:0],current_id_wire[15:8],current_id_wire[23:16],current_id_wire[31:24]}   ;
  end
end


wire   [127: 0]  contract_code0      = st_shift_reg[127+64:   64]    ;  //16---128

wire   [ 47: 0]  contract_code1      = st_shift_reg[127+64:80+64]    ;  // 6--- 48
wire   [ 71: 0]  contract_code2      = st_shift_reg[ 79+64: 8+64]    ;  // 9--- 72
wire   [  7: 0]  update_time_wire1   = st_shift_reg[  7+64:   64]    ;  // 1---  8


wire   [ 63: 0]  update_time_wire2   = st_shift_reg[127+64:64+64]    ;  // 8--- 64
wire   [ 31: 0]  update_ms_wire      = st_shift_reg[ 63+64:32+64]    ;  // 4--- 32
 
wire   [ 63: 0]  new_price_wire      = st_shift_reg[127+64: 64+64]     ;
wire   [ 31: 0]  turnover_wire       = st_shift_reg[ 63+64: 32+64]     ;
wire   [ 31: 0]  volume0             = st_shift_reg[ 31+64:    64]     ;

wire   [ 31: 0]  volume1             = st_shift_reg[127+64: 96+64]     ;
wire   [ 63: 0]  position_wire       = st_shift_reg[ 95+64: 32+64]     ;


wire   [ 63: 0]  purchase_price_wire = st_shift_reg[127+64: 64+64]     ;
wire   [ 31: 0]  buy_quantity_wire   = st_shift_reg[ 63+64: 32+64]     ;
wire   [ 31: 0]  sell_price0         = st_shift_reg[ 31+64:    64]     ;

wire   [ 31: 0]  sell_price1         = st_shift_reg[127+64: 96+64]     ;
wire   [ 31: 0]  sell_quantity_wire  = st_shift_reg[ 95+64: 64+64]     ;


////market_explain
//always@ ( negedge rst_n  or posedge clk)
//begin
//  if (~rst_n) begin
//      market_explain   <=  24'd0    ;
//  end
//  else begin
//      market_explain   <=  {8'h53,8'h51,8'h00}   ;  //SQ	
//  end
//end

assign  market_explain =  {8'h53,8'h51,8'h00}   ; 

//info_classify
assign   info_classify =  8'h31 ;
assign   contract_flag =  8'h30 ;
assign   contract_num  = 32'd0 ;


//fir_r_rdata0_st
//segm_type  2439 
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      contract_code   <=  176'd0    ;
  end
  else if (fir_r_id_st) begin
       contract_code   <=  176'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==12'd0)  ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2439) && (discard_data_cnt==12'd0)  ) begin 
      contract_code[175:48]   <=   contract_code0   ;  //16
  end
  //else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==12'd1)   ) begin 
  else if ( fir_r_rdata0_st   && (segm_type_2439) && (discard_data_cnt==12'd1)   ) begin 
      contract_code[47: 0]   <=   contract_code1   ;   //6
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      update_time   <=  72'd0    ;
  end
  else if (fir_r_id_st) begin
       update_time   <=  72'd0    ;
  end
  //else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==12'd1)   ) begin
  else if ( fir_r_rdata0_st  && (segm_type_2439) && (discard_data_cnt==12'd1)   ) begin  
      update_time[71:64]   <=   update_time_wire1   ;   //1
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==12'd2)   ) begin
  else if ( fir_r_rdata0_st  && (segm_type_2439) && (discard_data_cnt==12'd2)   ) begin 
      update_time[63: 0]   <=   update_time_wire2   ;   //8
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      update_ms   <=  32'd0    ;
  end
  else if (fir_r_id_st) begin
       update_ms   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==12'd2)   ) begin
  else if ( fir_r_rdata0_st  && (segm_type_2439) && (discard_data_cnt==12'd2)   ) begin  
      //update_ms[31: 0]   <=   update_ms_wire   ;   //4
      update_ms[31: 0]   <=   {update_ms_wire[7:0],update_ms_wire[15:8],update_ms_wire[23:16],update_ms_wire[31:24]}   ;   //4
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      new_price   <=  64'd0    ;
  end
  else if (fir_r_id_st ||   (&new_price[63:0])  ) begin
       new_price   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2433) && (discard_data_cnt==12'd0)   ) begin
  else if ( fir_r_rdata0_st  && (segm_type_2433) && (discard_data_cnt==12'd0)   ) begin 
//      new_price[63: 0]   <=   new_price_wire   ;   //8
      new_price[63: 0]   <=   {new_price_wire[7:0],new_price_wire[15:8],new_price_wire[23:16],new_price_wire[31:24],new_price_wire[39:32],new_price_wire[47:40],new_price_wire[55:48],new_price_wire[63:56]}   ;   //8      
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      turnover   <=  32'd0    ;
  end
  else if (fir_r_id_st) begin
       turnover   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2433) && (discard_data_cnt==12'd0)   ) begin
  else if ( fir_r_rdata0_st  && (segm_type_2433) && (discard_data_cnt==12'd0)   ) begin  
      //turnover[31: 0]   <=   turnover_wire   ;   //4
      turnover[31: 0]   <=   { turnover_wire[7:0],turnover_wire[15:8],turnover_wire[23:16],turnover_wire[31:24]    }    ;   //4
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      volume   <=  64'd0    ;
  end
  else if (fir_r_id_st  ||  (&volume[63:0])  ) begin
       volume   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2433) && (discard_data_cnt==12'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2433) && (discard_data_cnt==12'd0)   ) begin  
      //volume[63: 32]   <=   volume0   ;   //4
      volume[31:  0]   <=   { volume0[7:0],volume0[15:8],volume0[23:16],volume0[31:24]    }    ;   //4      
  end
  //else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd4 )  && (segm_type_2433)   ) begin
  else if ( fir_r_rend_st    && (segm_type_2433)   ) begin  
      //volume[31: 0]   <=   volume1   ;   //4
      volume[63: 32]   <=   { volume1[7:0],volume1[15:8],volume1[23:16],volume1[31:24]    }    ;   //4            
  end
end
//position
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      position   <=  64'd0    ;
  end
  else if (fir_r_id_st  ||  (&position[63:0])   ) begin
       position   <=  'd0    ;
  end
//  else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd4 )  && (segm_type_2433)   ) begin
  else if ( fir_r_rend_st  &&   (segm_type_2433)   ) begin  
//       position[63: 0]   <=   position_wire   ;   //8
//       position[63: 0]   <=     {[7:0],[15:8],[23:16],[31:24],[39:32],[47:40],[55:48],[63:56]}   ;   //8      
       position[63: 0]   <=     {position_wire[7:0],position_wire[15:8],position_wire[23:16],position_wire[31:24],position_wire[39:32],position_wire[47:40],position_wire[55:48],position_wire[63:56]}   ;   //8              
  end
end


//purchase_price
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      purchase_price   <=  64'd0    ;
  end
  else if (fir_r_id_st  ||  (&purchase_price[63:0])  ) begin
       purchase_price   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2434) && (discard_data_cnt==12'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2434) && (discard_data_cnt==12'd0)   ) begin  
  //    purchase_price[63:  0]   <=   purchase_price_wire   ;   //8
       purchase_price[63: 0]   <=     {purchase_price_wire[7:0],purchase_price_wire[15:8],purchase_price_wire[23:16],purchase_price_wire[31:24],purchase_price_wire[39:32],purchase_price_wire[47:40],purchase_price_wire[55:48],purchase_price_wire[63:56]}   ;   //8            
  end
end
//buy_quantity
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      buy_quantity   <=  32'd0    ;
  end
  else if (fir_r_id_st) begin
       buy_quantity   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2434) && (discard_data_cnt==12'd0)   ) begin
  else if ( fir_r_rdata0_st  &&  (segm_type_2434) && (discard_data_cnt==12'd0)   ) begin  
      //buy_quantity[31:  0]   <=   buy_quantity_wire   ;   //4
      buy_quantity[31:  0]   <=     {buy_quantity_wire[7:0],buy_quantity_wire[15:8],buy_quantity_wire[23:16],buy_quantity_wire[31:24]}    ;   //4
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sell_price   <=  64'd0    ;
  end
//  else if (fir_r_id_st ||  (&sell_price[63:0])  ) begin
  else if (fir_r_id_st   ) begin
       sell_price   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2434) && (discard_data_cnt==12'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2434) && (discard_data_cnt==12'd0)   ) begin 
     //sell_price[63: 32]   <=   sell_price0   ;   //4
     sell_price[31: 0]   <=    {sell_price0[7:0],sell_price0[15:8],sell_price0[23:16],sell_price0[31:24] }  ;     
  end
//  else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd8 )  && (segm_type_2434)   ) begin
  else if ( fir_r_rend_st  &&  (segm_type_2434)   ) begin 
   //   sell_price[63:  0]   <=   ((&sell_price[63: 32])&&(&sell_price1[31:0]))   ?    64'd0  :    {  sell_price[63:32] ,sell_price1 }  ;   //4
      sell_price[63:  0]   <=   ((&sell_price[31: 0])&&(&sell_price1[31:0]))   ?    64'd0  :    {   {sell_price1[7:0],sell_price1[15:8],sell_price1[23:16],sell_price1[31:24] }      ,  sell_price[31:0]  }  ;   //4           
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sell_quantity   <=  32'd0    ;
  end
  else if (fir_r_id_st) begin
       sell_quantity   <=  'd0    ;
  end
//  else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd8 )  && (segm_type_2434)   ) begin
  else if ( fir_r_rend_st  &&  (segm_type_2434)   ) begin  
      //sell_quantity[31:  0]   <=   sell_quantity_wire   ;   //4
      sell_quantity[31:  0]   <=    {sell_quantity_wire[7:0],sell_quantity_wire[15:8],sell_quantity_wire[23:16],sell_quantity_wire[31:24]}   ;   //4
  end
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//current_sqid_reg


//current_cut_done_sqid_reg
//always@ (  *  )
reg     current_sqcut_done_dly  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_cut_done_sqid_reg   <=  32'd0    ;
		current_sqcut_done_dly      <=   1'd0    ;
  end
  //else if (  fir_r_sqrcut_end_st   ) begin 
      //case (tcp_sqmatch_flag_reg)
  else begin
	  case (sq_market_rdy)
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
          default :      current_cut_done_sqid_reg   <=   current_cut_done_sqid_reg    ;
      endcase	
	    //current_sqcut_done_dly      <=   |tcp_sqmatch_flag_reg    ;
		current_sqcut_done_dly      <=   |sq_market_rdy    ;
    end		
	// else begin
	//      current_sqcut_done_dly      <=   1'd0    ;
	// end
end


//current_cut_now_sqid_reg_vld
reg             current_cut_now_sqid_reg_vld_dly  ;
reg     [31:0]  current_cut_done_sqid_reg_dly     ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
        current_cut_done_sqid_reg_dly   <=  32'd0    ;
		current_cut_now_sqid_reg_vld_dly      <=   1'd0    ;
  end
  //else if (  fir_r_sqrcut_end_st   ) begin 
      //case (tcp_sqmatch_flag_reg)
  else begin
	  case (current_cut_now_sqid_reg_vld)
	  32'h0000_0001: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq00id_reg) ;
	  32'h0000_0002: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq01id_reg) ;
	  32'h0000_0004: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq02id_reg) ;
	  32'h0000_0008: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq03id_reg) ;
	  32'h0000_0010: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq04id_reg) ;
	  32'h0000_0020: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq05id_reg) ;
	  32'h0000_0040: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq06id_reg) ;
	  32'h0000_0080: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq07id_reg) ;
	  32'h0000_0100: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq08id_reg) ;
	  32'h0000_0200: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq09id_reg) ;
	  32'h0000_0400: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq10id_reg) ;
	  32'h0000_0800: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq11id_reg) ;
	  32'h0000_1000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq12id_reg) ;
	  32'h0000_2000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq13id_reg) ;
	  32'h0000_4000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq14id_reg) ;
	  32'h0000_8000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq15id_reg) ;
	  32'h0001_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq16id_reg) ;
	  32'h0002_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq17id_reg) ;
	  32'h0004_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq18id_reg) ;
	  32'h0008_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq19id_reg) ;
	  32'h0010_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq20id_reg) ;
	  32'h0020_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq21id_reg) ;
	  32'h0040_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq22id_reg) ;
	  32'h0080_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq23id_reg) ;
	  32'h0100_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq24id_reg) ;
	  32'h0200_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq25id_reg) ;
	  32'h0400_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq26id_reg) ;
	  32'h0800_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq27id_reg) ;
	  32'h1000_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq28id_reg) ;
	  32'h2000_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq29id_reg) ;
	  32'h4000_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq30id_reg) ;
	  32'h8000_0000: current_cut_done_sqid_reg_dly   <=   (current_cut_done_sq31id_reg) ;
          default :  current_cut_done_sqid_reg_dly   <=   current_cut_done_sqid_reg_dly    ;
      endcase	
	    //current_sqcut_done_dly      <=   |tcp_sqmatch_flag_reg    ;
		current_cut_now_sqid_reg_vld_dly      <=   |current_cut_now_sqid_reg_vld    ;
    end		
	// else begin
	//      current_sqcut_done_dly      <=   1'd0    ;
	// end
end





reg      current_sqid_error  ;
//reg     [ 3:0]   current_sqid_reg_cnt  ;  
reg   [3:0]   current_sqid_reg_max_cnt   ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg       <=  32'd0    ;
      current_sqid_reg_vld   <=   1'd0    ;
  //    current_sqid_reg_cnt   <=   4'd0    ;
	  current_sqid_error     <=   1'd0    ; 
  end
  
  else if (params_filter_rst || current_sqid_reg_rst ) begin
      current_sqid_reg       <=  32'd0    ;
      current_sqid_reg_vld   <=   1'd0    ;
    //  current_sqid_reg_cnt   <=   4'd0    ;
	  current_sqid_error     <=   1'd0    ; 
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  &&  frame_type_rdy && sq_frame_flag ) begin 
          //if (  (current_id_wire<=current_sqid_reg) &&  (  (current_id_wire[31])  || (~current_sqid_reg[31]) )   ) begin
          if (  current_id_wire<=current_sqid_reg  ) begin
               current_sqid_reg_vld   <=   1'd0    ;  
               //current_sqid_reg_cnt   <=   4'd0    ;   
               current_sqid_error     <=   1'd0    ; 			   
          end
          //else if (  (~current_sqid_reg[31]) && (current_id_wire[31])  ) begin
          //     current_sqid_reg_vld   <=   1'd0    ;    
          //     //current_sqid_reg_cnt   <=   4'd0    ;    
          //     current_sqid_error     <=   1'd0    ; 			   
          //end
		  else if (seq_err_flag) begin
		       current_sqid_reg_vld   <=   1'd0    ;    
               //current_sqid_reg_cnt   <=   4'd0    ;    
               current_sqid_error     <=   1'd0    ; 		
		  end
          //else begin
//          else if ( ((current_id_wire<=(current_sqid_reg+params_current_sqid_reg_add))&&  (current_id_wire<=(current_sqid_reg_max+1'd1) )  )       ||(current_sqid_reg==32'd0) ||  (current_sqid_reg_cnt>=params_current_sqid_reg_cnt)    )  begin
          else if (   (current_id_wire<=(current_sqid_reg_max+1'd1) )  || (current_sqid_reg==32'd0) ||  (current_sqid_reg_max_cnt>=params_current_sqid_reg_cnt)    )  begin
               current_sqid_reg       <=    current_id_wire   ;
               current_sqid_reg_vld   <=   1'd1    ;     
               //current_sqid_reg_cnt   <=   4'd0    ;    
               current_sqid_error     <=   1'd0    ; 			   
          end
          else   begin
               current_sqid_reg       <=   current_sqid_reg   ;
               current_sqid_reg_vld   <=   1'd0               ;    
               //current_sqid_reg_cnt   <=   current_sqid_reg_cnt + 4'd1    ;   
               current_sqid_error     <=   ((current_id_wire-current_sqid_reg)>=32'd128 )   ; 			   
          end
  end
  else if (current_sqcut_done_dly &&  (current_sqid_reg<current_cut_done_sqid_reg) ) begin
      current_sqid_reg       <=    ((current_cut_done_sqid_reg-current_sqid_reg)>= 32'd8) ?   current_sqid_reg :  current_cut_done_sqid_reg   ;
      current_sqid_reg_vld   <=    1'd0    ; 
      //current_sqid_reg_cnt   <=    4'd0    ;
	  current_sqid_error     <=   ((current_cut_done_sqid_reg-current_sqid_reg)>=32'd128 )   ; 	
  end
  else begin
             current_sqid_reg_vld   <=   1'd0    ; 
             current_sqid_error     <=   1'd0    ; 						 
  end
end


//reg      [31:0]            current_sqid_reg_max   ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg_max       <=  32'd0    ;
	  current_sqid_reg_max_cnt       <=  4'd0    ;
  end
  else if (params_filter_rst || current_sqid_reg_rst) begin
      current_sqid_reg_max       <=  32'd0    ;
	  current_sqid_reg_max_cnt       <=  4'd0    ;
  end
  else if (current_cut_now_sqid_reg_vld_dly) begin
      if   ((current_cut_done_sqid_reg_dly==(current_sqid_reg_max+1'd1)) || (current_sqid_reg_max_cnt>=params_current_sqid_reg_cnt) ||  (current_sqid_reg_max==32'd0)   )   begin
	     current_sqid_reg_max       <=       (current_cut_done_sqid_reg_dly)            ; 
         current_sqid_reg_max_cnt       <=  4'd0    ;		 
	  end
	  else if   (current_cut_done_sqid_reg_dly>(current_sqid_reg_max+1'd1))   begin
	     current_sqid_reg_max_cnt       <=  current_sqid_reg_max_cnt + 1'd1    ;
	  end
	  else begin
	     current_sqid_reg_max_cnt       <=  4'd0    ;		 
	  end
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  &&  frame_type_rdy && sq_frame_flag ) begin 
      if   ( (current_id_wire==(current_sqid_reg_max+1'd1)) ||  (current_sqid_reg_max_cnt>=params_current_sqid_reg_cnt) ||  (current_sqid_reg_max==32'd0)    )   begin
	     current_sqid_reg_max       <=        current_id_wire           ; 
         current_sqid_reg_max_cnt       <=  4'd0    ;		 
	  end
	  else if   (current_id_wire>(current_sqid_reg_max+1'd1))   begin
	     current_sqid_reg_max_cnt       <=  current_sqid_reg_max_cnt + 1'd1    ;
	  end
	  else begin
	     current_sqid_reg_max_cnt       <=  4'd0    ;		 
	  end
  end
end



//params_current_sqid_reg_ro
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      params_current_sqid_reg_ro       <=  32'd0    ;
      params_current_sqid_reg_ro_vld   <=   1'd0    ;
  end
  else if (params_filter_rst) begin
      params_current_sqid_reg_ro       <=  32'd0    ;
      params_current_sqid_reg_ro_vld   <=   1'd0    ;      
  end
  //else if (current_sqcut_done_dly) begin
  //    params_current_sqid_reg_ro       <=    current_cut_done_sqid_reg          ;
  //end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  &&  frame_type_rdy && sq_frame_flag ) begin 
	   params_current_sqid_reg_ro       <=    current_id_wire          ;
           params_current_sqid_reg_ro_vld   <=   1'd1   ;           
  end
  else begin
           params_current_sqid_reg_ro_vld   <=   1'd0   ;                 
  end
end

//current_sqid_reg_match_00
//market_rdy
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg_match_00       <=  32'hffff_ffff    ;
      current_sqid_reg_match_01       <=  32'hffff_ffff    ;
      current_sqid_reg_match_02       <=  32'hffff_ffff    ;
      current_sqid_reg_match_03       <=  32'hffff_ffff    ;
      current_sqid_reg_match_04       <=  32'hffff_ffff    ;
      current_sqid_reg_match_05       <=  32'hffff_ffff    ;
      current_sqid_reg_match_06       <=  32'hffff_ffff    ;
      current_sqid_reg_match_07       <=  32'hffff_ffff    ;
      current_sqid_reg_match_08       <=  32'hffff_ffff    ;
      current_sqid_reg_match_09       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0a       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0b       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0c       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0d       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0e       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0f       <=  32'hffff_ffff    ;
      current_sqid_reg_match_10       <=  32'hffff_ffff    ;
      current_sqid_reg_match_11       <=  32'hffff_ffff    ;
      current_sqid_reg_match_12       <=  32'hffff_ffff    ;
      current_sqid_reg_match_13       <=  32'hffff_ffff    ;
      current_sqid_reg_match_14       <=  32'hffff_ffff    ;
      current_sqid_reg_match_15       <=  32'hffff_ffff    ;
      current_sqid_reg_match_16       <=  32'hffff_ffff    ;
      current_sqid_reg_match_17       <=  32'hffff_ffff    ;
      current_sqid_reg_match_18       <=  32'hffff_ffff    ;
      current_sqid_reg_match_19       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1a       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1b       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1c       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1d       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1e       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1f       <=  32'hffff_ffff    ;

  end
  else if (params_filter_rst) begin
      current_sqid_reg_match_00       <=  32'hffff_ffff    ;
      current_sqid_reg_match_01       <=  32'hffff_ffff    ;
      current_sqid_reg_match_02       <=  32'hffff_ffff    ;
      current_sqid_reg_match_03       <=  32'hffff_ffff    ;
      current_sqid_reg_match_04       <=  32'hffff_ffff    ;
      current_sqid_reg_match_05       <=  32'hffff_ffff    ;
      current_sqid_reg_match_06       <=  32'hffff_ffff    ;
      current_sqid_reg_match_07       <=  32'hffff_ffff    ;
      current_sqid_reg_match_08       <=  32'hffff_ffff    ;
      current_sqid_reg_match_09       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0a       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0b       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0c       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0d       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0e       <=  32'hffff_ffff    ;
      current_sqid_reg_match_0f       <=  32'hffff_ffff    ;
      current_sqid_reg_match_10       <=  32'hffff_ffff    ;
      current_sqid_reg_match_11       <=  32'hffff_ffff    ;
      current_sqid_reg_match_12       <=  32'hffff_ffff    ;
      current_sqid_reg_match_13       <=  32'hffff_ffff    ;
      current_sqid_reg_match_14       <=  32'hffff_ffff    ;
      current_sqid_reg_match_15       <=  32'hffff_ffff    ;
      current_sqid_reg_match_16       <=  32'hffff_ffff    ;
      current_sqid_reg_match_17       <=  32'hffff_ffff    ;
      current_sqid_reg_match_18       <=  32'hffff_ffff    ;
      current_sqid_reg_match_19       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1a       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1b       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1c       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1d       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1e       <=  32'hffff_ffff    ;
      current_sqid_reg_match_1f       <=  32'hffff_ffff    ;
  end
  else if ( market_rdy  ) begin 
      current_sqid_reg_match_00       <=    params_current_sqid_reg_ro  ;
      current_sqid_reg_match_01       <=    current_sqid_reg_match_00   ;         
      current_sqid_reg_match_02       <=    current_sqid_reg_match_01   ;
      current_sqid_reg_match_03       <=    current_sqid_reg_match_02   ;
      current_sqid_reg_match_04       <=    current_sqid_reg_match_03   ;
      current_sqid_reg_match_05       <=    current_sqid_reg_match_04   ;
      current_sqid_reg_match_06       <=    current_sqid_reg_match_05   ;
      current_sqid_reg_match_07       <=    current_sqid_reg_match_06   ;
      current_sqid_reg_match_08       <=    current_sqid_reg_match_07   ;
      current_sqid_reg_match_09       <=    current_sqid_reg_match_08   ;
      current_sqid_reg_match_0a       <=    current_sqid_reg_match_09   ;
      current_sqid_reg_match_0b       <=    current_sqid_reg_match_0a   ;
      current_sqid_reg_match_0c       <=    current_sqid_reg_match_0b   ;
      current_sqid_reg_match_0d       <=    current_sqid_reg_match_0c   ;
      current_sqid_reg_match_0e       <=    current_sqid_reg_match_0d   ;
      current_sqid_reg_match_0f       <=    current_sqid_reg_match_0e   ;
      current_sqid_reg_match_10       <=    current_sqid_reg_match_0f   ;
      current_sqid_reg_match_11       <=    current_sqid_reg_match_10   ;
      current_sqid_reg_match_12       <=    current_sqid_reg_match_11   ;
      current_sqid_reg_match_13       <=    current_sqid_reg_match_12   ;
      current_sqid_reg_match_14       <=    current_sqid_reg_match_13   ;
      current_sqid_reg_match_15       <=    current_sqid_reg_match_14   ;
      current_sqid_reg_match_16       <=    current_sqid_reg_match_15   ;
      current_sqid_reg_match_17       <=    current_sqid_reg_match_16   ;
      current_sqid_reg_match_18       <=    current_sqid_reg_match_17   ;
      current_sqid_reg_match_19       <=    current_sqid_reg_match_18   ;
      current_sqid_reg_match_1a       <=    current_sqid_reg_match_19   ;
      current_sqid_reg_match_1b       <=    current_sqid_reg_match_1a   ;
      current_sqid_reg_match_1c       <=    current_sqid_reg_match_1b   ;
      current_sqid_reg_match_1d       <=    current_sqid_reg_match_1c   ;
      current_sqid_reg_match_1e       <=    current_sqid_reg_match_1d   ;
      current_sqid_reg_match_1f       <=    current_sqid_reg_match_1e   ;
  end
end

//params_current_sqid_reg_ro_vld
//current_sqid_reg_match_flag


//current_sqid_reg_match_00
//market_rdy
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg_match_flag1    <=  1'd0     ;
      current_sqid_reg_match_flag2    <=  1'd0     ;
      current_sqid_reg_match_flag3    <=  1'd0     ;
      current_sqid_reg_match_flag4    <=  1'd0     ;
  end
  else if (params_filter_rst) begin
      current_sqid_reg_match_flag1    <=  1'd0     ;   
      current_sqid_reg_match_flag2    <=  1'd0     ;   
      current_sqid_reg_match_flag3    <=  1'd0     ;   
      current_sqid_reg_match_flag4    <=  1'd0     ;      
  end
  else if ( params_current_sqid_reg_ro_vld  ) begin
      current_sqid_reg_match_flag1  <=  (
                                           (current_sqid_reg_match_00==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_01==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_02==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_03==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_04==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_05==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_06==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_07==params_current_sqid_reg_ro) );
      current_sqid_reg_match_flag2  <=  (         
                                           (current_sqid_reg_match_08==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_09==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_0a==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_0b==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_0c==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_0d==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_0e==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_0f==params_current_sqid_reg_ro)  );
      current_sqid_reg_match_flag3  <=  (          
                                           (current_sqid_reg_match_10==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_11==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_12==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_13==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_14==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_15==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_16==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_17==params_current_sqid_reg_ro) );
      current_sqid_reg_match_flag4  <=  (            
                                           (current_sqid_reg_match_18==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_19==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_1a==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_1b==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_1c==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_1d==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_1e==params_current_sqid_reg_ro) ||  
                                           (current_sqid_reg_match_1f==params_current_sqid_reg_ro)   
                                       ); 
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg_match_flag    <=  1'd0     ;
  end
  else begin
      current_sqid_reg_match_flag  <=  current_sqid_reg_match_flag1 ||  current_sqid_reg_match_flag2 || current_sqid_reg_match_flag3 || current_sqid_reg_match_flag4 ;
  end
end



wire   [31:0]    current_id_wire2  =  current_id_wire +  1'd1  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg_flag   <=  1'd0    ;
  end
  else if (st_rx_start&&tcp_sqmatch_flag) begin
      current_sqid_reg_flag   <=  1'd1    ;
  end
  else if (st_rx_start&&~tcp_sqmatch_flag) begin
      current_sqid_reg_flag   <=  1'd0    ;
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  && frame_type_rdy  ) begin 
      //if ( ((current_id_wire+1'd1)>current_sqid_reg)  ) begin
//             current_sqid_reg_flag  =    1'd1   ;
//      end 
//		else begin
//		       current_sqid_reg_flag  =    1'd0   ;
//		end

//       if (  (current_id_wire2<=current_sqid_reg) &&  (  (current_id_wire2[31])  || (~current_sqid_reg[31]) )   ) begin
       if (  (current_id_wire2<=current_sqid_reg)   ) begin
           current_sqid_reg_flag  <=    1'd0   ;
       end
       //else if (  (~current_sqid_reg[31]) && (current_id_wire2[31])  ) begin
       //    current_sqid_reg_flag  <=    1'd0   ;          
       //end
       else begin
           current_sqid_reg_flag  <=    1'd1   ;           
       end
  end
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//sq_cut_flag

// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // sq_cut_on   <=  1'd0    ;
  // end
  // else if ( sq_cut_flag   ) begin
      // sq_cut_on   <=  1'd1 ;
  // end 
   // else if (sq_cut_reset) begin
     // sq_cut_on   <=  1'd0 ;    
  // end 
  // else if (st_rx_start && tcp_sqmatch_flag) begin
      // sq_cut_on   <=  1'd0    ;
  // end
// end


// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // st_rq_cut_cnt   <=   16'd0    ;
  // end
  // else if ( fir_r_sqcuth_st   )  begin
      // st_rq_cut_cnt   <=   st_rx_cnt_reg ;
  // end
  // else if ( fir_r_vsync_st &&  (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sq_frame_flag && current_sqid_reg_flag &&  ~sq_cut_on ) begin
      // st_rq_cut_cnt  <=    16'd8   ;   
  // end
  // else if ( (fir_r_sqcut_st )  && (st_shift_ccnt>=6'd8)  ) begin
      // st_rq_cut_cnt  <=    st_rq_cut_cnt +  16'd8   ;   
  // end
  // else if ((fir_r_sqcut_end_st )  && (st_shift_ccnt>=st_rx_cnt_reg)) begin
      // st_rq_cut_cnt  <=    st_rq_cut_cnt +  st_rx_cnt_reg   ;        
  // end
  // else if (fir_r_sqrcut_st &&  (st_shift_ccnt>=16'd8)  ) begin
      // st_rq_cut_cnt  <=    st_rq_cut_cnt +  16'd8   ;   
  // end
  // else if (fir_r_sqrcut_end_st &&  (st_shift_ccnt>=sub_sqcut_len_reg)  ) begin
      // st_rq_cut_cnt  <=    st_rq_cut_cnt +  sub_sqcut_len_reg   ;   
  // end
// end


// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // sq_cut_flag   <=  1'd0    ;
  // end
  // else if ( fir_r_vsync_st  &&   (st_rx_cnt_reg<(sync_len_byte+16'd4))  &&  (st_shift_ccnt>=6'd8)     ) begin 
      // sq_cut_flag   <=  sq_frame_flag  &&  current_sqid_reg_flag  && ~sq_cut_on  ;
  // end
  // else if (fir_r_rjudge_st) begin
      // sq_cut_flag   <=  sq_frame_flag  &&   (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) &&  ~sq_cut_on  ;
  // end 
  // else begin
      // sq_cut_flag   <=  1'd0    ;
  // end
// end

//market_rdy
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      market_rdy   <=  1'd0    ;
  end
  else if (fir_r_rdata0_st &&  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) &&  (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg)  ) begin
      market_rdy   <=  frame_type_rdy && ( segm_type_2433_flag  ||  segm_type_2434_flag )  &&  ~current_sqid_reg_match_flag  ; //1'd1 ;
  end
  else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) &&  (patition_cnt>=patition_cnt_reg) )  begin
      market_rdy   <=  frame_type_rdy && ( segm_type_2433_flag  ||  segm_type_2434_flag )  &&  ~current_sqid_reg_match_flag;  //1'd1 ;
  end
  else begin
      market_rdy   <=  1'd0    ;
  end
end


//current_sqid_reg_rst 
//250* 1000_000 *  60 * 60 * 2
reg      [47:0]          current_sqid_reg_rst_cnt        ;   
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg_rst_cnt   <=  48'd0    ;
      current_sqid_reg_rst       <=   1'd0    ; 
  end
  else if ( params_filter_rst  ) begin
      current_sqid_reg_rst_cnt   <=  48'd0    ;  
      current_sqid_reg_rst       <=   1'd0    ;     
  end
  else if ( market_rdy  ) begin
      current_sqid_reg_rst_cnt   <=  48'd0    ; 
      current_sqid_reg_rst       <=   1'd0    ;               
  end
  else if (  (current_sqid_reg_rst_cnt>({params_current_sqid_reg_rst_cnt,16'hffff}))  &&   st_rx_start_pre  ) begin
      current_sqid_reg_rst_cnt   <=  48'd0    ; 
      current_sqid_reg_rst       <=   1'd1    ;   

      /* synthesis translate_off */         
	$display("%m   Warning     current_sqid_reg_rst   !!!!!    \n   " );           
      /* synthesis translate_on */
                             
  end
  else  begin
      current_sqid_reg_rst_cnt   <=  (current_sqid_reg_rst_cnt==48'hffff_ffff_ffff)   ?  current_sqid_reg_rst_cnt  :    current_sqid_reg_rst_cnt + 64'd1    ; 
      current_sqid_reg_rst       <=   1'd0    ;                                
  end 
end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//reg                        sq_rx_start        ; 
//reg                        sq_rx_valid        ; 
//reg      [63:0]            sq_rx_data         ; 
//reg      [ 2:0]            sq_rx_empty        ; 
//reg                        sc_rx_start        ; 
//reg                        sc_rx_valid        ; 
//reg      [63:0]            sc_rx_data         ; 
//reg      [ 2:0]            sc_rx_empty        ; 

fir_cut_out  sq_fir_cut_out (
.sq_cut_on              ( sq_cut_on_reg           ),
.sq_cut_first_on        ( sq_cut_first_on         ),
.tcp_sqmatch_flag       ( tcp_sqmatch_flag_reg    ),
.current_sqid_reg_flag  (current_sqid_reg_flag    ),
.sync_len_byte        (sync_len_byte          )   ,

.sync_fisrt_byte    (sync_fisrt_byte),
.sync_four_byte     (sync_four_byte),

.sq_rx_start        (sq_rx_start     ), 
.sq_rx_end          (sq_rx_end       ),
.sq_rx_valid        (sq_rx_valid     ), 
.sq_rx_data         (sq_rx_data      ), 
.sq_rx_empty        (sq_rx_empty     ), 

.sq_rx_empty_01     ( sq_rx_empty_01       )   , 
.sq_rx_empty_02     ( sq_rx_empty_02       )   , 
.sq_rx_empty_03     ( sq_rx_empty_03       )   , 
.sq_rx_empty_04     ( sq_rx_empty_04       )   , 
.sq_rx_empty_05     ( sq_rx_empty_05       )   , 
.sq_rx_empty_06     ( sq_rx_empty_06       )   , 
.sq_rx_empty_07     ( sq_rx_empty_07       )   , 
.sq_rx_empty_08     ( sq_rx_empty_08       )   , 
.sq_rx_empty_09     ( sq_rx_empty_09       )   , 
.sq_rx_empty_10     ( sq_rx_empty_10       )   , 
.sq_rx_empty_11     ( sq_rx_empty_11       )   , 
.sq_rx_empty_12     ( sq_rx_empty_12       )   , 
.sq_rx_empty_13     ( sq_rx_empty_13       )   , 
.sq_rx_empty_14     ( sq_rx_empty_14       )   , 
.sq_rx_empty_15     ( sq_rx_empty_15       )   , 
.sq_rx_empty_16     ( sq_rx_empty_16       )   , 
.sq_rx_empty_17     ( sq_rx_empty_17       )   , 
.sq_rx_empty_18     ( sq_rx_empty_18       )   , 
.sq_rx_empty_19     ( sq_rx_empty_19       )   , 
.sq_rx_empty_20     ( sq_rx_empty_20       )   , 
.sq_rx_empty_21     ( sq_rx_empty_21       )   , 
.sq_rx_empty_22     ( sq_rx_empty_22       )   , 
.sq_rx_empty_23     ( sq_rx_empty_23       )   , 
.sq_rx_empty_24     ( sq_rx_empty_24       )   , 
.sq_rx_empty_25     ( sq_rx_empty_25       )   , 
.sq_rx_empty_26     ( sq_rx_empty_26       )   , 
.sq_rx_empty_27     ( sq_rx_empty_27       )   , 
.sq_rx_empty_28     ( sq_rx_empty_28       )   , 
.sq_rx_empty_29     ( sq_rx_empty_29       )   , 
.sq_rx_empty_30     ( sq_rx_empty_30       )   ,
.sq_rx_empty_31     ( sq_rx_empty_31       )   , 

.fir_r_sqcuth_st    (fir_r_sqcuth_st ),
.fir_r_vsync_st     (fir_r_vsync_st  ),
.fir_r_sqrcut_st     (fir_r_sqrcut_st  ),
.fir_r_sqrcut_end_st (fir_r_sqrcut_end_st),
.fir_r_sqcut_st     (fir_r_sqcut_st          ),
.fir_r_sqcut_end_st (fir_r_sqcut_end_st      ),
.sub_sqcut_len_reg  (sub_sqcut_len_reg[5:0]  ),
.st_shift_ccnt      (st_shift_ccnt   ),  
.st_rx_cnt_reg      (st_rx_cnt_reg   ),
.sq_frame_flag      (sq_frame_flag   ),
.st_shift_reg       (st_shift_reg    ),
.clk                (clk             ),
.rst_n              (rst_n         )
);

// fir_cut_out  sc_fir_cut_out (
// .sq_cut_on              (  sc_cut_on   ),
// .current_sqid_reg_flag  (current_scid_reg_flag),
// .sync_len_byte        (sync_len_byte       )   ,
// .sq_rx_start        (sc_rx_start     ), 
// .sq_rx_end          (sc_rx_end       ),
// .sq_rx_valid        (sc_rx_valid     ), 
// .sq_rx_data         (sc_rx_data      ), 
// .sq_rx_empty        (sc_rx_empty     ), 
// .fir_r_sqcuth_st    (fir_r_sccuth_st ),
// .fir_r_vsync_st     (fir_r_vsync_st  ),
// .fir_r_sqrcut_st     (fir_r_scrcut_st  ),
// .fir_r_sqrcut_end_st (fir_r_scrcut_end_st),
// .fir_r_sqcut_st     (fir_r_sccut_st          ),
// .fir_r_sqcut_end_st (fir_r_sccut_end_st      ),
// .sub_sqcut_len_reg  (sub_sccut_len_reg[5:0]  ),
// .st_shift_ccnt      (st_shift_ccnt   ),  
// .st_rx_cnt_reg      (st_rx_cnt_reg   ),
// .sq_frame_flag      (sc_frame_flag   ),
// .st_shift_reg       (st_shift_reg    ),
// .clk                (clk             ),
// .rst_n            (rst_n         )
// );


fir_shift_reg_192  fir_shift_reg_192 (
.fir_rx_cstate        (fir_rx_cstate       )   ,

.st_shift_full_flag   (st_shift_full_flag  )   ,
.st_rx_start          (st_rx_start         )   ,
.st_rx_offset         (st_rx_offset        )   ,
.st_rx_end            (st_rx_end           )   ,
.st_rx_valid          (st_rx_valid         )   ,
.st_rx_data           (st_rx_data          )   ,
.st_rx_ready          (st_rx_ready         )   ,
.st_rx_empty          (st_rx_empty         )   ,
.fir_r_idle_st        (fir_r_idle_st       )   ,
.st_shift_reg         (st_shift_reg        )   ,  
.st_shift_ccnt        (st_shift_ccnt       )   ,
.st_shift_scnt        (st_shift_scnt       )   ,
.st_shift_en          (st_shift_en         )   ,
.clk                  (clk                 )   ,
.rst_n                (rst_n             )   
);




//first_sync_len_error
//error_flag
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      error_flag   <=  32'd0    ;
  end
  else begin
      error_flag   <=  {24'd0,3'd0 ,  (st_rx_start_pre&&~fir_r_idle_st) ,  first_sync_len_error||current_sqid_error  , st_shift_full_flag  ,  sq_shift_full_flag , fir_r_error_st   } ;
  end
end




endmodule

