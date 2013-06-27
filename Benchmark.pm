package Benchmark;

use strict;
use warnings;
use List::Compare;
use Carp;
use Data::Dumper;

sub get_measure {
    my %args = (
                candidate => undef,
                answerset => undef,
                flag      => undef,
                @_,
               );
    
    # type checking 
    if (ref $args{candidate} ne 'ARRAY' && ref $args{answerset} ne 'ARRAY') {
        carp "Error: given data are not ARRAY";
    }
    # flag checking
    if (!$args{flag} eq 'precision' || !$args{flag} eq 'recall' || !$args{flag} eq 'all') {
        carp "Error: given a flag is not accepted";
    }
    # NA checking
    my $ans_data_count       = scalar @{ $args{answerset} };
    my $candidate_data_count = scalar @{ $args{candidate} };
        
    if ($ans_data_count != 0 && $candidate_data_count != 0) {
        my $lc = List::Compare->new($args{candidate}, $args{answerset});
        my $intersection = $lc->get_intersection();
        
        if ($args{flag} eq 'precision') {
            my $recall = $intersection/$candidate_data_count;
            return _formated($recall);
        }
        elsif ($args{flag} eq 'recall') {
            my $precision = $intersection/$ans_data_count;
            return _formated($precision);
        }
        elsif ($args{flag} eq 'all') {
            my $r = _formated($intersection/$candidate_data_count);
            my $p = _formated($intersection/$ans_data_count);
            return "$r, $p";
        } else {
            return;
        }
    }
}

sub _formated {
    my $p = shift;
    return sprintf "%2.4f", $p;
}

1;

