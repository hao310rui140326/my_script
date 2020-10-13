module  filter_cut_rx_fsm  (
clk                ,
rst_n              ,   

params_frame_type_byte      ,
params_filter_rst           ,
current_cut_done_sqid_reg   ,
current_sqcut_done          ,
current_cut_now_sqid_reg_vld ,

//sq_cut_len_reg     ,
//sc_cut_len_reg     ,              
st_rx_start        , 
st_rx_offset       ,
st_rx_end          , 
st_rx_valid        , 
st_rx_data         , 
st_rx_empty        , 
st_rx_cnt          ,
sq_cut_reset_pre   ,  
sq_cut_reset       ,

sq_frame_flag      ,

//current_sqid_reg   ,

sq_shift_full_flag   ,

sq_cut_len_reg     ,


//first_sync_len_byte,                 
//tcp_sqmatch_flag   ,  //match with pre  SQ tcp frame 
//tcp_scmatch_flag   ,  //match with pre  SC tcp frame   

                 
//error_flag         ,
//sc_cut_flag        ,  //cut _flag
//sq_cut_flag        ,  //cut _flag                 
//fir_r_idle_st      ,                   
//tcp_payload_len    ,
// sq_rx_start        , 
// sq_rx_end          , 
// sq_rx_valid        , 
// sq_rx_data         , 
// sq_rx_empty        , 
// sc_rx_start        , 
// sc_rx_end          , 
// sc_rx_valid        , 
// sc_rx_data         , 
// sc_rx_empty        ,

 
//current_sqid_reg   ,
//current_scid_reg   ,

market_explain     , //市场说明 3
info_classify      , //信息分类 1
dialog_num         , //会话编号 4
contract_flag      , //合约标志 1
contract_num       , //合约编号 4
contract_code      , //合约代码 22
update_time        , //更新时间 9
update_ms          , //更新毫秒 4
new_price          , //最新价 8
turnover           , //成交量 4
volume             , //成交额 8   
position           , //持仓量 8
purchase_price     , //申买价 8
buy_quantity       , //申买量 4
sell_price         , //申买价 8
sell_quantity      , //申卖量 4
market_rdy         

);

parameter   FIR_R_IDLE_STATE         =    5'd0  ;    
parameter   FIR_R_SYNC_STATE         =    5'd1  ; 
//parameter   FIR_R_VSYNC_STATE        =    5'd2  ;    
//parameter   FIR_R_DSYNC_STATE        =    5'd3  ;       
parameter   FIR_R_CHECK_STATE        =    5'd4  ;    
parameter   FIR_R_ID_STATE           =    5'd5  ;    
parameter   FIR_R_HEADER_STATE       =    5'd6  ;    
parameter   FIR_R_RDATA0_STATE       =    5'd7  ;            
parameter   FIR_R_REND_STATE         =    5'd8  ;
//parameter   FIR_R_RJUDGE_STATE       =    5'd9  ;       
//parameter   FIR_R_DISCARD_STATE      =    5'd10 ;       
//parameter   FIR_R_DISEND_STATE       =    5'd11 ;      
//parameter   FIR_RSQ_SEGMT_STATE      =    5'd12 ;     
//parameter   FIR_RSC_SEGMT_STATE      =    5'd13 ; 
//parameter   FIR_RSQ_SEGMT_END_STATE  =    5'd14 ;     
//parameter   FIR_RSC_SEGMT_END_STATE  =    5'd15 ;
//parameter   FIR_RSQ_SEGMT_H_STATE    =    5'd16 ;
//parameter   FIR_RSC_SEGMT_H_STATE    =    5'd17 ;
//parameter   FIR_R_SQRCUT_STATE       =    5'd18 ;
//parameter   FIR_R_SCRCUT_STATE       =    5'd19 ;
//parameter   FIR_R_SQRCUT_END_STATE   =    5'd20 ;
//parameter   FIR_R_SCRCUT_END_STATE   =    5'd21 ;
parameter   FIR_R_ERROR_STATE        =    5'd22 ; 

input                      clk                ;
input                      rst_n              ;

input      [15:0]            params_frame_type_byte  ;

input                        params_filter_rst   ;


//input    [15:0]            sq_cut_len_reg     ;
//input    [15:0]            sc_cut_len_reg     ;
                                              
input                      st_rx_start        ; 
input    [ 3:0]            st_rx_offset       ;
input                      st_rx_end          ; 
input                      st_rx_valid        ; 
input    [63:0]            st_rx_data         ; 
input    [ 2:0]            st_rx_empty        ; 
input    [15:0]            st_rx_cnt          ;

input                      sq_cut_reset_pre   ;
output                     sq_cut_reset       ;

//output                     st_rx_ready        ;
//input    [15:0]            first_sync_len_byte;

input                      sq_frame_flag      ;

//input    [31:0]            current_sqid_reg   ;

output                     sq_shift_full_flag ;

output   [15:0]            sq_cut_len_reg  ;
  
                                              
//tcp                                         
//input                      tcp_sqmatch_flag   ;  //match with pre  SQ tcp frame 
//input                      tcp_scmatch_flag   ;  //match with pre  SC tcp frame 
                                              
//output                     error_flag         ;
//output                     sc_cut_flag        ;  //cut _flag
//output                     sq_cut_flag        ;  //cut _flag
                                              
//output                     fir_r_idle_st      ;
                                              
//input    [15:0]            tcp_payload_len    ;

/////////////////////////////////////////////////////////////////////////////////////

// output                     sq_rx_start        ; 
// output                     sq_rx_end          ; 
// output                     sq_rx_valid        ; 
// output    [63:0]           sq_rx_data         ; 
// output    [ 2:0]           sq_rx_empty        ; 

// output                     sc_rx_start        ; 
// output                     sc_rx_end          ; 
// output                     sc_rx_valid        ; 
// output    [63:0]           sc_rx_data         ; 
// output    [ 2:0]           sc_rx_empty        ; 

output    [31:0]           current_cut_done_sqid_reg   ;
output                     current_sqcut_done   ;
output                     current_cut_now_sqid_reg_vld ;                     

output    [ 23: 0]         market_explain ; //市场说明 3
output    [  7: 0]         info_classify  ; //信息分类 1
output    [ 31: 0]         dialog_num     ; //会话编号 4
output    [  7: 0]         contract_flag  ; //合约标志 1
output    [ 31: 0]         contract_num   ; //合约编号 4
output    [175: 0]         contract_code  ; //合约代码 22
output    [ 71: 0]         update_time    ; //更新时间 9
output    [ 31: 0]         update_ms      ; //更新毫秒 4
output    [ 63: 0]         new_price      ; //最新价 8
output    [ 31: 0]         turnover       ; //成交量 4
output    [ 63: 0]         volume         ; //成交额 8   
output    [ 63: 0]         position       ; //持仓量 8
output    [ 63: 0]         purchase_price ; //申买价 8
output    [ 31: 0]         buy_quantity   ; //申买量 4
output    [ 63: 0]         sell_price     ; //申买价 8
output    [ 31: 0]         sell_quantity  ; //申卖量 4
output                     market_rdy     ;


//////////////////////////////////////////////////////////////////////////////////////////////
//reg                        st_rx_ready        ;
wire   [31:0]           current_cut_done_sqid_reg   ;

reg    [31:0]           current_cut_now_sqid_reg   ;

reg                     current_cut_now_sqid_reg_vld ;

reg                        current_sqcut_done   ;

reg      [  5:0]           st_shift_scnt      ;
reg                        st_shift_en        ; 
//reg                        sc_cut_flag        ;  //cut _flag
//reg                        sq_cut_flag        ;  //cut _flag

// wire                       sq_rx_start        ; 
// wire                       sq_rx_end          ; 
// wire                       sq_rx_valid        ; 
// wire     [63:0]            sq_rx_data         ; 
// wire     [ 2:0]            sq_rx_empty        ; 
// wire                       sc_rx_start        ; 
// wire                       sc_rx_end          ; 
// wire                       sc_rx_valid        ; 
// wire     [63:0]            sc_rx_data         ; 
// wire     [ 2:0]            sc_rx_empty        ; 

//wire     [ 23:0]           st_shift_start_reg ;
//wire     [ 23:0]           st_shift_end_reg   ;    
wire     [191:0]           st_shift_reg       ;
wire     [  5:0]           st_shift_ccnt      ;

////////////////////////////////////////////////////////////////////////////////////
//reg      [31:0]            current_sqid_reg   ;
//reg      [31:0]            current_scid_reg   ;
//reg     [31:0]     pre_id_reg        ;
//

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
//reg    [15:0]   st_rc_cut_cnt  ;
//wire   [15:0]   sub_sqcut_len_reg  =  (sq_cut_len_reg - st_rq_cut_cnt) ;
//wire   [15:0]   sub_sccut_len_reg  =  (sc_cut_len_reg - st_rc_cut_cnt) ;


