use strict;
use warnings;

@ARGV == 3 or die "3 arguements needed: sows-filename, findhap-pedigree-filename, out-filename\n";

my ($fam, $ped, $out) = @ARGV;

my %geno;
open IN, $fam;
while(<IN>) {
	chomp;
	my @c = split /\s+/;
	$geno{$c[0]} = 0;
}
close IN;

open OUT,">$out";
print OUT "id litter\n";

open IN, $ped;
while(<IN>) {
	chomp;
	my @c = split /\s+/;

	if( defined $geno{$c[1]} ) {
		print OUT $c[1]," ",$c[3].'-'.$c[4],"\n";
	}
}
close IN;
close OUT;

my %sow;
open IN, $out;
$_=<IN>;
while(<IN>){
	chomp;
	my @c = split / /;
	$sow{$c[1]} ++;
}
close IN;

print "There are ", scalar(keys %sow), " litters involved\n";

