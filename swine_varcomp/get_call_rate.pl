use strict;
use warnings;

@ARGV == 2 or die "Two arguments needed: raw-geno-folder and  output-prefix\n";
my ($aipl, $out) = @ARGV;

my @snps;
open IN,"$aipl/chromosome.data" or die "Could not open $aipl/chromosome.data: $!\n";
$_=<IN>;
while(<IN>)
{
        chomp;
        my @c = split /\s+/;
        push @snps, $c[0];
}
close IN;

open IN,"$aipl/genotypes.txt" or die "Could not open $aipl/genotypes.txt: $!\n";
my @snp_call_rate = (0) x scalar(@snps);
my $num_anim = 0;
open OUT,">$out.ind_call_rate.txt";
print OUT "IID\tcallrate\n";
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
    
    my $good = 0;
    my @gg = split //,$c[-1];
    for my $i (0..$#gg) {
      if($gg[$i] =~ /0|1|2/) {
        $good++;
        $snp_call_rate[$i] ++;
      }
    }
    $num_anim ++;
    print OUT $anim,"\t",$good/@snps,"\n";
}
close IN;
close OUT;

open OUT,">$out.snp_call_rate.txt";
print OUT "SNP\tcallrate\n";
for my $i (0..$#snps) {
  print OUT $snps[$i],"\t", $snp_call_rate[$i]/$num_anim,"\n";
}
close OUT;
