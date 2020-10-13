module  wrapper_filter_rx_top (
clk                   ,
rst_n                 ,
clk_322               ,
rst_n_322            ,

params_current_sqid_reg_add,
params_current_sqid_reg_cnt,
params_current_sqid_reg_rst_cnt ,


params_current_sqid_reg_ro   ,
params_filter_rst            ,
tlp_cnt,
params_frame_type_byte ,
market_pkt_cnt_o,
mac_in_tcp_cnt,
params_03e9_type            ,
params_1389_type            ,
params_07d0_type            ,
rq_tlp_cnt,

mac_rx_sop             , 
mac_rx_eop             , 
mac_rx_valid           , 
mac_rx_data            , 
mac_rx_empty           ,
/* rmem_descriptor_reg    ,
requestor_id           ,
tlp_StData_o           ,
tlp_StSop_o            ,
tlp_StEop_o            ,
tlp_StEmpty_o          ,
tlp_StValid_o          ,         
tlp_StReady_i          ,
st_fifo_hfull          ,
st_fifo_full           ,
st_fifo_empty          ,    
error_flag     */  
fifo_data_empty,
fifo_data_out ,
fifo_data_vld,
fifo_ready       
                                             
);

input                        clk                    ;
input                        rst_n                  ;
input                        clk_322                ;
input                        rst_n_322              ;


input      [3:0]            params_current_sqid_reg_add   ;
input      [3:0]            params_current_sqid_reg_cnt   ;
input    [31:0]          params_current_sqid_reg_rst_cnt ;  // 1min  'h38000



output   [31:0]            params_current_sqid_reg_ro    ;
input                      params_filter_rst             ;
output  [31:0]          tlp_cnt;

input      [ 15: 0]          params_frame_type_byte   ; 

input    [15:0]              params_03e9_type            ;
input    [15:0]              params_1389_type            ;
input    [15:0]              params_07d0_type            ;
 

input                        mac_rx_sop             ; 
input                        mac_rx_eop             ; 
input                        mac_rx_valid           ; 
input      [ 31: 0]          mac_rx_data            ; 
input      [  1: 0]          mac_rx_empty           ;

/* input      [159: 0]          rmem_descriptor_reg    ;
input      [ 15: 0]          requestor_id           ;
output      [255: 0]         tlp_StData_o          ;
output                       tlp_StSop_o           ;
output                       tlp_StEop_o           ;
output      [  1: 0]         tlp_StEmpty_o         ;
output                       tlp_StValid_o         ;         
input                        tlp_StReady_i         ;
output                       st_fifo_hfull         ;
output                       st_fifo_full          ;
output                       st_fifo_empty         ;    
output                       error_flag            ; */

//add  
output                       fifo_data_empty;
output   [255:0]             fifo_data_out ;
output                       fifo_data_vld;
input                        fifo_ready;
 output  [63:0]        market_pkt_cnt_o; 
 output  [31:0]       mac_in_tcp_cnt;
input  [31:0]    rq_tlp_cnt;
////////////////////////////////////////////////////////



wire    [31:0]            params_current_sqid_reg_ro    ;
wire    [31:0]             current_sqid_reg;
wire                         current_sqid_reg_vld;



wire    [63:0]      pkt_in_cnt_o;
wire  [63:0]      market_pkt_cnt_o;
wire  [31:0]   mac_in_tcp_cnt;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire    [15:0]              tcp_payload_len    ;
wire    [31:0]                    sq_cut_flag        ;
wire    [31:0]                    sq_cut_reset        ;

wire    [31:0]              tcp_sqmatch_flag   ;
wire    [31:0]              seq_err_flag   ;
wire    [15:0]              first_sync_len_byte ;


wire                         st_rx_start           ; 
wire       [  3: 0]          st_rx_offset          ;
wire                         st_rx_end             ; 
wire                         st_rx_valid           ; 
wire       [ 63: 0]          st_rx_data            ; 
wire       [  2: 0]          st_rx_empty           ; 
wire       [ 15: 0]          st_rx_cnt             ; 

