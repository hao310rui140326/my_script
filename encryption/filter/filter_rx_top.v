module  filter_rx_top (
clk                   ,
rst_n                 ,  


params_current_sqid_reg_add ,
params_current_sqid_reg_cnt ,
params_current_sqid_reg_rst_cnt ,


fir_rx_cstate,
debug_discard_calc_cnt1  ,
debug_st_shift_full_flag ,

debug_st_shift_scnt,    ,
debug_st_shift_en,       ,

tlp_cnt,

current_id_wire,                                                                                       
current_sqid_reg,                                                                                      
current_sqid_reg_vld,   

    st_rx_cnt_reg        ,
    st_shift_ccnt        ,



// pcie_clk              ,
// pcie_clk_rstn         ,

params_current_sqid_reg_ro   ,
params_filter_rst            ,

params_frame_type_byte ,
//params_des_acnt        ,


params_03e9_type            ,
params_1389_type            ,
params_07d0_type            ,
                                           
st_rx_start           , 
st_rx_offset          ,
st_rx_end             , 
st_rx_valid           , 
st_rx_data            , 
st_rx_empty           , 
st_rx_cnt             , 
st_rx_ready           ,   
first_sync_len_byte   ,                                                                                       
tcp_sqmatch_flag      ,  //match with pre  SQ tcp frame 
seq_err_flag          ,
error_flag            ,
sq_cut_flag           ,  //cut _flag     
sq_cut_reset          ,

                                                                                         
tcp_payload_len       ,

fifo_data_empty,
fifo_data_out ,
fifo_data_vld,
fifo_ready     

// requestor_id          ,
// tlp_StReady_i         ,
// tlp_StData_o          ,
// tlp_StSop_o           ,
// tlp_StEop_o           ,
// tlp_StEmpty_o         ,
// tlp_StValid_o         ,         
// st_fifo_hfull         ,
// st_fifo_full          ,
// st_fifo_empty         ,    
// rmem_descriptor_reg    
);

input                       clk                   ;
input                       rst_n                 ;


input      [3:0]            params_current_sqid_reg_add   ;
input      [3:0]            params_current_sqid_reg_cnt   ;
input      [31:0]           params_current_sqid_reg_rst_cnt ;


output   [4:0]    fir_rx_cstate;


output   [31:0]    tlp_cnt;                                                                            

output   [31:0]          current_id_wire;                                                              
output   [31:0]          current_sqid_reg;                                                             
output                     current_sqid_reg_vld ;    


// input                        pcie_clk              ;
// input                        pcie_clk_rstn         ;

input     [ 15: 0]          params_frame_type_byte ;
//input     [ 23: 0]          params_des_acnt ;

output   [31:0]            params_current_sqid_reg_ro    ;
input                      params_filter_rst             ;


input    [15:0]            params_03e9_type            ;
input    [15:0]            params_1389_type            ;
input    [15:0]            params_07d0_type            ;

                                                  
input                       st_rx_start           ; 
input     [  3: 0]          st_rx_offset          ;
input                       st_rx_end             ; 
input                       st_rx_valid           ; 
input     [ 63: 0]          st_rx_data            ; 
input     [  2: 0]          st_rx_empty           ; 
input     [ 15: 0]          st_rx_cnt             ; 
output                      st_rx_ready           ; 
input     [ 15: 0]          first_sync_len_byte   ;

                                                  
//tcp                                             
input     [31:0]            tcp_sqmatch_flag      ;  //match with pre  SQ tcp frame 

input     [31:0]            seq_err_flag          ;
                                                  
output    [31:0]             error_flag            ;
output    [31:0]            sq_cut_flag           ;  //cut _flag

output    [31:0]            sq_cut_reset          ;
                                                                                               
input      [ 15: 0]         tcp_payload_len       ;

//add  
output                       fifo_data_empty;
output   [255:0]             fifo_data_out ;
output                       fifo_data_vld;
input                        fifo_ready;

// input      [ 15: 0]         requestor_id          ;
// input                       tlp_StReady_i         ;
// output     [255: 0]         tlp_StData_o          ;
// output                      tlp_StSop_o           ;
// output                      tlp_StEop_o           ;
// output     [  1: 0]         tlp_StEmpty_o         ;
// output                      tlp_StValid_o         ;         
// output                      st_fifo_hfull         ;
// output                      st_fifo_full          ;
// output                      st_fifo_empty         ;    
// input      [159: 0]         rmem_descriptor_reg   ; 

/////////////////////////////////////////////////////////////////////////////////////
wire      [31:0]            params_current_sqid_reg_ro    ;

wire    [31:0]             sq_cut_reset          ;
wire    [31:0]             sq_cut_reset_pre      ;

wire                       fir_r_idle_st      ;
wire                       fir_r_sqcuth_st     ;
wire                       fir_r_vsync_st      ;
wire                       fir_r_sqcut_st      ;
wire                       fir_r_sqcut_end_st  ;
wire                       fir_r_sqrcut_st     ;
wire                       fir_r_sqrcut_end_st ;
wire                       fir_r_rjudge_st     ;

wire      [31:0]           sq_rx_start        ; 
wire      [31:0]           sq_rx_end          ; 
wire      [31:0]           sq_rx_valid        ; 
wire      [63:0]           sq_rx_data         ; 
wire      [ 2:0]           sq_rx_empty        ; 

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


wire    [31:0]          current_id_wire =  32'd0 ;


wire      [31:0]           current_sqid_reg   ;
wire                       current_sqid_reg_vld ;
wire      [ 23: 0]         market_explain     ; //市场说明 3
wire      [  7: 0]         info_classify      ; //信息分类 1
wire      [ 31: 0]         dialog_num         ; //会话编号 4
wire      [  7: 0]         contract_flag      ; //合约标志 1
wire      [ 31: 0]         contract_num       ; //合约编号 4
wire      [175: 0]         contract_code      ; //合约代码 22
wire      [ 71: 0]         update_time        ; //更新时间 9
wire      [ 31: 0]         update_ms          ; //更新毫秒 4
wire      [ 63: 0]         new_price          ; //最新价 8
wire      [ 31: 0]         turnover           ; //成交量 4
wire      [ 63: 0]         volume             ; //成交额 8   
wire      [ 63: 0]         position           ; //持仓量 8
wire      [ 63: 0]         purchase_price     ; //申买价 8
wire      [ 31: 0]         buy_quantity       ; //申买量 4
wire      [ 63: 0]         sell_price         ; //申买价 8
wire      [ 31: 0]         sell_quantity      ; //申卖量 4
wire                       market_rdy         ;

wire      [ 23: 0]         sq00_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq01_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq02_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq03_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq04_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq05_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq06_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq07_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq08_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq09_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq10_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq11_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq12_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq13_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq14_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq15_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq16_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq17_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq18_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq19_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq20_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq21_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq22_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq23_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq24_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq25_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq26_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq27_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq28_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq29_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq30_market_explain     ; //市场说明 3
wire      [ 23: 0]         sq31_market_explain     ; //市场说明 3


wire      [  7: 0]         sq00_info_classify      ; //信息分类 1
wire      [  7: 0]         sq01_info_classify      ; //信息分类 1
wire      [  7: 0]         sq02_info_classify      ; //信息分类 1
wire      [  7: 0]         sq03_info_classify      ; //信息分类 1
wire      [  7: 0]         sq04_info_classify      ; //信息分类 1
wire      [  7: 0]         sq05_info_classify      ; //信息分类 1
wire      [  7: 0]         sq06_info_classify      ; //信息分类 1
wire      [  7: 0]         sq07_info_classify      ; //信息分类 1
wire      [  7: 0]         sq08_info_classify      ; //信息分类 1
wire      [  7: 0]         sq09_info_classify      ; //信息分类 1
wire      [  7: 0]         sq10_info_classify      ; //信息分类 1
wire      [  7: 0]         sq11_info_classify      ; //信息分类 1
wire      [  7: 0]         sq12_info_classify      ; //信息分类 1
wire      [  7: 0]         sq13_info_classify      ; //信息分类 1
wire      [  7: 0]         sq14_info_classify      ; //信息分类 1
wire      [  7: 0]         sq15_info_classify      ; //信息分类 1
wire      [  7: 0]         sq16_info_classify      ; //信息分类 1
wire      [  7: 0]         sq17_info_classify      ; //信息分类 1
wire      [  7: 0]         sq18_info_classify      ; //信息分类 1
wire      [  7: 0]         sq19_info_classify      ; //信息分类 1
wire      [  7: 0]         sq20_info_classify      ; //信息分类 1
wire      [  7: 0]         sq21_info_classify      ; //信息分类 1
wire      [  7: 0]         sq22_info_classify      ; //信息分类 1
wire      [  7: 0]         sq23_info_classify      ; //信息分类 1
wire      [  7: 0]         sq24_info_classify      ; //信息分类 1
wire      [  7: 0]         sq25_info_classify      ; //信息分类 1
wire      [  7: 0]         sq26_info_classify      ; //信息分类 1
wire      [  7: 0]         sq27_info_classify      ; //信息分类 1
wire      [  7: 0]         sq28_info_classify      ; //信息分类 1
wire      [  7: 0]         sq29_info_classify      ; //信息分类 1
wire      [  7: 0]         sq30_info_classify      ; //信息分类 1
wire      [  7: 0]         sq31_info_classify      ; //信息分类 1

wire      [ 31: 0]         sq00_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq01_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq02_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq03_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq04_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq05_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq06_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq07_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq08_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq09_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq10_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq11_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq12_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq13_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq14_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq15_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq16_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq17_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq18_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq19_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq20_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq21_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq22_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq23_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq24_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq25_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq26_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq27_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq28_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq29_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq30_dialog_num         ; //会话编号 4
wire      [ 31: 0]         sq31_dialog_num         ; //会话编号 4

wire      [  7: 0]         sq00_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq01_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq02_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq03_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq04_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq05_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq06_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq07_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq08_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq09_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq10_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq11_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq12_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq13_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq14_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq15_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq16_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq17_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq18_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq19_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq20_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq21_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq22_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq23_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq24_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq25_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq26_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq27_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq28_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq29_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq30_contract_flag      ; //合约标志 1
wire      [  7: 0]         sq31_contract_flag      ; //合约标志 1

wire      [ 31: 0]         sq00_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq01_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq02_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq03_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq04_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq05_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq06_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq07_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq08_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq09_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq10_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq11_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq12_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq13_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq14_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq15_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq16_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq17_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq18_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq19_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq20_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq21_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq22_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq23_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq24_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq25_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq26_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq27_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq28_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq29_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq30_contract_num       ; //合约编号 4
wire      [ 31: 0]         sq31_contract_num       ; //合约编号 4

wire      [175: 0]         sq00_contract_code      ; //合约代码 22
wire      [175: 0]         sq01_contract_code      ; //合约代码 22
wire      [175: 0]         sq02_contract_code      ; //合约代码 22
wire      [175: 0]         sq03_contract_code      ; //合约代码 22
wire      [175: 0]         sq04_contract_code      ; //合约代码 22
wire      [175: 0]         sq05_contract_code      ; //合约代码 22
wire      [175: 0]         sq06_contract_code      ; //合约代码 22
wire      [175: 0]         sq07_contract_code      ; //合约代码 22
wire      [175: 0]         sq08_contract_code      ; //合约代码 22
wire      [175: 0]         sq09_contract_code      ; //合约代码 22
wire      [175: 0]         sq10_contract_code      ; //合约代码 22
wire      [175: 0]         sq11_contract_code      ; //合约代码 22
wire      [175: 0]         sq12_contract_code      ; //合约代码 22
wire      [175: 0]         sq13_contract_code      ; //合约代码 22
wire      [175: 0]         sq14_contract_code      ; //合约代码 22
wire      [175: 0]         sq15_contract_code      ; //合约代码 22
wire      [175: 0]         sq16_contract_code      ; //合约代码 22
wire      [175: 0]         sq17_contract_code      ; //合约代码 22
wire      [175: 0]         sq18_contract_code      ; //合约代码 22
wire      [175: 0]         sq19_contract_code      ; //合约代码 22
wire      [175: 0]         sq20_contract_code      ; //合约代码 22
wire      [175: 0]         sq21_contract_code      ; //合约代码 22
wire      [175: 0]         sq22_contract_code      ; //合约代码 22
wire      [175: 0]         sq23_contract_code      ; //合约代码 22
wire      [175: 0]         sq24_contract_code      ; //合约代码 22
wire      [175: 0]         sq25_contract_code      ; //合约代码 22
wire      [175: 0]         sq26_contract_code      ; //合约代码 22
wire      [175: 0]         sq27_contract_code      ; //合约代码 22
wire      [175: 0]         sq28_contract_code      ; //合约代码 22
wire      [175: 0]         sq29_contract_code      ; //合约代码 22
wire      [175: 0]         sq30_contract_code      ; //合约代码 22
wire      [175: 0]         sq31_contract_code      ; //合约代码 22

wire      [ 71: 0]         sq00_update_time        ; //更新时间 9
wire      [ 71: 0]         sq01_update_time        ; //更新时间 9
wire      [ 71: 0]         sq02_update_time        ; //更新时间 9
wire      [ 71: 0]         sq03_update_time        ; //更新时间 9
wire      [ 71: 0]         sq04_update_time        ; //更新时间 9
wire      [ 71: 0]         sq05_update_time        ; //更新时间 9
wire      [ 71: 0]         sq06_update_time        ; //更新时间 9
wire      [ 71: 0]         sq07_update_time        ; //更新时间 9
wire      [ 71: 0]         sq08_update_time        ; //更新时间 9
wire      [ 71: 0]         sq09_update_time        ; //更新时间 9
wire      [ 71: 0]         sq10_update_time        ; //更新时间 9
wire      [ 71: 0]         sq11_update_time        ; //更新时间 9
wire      [ 71: 0]         sq12_update_time        ; //更新时间 9
wire      [ 71: 0]         sq13_update_time        ; //更新时间 9
wire      [ 71: 0]         sq14_update_time        ; //更新时间 9
wire      [ 71: 0]         sq15_update_time        ; //更新时间 9
wire      [ 71: 0]         sq16_update_time        ; //更新时间 9
wire      [ 71: 0]         sq17_update_time        ; //更新时间 9
wire      [ 71: 0]         sq18_update_time        ; //更新时间 9
wire      [ 71: 0]         sq19_update_time        ; //更新时间 9
wire      [ 71: 0]         sq20_update_time        ; //更新时间 9
wire      [ 71: 0]         sq21_update_time        ; //更新时间 9
wire      [ 71: 0]         sq22_update_time        ; //更新时间 9
wire      [ 71: 0]         sq23_update_time        ; //更新时间 9
wire      [ 71: 0]         sq24_update_time        ; //更新时间 9
wire      [ 71: 0]         sq25_update_time        ; //更新时间 9
wire      [ 71: 0]         sq26_update_time        ; //更新时间 9
wire      [ 71: 0]         sq27_update_time        ; //更新时间 9
wire      [ 71: 0]         sq28_update_time        ; //更新时间 9
wire      [ 71: 0]         sq29_update_time        ; //更新时间 9
wire      [ 71: 0]         sq30_update_time        ; //更新时间 9
wire      [ 71: 0]         sq31_update_time        ; //更新时间 9

wire      [ 31: 0]         sq00_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq01_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq02_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq03_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq04_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq05_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq06_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq07_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq08_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq09_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq10_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq11_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq12_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq13_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq14_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq15_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq16_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq17_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq18_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq19_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq20_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq21_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq22_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq23_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq24_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq25_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq26_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq27_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq28_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq29_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq30_update_ms          ; //更新毫秒 4
wire      [ 31: 0]         sq31_update_ms          ; //更新毫秒 4

wire      [ 63: 0]         sq00_new_price          ; //最新价 8
wire      [ 63: 0]         sq01_new_price          ; //最新价 8
wire      [ 63: 0]         sq02_new_price          ; //最新价 8
wire      [ 63: 0]         sq03_new_price          ; //最新价 8
wire      [ 63: 0]         sq04_new_price          ; //最新价 8
wire      [ 63: 0]         sq05_new_price          ; //最新价 8
wire      [ 63: 0]         sq06_new_price          ; //最新价 8
wire      [ 63: 0]         sq07_new_price          ; //最新价 8
wire      [ 63: 0]         sq08_new_price          ; //最新价 8
wire      [ 63: 0]         sq09_new_price          ; //最新价 8
wire      [ 63: 0]         sq10_new_price          ; //最新价 8
wire      [ 63: 0]         sq11_new_price          ; //最新价 8
wire      [ 63: 0]         sq12_new_price          ; //最新价 8
wire      [ 63: 0]         sq13_new_price          ; //最新价 8
wire      [ 63: 0]         sq14_new_price          ; //最新价 8
wire      [ 63: 0]         sq15_new_price          ; //最新价 8
wire      [ 63: 0]         sq16_new_price          ; //最新价 8
wire      [ 63: 0]         sq17_new_price          ; //最新价 8
wire      [ 63: 0]         sq18_new_price          ; //最新价 8
wire      [ 63: 0]         sq19_new_price          ; //最新价 8
wire      [ 63: 0]         sq20_new_price          ; //最新价 8
wire      [ 63: 0]         sq21_new_price          ; //最新价 8
wire      [ 63: 0]         sq22_new_price          ; //最新价 8
wire      [ 63: 0]         sq23_new_price          ; //最新价 8
wire      [ 63: 0]         sq24_new_price          ; //最新价 8
wire      [ 63: 0]         sq25_new_price          ; //最新价 8
wire      [ 63: 0]         sq26_new_price          ; //最新价 8
wire      [ 63: 0]         sq27_new_price          ; //最新价 8
wire      [ 63: 0]         sq28_new_price          ; //最新价 8
wire      [ 63: 0]         sq29_new_price          ; //最新价 8
wire      [ 63: 0]         sq30_new_price          ; //最新价 8
wire      [ 63: 0]         sq31_new_price          ; //最新价 8

wire      [ 31: 0]         sq00_turnover           ; //成交量 4
wire      [ 31: 0]         sq01_turnover           ; //成交量 4
wire      [ 31: 0]         sq02_turnover           ; //成交量 4
wire      [ 31: 0]         sq03_turnover           ; //成交量 4
wire      [ 31: 0]         sq04_turnover           ; //成交量 4
wire      [ 31: 0]         sq05_turnover           ; //成交量 4
wire      [ 31: 0]         sq06_turnover           ; //成交量 4
wire      [ 31: 0]         sq07_turnover           ; //成交量 4
wire      [ 31: 0]         sq08_turnover           ; //成交量 4
wire      [ 31: 0]         sq09_turnover           ; //成交量 4
wire      [ 31: 0]         sq10_turnover           ; //成交量 4
wire      [ 31: 0]         sq11_turnover           ; //成交量 4
wire      [ 31: 0]         sq12_turnover           ; //成交量 4
wire      [ 31: 0]         sq13_turnover           ; //成交量 4
wire      [ 31: 0]         sq14_turnover           ; //成交量 4
wire      [ 31: 0]         sq15_turnover           ; //成交量 4
wire      [ 31: 0]         sq16_turnover           ; //成交量 4
wire      [ 31: 0]         sq17_turnover           ; //成交量 4
wire      [ 31: 0]         sq18_turnover           ; //成交量 4
wire      [ 31: 0]         sq19_turnover           ; //成交量 4
wire      [ 31: 0]         sq20_turnover           ; //成交量 4
wire      [ 31: 0]         sq21_turnover           ; //成交量 4
wire      [ 31: 0]         sq22_turnover           ; //成交量 4
wire      [ 31: 0]         sq23_turnover           ; //成交量 4
wire      [ 31: 0]         sq24_turnover           ; //成交量 4
wire      [ 31: 0]         sq25_turnover           ; //成交量 4
wire      [ 31: 0]         sq26_turnover           ; //成交量 4
wire      [ 31: 0]         sq27_turnover           ; //成交量 4
wire      [ 31: 0]         sq28_turnover           ; //成交量 4
wire      [ 31: 0]         sq29_turnover           ; //成交量 4
wire      [ 31: 0]         sq30_turnover           ; //成交量 4
wire      [ 31: 0]         sq31_turnover           ; //成交量 4

