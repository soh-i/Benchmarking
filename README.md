Benchmarking
============

Benchmarking test for RNA editing detection methods based on RNA-seq data

## example
```perl
 # Calculate for the metrics
my $result = Benchmark::get_measure(
                                    flag => 'all',
                                    predicted => $collected_predict,
                                    answerset => $collected_answer
                                   );
#=> 0.99\t0.393
```                                           
