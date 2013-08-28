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

# Collect answer data set from given directory
my $adh = IO::Dir->new($opts{answer_dir}) or die "Error: Can not find file:$!";
my @ans_files = ();
while (my $ans_file = $adh->read()){
    next unless $ans_file =~ m/$ANSDATA_SUFFIX$/;
    my $abs_ans_path = Cwd::abs_path($opts{answer_dir}).'/'.$ans_file;
    push @ans_files, $abs_ans_path;
}
$adh->close();

# Make a header line
my $header = "Recall\tPrecision\tLabel\tAnswerSet\tAnsCount\tPredCount\n";
print STDOUT $header;

# Roop num. of ans files * num. of predicted files
for my $ansfile (@ans_files) {
    
    # collection of answer data
    my $collected_answer = collect_data(file => $ansfile);
    
    my $pdh = IO::Dir->new($opts{predicted_dir}) or die $!;
    
    # collection of predicted data
    while (my $pred_file = $pdh->read()){
        next unless $pred_file =~ m/$PREDICTED_DATA_SUFFIX$/;
        my $abs_pred_path = Cwd::abs_path($opts{predicted_dir}).'/'.$pred_file;
        my $collected_predict = collect_data(file => $abs_pred_path);
        
        # Calculate for the metrics
        my $result = Benchmark::get_measure(
                                            flag => 'all',
                                            predicted => $collected_predict,
                                            answerset => $collected_answer
                                           );
        print $result, "\t";
        print basename($pred_file, '.csv'), "\t";
        print basename($ansfile,   '.csv'), "\t";
        print scalar @{$collected_answer},  "\t";
        print scalar @{$collected_predict}, "\n";
    }
    $pdh->close();
}

sub collect_data {
    my %args = (
                file => undef,
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
        my ($chr, $pos)  = (split /\,/, $data_entory)[0, 1];
        
        $chr =~ s/^chr// if $chr =~ m/^chr/;
        $pos =~ s/\,//g  if $pos =~ m/\,/;  
        push $collected, "$chr:$pos";
        
    }
    return $collected;
}

sub _usage {
    return <<EOF;

Program: Benchmarking test for the RNA editing sites detection methods based on RNA-seq data using precision and recall.

Version: 0.0.1

Usage:
    perl $0 --answer_dir ./DARNED_DIR --predicted ./EditingSite_collection/
    --answer_dir    [Required]
    --predicted_dir [Required]

Options:
    --help Show help message


### Input sample (csv) ###
chr1,1338121
YHet,12,009
1,9318212

EOF
}
