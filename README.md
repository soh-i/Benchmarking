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
```                                           
