#!/usr/bin/perl

use Cwd;
use File::Basename;

open(IN, '<orb2mxd.xsl') or die "$!";
open(OUT, '>abs/orb2mxd.xsl') or die "$!";

my $here = getcwd();
$here =~ s|^/var/www/||;
my $absurl = "http://urbit.cvt.dk/$here/abs/";
print STDERR "set absurl=$absurl\n";

while(<IN>) {
  s/\>\</\>$absurl\</ if /variable name="baseurl"/;
  print OUT;
}
close(IN); close(OUT);

system ("rsync -vu --existing *.xsl *.xml abs/");
