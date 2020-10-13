

######description
#not support parameter [WIDTH:1]
#not support bigendian
######
use strict;
use warnings;

#delete all comments;
##open my $file,"<","./filter/filter_tlp_reg_gen_reg.v";
##open my $file,"<","./filter/fir_shift_reg_192.v";
open my $file,"<","all.v";

$/=undef;#分隔符默认是\n，设置为undef，是想把整个段落作为一行。
my $file_without_comments;#文件内容清理后的整个段落，赋值进一个标量
while(<$file>){
    s/\/\/.*?\n/\n/g;#删除//注释部分
    ##s/\/\*.*?\*\///g; #删除/**/注释部分
    s/\s+/ /g;       #删除2个空白符
    s/\n+\s*\n+/\n/g; #删除多个空行
    $file_without_comments = $_;
}
    ##$file_without_comments =~ s/\/\*.*?\*\///g;
    $file_without_comments =~ s/;/;\r\n/g;   
    $file_without_comments =~ s/\bbegin\b/begin\r\n/g;   
    $file_without_comments =~ s/\bend\b/end\r\n/g; 
    $file_without_comments =~ s/\bendmodule\b/endmodule\r\n/g; 
     
    ##s/\/\*.*?\*\///g; #删除/**/注释部分
    ##$file_without_comments = $_;

##print "$file_without_comments";
open(DATA2,">my_dummy_all.v");
print  DATA2 $file_without_comments  ;
close(DATA2);

open(DATA3,">my_dummy_signal.txt");
##print  DATA3 $file_without_comments  ;


#####################
#print "/*\n";
#print "*moduename \tis\t $modulename\n";#得到module名称
#print "*inputname \tis\t @inputname\n";#得到input port名称
#print "*outputname \tis\t @outputname\n";#得到output port名称
#print "*inoutname \tis\t @inoutname\n";#得到inout port名称
#my @inputname_width;#得到input port的width
#my @outputname_width;#得到output port的width
#my @inoutname_width;#得到inout port的width
#print "*/\n";

my @file = split /;/,$file_without_comments;#以;作为分隔符，把段落分成多个变量，形成一个数组。
my @file_context;

my $modulename;
my @inputname;
my @outputname;
my @inoutname;

my @regname;
my @wirename;
my @paraname;


my @inputname_width;
my @outputname_width;
my @inoutname_width;

my @regname_width;
my @wirename_width;
my @paraname_width;




my $maxLenth=32;
my @dataSource = ('O',0,'o','i','I','L','l');

my @my_signal ;

