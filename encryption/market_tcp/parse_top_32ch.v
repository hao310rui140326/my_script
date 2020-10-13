//
//
module parse_top_32ch
(
   

             clk_322,
             rst_n_322,  
             clk,
             rst_n,
             params_filter_rst,
  //signals with mac core rx
               mac_rx_vld,
  mac_rx_data,
              mac_rx_sop,
              mac_rx_eop,
  mac_rx_byte,
    
  //signals with filter
     cut_flag,            //valid before rx_sop, valid for a pulse
     cut_reset,  

  
         tcp_payload_len_o,           //no jumbo pkt, <1518  ,not inclued FCS,valid  when sop is valid
         tcp_payload_byte_cnt_o,
  fivetuplematch_o, 
  seq_err_flag_o, 
  
                  market_pkt_ready,
                 market_pkt_vld_o,
  market_pkt_data_o,
                 market_pkt_sop_o,           //start from tcp payload
  market_pkt_offset_o,        // unit of byte, the value means the invalid bytes
                 market_pkt_eop_o,         
  market_pkt_byte_o,
 first_market_byte_o,
  
   tlp_cnt,
 rq_tlp_cnt,
  
        fir_rx_cstate,
                    debug_st_shift_full_flag ,
          debug_discard_calc_cnt1  ,
         st_rx_cnt_reg        ,
         st_shift_ccnt        ,
          debug_st_shift_scnt   ,
                    debug_st_shift_en     ,

      params_current_sqid_reg_ro  ,
      current_sqid_reg         ,
                    current_sqid_reg_vld         ,




  
         error_flag,

  //dbg signals
      pkt_in_cnt_o,
    mac_in_tcp_cnt,
      market_pkt_cnt_o
   
);

  input           clk_322;
  input           rst_n_322;  
  input           clk;
  input           rst_n;
  input           params_filter_rst;
  //signals with mac core rx
  input             mac_rx_vld;
  input    [31:0]  mac_rx_data;
  input            mac_rx_sop;
  input            mac_rx_eop;
  input     [1:0]  mac_rx_byte;
    
  //signals with filter
  input     [31:0]     cut_flag;            //valid before rx_sop, valid for a pulse
  input     [31:0]     cut_reset;  

  
  output       [15:0]         tcp_payload_len_o;           //no jumbo pkt, <1518  ,not inclued FCS,valid  when sop is valid
  output       [15:0]         tcp_payload_byte_cnt_o;
  output       [31:0]  fivetuplematch_o; 
  output       [31:0]  seq_err_flag_o; 
  
  input                market_pkt_ready;
  output               market_pkt_vld_o;
  output       [63:0]  market_pkt_data_o;
  output               market_pkt_sop_o;           //start from tcp payload
  output        [3:0]  market_pkt_offset_o;        // unit of byte, the value means the invalid bytes
  output               market_pkt_eop_o;         
  output        [2:0]  market_pkt_byte_o;
  output        [15:0] first_market_byte_o;
  
  input  [31:0]   tlp_cnt;
  input   [31:0] rq_tlp_cnt;
  
  input   [4:0]        fir_rx_cstate;
  input                  debug_st_shift_full_flag ;
  input   [3:0]          debug_discard_calc_cnt1  ;
  input   [15:0]         st_rx_cnt_reg        ;
  input   [ 5:0]         st_shift_ccnt        ;
  input   [5:0]          debug_st_shift_scnt   ;
  input                  debug_st_shift_en     ;

  input    [31:0  ]      params_current_sqid_reg_ro  ;
  input    [31:0  ]      current_sqid_reg         ;
  input                  current_sqid_reg_vld         ;




  
 input   [31:0]         error_flag;

  //dbg signals
  output       [63:0]      pkt_in_cnt_o;
  output     [31:0]    mac_in_tcp_cnt;
  output       [63:0]      market_pkt_cnt_o;





  wire            st_rx_vld;
  wire    [63:0]  st_rx_data;
  wire            st_rx_sop;
  wire            st_rx_eop;
  wire     [2:0]  st_rx_byte;
  
  wire    soft_rstn_322;
  wire    soft_rstn;
  
  reg   [11:0]  soft_rstn_keep;
  reg  [11:0]  soft_rstn_322_keep;
  
  always @ (posedge clk)
     if(params_filter_rst)
        soft_rstn_keep <= 12'h0;
     else
        soft_rstn_keep <= {soft_rstn_keep[10:0],1'b1};
       
     assign  soft_rstn = soft_rstn_keep[11];
     
   
     always @ (posedge clk_322)
        if(params_filter_rst)
           soft_rstn_322_keep <= 12'h0;
        else
           soft_rstn_322_keep <= {soft_rstn_322_keep[10:0],1'b1};
          
        assign  soft_rstn_322 = soft_rstn_322_keep[11];
        
            
       
  
  
//wrapper_market_parse_dc_fifo  u_wrapper_mac_rx_fifo (
//       //signals with 10G MAC
//       .clk_322            (clk_322), 
//       .rst_n_322          (rst_n_322),   
//       .mac_rx_data        (mac_rx_data),
//       .mac_rx_bytes       (mac_rx_byte), 
//       .mac_rx_vld         (mac_rx_vld),     
//       .mac_rx_sop         (mac_rx_sop),      
//       .mac_rx_eop         (mac_rx_eop),     
//	
//	    //signal with parse
//      .clk_250            (clk),   
//      .rst_n_250          (rst_n),   		
//      .market_pkt_ready   (market_pkt_ready),    
//      .rx_fifo_data_o     (st_rx_data),    
//      .rx_fifo_bytes_o    (st_rx_byte),      
//      .rx_fifo_vld_o      (st_rx_vld),    
//      .rx_fifo_sop_o      (st_rx_sop),    
//      .rx_fifo_eop_o      (st_rx_eop)
//);

wrapper_mac_rx_fifo  u_wrapper_mac_rx_fifo (
       //signals with 10G MAC
       .clk_322            (clk_322), 
       .rst_n_322          (rst_n_322&&soft_rstn_322),   
       .mac_rx_data        (mac_rx_data),
       .mac_rx_bytes       (mac_rx_byte), 
       .mac_rx_vld         (mac_rx_vld),     
       .mac_rx_sop         (mac_rx_sop),      
       .mac_rx_eop         (mac_rx_eop),     
	
	    //signal with parse
      .clk_250            (clk),   
      //.rst_n_250          (rst_n&&soft_rstn),   		
      .market_pkt_ready   (market_pkt_ready),    
      .rx_fifo_data_o     (st_rx_data),    
      .rx_fifo_bytes_o    (st_rx_byte),      
      .rx_fifo_vld_o      (st_rx_vld),    
      .rx_fifo_sop_o      (st_rx_sop),    
      .rx_fifo_eop_o      (st_rx_eop)
);


parse_search_32ch  
  u_parse_search( 
  .clk                               (clk),      
  .rst_n                             (rst_n&&soft_rstn),     
  .wfir_rx_cstate (fir_rx_cstate),
  .wdebug_st_shift_full_flag( debug_st_shift_full_flag) ,
  .wdebug_discard_calc_cnt1  (debug_discard_calc_cnt1),
  .wst_rx_cnt_reg        (st_rx_cnt_reg),
  .wst_shift_ccnt        (st_shift_ccnt),
  .wdebug_st_shift_scnt   (debug_st_shift_scnt),
  .wdebug_st_shift_en     (debug_st_shift_en),
  .error_flag (error_flag),
  
.params_current_sqid_reg_ro      ( params_current_sqid_reg_ro      ),
.current_sqid_reg                (current_sqid_reg  ),
.current_sqid_reg_vld            (current_sqid_reg_vld),


  //mac core rx                   
  .mac_st_rx_vld                     (st_rx_vld),        
  .mac_st_rx_data                    (st_rx_data),       
  .mac_st_rx_sop                     (st_rx_sop),    
  .mac_st_rx_eop                     (st_rx_eop),    
  .mac_st_rx_byte                    (st_rx_byte),  
  
  .cut_flag                          (cut_flag),      
  .cut_reset                         (cut_reset),      
   
  .tcp_payload_len_o             (tcp_payload_len_o), 
  .tcp_payload_byte_cnt_o        (tcp_payload_byte_cnt_o),  
  .fivetuplematch_o              (fivetuplematch_o),         
  .seq_err_flag_o              (seq_err_flag_o),         
  
  .market_pkt_vld_o              (market_pkt_vld_o),
  .market_pkt_data_o             (market_pkt_data_o),      
  .market_pkt_sop_o              (market_pkt_sop_o),      
  .market_pkt_offset_o           (market_pkt_offset_o),      
  .market_pkt_eop_o              (market_pkt_eop_o),          
  .market_pkt_byte_o             (market_pkt_byte_o),      
  .first_market_byte_o           (first_market_byte_o),  
  
  .pkt_in_cnt_o                  (pkt_in_cnt_o),   
  .tlp_cnt    (tlp_cnt),
  .rq_tlp_cnt(rq_tlp_cnt),
  .mac_in_tcp_cnt               (mac_in_tcp_cnt),
  .market_pkt_cnt_o	            (market_pkt_cnt_o)
  
);
endmodule