wire      [ 63: 0]         sq00_volume             ; //成交额 8   
wire      [ 63: 0]         sq01_volume             ; //成交额 8   
wire      [ 63: 0]         sq02_volume             ; //成交额 8   
wire      [ 63: 0]         sq03_volume             ; //成交额 8   
wire      [ 63: 0]         sq04_volume             ; //成交额 8   
wire      [ 63: 0]         sq05_volume             ; //成交额 8   
wire      [ 63: 0]         sq06_volume             ; //成交额 8   
wire      [ 63: 0]         sq07_volume             ; //成交额 8
wire      [ 63: 0]         sq08_volume             ; //成交额 8   
wire      [ 63: 0]         sq09_volume             ; //成交额 8   
wire      [ 63: 0]         sq10_volume             ; //成交额 8   
wire      [ 63: 0]         sq11_volume             ; //成交额 8   
wire      [ 63: 0]         sq12_volume             ; //成交额 8   
wire      [ 63: 0]         sq13_volume             ; //成交额 8   
wire      [ 63: 0]         sq14_volume             ; //成交额 8   
wire      [ 63: 0]         sq15_volume             ; //成交额 8
wire      [ 63: 0]         sq16_volume             ; //成交额 8   
wire      [ 63: 0]         sq17_volume             ; //成交额 8   
wire      [ 63: 0]         sq18_volume             ; //成交额 8   
wire      [ 63: 0]         sq19_volume             ; //成交额 8   
wire      [ 63: 0]         sq20_volume             ; //成交额 8   
wire      [ 63: 0]         sq21_volume             ; //成交额 8   
wire      [ 63: 0]         sq22_volume             ; //成交额 8   
wire      [ 63: 0]         sq23_volume             ; //成交额 8
wire      [ 63: 0]         sq24_volume             ; //成交额 8   
wire      [ 63: 0]         sq25_volume             ; //成交额 8   
wire      [ 63: 0]         sq26_volume             ; //成交额 8   
wire      [ 63: 0]         sq27_volume             ; //成交额 8   
wire      [ 63: 0]         sq28_volume             ; //成交额 8   
wire      [ 63: 0]         sq29_volume             ; //成交额 8   
wire      [ 63: 0]         sq30_volume             ; //成交额 8   
wire      [ 63: 0]         sq31_volume             ; //成交额 8

wire      [ 63: 0]         sq00_position           ; //持仓量 8
wire      [ 63: 0]         sq01_position           ; //持仓量 8
wire      [ 63: 0]         sq02_position           ; //持仓量 8
wire      [ 63: 0]         sq03_position           ; //持仓量 8
wire      [ 63: 0]         sq04_position           ; //持仓量 8
wire      [ 63: 0]         sq05_position           ; //持仓量 8
wire      [ 63: 0]         sq06_position           ; //持仓量 8
wire      [ 63: 0]         sq07_position           ; //持仓量 8
wire      [ 63: 0]         sq08_position           ; //持仓量 8
wire      [ 63: 0]         sq09_position           ; //持仓量 8
wire      [ 63: 0]         sq10_position           ; //持仓量 8
wire      [ 63: 0]         sq11_position           ; //持仓量 8
wire      [ 63: 0]         sq12_position           ; //持仓量 8
wire      [ 63: 0]         sq13_position           ; //持仓量 8
wire      [ 63: 0]         sq14_position           ; //持仓量 8
wire      [ 63: 0]         sq15_position           ; //持仓量 8
wire      [ 63: 0]         sq16_position           ; //持仓量 8
wire      [ 63: 0]         sq17_position           ; //持仓量 8
wire      [ 63: 0]         sq18_position           ; //持仓量 8
wire      [ 63: 0]         sq19_position           ; //持仓量 8
wire      [ 63: 0]         sq20_position           ; //持仓量 8
wire      [ 63: 0]         sq21_position           ; //持仓量 8
wire      [ 63: 0]         sq22_position           ; //持仓量 8
wire      [ 63: 0]         sq23_position           ; //持仓量 8
wire      [ 63: 0]         sq24_position           ; //持仓量 8
wire      [ 63: 0]         sq25_position           ; //持仓量 8
wire      [ 63: 0]         sq26_position           ; //持仓量 8
wire      [ 63: 0]         sq27_position           ; //持仓量 8
wire      [ 63: 0]         sq28_position           ; //持仓量 8
wire      [ 63: 0]         sq29_position           ; //持仓量 8
wire      [ 63: 0]         sq30_position           ; //持仓量 8
wire      [ 63: 0]         sq31_position           ; //持仓量 8

wire      [ 63: 0]         sq00_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq01_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq02_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq03_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq04_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq05_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq06_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq07_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq08_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq09_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq10_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq11_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq12_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq13_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq14_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq15_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq16_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq17_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq18_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq19_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq20_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq21_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq22_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq23_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq24_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq25_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq26_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq27_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq28_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq29_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq30_purchase_price     ; //申买价 8
wire      [ 63: 0]         sq31_purchase_price     ; //申买价 8

wire      [ 31: 0]         sq00_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq01_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq02_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq03_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq04_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq05_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq06_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq07_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq08_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq09_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq10_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq11_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq12_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq13_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq14_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq15_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq16_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq17_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq18_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq19_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq20_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq21_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq22_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq23_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq24_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq25_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq26_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq27_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq28_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq29_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq30_buy_quantity       ; //申买量 4
wire      [ 31: 0]         sq31_buy_quantity       ; //申买量 4

wire      [ 63: 0]         sq00_sell_price         ; //申买价 8
wire      [ 63: 0]         sq01_sell_price         ; //申买价 8
wire      [ 63: 0]         sq02_sell_price         ; //申买价 8
wire      [ 63: 0]         sq03_sell_price         ; //申买价 8
wire      [ 63: 0]         sq04_sell_price         ; //申买价 8
wire      [ 63: 0]         sq05_sell_price         ; //申买价 8
wire      [ 63: 0]         sq06_sell_price         ; //申买价 8
wire      [ 63: 0]         sq07_sell_price         ; //申买价 8
wire      [ 63: 0]         sq08_sell_price         ; //申买价 8
wire      [ 63: 0]         sq09_sell_price         ; //申买价 8
wire      [ 63: 0]         sq10_sell_price         ; //申买价 8
wire      [ 63: 0]         sq11_sell_price         ; //申买价 8
wire      [ 63: 0]         sq12_sell_price         ; //申买价 8
wire      [ 63: 0]         sq13_sell_price         ; //申买价 8
wire      [ 63: 0]         sq14_sell_price         ; //申买价 8
wire      [ 63: 0]         sq15_sell_price         ; //申买价 8
wire      [ 63: 0]         sq16_sell_price         ; //申买价 8
wire      [ 63: 0]         sq17_sell_price         ; //申买价 8
wire      [ 63: 0]         sq18_sell_price         ; //申买价 8
wire      [ 63: 0]         sq19_sell_price         ; //申买价 8
wire      [ 63: 0]         sq20_sell_price         ; //申买价 8
wire      [ 63: 0]         sq21_sell_price         ; //申买价 8
wire      [ 63: 0]         sq22_sell_price         ; //申买价 8
wire      [ 63: 0]         sq23_sell_price         ; //申买价 8
wire      [ 63: 0]         sq24_sell_price         ; //申买价 8
wire      [ 63: 0]         sq25_sell_price         ; //申买价 8
wire      [ 63: 0]         sq26_sell_price         ; //申买价 8
wire      [ 63: 0]         sq27_sell_price         ; //申买价 8
wire      [ 63: 0]         sq28_sell_price         ; //申买价 8
wire      [ 63: 0]         sq29_sell_price         ; //申买价 8
wire      [ 63: 0]         sq30_sell_price         ; //申买价 8
wire      [ 63: 0]         sq31_sell_price         ; //申买价 8

wire      [ 31: 0]         sq00_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq01_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq02_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq03_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq04_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq05_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq06_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq07_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq08_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq09_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq10_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq11_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq12_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq13_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq14_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq15_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq16_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq17_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq18_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq19_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq20_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq21_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq22_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq23_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq24_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq25_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq26_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq27_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq28_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq29_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq30_sell_quantity      ; //申卖量 4
wire      [ 31: 0]         sq31_sell_quantity      ; //申卖量 4

wire                       sq00_market_rdy         ;
wire                       sq01_market_rdy         ;
wire                       sq02_market_rdy         ;
wire                       sq03_market_rdy         ;
wire                       sq04_market_rdy         ;
wire                       sq05_market_rdy         ;
wire                       sq06_market_rdy         ;
wire                       sq07_market_rdy         ;
wire                       sq08_market_rdy         ;
wire                       sq09_market_rdy         ;
wire                       sq10_market_rdy         ;
wire                       sq11_market_rdy         ;
wire                       sq12_market_rdy         ;
wire                       sq13_market_rdy         ;
wire                       sq14_market_rdy         ;
wire                       sq15_market_rdy         ;
wire                       sq16_market_rdy         ;
wire                       sq17_market_rdy         ;
wire                       sq18_market_rdy         ;
wire                       sq19_market_rdy         ;
wire                       sq20_market_rdy         ;
wire                       sq21_market_rdy         ;
wire                       sq22_market_rdy         ;
wire                       sq23_market_rdy         ;
wire                       sq24_market_rdy         ;
wire                       sq25_market_rdy         ;
wire                       sq26_market_rdy         ;
wire                       sq27_market_rdy         ;
wire                       sq28_market_rdy         ;
wire                       sq29_market_rdy         ;
wire                       sq30_market_rdy         ;
wire                       sq31_market_rdy         ;

wire      [ 15: 0]         sq_cut_len_reg       ;

wire                       sq_shift_full_flag   ;

wire     [31:0]            current_cut_now_sqid_reg_vld  ;

wire     [31:0]            current_cut_done_sq00id_reg   ;
wire     [31:0]            current_cut_done_sq01id_reg   ;
wire     [31:0]            current_cut_done_sq02id_reg   ;
wire     [31:0]            current_cut_done_sq03id_reg   ;
wire     [31:0]            current_cut_done_sq04id_reg   ;
wire     [31:0]            current_cut_done_sq05id_reg   ;
wire     [31:0]            current_cut_done_sq06id_reg   ;
wire     [31:0]            current_cut_done_sq07id_reg   ;
wire     [31:0]            current_cut_done_sq08id_reg   ;
wire     [31:0]            current_cut_done_sq09id_reg   ;
wire     [31:0]            current_cut_done_sq10id_reg   ;
wire     [31:0]            current_cut_done_sq11id_reg   ;
wire     [31:0]            current_cut_done_sq12id_reg   ;
wire     [31:0]            current_cut_done_sq13id_reg   ;
wire     [31:0]            current_cut_done_sq14id_reg   ;
wire     [31:0]            current_cut_done_sq15id_reg   ;
wire     [31:0]            current_cut_done_sq16id_reg   ;
wire     [31:0]            current_cut_done_sq17id_reg   ;
wire     [31:0]            current_cut_done_sq18id_reg   ;
wire     [31:0]            current_cut_done_sq19id_reg   ;
wire     [31:0]            current_cut_done_sq20id_reg   ;
wire     [31:0]            current_cut_done_sq21id_reg   ;
wire     [31:0]            current_cut_done_sq22id_reg   ;
wire     [31:0]            current_cut_done_sq23id_reg   ;
wire     [31:0]            current_cut_done_sq24id_reg   ;
wire     [31:0]            current_cut_done_sq25id_reg   ;
wire     [31:0]            current_cut_done_sq26id_reg   ;
wire     [31:0]            current_cut_done_sq27id_reg   ;
wire     [31:0]            current_cut_done_sq28id_reg   ;
wire     [31:0]            current_cut_done_sq29id_reg   ;
wire     [31:0]            current_cut_done_sq30id_reg   ;
wire     [31:0]            current_cut_done_sq31id_reg   ;
wire     [31:0]            current_sqcut_done            ;

wire     [15:0]            sub_sqcut_len_reg             ;

wire     [31:0]            sq_cut_on                     ;
wire     [31:0]            sq_cut_first_on               ;

wire                       st_rx_start_dly        ; 
wire     [ 3:0]            st_rx_offset_dly       ;
wire                       st_rx_end_dly          ; 
wire                       st_rx_valid_dly        ; 
wire     [63:0]            st_rx_data_dly         ; 
wire     [ 2:0]            st_rx_empty_dly        ; 
wire     [15:0]            st_rx_cnt_dly          ; 
wire     [15:0]            first_sync_len_byte_dly;                                      
wire     [31:0]            tcp_sqmatch_flag_dly   ;  //match with pre  SQ tcp frame 
wire                       seq_err_flag_dly       ;
wire                       tcp_sqmatch_flag_1bit_dly ;
wire     [15:0]            tcp_payload_len_dly    ;


wire     [15:0]            sq00_cut_len_reg    ;
wire     [15:0]            sq01_cut_len_reg    ;
wire     [15:0]            sq02_cut_len_reg    ;
wire     [15:0]            sq03_cut_len_reg    ;
wire     [15:0]            sq04_cut_len_reg    ;
wire     [15:0]            sq05_cut_len_reg    ;
wire     [15:0]            sq06_cut_len_reg    ;
wire     [15:0]            sq07_cut_len_reg    ;
wire     [15:0]            sq08_cut_len_reg    ;
wire     [15:0]            sq09_cut_len_reg    ;
wire     [15:0]            sq10_cut_len_reg    ;
wire     [15:0]            sq11_cut_len_reg    ;
wire     [15:0]            sq12_cut_len_reg    ;
wire     [15:0]            sq13_cut_len_reg    ;
wire     [15:0]            sq14_cut_len_reg    ;
wire     [15:0]            sq15_cut_len_reg    ;
wire     [15:0]            sq16_cut_len_reg    ;
wire     [15:0]            sq17_cut_len_reg    ;
wire     [15:0]            sq18_cut_len_reg    ;
wire     [15:0]            sq19_cut_len_reg    ;
wire     [15:0]            sq20_cut_len_reg    ;
wire     [15:0]            sq21_cut_len_reg    ;
wire     [15:0]            sq22_cut_len_reg    ;
wire     [15:0]            sq23_cut_len_reg    ;
wire     [15:0]            sq24_cut_len_reg    ;
wire     [15:0]            sq25_cut_len_reg    ;
wire     [15:0]            sq26_cut_len_reg    ;
wire     [15:0]            sq27_cut_len_reg    ;
wire     [15:0]            sq28_cut_len_reg    ;
wire     [15:0]            sq29_cut_len_reg    ;
wire     [15:0]            sq30_cut_len_reg    ;
wire     [15:0]            sq31_cut_len_reg    ;


wire                       current_sqid_reg_flag  ;


output   [3:0]         debug_discard_calc_cnt1  ;
output                 debug_st_shift_full_flag ;

output   [5:0]         debug_st_shift_scnt     ;
output                 debug_st_shift_en       ;





output   [15:0]            st_rx_cnt_reg        ;
output   [ 5:0]            st_shift_ccnt        ;




wire     [3:0]         debug_discard_calc_cnt1  ;
wire                   debug_st_shift_full_flag ;

wire      [5:0]         debug_st_shift_scnt     ;
wire                    debug_st_shift_en       ;




wire     [15:0]            st_rx_cnt_reg        ;
wire     [ 5:0]            st_shift_ccnt        ;
wire     [15:0]            sync_len_byte        ;
wire                       sq_frame_flag        ;
wire   [ 15:0]            sync_fisrt_byte     ;
wire   [ 31:0]            sync_four_byte      ;

wire    sq00_shift_full_flag ;  
wire    sq01_shift_full_flag ;
wire    sq02_shift_full_flag ;
wire    sq03_shift_full_flag ;
wire    sq04_shift_full_flag ;
wire    sq05_shift_full_flag ;
wire    sq06_shift_full_flag ;
wire    sq07_shift_full_flag ;
wire    sq08_shift_full_flag ;
wire    sq09_shift_full_flag ;
wire    sq10_shift_full_flag ;
wire    sq11_shift_full_flag ;
wire    sq12_shift_full_flag ;
wire    sq13_shift_full_flag ;
wire    sq14_shift_full_flag ;
wire    sq15_shift_full_flag ;
wire    sq16_shift_full_flag ;  
wire    sq17_shift_full_flag ;
wire    sq18_shift_full_flag ;
wire    sq19_shift_full_flag ;
wire    sq20_shift_full_flag ;
wire    sq21_shift_full_flag ;
wire    sq22_shift_full_flag ;
wire    sq23_shift_full_flag ;
wire    sq24_shift_full_flag ;
wire    sq25_shift_full_flag ;
wire    sq26_shift_full_flag ;
wire    sq27_shift_full_flag ;
wire    sq28_shift_full_flag ;
wire    sq29_shift_full_flag ;
wire    sq30_shift_full_flag ;
wire    sq31_shift_full_flag ;



wire  [31:0]     sq_market_rdy ;

