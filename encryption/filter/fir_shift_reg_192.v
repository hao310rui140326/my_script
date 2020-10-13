

module fir_shift_reg_192 (
fir_rx_cstate        ,

st_rx_start          ,
st_rx_offset         ,
st_rx_end            ,
st_rx_valid          ,
st_rx_data           ,
st_rx_ready          ,
st_rx_empty          ,

fir_r_idle_st        ,

// st_shift_start_reg   ,
// st_shift_end_reg     ,
st_shift_reg         ,  
st_shift_ccnt        ,
st_shift_scnt        ,
st_shift_en          ,

st_shift_full_flag   ,

clk                  ,
rst_n
);


input  [4:0]              fir_rx_cstate    ;

input                     clk              ;
input                     rst_n          ;

input                     st_rx_start      ;
input   [ 3:0]            st_rx_offset     ;
input                     st_rx_end        ;
input                     st_rx_valid      ;
input   [63:0]            st_rx_data       ;
input   [2:0]  	          st_rx_empty      ;
input                     st_rx_ready      ;    

input                     fir_r_idle_st    ;

// output  [ 23:0]           st_shift_start_reg ;
// output  [ 23:0]           st_shift_end_reg   ;    
output  [191:0]           st_shift_reg     ;
output  [  5:0]           st_shift_ccnt    ;
input   [  5:0]           st_shift_scnt    ;
input                     st_shift_en      ; 

output                    st_shift_full_flag  ;
////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////
reg     [191:0]           st_shift_reg ;
reg     [  5:0]           st_shift_ccnt;
wire    [  5:0]           st_shift_ccnt_wire ;


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     st_shift_ccnt  <=    6'd0 ;
  end
  else if (st_rx_start) begin 
     st_shift_ccnt  <=  6'd8 - st_rx_offset - st_rx_empty ;     
  end
  else if (fir_r_idle_st) begin
     st_shift_ccnt  <=    6'd0 ;
  end
  else if ( (st_rx_valid&&st_rx_ready)&&(st_shift_en)  ) begin
     st_shift_ccnt  <=  st_shift_ccnt + 6'd8  - st_shift_scnt   - st_rx_empty;          
  end 
  else if (  st_rx_valid&&st_rx_ready ) begin
     st_shift_ccnt  <=  st_shift_ccnt + 6'd8 - st_rx_empty ;          
  end 
  else if ( st_shift_en  ) begin
     st_shift_ccnt  <=  st_shift_ccnt  - st_shift_scnt   ;          
  end 
end

