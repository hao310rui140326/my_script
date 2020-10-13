module CFG_TOP ( /*AUTOARG*/
   // Outputs
   reg_rd_data, params_wr_mode, params_start, params_saddr_l,
   params_saddr_h, params_rd_mode, params_other9, params_other8,
   params_other7, params_other6, params_other4, params_other3,
   params_other2, params_other14, params_other13, params_other12,
   params_other11, params_other1, params_data_len, params_daddr_l,
   // Inputs
   rst_n, reg_wr_en, reg_wr_data, reg_addr, params_other5,
   params_other15, params_other10, params_data_done, clk
   );
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			clk;			// To u_CFG_MUX of CFG_MUX.v, ...
input			params_data_done;	// To u_MFUNC_TOP of MFUNC_TOP.v
input			params_other10;		// To u_MFUNC_SUB2 of MFUNC_SUB2.v
input			params_other15;		// To u_MFUNC_SUB3 of MFUNC_SUB3.v
input			params_other5;		// To u_MFUNC_SUB1 of MFUNC_SUB1.v
input [63:0]		reg_addr;		// To u_CFG_MUX of CFG_MUX.v
input [31:0]		reg_wr_data;		// To u_MFUNC_TOP of MFUNC_TOP.v, ...
input			reg_wr_en;		// To u_CFG_MUX of CFG_MUX.v
input			rst_n;			// To u_CFG_MUX of CFG_MUX.v, ...
// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [31:0]		params_daddr_l;		// From u_MFUNC_TOP of MFUNC_TOP.v
output [31:0]		params_data_len;	// From u_MFUNC_TOP of MFUNC_TOP.v
output			params_other1;		// From u_MFUNC_SUB1 of MFUNC_SUB1.v
output			params_other11;		// From u_MFUNC_SUB3 of MFUNC_SUB3.v
output [31:0]		params_other12;		// From u_MFUNC_SUB3 of MFUNC_SUB3.v
output [31:0]		params_other13;		// From u_MFUNC_SUB3 of MFUNC_SUB3.v
output [31:0]		params_other14;		// From u_MFUNC_SUB3 of MFUNC_SUB3.v
output [31:0]		params_other2;		// From u_MFUNC_SUB1 of MFUNC_SUB1.v
output [31:0]		params_other3;		// From u_MFUNC_SUB1 of MFUNC_SUB1.v
output [31:0]		params_other4;		// From u_MFUNC_SUB1 of MFUNC_SUB1.v
output			params_other6;		// From u_MFUNC_SUB2 of MFUNC_SUB2.v
output [31:0]		params_other7;		// From u_MFUNC_SUB2 of MFUNC_SUB2.v
output [31:0]		params_other8;		// From u_MFUNC_SUB2 of MFUNC_SUB2.v
output [31:0]		params_other9;		// From u_MFUNC_SUB2 of MFUNC_SUB2.v
output			params_rd_mode;		// From u_MFUNC_TOP of MFUNC_TOP.v
output [31:0]		params_saddr_h;		// From u_MFUNC_TOP of MFUNC_TOP.v
output [31:0]		params_saddr_l;		// From u_MFUNC_TOP of MFUNC_TOP.v
output			params_start;		// From u_MFUNC_TOP of MFUNC_TOP.v
output			params_wr_mode;		// From u_MFUNC_TOP of MFUNC_TOP.v
output [31:0]		reg_rd_data;		// From u_CFG_MUX of CFG_MUX.v
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [31:0]		reg_MFUNC_SUB1_rd_data;	// From u_MFUNC_SUB1 of MFUNC_SUB1.v
wire			reg_MFUNC_SUB1_wr_en;	// From u_CFG_MUX of CFG_MUX.v
wire [31:0]		reg_MFUNC_SUB2_rd_data;	// From u_MFUNC_SUB2 of MFUNC_SUB2.v
wire			reg_MFUNC_SUB2_wr_en;	// From u_CFG_MUX of CFG_MUX.v
wire [31:0]		reg_MFUNC_SUB3_rd_data;	// From u_MFUNC_SUB3 of MFUNC_SUB3.v
wire			reg_MFUNC_SUB3_wr_en;	// From u_CFG_MUX of CFG_MUX.v
wire [31:0]		reg_MFUNC_TOP_rd_data;	// From u_MFUNC_TOP of MFUNC_TOP.v
wire			reg_MFUNC_TOP_wr_en;	// From u_CFG_MUX of CFG_MUX.v
wire [11:0]		sub_reg_addr;		// From u_CFG_MUX of CFG_MUX.v
// End of automatics
CFG_MUX u_CFG_MUX(/*AUTOINST*/
		  // Outputs
		  .reg_rd_data		(reg_rd_data[31:0]),
		  .sub_reg_addr		(sub_reg_addr[11:0]),
		  .reg_MFUNC_TOP_wr_en	(reg_MFUNC_TOP_wr_en),
		  .reg_MFUNC_SUB1_wr_en	(reg_MFUNC_SUB1_wr_en),
		  .reg_MFUNC_SUB2_wr_en	(reg_MFUNC_SUB2_wr_en),
		  .reg_MFUNC_SUB3_wr_en	(reg_MFUNC_SUB3_wr_en),
		  // Inputs
		  .clk			(clk),
		  .rst_n		(rst_n),
		  .reg_wr_en		(reg_wr_en),
		  .reg_addr		(reg_addr[63:0]),
		  .reg_MFUNC_TOP_rd_data(reg_MFUNC_TOP_rd_data[31:0]),
		  .reg_MFUNC_SUB1_rd_data(reg_MFUNC_SUB1_rd_data[31:0]),
		  .reg_MFUNC_SUB2_rd_data(reg_MFUNC_SUB2_rd_data[31:0]),
		  .reg_MFUNC_SUB3_rd_data(reg_MFUNC_SUB3_rd_data[31:0]));