///////////////////////////////////////////////////////////////////////////////////////
reg       [15:0]   st_rx_cnt_reg       ; 

//reg                sq_frame_flag       ;
//reg                sc_frame_flag       ;

//reg       [15:0]   sync_len_byte_reg   ;
//reg       [15:0]   sync_len_rest_reg   ;
//wire      [11:0]   discard_calc_cnt0   ;
//wire      [ 3:0]   discard_calc_cnt1   ;
reg       [2 :0]   discard_data_cnt    ;
//assign  discard_calc_cnt0 = sync_len_rest_reg[15:4] ;
//assign  discard_calc_cnt1 = sync_len_rest_reg[ 3:0] ;

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

reg       [15:0]   sq_cut_len_reg   ;

reg                sq_cut_reset_pre_dly  ; 
reg                sq_cut_reset          ; 


wire               st_rx_data_en = st_rx_valid  ;

//////////////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////////
reg     [ 4:0]     fir_rx_cstate ;
reg     [ 4:0]     fir_rx_nstate ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     fir_rx_cstate  <=  5'd0 ;
  end
  //else if (sq_cut_reset_pre_dly[7]) begin
  else if (sq_cut_reset||params_filter_rst) begin
     fir_rx_cstate  <=  5'd0 ;     
  end
  else begin 
     fir_rx_cstate  <=  fir_rx_nstate ;
  end
end

wire  fir_r_idle_st      =  (  fir_rx_cstate== FIR_R_IDLE_STATE        );    
wire  fir_r_sync_st      =  (  fir_rx_cstate== FIR_R_SYNC_STATE        ); 
//wire  fir_r_vsync_st     =  (  fir_rx_cstate== FIR_R_VSYNC_STATE       );    
//wire  fir_r_dsync_st     =  (  fir_rx_cstate== FIR_R_DSYNC_STATE       );       
wire  fir_r_check_st     =  (  fir_rx_cstate== FIR_R_CHECK_STATE       );    
wire  fir_r_id_st        =  (  fir_rx_cstate== FIR_R_ID_STATE          );    
wire  fir_r_header_st    =  (  fir_rx_cstate== FIR_R_HEADER_STATE      );    
wire  fir_r_rdata0_st    =  (  fir_rx_cstate== FIR_R_RDATA0_STATE      );            
wire  fir_r_rend_st      =  (  fir_rx_cstate== FIR_R_REND_STATE        );

//wire  fir_r_rjudge_st    =  (  fir_rx_cstate== FIR_R_RJUDGE_STATE      );       
//wire  fir_r_discard_st   =  (  fir_rx_cstate== FIR_R_DISCARD_STATE     );       
//wire  fir_r_disend_st    =  (  fir_rx_cstate== FIR_R_DISEND_STATE      );      
//wire  fir_r_sqcut_st     =  (  fir_rx_cstate== FIR_RSQ_SEGMT_STATE     );     
//wire  fir_r_sccut_st     =  (  fir_rx_cstate== FIR_RSC_SEGMT_STATE     ); 
//
//wire  fir_r_sqcut_end_st =  (  fir_rx_cstate== FIR_RSQ_SEGMT_END_STATE );     
//wire  fir_r_sccut_end_st =  (  fir_rx_cstate== FIR_RSC_SEGMT_END_STATE ); 
//    
//wire  fir_r_sqcuth_st    =  (  fir_rx_cstate== FIR_RSQ_SEGMT_H_STATE   );
//wire  fir_r_sccuth_st    =  (  fir_rx_cstate== FIR_RSC_SEGMT_H_STATE   );
//wire  fir_r_sqrcut_st    =  (  fir_rx_cstate== FIR_R_SQRCUT_STATE       );
//wire  fir_r_scrcut_st    =  (  fir_rx_cstate== FIR_R_SCRCUT_STATE       );
//
//wire  fir_r_sqrcut_end_st    =  (  fir_rx_cstate== FIR_R_SQRCUT_END_STATE       );
//wire  fir_r_scrcut_end_st    =  (  fir_rx_cstate== FIR_R_SCRCUT_END_STATE       );

always@ ( * )
begin
  fir_rx_nstate = fir_rx_cstate;
  case(fir_rx_cstate)
  FIR_R_IDLE_STATE : begin  
      if (st_rx_start&&st_rx_data_en)  begin
         fir_rx_nstate = FIR_R_SYNC_STATE ;
	  end
  end
  
