package Benchmark;

use strict;
use warnings;
use List::Compare;
use Carp;
use Data::Dumper;

sub calc_recall {
    my %args = (
                candidate => undef,
                answerset => undef,
                @_,
               );
    
    # type checking 
    if (ref $args{candidate} ne 'ARRAY' && ref $args{answerset} ne 'ARRAY') {
        die "Error: given data are not ARRAY";
    }
    
    # NA checking
    my $ans_data_count       = scalar @{ $args{answerset} };
    my $candidate_data_count = scalar @{ $args{candidate} };
    
    if ($candidate_data_count != 0 && $ans_data_count != 0) {
        my $lc = List::Compare->new($args{candidate}, $args{answerset});
        my $intersection = $lc->get_intersection();
        return sprintf "%2.4f", ($intersection / $ans_data_count);
        
    }
    else {
        carp "Error: given data are containing NA";
        return;
    }
}

sub calc_precision {
    my %args = (
                candidate => undef,
                answerset => undef,
                @_,
               );
    
    # type checking 
    if (ref $args{candidate} ne 'ARRAY' && ref $args{answerset} ne 'ARRAY') {
        die "Error: given data are not ARRAY";
    }
    
    # NA checking
    my $ans_data_count       = scalar @{ $args{answerset} };
    my $candidate_data_count = scalar @{ $args{candidate} };
        
    if ($ans_data_count != 0 && $candidate_data_count != 0) {
        my $lc = List::Compare->new($args{candidate}, $args{answerset});
        my $intersection = $lc->get_intersection();
        return sprintf "%2.4f", ($intersection / $candidate_data_count);
    }
}

1;
