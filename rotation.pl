#!/usr/bin/env perl
use strict;
use warnings;
use 5.012;
use Getopt::Long;
use Time::Piece;

my @UTC_MONTHS = qw/january february march april may june july august september october november december/;
my @UTC_WEEKDAYS = qw/sunday monday tuesday wednesday thursday friday saturday/;

# default arguments.
my $today = localtime();
my $prefix = '';
my $suffix = '';

# Parse command-line arguments.
GetOptions("date=s"   => \&date_handler,
           "prefix=s" => \$prefix,
           "suffix=s" => \$suffix)
or die("Error in command line arguments\n");

sub date_handler {
    my ($opt_name, $opt_value) = @_;
    $today = Time::Piece->strptime($opt_value, '%Y-%m-%d');
}

my $id;

if ($today->mday == 1) {
    if ($today->mon % 3 == 0) {
        $id = join '-', 'quarterly', $today->year, int($today->_mon / 3) + 1;
    } else {
        $id = join '-', 'monthly', sprintf('%02d', $today->mon), $today->month(@UTC_MONTHS);
    }
} elsif ($today->mday % 7 == 0) {
    $id = join '-', 'weekly', int($today->mday / 7);
} else {
    $id = join '-', 'daily', $today->wday, $today->day(@UTC_WEEKDAYS);
}

say "${prefix}${id}${suffix}";
