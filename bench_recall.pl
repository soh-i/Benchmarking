#!/usr/bin/env perl

use strict;
use warnings;
use Carp;
use IO::File;
use IO::Dir;
use Cwd;
use List::Compare;
use Getopt::Long;
use Data::Dumper;

# My modules
use lib qw{/home/soh.i/benchmark/lib};
use Benchmark;

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
    print "Require the answer set and/or predicted set";
    die _usage();
}

my $adh = IO::Dir->new($opts{answer_dir}) or die $!;

my $collected_answer;
while (my $ans_file = $adh->read()){
    next unless $ans_file =~ m/\.txt/;

    # Retrive absolute path of answer directory
    my $abs_ans_path = Cwd::abs_path($opts{answer_dir})."/$ans_file";
    $collected_answer = collect_data(file => $abs_ans_path, sep => 'tab');
}
$adh->close();

my $pdh = IO::Dir->new($opts{predicted_dir}) or die $!;
while (my $pred_file = $pdh->read()){
    next unless $pred_file =~ m/\.csv$/;
    my $abs_pred_path = Cwd::abs_path($opts{predicted_dir})."/$pred_file";
    my $collected_predict = collect_data(file => $abs_pred_path, sep => 'comma');
    my $result = Benchmark::get_measure(
                                        flag => 'all',
                                        predicted => $collected_predict,
                                        answerset => $collected_answer
                                       );
    print $pred_file, "\t";
    print $result, "\n";
}
$pdh->close();

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
            if ($chr =~ /chr/) {
                $chr =~ s/chr//g;
            }
            push $collected, "$chr:$pos";
        }
        elsif ($args{sep} eq 'comma') {
            my ($chr, $pos)  = (split /\,/, $data_entory)[0,1];
            if ($chr =~ /chr/) {
                $chr =~ s/chr//g;
            }
            push $collected, "$chr:$pos";
        }
        else {
            croak "Error: given split() separetor, 'tab' or 'comma' is accepted";
        }
    }
    return $collected;
}

sub _usage {
    return <<EOF;
    Usage:
    perl $0 --answer_dir ./answer_dir/ --predicted ./pred_dir/

Options:
    --answer [required]
    --predicted [required]
    --help Show help message

EOF
}
