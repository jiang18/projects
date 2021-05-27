# aipl2plink.pl

use strict;
use warnings;

@ARGV == 2 or die "Two arguments needed: aipl-geno-folder and  plink-file-prefix\n";
my ($aipl, $plink) = @ARGV;

open IN,"$aipl/genotypes.imputed" or die "Could not open $aipl/genotypes.imputed: $!\n";
open OUT,">$plink.ped";
while(<IN>)
{
        chomp;
        my @c = split /\s+/;
        my @g = split //,$c[-1];
        print OUT "0 $c[1] 0 0 2 0";
        
	$c[-1] =~ s/2/ 22/g;
	$c[-1] =~ s/1/ 12/g;
	$c[-1] =~ s/0/ 11/g;
        print OUT $c[-1],"\n";
}
close IN;
close OUT;

open IN,"$aipl/chromosome.data" or die "Could not open $aipl/chromosome.data: $!\n";
open OUT,">$plink.map";
$_=<IN>;
while(<IN>)
{
        chomp;
        my @c = split /\s+/;
        print OUT "$c[1]\t$c[0]\t0\t$c[4]\n";
}
close IN;
close OUT;