assign  st_shift_ccnt_wire = st_shift_en ?  ( st_shift_ccnt-st_shift_scnt )  :  st_shift_ccnt  ;
reg    [191:0]  st_shift_reg_1;
wire   [191:0]  st_shift_reg_2;
reg    [191:0]  st_shift_reg_3;
wire   [191:0]  st_shift_reg_4;
assign   st_shift_reg_2 = st_shift_en ?  st_shift_reg_1 : st_shift_reg ; 
always@ (*)
begin
  case ( st_shift_scnt )
     5'd0   :   st_shift_reg_1 =   { st_shift_reg[127+64:  0]          } ;
     5'd1   :   st_shift_reg_1 =   { st_shift_reg[119+64:  0] ,  8'd0  } ;
     5'd2   :   st_shift_reg_1 =   { st_shift_reg[111+64:  0] , 16'd0  } ;
     5'd3   :   st_shift_reg_1 =   { st_shift_reg[103+64:  0] , 24'd0  } ;
     5'd4   :   st_shift_reg_1 =   { st_shift_reg[ 95+64:  0] , 32'd0  } ;
     5'd5   :   st_shift_reg_1 =   { st_shift_reg[ 87+64:  0] , 40'd0  } ;
     5'd6   :   st_shift_reg_1 =   { st_shift_reg[ 79+64:  0] , 48'd0  } ;
     5'd7   :   st_shift_reg_1 =   { st_shift_reg[ 71+64:  0] , 56'd0  } ;
     5'd8   :   st_shift_reg_1 =   { st_shift_reg[ 63+64:  0] , 64'd0  } ;
     5'd9   :   st_shift_reg_1 =   { st_shift_reg[ 55+64:  0] , 72'd0  } ;
     5'd10  :   st_shift_reg_1 =   { st_shift_reg[ 47+64:  0] , 80'd0  } ;
     5'd11  :   st_shift_reg_1 =   { st_shift_reg[ 39+64:  0] , 88'd0  } ;
     5'd12  :   st_shift_reg_1 =   { st_shift_reg[ 31+64:  0] , 96'd0  } ;
     5'd13  :   st_shift_reg_1 =   { st_shift_reg[ 23+64:  0] ,104'd0  } ;
     5'd14  :   st_shift_reg_1 =   { st_shift_reg[ 15+64:  0] ,112'd0  } ;
     5'd15  :   st_shift_reg_1 =   { st_shift_reg[  7+64:  0] ,120'd0  } ;
     5'd16  :   st_shift_reg_1 =   { st_shift_reg[    63:  0] ,128'd0  } ;
     5'd17  :   st_shift_reg_1 =   { st_shift_reg[    55:  0] ,136'd0  } ;
     5'd18  :   st_shift_reg_1 =   { st_shift_reg[    47:  0] ,144'd0  } ;
     5'd19  :   st_shift_reg_1 =   { st_shift_reg[    39:  0] ,152'd0  } ;
     5'd20  :   st_shift_reg_1 =   { st_shift_reg[    31:  0] ,160'd0  } ;
     5'd21  :   st_shift_reg_1 =   { st_shift_reg[    23:  0] ,168'd0  } ;
     5'd22  :   st_shift_reg_1 =   { st_shift_reg[    15:  0] ,176'd0  } ;
     5'd23  :   st_shift_reg_1 =   { st_shift_reg[     7:  0] ,184'd0  } ;
     5'd24  :   st_shift_reg_1 =   {                           192'd0  } ;
     default :  st_shift_reg_1 =   {                           192'd0  } ;
     endcase
end
always@ (*)
begin
   case ( st_shift_ccnt_wire )
     5'd0   :   st_shift_reg_3 =   {                               st_rx_data[63:0] ,128'd0  } ;
     5'd1   :   st_shift_reg_3 =   { st_shift_reg_2[127+64:120+64],st_rx_data[63:0] ,120'd0  } ;
     5'd2   :   st_shift_reg_3 =   { st_shift_reg_2[127+64:112+64],st_rx_data[63:0] ,112'd0  } ;
     5'd3   :   st_shift_reg_3 =   { st_shift_reg_2[127+64:104+64],st_rx_data[63:0] ,104'd0  } ;
     5'd4   :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 96+64],st_rx_data[63:0] , 96'd0  } ;
     5'd5   :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 88+64],st_rx_data[63:0] , 88'd0  } ;
     5'd6   :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 80+64],st_rx_data[63:0] , 80'd0  } ;
     5'd7   :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 72+64],st_rx_data[63:0] , 72'd0  } ;
     5'd8   :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 64+64],st_rx_data[63:0] , 64'd0  } ;
     5'd9   :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 56+64],st_rx_data[63:0] , 56'd0  } ;
     5'd10  :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 48+64],st_rx_data[63:0] , 48'd0  } ;
     5'd11  :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 40+64],st_rx_data[63:0] , 40'd0  } ;
     5'd12  :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 32+64],st_rx_data[63:0] , 32'd0  } ;
     5'd13  :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 24+64],st_rx_data[63:0] , 24'd0  } ;
     5'd14  :   st_shift_reg_3 =   { st_shift_reg_2[127+64: 16+64],st_rx_data[63:0] , 16'd0  } ;
     5'd15  :   st_shift_reg_3 =   { st_shift_reg_2[127+64:  8+64],st_rx_data[63:0] ,  8'd0  } ;
     5'd16  :   st_shift_reg_3 =   { st_shift_reg_2[127+64:    64],st_rx_data[63:0]          } ;
     default :  st_shift_reg_3 =   { st_shift_reg_2[127+64:    64],st_rx_data[63:0]          } ;
     endcase
