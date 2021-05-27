use strict;
use warnings;

@ARGV == 2 or die "bim file and output file needed\n";

my ($bim,$out) = @ARGV;

open IN,$bim;
open OUT,">$out";
print OUT "SNP,group\n";
while(<IN>)
{
	my @c = split /\s+/;
	print OUT "$c[1],1\n";
}
close IN;
close OUT;


