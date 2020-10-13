#######!/usr/bin/perl

use strict;
use warnings;

my $maxLenth=1024;
my @dataSource = (0..9,'a'..'z','A'..'Z','~','!','@','#','$','%','^','&',,'*','-','+','_','=','(',')','{','}','[',']',':',';','"',',','.','<','>','?','/','\\','|','\'');
my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
print "$randomString\n";
