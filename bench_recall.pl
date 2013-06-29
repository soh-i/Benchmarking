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
use Data::Dumper;

# My modules
use lib qw{/home/soh.i/benchmark/lib};
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

# Collect answer data set from given dir
my $adh = IO::Dir->new($opts{answer_dir}) or die $!;
my @ans_files = ();
while (my $ans_file = $adh->read()){
    next unless $ans_file =~ m/\.txt/;
    my $abs_ans_path = Cwd::abs_path($opts{answer_dir})."/$ans_file";
    push @ans_files, $abs_ans_path;
}
$adh->close();

# Make a header line
my $header = "Recall\tPrecision\tLabel\tAnswerSet\n";
print STDOUT $header;

# Roop num. of ans files * num. of predicted files
for my $ansfile (@ans_files) {
    
    # collection of answer data
    my $collected_answer = collect_data(file => $ansfile, sep => 'tab');
    my $pdh = IO::Dir->new($opts{predicted_dir}) or die $!;
    
    # collection of predicted data
    while (my $pred_file = $pdh->read()){
        next unless $pred_file =~ m/\.csv$/;
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
        print basename($ansfile, '.txt'), "\n";
    }
    $pdh->close();
}

sub collect_data {
    my %args = (
                file => undef,
                sep  => undef,
                @_,
               );
    
    my $bfh = IO::File->new( $args{file} ) or croak "Cant open file:$!";
    my $collected = [];
    while (my $data_entory = $bfh->getline) {
        next if $. == 1;

        # Split properly
        my ($chr, $pos);
        if ($args{sep} eq 'tab') {
            ($chr, $pos)  = (split /\t/, $data_entory)[0,1];
            $chr =~ s/^chr//g if $chr =~ m/^chr/; # Remove 'chr' prefix
            $pos =~ s/\,//g   if $pos =~ m/\,/;   # Remove comma. e.g. 123,456
            push $collected, "$chr:$pos";
        }
        elsif ($args{sep} eq 'comma') {
            ($chr, $pos)  = (split /\,/, $data_entory)[0,1];
            $chr =~ s/^chr//g if $chr =~ /^chr/;
            $pos =~ s/\,//g if $pos =~ m/\,/;
            push $collected, "$chr:$pos";
        }
        else {
            croak "Error: given split() separetor, 'tab' or 'comma' is only accepted";
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

EOF
}
