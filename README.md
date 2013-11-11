Benchmarking
============

Benchmarking test for RNA editing detection methods based on RNA-seq data

## example
`get_measure(predicted=>array_ref, answerset=>array_ref, flag=>'all')`

flag => precison, recall, all

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
