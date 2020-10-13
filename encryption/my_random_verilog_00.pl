#######!/usr/bin/perl

use strict;
use warnings;

my $maxLenth=1024;
my @dataSource = ('O',0,'o','i','I','L','l');
my $randomString = join '', map { $dataSource[int rand @dataSource] } 0..($maxLenth-1);
$randomString = join '', 'O',  $randomString ;

print "$randomString\n";
