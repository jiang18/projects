use strict;
use warnings;

@ARGV == 2 or die "Two arguments needed: bim-filename and output-filename\n";

my ($bim,$out) = @ARGV;

open IN,$bim;
open OUT,">$out";
print OUT "SNP,CHR\n";
while(<IN>)
{
	my @c = split /\s+/;
	last if($c[0] == 19);
	print OUT "$c[1],$c[0]\n";
}
close IN;
close OUT;