//  need modify 
  // FIR_R_SQRCUT_STATE : begin
       // if ( (st_shift_ccnt>=6'd8) &&  (sub_sqcut_len_reg<=16'd16) ) begin
          // fir_rx_nstate  <=   FIR_R_SQRCUT_END_STATE  ;   
       // end
  // end
  
  // FIR_R_SQRCUT_END_STATE : begin
       // if ( st_shift_ccnt>=sub_sqcut_len_reg[5:0]) begin
          // fir_rx_nstate  <=   FIR_R_SYNC_STATE  ;   
       // end
  // end
  
  
  // FIR_R_SCRCUT_STATE : begin
	   // if ( (st_shift_ccnt>=6'd8) &&  (sub_sccut_len_reg<=16'd16) ) begin
          // fir_rx_nstate  <=   FIR_R_SCRCUT_END_STATE  ;   
       // end
  // end
  // FIR_R_SCRCUT_END_STATE : begin
	   // if ( (st_shift_ccnt>=sub_sccut_len_reg) ) begin
          // fir_rx_nstate  <=   FIR_R_SYNC_STATE  ;   
       // end
  // end
  
  
  FIR_R_SYNC_STATE : begin
      if (st_shift_ccnt>=6'd8) begin
	      //if  (st_rx_cnt_reg<(sync_len_byte+16'd4)) begin
	      //     fir_rx_nstate = FIR_R_IDLE_STATE ;
	      //end
          if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)) begin
                fir_rx_nstate  =   FIR_R_CHECK_STATE   ;                   
          end
          else begin
                fir_rx_nstate =  FIR_R_ERROR_STATE ;
          end
      end
  end
  
  // FIR_R_DSYNC_STATE : begin     
      // if (st_shift_ccnt>=6'd8) begin
	      // if  (st_rx_cnt_reg<(sync_len_byte+16'd4)) begin
	         // fir_rx_nstate = FIR_R_IDLE_STATE ;
	      // end
          // else if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)) begin
                // fir_rx_nstate  =   FIR_R_CHECK_STATE   ;                   
          // end
          // else begin
                // fir_rx_nstate =  FIR_R_ERROR_STATE ;
          // end
      // end
  // end
  
  // FIR_R_VSYNC_STATE : begin
      // if (st_shift_ccnt>=6'd8) begin
	      // if  ( st_rx_cnt_reg<(sync_len_byte+16'd4) ) begin
		        // fir_rx_nstate = sq_frame_flag  ?   FIR_RSQ_SEGMT_STATE  : sc_frame_flag  ?  FIR_RSC_SEGMT_STATE   :  FIR_R_IDLE_STATE; 
		  // end
          // else if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)) begin
                // fir_rx_nstate  =   FIR_R_CHECK_STATE   ;                   
          // end
          // else begin
                // fir_rx_nstate =  FIR_R_ERROR_STATE ;
          // end
      // end
  // end
  
  FIR_R_CHECK_STATE : begin
      if (st_shift_ccnt>=6'd6   ) begin
          if (  ( frame_type_byte==params_frame_type_byte )  &&(frame_sync_byte==32'h0000_5902)    ) begin
                fir_rx_nstate =  FIR_R_ID_STATE    ; 
          end
          else begin
                fir_rx_nstate =  FIR_R_ERROR_STATE ;
          end
      end
  end 

  FIR_R_ID_STATE : begin
    if (  st_shift_ccnt>=6'd12  )  begin
//        if ( ((current_id_wire<=current_sqid_reg)&&sq_frame_flag)  ||  ((current_id_wire<=current_scid_reg)&&sc_frame_flag)  ) begin
//             fir_rx_nstate  =    FIR_R_IDLE_STATE   ;
 //     end 
        if (patition_cnt_wire<=16'h0001)  begin
             fir_rx_nstate  =    FIR_R_IDLE_STATE   ;
        end
        else  begin
             fir_rx_nstate  =      FIR_R_HEADER_STATE   ;
        end
    end 
  end
  
  /* 
  FIR_R_DISCARD_STATE : begin
       if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
           if ( discard_calc_cnt1==4'd0 ) begin
               //if (st_rx_cnt_reg==6'd16 )  begin
               //    fir_rx_nstate = FIR_R_IDLE_STATE ;
               //end
               if ( st_rx_cnt_reg<(16'd16+ segm_min_len   )  ) begin  //16'd81  the length of ( header + 2439 )
                   fir_rx_nstate = FIR_R_IDLE_STATE ;
               end
               else begin
                   fir_rx_nstate =  FIR_R_DSYNC_STATE ;
               end
           end
           else begin 
               fir_rx_nstate  =    FIR_R_DISEND_STATE  ;                
           end
       end
  end
  FIR_R_DISEND_STATE: begin
      if (  st_shift_ccnt>=discard_calc_cnt1    ) begin
           //if (st_rx_cnt_reg==discard_calc_cnt1)  begin
           //     fir_rx_nstate  =     FIR_R_IDLE_STATE    ;                        
           //end
           if ( st_rx_cnt_reg<( discard_calc_cnt1  +  segm_min_len )) begin
                fir_rx_nstate  =     FIR_R_IDLE_STATE    ;                                        
           end
           else begin
                fir_rx_nstate  =     FIR_R_DSYNC_STATE   ;                                        
           end
      end   
  end
  */
  FIR_R_HEADER_STATE : begin
       if (  st_shift_ccnt>=6'd4 )begin
            fir_rx_nstate  =    FIR_R_RDATA0_STATE   ;
       end 
  end
  FIR_R_RDATA0_STATE : begin  
       if (  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1) )   )begin
            if (segm_cnt1_wire==4'd0)  begin
                  if (patition_cnt>=patition_cnt_reg) begin
					  fir_rx_nstate  =    FIR_R_IDLE_STATE  ;  
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
				fir_rx_nstate  =    FIR_R_IDLE_STATE  ;  
            end
            else begin
                fir_rx_nstate  =  FIR_R_HEADER_STATE     ;                
            end 
       end 
  end
  
  
/*   FIR_R_RJUDGE_STATE : begin
      if  (st_rx_cnt_reg==16'd0)  begin
	       fir_rx_nstate  =    FIR_R_IDLE_STATE     ; 
	   end
	   else if (st_rx_cnt_reg<=16'd8)  begin
	       fir_rx_nstate  =    sq_frame_flag  ?    FIR_RSQ_SEGMT_H_STATE   :   FIR_RSC_SEGMT_H_STATE   ; 
	   end
      else begin
	      fir_rx_nstate  =    FIR_R_VSYNC_STATE    ; 
      end
  end */
  
/*   FIR_RSQ_SEGMT_H_STATE : begin
        if ( st_shift_ccnt>=st_rx_cnt_reg )  begin
            fir_rx_nstate  =  FIR_R_IDLE_STATE     ;                
        end 
  end 
  
  FIR_RSC_SEGMT_H_STATE : begin
        if (  st_shift_ccnt>=st_rx_cnt_reg )  begin
            fir_rx_nstate  =  FIR_R_IDLE_STATE     ;                
        end 
  end */
  
  
  /* 
  FIR_RSC_SEGMT_STATE : begin
		if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
		   fir_rx_nstate  =  FIR_RSC_SEGMT_END_STATE     ;  
		end
  end
  
  FIR_RSC_SEGMT_END_STATE : begin
     if (  st_shift_ccnt>=st_rx_cnt_reg ) begin
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
  end */
  

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
/* always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_frame_flag  <=  1'd0    ;
      sc_frame_flag  <=  1'd0    ;
  end
  else if (  fir_r_check_st ) begin 
      sq_frame_flag  <=   (frame_type_byte==16'h03e9)    ;
      sc_frame_flag  <=   (frame_type_byte==16'h1389)    ;
  end
end */

//sync_len_byte_reg
// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // sync_len_byte_reg  <=  16'd0    ;
  // end
  // else if (  fir_r_sync_st || fir_r_dsync_st || fir_r_vsync_st  ) begin 
      // sync_len_byte_reg  <=    sync_len_byte     ;
  // end
// end
//sync_len_rest_reg 
/* always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sync_len_rest_reg  <=  16'd0    ;
  end
  else if (st_rx_start&&~tcp_sqmatch_flag&&~tcp_scmatch_flag) begin
      sync_len_rest_reg  <=    first_sync_len_byte - 16'd22     ;
  end
  else if (   fir_r_dsync_st || fir_r_vsync_st ) begin 
      sync_len_rest_reg  <=    sync_len_byte - 16'd22     ;
  end
end */

//fir_r_sqcut_st
//fir_r_sccut_st
//fir_r_sqcuth_st
//fir_r_sccuth_st

//st_rx_cnt_reg
/* always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rx_cnt_reg  <=  16'd0    ;
  end
  else if (  st_rx_start  ) begin 
      //st_rx_cnt_reg  <=   (tcp_sqmatch_flag||tcp_scmatch_flag)   ?    (tcp_payload_len -  st_rx_cnt - st_rx_offset)   :   (tcp_payload_len)  ;
	  st_rx_cnt_reg  <=    (tcp_payload_len -  st_rx_cnt - st_rx_offset - 16'd8)    ;
  end
  else if ( ( fir_r_dsync_st || fir_r_vsync_st)  &&  (st_shift_ccnt>=16'd8) ) begin
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
  else if ( (fir_r_sqcut_st || fir_r_sccut_st)  && (st_shift_ccnt>=6'd8) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd8   ;   
  end
  else if ( (fir_r_sqcut_end_st || fir_r_sccut_end_st)  && (st_shift_ccnt>=st_rx_cnt_reg) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  st_rx_cnt_reg   ;   
  end
  else if ( (fir_r_sqcuth_st || fir_r_sccuth_st)  && (st_shift_ccnt>=st_rx_cnt_reg)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  st_rx_cnt_reg   ;   
  end
  
  else if ((fir_r_sqrcut_st) &&  (st_shift_ccnt>=16'd8)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd8    ;  
  end
  else if ((fir_r_sqrcut_end_st) &&  (st_shift_ccnt>=sub_sqcut_len_reg)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  sub_sqcut_len_reg    ;  
  end
  
  else if ((fir_r_scrcut_st) &&  (st_shift_ccnt>=16'd8) ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  16'd8    ;  
  end
  else if ((fir_r_scrcut_end_st) &&  (st_shift_ccnt>=sub_sccut_len_reg)  ) begin
      st_rx_cnt_reg  <=    st_rx_cnt_reg -  sub_sccut_len_reg    ;  
  end
  
end */

////////////////////////////////////////////////////////////////////////////////////////////////////

reg    [3:0]    sq_cut_reset_pre_cnt  ;
reg    [3:0]    sq_cut_reset_cnt      ;


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     sq_cut_reset_pre_dly  <=  1'd0 ;
     sq_cut_reset_pre_cnt  <=  4'd0 ;
  end
  else if (params_filter_rst) begin
      sq_cut_reset_pre_dly  <=  1'd0 ;
      sq_cut_reset_pre_cnt  <=  4'd0 ;      
  end
  else if (sq_cut_reset_pre&&(  fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin 
     sq_cut_reset_pre_dly  <=  1'd0  ;
      sq_cut_reset_pre_cnt  <=  4'd0 ;      
  end
  else if (sq_cut_reset_pre&&(  fir_rx_cstate== FIR_R_IDLE_STATE  ) ) begin 
     sq_cut_reset_pre_dly  <=  1'd0  ;
      sq_cut_reset_pre_cnt  <=  4'd0 ;      
  end
  else if (sq_cut_reset_pre_dly&&  (  fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin
     sq_cut_reset_pre_dly  <=  1'd0 ; 
     sq_cut_reset_pre_cnt  <=  4'd0 ;      
  end
  else if (sq_cut_reset_pre_dly &&  (sq_cut_reset_pre_cnt>=4'd7)  ) begin
     sq_cut_reset_pre_dly  <=  1'd0 ;  
     sq_cut_reset_pre_cnt  <=  4'd0 ;               
  end
  else if (sq_cut_reset_pre ) begin 
     sq_cut_reset_pre_dly  <=  1'd1  ;
     sq_cut_reset_pre_cnt  <=  sq_cut_reset_pre_cnt + 4'd1 ;      
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     sq_cut_reset_cnt  <=  1'd0 ;
  end
  else if (params_filter_rst) begin
     sq_cut_reset_cnt  <=  1'd0 ;      
  end
  else if (sq_cut_reset_pre ) begin 
     sq_cut_reset_cnt   <=  sq_cut_reset_cnt + 1'd1 ;      
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     sq_cut_reset  <=  1'd0 ;
  end
  else if (params_filter_rst) begin
      sq_cut_reset  <=  1'd1 ;
  end
  else if (sq_cut_reset_pre&&(  fir_rx_cstate>= FIR_R_CHECK_STATE )   ) begin 
     sq_cut_reset  <=  1'd1 ;
  end
  else if (sq_cut_reset_pre&&(  fir_rx_cstate== FIR_R_IDLE_STATE  )  ) begin 
     sq_cut_reset  <=  1'd1 ;
  end
  else if (sq_cut_reset_pre_dly&&  (  fir_rx_cstate>= FIR_R_CHECK_STATE ) ) begin
     sq_cut_reset  <=  1'd1 ; 
  end
  else if (sq_cut_reset_pre_dly &&  (sq_cut_reset_pre_cnt>=4'd7)  ) begin
     sq_cut_reset  <=  1'd1 ;      
  end
  else begin
     sq_cut_reset  <=  1'd0 ;
  end
end



//discard_ddiscard_data_cntata_cnt
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      discard_data_cnt  <= 3'd0    ;
  end
  else if ( fir_r_rdata0_st  ) begin 
      discard_data_cnt  <=   (st_shift_ccnt>=6'd16)  ?     discard_data_cnt + 1'd1 :  discard_data_cnt    ;
  end
  else  begin
      discard_data_cnt  <=  3'd0    ;     
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
/*   else if (st_rx_start&&~tcp_sqmatch_flag&&~tcp_scmatch_flag && st_rx_data_en) begin  
       st_shift_scnt  <= 6'd6  ;
       st_shift_en    <= 1'd1  ;
  end
  else if (st_rx_start&&tcp_sqmatch_flag && st_rx_data_en) begin
	   st_shift_scnt  <= 6'd8  ;
       st_shift_en    <= 1'd1  ;
  end */
  else if (st_rx_start && st_rx_data_en &&  (st_rx_empty==3'd0)  ) begin
	   st_shift_scnt  <= 6'd8  ;
           st_shift_en    <= 1'd1  ;
  end
  
  /* else if (fir_r_sqrcut_st) begin
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
	      st_shift_scnt  <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8)))  ?  6'd8   :  6'd0  ;
          st_shift_en    <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sqcut_len_reg[5:0]+6'd8)))  ?  1'd1   :  1'd0  ;
  end
  
  else if (fir_r_scrcut_st) begin
      if  ( (st_shift_ccnt>=6'd8) &&  (sub_sccut_len_reg<=16'd16)  )  begin
	      st_shift_scnt  <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sccut_len_reg[5:0])))  ? sub_sccut_len_reg[5:0] - 6'd8  : 6'd0 ;
          st_shift_en    <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sccut_len_reg[5:0])))  ? 1'd1   :  1'd0;
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
  else if (fir_r_scrcut_end_st &&   ( st_shift_ccnt>=sub_sccut_len_reg[5:0] ) ) begin
	      st_shift_scnt  <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sccut_len_reg[5:0]+6'd8)))  ?  6'd8   :  6'd0  ;
          st_shift_en    <= (st_rx_data_en ||  (st_shift_ccnt>=(sub_sccut_len_reg[5:0]+6'd8)))  ?  1'd1   :  1'd0  ;
  end */
  
  else if (fir_r_sync_st ) begin
      if (st_shift_ccnt>=6'd8) begin
          //if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)  ) begin
                st_shift_scnt  <= (st_shift_ccnt>=6'd14)||  (st_rx_data_en&&((st_shift_ccnt-st_rx_empty)>=6'd6))   ?  6'd6 : 6'd0 ;
                st_shift_en    <= (st_shift_ccnt>=6'd14)||  (st_rx_data_en&&((st_shift_ccnt-st_rx_empty)>=6'd6))   ?  1'd1 : 1'd0 ;              
          //end
          //else begin
          //      st_shift_scnt  <= 6'd0  ;
          //      st_shift_en    <= 1'd0  ;
          //end
      end
	  else if (st_rx_data_en &&   ((st_shift_ccnt+6'd8-st_rx_empty)>=6'd8)   ) begin
	     st_shift_scnt  <= 6'd8  ;
             st_shift_en    <= 1'd1  ;
	  end
	  else begin
	     st_shift_scnt  <= 6'd0  ;
         st_shift_en    <= 1'd0  ;
	  end
  end
  /* 
  else if (fir_r_vsync_st ) begin
      if (st_shift_ccnt>=6'd8) begin
	      if ( (st_rx_cnt_reg<(sync_len_byte+16'd4)) &&  (sq_frame_flag||sc_frame_flag)  ) begin
		        st_shift_scnt  <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 6'd8 : 6'd0  ;
                st_shift_en    <= ((st_shift_ccnt>=6'd16)||st_rx_data_en) ? 1'd1 : 1'd0  ;
		  end
          if ((sync_fisrt_byte==16'h0200)&&(sync_four_byte==32'h0100_044c)  ) begin
                st_shift_scnt  <= ((st_shift_ccnt>=6'd12)||st_rx_data_en) ?  6'd4 : 6'd0 ;
                st_shift_en    <= ((st_shift_ccnt>=6'd12)||st_rx_data_en) ?  1'd1 : 1'd0 ;              
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
  end */
  
  else if (fir_r_check_st)  begin
      if (st_shift_ccnt>=6'd6   ) begin
         st_shift_scnt  <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&((st_shift_ccnt+6'd2-st_rx_empty)>=6'd12))) ?    6'd12   :  6'd0  ;
         st_shift_en    <= ((st_shift_ccnt>=6'd18)||(st_rx_data_en&&((st_shift_ccnt+6'd2-st_rx_empty)>=6'd12))) ?     1'd1   :  1'd0  ; 
      end
	  else if (st_rx_data_en&&((st_shift_ccnt+6'd8-st_rx_empty)>=6'd6)) begin
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
        //if ( ((current_id_wire<=current_sqid_reg)&&sq_frame_flag)  ||  ((current_id_wire<=current_scid_reg)&&sc_frame_flag) ||  (patition_cnt_wire<=16'h0001) ) begin
         //   st_shift_scnt  <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ?    6'd16   :  6'd0  ;
         //   st_shift_en    <= ((st_shift_ccnt>=6'd28)||(st_rx_data_en&&(st_shift_ccnt>=6'd20))) ?     1'd1   :  1'd0  ; 
        //end 
        //else  begin
            st_shift_scnt  <= ((st_shift_ccnt>=6'd16)||(st_rx_data_en&&((st_shift_ccnt-6'd4-st_rx_empty)>=6'd4))) ?     6'd4   :  6'd0  ;
            st_shift_en    <= ((st_shift_ccnt>=6'd16)||(st_rx_data_en&&((st_shift_ccnt-6'd4-st_rx_empty)>=6'd4))) ?     1'd1   :  1'd0  ; 
        //end
    end 
	else if (st_rx_data_en&& ((st_shift_ccnt+6'd8-st_rx_empty)>=6'd12)    ) begin
	    st_shift_scnt  <= 6'd12  ;
            st_shift_en    <= 1'd1  ;
	end
    else begin
	    st_shift_scnt  <= 6'd0  ;
        st_shift_en    <= 1'd0  ;
    end
  end
  /* 
  else if (  fir_r_discard_st ) begin
        if ( (st_shift_ccnt>=6'd16) && (discard_data_cnt>=(discard_calc_cnt0-1'b1)) ) begin
           if ( discard_calc_cnt1==4'd0 ) begin
               //if ( st_rx_cnt_reg>=(16'd16+ segm_min_len   )  ) begin  //16'd81  the length of ( header + 2439 )
                   st_shift_scnt  <= ((st_shift_ccnt>=6'd24)||(st_rx_data_en&&(st_shift_ccnt>=6'd16))) ?     6'd8   :  6'd0  ;
                   st_shift_en    <= ((st_shift_ccnt>=6'd24)||(st_rx_data_en&&(st_shift_ccnt>=6'd16))) ?     1'd1   :  1'd0  ; 
               //end
			  // else begin
			  //     st_shift_scnt  <= 6'd0  ;
              //     st_shift_en    <= 1'd0  ;
			  // end
           end
           else begin 
               st_shift_scnt  <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ?     discard_calc_cnt1   :  6'd0  ;
               st_shift_en    <= ((st_shift_ccnt>=(6'd16+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(6'd8+discard_calc_cnt1)))) ?     1'd1   :  1'd0  ;        
           end
        end
	    else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
	        st_shift_scnt  <= 6'd16  ;
            st_shift_en    <= 1'd1   ;
	    end
	    else  begin
		    st_shift_scnt  <= 6'd0  ;
            st_shift_en    <= 1'd0  ;
		end
  end
  
  else if (fir_r_disend_st) begin
        if (  st_shift_ccnt>=discard_calc_cnt1    ) begin
            st_shift_scnt  <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(discard_calc_cnt1)))) ?     6'd8   :  6'd0  ;
            st_shift_en    <= ((st_shift_ccnt>=(6'd8+discard_calc_cnt1))||(st_rx_data_en&&(st_shift_ccnt>=(discard_calc_cnt1)))) ?     1'd1   :  1'd0  ;       
        end   
		else if (st_rx_data_en) begin
		    st_shift_scnt  <= discard_calc_cnt1  ;
            st_shift_en    <= 1'd1  ;
		end
		else begin
		    st_shift_scnt  <= 6'd0  ;
            st_shift_en    <= 1'd0  ;
		end
  end
   */
  else if (fir_r_header_st) begin
       if (  st_shift_ccnt>=6'd4 )begin
            st_shift_scnt  <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&&  ((st_shift_ccnt+6'd4-st_rx_empty)>=6'd16)     ))  ?     6'd16   :  6'd0  ;
            st_shift_en    <= ((st_shift_ccnt>=6'd20)||(st_rx_data_en&&  ((st_shift_ccnt+6'd4-st_rx_empty)>=6'd16)     ))  ?     1'd1    :  1'd0  ; 
       end
       else if ( st_rx_data_en  &&   ((st_shift_ccnt+6'd8-st_rx_empty)>=6'd4)       ) begin
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
                      st_shift_scnt  <= ((st_shift_ccnt>=6'd20)|| (st_rx_data_en&& ((st_shift_ccnt-6'd8-st_rx_empty)>=6'd4)   ) ) ?     6'd4    :  6'd0  ;
                      st_shift_en    <= ((st_shift_ccnt>=6'd20)|| (st_rx_data_en&& ((st_shift_ccnt-6'd8-st_rx_empty)>=6'd4)   ) ) ?     1'd1    :  1'd0  ; 
                  end
				  else begin
				      st_shift_scnt  <= 6'd0  ;
                      st_shift_en    <= 1'd0  ;
				  end
            end
            else begin
                  //st_shift_scnt  <= ((st_shift_ccnt>=(6'd16+segm_cnt1_wire))||(st_rx_data_en&&  ( (segm_cnt1_wire<=4'd8)  || ( (segm_cnt1_wire>4'd8)&&(st_shift_ccnt>=(segm_cnt1_wire+4'd8)))  )) ) ?     segm_cnt1_wire   :  6'd0  ;
                  //st_shift_en    <= ((st_shift_ccnt>=(6'd16+segm_cnt1_wire))||(st_rx_data_en&&  ( (segm_cnt1_wire<=4'd8)  || ( (segm_cnt1_wire>4'd8)&&(st_shift_ccnt>=(segm_cnt1_wire+4'd8)))  )) ) ?     1'd1             :  1'd0  ;           
                  if  (st_shift_ccnt>=(6'd16+segm_cnt1_wire))  begin 
                          st_shift_scnt <= segm_cnt1_wire ;
                          st_shift_en   <= 1'd1           ;
                  end  
                  else if (st_rx_data_en  && ((st_shift_ccnt-6'd8-st_rx_empty)>= segm_cnt1_wire)  ) begin
                          st_shift_scnt <= segm_cnt1_wire ;
                          st_shift_en   <= 1'd1           ;
                  end
                  else begin
                         st_shift_scnt <= 6'd0           ;
                         st_shift_en   <= 1'd0           ;
                  end
            end
	   end
	   //else if (st_rx_data_en&&(st_shift_ccnt>=6'd8)) begin
	   //else if (st_rx_data_en&&((st_shift_ccnt-st_rx_empty)>=6'd8)) begin
	   else if (st_rx_data_en&&(st_shift_ccnt>=(6'd8+st_rx_empty)) ) begin
	       st_shift_scnt  <= st_shift_en ?  6'd0  :  6'd16  ;
               st_shift_en    <= st_shift_en ?  1'd0  :  1'd1   ;
	   end
	   else  begin
		    st_shift_scnt  <= 6'd0  ;
            st_shift_en    <= 1'd0  ;
	   end
  end

  
  else if ( fir_r_rend_st   ) begin
       if (  st_shift_ccnt>=segm_cnt1_wire)begin
            if (patition_cnt>=patition_cnt_reg) begin
                st_shift_scnt  <= 6'd0  ;
                st_shift_en    <= 1'd0  ;
            end
            else   begin
                //st_shift_scnt  <= 6'd0  ;
                //st_shift_en    <= 1'd0  ;
               // st_shift_scnt  <= ((st_shift_ccnt>=(6'd4+segm_cnt1_wire))|| (st_rx_data_en&&(st_rx_empty<=6'd4  )) ) ?     6'd4             :  6'd0  ;
               // st_shift_en    <= ((st_shift_ccnt>=(6'd4+segm_cnt1_wire))|| (st_rx_data_en&&(st_rx_empty<=6'd4  )) ) ?     1'd1             :  1'd0  ;   

               if ( st_shift_ccnt>=(6'd4+segm_cnt1_wire)  )  begin
                    st_shift_scnt <= 6'd4 ;
                    st_shift_en   <= 1'd1 ;
               end 
               else if ( st_rx_data_en&&(st_rx_empty<=6'd4  ) ) begin
                    st_shift_scnt <= 6'd4 ;
                    st_shift_en   <= 1'd1 ;
               end
               else if ( st_rx_data_en && ( (st_shift_ccnt + 6'd8) >= (6'd4  + st_rx_empty + segm_cnt1_wire ))  ) begin
                    st_shift_scnt <= 6'd4 ;
                    st_shift_en   <= 1'd1 ; 
               end
               else begin
                    st_shift_scnt <= 6'd0 ;
                    st_shift_en   <= 1'd0 ; 
               end
               
            end 
       end
       //else if (st_rx_data_en&&( ((segm_cnt1_wire>4'd8)&&(st_shift_ccnt>=(segm_cnt1_wire-4'd8)))  ||  (segm_cnt1_wire<=4'd8)    )) begin
       //    st_shift_scnt  <= segm_cnt1_wire  ;
       //    st_shift_en    <= 1'd1  ;
       //end

       else if (st_rx_data_en&&  ( (st_shift_ccnt+6'd8-st_rx_empty) >=  segm_cnt1_wire    )   ) begin
           st_shift_scnt  <= segm_cnt1_wire  ;
           st_shift_en    <= 1'd1  ;
       end


       else begin
           st_shift_scnt  <= 6'd0  ;
           st_shift_en    <= 1'd0  ;
       end 
  end
   





  /* 
  else if (fir_r_rjudge_st)  begin
       if  (st_rx_cnt_reg==16'd0)  begin
	       st_shift_scnt  <= 6'd0  ;
           st_shift_en    <= 1'd0  ;
	   end
	   else if (st_rx_cnt_reg<=16'd8)  begin
	       st_shift_scnt  <= st_rx_cnt_reg[5:0]  ;
           st_shift_en    <= 1'd1  ;
	   end
      else begin
	       st_shift_scnt  <= ((st_shift_ccnt>=6'd8)||st_rx_data_en) ?     6'd8   :  6'd0  ;
           st_shift_en    <= ((st_shift_ccnt>=6'd8)||st_rx_data_en) ?     1'd1   :  1'd0  ;     
      end
  end */
  
  //else if (fir_r_sqcuth_st) begin
  //    st_shift_scnt  <= 6'd0  ;
  //    st_shift_en    <= 1'd0  ;
  //end
  //else if (fir_r_sccuth_st) begin
  //    st_shift_scnt  <= 6'd0  ;
  //    st_shift_en    <= 1'd0  ;
  //end
  /* 
  else if (fir_r_sccut_st || fir_r_sqcut_st ) begin
    if ((st_shift_ccnt>=6'd8)&&(st_rx_cnt_reg<=16'd16)) begin
		   st_shift_scnt  <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ?     (st_rx_cnt_reg[5:0]-6'd8)   :  6'd0  ;
           st_shift_en    <= ((st_shift_ccnt>=(st_rx_cnt_reg))||st_rx_data_en) ?     1'd1                        :  1'd0  ;    
    end
	else if (st_rx_data_en) begin
	       st_shift_scnt  <= 6'd8  ;
           st_shift_en    <= 1'd1   ;
	end
	else begin
           st_shift_scnt  <= 6'd0  ;
           st_shift_en    <= 1'd0  ;
    end
  end */
  
  //else if (fir_r_sccut_end_st || fir_r_sqcut_end_st ) begin
  //    st_shift_scnt  <= 6'd0  ;
  //    st_shift_en    <= 1'd0  ;
  //end
  
  else begin
      st_shift_scnt  <= 6'd0  ;
      st_shift_en    <= 1'd0  ;
  end
  
end




// always@ ( negedge rst_n  or posedge clk)
// begin
  // if  (~rst_n) begin
       // st_shift_scnt  <= 6'd0  ;
       // st_shift_en    <= 1'd0  ;
  // end
  // else if  ( ( fir_r_dsync_st || fir_r_vsync_st ) &&  (st_shift_ccnt>=6'd8) )  begin
       // st_shift_scnt  <= 6'd8  ;
       // st_shift_en    <= 1'd1  ;
  // end
 // else if  ( fir_r_check_st &&  (st_shift_ccnt>=6'd6) )  begin
  // else if (st_rx_start&&~tcp_sqmatch_flag&&~tcp_scmatch_flag) begin  
       // st_shift_scnt  <= 6'd6  ;
       // st_shift_en    <= 1'd1  ;
  // end
  // else if  ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12) )  begin
       // st_shift_scnt  <= 6'd12  ;
       // st_shift_en    <= 1'd1  ;
  // end
  // else if  ( fir_r_discard_st  &&  (st_shift_ccnt>=6'd16) )  begin
       // st_shift_scnt  <= 6'd16  ;
       // st_shift_en    <= 1'd1  ;
  // end
  // else if  ( fir_r_disend_st  &&  (st_shift_ccnt>=discard_calc_cnt1) )  begin
       // st_shift_scnt  <= discard_calc_cnt1  ;
       // st_shift_en    <= 1'd1  ;
  // end
  // else if  ( fir_r_header_st  &&  (st_shift_ccnt>=6'd4) )  begin
       // st_shift_scnt  <= 6'd4  ;
       // st_shift_en    <= 1'd1  ;
  // end
  // else if  ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16) )  begin
       // st_shift_scnt  <= 6'd16  ;
       // st_shift_en    <= 1'd1  ;
  // end
  // else if  ( fir_r_rend_st  &&  (st_shift_ccnt>= segm_cnt1_wire ) )  begin
       // st_shift_scnt  <= segm_cnt1_wire  ;
       // st_shift_en    <= 1'd1  ;
  // end
  
  // else if ( (fir_r_sqcut_st || fir_r_sccut_st)  && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg>16'd8) ) begin
      // st_shift_scnt  <= 6'd8  ;
      // st_shift_en    <= 1'd1   ;
  // end
  // else if ( (fir_r_sqcut_st || fir_r_sccut_st)  && (st_shift_ccnt>=st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ) begin
      // st_shift_scnt  <= st_rx_cnt_reg[5:0]  ;
      // st_shift_en    <= 1'd1   ;
  // end
  // else if ( (fir_r_sqcuth_st || fir_r_sccuth_st)  && (st_shift_ccnt>=st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ) begin
      // st_shift_scnt  <= st_rx_cnt_reg[5:0]  ;
      // st_shift_en    <= 1'd1   ;
  // end
  // else if ((fir_r_sqrcut_st) &&  (st_shift_ccnt>=16'd8) &&  (sub_sqcut_len_reg>16'd8) ) begin
      // st_shift_scnt  <= 16'd8  ;
      // st_shift_en    <= 1'd1   ;
  // end
  // else if ((fir_r_sqrcut_st) &&  (st_shift_ccnt>=sub_sqcut_len_reg) &&  (sub_sqcut_len_reg<=16'd8) ) begin
      // st_shift_scnt  <= sub_sqcut_len_reg[5:0]  ;
      // st_shift_en    <= 1'd1   ; 
  // end
  
  // else if ((fir_r_scrcut_st) &&  (st_shift_ccnt>=16'd8) &&  (sub_sccut_len_reg>16'd8) ) begin
      // st_shift_scnt  <= 16'd8  ;
      // st_shift_en    <= 1'd1   ;
  // end
  // else if ((fir_r_scrcut_st) &&  (st_shift_ccnt>=sub_sccut_len_reg) &&  (sub_sccut_len_reg<=16'd8) ) begin
      // st_shift_scnt  <= sub_sccut_len_reg[5:0]  ;
      // st_shift_en    <= 1'd1   ; 
  // end
  // else begin
       // st_shift_scnt  <= 6'd0  ;
       // st_shift_en    <= 1'd0  ;
  // end     
// end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire      [ 23: 0]       market_explain ; //市场说明 3
wire      [  7: 0]       info_classify  ; //信息分类 1
reg       [ 31: 0]       dialog_num     ; //会话编号 4
wire      [  7: 0]       contract_flag  ; //合约标志 1
wire      [ 31: 0]       contract_num   ; //合约编号 4
reg       [175: 0]       contract_code  ; //合约代码 22
reg       [ 71: 0]       update_time    ; //更新时间 9
reg       [ 31: 0]       update_ms      ; //更新毫秒 4
reg       [ 63: 0]       new_price      ; //最新价 8
reg       [ 31: 0]       turnover       ; //成交量 4
reg       [ 63: 0]       volume         ; //成交额 8   
reg       [ 63: 0]       position       ; //持仓量 8
reg       [ 63: 0]       purchase_price ; //申买价 8
reg       [ 31: 0]       buy_quantity   ; //申买量 4
reg       [ 63: 0]       sell_price     ; //申买价 8
reg       [ 31: 0]       sell_quantity  ; //申卖量 4
reg                      market_rdy     ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      dialog_num   <=  32'd0    ;
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  ) begin 
//      dialog_num   <=   current_id_wire   ;
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





//market_explain
//
//
assign  market_explain =  {8'h53,8'h51,8'h00}   ; 
//always@ ( negedge rst_n  or posedge clk)
//begin
//  if (~rst_n) begin
//      market_explain   <=  24'd0    ;
//  end
//  else  begin
//      market_explain   <=  {8'h53,8'h51,8'h00}   ;  //SQ	
//  end
//  //else if ( sq_frame_flag  ) begin
//  //    market_explain   <=  {8'h53,8'h51,8'h00}   ;  //SQ	
//  //end
//  //else if ( sc_frame_flag  ) begin
//  //    market_explain   <=  {8'h53,8'h43,8'h00}   ;  //SC
//  //end
//end


//info_classify
assign   info_classify =  8'h31 ;
assign   contract_flag =  8'h30 ;
assign   contract_num  =  32'd0  ;


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
 // else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==3'd0)  ) begin
  else if ( fir_r_rdata0_st  &&   (segm_type_2439) && (discard_data_cnt==3'd0)  ) begin  
      contract_code[175:48]   <=   contract_code0   ;  //16
  end
 // else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==3'd1)   ) begin 
  else if ( fir_r_rdata0_st  &&   (segm_type_2439) && (discard_data_cnt==3'd1)   ) begin 
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
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==3'd1)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2439) && (discard_data_cnt==3'd1)   ) begin  
      update_time[71:64]   <=   update_time_wire1   ;   //1
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==3'd2)   ) begin 
  else if ( fir_r_rdata0_st   && (segm_type_2439) && (discard_data_cnt==3'd2)   ) begin 
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
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2439) && (discard_data_cnt==3'd2)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2439) && (discard_data_cnt==3'd2)   ) begin  
     // update_ms[31: 0]   <=   update_ms_wire   ;   //4
      update_ms[31: 0]   <=   {update_ms_wire[7:0],update_ms_wire[15:8],update_ms_wire[23:16],update_ms_wire[31:24]}   ;   //4      
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      new_price   <=  64'd0    ;
  end
  else if (fir_r_id_st  ||   (&new_price[63:0])   ) begin
       new_price   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2433) && (discard_data_cnt==3'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2433) && (discard_data_cnt==3'd0)   ) begin  
      //new_price[63: 0]   <=   new_price_wire   ;   //8
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
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2433) && (discard_data_cnt==3'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2433) && (discard_data_cnt==3'd0)   ) begin  
      //turnover[31: 0]   <=   turnover_wire   ;   //4
      turnover[31: 0]   <=   { turnover_wire[7:0],turnover_wire[15:8],turnover_wire[23:16],turnover_wire[31:24]    }    ;   //4       
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      volume   <=  64'd0    ;
  end
  else if (fir_r_id_st    ||  (&volume[63:0])   ) begin
       volume   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2433) && (discard_data_cnt==3'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2433) && (discard_data_cnt==3'd0)   ) begin  
//      volume[63: 32]   <=   volume0   ;   //4
      volume[31:  0]   <=   { volume0[7:0],volume0[15:8],volume0[23:16],volume0[31:24]    }    ;   //4            
  end
//  else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd4 )  && (segm_type_2433)   ) begin
  else if ( fir_r_rend_st   && (segm_type_2433)   ) begin 
 //     volume[31: 0]   <=   volume1   ;   //4
      volume[63: 32]   <=   { volume1[7:0],volume1[15:8],volume1[23:16],volume1[31:24]    }    ;   //4                  
  end
end
//position
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      position   <=  64'd0    ;
  end
  else if (fir_r_id_st    ||  (&position[63:0])  ) begin
       position   <=  'd0    ;
  end
//  else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd4 )  && (segm_type_2433)   ) begin
  else if ( fir_r_rend_st  && (segm_type_2433)   ) begin  
      // position[63: 0]   <=   position_wire   ;   //8
       position[63: 0]   <=     {position_wire[7:0],position_wire[15:8],position_wire[23:16],position_wire[31:24],position_wire[39:32],position_wire[47:40],position_wire[55:48],position_wire[63:56]}   ;   //8              
  end
end

//purchase_price
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      purchase_price   <=  64'd0    ;
  end
  else if (fir_r_id_st   ||  (&purchase_price[63:0])  ) begin
       purchase_price   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2434) && (discard_data_cnt==3'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2434) && (discard_data_cnt==3'd0)   ) begin 
     // purchase_price[63:  0]   <=   purchase_price_wire   ;   //8
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
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2434) && (discard_data_cnt==3'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2434) && (discard_data_cnt==3'd0)   ) begin  
     // buy_quantity[31:  0]   <=   buy_quantity_wire   ;   //4
      buy_quantity[31:  0]   <=     {buy_quantity_wire[7:0],buy_quantity_wire[15:8],buy_quantity_wire[23:16],buy_quantity_wire[31:24]}    ;   //4
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sell_price   <=  64'd0    ;
  end
//  else if (fir_r_id_st ||  (&sell_price[63:0]) ) begin
  else if (fir_r_id_st ) begin  
       sell_price   <=  'd0    ;
  end
//  else if ( fir_r_rdata0_st  &&  (st_shift_ccnt>=6'd16 )  && (segm_type_2434) && (discard_data_cnt==3'd0)   ) begin
  else if ( fir_r_rdata0_st   && (segm_type_2434) && (discard_data_cnt==3'd0)   ) begin  
      //sell_price[63: 32]   <=   sell_price0   ;   //4
     sell_price[31: 0]   <=    {sell_price0[7:0],sell_price0[15:8],sell_price0[23:16],sell_price0[31:24] }  ;           
  end
//  else if ( fir_r_rend_st  &&  (st_shift_ccnt>=6'd8 )  && (segm_type_2434)   ) begin
  else if ( fir_r_rend_st  && (segm_type_2434)   ) begin  
//      sell_price[31:  0]   <=   sell_price1   ;   //4
     // sell_price[63:  0]   <=   ((&sell_price[63: 32])&&(&sell_price1[31:0]))   ?    64'd0  :    {  sell_price[63:32] ,sell_price1 }  ;   //4            
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
  else if ( fir_r_rend_st   && (segm_type_2434)   ) begin  
     // sell_quantity[31:  0]   <=   sell_quantity_wire   ;   //4
      sell_quantity[31:  0]   <=    {sell_quantity_wire[7:0],sell_quantity_wire[15:8],sell_quantity_wire[23:16],sell_quantity_wire[31:24]}   ;   //4      
  end
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//reg    [31:0]           current_cut_done_sqid_reg   ;
//reg    [31:0]           current_cut_done_scid_reg   ;
//reg    [31:0]           current_cut_now_sqid_reg   ;
//reg    [31:0]           current_cut_now_scid_reg   ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_cut_now_sqid_reg   <=  32'd0    ;
      current_cut_now_sqid_reg_vld <=  1'd0   ;
  end
  else if (params_filter_rst||fir_r_check_st) begin
      current_cut_now_sqid_reg   <=  32'd0    ;
      current_cut_now_sqid_reg_vld <=  1'd0   ;      
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 ) &&  sq_frame_flag  ) begin 
      current_cut_now_sqid_reg  <=    current_id_wire   ;
      current_cut_now_sqid_reg_vld <=  1'd1   ;
  end
  else begin
      current_cut_now_sqid_reg_vld <=  1'd0   ;      
  end
end

assign  current_cut_done_sqid_reg  =  current_cut_now_sqid_reg ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      //current_cut_done_sqid_reg   <=  32'd0    ;
      current_sqcut_done          <=   1'd0    ;
  end
  else if ( fir_r_rdata0_st ) begin 
        if (  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1) )   )begin
            if (segm_cnt1_wire==4'd0)  begin
                  if (patition_cnt>=patition_cnt_reg) begin
                        //current_cut_done_sqid_reg   <=  sq_frame_flag ?  current_cut_now_sqid_reg : current_cut_done_sqid_reg   ;  
                        current_sqcut_done          <=   sq_frame_flag    ;
                  end
                  else begin
                        current_sqcut_done          <=   1'd0    ;
                  end
            end
            else begin
                current_sqcut_done          <=   1'd0    ;
            end
       end
       else begin
           current_sqcut_done          <=   1'd0    ;
       end 
  end
  else if (fir_r_rend_st)  begin
       if (  st_shift_ccnt>=segm_cnt1_wire)begin
            if (patition_cnt>=patition_cnt_reg) begin
                  // current_cut_done_sqid_reg   <=  sq_frame_flag ?  current_cut_now_sqid_reg : current_cut_done_sqid_reg   ;  
                   current_sqcut_done          <=   sq_frame_flag    ;
            end
            else begin
                        current_sqcut_done          <=   1'd0    ;
            end
       end  
       else begin
                        current_sqcut_done          <=   1'd0    ;
       end      
  end 
  else begin
                        current_sqcut_done          <=   1'd0    ;
  end
end



// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
      // current_cut_now_scid_reg   <=  32'd0    ;
  // end
  // else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 ) &&  sc_frame_flag  ) begin 
      // current_cut_now_scid_reg  =    current_id_wire   ;
  // end
// end






//current_sqid_reg
/* always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_sqid_reg   <=  32'd0    ;
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  ) begin 
      if ( (current_id_wire>current_sqid_reg)&&sq_frame_flag && (patition_cnt_wire>16'h0001)  ) begin
             current_sqid_reg  =    current_id_wire   ;
      end 
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      current_scid_reg   <=  32'd0    ;
  end
  else if ( fir_r_id_st  &&  (st_shift_ccnt>=6'd12 )  ) begin 
      if ( (current_id_wire>current_scid_reg)&&sc_frame_flag && (patition_cnt_wire>16'h0001)  ) begin
             current_scid_reg  =    current_id_wire   ;
      end 
  end
end */
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//sc_cut_flag
//sq_cut_flag
/* always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sc_cut_flag   <=  1'd0    ;
  end
  else if ( fir_r_vsync_st  &&   (st_rx_cnt_reg<(sync_len_byte+16'd4))  ) begin 
      sc_cut_flag   <=  sc_frame_flag ;
  end
  // else if (fir_r_rdata0_st &&  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1)  &&  (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg)  ) begin
      // sc_cut_flag   <=  sc_frame_flag  &&   (st_rx_cnt_reg>16'16) && (st_rx_cnt_reg<=( 16'd16  +  16'd8 ) ) ;
  // end
  // else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) &&  (patition_cnt>=patition_cnt_reg) ) 
      // sc_cut_flag   <=  sc_frame_flag  &&   (st_rx_cnt_reg>segm_cnt1_wire) && (st_rx_cnt_reg<=( segm_cnt1_wire +  16'd8 ) ) ;
  // end
  else if (fir_r_rjudge_st) begin
     sc_cut_flag   <=  sc_frame_flag  &&   (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ;
  end 
  else begin
      sc_cut_flag   <=  1'd0    ;
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_flag   <=  1'd0    ;
  end
  else if ( fir_r_vsync_st  &&   (st_rx_cnt_reg<(sync_len_byte+16'd4))  ) begin 
      sq_cut_flag   <=  sq_frame_flag ;
  end
  // else if (fir_r_rdata0_st &&  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1)  &&  (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg)  ) begin
      // sc_cut_flag   <=  sq_frame_flag  &&   (st_rx_cnt_reg>16'16) && (st_rx_cnt_reg<=( 16'd16  +  16'd8 ) ) ;
  // end
  // else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) &&  (patition_cnt>=patition_cnt_reg) ) 
      // sc_cut_flag   <=  sq_frame_flag  &&   (st_rx_cnt_reg>segm_cnt1_wire) && (st_rx_cnt_reg<=( segm_cnt1_wire +  16'd8 ) ) ;
  // end
  else if (fir_r_rjudge_st) begin
      sq_cut_flag   <=  sq_frame_flag  &&   (|st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8 ) ;
  end 
  else begin
      sq_cut_flag   <=  1'd0    ;
  end
end */

//market_rdy
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      market_rdy   <=  1'd0    ;
  end
  //else if (sq_cut_reset_pre  || (|sq_cut_reset_pre_dly[7:0]) ) begin
  else if (sq_cut_reset_pre || sq_cut_reset || sq_cut_reset_pre_dly  ) begin
      market_rdy   <=  1'd0    ;
  end
  else if (fir_r_rdata0_st &&  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1) ) &&  (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg)  ) begin
      market_rdy   <=  (segm_type_2433_flag || segm_type_2434_flag) ;
  end
  else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) &&  (patition_cnt>=patition_cnt_reg) )  begin
      market_rdy   <=  (segm_type_2433_flag || segm_type_2434_flag) ;
  end
  // else if (fir_r_rjudge_st) begin
      // market_rdy   <=  1'd1 ;
  // end
  else begin
      market_rdy   <=  1'd0    ;
  end
end

/* //st_rx_ready
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rx_ready   <=  1'd1    ;
  end
  else if (fir_r_rdata0_st &&  (st_shift_ccnt>=6'd16)  &&  (discard_data_cnt >= (segm_cnt0_wire-1'b1))  &&  (segm_cnt1_wire==4'd0) && (patition_cnt>=patition_cnt_reg)  ) begin
      st_rx_ready   <=  1'd0 ;
  end
  else if (fir_r_rend_st && (st_shift_ccnt>=segm_cnt1_wire) &&  (patition_cnt>=patition_cnt_reg) )  begin
      st_rx_ready   <=  1'd0 ;
  end
  else if ( fir_r_rjudge_st  ) begin
      st_rx_ready   <=  1'd1 ;
  end
  else begin
      st_rx_ready   <=  1'd1    ;
  end
end */


//sq_cut_len_reg
//sq_cut_len_reg


//sq_cut_len_reg
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      sq_cut_len_reg  <=  16'd81    ;
  end
  else if (st_rx_start) begin
      sq_cut_len_reg  <=  16'd81    ;
  end
  else if (  fir_r_sync_st &&  (st_shift_ccnt>=6'd8)   ) begin 
      sq_cut_len_reg  <=    sync_len_byte  + 16'd4   ;
  end
end


//st_rq_cut_cnt
/* 
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rq_cut_cnt   <=   16'd0    ;
  end
  else if ( fir_r_sqcuth_st   )  begin
      st_rq_cut_cnt   <=   st_rx_cnt_reg ;
  end
  else if ( fir_r_vsync_st &&  (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sq_frame_flag ) begin
      st_rq_cut_cnt  <=    16'd8   ;   
  end
  else if ( (fir_r_sqcut_st )  && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg>16'd8) ) begin
      st_rq_cut_cnt  <=    st_rq_cut_cnt +  16'd8   ;   
  end
  else if ( (fir_r_sqcut_st )  && (st_shift_ccnt>=st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ) begin
      st_rq_cut_cnt  <=    st_rq_cut_cnt +  st_rx_cnt_reg   ;   
  end
  else if (fir_r_sqrcut_st &&  (st_shift_ccnt>=16'd8) &&  (sub_sqcut_len_reg>16'd8) ) begin
      st_rq_cut_cnt  <=    st_rq_cut_cnt +  16'd8   ;   
  end
  else if (fir_r_sqrcut_st &&  (st_shift_ccnt>=sub_sqcut_len_reg) &&  (sub_sqcut_len_reg<=16'd8) ) begin
      st_rq_cut_cnt  <=    st_rq_cut_cnt +  sub_sqcut_len_reg   ;   
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
      st_rc_cut_cnt   <=   16'd0    ;
  end
  else if (  fir_r_sccuth_st  )  begin
      st_rc_cut_cnt   <=   st_rx_cnt_reg ;
  end
  else if ( fir_r_vsync_st &&  (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg<(sync_len_byte+16'd4)) && sc_frame_flag ) begin
      st_rc_cut_cnt  <=    16'd8   ;   
  end
  else if ( ( fir_r_sccut_st)  && (st_shift_ccnt>=6'd8) && (st_rx_cnt_reg>16'd8) ) begin
      st_rc_cut_cnt  <=    st_rc_cut_cnt +  16'd8   ;   
  end
  else if ( ( fir_r_sccut_st)  && (st_shift_ccnt>=st_rx_cnt_reg) && (st_rx_cnt_reg<=16'd8) ) begin
      st_rc_cut_cnt  <=    st_rc_cut_cnt +  st_rx_cnt_reg   ;   
  end
  else if (fir_r_scrcut_st &&  (st_shift_ccnt>=16'd8) &&  (sub_sccut_len_reg>16'd8) ) begin
      st_rc_cut_cnt  <=    st_rc_cut_cnt +  16'd8   ;   
  end
  else if (fir_r_scrcut_st &&  (st_shift_ccnt>=sub_sccut_len_reg) &&  (sub_sccut_len_reg<=16'd8) ) begin
      st_rc_cut_cnt  <=    st_rc_cut_cnt +  sub_sccut_len_reg   ;   
  end
end
 */
  



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//reg                        sq_rx_start        ; 
//reg                        sq_rx_valid        ; 
//reg      [63:0]            sq_rx_data         ; 
//reg      [ 2:0]            sq_rx_empty        ; 
//reg                        sc_rx_start        ; 
//reg                        sc_rx_valid        ; 
//reg      [63:0]            sc_rx_data         ; 
//reg      [ 2:0]            sc_rx_empty        ; 

/* fir_cut_out  sq_fir_cut_out (
.sq_rx_start        (sq_rx_start     ), 
.sq_rx_end          (sq_rx_end       ),
.sq_rx_valid        (sq_rx_valid     ), 
.sq_rx_data         (sq_rx_data      ), 
.sq_rx_empty        (sq_rx_empty     ), 
.fir_r_sqcuth_st    (fir_r_sqcuth_st ),
.fir_r_vsync_st     (fir_r_vsync_st  ),
.fir_r_sqcut_st     (fir_r_sqcut_st  ),
.st_shift_ccnt      (st_shift_ccnt   ),  
.st_rx_cnt_reg      (st_rx_cnt_reg   ),
.sq_frame_flag      (sq_frame_flag   ),
.st_shift_reg       (st_shift_reg    ),
.clk                (clk             ),
.rst_n              (rst_n         )
);

fir_cut_out  sc_fir_cut_out (
.sq_rx_start        (sc_rx_start     ), 
.sq_rx_end          (sc_rx_end       ),
.sq_rx_valid        (sc_rx_valid     ), 
.sq_rx_data         (sc_rx_data      ), 
.sq_rx_empty        (sc_rx_empty     ), 
.fir_r_sqcuth_st    (fir_r_sccuth_st ),
.fir_r_vsync_st     (fir_r_vsync_st  ),
.fir_r_sqcut_st     (fir_r_sccut_st  ),
.st_shift_ccnt      (st_shift_ccnt   ),  
.st_rx_cnt_reg      (st_rx_cnt_reg   ),
.sq_frame_flag      (sc_frame_flag   ),
.st_shift_reg       (st_shift_reg    ),
.clk                (clk             ),
.rst_n            (rst_n         )
); */


fir_shift_reg_192  fir_shift_reg_192 (
.fir_rx_cstate        (fir_rx_cstate       )  ,

.st_shift_full_flag   (sq_shift_full_flag  )   ,
.st_rx_start          (st_rx_start         )   ,
.st_rx_offset         (4'd0                )   ,
.st_rx_end            (st_rx_end           )   ,
.st_rx_valid          (st_rx_valid         )   ,
.st_rx_data           (st_rx_data          )   ,
.st_rx_ready          (1'd1                )   ,
.st_rx_empty          (st_rx_empty         )   ,
.fir_r_idle_st        (fir_r_idle_st       )   ,
//.st_shift_start_reg   (st_shift_start_reg  )   ,
//.st_shift_end_reg     (st_shift_end_reg    )   ,
.st_shift_reg         (st_shift_reg        )   ,  
.st_shift_ccnt        (st_shift_ccnt       )   ,
.st_shift_scnt        (st_shift_scnt       )   ,
.st_shift_en          (st_shift_en         )   ,
.clk                  (clk                 )   ,
.rst_n                (rst_n               )   
);







endmodule