assign       sq_market_rdy[ 0]   =    sq00_market_rdy         ;
assign       sq_market_rdy[ 1]   =    sq01_market_rdy         ;
assign       sq_market_rdy[ 2]   =    sq02_market_rdy         ;
assign       sq_market_rdy[ 3]   =    sq03_market_rdy         ;
assign       sq_market_rdy[ 4]   =    sq04_market_rdy         ;
assign       sq_market_rdy[ 5]   =    sq05_market_rdy         ;
assign       sq_market_rdy[ 6]   =    sq06_market_rdy         ;
assign       sq_market_rdy[ 7]   =    sq07_market_rdy         ;
assign       sq_market_rdy[ 8]   =    sq08_market_rdy         ;
assign       sq_market_rdy[ 9]   =    sq09_market_rdy         ;
assign       sq_market_rdy[10]   =    sq10_market_rdy         ;
assign       sq_market_rdy[11]   =    sq11_market_rdy         ;
assign       sq_market_rdy[12]   =    sq12_market_rdy         ;
assign       sq_market_rdy[13]   =    sq13_market_rdy         ;
assign       sq_market_rdy[14]   =    sq14_market_rdy         ;
assign       sq_market_rdy[15]   =    sq15_market_rdy         ;
assign       sq_market_rdy[16]   =    sq16_market_rdy         ;
assign       sq_market_rdy[17]   =    sq17_market_rdy         ;
assign       sq_market_rdy[18]   =    sq18_market_rdy         ;
assign       sq_market_rdy[19]   =    sq19_market_rdy         ;
assign       sq_market_rdy[20]   =    sq20_market_rdy         ;
assign       sq_market_rdy[21]   =    sq21_market_rdy         ;
assign       sq_market_rdy[22]   =    sq22_market_rdy         ;
assign       sq_market_rdy[23]   =    sq23_market_rdy         ;
assign       sq_market_rdy[24]   =    sq24_market_rdy         ;
assign       sq_market_rdy[25]   =    sq25_market_rdy         ;
assign       sq_market_rdy[26]   =    sq26_market_rdy         ;
assign       sq_market_rdy[27]   =    sq27_market_rdy         ;
assign       sq_market_rdy[28]   =    sq28_market_rdy         ;
assign       sq_market_rdy[29]   =    sq29_market_rdy         ;
assign       sq_market_rdy[30]   =    sq30_market_rdy         ;
assign       sq_market_rdy[31]   =    sq31_market_rdy         ;


//////////////////////////////////////////////////////////////////////////////////////////////
assign   sq_shift_full_flag  =  sq00_shift_full_flag ||  
                                sq01_shift_full_flag ||
								sq02_shift_full_flag ||
								sq03_shift_full_flag ||
								sq04_shift_full_flag ||
								sq05_shift_full_flag ||
								sq06_shift_full_flag ||
								sq07_shift_full_flag ||
								sq08_shift_full_flag ||
								sq09_shift_full_flag ||
								sq10_shift_full_flag ||
								sq11_shift_full_flag ||
								sq12_shift_full_flag ||
								sq13_shift_full_flag ||
								sq14_shift_full_flag ||
								sq15_shift_full_flag ||
								sq16_shift_full_flag ||  
                                sq17_shift_full_flag ||
								sq18_shift_full_flag ||
								sq19_shift_full_flag ||
								sq20_shift_full_flag ||
								sq21_shift_full_flag ||
								sq22_shift_full_flag ||
								sq23_shift_full_flag ||
								sq24_shift_full_flag ||
								sq25_shift_full_flag ||
								sq26_shift_full_flag ||
								sq27_shift_full_flag ||
								sq28_shift_full_flag ||
								sq29_shift_full_flag ||
								sq30_shift_full_flag ||
								sq31_shift_full_flag ;





filter_rx_fsm    filter_rx_fsm  (
.clk                ( clk                  )   ,
.rst_n              ( rst_n                )   ,


.params_current_sqid_reg_add (params_current_sqid_reg_add),
.params_current_sqid_reg_cnt (params_current_sqid_reg_cnt),
.params_current_sqid_reg_rst_cnt(params_current_sqid_reg_rst_cnt),

.sq_market_rdy      (sq_market_rdy         )   ,


.debug_discard_calc_cnt1 (debug_discard_calc_cnt1),
.debug_st_shift_full_flag(debug_st_shift_full_flag),
.debug_st_shift_scnt(debug_st_shift_scnt)     ,
.debug_st_shift_en  (debug_st_shift_en)      ,


.fir_rx_cstate   (fir_rx_cstate ),
.st_rx_cnt_reg                (st_rx_cnt_reg              ),
.st_shift_ccnt                (st_shift_ccnt              ),
.sync_len_byte                (sync_len_byte              ),
.sync_fisrt_byte    (sync_fisrt_byte),
.sync_four_byte     (sync_four_byte),
.sq_frame_flag                (sq_frame_flag              ),

.params_frame_type_byte       (params_frame_type_byte     ),

.params_current_sqid_reg_ro   (params_current_sqid_reg_ro),
.params_filter_rst            (params_filter_rst),

.params_03e9_type  (params_03e9_type),
.params_1389_type  (params_1389_type),
.params_07d0_type  (params_07d0_type),


.sub_sqcut_len_reg            (sub_sqcut_len_reg          ),

.current_sqid_reg_flag        (current_sqid_reg_flag      ),

.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld),
.current_cut_done_sq00id_reg  (current_cut_done_sq00id_reg),
.current_cut_done_sq01id_reg  (current_cut_done_sq01id_reg),
.current_cut_done_sq02id_reg  (current_cut_done_sq02id_reg),
.current_cut_done_sq03id_reg  (current_cut_done_sq03id_reg),
.current_cut_done_sq04id_reg  (current_cut_done_sq04id_reg),
.current_cut_done_sq05id_reg  (current_cut_done_sq05id_reg),
.current_cut_done_sq06id_reg  (current_cut_done_sq06id_reg),
.current_cut_done_sq07id_reg  (current_cut_done_sq07id_reg),
.current_cut_done_sq08id_reg  (current_cut_done_sq08id_reg),
.current_cut_done_sq09id_reg  (current_cut_done_sq09id_reg),
.current_cut_done_sq10id_reg  (current_cut_done_sq10id_reg),
.current_cut_done_sq11id_reg  (current_cut_done_sq11id_reg),
.current_cut_done_sq12id_reg  (current_cut_done_sq12id_reg),
.current_cut_done_sq13id_reg  (current_cut_done_sq13id_reg),
.current_cut_done_sq14id_reg  (current_cut_done_sq14id_reg),
.current_cut_done_sq15id_reg  (current_cut_done_sq15id_reg),
.current_cut_done_sq16id_reg  (current_cut_done_sq16id_reg),
.current_cut_done_sq17id_reg  (current_cut_done_sq17id_reg),
.current_cut_done_sq18id_reg  (current_cut_done_sq18id_reg),
.current_cut_done_sq19id_reg  (current_cut_done_sq19id_reg),
.current_cut_done_sq20id_reg  (current_cut_done_sq20id_reg),
.current_cut_done_sq21id_reg  (current_cut_done_sq21id_reg),
.current_cut_done_sq22id_reg  (current_cut_done_sq22id_reg),
.current_cut_done_sq23id_reg  (current_cut_done_sq23id_reg),
.current_cut_done_sq24id_reg  (current_cut_done_sq24id_reg),
.current_cut_done_sq25id_reg  (current_cut_done_sq25id_reg),
.current_cut_done_sq26id_reg  (current_cut_done_sq26id_reg),
.current_cut_done_sq27id_reg  (current_cut_done_sq27id_reg),
.current_cut_done_sq28id_reg  (current_cut_done_sq28id_reg),
.current_cut_done_sq29id_reg  (current_cut_done_sq29id_reg),
.current_cut_done_sq30id_reg  (current_cut_done_sq30id_reg),
.current_cut_done_sq31id_reg  (current_cut_done_sq31id_reg),
.current_sqcut_done           (current_sqcut_done         ),

.sq_cut_on_reg                (sq_cut_on                  ),
.sq_cut_first_on              (sq_cut_first_on            ),

.st_rx_start_pre         ( st_rx_start&&st_rx_valid     )   , 
   
.st_rx_start            ( st_rx_start_dly               )   , 
.st_rx_offset           ( st_rx_offset_dly              )   ,
.st_rx_end              ( st_rx_end_dly                 )   , 
.st_rx_valid            ( st_rx_valid_dly               )   , 
.st_rx_ready            ( st_rx_ready                   )   ,
.st_rx_data             ( st_rx_data_dly                )   , 
.st_rx_empty            ( st_rx_empty_dly               )   , 
.st_rx_cnt              ( st_rx_cnt_dly                 )   ,   
.first_sync_len_byte    ( first_sync_len_byte_dly       )   ,              
.tcp_sqmatch_flag       ( tcp_sqmatch_flag_1bit_dly     )   ,  //match with pre  SQ tcp frame 
.tcp_sqmatch_flag_reg   ( tcp_sqmatch_flag_dly          )   ,  //match with pre  SQ tcp frame 
.tcp_payload_len        ( tcp_payload_len_dly           )   ,

.seq_err_flag           (seq_err_flag_dly               )   ,

.error_flag         ( error_flag           )   ,
//.sq_cut_flag        ( sq_cut_flag          )   ,  //cut _flag   
//.sq_cut_reset       ( sq_cut_reset         )   ,  
            
.fir_r_idle_st       ( fir_r_idle_st        )   ,  
.fir_r_sqcuth_st     (fir_r_sqcuth_st       )   ,
.fir_r_vsync_st      (fir_r_vsync_st        )   ,
.fir_r_sqcut_st      (fir_r_sqcut_st        )   ,
.fir_r_sqcut_end_st  (fir_r_sqcut_end_st    )   ,
.fir_r_sqrcut_st     (fir_r_sqrcut_st       )   ,
.fir_r_sqrcut_end_st (fir_r_sqrcut_end_st   )   ,
.fir_r_rjudge_st     (fir_r_rjudge_st       )   ,
                
.sq_rx_start        ( sq_rx_start          )   , 
.sq_rx_end          ( sq_rx_end            )   , 
.sq_rx_valid        ( sq_rx_valid          )   , 
.sq_rx_data         ( sq_rx_data           )   , 
.sq_rx_empty        ( sq_rx_empty          )   ,  

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

.current_sqid_reg   ( current_sqid_reg     )   ,
.current_sqid_reg_vld (current_sqid_reg_vld)   ,
.sq_shift_full_flag ( sq_shift_full_flag   )   ,
.market_explain     ( market_explain       )   , //市场说明 3
.info_classify      ( info_classify        )   , //信息分类 1
.dialog_num         ( dialog_num           )   , //会话编号 4
.contract_flag      ( contract_flag        )   , //合约标志 1
.contract_num       ( contract_num         )   , //合约编号 4
.contract_code      ( contract_code        )   , //合约代码 22
.update_time        ( update_time          )   , //更新时间 9
.update_ms          ( update_ms            )   , //更新毫秒 4
.new_price          ( new_price            )   , //最新价 8
.turnover           ( turnover             )   , //成交量 4
.volume             ( volume               )   , //成交额 8   
.position           ( position             )   , //持仓量 8
.purchase_price     ( purchase_price       )   , //申买价 8
.buy_quantity       ( buy_quantity         )   , //申买量 4
.sell_price         ( sell_price           )   , //申买价 8
.sell_quantity      ( sell_quantity        )   , //申卖量 4
.market_rdy         ( market_rdy           )   

);

filter_cut_rx_fsm  sq_cut_rx_fsm_00  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,
.current_cut_done_sqid_reg   ( current_cut_done_sq00id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[0] ),
.current_sqcut_done          ( current_sqcut_done[0]        )  ,                                     
.st_rx_start                 ( sq_rx_start[0]               )  , 
.st_rx_end                   ( sq_rx_end[0]                 )  , 
.st_rx_valid                 ( sq_rx_valid[0]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[0]          )  , 
.sq_cut_reset                ( sq_cut_reset[0]              )  , 
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq00_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq00_cut_len_reg             )  ,
.market_explain              ( sq00_market_explain          )  , //市场说明 3
.info_classify               ( sq00_info_classify           )  , //信息分类 1
.dialog_num                  ( sq00_dialog_num              )  , //会话编号 4
.contract_flag               ( sq00_contract_flag           )  , //合约标志 1
.contract_num                ( sq00_contract_num            )  , //合约编号 4
.contract_code               ( sq00_contract_code           )  , //合约代码 22
.update_time                 ( sq00_update_time             )  , //更新时间 9
.update_ms                   ( sq00_update_ms               )  , //更新毫秒 4
.new_price                   ( sq00_new_price               )  , //最新价 8
.turnover                    ( sq00_turnover                )  , //成交量 4
.volume                      ( sq00_volume                  )  , //成交额 8   
.position                    ( sq00_position                )  , //持仓量 8
.purchase_price              ( sq00_purchase_price          )  , //申买价 8
.buy_quantity                ( sq00_buy_quantity            )  , //申买量 4
.sell_price                  ( sq00_sell_price              )  , //申买价 8
.sell_quantity               ( sq00_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq00_market_rdy              )  
);


filter_cut_rx_fsm  sq_cut_rx_fsm_01  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,   
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,
.current_cut_done_sqid_reg   ( current_cut_done_sq01id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[1] ),
.current_sqcut_done          ( current_sqcut_done[1]        )  ,                                     
.st_rx_start                 ( sq_rx_start[1]               )  , 
.st_rx_end                   ( sq_rx_end[1]                 )  , 
.st_rx_valid                 ( sq_rx_valid[1]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[1]          )  ,  
.sq_cut_reset                ( sq_cut_reset[1]              )  ,    
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_01               )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq01_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq01_cut_len_reg             )  ,
.market_explain              ( sq01_market_explain          )  , //市场说明 3
.info_classify               ( sq01_info_classify           )  , //信息分类 1
.dialog_num                  ( sq01_dialog_num              )  , //会话编号 4
.contract_flag               ( sq01_contract_flag           )  , //合约标志 1
.contract_num                ( sq01_contract_num            )  , //合约编号 4
.contract_code               ( sq01_contract_code           )  , //合约代码 22
.update_time                 ( sq01_update_time             )  , //更新时间 9
.update_ms                   ( sq01_update_ms               )  , //更新毫秒 4
.new_price                   ( sq01_new_price               )  , //最新价 8
.turnover                    ( sq01_turnover                )  , //成交量 4
.volume                      ( sq01_volume                  )  , //成交额 8   
.position                    ( sq01_position                )  , //持仓量 8
.purchase_price              ( sq01_purchase_price          )  , //申买价 8
.buy_quantity                ( sq01_buy_quantity            )  , //申买量 4
.sell_price                  ( sq01_sell_price              )  , //申买价 8
.sell_quantity               ( sq01_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq01_market_rdy              )  
);