wire                         st_rx_ready           ;

wire  [4:0]  fir_rx_cstate;

wire                       debug_st_shift_full_flag ;
wire   [3:0]             debug_discard_calc_cnt1  ;

wire   [5:0]             debug_st_shift_scnt   ;
wire                     debug_st_shift_en     ;

wire  [31:0] error_flag       ;


wire   [15:0]            st_rx_cnt_reg        ;
wire   [ 5:0]            st_shift_ccnt        ;

parse_top_32ch   parse_search_top (
.clk_322               (  clk_322                ) ,
.rst_n_322             (  rst_n_322                  ) ,
.clk                   (  clk                    )   ,
.rst_n                 (  rst_n                  )   ,       
.params_filter_rst         (params_filter_rst),                                      
.mac_rx_sop            (  mac_rx_sop             )   , 
.mac_rx_eop            (  mac_rx_eop             )   ,
.mac_rx_vld            (  mac_rx_valid           )   , 
.mac_rx_data           (  mac_rx_data            )   , 
.mac_rx_byte           (  mac_rx_empty           )   ,

.cut_flag              (  sq_cut_flag            )   ,  //sc_cut_flag
.cut_reset             (  sq_cut_reset),   

.fivetuplematch_o      (  tcp_sqmatch_flag       )   ,  //match with pre  SQ tcp frame 
.seq_err_flag_o      (  seq_err_flag       )   ,  //match with pre  SQ tcp frame 

.first_market_byte_o   (  first_sync_len_byte    )   ,                                                                         
.market_pkt_vld_o      (st_rx_valid       ),   
.market_pkt_sop_o      (st_rx_start       ),
.market_pkt_eop_o      (st_rx_end         ),
.market_pkt_offset_o   (st_rx_offset      ),
.market_pkt_byte_o     (st_rx_empty       ),
.market_pkt_data_o     (st_rx_data        ),
.market_pkt_ready      (st_rx_ready       ),

.tcp_payload_len_o        (  tcp_payload_len        )   ,
.tcp_payload_byte_cnt_o   (  st_rx_cnt              )   ,

.fir_rx_cstate (fir_rx_cstate),
.debug_discard_calc_cnt1(debug_discard_calc_cnt1),
.debug_st_shift_full_flag(debug_st_shift_full_flag),



.params_current_sqid_reg_ro   (params_current_sqid_reg_ro),
.current_sqid_reg  (current_sqid_reg),
.current_sqid_reg_vld (current_sqid_reg_vld),




.debug_st_shift_scnt(debug_st_shift_scnt)     ,
.debug_st_shift_en  (debug_st_shift_en)      ,

.error_flag            (   error_flag            )   ,

.st_rx_cnt_reg    (st_rx_cnt_reg),
.st_shift_ccnt (st_shift_ccnt),



.pkt_in_cnt_o        (pkt_in_cnt_o),
.mac_in_tcp_cnt    (mac_in_tcp_cnt),
.rq_tlp_cnt  (rq_tlp_cnt),
.tlp_cnt(tlp_cnt),
.market_pkt_cnt_o    (market_pkt_cnt_o)

);





