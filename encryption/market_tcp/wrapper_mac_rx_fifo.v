//
//
module wrapper_mac_rx_fifo(
   //signals with 10G MAC
	clk_322,
	rst_n_322,
	mac_rx_data,
	mac_rx_bytes,
	mac_rx_vld,
	mac_rx_sop,
	mac_rx_eop,
	
	//signal with parse
	 clk_250,
	 market_pkt_ready,
	 rx_fifo_data_o,
	 rx_fifo_bytes_o,
	 rx_fifo_vld_o,
	 rx_fifo_sop_o,
	 rx_fifo_eop_o

);


	input         clk_322;
	input         rst_n_322;
	input  [31:0] mac_rx_data;
	input  [1:0]  mac_rx_bytes;
	input         mac_rx_vld;
	input         mac_rx_sop;
	input         mac_rx_eop;
	
	//signal with parse
	input           clk_250;
	input           market_pkt_ready;
	output  [63:0]  rx_fifo_data_o;
	output  [2:0]   rx_fifo_bytes_o;
	output          rx_fifo_vld_o;
	output          rx_fifo_sop_o;
	output          rx_fifo_eop_o;





wire               rx_fifo_full;
wire               rx_fifo_empty;
wire   [69:0]       rx_fifo_wrdata;
wire  [69:0]       rx_fifo_rddata;
reg                rx_fifo_wren;
wire               rx_fifo_rden;

reg                vld_flag;
reg  [35:0]        data_keep;
//reg [35:0]         data_keeep_reg;
reg  [2:0]         rx_fifo_byte;
reg  [63:0]        rx_fifo_data;
wire [1:0]         mac_rx_empty;
reg                rx_fifo_eop;
reg               rx_fifo_sop;

assign   mac_rx_empty = 3'd4 - mac_rx_bytes;
//32bit change to 64bit
always @ (posedge clk_322)
  if(!rst_n_322)
     vld_flag <= 1'b0;
  else if(mac_rx_vld & mac_rx_eop)
     vld_flag <= 1'b0;
  else if(mac_rx_vld)
     vld_flag <= ~vld_flag;

always @ (posedge clk_322)
  if(mac_rx_vld && !vld_flag)
     data_keep <= {mac_rx_sop,mac_rx_eop,mac_rx_empty,mac_rx_data};
	  
always @ (posedge clk_322)
  if(mac_rx_vld && mac_rx_eop && vld_flag)
     rx_fifo_byte <= {1'b0,mac_rx_empty};
  else if(mac_rx_vld && mac_rx_eop)
     rx_fifo_byte <= {1'b1,mac_rx_empty};
  else
     rx_fifo_byte <= 3'b0;

always @ (posedge clk_322)
  if(mac_rx_vld && mac_rx_eop && vld_flag)
     rx_fifo_data <= {data_keep[31:0],mac_rx_data};
  else if(mac_rx_vld && mac_rx_eop)
     rx_fifo_data <= {mac_rx_data,32'b0};
  else
     rx_fifo_data <= {data_keep[31:0],mac_rx_data};
	  
  	  
 //fifo in
 always @ (posedge clk_322) begin
    if(!rst_n_322)
         rx_fifo_wren <=   1'b0;
    else
          rx_fifo_wren <=   mac_rx_vld & vld_flag | mac_rx_vld & mac_rx_eop;

   end
         
 always @ (posedge clk_322)  
    if(!rst_n_322) begin
       rx_fifo_sop <= 1'b0;   
       rx_fifo_eop <= 1'b0;
     end
     else begin
            rx_fifo_sop <=  data_keep[35];
            rx_fifo_eop <= mac_rx_eop;
        end
 
assign       rx_fifo_wrdata = {1'b0,rx_fifo_sop,rx_fifo_eop,rx_fifo_byte,rx_fifo_data};
      
 assign rx_fifo_rden = !rx_fifo_empty && market_pkt_ready;
 
 //fifo out
 assign  rx_fifo_data_o  = rx_fifo_rddata[63:0];
 assign  rx_fifo_bytes_o = rx_fifo_rddata[66:64];
 assign  rx_fifo_sop_o   = rx_fifo_rddata[68];
 assign  rx_fifo_eop_o = rx_fifo_rddata[67];
 assign  rx_fifo_vld_o = rx_fifo_rden;
 
//
// mac_rx_fifo 
//  wrapper_mac_rx_fifo(
//		.din          (rx_fifo_wrdata),
//		.wr_en         (rx_fifo_wren),
//		.rd_en         (rx_fifo_rden),
//		.wr_clk         (clk_322),
//		.rd_clk         (clk_250),
//		.rst          (~rst_n_322),
//		.dout             (rx_fifo_rddata),
//		.empty       (rx_fifo_empty),
//		.full        (rx_fifo_full),
//		.wr_rst_busy (),
//		.rd_rst_busy()
//	);
//


 mac_rx_fifo 
  wrapper_mac_rx_fifo(
		.data          (rx_fifo_wrdata),
		.wrreq         (rx_fifo_wren),
		.rdreq         (rx_fifo_rden),
		.wrclk         (clk_322),
		.rdclk         (clk_250),
		//.rst          (~rst_n_322),
		.q              (rx_fifo_rddata),
		.rdempty       (rx_fifo_empty),
		.wrfull        (rx_fifo_full)
		//.wr_rst_busy (),
		//.rd_rst_busy()
	);






//ila_mac u_ila_mac (
//	.clk(clk_322), // input wire clk

//	.probe0({rx_fifo_wren,rx_fifo_byte}), // input wire [9:0]  probe0  
//	.probe1(rx_fifo_data[31:0]), // input wire [31:0]  probe1 
//	.probe2(mac_rx_sop), // input wire [0:0]  probe2 
//	.probe3(mac_rx_eop), // input wire [0:0]  probe3 
//	.probe4(mac_rx_vld) // input wire [1:0]  probe4 

//);

//ila_mac u2_2ila_mac (
//	.clk(clk_250), // input wire clk

//	.probe0({rx_fifo_rden,rx_fifo_eop_o}), // input wire [9:0]  probe0  
//	.probe1(rx_fifo_data_o[31:0]), // input wire [31:0]  probe1 
//	.probe2(rx_fifo_sop_o), // input wire [0:0]  probe2 
//	.probe3(rx_fifo_vld_o), // input wire [0:0]  probe3 
//	.probe4(rx_fifo_empty) // input wire [1:0]  probe4 

//);	


endmodule