filter_cut_rx_fsm  sq_cut_rx_fsm_02  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq02id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[2] ),
.current_sqcut_done          ( current_sqcut_done[2]        )  ,                                     
.st_rx_start                 ( sq_rx_start[2]               )  , 
.st_rx_end                   ( sq_rx_end[2]                 )  , 
.st_rx_valid                 ( sq_rx_valid[2]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[2]              )  , 
.sq_cut_reset                ( sq_cut_reset[2]              )  ,      
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_02                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq02_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq02_cut_len_reg             )  ,
.market_explain              ( sq02_market_explain          )  , //市场说明 3
.info_classify               ( sq02_info_classify           )  , //信息分类 1
.dialog_num                  ( sq02_dialog_num              )  , //会话编号 4
.contract_flag               ( sq02_contract_flag           )  , //合约标志 1
.contract_num                ( sq02_contract_num            )  , //合约编号 4
.contract_code               ( sq02_contract_code           )  , //合约代码 22
.update_time                 ( sq02_update_time             )  , //更新时间 9
.update_ms                   ( sq02_update_ms               )  , //更新毫秒 4
.new_price                   ( sq02_new_price               )  , //最新价 8
.turnover                    ( sq02_turnover                )  , //成交量 4
.volume                      ( sq02_volume                  )  , //成交额 8   
.position                    ( sq02_position                )  , //持仓量 8
.purchase_price              ( sq02_purchase_price          )  , //申买价 8
.buy_quantity                ( sq02_buy_quantity            )  , //申买量 4
.sell_price                  ( sq02_sell_price              )  , //申买价 8
.sell_quantity               ( sq02_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq02_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_03  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,   
.current_cut_done_sqid_reg   ( current_cut_done_sq03id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[3] ),
.current_sqcut_done          ( current_sqcut_done[3]        )  ,                                     
.st_rx_start                 ( sq_rx_start[3]               )  , 
.st_rx_end                   ( sq_rx_end[3]                 )  , 
.st_rx_valid                 ( sq_rx_valid[3]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[3]              )  ,
.sq_cut_reset                ( sq_cut_reset[3]              )  ,       
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_03                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq03_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq03_cut_len_reg             )  ,
.market_explain              ( sq03_market_explain          )  , //市场说明 3
.info_classify               ( sq03_info_classify           )  , //信息分类 1
.dialog_num                  ( sq03_dialog_num              )  , //会话编号 4
.contract_flag               ( sq03_contract_flag           )  , //合约标志 1
.contract_num                ( sq03_contract_num            )  , //合约编号 4
.contract_code               ( sq03_contract_code           )  , //合约代码 22
.update_time                 ( sq03_update_time             )  , //更新时间 9
.update_ms                   ( sq03_update_ms               )  , //更新毫秒 4
.new_price                   ( sq03_new_price               )  , //最新价 8
.turnover                    ( sq03_turnover                )  , //成交量 4
.volume                      ( sq03_volume                  )  , //成交额 8   
.position                    ( sq03_position                )  , //持仓量 8
.purchase_price              ( sq03_purchase_price          )  , //申买价 8
.buy_quantity                ( sq03_buy_quantity            )  , //申买量 4
.sell_price                  ( sq03_sell_price              )  , //申买价 8
.sell_quantity               ( sq03_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq03_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_04  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq04id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[4] ),
.current_sqcut_done          ( current_sqcut_done[4]        )  ,                                     
.st_rx_start                 ( sq_rx_start[4]               )  , 
.st_rx_end                   ( sq_rx_end[4]                 )  , 
.st_rx_valid                 ( sq_rx_valid[4]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[4]              )  , 
.sq_cut_reset                ( sq_cut_reset[4]              )  ,      
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_04                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq04_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq04_cut_len_reg             )  ,
.market_explain              ( sq04_market_explain          )  , //市场说明 3
.info_classify               ( sq04_info_classify           )  , //信息分类 1
.dialog_num                  ( sq04_dialog_num              )  , //会话编号 4
.contract_flag               ( sq04_contract_flag           )  , //合约标志 1
.contract_num                ( sq04_contract_num            )  , //合约编号 4
.contract_code               ( sq04_contract_code           )  , //合约代码 22
.update_time                 ( sq04_update_time             )  , //更新时间 9
.update_ms                   ( sq04_update_ms               )  , //更新毫秒 4
.new_price                   ( sq04_new_price               )  , //最新价 8
.turnover                    ( sq04_turnover                )  , //成交量 4
.volume                      ( sq04_volume                  )  , //成交额 8   
.position                    ( sq04_position                )  , //持仓量 8
.purchase_price              ( sq04_purchase_price          )  , //申买价 8
.buy_quantity                ( sq04_buy_quantity            )  , //申买量 4
.sell_price                  ( sq04_sell_price              )  , //申买价 8
.sell_quantity               ( sq04_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq04_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_05  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq05id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[5] ),
.current_sqcut_done          ( current_sqcut_done[5]        )  ,                                     
.st_rx_start                 ( sq_rx_start[5]               )  , 
.st_rx_end                   ( sq_rx_end[5]                 )  , 
.st_rx_valid                 ( sq_rx_valid[5]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[5]          )  ,  
.sq_cut_reset                ( sq_cut_reset[5]              )  ,     
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_05                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq05_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq05_cut_len_reg             )  ,
.market_explain              ( sq05_market_explain          )  , //市场说明 3
.info_classify               ( sq05_info_classify           )  , //信息分类 1
.dialog_num                  ( sq05_dialog_num              )  , //会话编号 4
.contract_flag               ( sq05_contract_flag           )  , //合约标志 1
.contract_num                ( sq05_contract_num            )  , //合约编号 4
.contract_code               ( sq05_contract_code           )  , //合约代码 22
.update_time                 ( sq05_update_time             )  , //更新时间 9
.update_ms                   ( sq05_update_ms               )  , //更新毫秒 4
.new_price                   ( sq05_new_price               )  , //最新价 8
.turnover                    ( sq05_turnover                )  , //成交量 4
.volume                      ( sq05_volume                  )  , //成交额 8   
.position                    ( sq05_position                )  , //持仓量 8
.purchase_price              ( sq05_purchase_price          )  , //申买价 8
.buy_quantity                ( sq05_buy_quantity            )  , //申买量 4
.sell_price                  ( sq05_sell_price              )  , //申买价 8
.sell_quantity               ( sq05_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq05_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_06  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq06id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[6] ),
.current_sqcut_done          ( current_sqcut_done[6]        )  ,                                     
.st_rx_start                 ( sq_rx_start[6]               )  , 
.st_rx_end                   ( sq_rx_end[6]                 )  , 
.st_rx_valid                 ( sq_rx_valid[6]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[6]              )  , 
.sq_cut_reset                ( sq_cut_reset[6]              )  ,      
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_06                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq06_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq06_cut_len_reg             )  ,
.market_explain              ( sq06_market_explain          )  , //市场说明 3
.info_classify               ( sq06_info_classify           )  , //信息分类 1
.dialog_num                  ( sq06_dialog_num              )  , //会话编号 4
.contract_flag               ( sq06_contract_flag           )  , //合约标志 1
.contract_num                ( sq06_contract_num            )  , //合约编号 4
.contract_code               ( sq06_contract_code           )  , //合约代码 22
.update_time                 ( sq06_update_time             )  , //更新时间 9
.update_ms                   ( sq06_update_ms               )  , //更新毫秒 4
.new_price                   ( sq06_new_price               )  , //最新价 8
.turnover                    ( sq06_turnover                )  , //成交量 4
.volume                      ( sq06_volume                  )  , //成交额 8   
.position                    ( sq06_position                )  , //持仓量 8
.purchase_price              ( sq06_purchase_price          )  , //申买价 8
.buy_quantity                ( sq06_buy_quantity            )  , //申买量 4
.sell_price                  ( sq06_sell_price              )  , //申买价 8
.sell_quantity               ( sq06_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq06_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_07  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq07id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[7] ),
.current_sqcut_done          ( current_sqcut_done[7]        )  ,                                     
.st_rx_start                 ( sq_rx_start[7]               )  , 
.st_rx_end                   ( sq_rx_end[7]                 )  , 
.st_rx_valid                 ( sq_rx_valid[7]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[7]          )  , 
.sq_cut_reset                ( sq_cut_reset[7]              )  ,     
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_07                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq07_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq07_cut_len_reg             )  ,
.market_explain              ( sq07_market_explain          )  , //市场说明 3
.info_classify               ( sq07_info_classify           )  , //信息分类 1
.dialog_num                  ( sq07_dialog_num              )  , //会话编号 4
.contract_flag               ( sq07_contract_flag           )  , //合约标志 1
.contract_num                ( sq07_contract_num            )  , //合约编号 4
.contract_code               ( sq07_contract_code           )  , //合约代码 22
.update_time                 ( sq07_update_time             )  , //更新时间 9
.update_ms                   ( sq07_update_ms               )  , //更新毫秒 4
.new_price                   ( sq07_new_price               )  , //最新价 8
.turnover                    ( sq07_turnover                )  , //成交量 4
.volume                      ( sq07_volume                  )  , //成交额 8   
.position                    ( sq07_position                )  , //持仓量 8
.purchase_price              ( sq07_purchase_price          )  , //申买价 8
.buy_quantity                ( sq07_buy_quantity            )  , //申买量 4
.sell_price                  ( sq07_sell_price              )  , //申买价 8
.sell_quantity               ( sq07_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq07_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_08  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,   
.current_cut_done_sqid_reg   ( current_cut_done_sq08id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[8] ),
.current_sqcut_done          ( current_sqcut_done[8]        )  ,                                     
.st_rx_start                 ( sq_rx_start[8]               )  , 
.st_rx_end                   ( sq_rx_end[8]                 )  , 
.st_rx_valid                 ( sq_rx_valid[8]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[8]          )  , 
.sq_cut_reset                ( sq_cut_reset[8]              )  ,       
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_08                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq08_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq08_cut_len_reg             )  ,
.market_explain              ( sq08_market_explain          )  , //市场说明 3
.info_classify               ( sq08_info_classify           )  , //信息分类 1
.dialog_num                  ( sq08_dialog_num              )  , //会话编号 4
.contract_flag               ( sq08_contract_flag           )  , //合约标志 1
.contract_num                ( sq08_contract_num            )  , //合约编号 4
.contract_code               ( sq08_contract_code           )  , //合约代码 22
.update_time                 ( sq08_update_time             )  , //更新时间 9
.update_ms                   ( sq08_update_ms               )  , //更新毫秒 4
.new_price                   ( sq08_new_price               )  , //最新价 8
.turnover                    ( sq08_turnover                )  , //成交量 4
.volume                      ( sq08_volume                  )  , //成交额 8   
.position                    ( sq08_position                )  , //持仓量 8
.purchase_price              ( sq08_purchase_price          )  , //申买价 8
.buy_quantity                ( sq08_buy_quantity            )  , //申买量 4
.sell_price                  ( sq08_sell_price              )  , //申买价 8
.sell_quantity               ( sq08_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq08_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_09  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq09id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[9] ),
.current_sqcut_done          ( current_sqcut_done[9]        )  ,                                     
.st_rx_start                 ( sq_rx_start[9]               )  , 
.st_rx_end                   ( sq_rx_end[9]                 )  , 
.st_rx_valid                 ( sq_rx_valid[9]               )  , 
.sq_cut_reset_pre            ( sq_cut_reset_pre[9]              )  ,  
.sq_cut_reset                ( sq_cut_reset[9]              )  ,      
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_09                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq09_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq09_cut_len_reg             )  ,
.market_explain              ( sq09_market_explain          )  , //市场说明 3
.info_classify               ( sq09_info_classify           )  , //信息分类 1
.dialog_num                  ( sq09_dialog_num              )  , //会话编号 4
.contract_flag               ( sq09_contract_flag           )  , //合约标志 1
.contract_num                ( sq09_contract_num            )  , //合约编号 4
.contract_code               ( sq09_contract_code           )  , //合约代码 22
.update_time                 ( sq09_update_time             )  , //更新时间 9
.update_ms                   ( sq09_update_ms               )  , //更新毫秒 4
.new_price                   ( sq09_new_price               )  , //最新价 8
.turnover                    ( sq09_turnover                )  , //成交量 4
.volume                      ( sq09_volume                  )  , //成交额 8   
.position                    ( sq09_position                )  , //持仓量 8
.purchase_price              ( sq09_purchase_price          )  , //申买价 8
.buy_quantity                ( sq09_buy_quantity            )  , //申买量 4
.sell_price                  ( sq09_sell_price              )  , //申买价 8
.sell_quantity               ( sq09_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq09_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_10  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq10id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[10] ),
.current_sqcut_done          ( current_sqcut_done[10]        )  ,                                     
.st_rx_start                 ( sq_rx_start[10]               )  , 
.st_rx_end                   ( sq_rx_end[10]                 )  , 
.st_rx_valid                 ( sq_rx_valid[10]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[10]              )  , 
.sq_cut_reset                ( sq_cut_reset[10]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_10                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq10_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq10_cut_len_reg             )  ,
.market_explain              ( sq10_market_explain          )  , //市场说明 3
.info_classify               ( sq10_info_classify           )  , //信息分类 1
.dialog_num                  ( sq10_dialog_num              )  , //会话编号 4
.contract_flag               ( sq10_contract_flag           )  , //合约标志 1
.contract_num                ( sq10_contract_num            )  , //合约编号 4
.contract_code               ( sq10_contract_code           )  , //合约代码 22
.update_time                 ( sq10_update_time             )  , //更新时间 9
.update_ms                   ( sq10_update_ms               )  , //更新毫秒 4
.new_price                   ( sq10_new_price               )  , //最新价 8
.turnover                    ( sq10_turnover                )  , //成交量 4
.volume                      ( sq10_volume                  )  , //成交额 8   
.position                    ( sq10_position                )  , //持仓量 8
.purchase_price              ( sq10_purchase_price          )  , //申买价 8
.buy_quantity                ( sq10_buy_quantity            )  , //申买量 4
.sell_price                  ( sq10_sell_price              )  , //申买价 8
.sell_quantity               ( sq10_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq10_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_11  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq11id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[11] ),
.current_sqcut_done          ( current_sqcut_done[11]        )  ,                                     
.st_rx_start                 ( sq_rx_start[11]               )  , 
.st_rx_end                   ( sq_rx_end[11]                 )  , 
.st_rx_valid                 ( sq_rx_valid[11]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[11]              )  , 
.sq_cut_reset                ( sq_cut_reset[11]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_11                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq11_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq11_cut_len_reg             )  ,
.market_explain              ( sq11_market_explain          )  , //市场说明 3
.info_classify               ( sq11_info_classify           )  , //信息分类 1
.dialog_num                  ( sq11_dialog_num              )  , //会话编号 4
.contract_flag               ( sq11_contract_flag           )  , //合约标志 1
.contract_num                ( sq11_contract_num            )  , //合约编号 4
.contract_code               ( sq11_contract_code           )  , //合约代码 22
.update_time                 ( sq11_update_time             )  , //更新时间 9
.update_ms                   ( sq11_update_ms               )  , //更新毫秒 4
.new_price                   ( sq11_new_price               )  , //最新价 8
.turnover                    ( sq11_turnover                )  , //成交量 4
.volume                      ( sq11_volume                  )  , //成交额 8   
.position                    ( sq11_position                )  , //持仓量 8
.purchase_price              ( sq11_purchase_price          )  , //申买价 8
.buy_quantity                ( sq11_buy_quantity            )  , //申买量 4
.sell_price                  ( sq11_sell_price              )  , //申买价 8
.sell_quantity               ( sq11_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq11_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_12  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq12id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[12] ),
.current_sqcut_done          ( current_sqcut_done[12]        )  ,                                     
.st_rx_start                 ( sq_rx_start[12]               )  , 
.st_rx_end                   ( sq_rx_end[12]                 )  , 
.st_rx_valid                 ( sq_rx_valid[12]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[12]              )  ,  
.sq_cut_reset                ( sq_cut_reset[12]              )  ,       
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_12                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq12_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq12_cut_len_reg             )  ,
.market_explain              ( sq12_market_explain          )  , //市场说明 3
.info_classify               ( sq12_info_classify           )  , //信息分类 1
.dialog_num                  ( sq12_dialog_num              )  , //会话编号 4
.contract_flag               ( sq12_contract_flag           )  , //合约标志 1
.contract_num                ( sq12_contract_num            )  , //合约编号 4
.contract_code               ( sq12_contract_code           )  , //合约代码 22
.update_time                 ( sq12_update_time             )  , //更新时间 9
.update_ms                   ( sq12_update_ms               )  , //更新毫秒 4
.new_price                   ( sq12_new_price               )  , //最新价 8
.turnover                    ( sq12_turnover                )  , //成交量 4
.volume                      ( sq12_volume                  )  , //成交额 8   
.position                    ( sq12_position                )  , //持仓量 8
.purchase_price              ( sq12_purchase_price          )  , //申买价 8
.buy_quantity                ( sq12_buy_quantity            )  , //申买量 4
.sell_price                  ( sq12_sell_price              )  , //申买价 8
.sell_quantity               ( sq12_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq12_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_13  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq13id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[13] ),
.current_sqcut_done          ( current_sqcut_done[13]        )  ,                                     
.st_rx_start                 ( sq_rx_start[13]               )  , 
.st_rx_end                   ( sq_rx_end[13]                 )  , 
.st_rx_valid                 ( sq_rx_valid[13]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[13]              )  ,  
.sq_cut_reset                ( sq_cut_reset[13]              )  ,       
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_13                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq13_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq13_cut_len_reg             )  ,
.market_explain              ( sq13_market_explain          )  , //市场说明 3
.info_classify               ( sq13_info_classify           )  , //信息分类 1
.dialog_num                  ( sq13_dialog_num              )  , //会话编号 4
.contract_flag               ( sq13_contract_flag           )  , //合约标志 1
.contract_num                ( sq13_contract_num            )  , //合约编号 4
.contract_code               ( sq13_contract_code           )  , //合约代码 22
.update_time                 ( sq13_update_time             )  , //更新时间 9
.update_ms                   ( sq13_update_ms               )  , //更新毫秒 4
.new_price                   ( sq13_new_price               )  , //最新价 8
.turnover                    ( sq13_turnover                )  , //成交量 4
.volume                      ( sq13_volume                  )  , //成交额 8   
.position                    ( sq13_position                )  , //持仓量 8
.purchase_price              ( sq13_purchase_price          )  , //申买价 8
.buy_quantity                ( sq13_buy_quantity            )  , //申买量 4
.sell_price                  ( sq13_sell_price              )  , //申买价 8
.sell_quantity               ( sq13_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq13_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_14  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq14id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[14] ),
.current_sqcut_done          ( current_sqcut_done[14]        )  ,                                     
.st_rx_start                 ( sq_rx_start[14]               )  , 
.st_rx_end                   ( sq_rx_end[14]                 )  , 
.st_rx_valid                 ( sq_rx_valid[14]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[14]              )  , 
.sq_cut_reset                ( sq_cut_reset[14]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_14                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq14_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq14_cut_len_reg             )  ,
.market_explain              ( sq14_market_explain          )  , //市场说明 3
.info_classify               ( sq14_info_classify           )  , //信息分类 1
.dialog_num                  ( sq14_dialog_num              )  , //会话编号 4
.contract_flag               ( sq14_contract_flag           )  , //合约标志 1
.contract_num                ( sq14_contract_num            )  , //合约编号 4
.contract_code               ( sq14_contract_code           )  , //合约代码 22
.update_time                 ( sq14_update_time             )  , //更新时间 9
.update_ms                   ( sq14_update_ms               )  , //更新毫秒 4
.new_price                   ( sq14_new_price               )  , //最新价 8
.turnover                    ( sq14_turnover                )  , //成交量 4
.volume                      ( sq14_volume                  )  , //成交额 8   
.position                    ( sq14_position                )  , //持仓量 8
.purchase_price              ( sq14_purchase_price          )  , //申买价 8
.buy_quantity                ( sq14_buy_quantity            )  , //申买量 4
.sell_price                  ( sq14_sell_price              )  , //申买价 8
.sell_quantity               ( sq14_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq14_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_15  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq15id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[15] ),
.current_sqcut_done          ( current_sqcut_done[15]        )  ,                                     
.st_rx_start                 ( sq_rx_start[15]               )  , 
.st_rx_end                   ( sq_rx_end[15]                 )  , 
.st_rx_valid                 ( sq_rx_valid[15]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[15]              )  ,  
.sq_cut_reset                ( sq_cut_reset[15]              )  ,       
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_15                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq15_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq15_cut_len_reg             )  ,
.market_explain              ( sq15_market_explain          )  , //市场说明 3
.info_classify               ( sq15_info_classify           )  , //信息分类 1
.dialog_num                  ( sq15_dialog_num              )  , //会话编号 4
.contract_flag               ( sq15_contract_flag           )  , //合约标志 1
.contract_num                ( sq15_contract_num            )  , //合约编号 4
.contract_code               ( sq15_contract_code           )  , //合约代码 22
.update_time                 ( sq15_update_time             )  , //更新时间 9
.update_ms                   ( sq15_update_ms               )  , //更新毫秒 4
.new_price                   ( sq15_new_price               )  , //最新价 8
.turnover                    ( sq15_turnover                )  , //成交量 4
.volume                      ( sq15_volume                  )  , //成交额 8   
.position                    ( sq15_position                )  , //持仓量 8
.purchase_price              ( sq15_purchase_price          )  , //申买价 8
.buy_quantity                ( sq15_buy_quantity            )  , //申买量 4
.sell_price                  ( sq15_sell_price              )  , //申买价 8
.sell_quantity               ( sq15_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq15_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_16  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq16id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[16] ),
.current_sqcut_done          ( current_sqcut_done[16]        )  ,                                     
.st_rx_start                 ( sq_rx_start[16]               )  , 
.st_rx_end                   ( sq_rx_end[16]                 )  , 
.st_rx_valid                 ( sq_rx_valid[16]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[16]              )  ,
.sq_cut_reset                ( sq_cut_reset[16]              )  ,         
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_16                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq16_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq16_cut_len_reg             )  ,
.market_explain              ( sq16_market_explain          )  , //市场说明 3
.info_classify               ( sq16_info_classify           )  , //信息分类 1
.dialog_num                  ( sq16_dialog_num              )  , //会话编号 4
.contract_flag               ( sq16_contract_flag           )  , //合约标志 1
.contract_num                ( sq16_contract_num            )  , //合约编号 4
.contract_code               ( sq16_contract_code           )  , //合约代码 22
.update_time                 ( sq16_update_time             )  , //更新时间 9
.update_ms                   ( sq16_update_ms               )  , //更新毫秒 4
.new_price                   ( sq16_new_price               )  , //最新价 8
.turnover                    ( sq16_turnover                )  , //成交量 4
.volume                      ( sq16_volume                  )  , //成交额 8   
.position                    ( sq16_position                )  , //持仓量 8
.purchase_price              ( sq16_purchase_price          )  , //申买价 8
.buy_quantity                ( sq16_buy_quantity            )  , //申买量 4
.sell_price                  ( sq16_sell_price              )  , //申买价 8
.sell_quantity               ( sq16_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq16_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_17  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq17id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[17] ),
.current_sqcut_done          ( current_sqcut_done[17]        )  ,                                     
.st_rx_start                 ( sq_rx_start[17]               )  , 
.st_rx_end                   ( sq_rx_end[17]                 )  , 
.st_rx_valid                 ( sq_rx_valid[17]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[17]              )  , 
.sq_cut_reset                ( sq_cut_reset[17]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_17                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq17_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq17_cut_len_reg             )  ,
.market_explain              ( sq17_market_explain          )  , //市场说明 3
.info_classify               ( sq17_info_classify           )  , //信息分类 1
.dialog_num                  ( sq17_dialog_num              )  , //会话编号 4
.contract_flag               ( sq17_contract_flag           )  , //合约标志 1
.contract_num                ( sq17_contract_num            )  , //合约编号 4
.contract_code               ( sq17_contract_code           )  , //合约代码 22
.update_time                 ( sq17_update_time             )  , //更新时间 9
.update_ms                   ( sq17_update_ms               )  , //更新毫秒 4
.new_price                   ( sq17_new_price               )  , //最新价 8
.turnover                    ( sq17_turnover                )  , //成交量 4
.volume                      ( sq17_volume                  )  , //成交额 8   
.position                    ( sq17_position                )  , //持仓量 8
.purchase_price              ( sq17_purchase_price          )  , //申买价 8
.buy_quantity                ( sq17_buy_quantity            )  , //申买量 4
.sell_price                  ( sq17_sell_price              )  , //申买价 8
.sell_quantity               ( sq17_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq17_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_18  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq18id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[18] ),
.current_sqcut_done          ( current_sqcut_done[18]        )  ,                                     
.st_rx_start                 ( sq_rx_start[18]               )  , 
.st_rx_end                   ( sq_rx_end[18]                 )  , 
.st_rx_valid                 ( sq_rx_valid[18]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[18]              )  , 
.sq_cut_reset                ( sq_cut_reset[18]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_18                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq18_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq18_cut_len_reg             )  ,
.market_explain              ( sq18_market_explain          )  , //市场说明 3
.info_classify               ( sq18_info_classify           )  , //信息分类 1
.dialog_num                  ( sq18_dialog_num              )  , //会话编号 4
.contract_flag               ( sq18_contract_flag           )  , //合约标志 1
.contract_num                ( sq18_contract_num            )  , //合约编号 4
.contract_code               ( sq18_contract_code           )  , //合约代码 22
.update_time                 ( sq18_update_time             )  , //更新时间 9
.update_ms                   ( sq18_update_ms               )  , //更新毫秒 4
.new_price                   ( sq18_new_price               )  , //最新价 8
.turnover                    ( sq18_turnover                )  , //成交量 4
.volume                      ( sq18_volume                  )  , //成交额 8   
.position                    ( sq18_position                )  , //持仓量 8
.purchase_price              ( sq18_purchase_price          )  , //申买价 8
.buy_quantity                ( sq18_buy_quantity            )  , //申买量 4
.sell_price                  ( sq18_sell_price              )  , //申买价 8
.sell_quantity               ( sq18_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq18_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_19  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq19id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[19] ),
.current_sqcut_done          ( current_sqcut_done[19]        )  ,                                     
.st_rx_start                 ( sq_rx_start[19]               )  , 
.st_rx_end                   ( sq_rx_end[19]                 )  , 
.st_rx_valid                 ( sq_rx_valid[19]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[19]              )  , 
.sq_cut_reset                ( sq_cut_reset[19]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_19                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq19_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq19_cut_len_reg             )  ,
.market_explain              ( sq19_market_explain          )  , //市场说明 3
.info_classify               ( sq19_info_classify           )  , //信息分类 1
.dialog_num                  ( sq19_dialog_num              )  , //会话编号 4
.contract_flag               ( sq19_contract_flag           )  , //合约标志 1
.contract_num                ( sq19_contract_num            )  , //合约编号 4
.contract_code               ( sq19_contract_code           )  , //合约代码 22
.update_time                 ( sq19_update_time             )  , //更新时间 9
.update_ms                   ( sq19_update_ms               )  , //更新毫秒 4
.new_price                   ( sq19_new_price               )  , //最新价 8
.turnover                    ( sq19_turnover                )  , //成交量 4
.volume                      ( sq19_volume                  )  , //成交额 8   
.position                    ( sq19_position                )  , //持仓量 8
.purchase_price              ( sq19_purchase_price          )  , //申买价 8
.buy_quantity                ( sq19_buy_quantity            )  , //申买量 4
.sell_price                  ( sq19_sell_price              )  , //申买价 8
.sell_quantity               ( sq19_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq19_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_20  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq20id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[20] ),
.current_sqcut_done          ( current_sqcut_done[20]        )  ,                                     
.st_rx_start                 ( sq_rx_start[20]               )  , 
.st_rx_end                   ( sq_rx_end[20]                 )  , 
.st_rx_valid                 ( sq_rx_valid[20]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[20]              )  , 
.sq_cut_reset                ( sq_cut_reset[20]              )  ,        
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_20                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,
.sq_shift_full_flag          ( sq20_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq20_cut_len_reg             )  ,
.market_explain              ( sq20_market_explain          )  , //市场说明 3
.info_classify               ( sq20_info_classify           )  , //信息分类 1
.dialog_num                  ( sq20_dialog_num              )  , //会话编号 4
.contract_flag               ( sq20_contract_flag           )  , //合约标志 1
.contract_num                ( sq20_contract_num            )  , //合约编号 4
.contract_code               ( sq20_contract_code           )  , //合约代码 22
.update_time                 ( sq20_update_time             )  , //更新时间 9
.update_ms                   ( sq20_update_ms               )  , //更新毫秒 4
.new_price                   ( sq20_new_price               )  , //最新价 8
.turnover                    ( sq20_turnover                )  , //成交量 4
.volume                      ( sq20_volume                  )  , //成交额 8   
.position                    ( sq20_position                )  , //持仓量 8
.purchase_price              ( sq20_purchase_price          )  , //申买价 8
.buy_quantity                ( sq20_buy_quantity            )  , //申买量 4
.sell_price                  ( sq20_sell_price              )  , //申买价 8
.sell_quantity               ( sq20_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq20_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_21  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq21id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[21] ),
.current_sqcut_done          ( current_sqcut_done[21]        )  ,                                     
.st_rx_start                 ( sq_rx_start[21]               )  , 
.st_rx_end                   ( sq_rx_end[21]                 )  , 
.st_rx_valid                 ( sq_rx_valid[21]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[21]              )  , 
.sq_cut_reset                ( sq_cut_reset[21]              )  ,  
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_21                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq21_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq21_cut_len_reg             )  ,
.market_explain              ( sq21_market_explain          )  , //市场说明 3
.info_classify               ( sq21_info_classify           )  , //信息分类 1
.dialog_num                  ( sq21_dialog_num              )  , //会话编号 4
.contract_flag               ( sq21_contract_flag           )  , //合约标志 1
.contract_num                ( sq21_contract_num            )  , //合约编号 4
.contract_code               ( sq21_contract_code           )  , //合约代码 22
.update_time                 ( sq21_update_time             )  , //更新时间 9
.update_ms                   ( sq21_update_ms               )  , //更新毫秒 4
.new_price                   ( sq21_new_price               )  , //最新价 8
.turnover                    ( sq21_turnover                )  , //成交量 4
.volume                      ( sq21_volume                  )  , //成交额 8   
.position                    ( sq21_position                )  , //持仓量 8
.purchase_price              ( sq21_purchase_price          )  , //申买价 8
.buy_quantity                ( sq21_buy_quantity            )  , //申买量 4
.sell_price                  ( sq21_sell_price              )  , //申买价 8
.sell_quantity               ( sq21_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq21_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_22  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq22id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[22] ),
.current_sqcut_done          ( current_sqcut_done[22]        )  ,                                     
.st_rx_start                 ( sq_rx_start[22]               )  , 
.st_rx_end                   ( sq_rx_end[22]                 )  , 
.st_rx_valid                 ( sq_rx_valid[22]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[22]              )  ,  
.sq_cut_reset                ( sq_cut_reset[22]              )  , 
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_22                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq22_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq22_cut_len_reg             )  ,
.market_explain              ( sq22_market_explain          )  , //市场说明 3
.info_classify               ( sq22_info_classify           )  , //信息分类 1
.dialog_num                  ( sq22_dialog_num              )  , //会话编号 4
.contract_flag               ( sq22_contract_flag           )  , //合约标志 1
.contract_num                ( sq22_contract_num            )  , //合约编号 4
.contract_code               ( sq22_contract_code           )  , //合约代码 22
.update_time                 ( sq22_update_time             )  , //更新时间 9
.update_ms                   ( sq22_update_ms               )  , //更新毫秒 4
.new_price                   ( sq22_new_price               )  , //最新价 8
.turnover                    ( sq22_turnover                )  , //成交量 4
.volume                      ( sq22_volume                  )  , //成交额 8   
.position                    ( sq22_position                )  , //持仓量 8
.purchase_price              ( sq22_purchase_price          )  , //申买价 8
.buy_quantity                ( sq22_buy_quantity            )  , //申买量 4
.sell_price                  ( sq22_sell_price              )  , //申买价 8
.sell_quantity               ( sq22_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq22_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_23  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq23id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[23] ),
.current_sqcut_done          ( current_sqcut_done[23]        )  ,                                     
.st_rx_start                 ( sq_rx_start[23]               )  , 
.st_rx_end                   ( sq_rx_end[23]                 )  , 
.st_rx_valid                 ( sq_rx_valid[23]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[23]              )  , 
.sq_cut_reset                ( sq_cut_reset[23]              )  ,  
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_23                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq23_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq23_cut_len_reg             )  ,
.market_explain              ( sq23_market_explain          )  , //市场说明 3
.info_classify               ( sq23_info_classify           )  , //信息分类 1
.dialog_num                  ( sq23_dialog_num              )  , //会话编号 4
.contract_flag               ( sq23_contract_flag           )  , //合约标志 1
.contract_num                ( sq23_contract_num            )  , //合约编号 4
.contract_code               ( sq23_contract_code           )  , //合约代码 22
.update_time                 ( sq23_update_time             )  , //更新时间 9
.update_ms                   ( sq23_update_ms               )  , //更新毫秒 4
.new_price                   ( sq23_new_price               )  , //最新价 8
.turnover                    ( sq23_turnover                )  , //成交量 4
.volume                      ( sq23_volume                  )  , //成交额 8   
.position                    ( sq23_position                )  , //持仓量 8
.purchase_price              ( sq23_purchase_price          )  , //申买价 8
.buy_quantity                ( sq23_buy_quantity            )  , //申买量 4
.sell_price                  ( sq23_sell_price              )  , //申买价 8
.sell_quantity               ( sq23_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq23_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_24  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq24id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[24] ),
.current_sqcut_done          ( current_sqcut_done[24]        )  ,                                     
.st_rx_start                 ( sq_rx_start[24]               )  , 
.st_rx_end                   ( sq_rx_end[24]                 )  , 
.st_rx_valid                 ( sq_rx_valid[24]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[24]              )  ,
.sq_cut_reset                ( sq_cut_reset[24]              )  ,   
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_24                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq24_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq24_cut_len_reg             )  ,
.market_explain              ( sq24_market_explain          )  , //市场说明 3
.info_classify               ( sq24_info_classify           )  , //信息分类 1
.dialog_num                  ( sq24_dialog_num              )  , //会话编号 4
.contract_flag               ( sq24_contract_flag           )  , //合约标志 1
.contract_num                ( sq24_contract_num            )  , //合约编号 4
.contract_code               ( sq24_contract_code           )  , //合约代码 22
.update_time                 ( sq24_update_time             )  , //更新时间 9
.update_ms                   ( sq24_update_ms               )  , //更新毫秒 4
.new_price                   ( sq24_new_price               )  , //最新价 8
.turnover                    ( sq24_turnover                )  , //成交量 4
.volume                      ( sq24_volume                  )  , //成交额 8   
.position                    ( sq24_position                )  , //持仓量 8
.purchase_price              ( sq24_purchase_price          )  , //申买价 8
.buy_quantity                ( sq24_buy_quantity            )  , //申买量 4
.sell_price                  ( sq24_sell_price              )  , //申买价 8
.sell_quantity               ( sq24_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq24_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_25  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,   
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,
.current_cut_done_sqid_reg   ( current_cut_done_sq25id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[25] ),
.current_sqcut_done          ( current_sqcut_done[25]        )  ,                                     
.st_rx_start                 ( sq_rx_start[25]               )  , 
.st_rx_end                   ( sq_rx_end[25]                 )  , 
.st_rx_valid                 ( sq_rx_valid[25]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[25]              )  , 
.sq_cut_reset                ( sq_cut_reset[25]              )  ,  
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_25                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq25_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq25_cut_len_reg             )  ,
.market_explain              ( sq25_market_explain          )  , //市场说明 3
.info_classify               ( sq25_info_classify           )  , //信息分类 1
.dialog_num                  ( sq25_dialog_num              )  , //会话编号 4
.contract_flag               ( sq25_contract_flag           )  , //合约标志 1
.contract_num                ( sq25_contract_num            )  , //合约编号 4
.contract_code               ( sq25_contract_code           )  , //合约代码 22
.update_time                 ( sq25_update_time             )  , //更新时间 9
.update_ms                   ( sq25_update_ms               )  , //更新毫秒 4
.new_price                   ( sq25_new_price               )  , //最新价 8
.turnover                    ( sq25_turnover                )  , //成交量 4
.volume                      ( sq25_volume                  )  , //成交额 8   
.position                    ( sq25_position                )  , //持仓量 8
.purchase_price              ( sq25_purchase_price          )  , //申买价 8
.buy_quantity                ( sq25_buy_quantity            )  , //申买量 4
.sell_price                  ( sq25_sell_price              )  , //申买价 8
.sell_quantity               ( sq25_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq25_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_26  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq26id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[26] ),
.current_sqcut_done          ( current_sqcut_done[26]        )  ,                                     
.st_rx_start                 ( sq_rx_start[26]               )  , 
.st_rx_end                   ( sq_rx_end[26]                 )  , 
.st_rx_valid                 ( sq_rx_valid[26]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[26]              )  ,  
.sq_cut_reset                ( sq_cut_reset[26]              )  , 
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_26                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq26_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq26_cut_len_reg             )  ,
.market_explain              ( sq26_market_explain          )  , //市场说明 3
.info_classify               ( sq26_info_classify           )  , //信息分类 1
.dialog_num                  ( sq26_dialog_num              )  , //会话编号 4
.contract_flag               ( sq26_contract_flag           )  , //合约标志 1
.contract_num                ( sq26_contract_num            )  , //合约编号 4
.contract_code               ( sq26_contract_code           )  , //合约代码 22
.update_time                 ( sq26_update_time             )  , //更新时间 9
.update_ms                   ( sq26_update_ms               )  , //更新毫秒 4
.new_price                   ( sq26_new_price               )  , //最新价 8
.turnover                    ( sq26_turnover                )  , //成交量 4
.volume                      ( sq26_volume                  )  , //成交额 8   
.position                    ( sq26_position                )  , //持仓量 8
.purchase_price              ( sq26_purchase_price          )  , //申买价 8
.buy_quantity                ( sq26_buy_quantity            )  , //申买量 4
.sell_price                  ( sq26_sell_price              )  , //申买价 8
.sell_quantity               ( sq26_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq26_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_27  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq27id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[27] ),
.current_sqcut_done          ( current_sqcut_done[27]        )  ,                                     
.st_rx_start                 ( sq_rx_start[27]               )  , 
.st_rx_end                   ( sq_rx_end[27]                 )  , 
.st_rx_valid                 ( sq_rx_valid[27]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[27]              )  ,  
.sq_cut_reset                ( sq_cut_reset[27]              )  , 
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_27                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq27_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq27_cut_len_reg             )  ,
.market_explain              ( sq27_market_explain          )  , //市场说明 3
.info_classify               ( sq27_info_classify           )  , //信息分类 1
.dialog_num                  ( sq27_dialog_num              )  , //会话编号 4
.contract_flag               ( sq27_contract_flag           )  , //合约标志 1
.contract_num                ( sq27_contract_num            )  , //合约编号 4
.contract_code               ( sq27_contract_code           )  , //合约代码 22
.update_time                 ( sq27_update_time             )  , //更新时间 9
.update_ms                   ( sq27_update_ms               )  , //更新毫秒 4
.new_price                   ( sq27_new_price               )  , //最新价 8
.turnover                    ( sq27_turnover                )  , //成交量 4
.volume                      ( sq27_volume                  )  , //成交额 8   
.position                    ( sq27_position                )  , //持仓量 8
.purchase_price              ( sq27_purchase_price          )  , //申买价 8
.buy_quantity                ( sq27_buy_quantity            )  , //申买量 4
.sell_price                  ( sq27_sell_price              )  , //申买价 8
.sell_quantity               ( sq27_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq27_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_28  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq28id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[28] ),
.current_sqcut_done          ( current_sqcut_done[28]        )  ,                                     
.st_rx_start                 ( sq_rx_start[28]               )  , 
.st_rx_end                   ( sq_rx_end[28]                 )  , 
.st_rx_valid                 ( sq_rx_valid[28]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[28]              )  ,  
.sq_cut_reset                ( sq_cut_reset[28]              )  , 
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_28                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq28_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq28_cut_len_reg             )  ,
.market_explain              ( sq28_market_explain          )  , //市场说明 3
.info_classify               ( sq28_info_classify           )  , //信息分类 1
.dialog_num                  ( sq28_dialog_num              )  , //会话编号 4
.contract_flag               ( sq28_contract_flag           )  , //合约标志 1
.contract_num                ( sq28_contract_num            )  , //合约编号 4
.contract_code               ( sq28_contract_code           )  , //合约代码 22
.update_time                 ( sq28_update_time             )  , //更新时间 9
.update_ms                   ( sq28_update_ms               )  , //更新毫秒 4
.new_price                   ( sq28_new_price               )  , //最新价 8
.turnover                    ( sq28_turnover                )  , //成交量 4
.volume                      ( sq28_volume                  )  , //成交额 8   
.position                    ( sq28_position                )  , //持仓量 8
.purchase_price              ( sq28_purchase_price          )  , //申买价 8
.buy_quantity                ( sq28_buy_quantity            )  , //申买量 4
.sell_price                  ( sq28_sell_price              )  , //申买价 8
.sell_quantity               ( sq28_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq28_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_29  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq29id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[29] ),
.current_sqcut_done          ( current_sqcut_done[29]        )  ,                                     
.st_rx_start                 ( sq_rx_start[29]               )  , 
.st_rx_end                   ( sq_rx_end[29]                 )  , 
.st_rx_valid                 ( sq_rx_valid[29]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[29]              )  , 
.sq_cut_reset                ( sq_cut_reset[29]              )  ,  
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_29                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq29_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq29_cut_len_reg             )  ,
.market_explain              ( sq29_market_explain          )  , //市场说明 3
.info_classify               ( sq29_info_classify           )  , //信息分类 1
.dialog_num                  ( sq29_dialog_num              )  , //会话编号 4
.contract_flag               ( sq29_contract_flag           )  , //合约标志 1
.contract_num                ( sq29_contract_num            )  , //合约编号 4
.contract_code               ( sq29_contract_code           )  , //合约代码 22
.update_time                 ( sq29_update_time             )  , //更新时间 9
.update_ms                   ( sq29_update_ms               )  , //更新毫秒 4
.new_price                   ( sq29_new_price               )  , //最新价 8
.turnover                    ( sq29_turnover                )  , //成交量 4
.volume                      ( sq29_volume                  )  , //成交额 8   
.position                    ( sq29_position                )  , //持仓量 8
.purchase_price              ( sq29_purchase_price          )  , //申买价 8
.buy_quantity                ( sq29_buy_quantity            )  , //申买量 4
.sell_price                  ( sq29_sell_price              )  , //申买价 8
.sell_quantity               ( sq29_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq29_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_30  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  ,  
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  , 
.current_cut_done_sqid_reg   ( current_cut_done_sq30id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[30] ),
.current_sqcut_done          ( current_sqcut_done[30]        )  ,                                     
.st_rx_start                 ( sq_rx_start[30]               )  , 
.st_rx_end                   ( sq_rx_end[30]                 )  , 
.st_rx_valid                 ( sq_rx_valid[30]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[30]              )  ,   
.sq_cut_reset                ( sq_cut_reset[30]              )  ,
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_30                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq30_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq30_cut_len_reg             )  ,
.market_explain              ( sq30_market_explain          )  , //市场说明 3
.info_classify               ( sq30_info_classify           )  , //信息分类 1
.dialog_num                  ( sq30_dialog_num              )  , //会话编号 4
.contract_flag               ( sq30_contract_flag           )  , //合约标志 1
.contract_num                ( sq30_contract_num            )  , //合约编号 4
.contract_code               ( sq30_contract_code           )  , //合约代码 22
.update_time                 ( sq30_update_time             )  , //更新时间 9
.update_ms                   ( sq30_update_ms               )  , //更新毫秒 4
.new_price                   ( sq30_new_price               )  , //最新价 8
.turnover                    ( sq30_turnover                )  , //成交量 4
.volume                      ( sq30_volume                  )  , //成交额 8   
.position                    ( sq30_position                )  , //持仓量 8
.purchase_price              ( sq30_purchase_price          )  , //申买价 8
.buy_quantity                ( sq30_buy_quantity            )  , //申买量 4
.sell_price                  ( sq30_sell_price              )  , //申买价 8
.sell_quantity               ( sq30_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq30_market_rdy              )  
);

