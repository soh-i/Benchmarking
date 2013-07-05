#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use Math::Random::MT;
use IO::File;

my $file = shift or die "perl $0 data.csv Num. of sampling";
my $N    = shift || 1000; # Set sampling count, default value is 1000

my $fh = IO::File->new($file) or die;
my $selected = [];
my $count = 0;
while (my $line = $fh->getline()) {
    chomp $line;
    my ($chr, $pos) = (split /\,/, $line)[0,1];
    push $selected, "$chr,$pos,";
    $count++;
}

for (my $i=0; $i<$N; $i++) {
    print $selected->[ int(Math::Random::MT::rand($count)) ], "\n";
}
