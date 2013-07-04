#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use Carp;
use IO::File;
use List::Compare qw/intersection/;

my $Peng2012      = '/home/soh.i/benchmark/data/human/answer/cat_Answerset/Peng2012_cat.csv';
my $ENCODE        = '/home/soh.i/benchmark/data/human/answer/cat_Answerset/ENCODE_cat.csv';
my $ENCODE_gm12878 = '/home/soh.i/benchmark/data/human/predict/ENCODE/ENCODE_gm12878.csv';
my $Ramaswami2012 = '/home/soh.i/benchmark/data/human/answer/cat_Answerset/Ramaswami2012.csv';
my $Ramaswami2013 = '/home/soh.i/benchmark/data/human/answer/cat_Answerset/Ramaswami2013.csv';
my $Zhu2013       = '/home/soh.i/benchmark/data/human/answer/cat_Answerset/Zhu2013.csv';

my $darned = '/home/soh.i/benchmark/data/human/answer/DARNED_hg19.csv';
my $rand = shift;

my $lc = List::Compare->new(_collect($ENCODE), _collect($rand));

#my $lc = List::Compare->new(_collect($Ramaswami2013), _collect($ENCODE));
my @inter = $lc->get_intersection();
print scalar @inter;

sub _collect {
    my $data = shift;
    
    my $fh = IO::File->new($data) or croak "Internal Error";
    my $collect = [];
    while (my $line = $fh->getline()) {
        next if __LINE__ == 1;
        chomp $line;
        my ($chr, $pos) = (split/\,/, $line)[0,1];
        push $collect, "$chr:$pos" if defined $pos && defined $chr;
    }
    return $collect;
}

