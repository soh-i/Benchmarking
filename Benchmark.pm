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
            return sprintf "%2.4f", $recall;
        }
        elsif ($args{flag} eq 'recall') {
            my $precision = $intersection/$ans_data_count;
            return sprintf "%2.4f", $precision;
        }
        elsif ($args{flag} eq 'all') {
            my $r = $intersection/$candidate_data_count;
            my $p = $intersection/$ans_data_count;
            return "$r, $p";
        } else {
            return;
        }
    }
}

1;

__END__

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
