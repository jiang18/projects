# aipl2plink.pl

use strict;
use warnings;

@ARGV == 2 or die "Two arguments needed: aipl-geno-folder and  plink-file-prefix\n";
my ($aipl, $plink) = @ARGV;

our %sex = ('M' => 1, 'F' => 2);

my %pedigree;
open IN,"$aipl/pedigree.file" or die "Could not open $aipl/pedigree.file: $!\n";
while(<IN>)
{
        chomp;
        my @c = split /\s+/;
	$c[2] = 0 if($c[2] < 0);
	$c[3] = 0 if($c[3] < 0);
	$pedigree{$c[1]} = join(" ", @c[2,3], $sex{$c[0]});
}
close IN;
print "Pedigree has been parsed.\n";

open IN,"$aipl/genotypes.imputed" or die "Could not open $aipl/genotypes.imputed: $!\n";
open OUT,">$plink.ped";
while(<IN>)
{
        chomp;
        my @c = split /\s+/;
	my $anim;
	if($c[0] eq '') {
		$anim = $c[1];
	} else {
		$anim = $c[0];
	}
	if(defined $pedigree{$anim}) {
        	print OUT "0 $anim ", $pedigree{$anim}, " 0";
	} else {
		print "$anim NOT in pedigree.file. Missing parents & sex.\n";
		print OUT "0 $anim 0 0 0 0";
	}
        
	$c[-1] =~ s/2/ 22/g;
	$c[-1] =~ s/1/ 12/g;
	$c[-1] =~ s/0/ 11/g;
	$c[-1] =~ s/5/ 00/g; # no call
        print OUT $c[-1],"\n";
}
close IN;
close OUT;
print ".ped file has been generated\n";

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
print ".map file has been generated\n";
