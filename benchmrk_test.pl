#!/usr/bin/env perl

use strict;
use warnings;
use Carp;
use IO::File;
use IO::Dir;
use Cwd;
use File::Basename qw/fileparse basename/;
use List::Compare;
use Getopt::Long;
use Readonly;
use Data::Dumper;

# My modules
use lib qw{/home/soh.i/benchmark/src/lib};
use Benchmark;

# Parsing args
my %opts = ();
my $help = undef;
GetOptions(
           \%opts,
           'help|h' => \$help,
           'answer_dir=s',
           'predicted_dir=s',
          ) or die _usage();

if ($help) {
    print _usage();
    exit;
}
if (!$opts{answer_dir} || !$opts{predicted_dir}) {
    print "!!! Require the answer set and/or predicted set !!!\n";
    die _usage();
}

# Constatnt variables
Readonly my $ANSDATA_SUFFIX        => '.csv'; # eg. hg19.csv
Readonly my $PREDICTED_DATA_SUFFIX => '.csv'; # eg. excel.csv

# Collect answer data set from given dir
my $adh = IO::Dir->new($opts{answer_dir}) or die "Error: Can not find file:$!";
my @ans_files = ();
while (my $ans_file = $adh->read()){
    next unless $ans_file =~ m/$ANSDATA_SUFFIX$/;
    my $abs_ans_path = Cwd::abs_path($opts{answer_dir})."/$ans_file";
    push @ans_files, $abs_ans_path;
}
$adh->close();

# Make a header line
my $header = "Recall\tPrecision\tLabel\tAnswerSet\tAnsCount\tPredCount\n";
print STDOUT $header;

# Roop num. of ans files * num. of predicted files
for my $ansfile (@ans_files) {
    
    # collection of answer data
    my $collected_answer = collect_data(file => $ansfile, sep => 'comma');
    
    my $pdh = IO::Dir->new($opts{predicted_dir}) or die $!;
    
    # collection of predicted data
    while (my $pred_file = $pdh->read()){
        next unless $pred_file =~ m/$PREDICTED_DATA_SUFFIX$/;
        my $abs_pred_path = Cwd::abs_path($opts{predicted_dir})."/$pred_file";
        my $collected_predict = collect_data(file => $abs_pred_path, sep => 'comma');
        
        # Calculate for the metrics
        my $result = Benchmark::get_measure(
                                            flag => 'all',
                                            predicted => $collected_predict,
                                            answerset => $collected_answer
                                           );
        print $result, "\t";
        print basename($pred_file, '.csv'), "\t";
        print basename($ansfile, '.txt'), "\t";
        print scalar @{$collected_answer}, "\t";
        print scalar @{$collected_predict}, "\n";
    }
    $pdh->close();
}

sub collect_data {
    my %args = (
                file => undef,
                sep  => undef,
                @_,
               );
    
    my $bfh = IO::File->new($args{file}) or croak "Internal Error: Can not open file:$!";
    my $collected = [];
    while (my $data_entory = $bfh->getline) {
        
        # Skip the header if its exists
        next if __LINE__ == 1;
        next if $data_entory =~ m/^#/;
        next if $data_entory =~ m/^track/;

        # Split properly
        if ($args{sep} eq 'tab') {
            my ($chr, $pos)  = (split /\t+/, $data_entory)[0,1];
            $chr =~ s/^chr// if $chr =~ m/^chr/; # Remove 'chr' prefix
            $pos =~ s/\,//g  if $pos =~ m/\,/;   # Remove comma. e.g. 123,456
            push $collected, "$chr:$pos";
        }
        elsif ($args{sep} eq 'comma') {
            my ($chr, $pos)  = (split /\,/, $data_entory)[0,1];
            $chr =~ s/^chr// if $chr =~ m/^chr/;
            $pos =~ s/\,//g  if $pos =~ m/\,/;  
            push $collected, "$chr:$pos";
        }
        else {
            croak "Internal error: given split() separetor, 'tab' or 'comma' is only accepted";
        }
    }
    return $collected;
}

sub _usage {
    return <<EOF;
$0:
Benchmarking test for the RNA editing sites detection methods based on RNA-seq data,
using precision and recall.

Usage:
    perl $0 --answer_dir ./DARNED_DIR --predicted ./EditingSite_collection/
    --answer_dir    [required]
    --predicted_dir [required]

Options:
    --help Show help message

*** Input data ***
[0] chr1 [1] 1338121
[0] YHet, [1] 12,009
[0] 1, [1] 9318212

EOF
}
