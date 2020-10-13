module MFUNC_TOP ( /*AUTOARG*/
   // Outputs
   reg_MFUNC_TOP_rd_data, params_start, params_saddr_l,
   params_saddr_h, params_daddr_l, params_data_len, params_wr_mode,
   params_rd_mode,
   // Inputs
   clk, rst_n, reg_MFUNC_TOP_wr_en, sub_reg_addr, reg_wr_data,
   params_data_done
   );
input         clk;
input         rst_n;
input         reg_MFUNC_TOP_wr_en;
input  [11:0] sub_reg_addr;
input  [31:0] reg_wr_data;
output [31:0] reg_MFUNC_TOP_rd_data;
output           params_start;
output  [31:0]   params_saddr_l;
output  [31:0]   params_saddr_h;
output  [31:0]   params_daddr_l;
output  [31:0]   params_daddr_l;
output  [31:0]   params_data_len;
output           params_wr_mode;
output           params_rd_mode;
input            params_data_done;
/////////////////////////////////////////////////////
reg  [31:0]   reg_MFUNC_TOP_rd_data;
reg           reg_000;
reg  [31:0]   reg_004;
reg  [31:0]   reg_008;
reg  [31:0]   reg_00c;
reg  [31:0]   reg_010;
reg  [31:0]   reg_014;
reg           reg_018;
reg           reg_01c;
reg           reg_020;
wire          wr_000_en;
wire          wr_004_en;
wire          wr_008_en;
wire          wr_00c_en;
wire          wr_010_en;
wire          wr_014_en;
wire          wr_018_en;
wire          wr_01c_en;
wire          wr_020_en;
assign          wr_000_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h000));
assign          wr_004_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h004));
assign          wr_008_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h008));
assign          wr_00c_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h00c));
assign          wr_010_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h010));
assign          wr_014_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h014));
assign          wr_018_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h018));
assign          wr_01c_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h01c));
assign          wr_020_en=(reg_MFUNC_TOP_wr_en&&(sub_reg_addr==12'h020));
/////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_000<=1'b0;
    end
    else if (wr_000_en) begin
       reg_000<=reg_wr_data;
    end
end
assign  params_start=reg_000;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_004<=32'h0000_0000;
    end
    else if (wr_004_en) begin
       reg_004<=reg_wr_data;
    end
end
assign  params_saddr_l=reg_004;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_008<=32'h0000_0000;
    end
    else if (wr_008_en) begin
       reg_008<=reg_wr_data;
    end
end
assign  params_saddr_h=reg_008;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_00c<=32'h0000_0000;
    end
    else if (wr_00c_en) begin
       reg_00c<=reg_wr_data;
    end
end
assign  params_daddr_l=reg_00c;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_010<=32'h0000_0000;
    end
    else if (wr_010_en) begin
       reg_010<=reg_wr_data;
    end
end
assign  params_daddr_l=reg_010;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_014<=32'h0000_0100;
    end
    else if (wr_014_en) begin
       reg_014<=reg_wr_data;
    end
end
assign  params_data_len=reg_014;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_018<=1'd0;
    end
    else if (wr_018_en) begin
       reg_018<=reg_wr_data;
    end
end
assign  params_wr_mode=reg_018;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_01c<=1'd0;
    end
    else if (wr_01c_en) begin
       reg_01c<=reg_wr_data;
    end
end
assign  params_rd_mode=reg_01c;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_020<=1'd0;
    end
    else  begin
       reg_020<=params_data_done;
    end
end
always @( * )
begin
    case(sub_reg_addr) begin
    12'h000 : reg_MFUNC_TOP_rd_data=reg_000;
    12'h004 : reg_MFUNC_TOP_rd_data=reg_004;
    12'h008 : reg_MFUNC_TOP_rd_data=reg_008;
    12'h00c : reg_MFUNC_TOP_rd_data=reg_00c;
    12'h010 : reg_MFUNC_TOP_rd_data=reg_010;
    12'h014 : reg_MFUNC_TOP_rd_data=reg_014;
    12'h018 : reg_MFUNC_TOP_rd_data=reg_018;
    12'h01c : reg_MFUNC_TOP_rd_data=reg_01c;
    default : reg_MFUNC_TOP_rd_data=reg_020;
    endcase
end
endmodule