foreach (@file){
    if(m/module\s+(\S+)\s*\(/){
        $modulename = $1;#得到module名称
         @my_signal = $modulename  ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "module @my_signal  $randomString  \r\n"; 
    }
    if(m/\binput\s*\[*\s*([0-9]*)\s*:*\s*([0-9]*)\s*\]*\s*(.*?)$/){
        my $input_leftwidth = $1;
        my $input_rightwidth = $2;
        unless($1){$input_leftwidth=0;}#input有时候没有[31:0]的字段，赋值左宽度为初始值0
        unless($2){$input_rightwidth=0;}#input有时候没有[31:0]的字段，赋值右宽度为初始值0
        my @input_1 = split /,/,$3;#所有的input name；并以,作为分隔符。
        foreach (@input_1){
            s/input//;
            s/\s//;
            s/\n//;
            push @inputname,$_;
            @my_signal = $_ ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "@my_signal  $randomString  \r\n"; 
            push @inputname_width,abs($input_leftwidth-$input_rightwidth)+1;
            if(abs($input_leftwidth-$input_rightwidth) == ($input_leftwidth-$input_rightwidth)) {
                my $bigendian = 1;
            }#暂时不支持bigendian，要实现，也容易。
        }
    }
    if(m/\boutput\s*\[*\s*([0-9]*)\s*:*\s*([0-9]*)\s*\]*\s*(.*?)$/){
        my $output_leftwidth = $1;
        my $output_rightwidth = $2;
        unless($1){$output_leftwidth=0;}
        unless($2){$output_rightwidth=0;}
        my @output_1 = split /,/,$3;
        foreach (@output_1){
            s/output//;
            s/\s//;
            s/\n//;
            s/=.*//;
            push @outputname,$_;
            @my_signal = $_ ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "@my_signal  $randomString  \r\n"; 
            push @outputname_width,abs($output_leftwidth-$output_rightwidth)+1;
        }
    }
    if(m/\binout\s*\[*\s*([0-9]*)\s*:*\s*([0-9]*)\s*\]*\s*(.*?)$/){
        my $inout_leftwidth = $1;
        my $inout_rightwidth = $2;
        unless($1){$inout_leftwidth=0;}
        unless($2){$inout_rightwidth=0;}
        my @inout_1 = split /,/,$3;
        foreach (@inout_1){
            s/inout//;
            s/\s//;
            s/\n//;
            s/=.*//;
            push @inoutname,$_;
            @my_signal = $_ ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "@my_signal  $randomString  \r\n"; 
            push @inoutname_width,abs($inout_leftwidth-$inout_rightwidth)+1;
        }
    }

  if(m/\breg\s*\[*\s*([0-9]*)\s*:*\s*([0-9]*)\s*\]*\s*(.*?)$/){
        my $reg_leftwidth = $1;
        my $reg_rightwidth = $2;
        unless($1){$reg_leftwidth=0;}
        unless($2){$reg_rightwidth=0;}
        my @reg_1 = split /,/,$3;
        foreach (@reg_1){
            s/\breg\b//;
            s/\s//;
            s/\n//;
            s/=.*//;
            push @regname,$_;
            @my_signal = $_ ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "@my_signal  $randomString  \r\n"; 
            push @regname_width,abs($reg_leftwidth-$reg_rightwidth)+1;
        }
    }


  if(m/\bwire\s*\[*\s*([0-9]*)\s*:*\s*([0-9]*)\s*\]*\s*(.*?)$/){
        my $wire_leftwidth = $1;
        my $wire_rightwidth = $2;
        unless($1){$wire_leftwidth=0;}
        unless($2){$wire_rightwidth=0;}
        my @wire_1 = split /,/,$3;
        foreach (@wire_1){
            s/\bwire\b//;
            s/\s//;
            s/\n//;
            s/=.*//;
            push @wirename,$_;
            @my_signal = $_ ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "@my_signal  $randomString  \r\n"; 
            push @wirename_width,abs($wire_leftwidth-$wire_rightwidth)+1;
        }
    }


  
  if(m/\bparameter\s*\[*\s*([0-9]*)\s*:*\s*([0-9]*)\s*\]*\s*(.*?)$/){
        my $para_leftwidth = $1;
        my $para_rightwidth = $2;
        unless($1){$para_leftwidth=0;}
        unless($2){$para_rightwidth=0;}
        my @para_1 = split /,/,$3;
        foreach (@para_1){
            s/parameter\b//;
            s/\s//;
            s/\n//;
            s/=.*//;
            push @paraname,$_;
            @my_signal = $_ ;
            my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
            $randomString = join '', 'O',  $randomString ;
            $file_without_comments =~ s/\b@my_signal\b/$randomString/g;     
            print DATA3 "@my_signal  $randomString  \r\n"; 
            push @paraname_width,abs($para_leftwidth-$para_rightwidth)+1;
        }
    }



}


 my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_00\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";    
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_01\b/$randomString/g; 
 print DATA3 "$randomString  \r\n";        
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_02\b/$randomString/g;     
 print DATA3 "$randomString  \r\n";    
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_03\b/$randomString/g;     
 print DATA3 "$randomString  \r\n";    
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_04\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";      
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_05\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_06\b/$randomString/g;     
 print DATA3 "$randomString  \r\n";    
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_07\b/$randomString/g;    
 print DATA3 "$randomString  \r\n";     
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_08\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";      
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_09\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_10\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";      
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_11\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_12\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";      
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_13\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_14\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_15\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_16\b/$randomString/g;
 print DATA3 "$randomString  \r\n";         
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_17\b/$randomString/g; 
 print DATA3 "$randomString  \r\n";        
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_18\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";      
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_19\b/$randomString/g; 
 print DATA3 "$randomString  \r\n";        
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_20\b/$randomString/g; 
 print DATA3 "$randomString  \r\n";        
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_21\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";      
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_22\b/$randomString/g; 
 print DATA3 "$randomString  \r\n";        
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_23\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_24\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_25\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_26\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_27\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";          
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_28\b/$randomString/g;   
 print DATA3 "$randomString  \r\n";         
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_29\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";          
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_30\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";          
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bsq_cut_rx_fsm_31\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bgen_cut_start\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/gen_fivetuplematch\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bparse_search_top\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";       
 $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
 $randomString = join '', 'O',  $randomString ;
 $file_without_comments =~ s/\bu_parse_search\b/$randomString/g;  
 print DATA3 "$randomString  \r\n";  



close(DATA3);

##
##my @linelist = '' ;
##
##my $maxLenth=32;
##my @dataSource = ('O',0,'o','i','I','L','l');
##
##open(FILE,"my_dummy_signal.txt")||die"cannot open the file: $!\n";
##while(<FILE>){
##  @linelist = $_;
##  chomp  @linelist;             
##  my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
##  $randomString = join '', 'O',  $randomString ;
##  print "@linelist\n ";    
##  print "$randomString\n ";       
##  ##print  " $randomString    "  ;    
##  $file_without_comments =~ s/@linelist\b/$randomString/g;     
##}
##
##
open(DATA4,">my_dummy_final.v");
print  DATA4 $file_without_comments  ;
close(DATA4);




