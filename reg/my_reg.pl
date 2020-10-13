#######!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);


my $modulename;
my $base_addr;
##my @reg_signal   = '';
my @reg_type     = '';
my @reg_addr     = '';
my @reg_name     = '';
my @reg_value    = '';
my @reg_width    = '';
my $reg_cnt      = 0 ;
my $signal_cnt   = 0 ;

my @sub_name     = '';
my @sub_addr     = '';
my $sub_cnt      = 0 ;


my @linelist   = '';

##`cat temp.v  > all.v `;
##open(DATA2,">my_reg.v");

open(FILE,"reg.txt")||die"cannot open the file: $!\n";
while (<FILE>){
    ## @linelist = split(/\.v/,$_);
     @linelist = $_;
     chomp  @linelist;          
     ##print "@linelist\n";     
     ##print  DATA2  "@linelist";    
    
     if (m/ENDALL/)  {
        open(DATA2,">CFG_MUX.v");      
        print  DATA2  "module CFG_MUX ( /*AUTOARG*/ );\n";    
        print  DATA2  "input         clk;\n";
        print  DATA2  "input         rst_n;\n";
        print  DATA2  "input         reg_wr_en;\n";
        print  DATA2  "input  [63:0] reg_addr;\n";
        print  DATA2  "output [31:0] reg_rd_data;\n";
        print  DATA2  "output [11:0] sub_reg_addr;\n";

        for ($signal_cnt=1;$signal_cnt<=$sub_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "input  [31:0] reg_$sub_name[$signal_cnt]_rd_data;\n";
        }

        for ($signal_cnt=1;$signal_cnt<=$sub_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "output        reg_$sub_name[$signal_cnt]_wr_en;\n";        
        }

        print  DATA2  "/////////////////////////////////////////////////////\n";      
        print  DATA2  "reg [31:0] reg_rd_data;\n";
 
        for ($signal_cnt=1;$signal_cnt<=$sub_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "assign  reg_$sub_name[$signal_cnt]_wr_en =  reg_wr_en&&(reg_addr[63:13]==$sub_addr[$signal_cnt]);\n"; 
        }
        print  DATA2  "assign  sub_reg_addr =  reg_addr[11:0];\n"; 
        
        print  DATA2  "always @(posedge clk or negedge rst_n)\nbegin\n    if (~rst_n) begin\n       reg_rd_data<='d0;\n    end\n    else  begin\n        case(reg_addr[63:13]) begin\n";
        for ($signal_cnt=1;$signal_cnt<$sub_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "        $sub_addr[$signal_cnt] : reg_rd_data<=reg_$sub_name[$signal_cnt]_rd_data;\n";
        }
        print  DATA2  "        default : reg_rd_data<=reg_$sub_name[$signal_cnt]_rd_data;\n        endcase\n    end\nend\n";

         
        print  DATA2  "endmodule\n";                      
        close DATA2;
        
        open(DATA2,">CFG_TOP.v");      
        print  DATA2  "module CFG_TOP ( /*AUTOARG*/ );\n";    
        print  DATA2  "/*AUTOINPUT*/\n";    
        print  DATA2  "/*AUTOOUTPUT*/\n";    
        print  DATA2  "/*AUTOWIRE*/\n";    
        print  DATA2  "CFG_MUX u_CFG_MUX(/*AUTOINST*/);\n";    
        for ($signal_cnt=1;$signal_cnt<=$sub_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "$sub_name[$signal_cnt] u_$sub_name[$signal_cnt](/*AUTOINST*/)\n";
        }
        print  DATA2  "endmodule\n";                      
        close DATA2;
 
        for ($signal_cnt=1;$signal_cnt<=$sub_cnt;$signal_cnt=$signal_cnt+1) {
        `emacs   --batch   $sub_name[$signal_cnt].v      -f verilog-auto     -f save-buffer`;                
        }
        `emacs   --batch   CFG_MUX.v      -f verilog-auto     -f save-buffer`;        
        `emacs   --batch   CFG_TOP.v      -f verilog-auto     -f save-buffer`;        
                
     }
     elsif (m/ENDMFUNC/)  {
        print  "module name is  $modulename  and base_addr is $base_addr  ;\n";  
        print  DATA2  "module $modulename ( /*AUTOARG*/ );\n";    
        print  DATA2  "input         clk;\n";
        print  DATA2  "input         rst_n;\n";
        print  DATA2  "input         reg_${modulename}_wr_en;\n";
        print  DATA2  "input  [11:0] sub_reg_addr;\n";
        print  DATA2  "input  [31:0] reg_wr_data;\n";
##        print  DATA2  "input         reg_rd_en;\n";
        print  DATA2  "output [31:0] reg_${modulename}_rd_data;\n";
        for ($signal_cnt=1;$signal_cnt<=$reg_cnt;$signal_cnt=$signal_cnt+1) {
        if ($reg_type[$signal_cnt]=~ m/WR/) {        
        if ($reg_width[$signal_cnt]==0) {
        print  DATA2  "output           $reg_name[$signal_cnt];\n";}
        else {
        print  DATA2  "output  [$reg_width[$signal_cnt]:0]   $reg_name[$signal_cnt];\n";}
        }
        else {
        if ($reg_width[$signal_cnt]==0) {
        print  DATA2  "input            $reg_name[$signal_cnt];\n";}
        else {
        print  DATA2  "input   [$reg_width[$signal_cnt]:0]   $reg_name[$signal_cnt];\n";}
        }    
        }

        print  DATA2  "/////////////////////////////////////////////////////\n";
        print  DATA2  "reg  [31:0]   reg_${modulename}_rd_data;\n";

        for ($signal_cnt=1;$signal_cnt<=$reg_cnt;$signal_cnt=$signal_cnt+1) {
        if ($reg_width[$signal_cnt]==0) {
        print  DATA2  "reg           reg_$reg_addr[$signal_cnt];\n";
        }
        else {
        print  DATA2  "reg  [$reg_width[$signal_cnt]:0]   reg_$reg_addr[$signal_cnt];\n";
        }    
        }

        for ($signal_cnt=1;$signal_cnt<=$reg_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "wire          wr_$reg_addr[$signal_cnt]_en;\n";
        ##print  DATA2  "wire          rd_$reg_addr[$signal_cnt]_en;\n";
        }

        for ($signal_cnt=1;$signal_cnt<=$reg_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "assign          wr_$reg_addr[$signal_cnt]_en=(reg_${modulename}_wr_en&&(sub_reg_addr==12'h$reg_addr[$signal_cnt]));\n";
        ##print  DATA2  "assign          rd_$reg_addr[$signal_cnt]_en=(reg_rd_en&&(reg_addr==12'h$reg_addr[$signal_cnt]));\n";
        }

        print  DATA2  "/////////////////////////////////////////////////////\n"; 
        for ($signal_cnt=1;$signal_cnt<=$reg_cnt;$signal_cnt=$signal_cnt+1) {
        ##print "$reg_type[$signal_cnt]\n";
        if ($reg_type[$signal_cnt]=~ m/WR/) {
        print  DATA2  "always @(posedge clk or negedge rst_n)\nbegin\n    if (~rst_n) begin\n       reg_$reg_addr[$signal_cnt]<=$reg_value[$signal_cnt];\n    end\n    else if (wr_$reg_addr[$signal_cnt]_en) begin\n       reg_$reg_addr[$signal_cnt]<=reg_wr_data;\n    end\nend\n";
        print  DATA2  "assign  $reg_name[$signal_cnt]=reg_$reg_addr[$signal_cnt];\n";}
        else{
        print  DATA2  "always @(posedge clk or negedge rst_n)\nbegin\n    if (~rst_n) begin\n       reg_$reg_addr[$signal_cnt]<=$reg_value[$signal_cnt];\n    end\n    else  begin\n       reg_$reg_addr[$signal_cnt]<=$reg_name[$signal_cnt];\n    end\nend\n";}
        }

        print  DATA2  "always @( * )\nbegin\n    case(sub_reg_addr) begin\n";
        for ($signal_cnt=1;$signal_cnt<$reg_cnt;$signal_cnt=$signal_cnt+1) {
        print  DATA2  "    12'h$reg_addr[$signal_cnt] : reg_${modulename}_rd_data=reg_$reg_addr[$signal_cnt];\n";
        }
        print  DATA2  "    default : reg_${modulename}_rd_data=reg_$reg_addr[$signal_cnt];\n    endcase\nend\n";
        
        print  DATA2  "endmodule\n";             
        ##
        ##           
        ##print "@linelist\n";  
        close DATA2;
                            
     }
     elsif(m/MFUNC.*/){
        ##print "@linelist\n";
        my @output_1 = split (/ /,$linelist[0]);
        $modulename = $output_1[0] ;
        $base_addr  = $output_1[1] ;
        ##print  "module name is $output_1[0]  and base_addr is $output_1[1] ;\n";  
        ##print "@linelist";      
        open(DATA2,">$modulename.v");      
        $reg_cnt = 0 ;
        @reg_type     = '';
        @reg_addr     = '';
        @reg_name     = '';
        @reg_value    = '';
        @reg_width    = '';
        push @sub_addr,"$output_1[1]";                
        push @sub_name,"$output_1[0]";
        $sub_cnt = $sub_cnt + 1 ;                                
     }
     elsif (m/\b(WR |RO )\b/) {
        ##print "@linelist\n";
        ##push @reg_signal,"$linelist[0];";
        $reg_cnt = $reg_cnt + 1;
        my @output_1 = split (/ /,$linelist[0]);
        push @reg_type,"$output_1[0]";
        push @reg_addr,"$output_1[1]";                
        push @reg_name,"$output_1[2]";
        $output_1[3] = $output_1[3] -1 ;
        push @reg_width,"$output_1[3]";
        push @reg_value,"$output_1[4]";
        
        ##print "@reg_signal\n";                    
     }
     else {
        print "IDLE\n";                            
     }
 
 }
 close FILE;



##print "$randomString\n";
