module test(/*AUTOARG*/
   );


input   clk     ;
input   rst_n   ;


output    o ;

/*AUTOWIRE*/
/*AUTOREG*/






always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
       /*AUTORESET*/
    end
    else begin
        o<=1'b1;
    end
end











endmodule