filter_cut_rx_fsm  sq_cut_rx_fsm_31  (
.clk                         ( clk                          )  ,
.rst_n                       ( rst_n                        )  , 
.params_frame_type_byte      (params_frame_type_byte        )  , 
.params_filter_rst           (params_filter_rst             )  ,  
.current_cut_done_sqid_reg   ( current_cut_done_sq31id_reg  )  ,
.current_cut_now_sqid_reg_vld (current_cut_now_sqid_reg_vld[31] ),
.current_sqcut_done          ( current_sqcut_done[31]        )  ,                                     
.st_rx_start                 ( sq_rx_start[31]               )  , 
.st_rx_end                   ( sq_rx_end[31]                 )  , 
.st_rx_valid                 ( sq_rx_valid[31]               )  , 
.sq_cut_reset_pre                ( sq_cut_reset_pre[31]              )  ,
.sq_cut_reset                ( sq_cut_reset[31]              )  ,   
.st_rx_data                  ( sq_rx_data                   )  , 
.st_rx_empty                 ( sq_rx_empty_31                  )  ,
.st_rx_offset                ( 4'd0                         )  ,
.st_rx_cnt                   ( 16'd0                        )  , 
.sq_frame_flag               ( 1'd1                         )  ,

.sq_shift_full_flag          ( sq31_shift_full_flag         )  ,                                                    
.sq_cut_len_reg              ( sq31_cut_len_reg             )  ,
.market_explain              ( sq31_market_explain          )  , //市场说明 3
.info_classify               ( sq31_info_classify           )  , //信息分类 1
.dialog_num                  ( sq31_dialog_num              )  , //会话编号 4
.contract_flag               ( sq31_contract_flag           )  , //合约标志 1
.contract_num                ( sq31_contract_num            )  , //合约编号 4
.contract_code               ( sq31_contract_code           )  , //合约代码 22
.update_time                 ( sq31_update_time             )  , //更新时间 9
.update_ms                   ( sq31_update_ms               )  , //更新毫秒 4
.new_price                   ( sq31_new_price               )  , //最新价 8
.turnover                    ( sq31_turnover                )  , //成交量 4
.volume                      ( sq31_volume                  )  , //成交额 8   
.position                    ( sq31_position                )  , //持仓量 8
.purchase_price              ( sq31_purchase_price          )  , //申买价 8
.buy_quantity                ( sq31_buy_quantity            )  , //申买量 4
.sell_price                  ( sq31_sell_price              )  , //申买价 8
.sell_quantity               ( sq31_sell_quantity           )  , //申卖量 4
.market_rdy                  ( sq31_market_rdy              )  
);


sq_cut_ctrl    sq_cut_ctrl  (
.clk                          (clk                          )   ,
.rst_n                        (rst_n                        )   ,
.params_filter_rst            (params_filter_rst            )   ,
.sq00_cut_len_reg             (sq00_cut_len_reg             )   ,
.sq01_cut_len_reg             (sq01_cut_len_reg             )   ,
.sq02_cut_len_reg             (sq02_cut_len_reg             )   ,
.sq03_cut_len_reg             (sq03_cut_len_reg             )   ,
.sq04_cut_len_reg             (sq04_cut_len_reg             )   ,
.sq05_cut_len_reg             (sq05_cut_len_reg             )   ,
.sq06_cut_len_reg             (sq06_cut_len_reg             )   ,
.sq07_cut_len_reg             (sq07_cut_len_reg             )   ,
.sq08_cut_len_reg             (sq08_cut_len_reg             )   ,
.sq09_cut_len_reg             (sq09_cut_len_reg             )   ,
.sq10_cut_len_reg             (sq10_cut_len_reg             )   ,
.sq11_cut_len_reg             (sq11_cut_len_reg             )   ,
.sq12_cut_len_reg             (sq12_cut_len_reg             )   ,
.sq13_cut_len_reg             (sq13_cut_len_reg             )   ,
.sq14_cut_len_reg             (sq14_cut_len_reg             )   ,
.sq15_cut_len_reg             (sq15_cut_len_reg             )   ,
.sq16_cut_len_reg             (sq16_cut_len_reg             )   ,
.sq17_cut_len_reg             (sq17_cut_len_reg             )   ,
.sq18_cut_len_reg             (sq18_cut_len_reg             )   ,
.sq19_cut_len_reg             (sq19_cut_len_reg             )   ,
.sq20_cut_len_reg             (sq20_cut_len_reg             )   ,
.sq21_cut_len_reg             (sq21_cut_len_reg             )   ,
.sq22_cut_len_reg             (sq22_cut_len_reg             )   ,
.sq23_cut_len_reg             (sq23_cut_len_reg             )   ,
.sq24_cut_len_reg             (sq24_cut_len_reg             )   ,
.sq25_cut_len_reg             (sq25_cut_len_reg             )   ,
.sq26_cut_len_reg             (sq26_cut_len_reg             )   ,
.sq27_cut_len_reg             (sq27_cut_len_reg             )   ,
.sq28_cut_len_reg             (sq28_cut_len_reg             )   ,
.sq29_cut_len_reg             (sq29_cut_len_reg             )   ,
.sq30_cut_len_reg             (sq30_cut_len_reg             )   ,
.sq31_cut_len_reg             (sq31_cut_len_reg             )   ,
.fir_r_idle_st                (fir_r_idle_st                )   ,
.fir_r_sqcuth_st              (fir_r_sqcuth_st              )   ,
.fir_r_vsync_st               (fir_r_vsync_st               )   ,
.fir_r_sqcut_st               (fir_r_sqcut_st               )   ,
.fir_r_sqcut_end_st           (fir_r_sqcut_end_st           )   ,
.fir_r_sqrcut_st              (fir_r_sqrcut_st              )   ,
.fir_r_sqrcut_end_st          (fir_r_sqrcut_end_st          )   ,
.fir_r_rjudge_st              (fir_r_rjudge_st              )   ,
.sq_cut_len_reg               (sq_cut_len_reg               )   ,
.st_rx_cnt_reg                (st_rx_cnt_reg                )   , 
.st_shift_ccnt                (st_shift_ccnt                )   ,
.sync_len_byte                (sync_len_byte                )   ,
.sync_fisrt_byte    (sync_fisrt_byte),
.sync_four_byte     (sync_four_byte),
.sq_frame_flag                (sq_frame_flag                )   ,
.current_sqid_reg_flag        (current_sqid_reg_flag        )   ,
.sq_cut_on                    (sq_cut_on                    )   ,
.sq_cut_first_on              (sq_cut_first_on              )   ,
.sub_sqcut_len_reg            (sub_sqcut_len_reg            )   ,                                         
.st_rx_start                  (st_rx_start                  )   , 
.st_rx_offset                 (st_rx_offset                 )   ,
.st_rx_end                    (st_rx_end                    )   , 
.st_rx_valid                  (st_rx_valid                  )   , 
.st_rx_data                   (st_rx_data                   )   , 
.st_rx_empty                  (st_rx_empty                  )   , 
.st_rx_cnt                    (st_rx_cnt                    )   , 
.first_sync_len_byte          (first_sync_len_byte          )   ,                                      
.tcp_sqmatch_flag             (tcp_sqmatch_flag             )   ,  //match with pre  SQ tcp frame 
.seq_err_flag                 (seq_err_flag                 )   ,
.seq_err_flag_dly             (seq_err_flag_dly             )   ,
.tcp_payload_len              (tcp_payload_len              )   ,
.st_rx_start_dly              (st_rx_start_dly              )   , 
.st_rx_offset_dly             (st_rx_offset_dly             )   ,
.st_rx_end_dly                (st_rx_end_dly                )   , 
.st_rx_valid_dly              (st_rx_valid_dly              )   , 
.st_rx_data_dly               (st_rx_data_dly               )   , 
.st_rx_empty_dly              (st_rx_empty_dly              )   , 
.st_rx_cnt_dly                (st_rx_cnt_dly                )   , 
.first_sync_len_byte_dly      (first_sync_len_byte_dly      )   ,                                      
.tcp_sqmatch_flag_dly         (tcp_sqmatch_flag_dly         )   ,  //match with pre  SQ tcp frame 
.tcp_sqmatch_flag_1bit_dly    (tcp_sqmatch_flag_1bit_dly    )   ,
.tcp_payload_len_dly          (tcp_payload_len_dly          )   ,                                           
.sq_cut_flag                  (sq_cut_flag                  )   ,  //cut _flag                          
.sq_cut_reset                 (sq_cut_reset                 )   ,  //cut _flag
.sq_cut_reset_pre             (sq_cut_reset_pre             )   ,  //cut _flag
.current_cut_done_sq00id_reg  (current_cut_done_sq00id_reg  )   ,
.current_cut_done_sq01id_reg  (current_cut_done_sq01id_reg  )   ,
.current_cut_done_sq02id_reg  (current_cut_done_sq02id_reg  )   ,
.current_cut_done_sq03id_reg  (current_cut_done_sq03id_reg  )   ,
.current_cut_done_sq04id_reg  (current_cut_done_sq04id_reg  )   ,
.current_cut_done_sq05id_reg  (current_cut_done_sq05id_reg  )   ,
.current_cut_done_sq06id_reg  (current_cut_done_sq06id_reg  )   ,
.current_cut_done_sq07id_reg  (current_cut_done_sq07id_reg  )   ,
.current_cut_done_sq08id_reg  (current_cut_done_sq08id_reg  )   ,
.current_cut_done_sq09id_reg  (current_cut_done_sq09id_reg  )   ,
.current_cut_done_sq10id_reg  (current_cut_done_sq10id_reg  )   ,
.current_cut_done_sq11id_reg  (current_cut_done_sq11id_reg  )   ,
.current_cut_done_sq12id_reg  (current_cut_done_sq12id_reg  )   ,
.current_cut_done_sq13id_reg  (current_cut_done_sq13id_reg  )   ,
.current_cut_done_sq14id_reg  (current_cut_done_sq14id_reg  )   ,
.current_cut_done_sq15id_reg  (current_cut_done_sq15id_reg  )   ,
.current_cut_done_sq16id_reg  (current_cut_done_sq16id_reg  )   ,
.current_cut_done_sq17id_reg  (current_cut_done_sq17id_reg  )   ,
.current_cut_done_sq18id_reg  (current_cut_done_sq18id_reg  )   ,
.current_cut_done_sq19id_reg  (current_cut_done_sq19id_reg  )   ,
.current_cut_done_sq20id_reg  (current_cut_done_sq20id_reg  )   ,
.current_cut_done_sq21id_reg  (current_cut_done_sq21id_reg  )   ,
.current_cut_done_sq22id_reg  (current_cut_done_sq22id_reg  )   ,
.current_cut_done_sq23id_reg  (current_cut_done_sq23id_reg  )   ,
.current_cut_done_sq24id_reg  (current_cut_done_sq24id_reg  )   ,
.current_cut_done_sq25id_reg  (current_cut_done_sq25id_reg  )   ,
.current_cut_done_sq26id_reg  (current_cut_done_sq26id_reg  )   ,
.current_cut_done_sq27id_reg  (current_cut_done_sq27id_reg  )   ,
.current_cut_done_sq28id_reg  (current_cut_done_sq28id_reg  )   ,
.current_cut_done_sq29id_reg  (current_cut_done_sq29id_reg  )   ,
.current_cut_done_sq30id_reg  (current_cut_done_sq30id_reg  )   ,
.current_cut_done_sq31id_reg  (current_cut_done_sq31id_reg  )   ,
.current_sqcut_done           (current_sqcut_done           )   ,
.current_sqid_reg             (current_sqid_reg             )   ,
.current_sqid_reg_vld         (current_sqid_reg_vld         ) 
);





filter_tlp_gen   filter_tlp_gen  (
.clk                   ( clk                    )   ,
.rst_n                 ( rst_n                  )   ,

// .pcie_clk              (pcie_clk                 ),
// .pcie_clk_rstn         (pcie_clk_rstn            ),

.params_filter_rst     (params_filter_rst       )   ,
//.params_des_acnt       (params_des_acnt         )   ,


.market_explain        ( market_explain         )   , //市场说明 3
.info_classify         ( info_classify          )   , //信息分类 1
.dialog_num            ( dialog_num             )   , //会话编号 4
.contract_flag         ( contract_flag          )   , //合约标志 1
.contract_num          ( contract_num           )   , //合约编号 4
.contract_code         ( contract_code          )   , //合约代码 22
.update_time           ( update_time            )   , //更新时间 9
.update_ms             ( update_ms              )   , //更新毫秒 4
.new_price             ( new_price              )   , //最新价 8
.turnover              ( turnover               )   , //成交量 4
.volume                ( volume                 )   , //成交额 8   
.position              ( position               )   , //持仓量 8
.purchase_price        ( purchase_price         )   , //申买价 8
.buy_quantity          ( buy_quantity           )   , //申买量 4
.sell_price            ( sell_price             )   , //申买价 8
.sell_quantity         ( sell_quantity          )   , //申卖量 4
.market_rdy            ( market_rdy             )   ,

.sq00_market_explain     ( sq00_market_explain      )   , //市场说明 3
.sq00_info_classify      ( sq00_info_classify       )   , //信息分类 1
.sq00_dialog_num         ( sq00_dialog_num          )   , //会话编号 4
.sq00_contract_flag      ( sq00_contract_flag       )   , //合约标志 1
.sq00_contract_num       ( sq00_contract_num        )   , //合约编号 4
.sq00_contract_code      ( sq00_contract_code       )   , //合约代码 22
.sq00_update_time        ( sq00_update_time         )   , //更新时间 9
.sq00_update_ms          ( sq00_update_ms           )   , //更新毫秒 4
.sq00_new_price          ( sq00_new_price           )   , //最新价 8
.sq00_turnover           ( sq00_turnover            )   , //成交量 4
.sq00_volume             ( sq00_volume              )   , //成交额 8   
.sq00_position           ( sq00_position            )   , //持仓量 8
.sq00_purchase_price     ( sq00_purchase_price      )   , //申买价 8
.sq00_buy_quantity       ( sq00_buy_quantity        )   , //申买量 4
.sq00_sell_price         ( sq00_sell_price          )   , //申买价 8
.sq00_sell_quantity      ( sq00_sell_quantity       )   , //申卖量 4
.sq00_market_rdy         ( sq00_market_rdy          )   ,

.sq01_market_explain     ( sq01_market_explain      )   , //市场说明 3
.sq01_info_classify      ( sq01_info_classify       )   , //信息分类 1
.sq01_dialog_num         ( sq01_dialog_num          )   , //会话编号 4
.sq01_contract_flag      ( sq01_contract_flag       )   , //合约标志 1
.sq01_contract_num       ( sq01_contract_num        )   , //合约编号 4
.sq01_contract_code      ( sq01_contract_code       )   , //合约代码 22
.sq01_update_time        ( sq01_update_time         )   , //更新时间 9
.sq01_update_ms          ( sq01_update_ms           )   , //更新毫秒 4
.sq01_new_price          ( sq01_new_price           )   , //最新价 8
.sq01_turnover           ( sq01_turnover            )   , //成交量 4
.sq01_volume             ( sq01_volume              )   , //成交额 8   
.sq01_position           ( sq01_position            )   , //持仓量 8
.sq01_purchase_price     ( sq01_purchase_price      )   , //申买价 8
.sq01_buy_quantity       ( sq01_buy_quantity        )   , //申买量 4
.sq01_sell_price         ( sq01_sell_price          )   , //申买价 8
.sq01_sell_quantity      ( sq01_sell_quantity       )   , //申卖量 4
.sq01_market_rdy         ( sq01_market_rdy          )   ,

.sq02_market_explain     ( sq02_market_explain      )   , //市场说明 3
.sq02_info_classify      ( sq02_info_classify       )   , //信息分类 1
.sq02_dialog_num         ( sq02_dialog_num          )   , //会话编号 4
.sq02_contract_flag      ( sq02_contract_flag       )   , //合约标志 1
.sq02_contract_num       ( sq02_contract_num        )   , //合约编号 4
.sq02_contract_code      ( sq02_contract_code       )   , //合约代码 22
.sq02_update_time        ( sq02_update_time         )   , //更新时间 9
.sq02_update_ms          ( sq02_update_ms           )   , //更新毫秒 4
.sq02_new_price          ( sq02_new_price           )   , //最新价 8
.sq02_turnover           ( sq02_turnover            )   , //成交量 4
.sq02_volume             ( sq02_volume              )   , //成交额 8   
.sq02_position           ( sq02_position            )   , //持仓量 8
.sq02_purchase_price     ( sq02_purchase_price      )   , //申买价 8
.sq02_buy_quantity       ( sq02_buy_quantity        )   , //申买量 4
.sq02_sell_price         ( sq02_sell_price          )   , //申买价 8
.sq02_sell_quantity      ( sq02_sell_quantity       )   , //申卖量 4
.sq02_market_rdy         ( sq02_market_rdy          )   ,

.sq03_market_explain     ( sq03_market_explain      )   , //市场说明 3
.sq03_info_classify      ( sq03_info_classify       )   , //信息分类 1
.sq03_dialog_num         ( sq03_dialog_num          )   , //会话编号 4
.sq03_contract_flag      ( sq03_contract_flag       )   , //合约标志 1
.sq03_contract_num       ( sq03_contract_num        )   , //合约编号 4
.sq03_contract_code      ( sq03_contract_code       )   , //合约代码 22
.sq03_update_time        ( sq03_update_time         )   , //更新时间 9
.sq03_update_ms          ( sq03_update_ms           )   , //更新毫秒 4
.sq03_new_price          ( sq03_new_price           )   , //最新价 8
.sq03_turnover           ( sq03_turnover            )   , //成交量 4
.sq03_volume             ( sq03_volume              )   , //成交额 8   
.sq03_position           ( sq03_position            )   , //持仓量 8
.sq03_purchase_price     ( sq03_purchase_price      )   , //申买价 8
.sq03_buy_quantity       ( sq03_buy_quantity        )   , //申买量 4
.sq03_sell_price         ( sq03_sell_price          )   , //申买价 8
.sq03_sell_quantity      ( sq03_sell_quantity       )   , //申卖量 4
.sq03_market_rdy         ( sq03_market_rdy          )   ,

.sq04_market_explain     ( sq04_market_explain      )   , //市场说明 3
.sq04_info_classify      ( sq04_info_classify       )   , //信息分类 1
.sq04_dialog_num         ( sq04_dialog_num          )   , //会话编号 4
.sq04_contract_flag      ( sq04_contract_flag       )   , //合约标志 1
.sq04_contract_num       ( sq04_contract_num        )   , //合约编号 4
.sq04_contract_code      ( sq04_contract_code       )   , //合约代码 22
.sq04_update_time        ( sq04_update_time         )   , //更新时间 9
.sq04_update_ms          ( sq04_update_ms           )   , //更新毫秒 4
.sq04_new_price          ( sq04_new_price           )   , //最新价 8
.sq04_turnover           ( sq04_turnover            )   , //成交量 4
.sq04_volume             ( sq04_volume              )   , //成交额 8   
.sq04_position           ( sq04_position            )   , //持仓量 8
.sq04_purchase_price     ( sq04_purchase_price      )   , //申买价 8
.sq04_buy_quantity       ( sq04_buy_quantity        )   , //申买量 4
.sq04_sell_price         ( sq04_sell_price          )   , //申买价 8
.sq04_sell_quantity      ( sq04_sell_quantity       )   , //申卖量 4
.sq04_market_rdy         ( sq04_market_rdy          )   ,

.sq05_market_explain     ( sq05_market_explain      )   , //市场说明 3
.sq05_info_classify      ( sq05_info_classify       )   , //信息分类 1
.sq05_dialog_num         ( sq05_dialog_num          )   , //会话编号 4
.sq05_contract_flag      ( sq05_contract_flag       )   , //合约标志 1
.sq05_contract_num       ( sq05_contract_num        )   , //合约编号 4
.sq05_contract_code      ( sq05_contract_code       )   , //合约代码 22
.sq05_update_time        ( sq05_update_time         )   , //更新时间 9
.sq05_update_ms          ( sq05_update_ms           )   , //更新毫秒 4
.sq05_new_price          ( sq05_new_price           )   , //最新价 8
.sq05_turnover           ( sq05_turnover            )   , //成交量 4
.sq05_volume             ( sq05_volume              )   , //成交额 8   
.sq05_position           ( sq05_position            )   , //持仓量 8
.sq05_purchase_price     ( sq05_purchase_price      )   , //申买价 8
.sq05_buy_quantity       ( sq05_buy_quantity        )   , //申买量 4
.sq05_sell_price         ( sq05_sell_price          )   , //申买价 8
.sq05_sell_quantity      ( sq05_sell_quantity       )   , //申卖量 4
.sq05_market_rdy         ( sq05_market_rdy          )   ,

.sq06_market_explain     ( sq06_market_explain      )   , //市场说明 3
.sq06_info_classify      ( sq06_info_classify       )   , //信息分类 1
.sq06_dialog_num         ( sq06_dialog_num          )   , //会话编号 4
.sq06_contract_flag      ( sq06_contract_flag       )   , //合约标志 1
.sq06_contract_num       ( sq06_contract_num        )   , //合约编号 4
.sq06_contract_code      ( sq06_contract_code       )   , //合约代码 22
.sq06_update_time        ( sq06_update_time         )   , //更新时间 9
.sq06_update_ms          ( sq06_update_ms           )   , //更新毫秒 4
.sq06_new_price          ( sq06_new_price           )   , //最新价 8
.sq06_turnover           ( sq06_turnover            )   , //成交量 4
.sq06_volume             ( sq06_volume              )   , //成交额 8   
.sq06_position           ( sq06_position            )   , //持仓量 8
.sq06_purchase_price     ( sq06_purchase_price      )   , //申买价 8
.sq06_buy_quantity       ( sq06_buy_quantity        )   , //申买量 4
.sq06_sell_price         ( sq06_sell_price          )   , //申买价 8
.sq06_sell_quantity      ( sq06_sell_quantity       )   , //申卖量 4
.sq06_market_rdy         ( sq06_market_rdy          )   ,

.sq07_market_explain     ( sq07_market_explain      )   , //市场说明 3
.sq07_info_classify      ( sq07_info_classify       )   , //信息分类 1
.sq07_dialog_num         ( sq07_dialog_num          )   , //会话编号 4
.sq07_contract_flag      ( sq07_contract_flag       )   , //合约标志 1
.sq07_contract_num       ( sq07_contract_num        )   , //合约编号 4
.sq07_contract_code      ( sq07_contract_code       )   , //合约代码 22
.sq07_update_time        ( sq07_update_time         )   , //更新时间 9
.sq07_update_ms          ( sq07_update_ms           )   , //更新毫秒 4
.sq07_new_price          ( sq07_new_price           )   , //最新价 8
.sq07_turnover           ( sq07_turnover            )   , //成交量 4
.sq07_volume             ( sq07_volume              )   , //成交额 8   
.sq07_position           ( sq07_position            )   , //持仓量 8
.sq07_purchase_price     ( sq07_purchase_price      )   , //申买价 8
.sq07_buy_quantity       ( sq07_buy_quantity        )   , //申买量 4
.sq07_sell_price         ( sq07_sell_price          )   , //申买价 8
.sq07_sell_quantity      ( sq07_sell_quantity       )   , //申卖量 4
.sq07_market_rdy         ( sq07_market_rdy          )   ,

.sq08_market_explain     ( sq08_market_explain      )   , //市场说明 3
.sq08_info_classify      ( sq08_info_classify       )   , //信息分类 1
.sq08_dialog_num         ( sq08_dialog_num          )   , //会话编号 4
.sq08_contract_flag      ( sq08_contract_flag       )   , //合约标志 1
.sq08_contract_num       ( sq08_contract_num        )   , //合约编号 4
.sq08_contract_code      ( sq08_contract_code       )   , //合约代码 22
.sq08_update_time        ( sq08_update_time         )   , //更新时间 9
.sq08_update_ms          ( sq08_update_ms           )   , //更新毫秒 4
.sq08_new_price          ( sq08_new_price           )   , //最新价 8
.sq08_turnover           ( sq08_turnover            )   , //成交量 4
.sq08_volume             ( sq08_volume              )   , //成交额 8   
.sq08_position           ( sq08_position            )   , //持仓量 8
.sq08_purchase_price     ( sq08_purchase_price      )   , //申买价 8
.sq08_buy_quantity       ( sq08_buy_quantity        )   , //申买量 4
.sq08_sell_price         ( sq08_sell_price          )   , //申买价 8
.sq08_sell_quantity      ( sq08_sell_quantity       )   , //申卖量 4
.sq08_market_rdy         ( sq08_market_rdy          )   ,

.sq09_market_explain     ( sq09_market_explain      )   , //市场说明 3
.sq09_info_classify      ( sq09_info_classify       )   , //信息分类 1
.sq09_dialog_num         ( sq09_dialog_num          )   , //会话编号 4
.sq09_contract_flag      ( sq09_contract_flag       )   , //合约标志 1
.sq09_contract_num       ( sq09_contract_num        )   , //合约编号 4
.sq09_contract_code      ( sq09_contract_code       )   , //合约代码 22
.sq09_update_time        ( sq09_update_time         )   , //更新时间 9
.sq09_update_ms          ( sq09_update_ms           )   , //更新毫秒 4
.sq09_new_price          ( sq09_new_price           )   , //最新价 8
.sq09_turnover           ( sq09_turnover            )   , //成交量 4
.sq09_volume             ( sq09_volume              )   , //成交额 8   
.sq09_position           ( sq09_position            )   , //持仓量 8
.sq09_purchase_price     ( sq09_purchase_price      )   , //申买价 8
.sq09_buy_quantity       ( sq09_buy_quantity        )   , //申买量 4
.sq09_sell_price         ( sq09_sell_price          )   , //申买价 8
.sq09_sell_quantity      ( sq09_sell_quantity       )   , //申卖量 4
.sq09_market_rdy         ( sq09_market_rdy          )   ,

.sq10_market_explain     ( sq10_market_explain      )   , //市场说明 3
.sq10_info_classify      ( sq10_info_classify       )   , //信息分类 1
.sq10_dialog_num         ( sq10_dialog_num          )   , //会话编号 4
.sq10_contract_flag      ( sq10_contract_flag       )   , //合约标志 1
.sq10_contract_num       ( sq10_contract_num        )   , //合约编号 4
.sq10_contract_code      ( sq10_contract_code       )   , //合约代码 22
.sq10_update_time        ( sq10_update_time         )   , //更新时间 9
.sq10_update_ms          ( sq10_update_ms           )   , //更新毫秒 4
.sq10_new_price          ( sq10_new_price           )   , //最新价 8
.sq10_turnover           ( sq10_turnover            )   , //成交量 4
.sq10_volume             ( sq10_volume              )   , //成交额 8   
.sq10_position           ( sq10_position            )   , //持仓量 8
.sq10_purchase_price     ( sq10_purchase_price      )   , //申买价 8
.sq10_buy_quantity       ( sq10_buy_quantity        )   , //申买量 4
.sq10_sell_price         ( sq10_sell_price          )   , //申买价 8
.sq10_sell_quantity      ( sq10_sell_quantity       )   , //申卖量 4
.sq10_market_rdy         ( sq10_market_rdy          )   ,

.sq11_market_explain     ( sq11_market_explain      )   , //市场说明 3
.sq11_info_classify      ( sq11_info_classify       )   , //信息分类 1
.sq11_dialog_num         ( sq11_dialog_num          )   , //会话编号 4
.sq11_contract_flag      ( sq11_contract_flag       )   , //合约标志 1
.sq11_contract_num       ( sq11_contract_num        )   , //合约编号 4
.sq11_contract_code      ( sq11_contract_code       )   , //合约代码 22
.sq11_update_time        ( sq11_update_time         )   , //更新时间 9
.sq11_update_ms          ( sq11_update_ms           )   , //更新毫秒 4
.sq11_new_price          ( sq11_new_price           )   , //最新价 8
.sq11_turnover           ( sq11_turnover            )   , //成交量 4
.sq11_volume             ( sq11_volume              )   , //成交额 8   
.sq11_position           ( sq11_position            )   , //持仓量 8
.sq11_purchase_price     ( sq11_purchase_price      )   , //申买价 8
.sq11_buy_quantity       ( sq11_buy_quantity        )   , //申买量 4
.sq11_sell_price         ( sq11_sell_price          )   , //申买价 8
.sq11_sell_quantity      ( sq11_sell_quantity       )   , //申卖量 4
.sq11_market_rdy         ( sq11_market_rdy          )   ,

.sq12_market_explain     ( sq12_market_explain      )   , //市场说明 3
.sq12_info_classify      ( sq12_info_classify       )   , //信息分类 1
.sq12_dialog_num         ( sq12_dialog_num          )   , //会话编号 4
.sq12_contract_flag      ( sq12_contract_flag       )   , //合约标志 1
.sq12_contract_num       ( sq12_contract_num        )   , //合约编号 4
.sq12_contract_code      ( sq12_contract_code       )   , //合约代码 22
.sq12_update_time        ( sq12_update_time         )   , //更新时间 9
.sq12_update_ms          ( sq12_update_ms           )   , //更新毫秒 4
.sq12_new_price          ( sq12_new_price           )   , //最新价 8
.sq12_turnover           ( sq12_turnover            )   , //成交量 4
.sq12_volume             ( sq12_volume              )   , //成交额 8   
.sq12_position           ( sq12_position            )   , //持仓量 8
.sq12_purchase_price     ( sq12_purchase_price      )   , //申买价 8
.sq12_buy_quantity       ( sq12_buy_quantity        )   , //申买量 4
.sq12_sell_price         ( sq12_sell_price          )   , //申买价 8
.sq12_sell_quantity      ( sq12_sell_quantity       )   , //申卖量 4
.sq12_market_rdy         ( sq12_market_rdy          )   ,

.sq13_market_explain     ( sq13_market_explain      )   , //市场说明 3
.sq13_info_classify      ( sq13_info_classify       )   , //信息分类 1
.sq13_dialog_num         ( sq13_dialog_num          )   , //会话编号 4
.sq13_contract_flag      ( sq13_contract_flag       )   , //合约标志 1
.sq13_contract_num       ( sq13_contract_num        )   , //合约编号 4
.sq13_contract_code      ( sq13_contract_code       )   , //合约代码 22
.sq13_update_time        ( sq13_update_time         )   , //更新时间 9
.sq13_update_ms          ( sq13_update_ms           )   , //更新毫秒 4
.sq13_new_price          ( sq13_new_price           )   , //最新价 8
.sq13_turnover           ( sq13_turnover            )   , //成交量 4
.sq13_volume             ( sq13_volume              )   , //成交额 8   
.sq13_position           ( sq13_position            )   , //持仓量 8
.sq13_purchase_price     ( sq13_purchase_price      )   , //申买价 8
.sq13_buy_quantity       ( sq13_buy_quantity        )   , //申买量 4
.sq13_sell_price         ( sq13_sell_price          )   , //申买价 8
.sq13_sell_quantity      ( sq13_sell_quantity       )   , //申卖量 4
.sq13_market_rdy         ( sq13_market_rdy          )   ,

.sq14_market_explain     ( sq14_market_explain      )   , //市场说明 3
.sq14_info_classify      ( sq14_info_classify       )   , //信息分类 1
.sq14_dialog_num         ( sq14_dialog_num          )   , //会话编号 4
.sq14_contract_flag      ( sq14_contract_flag       )   , //合约标志 1
.sq14_contract_num       ( sq14_contract_num        )   , //合约编号 4
.sq14_contract_code      ( sq14_contract_code       )   , //合约代码 22
.sq14_update_time        ( sq14_update_time         )   , //更新时间 9
.sq14_update_ms          ( sq14_update_ms           )   , //更新毫秒 4
.sq14_new_price          ( sq14_new_price           )   , //最新价 8
.sq14_turnover           ( sq14_turnover            )   , //成交量 4
.sq14_volume             ( sq14_volume              )   , //成交额 8   
.sq14_position           ( sq14_position            )   , //持仓量 8
.sq14_purchase_price     ( sq14_purchase_price      )   , //申买价 8
.sq14_buy_quantity       ( sq14_buy_quantity        )   , //申买量 4
.sq14_sell_price         ( sq14_sell_price          )   , //申买价 8
.sq14_sell_quantity      ( sq14_sell_quantity       )   , //申卖量 4
.sq14_market_rdy         ( sq14_market_rdy          )   ,

.sq15_market_explain     ( sq15_market_explain      )   , //市场说明 3
.sq15_info_classify      ( sq15_info_classify       )   , //信息分类 1
.sq15_dialog_num         ( sq15_dialog_num          )   , //会话编号 4
.sq15_contract_flag      ( sq15_contract_flag       )   , //合约标志 1
.sq15_contract_num       ( sq15_contract_num        )   , //合约编号 4
.sq15_contract_code      ( sq15_contract_code       )   , //合约代码 22
.sq15_update_time        ( sq15_update_time         )   , //更新时间 9
.sq15_update_ms          ( sq15_update_ms           )   , //更新毫秒 4
.sq15_new_price          ( sq15_new_price           )   , //最新价 8
.sq15_turnover           ( sq15_turnover            )   , //成交量 4
.sq15_volume             ( sq15_volume              )   , //成交额 8   
.sq15_position           ( sq15_position            )   , //持仓量 8
.sq15_purchase_price     ( sq15_purchase_price      )   , //申买价 8
.sq15_buy_quantity       ( sq15_buy_quantity        )   , //申买量 4
.sq15_sell_price         ( sq15_sell_price          )   , //申买价 8
.sq15_sell_quantity      ( sq15_sell_quantity       )   , //申卖量 4
.sq15_market_rdy         ( sq15_market_rdy          )   ,

.sq16_market_explain     ( sq16_market_explain      )   , //市场说明 3
.sq16_info_classify      ( sq16_info_classify       )   , //信息分类 1
.sq16_dialog_num         ( sq16_dialog_num          )   , //会话编号 4
.sq16_contract_flag      ( sq16_contract_flag       )   , //合约标志 1
.sq16_contract_num       ( sq16_contract_num        )   , //合约编号 4
.sq16_contract_code      ( sq16_contract_code       )   , //合约代码 22
.sq16_update_time        ( sq16_update_time         )   , //更新时间 9
.sq16_update_ms          ( sq16_update_ms           )   , //更新毫秒 4
.sq16_new_price          ( sq16_new_price           )   , //最新价 8
.sq16_turnover           ( sq16_turnover            )   , //成交量 4
.sq16_volume             ( sq16_volume              )   , //成交额 8   
.sq16_position           ( sq16_position            )   , //持仓量 8
.sq16_purchase_price     ( sq16_purchase_price      )   , //申买价 8
.sq16_buy_quantity       ( sq16_buy_quantity        )   , //申买量 4
.sq16_sell_price         ( sq16_sell_price          )   , //申买价 8
.sq16_sell_quantity      ( sq16_sell_quantity       )   , //申卖量 4
.sq16_market_rdy         ( sq16_market_rdy          )   ,

.sq17_market_explain     ( sq17_market_explain      )   , //市场说明 3
.sq17_info_classify      ( sq17_info_classify       )   , //信息分类 1
.sq17_dialog_num         ( sq17_dialog_num          )   , //会话编号 4
.sq17_contract_flag      ( sq17_contract_flag       )   , //合约标志 1
.sq17_contract_num       ( sq17_contract_num        )   , //合约编号 4
.sq17_contract_code      ( sq17_contract_code       )   , //合约代码 22
.sq17_update_time        ( sq17_update_time         )   , //更新时间 9
.sq17_update_ms          ( sq17_update_ms           )   , //更新毫秒 4
.sq17_new_price          ( sq17_new_price           )   , //最新价 8
.sq17_turnover           ( sq17_turnover            )   , //成交量 4
.sq17_volume             ( sq17_volume              )   , //成交额 8   
.sq17_position           ( sq17_position            )   , //持仓量 8
.sq17_purchase_price     ( sq17_purchase_price      )   , //申买价 8
.sq17_buy_quantity       ( sq17_buy_quantity        )   , //申买量 4
.sq17_sell_price         ( sq17_sell_price          )   , //申买价 8
.sq17_sell_quantity      ( sq17_sell_quantity       )   , //申卖量 4
.sq17_market_rdy         ( sq17_market_rdy          )   ,

.sq18_market_explain     ( sq18_market_explain      )   , //市场说明 3
.sq18_info_classify      ( sq18_info_classify       )   , //信息分类 1
.sq18_dialog_num         ( sq18_dialog_num          )   , //会话编号 4
.sq18_contract_flag      ( sq18_contract_flag       )   , //合约标志 1
.sq18_contract_num       ( sq18_contract_num        )   , //合约编号 4
.sq18_contract_code      ( sq18_contract_code       )   , //合约代码 22
.sq18_update_time        ( sq18_update_time         )   , //更新时间 9
.sq18_update_ms          ( sq18_update_ms           )   , //更新毫秒 4
.sq18_new_price          ( sq18_new_price           )   , //最新价 8
.sq18_turnover           ( sq18_turnover            )   , //成交量 4
.sq18_volume             ( sq18_volume              )   , //成交额 8   
.sq18_position           ( sq18_position            )   , //持仓量 8
.sq18_purchase_price     ( sq18_purchase_price      )   , //申买价 8
.sq18_buy_quantity       ( sq18_buy_quantity        )   , //申买量 4
.sq18_sell_price         ( sq18_sell_price          )   , //申买价 8
.sq18_sell_quantity      ( sq18_sell_quantity       )   , //申卖量 4
.sq18_market_rdy         ( sq18_market_rdy          )   ,

.sq19_market_explain     ( sq19_market_explain      )   , //市场说明 3
.sq19_info_classify      ( sq19_info_classify       )   , //信息分类 1
.sq19_dialog_num         ( sq19_dialog_num          )   , //会话编号 4
.sq19_contract_flag      ( sq19_contract_flag       )   , //合约标志 1
.sq19_contract_num       ( sq19_contract_num        )   , //合约编号 4
.sq19_contract_code      ( sq19_contract_code       )   , //合约代码 22
.sq19_update_time        ( sq19_update_time         )   , //更新时间 9
.sq19_update_ms          ( sq19_update_ms           )   , //更新毫秒 4
.sq19_new_price          ( sq19_new_price           )   , //最新价 8
.sq19_turnover           ( sq19_turnover            )   , //成交量 4
.sq19_volume             ( sq19_volume              )   , //成交额 8   
.sq19_position           ( sq19_position            )   , //持仓量 8
.sq19_purchase_price     ( sq19_purchase_price      )   , //申买价 8
.sq19_buy_quantity       ( sq19_buy_quantity        )   , //申买量 4
.sq19_sell_price         ( sq19_sell_price          )   , //申买价 8
.sq19_sell_quantity      ( sq19_sell_quantity       )   , //申卖量 4
.sq19_market_rdy         ( sq19_market_rdy          )   ,

.sq20_market_explain     ( sq20_market_explain      )   , //市场说明 3
.sq20_info_classify      ( sq20_info_classify       )   , //信息分类 1
.sq20_dialog_num         ( sq20_dialog_num          )   , //会话编号 4
.sq20_contract_flag      ( sq20_contract_flag       )   , //合约标志 1
.sq20_contract_num       ( sq20_contract_num        )   , //合约编号 4
.sq20_contract_code      ( sq20_contract_code       )   , //合约代码 22
.sq20_update_time        ( sq20_update_time         )   , //更新时间 9
.sq20_update_ms          ( sq20_update_ms           )   , //更新毫秒 4
.sq20_new_price          ( sq20_new_price           )   , //最新价 8
.sq20_turnover           ( sq20_turnover            )   , //成交量 4
.sq20_volume             ( sq20_volume              )   , //成交额 8   
.sq20_position           ( sq20_position            )   , //持仓量 8
.sq20_purchase_price     ( sq20_purchase_price      )   , //申买价 8
.sq20_buy_quantity       ( sq20_buy_quantity        )   , //申买量 4
.sq20_sell_price         ( sq20_sell_price          )   , //申买价 8
.sq20_sell_quantity      ( sq20_sell_quantity       )   , //申卖量 4
.sq20_market_rdy         ( sq20_market_rdy          )   ,

.sq21_market_explain     ( sq21_market_explain      )   , //市场说明 3
.sq21_info_classify      ( sq21_info_classify       )   , //信息分类 1
.sq21_dialog_num         ( sq21_dialog_num          )   , //会话编号 4
.sq21_contract_flag      ( sq21_contract_flag       )   , //合约标志 1
.sq21_contract_num       ( sq21_contract_num        )   , //合约编号 4
.sq21_contract_code      ( sq21_contract_code       )   , //合约代码 22
.sq21_update_time        ( sq21_update_time         )   , //更新时间 9
.sq21_update_ms          ( sq21_update_ms           )   , //更新毫秒 4
.sq21_new_price          ( sq21_new_price           )   , //最新价 8
.sq21_turnover           ( sq21_turnover            )   , //成交量 4
.sq21_volume             ( sq21_volume              )   , //成交额 8   
.sq21_position           ( sq21_position            )   , //持仓量 8
.sq21_purchase_price     ( sq21_purchase_price      )   , //申买价 8
.sq21_buy_quantity       ( sq21_buy_quantity        )   , //申买量 4
.sq21_sell_price         ( sq21_sell_price          )   , //申买价 8
.sq21_sell_quantity      ( sq21_sell_quantity       )   , //申卖量 4
.sq21_market_rdy         ( sq21_market_rdy          )   ,

.sq22_market_explain     ( sq22_market_explain      )   , //市场说明 3
.sq22_info_classify      ( sq22_info_classify       )   , //信息分类 1
.sq22_dialog_num         ( sq22_dialog_num          )   , //会话编号 4
.sq22_contract_flag      ( sq22_contract_flag       )   , //合约标志 1
.sq22_contract_num       ( sq22_contract_num        )   , //合约编号 4
.sq22_contract_code      ( sq22_contract_code       )   , //合约代码 22
.sq22_update_time        ( sq22_update_time         )   , //更新时间 9
.sq22_update_ms          ( sq22_update_ms           )   , //更新毫秒 4
.sq22_new_price          ( sq22_new_price           )   , //最新价 8
.sq22_turnover           ( sq22_turnover            )   , //成交量 4
.sq22_volume             ( sq22_volume              )   , //成交额 8   
.sq22_position           ( sq22_position            )   , //持仓量 8
.sq22_purchase_price     ( sq22_purchase_price      )   , //申买价 8
.sq22_buy_quantity       ( sq22_buy_quantity        )   , //申买量 4
.sq22_sell_price         ( sq22_sell_price          )   , //申买价 8
.sq22_sell_quantity      ( sq22_sell_quantity       )   , //申卖量 4
.sq22_market_rdy         ( sq22_market_rdy          )   ,

.sq23_market_explain     ( sq23_market_explain      )   , //市场说明 3
.sq23_info_classify      ( sq23_info_classify       )   , //信息分类 1
.sq23_dialog_num         ( sq23_dialog_num          )   , //会话编号 4
.sq23_contract_flag      ( sq23_contract_flag       )   , //合约标志 1
.sq23_contract_num       ( sq23_contract_num        )   , //合约编号 4
.sq23_contract_code      ( sq23_contract_code       )   , //合约代码 22
.sq23_update_time        ( sq23_update_time         )   , //更新时间 9
.sq23_update_ms          ( sq23_update_ms           )   , //更新毫秒 4
.sq23_new_price          ( sq23_new_price           )   , //最新价 8
.sq23_turnover           ( sq23_turnover            )   , //成交量 4
.sq23_volume             ( sq23_volume              )   , //成交额 8   
.sq23_position           ( sq23_position            )   , //持仓量 8
.sq23_purchase_price     ( sq23_purchase_price      )   , //申买价 8
.sq23_buy_quantity       ( sq23_buy_quantity        )   , //申买量 4
.sq23_sell_price         ( sq23_sell_price          )   , //申买价 8
.sq23_sell_quantity      ( sq23_sell_quantity       )   , //申卖量 4
.sq23_market_rdy         ( sq23_market_rdy          )   ,

.sq24_market_explain     ( sq24_market_explain      )   , //市场说明 3
.sq24_info_classify      ( sq24_info_classify       )   , //信息分类 1
.sq24_dialog_num         ( sq24_dialog_num          )   , //会话编号 4
.sq24_contract_flag      ( sq24_contract_flag       )   , //合约标志 1
.sq24_contract_num       ( sq24_contract_num        )   , //合约编号 4
.sq24_contract_code      ( sq24_contract_code       )   , //合约代码 22
.sq24_update_time        ( sq24_update_time         )   , //更新时间 9
.sq24_update_ms          ( sq24_update_ms           )   , //更新毫秒 4
.sq24_new_price          ( sq24_new_price           )   , //最新价 8
.sq24_turnover           ( sq24_turnover            )   , //成交量 4
.sq24_volume             ( sq24_volume              )   , //成交额 8   
.sq24_position           ( sq24_position            )   , //持仓量 8
.sq24_purchase_price     ( sq24_purchase_price      )   , //申买价 8
.sq24_buy_quantity       ( sq24_buy_quantity        )   , //申买量 4
.sq24_sell_price         ( sq24_sell_price          )   , //申买价 8
.sq24_sell_quantity      ( sq24_sell_quantity       )   , //申卖量 4
.sq24_market_rdy         ( sq24_market_rdy          )   ,

.sq25_market_explain     ( sq25_market_explain      )   , //市场说明 3
.sq25_info_classify      ( sq25_info_classify       )   , //信息分类 1
.sq25_dialog_num         ( sq25_dialog_num          )   , //会话编号 4
.sq25_contract_flag      ( sq25_contract_flag       )   , //合约标志 1
.sq25_contract_num       ( sq25_contract_num        )   , //合约编号 4
.sq25_contract_code      ( sq25_contract_code       )   , //合约代码 22
.sq25_update_time        ( sq25_update_time         )   , //更新时间 9
.sq25_update_ms          ( sq25_update_ms           )   , //更新毫秒 4
.sq25_new_price          ( sq25_new_price           )   , //最新价 8
.sq25_turnover           ( sq25_turnover            )   , //成交量 4
.sq25_volume             ( sq25_volume              )   , //成交额 8   
.sq25_position           ( sq25_position            )   , //持仓量 8
.sq25_purchase_price     ( sq25_purchase_price      )   , //申买价 8
.sq25_buy_quantity       ( sq25_buy_quantity        )   , //申买量 4
.sq25_sell_price         ( sq25_sell_price          )   , //申买价 8
.sq25_sell_quantity      ( sq25_sell_quantity       )   , //申卖量 4
.sq25_market_rdy         ( sq25_market_rdy          )   ,

.sq26_market_explain     ( sq26_market_explain      )   , //市场说明 3
.sq26_info_classify      ( sq26_info_classify       )   , //信息分类 1
.sq26_dialog_num         ( sq26_dialog_num          )   , //会话编号 4
.sq26_contract_flag      ( sq26_contract_flag       )   , //合约标志 1
.sq26_contract_num       ( sq26_contract_num        )   , //合约编号 4
.sq26_contract_code      ( sq26_contract_code       )   , //合约代码 22
.sq26_update_time        ( sq26_update_time         )   , //更新时间 9
.sq26_update_ms          ( sq26_update_ms           )   , //更新毫秒 4
.sq26_new_price          ( sq26_new_price           )   , //最新价 8
.sq26_turnover           ( sq26_turnover            )   , //成交量 4
.sq26_volume             ( sq26_volume              )   , //成交额 8   
.sq26_position           ( sq26_position            )   , //持仓量 8
.sq26_purchase_price     ( sq26_purchase_price      )   , //申买价 8
.sq26_buy_quantity       ( sq26_buy_quantity        )   , //申买量 4
.sq26_sell_price         ( sq26_sell_price          )   , //申买价 8
.sq26_sell_quantity      ( sq26_sell_quantity       )   , //申卖量 4
.sq26_market_rdy         ( sq26_market_rdy          )   ,

.sq27_market_explain     ( sq27_market_explain      )   , //市场说明 3
.sq27_info_classify      ( sq27_info_classify       )   , //信息分类 1
.sq27_dialog_num         ( sq27_dialog_num          )   , //会话编号 4
.sq27_contract_flag      ( sq27_contract_flag       )   , //合约标志 1
.sq27_contract_num       ( sq27_contract_num        )   , //合约编号 4
.sq27_contract_code      ( sq27_contract_code       )   , //合约代码 22
.sq27_update_time        ( sq27_update_time         )   , //更新时间 9
.sq27_update_ms          ( sq27_update_ms           )   , //更新毫秒 4
.sq27_new_price          ( sq27_new_price           )   , //最新价 8
.sq27_turnover           ( sq27_turnover            )   , //成交量 4
.sq27_volume             ( sq27_volume              )   , //成交额 8   
.sq27_position           ( sq27_position            )   , //持仓量 8
.sq27_purchase_price     ( sq27_purchase_price      )   , //申买价 8
.sq27_buy_quantity       ( sq27_buy_quantity        )   , //申买量 4
.sq27_sell_price         ( sq27_sell_price          )   , //申买价 8
.sq27_sell_quantity      ( sq27_sell_quantity       )   , //申卖量 4
.sq27_market_rdy         ( sq27_market_rdy          )   ,

.sq28_market_explain     ( sq28_market_explain      )   , //市场说明 3
.sq28_info_classify      ( sq28_info_classify       )   , //信息分类 1
.sq28_dialog_num         ( sq28_dialog_num          )   , //会话编号 4
.sq28_contract_flag      ( sq28_contract_flag       )   , //合约标志 1
.sq28_contract_num       ( sq28_contract_num        )   , //合约编号 4
.sq28_contract_code      ( sq28_contract_code       )   , //合约代码 22
.sq28_update_time        ( sq28_update_time         )   , //更新时间 9
.sq28_update_ms          ( sq28_update_ms           )   , //更新毫秒 4
.sq28_new_price          ( sq28_new_price           )   , //最新价 8
.sq28_turnover           ( sq28_turnover            )   , //成交量 4
.sq28_volume             ( sq28_volume              )   , //成交额 8   
.sq28_position           ( sq28_position            )   , //持仓量 8
.sq28_purchase_price     ( sq28_purchase_price      )   , //申买价 8
.sq28_buy_quantity       ( sq28_buy_quantity        )   , //申买量 4
.sq28_sell_price         ( sq28_sell_price          )   , //申买价 8
.sq28_sell_quantity      ( sq28_sell_quantity       )   , //申卖量 4
.sq28_market_rdy         ( sq28_market_rdy          )   ,

.sq29_market_explain     ( sq29_market_explain      )   , //市场说明 3
.sq29_info_classify      ( sq29_info_classify       )   , //信息分类 1
.sq29_dialog_num         ( sq29_dialog_num          )   , //会话编号 4
.sq29_contract_flag      ( sq29_contract_flag       )   , //合约标志 1
.sq29_contract_num       ( sq29_contract_num        )   , //合约编号 4
.sq29_contract_code      ( sq29_contract_code       )   , //合约代码 22
.sq29_update_time        ( sq29_update_time         )   , //更新时间 9
.sq29_update_ms          ( sq29_update_ms           )   , //更新毫秒 4
.sq29_new_price          ( sq29_new_price           )   , //最新价 8
.sq29_turnover           ( sq29_turnover            )   , //成交量 4
.sq29_volume             ( sq29_volume              )   , //成交额 8   
.sq29_position           ( sq29_position            )   , //持仓量 8
.sq29_purchase_price     ( sq29_purchase_price      )   , //申买价 8
.sq29_buy_quantity       ( sq29_buy_quantity        )   , //申买量 4
.sq29_sell_price         ( sq29_sell_price          )   , //申买价 8
.sq29_sell_quantity      ( sq29_sell_quantity       )   , //申卖量 4
.sq29_market_rdy         ( sq29_market_rdy          )   ,

.sq30_market_explain     ( sq30_market_explain      )   , //市场说明 3
.sq30_info_classify      ( sq30_info_classify       )   , //信息分类 1
.sq30_dialog_num         ( sq30_dialog_num          )   , //会话编号 4
.sq30_contract_flag      ( sq30_contract_flag       )   , //合约标志 1
.sq30_contract_num       ( sq30_contract_num        )   , //合约编号 4
.sq30_contract_code      ( sq30_contract_code       )   , //合约代码 22
.sq30_update_time        ( sq30_update_time         )   , //更新时间 9
.sq30_update_ms          ( sq30_update_ms           )   , //更新毫秒 4
.sq30_new_price          ( sq30_new_price           )   , //最新价 8
.sq30_turnover           ( sq30_turnover            )   , //成交量 4
.sq30_volume             ( sq30_volume              )   , //成交额 8   
.sq30_position           ( sq30_position            )   , //持仓量 8
.sq30_purchase_price     ( sq30_purchase_price      )   , //申买价 8
.sq30_buy_quantity       ( sq30_buy_quantity        )   , //申买量 4
.sq30_sell_price         ( sq30_sell_price          )   , //申买价 8
.sq30_sell_quantity      ( sq30_sell_quantity       )   , //申卖量 4
.sq30_market_rdy         ( sq30_market_rdy          )   ,

.sq31_market_explain     ( sq31_market_explain      )   , //市场说明 3
.sq31_info_classify      ( sq31_info_classify       )   , //信息分类 1
.sq31_dialog_num         ( sq31_dialog_num          )   , //会话编号 4
.sq31_contract_flag      ( sq31_contract_flag       )   , //合约标志 1
.sq31_contract_num       ( sq31_contract_num        )   , //合约编号 4
.sq31_contract_code      ( sq31_contract_code       )   , //合约代码 22
.sq31_update_time        ( sq31_update_time         )   , //更新时间 9
.sq31_update_ms          ( sq31_update_ms           )   , //更新毫秒 4
.sq31_new_price          ( sq31_new_price           )   , //最新价 8
.sq31_turnover           ( sq31_turnover            )   , //成交量 4
.sq31_volume             ( sq31_volume              )   , //成交额 8   
.sq31_position           ( sq31_position            )   , //持仓量 8
.sq31_purchase_price     ( sq31_purchase_price      )   , //申买价 8
.sq31_buy_quantity       ( sq31_buy_quantity        )   , //申买量 4
.sq31_sell_price         ( sq31_sell_price          )   , //申买价 8
.sq31_sell_quantity      ( sq31_sell_quantity       )   , //申卖量 4
.sq31_market_rdy         ( sq31_market_rdy          )   ,

//.tlp_cnt(tlp_cnt),

 .tlp_fifo_empty          (fifo_data_empty),
 .tlp_fifo_rdata          (fifo_data_out ),
 .tlp_fifo_data_vld       (fifo_data_vld),
 .fifo_ready              (fifo_ready)
// .requestor_id          ( requestor_id           )   ,
// .tlp_StReady_i         ( tlp_StReady_i          )   ,
// .tlp_StData_o          ( tlp_StData_o           )   ,
// .tlp_StSop_o           ( tlp_StSop_o            )   ,
// .tlp_StEop_o           ( tlp_StEop_o            )   ,
// .tlp_StEmpty_o         ( tlp_StEmpty_o          )   ,
// .tlp_StValid_o         ( tlp_StValid_o          )   ,         
// .st_fifo_hfull         ( st_fifo_hfull          )   ,
// .st_fifo_full          ( st_fifo_full           )   ,
// .st_fifo_empty         ( st_fifo_empty          )   ,    
// .rmem_descriptor_reg   ( rmem_descriptor_reg    )    
);






endmodule 



