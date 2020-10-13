

######description
#not support parameter [WIDTH:1]
#not support bigendian
######
use strict;
use warnings;

#delete all comments;
open my $file,"<","./filter/filter_cut_rx_fsm.v";
$/=undef;#分隔符默认是\n，设置为undef，是想把整个段落作为一行。
my $file_without_comments;#文件内容清理后的整个段落，赋值进一个标量
while(<$file>){
    s/\/\/.*?\n/\n/g;#删除//注释部分
    s/\/\*.*?\*\///g; #删除/**/注释部分
    s/\s+/ /g;       #删除2个空白符
    s/\n+\s*\n+/\n/g; #删除多个空行
    $file_without_comments = $_;
}
    $file_without_comments =~ s/\/\*.*?\*\///g;
    $file_without_comments =~ s/;/;\n\r/g;   
    $file_without_comments =~ s/begin\b/begin\n\r/g;   
    $file_without_comments =~ s/ end\b/ end\n\r/g; 
     
    ##s/\/\*.*?\*\///g; #删除/**/注释部分
    ##$file_without_comments = $_;

##print "$file_without_comments";
open(DATA2,">my_dummy.v");
print  DATA2 $file_without_comments  ;
close(DATA2);

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

my @inputname_width;
my @outputname_width;
my @inoutname_width;
foreach (@file){
    if(m/module\s+(\S+)\s*\(/){
        $modulename = $1;#得到module名称
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
            push @inputname_width,abs($input_leftwidth-$input_rightwidth);
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
            push @outputname,$_;
            push @outputname_width,abs($output_leftwidth-$output_rightwidth);
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
            push @inoutname,$_;
            push @inoutname_width,abs($inout_leftwidth-$inout_rightwidth);
        }
    }
}
print "/*\n";
print "*moduename \tis\t $modulename\n";
print "*inputname \tis\t @inputname\n";
print "*inputname_width \tis\t @inputname_width\n";
print "*outputname \tis\t @outputname\n";
print "*outputname_width \tis\t @outputname_width\n";
print "*inoutname \tis\t @inoutname\n";
print "*inoutname_width \tis\t @inoutname_width\n";
print "*/\n";

#####Result
my @outputname_join1 = join ",", @outputname;   
my @inputname_join1 = join ",", @inputname;
my @inoutname_join1 = join ",", @inoutname;

my @outputname_join;   
my @inputname_join;
my @inoutname_join;

#module声明
print "module $modulename (\n";
if(@inoutname){
    print "@inoutname_join1,\n";
}
if(@outputname){
    print "@outputname_join1,";
}
if(@inputname){
    print "@inputname_join1);\n";
}

#inout变量声明
for (my $i=0;$i<$#inoutname + 1;$i=$i+1){
##    $inoutname_join[$i] = "inout [$inoutname_width[$i]-1:0] $inoutname[$i];\n";
  if ($inoutname_width[$i]==0) {
    $inoutname_join[$i] = "inout   $inoutname[$i];\n";    
  }
  else {
    $inoutname_join[$i] = "inout [$inoutname_width[$i]:0] $inoutname[$i];\n";
  }
}
print @inoutname_join;

#output变量声明
for (my $i=0;$i<$#outputname + 1;$i=$i+1){
##    $outputname_join[$i] = "output [$outputname_width[$i]-1:0] $outputname[$i];\n";
  if ($outputname_width[$i]==0) {
    $outputname_join[$i] = "output   $outputname[$i];\n";    
  }
  else {
    $outputname_join[$i] = "output [$outputname_width[$i]:0] $outputname[$i];\n";
  }
}
print @outputname_join;

#input变量声明
for (my $i=0;$i<$#inputname + 1;$i=$i+1){
##    $inputname_join[$i] = "input [$inputname_width[$i]-1:0] $inputname[$i];\n";
  if ($inputname_width[$i]==0) {
    $inputname_join[$i] = "input   $inputname[$i];\n";    
  }
  else {
    $inputname_join[$i] = "input [$inputname_width[$i]:0] $inputname[$i];\n";
  }
}
print @inputname_join;

#所有output信号，赋值为'b0
if(@outputname){
    print "assign { @outputname_join1 } = 'b0;\n";
}


#结束endmodule
print "endmodule\n";