filter_rx_top  filter_rx_top (
.clk                   (  clk                    )   ,
.rst_n                 (  rst_n                  )   ,   


.params_current_sqid_reg_add (params_current_sqid_reg_add),
.params_current_sqid_reg_cnt (params_current_sqid_reg_cnt),
.params_current_sqid_reg_rst_cnt (params_current_sqid_reg_rst_cnt),


.fir_rx_cstate (fir_rx_cstate),
.debug_discard_calc_cnt1(debug_discard_calc_cnt1),
.debug_st_shift_full_flag(debug_st_shift_full_flag),
.tlp_cnt(tlp_cnt),
.debug_st_shift_scnt(debug_st_shift_scnt)     ,
.debug_st_shift_en  (debug_st_shift_en)      ,



.st_rx_cnt_reg    (st_rx_cnt_reg),
.st_shift_ccnt (st_shift_ccnt),




.params_current_sqid_reg_ro   (params_current_sqid_reg_ro),
.current_sqid_reg  (current_sqid_reg),
.current_sqid_reg_vld (current_sqid_reg_vld),




.params_filter_rst            (params_filter_rst),

.params_frame_type_byte (params_frame_type_byte  )   ,

.params_03e9_type  (params_03e9_type),
.params_1389_type  (params_1389_type),
.params_07d0_type  (params_07d0_type),
                                          
.st_rx_start           (  st_rx_start            )   , 
.st_rx_offset          (  st_rx_offset           )   ,
.st_rx_end             (  st_rx_end              )   , 
.st_rx_valid           (  st_rx_valid            )   , 
.st_rx_data            (  st_rx_data             )   , 
.st_rx_empty           (  st_rx_empty            )   , 
.st_rx_cnt             (  st_rx_cnt              )   , 
.st_rx_ready           (  st_rx_ready            )   , 
  
.first_sync_len_byte   (  first_sync_len_byte    )   ,                                                                                       
.tcp_sqmatch_flag      (  tcp_sqmatch_flag       )   ,  //match with pre  SQ tcp frame 
.seq_err_flag      (  seq_err_flag       )   ,  //match with pre  SQ tcp frame 
.error_flag            (   error_flag            )   ,
.sq_cut_flag           (  sq_cut_flag            )   ,  //cut _flag                                                                                  
.sq_cut_reset          (  sq_cut_reset),   

.tcp_payload_len       (  tcp_payload_len        )   ,

 .fifo_data_empty       (fifo_data_empty),
 .fifo_data_out         (fifo_data_out ),
 .fifo_data_vld         (fifo_data_vld),
 .fifo_ready            (fifo_ready)


// .requestor_id          (  requestor_id           )   ,
// .tlp_StReady_i         (  tlp_StReady_i          )   ,
// .tlp_StData_o          (  tlp_StData_o           )   ,
// .tlp_StSop_o           (  tlp_StSop_o            )   ,
// .tlp_StEop_o           (  tlp_StEop_o            )   ,
// .tlp_StEmpty_o         (  tlp_StEmpty_o          )   ,
// .tlp_StValid_o         (  tlp_StValid_o          )   ,         
// .st_fifo_hfull         (  st_fifo_hfull          )   ,
// .st_fifo_full          (  st_fifo_full           )   ,
// .st_fifo_empty         (  st_fifo_empty          )   ,    
// .rmem_descriptor_reg   (  rmem_descriptor_reg    )    
);

//ila_mac u_ila_mac (
//	.clk(clk_322), // input wire clk

//	.probe0({mac_rx_sop,rst_n_322,rst_n}), // input wire [9:0]  probe0  
//	.probe1(pkt_in_cnt_o[31:0]), // input wire [31:0]  probe1 
//	.probe2(mac_rx_valid), // input wire [0:0]  probe2 
//	.probe3(mac_rx_eop), // input wire [0:0]  probe3 
//	.probe4(mac_rx_empty), // input wire [1:0]  probe4 
//    .probe5(mac_rx_data) // input wire [63:0]  probe4 
//);

//ila_mac u2_2ila_mac (
//	.clk(clk), // input wire clk

//	.probe0({st_rx_start,st_rx_end}), // input wire [9:0]  probe0  
//	.probe1(market_pkt_cnt_o[31:0]), // input wire [31:0]  probe1 
//	.probe2(fifo_data_vld), // input wire [0:0]  probe2 
//	.probe3(fifo_ready), // input wire [0:0]  probe3 
//	.probe4(st_rx_valid), // input wire [1:0]  probe4 
//    .probe5(st_rx_data) // input wire [63:0]  probe4 st_rx_data
//);

	
endmodule



