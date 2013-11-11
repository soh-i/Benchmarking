Benchmarking
============

Benchmarking test for RNA editing detection methods based on RNA-seq data

## example
* `get_measure(predicted=>array_ref, answerset=>array_ref, flag=>'all')`    
* flag => precison, recall, all

```perl
# Calculate for the metrics
use Benchmark;
my $result = Benchmark::get_measure(
                                    flag => 'all',
                                    predicted => $collected_predict,
                                    answerset => $collected_answer
                                   );
#=> recall precision
#=> 0.99   0.393
```                                           

## test
```perl
 if ($ans_data_count != 0 && $predicted_data_count != 0) {
            my $lc = List::Compare->new($args{predicted}, $args{answerset});
            my $intersection = $lc->get_intersection();

            if ($args{flag} eq 'precision') {
                my $recall = $intersection/$predicted_data_count;
                return main::_formated($recall);
            }
            elsif ($args{flag} eq 'recall') {
                my $precision = $intersection/$ans_data_count;
                return main::_formated($precision);
            }
            elsif ($args{flag} eq 'all') {
                my $precision = main::_formated($intersection/$predicted_data_count);
                my $recall    = main::_formated($intersection/$ans_data_count);
                my $res = "$recall\t$precision";
                return $res;
            } else {
                croak "Error: given argument is not acceptable";}
        } else {
            croak "Error: given data is containing zero";
        }
```        
