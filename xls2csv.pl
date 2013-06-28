#!/usr/bin/env perl

use strict;
use warnings;
use Spreadsheet::ParseExcel;

if (scalar @ARGV != 2) {
    die "perl $0 <excel.xls> <SheetName>";
}

my $input      = shift;
my $sheet_name = shift;

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($input);

if (!defined $workbook) {
    die $parser->error();
}

#my $sheet_name = 'PooledSamplesAlu';
#my $sheet_name = 'PooledSamplesRepetitiveNonAlu';
#my $sheet_name = 'PooledSamplesNon-Repetitive';


for my $worksheet ($workbook->worksheet($sheet_name)) {
    my ($row_min, $row_max) = $worksheet->row_range();
    my ($col_min, $col_max) = $worksheet->col_range();
    
    for my $row ($row_min .. $row_max){
        for my $col ($col_min .. $col_max){
            my $cell = $worksheet->get_cell($row, $col);
            defined $cell ? print $cell->value(), "," : print ",";
        }
        print "\n";
    }
}

