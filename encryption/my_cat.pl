#######!/usr/bin/perl

use strict;
use warnings;

my @linelist = '' ;

`cat temp.v  > all.v `;

open(FILE,"filelist.vc")||die"cannot open the file: $!\n";
while (<FILE>){
    ## @linelist = split(/\.v/,$_);
     @linelist = $_;
     chomp  @linelist;          
     print "@linelist\n";     
     ##@linelist = join "","@linelist",".v";
     ##print "@linelist";
    `cat  "@linelist"   >> all.v` ;
    `cat temp.v  >> all.v `
 }
 close FILE;



##print "$randomString\n";
