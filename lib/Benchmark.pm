package Benchmark {
    
    use strict;
    use warnings;
    use List::Compare;
    use Carp;
    use Data::Dumper;
    
    sub get_measure {
        my %args = (
                    predicted => undef,
                    answerset => undef,
                    flag      => undef,
                    @_,
                   );
        
        # type checking 
        if (ref $args{predicted} ne 'ARRAY' && ref $args{answerset} ne 'ARRAY' && ref $args{flag} ne 'HASH') {
            croak "Error: given data are not ARRAY";
        }
        
        # flag checking
        if (!defined $args{flag}) {
            croak "Error: Setting 'flag' param to get_measure() is required";
        }
        elsif (!defined $args{predicted}) {
            croak "Error: Setting 'predicted' param to get_measure() is required";
        }
        elsif (!defined $args{answerset}) {
            croak "Error: Setting 'answerset' param to get_measure() is required";
        }
        
        # NA checking
        my $ans_data_count       = scalar @{ $args{answerset} };
        my $predicted_data_count = scalar @{ $args{predicted} };
        
        if ($ans_data_count != 0 && $predicted_data_count != 0) {
            my $lc = List::Compare->new($args{predicted}, $args{answerset});
            my $intersection = $lc->get_intersection();
            
            if ($args{flag} eq 'recall') {
                my $recall = $intersection/$ans_data_count;
                return main::_formated($recall);
            }
            elsif ($args{flag} eq 'precision') {
                my $precision = $intersection/$predicted_data_count;
                return main::_formated($precision);
            }
            elsif ($args{flag} eq 'all') {
                my $recall    = main::_formated($intersection/$ans_data_count);
                my $precision = main::_formated($intersection/$predicted_data_count);
                my $res = "$recall\t$precision";
                return $res;
            } else {
                croak "Error: given argument is not acceptable";}
        } else {
            croak "Error: given data is containing zero";
        }
    }
}
    
package main {
    use warnings;
    use strict;
    
    sub _formated {
        my $p = shift;
        return sprintf "%2.4f", $p;
    }
}

1;
