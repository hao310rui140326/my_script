//
//Function Description:
//                     1. 
//
//Revision 
//        Version                         Auther                      Data()                              Description
//          0.1                           jwei                       20181109                               creat
//          0.2                           jwei                       20181204            the cut_flag become 32channel;market type is configed by register
//          0.3                           jwei                       20181206             output the short pkt 
//          0.4                           jwei                       2019010             1modified the market_pkt_byte_o,output by calculate
module parse_search_32ch 
 (
   clk,
   rst_n,
   mac_st_rx_vld,
   mac_st_rx_data,
   mac_st_rx_sop,
   mac_st_rx_eop,
   mac_st_rx_byte,
    
  cut_flag,            //valid before rx_sop, valid for a pulse
  cut_reset,  
   
  tcp_payload_len_o,           //no jumbo pkt, <1518  ,not inclued FCS,valid  when sop is valid
  tcp_payload_byte_cnt_o,
  fivetuplematch_o,   
  seq_err_flag_o,   
  
  market_pkt_vld_o,
  market_pkt_data_o,
  market_pkt_sop_o,           //start from tcp payload
  market_pkt_offset_o,        // unit of byte, the value means the invalid bytes
  market_pkt_eop_o,         
  market_pkt_byte_o,
  first_market_byte_o,  
    wfir_rx_cstate,
    wdebug_st_shift_full_flag ,
    wdebug_discard_calc_cnt1  ,
    wst_rx_cnt_reg        ,
    wst_shift_ccnt        ,
    wdebug_st_shift_scnt   ,
    wdebug_st_shift_en     ,
    error_flag  ,


    params_current_sqid_reg_ro  ,
    current_sqid_reg         ,
    current_sqid_reg_vld         ,



  //dbg signals
       pkt_in_cnt_o,
     mac_in_tcp_cnt,
                tlp_cnt,
        rq_tlp_cnt,
       market_pkt_cnt_o
  );
  
  localparam [2:0] IDLE          = 3'b000; //wait for  new sop
  localparam [2:0] PARSE         = 3'b001; //parse eth head
  localparam [2:0] PAYLOAD_OUT   = 3'b011;
  localparam [2:0] SEARCH        = 3'b010; //search for market pkt head  
 


 input            clk;
  input            rst_n;
  //signals with mac core rx
  input            mac_st_rx_vld;
  input    [63:0]  mac_st_rx_data;
  input            mac_st_rx_sop;
  input            mac_st_rx_eop;
  input     [2:0]  mac_st_rx_byte;
    
  //signals with ctrl
  input     [31:0]     cut_flag;           //valid before rx_sop, valid for a pulse
  input     [31:0]     cut_reset;  
   
  output       [15:0]         tcp_payload_len_o;           //no jumbo pkt, <1518  ,not inclued FCS,valid  when sop is valid
  output   [15:0]         tcp_payload_byte_cnt_o;
  output   [31:0]  fivetuplematch_o;   
  output   [31:0]  seq_err_flag_o;   
  
  output           market_pkt_vld_o;
  output   [63:0]  market_pkt_data_o;
  output           market_pkt_sop_o;           //start from tcp payload
  output    [3:0]  market_pkt_offset_o;        // unit of byte, the value means the invalid bytes
  output           market_pkt_eop_o;        
  output    [2:0]  market_pkt_byte_o;
  output    [15:0] first_market_byte_o;  
  input   [4:0]          wfir_rx_cstate;
  input                  wdebug_st_shift_full_flag ;
  input   [3:0]          wdebug_discard_calc_cnt1  ;
  input   [15:0]         wst_rx_cnt_reg        ;
  input   [ 5:0]         wst_shift_ccnt        ;
  input   [5:0]          wdebug_st_shift_scnt   ;
  input                  wdebug_st_shift_en     ;
 input     [31:0]              error_flag  ;


  input    [31:0  ]      params_current_sqid_reg_ro  ;
  input    [31:0  ]      current_sqid_reg         ;
  input                  current_sqid_reg_vld         ;

  //dbg signals
  output   [63:0]      pkt_in_cnt_o;
  output  [31:0]     mac_in_tcp_cnt;
  input   [31:0]                    tlp_cnt;
  input   [31:0]            rq_tlp_cnt;
  output  [63:0]      market_pkt_cnt_o;
 

   reg [63:0]      pkt_in_cnt_o;
  reg [31:0]     mac_in_tcp_cnt;
  reg [63:0]      market_pkt_cnt_o;


  reg [15:0]         tcp_payload_byte_cnt_o;
  reg [31:0]  fivetuplematch_o;   
  reg [31:0]  seq_err_flag_o;   
  
  reg         market_pkt_vld_o;
  reg [63:0]  market_pkt_data_o;
  reg         market_pkt_sop_o;           //start from tcp payload
  reg  [3:0]  market_pkt_offset_o;        // unit of byte, the value means the invalid bytes
  reg         market_pkt_eop_o;        
  reg  [2:0]  market_pkt_byte_o;
  reg  [15:0] first_market_byte_o;  







 
  reg    [2:0]     cur_state;
  reg    [2:0]     next_state;
  
  reg   [103:0]    fivetuple_pre [0:31] ;   //{sip,dip,sp,dp,pro} 13B
  reg   [103:0]    fivetuple_cur = 104'b0;   //{sip,dip,sp,dp,pro} 13B  
 
  reg   [135:0]    fivetuple_seq_pre [0:31] ;   //{sip,dip,sp,dp,pro} 13B
  wire  [135:0]    fivetuple_seq_cur ;   //{sip,dip,sp,dp,pro} 13B  
  reg   [135:0]    fivetuple_cur_nex_seq;
  reg   [31:0]     cut_keep = {32{1'b0}};
  reg   [31:0]     cut_start = {32{1'b0}};
  wire  [31:0]     match_flag;
  wire  [31:0]     seq_err_flag;
  
  reg              is_ipv4;
  reg              is_tcp_norm;
  reg              is_tcp_vlan;
  wire             is_tcp;
  reg              is_vlan;

  reg              is_ipv4_flag = 1'd0 ;
  reg              is_tcp_flag  = 1'd0 ;

  reg              short_pkt;
  
  reg  [31:0]      sip;
  reg  [31:0]      dip;
  reg  [7:0]       pro;
  reg  [15:0]      sp;
  reg  [15:0]      dp;
  reg              parse_fivetuple_done;

  wire [15:0]      pkt_total_len;
  reg  [15:0]      ip_total_len;
  reg  [5:0]       ip_head_len;
  reg  [5:0]       tcp_head_len;
  reg  [6:0]       tcp_head_offset; 
  reg              tcp_head_start;
  reg  [6:0]       payload_head_offset; 
  reg              payload_head_start;
  reg              payload_head_flag;
  reg   [31:0]     tcp_seq;
  reg   [31:0]     tcp_seq_reg;
  wire  [31:0]     next_seq;
  reg   [5:0]     tcp_head_len_seq; 
  reg             tcp_head_start_dly ;
  reg             tcp_head_start_dly2;

  
  reg  [63:0]     payload;
  reg  [63:0]     payload_dly; 
  reg             payload_start;
  
  reg   [63:0]    mac_st_rx_data_dly;
  reg   [63:0]    mac_st_rx_data_dly2;
  wire            mac_rx_sop;
  wire            mac_rx_eop;
  reg  [15:0]     first_market_byte;

  reg            search_sop;
  reg   [2:0]    search_offset;
  
  reg  [11:0]     pkt_byte_cnt = 12'd0;

  assign   mac_rx_sop = mac_st_rx_vld & mac_st_rx_sop;
  assign   mac_rx_eop = mac_st_rx_vld & mac_st_rx_eop;
  //latch the data when vld
  always @ (posedge clk) 
    if(mac_st_rx_vld) begin
		mac_st_rx_data_dly   <= mac_st_rx_data;
      mac_st_rx_data_dly2  <= mac_st_rx_data_dly;
  end

  //cal the byte of the pkt
  always @ (posedge  clk)
    if(mac_rx_eop)
      pkt_byte_cnt <= 12'd0;
    else if(mac_st_rx_vld)
      pkt_byte_cnt <= pkt_byte_cnt + 12'd8;


  //assign pkt_total_len = ip_total_len + 16'd14;   //only consider eth+ip,others will not output
  reg   [15:0]  tcp_payload_len;
  assign tcp_payload_len_o = ip_total_len - ip_head_len - tcp_head_len;
  
  //always @(posedge clk)
    //tcp_payload_len <= mac_st_rx_vld  ?  (ip_total_len - ip_head_len - tcp_head_len_seq)  :   tcp_payload_len   ;
 // assign  tcp_payload_len = ip_total_len - ip_head_len - tcp_head_len_seq  ;
 //############################
 // FSM
 //############################
  always @(posedge clk)
    if(!rst_n)
      cur_state <= IDLE;
    else
      cur_state <= next_state;

  always @(*)
    case(cur_state)
    IDLE:  begin
        if(mac_rx_sop)
			next_state = PARSE;
        else
            next_state = IDLE;
    end
  
    PARSE:  begin
        if(!is_ipv4_flag  ||  !is_tcp_flag )    //valid pkt:mac+ipv4+tcp|| short_pkt
            next_state = IDLE;
        else if(parse_fivetuple_done&&mac_st_rx_vld) begin
			 if(|match_flag)
				next_state = PAYLOAD_OUT;
			 else
				next_state = SEARCH;
		end
 		else
            next_state = PARSE;
	end
  
    PAYLOAD_OUT: begin
		if(mac_rx_eop)
			next_state = IDLE;
		else
			next_state = PAYLOAD_OUT;
	end  
  
	SEARCH: begin
		if(mac_rx_eop)
			next_state = IDLE;
		else
			next_state = SEARCH;
	end  

    default:
        next_state = IDLE;
    endcase


  //keep the cut_flag until fivetuple match
  generate
    genvar ch;
	 for(ch = 0; ch < 32; ch=ch+1) begin: gen_fivetuplematch
		
	  	 always @(posedge clk) begin
			 if((fivetuple_seq_pre[ch] == fivetuple_seq_cur)&& cut_start[ch]&&mac_st_rx_vld)
				cut_keep[ch] <= 1'b0;
			 else if (cut_reset[ch])
				cut_keep[ch] <= 1'b0;      
			 else if(cut_flag[ch])
				cut_keep[ch] <=  1'b1;
		  end	  
			  
		  //keep the old fivetuple for match
		  always @(posedge clk) begin
			 if(cut_flag[ch])
				fivetuple_seq_pre[ch] <= fivetuple_cur_nex_seq;
		  
		  end
        
		  assign match_flag[ch] = cut_keep[ch]  && (fivetuple_seq_pre[ch] == fivetuple_seq_cur) && cut_start[ch]&&mac_st_rx_vld;
		  
		  assign seq_err_flag[ch] = cut_keep[ch]  && (fivetuple_seq_pre[ch][103:0] == fivetuple_seq_cur[103:0])&&(fivetuple_seq_pre[ch][135:104] != fivetuple_seq_cur[135:104]) && cut_start[ch]&& mac_st_rx_vld;
		  //output the fivetuple match flag
		  always @(posedge clk) begin
			if(!rst_n)
				fivetuplematch_o[ch] <= 1'b0;
			else if(market_pkt_eop_o&&market_pkt_vld_o)
				fivetuplematch_o[ch] <= 1'b0;
			else if(match_flag[ch])
				fivetuplematch_o[ch] <= 1'b1;
			end
				
		  always @(posedge clk) begin
			if(!rst_n)
				seq_err_flag_o[ch] <= 1'b0;
			else if(market_pkt_eop_o&&market_pkt_vld_o)
				seq_err_flag_o[ch] <= 1'b0;
			else if(seq_err_flag[ch])
				seq_err_flag_o[ch] <= 1'b1;
			end
	 end
  endgenerate   
  
 //############################
 // PARSE
 //############################ 
  reg [7:0]  pkt_cycle_cnt = 8'b0;
  always @(posedge clk) begin
    if(mac_rx_eop)
      pkt_cycle_cnt <= 8'b0;
    else if(mac_st_rx_vld)
      pkt_cycle_cnt <= pkt_cycle_cnt + 1'b1;
  end
      
  //parse vlan  
  always @(posedge clk) begin
    if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd1)) begin    //parse  mac_type
      if(mac_st_rx_data[31:16]==16'h8100)
        is_vlan <= 1'b1;
      else
        is_vlan <= 1'b0;
    end
  end 
 
  always @(posedge clk) begin
    if(mac_rx_eop)
      is_ipv4 <= 1'b0;
    else if(is_vlan && mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2)&& (mac_st_rx_data[63:48]== 16'h0800))
        is_ipv4 <= 1'b1;
    else if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd1) && (mac_st_rx_data[31:16]== 16'h0800))     //parse  mac_type
        is_ipv4 <= 1'b1;
  end
 
 //active for one clock 
 always @(posedge clk) begin
    if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd3)) begin    //parse  mac_type
      if(!is_ipv4)
        is_ipv4_flag <= 1'b0;
      else
        is_ipv4_flag <= 1'b1;
    end
   else 
      is_ipv4_flag <= 1'b1;
end

always @(posedge clk) begin
   if(mac_rx_eop)
      is_tcp_norm <= 1'b0; 
   else if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2)&&(mac_st_rx_data[7:0]== 8'h06))     //parse  mac_type
      is_tcp_norm <= 1'b1;
end

reg  is_tcp_vlan_flag;
always @(*) begin
   if(is_vlan && mac_st_rx_vld &&(pkt_cycle_cnt == 8'd3)&&(mac_st_rx_data[39:32]== 8'h06))
      is_tcp_vlan_flag = 1'b1;
   else 
      is_tcp_vlan_flag = 1'b0;
end

always @ (posedge clk)
   if(mac_rx_eop)
       is_tcp_vlan <= 1'b0;
   else if(is_tcp_vlan_flag)
       is_tcp_vlan <= 1'b1;

assign is_tcp = is_tcp_vlan | is_tcp_vlan_flag | is_tcp_norm;


  always @(posedge clk) begin
    if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd3)) begin    //parse  mac_type
      if(!is_tcp)
        is_tcp_flag <= 1'b0;
      else
        is_tcp_flag <= 1'b1;
    end 
    else begin
      is_tcp_flag <= 1'b1;
    end
  end
  
  wire  is_ipv4_norm;
  assign  is_ipv4_norm = is_ipv4 && !is_vlan;
 
  //fivetuple,payload_len
  always @(posedge clk)  begin
   if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd1) && (mac_st_rx_data[31:16]== 16'h0800))begin
	tcp_head_offset    <= {mac_st_rx_data[11:8],2'b00} + 7'd14;  //dl+ip len
	ip_head_len        <= {mac_st_rx_data[11:8],2'b00};
   end
     else if(is_vlan && mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2) && (mac_st_rx_data[63:48]== 16'h0800)) begin
	ip_head_len        <= {mac_st_rx_data[43:40],2'b00};
	tcp_head_offset    <= {mac_st_rx_data[43:40],2'b00} + 7'd18;  //dl+ip len
  end
 end

  always @(posedge clk) 
       if(is_ipv4_norm) begin
         if(mac_st_rx_vld) begin
		if(pkt_cycle_cnt == 8'd2) begin 
			pro            <=  mac_st_rx_data[7:0];
			ip_total_len   <=  mac_st_rx_data[63:48];
		end
		else if(pkt_cycle_cnt == 8'd3) begin
			sip      <= mac_st_rx_data[47:16];
		end
		else if(pkt_cycle_cnt == 8'd4) begin
			dip      <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
		end
           end
         end
      else if(is_vlan) begin
         if(mac_st_rx_vld) begin
                if(pkt_cycle_cnt == 8'd2) begin     
                        ip_total_len   <=  mac_st_rx_data[31:16];
                end
                else if(pkt_cycle_cnt == 8'd3) begin
                        pro            <=  mac_st_rx_data[39:32];
                end
                else if(pkt_cycle_cnt == 8'd4) begin
                        dip      <= mac_st_rx_data[47:16];
                        sip      <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
                end
           end
         end

	
   //############looking for tcp head################# 
  always @(posedge clk) begin
                if ( ~is_tcp  || ~is_ipv4 ) begin
                     tcp_head_start <= 1'd0 ;
                end
                else begin
		case(tcp_head_offset[6:3])
		 4'd4:  begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd3))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
				
		 4'd5:  begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd4))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
		 4'd6:  begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd5))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
		 4'd7:  begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd6))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
		 4'd8:  begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd7))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
	     4'd9:  begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd8))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
		 default : begin
			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd3))
				tcp_head_start <= 1'b1;
			else if(mac_st_rx_vld)
				tcp_head_start <= 1'b0;               
		 end
		 
		 endcase
		end
 
 end
  
  // the tcp_head_offset value is 2B,or 6B,
  always @(posedge clk) 
	if(!rst_n) begin
		tcp_head_start_dly  <= 1'b0;
		tcp_head_start_dly2 <= 1'b0;
	end
	else if(mac_st_rx_vld) begin  //latch
		tcp_head_start_dly  <= tcp_head_start ;
		tcp_head_start_dly2 <= tcp_head_start_dly;
		
	end
  //current fivetupel, 1 clk before payload start	 
  always @(posedge clk) 
		 case(tcp_head_offset[2:0])    //
		 3'b010: begin
			if(tcp_head_start & mac_st_rx_vld) begin
                                if(pkt_cycle_cnt == 8'd4)
				  fivetuple_cur <= {sip,mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48],pro,mac_st_rx_data[47:16]}; 
				else
				  fivetuple_cur <= {sip,dip,pro,mac_st_rx_data[47:16]};
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
		endcase  

   always @(*) 
		 case(tcp_head_offset[2:0])    //
		 3'b010: begin
			if(tcp_head_start_dly & mac_st_rx_vld) begin
				tcp_seq = {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
                                //tcp_head_len_seq = {mac_st_rx_data[15:12],2'b00};
			end
                       else begin
                            tcp_seq = 32'd0;
                           // tcp_head_len_seq = 6'd0;
                       end
		end
		
		 3'b110: begin
			if(tcp_head_start_dly2 & mac_st_rx_vld) begin
				tcp_seq= {mac_st_rx_data_dly[47:16]};
                                //tcp_head_len_seq = {mac_st_rx_data[47:44],2'b00};
			end
                       else begin
                            tcp_seq = 32'd0;
                            //tcp_head_len_seq = 6'd0;
                       end
		end		
		
		default: begin
			if(tcp_head_start_dly & mac_st_rx_vld) begin
				tcp_seq = {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
                               // tcp_head_len_seq = {mac_st_rx_data[15:12],2'b00};
			end
                       else begin
                            tcp_seq = 32'd0;
                            //tcp_head_len_seq = 6'd0;
                       end
		end
		endcase 

	  
      assign next_seq = tcp_seq_reg  + tcp_payload_len_o;
      //fivetuple_seq_cur is valid for one clock
	  assign  fivetuple_seq_cur  = {fivetuple_cur,tcp_seq};
       
	   //  when cut_flag is vld, keep the fivetuple.  
	   always @(posedge clk) 
	      fivetuple_cur_nex_seq <= {fivetuple_cur,next_seq};
		  
	// fivetuple parse is done
	always @(posedge clk) 
		if(mac_rx_eop)
			parse_fivetuple_done  <= 1'b0;
		else  begin
			case(tcp_head_offset[2:0]) 
			 3'b010: begin
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
			endcase 	
		end

   // fivetuple_pre updated when cut_flag is active, compare when the next packet come
  //fix the bug when cut_flag and tcp_head_start are in the same clk,commonly, cut_flag should ahead of tcp_head_start
  reg   [6:0]   tcp_head_offset_dly;
  always @ (posedge clk) begin
		 tcp_head_offset_dly <= tcp_head_offset;
	end
	
	
  generate
    genvar chn;
	 for(chn = 0; chn < 32; chn=chn+1) begin: gen_cut_start

			always @(posedge clk) 
				if(cut_flag[chn] && !tcp_head_start)
					cut_start[chn]  <= 1'b0;
				else  if(cut_keep[chn] | cut_flag[chn]) begin
					case(tcp_head_offset[2:0]) 
					 3'b010: begin
						if(tcp_head_start & mac_st_rx_vld) begin
							cut_start[chn]  <= 1'b1;
						end
					  end
					
					 3'b110: begin
						if(tcp_head_start_dly&&mac_st_rx_vld) begin
							cut_start[chn]  <= 1'b1;
						end
					end		
					
					default: begin
						if(tcp_head_start & mac_st_rx_vld ) begin
							cut_start[chn]  <= 1'b1;
						end
					end
					endcase 	
				 end
			  else
			    cut_start[chn]  <= 1'b0;
		 end
    endgenerate 	
 
    always @(posedge clk) 
              if(mac_rx_eop) begin
                payload_head_flag <= 1'b0;
              end
              else begin 
                
		  case(tcp_head_offset[2:0])    //
		    3'b010: begin
				if(tcp_head_start_dly & mac_st_rx_vld) begin
					sp           <= mac_st_rx_data_dly[47:32]; //for debug
					dp           <= mac_st_rx_data_dly[31:16];
					payload_head_offset <=  {mac_st_rx_data[15:12],2'b00} + tcp_head_offset;
					payload_head_flag   <= 1'b1;
                    tcp_head_len <= {mac_st_rx_data[15:12],2'b00};
					tcp_seq_reg <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};
				end
			end
			
		    3'b110: begin
				if(tcp_head_start_dly2 & mac_st_rx_vld) begin
					sp <= mac_st_rx_data_dly2[15:0];
					dp <= mac_st_rx_data_dly[63:48];
					payload_head_offset <= {mac_st_rx_data[47:44],2'b00} + tcp_head_offset;
					payload_head_flag   <= 1'b1;
                    tcp_head_len <= {mac_st_rx_data[47:44],2'b00};
					tcp_seq_reg <= {mac_st_rx_data_dly[47:16]};
				end
			end		
			
			default: begin
				if(tcp_head_start_dly & mac_st_rx_vld ) begin
					sp          <= mac_st_rx_data_dly[47:32];
					dp          <= mac_st_rx_data_dly[31:16];
					payload_head_offset <=  {mac_st_rx_data[15:12],2'b00} + tcp_head_offset;
					payload_head_flag   <= 1'b1;
                    tcp_head_len <= {mac_st_rx_data[15:12],2'b00};
					tcp_seq_reg <= {mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]};					
				end
			end
		   endcase
                end
	      
  //############looking for payload################# 
  always @(*) begin
                case(payload_head_offset[6:3])
		 4'd6:  begin
			if(payload_head_flag && mac_st_rx_vld && (pkt_cycle_cnt == 8'd6))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
				
		 4'd7:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd7))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 4'd8:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd8))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 4'd9:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd9))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 4'd10:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd10))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
	         4'd11:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd11))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 
		 4'd4:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd4))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end


		 4'd5:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd5))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end

		 4'd12:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd12))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 4'd13:  begin
			if(payload_head_flag &&mac_st_rx_vld && (pkt_cycle_cnt == 8'd13))
				payload_head_start = 1'b1;
			else //if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 
		 default : begin
//			if(mac_st_rx_vld && (pkt_cycle_cnt == 8'd5))
//				payload_head_start <= 1'b1;
//			else if(mac_st_rx_vld)
				payload_head_start = 1'b0;               
		 end
		 
		 endcase
	     end 
  

  //payload byte cnt
  always @(posedge clk) 
	if(mac_rx_eop & payload_head_start & mac_st_rx_vld)
	   tcp_payload_byte_cnt_o <= 4'd8 - mac_st_rx_byte - payload_head_offset[2:0];
	else if(mac_rx_eop)
	 	tcp_payload_byte_cnt_o <= tcp_payload_byte_cnt_o + (4'd8 - mac_st_rx_byte);
	else if(payload_head_start & mac_st_rx_vld)
		tcp_payload_byte_cnt_o <= 4'd8 - payload_head_offset[2:0];
	else if(mac_st_rx_vld)	
		tcp_payload_byte_cnt_o <= tcp_payload_byte_cnt_o + 4'd8;	
	
	
  //############################
  // SEARCH
  //############################ 
  //############search for 020000xx0100044c################# 
    always @(*)  
		  if(cur_state == SEARCH) begin
			if(mac_st_rx_vld && ({mac_st_rx_data_dly[47:32],mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]}== 48'h02000100044c)) begin  //payload == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd2;
				//first_market_byte  = mac_st_rx_data_dly[31:16];
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[39:24],mac_st_rx_data_dly[7:0],mac_st_rx_data[63:40]}== 48'h02000100044c)) begin  //payload>>1B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd3;
				//first_market_byte  = mac_st_rx_data_dly[23:8];
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[31:16],mac_st_rx_data[63:32]}== 48'h02000100044c)) begin  //payload>>2B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd4;
				//first_market_byte  = mac_st_rx_data_dly[15:0];
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[23:8],mac_st_rx_data[55:24]}== 48'h02000100044c)) begin  //payload>>3B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd5;
				//first_market_byte  = {mac_st_rx_data_dly[7:0],mac_st_rx_data[63:56]};
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[15:0],mac_st_rx_data[47:16]}== 48'h02000100044c)) begin  //payload>>4B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd6;
				//first_market_byte  = mac_st_rx_data[63:48];
			end		
			else if(mac_st_rx_vld &&  ({mac_st_rx_data_dly[7:0],mac_st_rx_data[63:56],mac_st_rx_data[39:8]}== 48'h02000100044c)) begin  //payload>>5B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd7;
				//first_market_byte  = mac_st_rx_data[55:40];
			end		
			else if(mac_st_rx_vld &&  ({mac_st_rx_data_dly[63:48],mac_st_rx_data_dly[31:0]}== 48'h02000100044c)) begin  //payload>>6B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd0;
				//first_market_byte  = mac_st_rx_data_dly[47:32];
			end		
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[55:40],mac_st_rx_data_dly[23:0],mac_st_rx_data[63:56]}== 48'h02000100044c)) begin  //payload>>7B == 0200xxx
				search_sop  	     = 1'b1;
				search_offset 	     = 3'd1;
				//first_market_byte  = mac_st_rx_data_dly[39:24];
			end		
			else begin  //payload>>7B == 0200xxx
				search_sop  	     = 1'b0;
				search_offset 	     = 3'd0;
				//first_market_byte  = 16'd0;
			end	
      end
		else begin
				search_sop  	     = 1'b0;
				search_offset 	     = 3'd0;		
		end

  // first_market_byte 
      always @(posedge clk) 

			if(mac_st_rx_vld && ({mac_st_rx_data_dly[15:0],mac_st_rx_data[63:48]}== 32'h0100044c)) begin  //payload == 0200xxx

				first_market_byte_o  <= mac_st_rx_data_dly[31:16];  //
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[7:0],mac_st_rx_data[63:40]}== 32'h0100044c)) begin  //payload>>1B == 0200xxx

				first_market_byte_o  <= mac_st_rx_data_dly[23:8];
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data[63:32]}== 32'h0100044c)) begin  //payload>>2B == 0200xxx

				first_market_byte_o  <= mac_st_rx_data_dly[15:0];
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data[55:24]}== 32'h0100044c)) begin  //payload>>3B == 0200xxx

				first_market_byte_o  <= {mac_st_rx_data_dly[7:0],mac_st_rx_data[63:56]};
			end
			else if(mac_st_rx_vld && ({mac_st_rx_data[47:16]}== 32'h0100044c)) begin  //payload>>4B == 0200xxx

				first_market_byte_o  <= mac_st_rx_data[63:48];
			end		
			else if(mac_st_rx_vld && ({mac_st_rx_data[39:8]}== 32'h0100044c)) begin  //payload>>5B == 0200xxx

				first_market_byte_o  <= mac_st_rx_data[55:40];
			end		
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[31:0]}== 32'h0100044c)) begin  //payload>>6B == 0200xxx

				first_market_byte_o  <= mac_st_rx_data_dly[47:32];
			end		
			else if(mac_st_rx_vld && ({mac_st_rx_data_dly[23:0],mac_st_rx_data[63:56]}== 32'h0100044c)) begin  //payload>>7B == 0200xxx

				first_market_byte_o  <= mac_st_rx_data_dly[39:24];
			end		

  //############output market pkt################# 
  //sop
  reg    search_sop_inv = 1'b0;
  always @(posedge clk) 	
	if(cur_state == PAYLOAD_OUT) begin
		market_pkt_sop_o     <= payload_head_start;
		market_pkt_offset_o  <= payload_head_offset[2:0];
		market_pkt_vld_o     <= mac_st_rx_vld & (payload_start|payload_head_start);
		market_pkt_data_o    <= mac_st_rx_data;
	end
	else if(cur_state == SEARCH) begin
		market_pkt_sop_o     <= search_sop & mac_st_rx_vld && (search_sop_inv == 1'b0);  //the first sop
		market_pkt_offset_o  <= search_offset;
		market_pkt_vld_o     <= mac_st_rx_vld & (payload_start | search_sop );
		market_pkt_data_o    <= mac_st_rx_data;
		
	end		
	else begin
		market_pkt_sop_o     <= 1'b0;
		market_pkt_offset_o  <= 3'b0;
		market_pkt_vld_o     <= 1'b0;
		market_pkt_data_o    <= 64'b0;
	end		
 

	
  //output the first sop
  always @(posedge clk) 	
    if(cur_state == SEARCH) begin
	  if(search_sop & mac_st_rx_vld)
	    search_sop_inv <=  1'b1;
	end
	else
	    search_sop_inv <= 5'b0;

  
  //vld
  wire   payload_flag;
  always @(posedge clk)
	if(mac_rx_eop)
		payload_start <= 1'b0;
	else if((cur_state == PAYLOAD_OUT) && payload_head_start)
	   payload_start <= 1'b1;
	else if((cur_state == SEARCH) &&  search_sop)
		payload_start <= 1'b1;
  
  // market_sop and eop in the same clk
  assign payload_flag = payload_start || ((cur_state == PAYLOAD_OUT) && payload_head_start) || ((cur_state == SEARCH) &&  search_sop);
  
  
  //eop and byte output 
  always @(posedge clk) begin
     market_pkt_eop_o  <= mac_st_rx_eop ;//& payload_flag modifed for timing
     market_pkt_byte_o <= mac_st_rx_byte;
	end
  
  //the signal of byte_o  of mac ip's output sometimes err
//  always @ (posedge clk)
//    if(mac_rx_eop)
//      market_pkt_byte_o  <= 4'd8 -(pkt_total_len -pkt_byte_cnt);
 
   //############dbg################# 
	always @(posedge clk)
	   if(!rst_n)
		  pkt_in_cnt_o <= 'd0;
		else if(mac_rx_sop)
		   pkt_in_cnt_o <= pkt_in_cnt_o + 1'b1;
			
			
	always @(posedge clk)
	  if(!rst_n)
		  market_pkt_cnt_o <= 64'd0;
	  else if(market_pkt_sop_o&&market_pkt_vld_o)
		   market_pkt_cnt_o <= market_pkt_cnt_o + 1'b1;			
	
			
   always @(posedge clk)
     if(!rst_n)
         mac_in_tcp_cnt <= 32'd0;
     else if(mac_st_rx_vld &&(pkt_cycle_cnt == 8'd2)&&(mac_st_rx_data[7:0]==8'h06))
         mac_in_tcp_cnt <= mac_in_tcp_cnt + 1'b1;      
//         
//     reg    [4:0]         fir_rx_cstate;
//     reg                  debug_st_shift_full_flag ;
//     reg   [3:0]          debug_discard_calc_cnt1  ;
//     reg   [15:0]         st_rx_cnt_reg        ;
//     reg   [ 5:0]         st_shift_ccnt        ;
//     reg   [5:0]          debug_st_shift_scnt   ;
//     reg                  debug_st_shift_en     ; 
//     
////  reg    [31:0  ]      params_current_sqid_reg_ro  ,
//  reg    [31:0  ]      current_sqid_reg_reg         ;
//  reg                  current_sqid_reg_reg_vld         ;
//
//always @ (posedge clk) begin
//      fir_rx_cstate              <=    wfir_rx_cstate;
//      debug_st_shift_full_flag   <=    wdebug_st_shift_full_flag ;
//      debug_discard_calc_cnt1    <=    wdebug_discard_calc_cnt1  ;
//      st_rx_cnt_reg              <=    wst_rx_cnt_reg        ;
//      st_shift_ccnt              <=    wst_shift_ccnt        ;
//      debug_st_shift_scnt        <=    wdebug_st_shift_scnt   ;
//      debug_st_shift_en          <=    wdebug_st_shift_en    ;
//      current_sqid_reg_reg       <=    current_sqid_reg      ;
//      current_sqid_reg_reg_vld   <=    current_sqid_reg_vld  ;
//    end	  
//  
//  //error_flag
//           ila_mac u2_2ila_mac (
//               .clk(clk), // input wire clk
//           
//               .probe0({market_pkt_eop_o,market_pkt_vld_o,market_pkt_sop_o,market_pkt_byte_o,market_pkt_offset_o}), // input wire [9:0]  probe0  
////               .probe1(mac_in_tcp_cnt), // input wire [31:0]  probe1 
//               .probe1(    next_seq      ), // input wire [31:0]  probe1 
//
//               .probe2(mac_st_rx_sop), // input wire [0:0]  probe2 
//               .probe3(mac_st_rx_vld), // input wire [0:0]  probe3 
//               .probe4({mac_st_rx_eop}), // input wire [1:0]  probe4 
////               .probe5({tcp_payload_len_o,tcp_payload_byte_cnt_o,cut_flag}), // 64
//
//               .probe5({  current_sqid_reg_reg_vld  ,tcp_payload_len_o[14:0],tcp_payload_byte_cnt_o,    tcp_seq    }), // 64
//
//               .probe6({error_flag[4:0],rq_tlp_cnt[15:0],tlp_cnt[15:0]}), // input wire [63:0]  probe6 
////               .probe7(fivetuplematch_o) ,// input wire [31:0]  probe7 // input wire [63:0]  probe4 st_rx_data
//
//               .probe7({fivetuplematch_o[15:0], cut_flag[15:0]   }) ,// input wire [31:0]  probe7 // input wire [63:0]  probe4 st_rx_data
//
//               .probe8({debug_discard_calc_cnt1,st_rx_cnt_reg,st_shift_ccnt,debug_st_shift_scnt,debug_st_shift_en}), // input wire [31:0]  probe8 
//               .probe9({cut_start[15:0],fir_rx_cstate,debug_st_shift_full_flag,mac_st_rx_byte}), // input wire [31:0]  probe9
//               .probe10({mac_st_rx_data[63:32]})       //32       
//           );
//
//	
//	
//	
endmodule