MFUNC_TOP u_MFUNC_TOP(/*AUTOINST*/
		      // Outputs
		      .reg_MFUNC_TOP_rd_data(reg_MFUNC_TOP_rd_data[31:0]),
		      .params_start	(params_start),
		      .params_saddr_l	(params_saddr_l[31:0]),
		      .params_saddr_h	(params_saddr_h[31:0]),
		      .params_daddr_l	(params_daddr_l[31:0]),
		      .params_data_len	(params_data_len[31:0]),
		      .params_wr_mode	(params_wr_mode),
		      .params_rd_mode	(params_rd_mode),
		      // Inputs
		      .clk		(clk),
		      .rst_n		(rst_n),
		      .reg_MFUNC_TOP_wr_en(reg_MFUNC_TOP_wr_en),
		      .sub_reg_addr	(sub_reg_addr[11:0]),
		      .reg_wr_data	(reg_wr_data[31:0]),
		      .params_data_done	(params_data_done));
MFUNC_SUB1 u_MFUNC_SUB1(/*AUTOINST*/
			// Outputs
			.reg_MFUNC_SUB1_rd_data(reg_MFUNC_SUB1_rd_data[31:0]),
			.params_other1	(params_other1),
			.params_other2	(params_other2[31:0]),
			.params_other3	(params_other3[31:0]),
			.params_other4	(params_other4[31:0]),
			// Inputs
			.clk		(clk),
			.rst_n		(rst_n),
			.reg_MFUNC_SUB1_wr_en(reg_MFUNC_SUB1_wr_en),
			.sub_reg_addr	(sub_reg_addr[11:0]),
			.reg_wr_data	(reg_wr_data[31:0]),
			.params_other5	(params_other5));
MFUNC_SUB2 u_MFUNC_SUB2(/*AUTOINST*/
			// Outputs
			.reg_MFUNC_SUB2_rd_data(reg_MFUNC_SUB2_rd_data[31:0]),
			.params_other6	(params_other6),
			.params_other7	(params_other7[31:0]),
			.params_other8	(params_other8[31:0]),
			.params_other9	(params_other9[31:0]),
			// Inputs
			.clk		(clk),
			.rst_n		(rst_n),
			.reg_MFUNC_SUB2_wr_en(reg_MFUNC_SUB2_wr_en),
			.sub_reg_addr	(sub_reg_addr[11:0]),
			.reg_wr_data	(reg_wr_data[31:0]),
			.params_other10	(params_other10));
MFUNC_SUB3 u_MFUNC_SUB3(/*AUTOINST*/
			// Outputs
			.reg_MFUNC_SUB3_rd_data(reg_MFUNC_SUB3_rd_data[31:0]),
			.params_other11	(params_other11),
			.params_other12	(params_other12[31:0]),
			.params_other13	(params_other13[31:0]),
			.params_other14	(params_other14[31:0]),
			// Inputs
			.clk		(clk),
			.rst_n		(rst_n),
			.reg_MFUNC_SUB3_wr_en(reg_MFUNC_SUB3_wr_en),
			.sub_reg_addr	(sub_reg_addr[11:0]),
			.reg_wr_data	(reg_wr_data[31:0]),
			.params_other15	(params_other15));
endmodule
