module CFG_MUX ( /*AUTOARG*/
   // Outputs
   reg_rd_data, sub_reg_addr, reg_MFUNC_TOP_wr_en,
   reg_MFUNC_SUB1_wr_en, reg_MFUNC_SUB2_wr_en, reg_MFUNC_SUB3_wr_en,
   // Inputs
   clk, rst_n, reg_wr_en, reg_addr, reg_MFUNC_TOP_rd_data,
   reg_MFUNC_SUB1_rd_data, reg_MFUNC_SUB2_rd_data,
   reg_MFUNC_SUB3_rd_data
   );
input         clk;
input         rst_n;
input         reg_wr_en;
input  [63:0] reg_addr;
output [31:0] reg_rd_data;
output [11:0] sub_reg_addr;
input  [31:0] reg_MFUNC_TOP_rd_data;
input  [31:0] reg_MFUNC_SUB1_rd_data;
input  [31:0] reg_MFUNC_SUB2_rd_data;
input  [31:0] reg_MFUNC_SUB3_rd_data;
output        reg_MFUNC_TOP_wr_en;
output        reg_MFUNC_SUB1_wr_en;
output        reg_MFUNC_SUB2_wr_en;
output        reg_MFUNC_SUB3_wr_en;
/////////////////////////////////////////////////////
reg [31:0] reg_rd_data;
assign  reg_MFUNC_TOP_wr_en =  reg_wr_en&&(reg_addr[63:13]==6'h0000);
assign  reg_MFUNC_SUB1_wr_en =  reg_wr_en&&(reg_addr[63:13]==6'h0001);
assign  reg_MFUNC_SUB2_wr_en =  reg_wr_en&&(reg_addr[63:13]==6'h0002);
assign  reg_MFUNC_SUB3_wr_en =  reg_wr_en&&(reg_addr[63:13]==6'h0003);
assign  sub_reg_addr =  reg_addr[11:0];
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       reg_rd_data<='d0;
    end
    else  begin
        case(reg_addr[63:13]) begin
        6'h0000 : reg_rd_data<=reg_MFUNC_TOP_rd_data;
        6'h0001 : reg_rd_data<=reg_MFUNC_SUB1_rd_data;
        6'h0002 : reg_rd_data<=reg_MFUNC_SUB2_rd_data;
        default : reg_rd_data<=reg_MFUNC_SUB3_rd_data;
        endcase
    end
end
endmodule
