#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Spreadsheet::ParseExcel;

my %args = ();
my $help = undef;

GetOptions(
           \%args,
           'excel=s',
           'sheet=s',
           'man|help' => \$help,
          ) or die pod2Usage(1);
if ($help) {
    pod2usage(1);
}

if (scalar @ARGV != 2) {
    pod2usage(-verbose   => 2,
              exitstatus => 0,
              output     => \*STDERR
             );
}

my $input      = shift;
my $sheet_name = shift;

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($input);

if (!defined $workbook) {
    die $parser->error();
}

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


__END__

=head1 NAME

xls2csv - Converting XLS file to CSV

=head1 SYNOPSIS

perl xls2csv --excel data.xls --sheet Sheet1

=head1 OPTIONS

 -e,  --excel     Given a Excel 2003 file.     [Required]
 -s,  --sheet     Given a sheet name of Excel. [Required]
 -h,  --help      Show help messages.

=head1 DESCRIPTION

This program converts .xls file to csv.

=cut