end
assign  st_shift_reg_4  =    st_rx_valid&&st_rx_ready  ?   st_shift_reg_3  :  st_shift_reg_2 ;

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     st_shift_reg   <=  192'd0 ;
  end
  else if (st_rx_start) begin
     case ( st_rx_offset ) 
     3'd0    :  st_shift_reg   <=  { st_rx_data[63:0]          ,64'd0 ,64'd0 } ;
     3'd1    :  st_shift_reg   <=  { st_rx_data[55:0] ,  8'd0  ,64'd0 ,64'd0 } ;
     3'd2    :  st_shift_reg   <=  { st_rx_data[47:0] , 16'd0  ,64'd0 ,64'd0 } ;
     3'd3    :  st_shift_reg   <=  { st_rx_data[39:0] , 24'd0  ,64'd0 ,64'd0 } ;
     3'd4    :  st_shift_reg   <=  { st_rx_data[31:0] , 32'd0  ,64'd0 ,64'd0 } ;
     3'd5    :  st_shift_reg   <=  { st_rx_data[23:0] , 40'd0  ,64'd0 ,64'd0 } ;
     3'd6    :  st_shift_reg   <=  { st_rx_data[15:0] , 48'd0  ,64'd0 ,64'd0 } ;
     3'd7    :  st_shift_reg   <=  { st_rx_data[ 7:0] , 56'd0  ,64'd0 ,64'd0 } ;
     default :  st_shift_reg   <=  {                    64'd0  ,64'd0 ,64'd0 } ;
     endcase 
  end
  else if (fir_r_idle_st) begin
     st_shift_reg  <=    192'd0 ;
  end
  else if (  (st_rx_valid&&st_rx_ready) || (st_shift_en)  ) begin
     st_shift_reg   <=   st_shift_reg_4 ;    
  end
  //else if ( (st_rx_valid&&st_rx_ready) && (st_shift_en)  ) begin
  //   st_shift_reg  <=    st_shift_reg_3 ;         
  //end
  //else if (st_shift_en) begin
  //   //st_shift_reg  <=   ( st_shift_reg<<st_shift_scnt ) ;
  //   st_shift_reg  <=    st_shift_reg_1 ;
  //end
  //else if ( st_rx_valid&&st_rx_ready ) begin
  //   st_shift_reg  <=    st_shift_reg_3 ;    
  //end
end


/////////////////////////////////////////////////////////////////////////////////////
/* reg     [23:0]           st_shift_start_reg ;
reg     [23:0]           st_shift_end_reg   ;

reg    [23:0]  st_shift_start_reg_1;
wire   [23:0]  st_shift_start_reg_2;
reg    [23:0]  st_shift_start_reg_3;
wire   [23:0]  st_shift_start_reg_4;
assign   st_shift_start_reg_2 = st_shift_en ?  st_shift_start_reg_1 : st_shift_start_reg ; 
always@ (*)
begin
  case ( st_shift_scnt )
     6'd0   :   st_shift_start_reg_1 =   { st_shift_start_reg[ 15+8:  0]         } ;
     6'd1   :   st_shift_start_reg_1 =   { st_shift_start_reg[ 14+8:  0] , 1'd0  } ;
     6'd2   :   st_shift_start_reg_1 =   { st_shift_start_reg[ 13+8:  0] , 2'd0  } ;
     6'd3   :   st_shift_start_reg_1 =   { st_shift_start_reg[ 12+8:  0] , 3'd0  } ;
     6'd4   :   st_shift_start_reg_1 =   { st_shift_start_reg[ 11+8:  0] , 4'd0  } ;
     6'd5   :   st_shift_start_reg_1 =   { st_shift_start_reg[ 10+8:  0] , 5'd0  } ;
     6'd6   :   st_shift_start_reg_1 =   { st_shift_start_reg[  9+8:  0] , 6'd0  } ;
     6'd7   :   st_shift_start_reg_1 =   { st_shift_start_reg[  8+8:  0] , 7'd0  } ;
     6'd8   :   st_shift_start_reg_1 =   { st_shift_start_reg[  7+8:  0] , 8'd0  } ;
     6'd9   :   st_shift_start_reg_1 =   { st_shift_start_reg[  6+8:  0] , 9'd0  } ;
     6'd10  :   st_shift_start_reg_1 =   { st_shift_start_reg[  5+8:  0] ,10'd0  } ;
     6'd11  :   st_shift_start_reg_1 =   { st_shift_start_reg[  4+8:  0] ,11'd0  } ;
     6'd12  :   st_shift_start_reg_1 =   { st_shift_start_reg[  3+8:  0] ,12'd0  } ;
     6'd13  :   st_shift_start_reg_1 =   { st_shift_start_reg[  2+8:  0] ,13'd0  } ;
     6'd14  :   st_shift_start_reg_1 =   { st_shift_start_reg[  1+8:  0] ,14'd0  } ;
     6'd15  :   st_shift_start_reg_1 =   { st_shift_start_reg[    8:  0] ,15'd0  } ;
     6'd16  :   st_shift_start_reg_1 =   { st_shift_start_reg[    7:  0] ,16'd0  } ; 
     6'd17  :   st_shift_start_reg_1 =   { st_shift_start_reg[    6:  0] ,17'd0  } ;
     6'd18  :   st_shift_start_reg_1 =   { st_shift_start_reg[    5:  0] ,18'd0  } ;
     6'd19  :   st_shift_start_reg_1 =   { st_shift_start_reg[    4:  0] ,19'd0  } ;
     6'd20  :   st_shift_start_reg_1 =   { st_shift_start_reg[    3:  0] ,20'd0  } ;
     6'd21  :   st_shift_start_reg_1 =   { st_shift_start_reg[    2:  0] ,21'd0  } ;
     6'd22  :   st_shift_start_reg_1 =   { st_shift_start_reg[    1:  0] ,22'd0  } ;
     6'd23  :   st_shift_start_reg_1 =   { st_shift_start_reg[        0] ,23'd0  } ;
     6'd24  :   st_shift_start_reg_1 =   {                                23'd0  } ; 
     default :  st_shift_start_reg_1 =   {                                23'd0  } ;

     endcase
end
always@ (*)
begin
   case ( st_shift_ccnt_wire )
     5'd0   :   st_shift_start_reg_3 =   {                                 {8{st_rx_start}} , 8'd0 ,8'd0  } ;
     5'd1   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8     ],{8{st_rx_start}} , 7'd0 ,8'd0  } ;
     5'd2   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8:14+8],{8{st_rx_start}} , 6'd0 ,8'd0  } ;
     5'd3   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8:13+8],{8{st_rx_start}} , 5'd0 ,8'd0  } ;
     5'd4   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8:12+8],{8{st_rx_start}} , 4'd0 ,8'd0  } ;
     5'd5   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8:11+8],{8{st_rx_start}} , 3'd0 ,8'd0  } ;
     5'd6   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8:10+8],{8{st_rx_start}} , 2'd0 ,8'd0  } ;
     5'd7   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 9+8],{8{st_rx_start}} , 1'd0 ,8'd0  } ;
     5'd8   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 8+8],{8{st_rx_start}}        ,8'd0   } ;
     5'd9   :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 7+8],{8{st_rx_start}}        ,7'd0  } ;
     5'd10  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 6+8],{8{st_rx_start}}        ,6'd0  } ;
     5'd11  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 5+8],{8{st_rx_start}}        ,5'd0  } ;
     5'd12  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 4+8],{8{st_rx_start}}        ,4'd0  } ;
     5'd13  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 3+8],{8{st_rx_start}}        ,3'd0  } ;
     5'd14  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 2+8],{8{st_rx_start}}        ,2'd0  } ;
     5'd15  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 1+8],{8{st_rx_start}}        ,1'd0  } ;
     5'd16  :   st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8:   8],{8{st_rx_start}}               } ;
     default :  st_shift_start_reg_3 =   { st_shift_start_reg_2[15+8: 8+8],{8{st_rx_start}}               } ;
     endcase
end
assign  st_shift_start_reg_4  =    st_rx_valid&&st_rx_ready  ?   st_shift_start_reg_3  :  st_shift_start_reg_2 ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     st_shift_start_reg   <=  16'd0 ;
  end
  else if (st_rx_start) begin 
     //st_shift_start_reg   <=  {8'hff,8'h00} ;
     case ( st_rx_offset ) 
     3'd0    :  st_shift_start_reg   <=  { 8'hff ,  8'd0,8'd0   } ;
     3'd1    :  st_shift_start_reg   <=  { 7'h7f ,  9'd0,8'd0   } ;
     3'd2    :  st_shift_start_reg   <=  { 6'h3f , 10'd0,8'd0   } ;
     3'd3    :  st_shift_start_reg   <=  { 5'h1f , 11'd0,8'd0   } ;
     3'd4    :  st_shift_start_reg   <=  {  4'hf , 12'd0,8'd0   } ;
     3'd5    :  st_shift_start_reg   <=  {  3'h3 , 13'd0,8'd0   } ;
     3'd6    :  st_shift_start_reg   <=  {  2'h2 , 14'd0,8'd0   } ;
     3'd7    :  st_shift_start_reg   <=  {  1'h1 , 15'd0,8'd0   } ;
     default :  st_shift_start_reg   <=  {         16'd0,8'd0   } ;
     endcase 
  end
  else if (fir_r_idle_st) begin
     st_shift_start_reg  <=    'd0 ;
  end
  else if (  (st_rx_valid&&st_rx_ready) || (st_shift_en)  ) begin
     st_shift_start_reg   <=   st_shift_start_reg_4 ;    
  end
  //else if ( (st_rx_valid&&st_rx_ready) && (st_shift_en)  ) begin
  //   st_shift_start_reg  <=    st_shift_start_reg_3 ;         
  //end
  //else if (st_shift_en) begin
  //   //st_shift_reg  <=   ( st_shift_reg<<st_shift_scnt ) ;
  //   st_shift_start_reg  <=    st_shift_start_reg_1 ;
  //end
  //else if ( st_rx_valid&&st_rx_ready ) begin
  //   st_shift_start_reg  <=    st_shift_start_reg_3 ;    
  //end
end

/////////////////////////////////////////////////////////////////////////////////////////

reg    [23:0]  st_shift_end_reg_1;
wire   [23:0]  st_shift_end_reg_2;
reg    [23:0]  st_shift_end_reg_3;
wire   [23:0]  st_shift_end_reg_4;
assign   st_shift_end_reg_2 = st_shift_en ?  st_shift_end_reg_1 : st_shift_end_reg ; 
always@ (*)
begin
  case ( st_shift_scnt )
     5'd0   :   st_shift_end_reg_1 =   { st_shift_end_reg[ 15+8:  0]         } ;
     5'd1   :   st_shift_end_reg_1 =   { st_shift_end_reg[ 14+8:  0] , 1'd0  } ;
     5'd2   :   st_shift_end_reg_1 =   { st_shift_end_reg[ 13+8:  0] , 2'd0  } ;
     5'd3   :   st_shift_end_reg_1 =   { st_shift_end_reg[ 12+8:  0] , 3'd0  } ;
     5'd4   :   st_shift_end_reg_1 =   { st_shift_end_reg[ 11+8:  0] , 4'd0  } ;
     5'd5   :   st_shift_end_reg_1 =   { st_shift_end_reg[ 10+8:  0] , 5'd0  } ;
     5'd6   :   st_shift_end_reg_1 =   { st_shift_end_reg[  9+8:  0] , 6'd0  } ;
     5'd7   :   st_shift_end_reg_1 =   { st_shift_end_reg[  8+8:  0] , 7'd0  } ;
     5'd8   :   st_shift_end_reg_1 =   { st_shift_end_reg[  7+8:  0] , 8'd0  } ;
     5'd9   :   st_shift_end_reg_1 =   { st_shift_end_reg[  6+8:  0] , 9'd0  } ;
     5'd10  :   st_shift_end_reg_1 =   { st_shift_end_reg[  5+8:  0] ,10'd0  } ;
     5'd11  :   st_shift_end_reg_1 =   { st_shift_end_reg[  4+8:  0] ,11'd0  } ;
     5'd12  :   st_shift_end_reg_1 =   { st_shift_end_reg[  3+8:  0] ,12'd0  } ;
     5'd13  :   st_shift_end_reg_1 =   { st_shift_end_reg[  2+8:  0] ,13'd0  } ;
     5'd14  :   st_shift_end_reg_1 =   { st_shift_end_reg[  1+8:  0] ,14'd0  } ;
     5'd15  :   st_shift_end_reg_1 =   { st_shift_end_reg[  0+8:  0] ,15'd0  } ;
     5'd16  :   st_shift_end_reg_1 =   { st_shift_end_reg[    7:  0] ,16'd0  } ;
     6'd17  :   st_shift_end_reg_1 =   { st_shift_end_reg[    6:  0] ,17'd0  } ;
     6'd18  :   st_shift_end_reg_1 =   { st_shift_end_reg[    5:  0] ,18'd0  } ;
     6'd19  :   st_shift_end_reg_1 =   { st_shift_end_reg[    4:  0] ,19'd0  } ;
     6'd20  :   st_shift_end_reg_1 =   { st_shift_end_reg[    3:  0] ,20'd0  } ;
     6'd21  :   st_shift_end_reg_1 =   { st_shift_end_reg[    2:  0] ,21'd0  } ;
     6'd22  :   st_shift_end_reg_1 =   { st_shift_end_reg[    1:  0] ,22'd0  } ;
     6'd23  :   st_shift_end_reg_1 =   { st_shift_end_reg[        0] ,23'd0  } ;
     6'd24  :   st_shift_end_reg_1 =   {                              23'd0  } ; 
     default :  st_shift_end_reg_1 =   {                              23'd0  } ;
     endcase
end
always@ (*)
begin
   case ( st_shift_ccnt_wire )
     5'd0   :   st_shift_end_reg_3 =   {                               {8{st_rx_end}} , 8'd0 ,8'd0 } ;
     5'd1   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8     ],{8{st_rx_end}} , 7'd0 ,8'd0 } ;
     5'd2   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:14+8],{8{st_rx_end}} , 6'd0 ,8'd0 } ;
     5'd3   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:13+8],{8{st_rx_end}} , 5'd0 ,8'd0 } ;
     5'd4   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:12+8],{8{st_rx_end}} , 4'd0 ,8'd0 } ;
     5'd5   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:11+8],{8{st_rx_end}} , 3'd0 ,8'd0 } ;
     5'd6   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:10+8],{8{st_rx_end}} , 2'd0 ,8'd0 } ;
     5'd7   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 9+8],{8{st_rx_end}} , 1'd0 ,8'd0 } ;
     5'd8   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 8+8],{8{st_rx_end}}        ,8'd0 } ;
     5'd9   :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 7+8],{8{st_rx_end}}        ,7'd0  } ;
     5'd10  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 6+8],{8{st_rx_end}}        ,6'd0  } ;
     5'd11  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 5+8],{8{st_rx_end}}        ,5'd0  } ;
     5'd12  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 4+8],{8{st_rx_end}}        ,4'd0  } ;
     5'd13  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 3+8],{8{st_rx_end}}        ,3'd0  } ;
     5'd14  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 2+8],{8{st_rx_end}}        ,2'd0  } ;
     5'd15  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8: 1+8],{8{st_rx_end}}        ,1'd0  } ;
     5'd16  :   st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:   8],{8{st_rx_end}}               } ;
     default :  st_shift_end_reg_3 =   { st_shift_end_reg_2[15+8:   8],{8{st_rx_end}}               } ;
     endcase
end
assign  st_shift_end_reg_4  =    st_rx_valid&&st_rx_ready  ?   st_shift_end_reg_3  :  st_shift_end_reg_2 ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     st_shift_end_reg   <=  24'd0 ;
  end
  else if (st_rx_start) begin 
     st_shift_end_reg   <=  {8'h00,8'h00,8'h00} ;
  end
  else if (fir_r_idle_st) begin
     st_shift_end_reg  <=    'd0 ;
  end
  else if (  (st_rx_valid&&st_rx_ready) || (st_shift_en)  ) begin
     st_shift_end_reg   <=   st_shift_end_reg_4 ;    
  end
  //else if ( (st_rx_valid&&st_rx_ready) && (st_shift_en)  ) begin
  //   st_shift_start_reg  <=    st_shift_start_reg_3 ;         
  //end
  //else if (st_shift_en) begin
  //   //st_shift_reg  <=   ( st_shift_reg<<st_shift_scnt ) ;
  //   st_shift_start_reg  <=    st_shift_start_reg_1 ;
  //end
  //else if ( st_rx_valid&&st_rx_ready ) begin
  //   st_shift_start_reg  <=    st_shift_start_reg_3 ;    
  //end
end


 */





/////////////////////////////////////////////////////////////////////////////////////

reg      st_shift_full_flag  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
        st_shift_full_flag <= 1'd0  ;      
  end
  else if (st_shift_ccnt>6'd24) begin
        /* synthesis translate_off */         
	$display("%m   Error    buffer is full !!!!!  cnt is   %d     fir_rx_cstate  is %h  \n   ",  st_shift_ccnt,  fir_rx_cstate  );           
        /* synthesis translate_on */
        st_shift_full_flag <= 1'd1  ;
  end
  else begin
        st_shift_full_flag <= 1'd0  ;        
  end
end

/* synthesis translate_off */

reg   [15:0]  byte_wcnt_all  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     byte_wcnt_all   <=  16'd0 ;
  end
  else if (st_rx_start) begin
     byte_wcnt_all   <=  16'd8 - st_rx_offset ;
  end
  else if ( st_rx_valid && st_rx_ready  ) begin 
     byte_wcnt_all   <= byte_wcnt_all +  16'd8 - st_rx_empty ;     
  end
end

reg   [15:0]  byte_rcnt_all  ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     byte_rcnt_all   <=  16'd0 ;
  end
  else if (st_rx_start) begin
     byte_rcnt_all   <=  16'd0 ;
  end
  else if ( st_shift_en   ) begin 
     byte_rcnt_all   <= byte_rcnt_all +  st_shift_scnt ;     
  end
end


//reg     [15:0]   byte_rcnt_all_add ;
//always@ ( negedge rst_n  or posedge clk)
//begin
//  if (~rst_n) begin
//     byte_rcnt_all_add   <=  16'd0 ;
//  end
//  else if ( st_shift_en   ) begin 
//     byte_rcnt_all_add   <= byte_rcnt_all +  tb.wrapper_filter_rx_top.filter_rx_top.filter_rx_fsm.st_rx_cnt_reg[15:0]   ;     
//  end
//end





/* synthesis translate_on */







endmodule



