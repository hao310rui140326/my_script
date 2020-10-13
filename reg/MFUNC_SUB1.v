module MFUNC_SUB1 ( /*AUTOARG*/
   // Outputs
   reg_MFUNC_SUB1_rd_data, params_other1, params_other2,
   params_other3, params_other4,
   // Inputs
   clk, rst_n, reg_MFUNC_SUB1_wr_en, sub_reg_addr, reg_wr_data,
   params_other5
   );
input         clk;
input         rst_n;
input         reg_MFUNC_SUB1_wr_en;
input  [11:0] sub_reg_addr;
input  [31:0] reg_wr_data;
output [31:0] reg_MFUNC_SUB1_rd_data;
output           params_other1;
output  [31:0]   params_other2;
output  [31:0]   params_other3;
output  [31:0]   params_other4;
input            params_other5;
/////////////////////////////////////////////////////
reg  [31:0]   reg_MFUNC_SUB1_rd_data;
reg           reg_000;
reg  [31:0]   reg_004;
reg  [31:0]   reg_008;
reg  [31:0]   reg_00c;
reg           reg_020;
wire          wr_000_en;
wire          wr_004_en;
wire          wr_008_en;
wire          wr_00c_en;
wire          wr_020_en;
assign          wr_000_en=(reg_MFUNC_SUB1_wr_en&&(sub_reg_addr==12'h000));
assign          wr_004_en=(reg_MFUNC_SUB1_wr_en&&(sub_reg_addr==12'h004));
assign          wr_008_en=(reg_MFUNC_SUB1_wr_en&&(sub_reg_addr==12'h008));
assign          wr_00c_en=(reg_MFUNC_SUB1_wr_en&&(sub_reg_addr==12'h00c));
assign          wr_020_en=(reg_MFUNC_SUB1_wr_en&&(sub_reg_addr==12'h020));
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
assign  params_other1=reg_000;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_004<=32'h0000_0003;
    end
    else if (wr_004_en) begin
       reg_004<=reg_wr_data;
    end
end
assign  params_other2=reg_004;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_008<=32'h0000_0002;
    end
    else if (wr_008_en) begin
       reg_008<=reg_wr_data;
    end
end
assign  params_other3=reg_008;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_00c<=32'h0000_0001;
    end
    else if (wr_00c_en) begin
       reg_00c<=reg_wr_data;
    end
end
assign  params_other4=reg_00c;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_020<=1'd0;
    end
    else  begin
       reg_020<=params_other5;
    end
end
always @( * )
begin
    case(sub_reg_addr) begin
    12'h000 : reg_MFUNC_SUB1_rd_data=reg_000;
    12'h004 : reg_MFUNC_SUB1_rd_data=reg_004;
    12'h008 : reg_MFUNC_SUB1_rd_data=reg_008;
    12'h00c : reg_MFUNC_SUB1_rd_data=reg_00c;
    default : reg_MFUNC_SUB1_rd_data=reg_020;
    endcase
end
endmodule
