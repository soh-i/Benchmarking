#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use Carp;
use IO::File;
use IO::Dir;

if (scalar @ARGV != 2) {
    die "perl $0 <AG_file> <nonAG_file>\n";
}

my $AG_file    = shift;
my $nonAG_file = shift;

# Calculation
my $AG_count    = _count_data($AG_file);
my $nonAG_count = _count_data($nonAG_file);

say $AG_count;
say $nonAG_count;
say _AG_richness(AG => $AG_count, nonAG => $nonAG_count);

sub _count_data {
    my $file = shift;
    
    my $io = IO::File->new($file, 'r') or croak "Error: Cant read file:$!";
    my $entory_count = 0;
    while (my $line = $io->getline()) {
        next if __LINE__ == 1;
        $entory_count++;
    }
    $io->close();
    return $entory_count;
}

sub _AG_richness {
    my %args = (
                AG    => undef,
                nonAG => undef,
                @_,
               );
    
    if ($args{AG} != 0 && $args{nonAG} != 0) {
        my $richness = $args{AG} / ($args{AG} + $args{nonAG});
        return scalar $richness;
    } else { 
        croak "Error: AG and/or nonAG is empty";
    }
}
