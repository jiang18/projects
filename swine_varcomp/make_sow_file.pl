use strict;
use warnings;

@ARGV == 3 or die "3 arguements needed: fam-file, ped-file, out-file\n";

my ($fam, $ped, $out) = @ARGV;

my %geno;
open IN, $fam;
while(<IN>) {
	chomp;
	my @c = split /\s+/;
	$geno{$c[1]} = 0;
}
close IN;

open OUT,">$out";
print OUT "id sow\n";

open IN, $ped;
while(<IN>) {
	chomp;
	my @c = split /\s+/;

	if((defined $geno{$c[1]}) and (defined $geno{$c[3]})) {
		print OUT $c[1]," ",$c[3],"\n";
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

print "There are ", scalar(keys %sow), " sows involved in genotypes\n";

open OUT,">keep.txt";
my $geno_sow; 
for (sort {$a <=> $b} keys %sow) {
	print OUT "0 $_\n";
	if(defined $geno{$_}) {
		$geno_sow ++;
	}
}
close OUT;
print "There are $geno_sow genotyped sows\n";

