#!/usr/bin/env perl

use strict;
use warnings;

use IO::File;
use IO::Dir;
use List::Compare;
use Getopt::Long;
use Data::Dumper;

# My modules
use lib qw{/home/soh.i/benchmark/lib};
use Benchmark;

my %opts = ();
my $help = undef;
GetOptions(\%opts,
           'help|h' => \$help,
           'answer=s',
           'predicted=s',
          ) or die _usage();
if ($help) {
    print _usage();
    exit;
}
if (!$opts{answer} || !$opts{predicted}) {
    print "Require the answer set and/or predicted set";
    exit;
}

my $afh = IO::File->new($opts{answer}) or die;
my $bfh = IO::File->new($opts{predicted}) or die;

my @darned_collected;
while (my $darned_entory = $afh->getline) {
    next if $. == 1;
    my ($chr, $pos)  = (split /\t/, $darned_entory)[0,1];
    push @darned_collected, "$chr:$pos";
}

my @data_collected;
while (my $data_entory = $bfh->getline) {
    next if $. == 1;
    my ($chr, $pos, $strand, $from, $to)  = (split /\,/, $data_entory)[0,1];
    $chr =~ s/^chr//;
    push @data_collected, "$chr:$pos";
}

my $recall = Benchmark::get_measure(predicted=>\@data_collected, answerset=>\@darned_collected, flag=>"all");
print $recall;


sub _usage {
    return <<EOF;
Usage:
    perl $0 --answer <in.tsv> --predicted <in.tsv>

Options:
    --answer [required]
    --predicted [required]
    --help Show help message

EOF
}

