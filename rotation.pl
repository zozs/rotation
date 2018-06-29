#!/usr/bin/env perl
use strict;
use warnings;
use 5.012;
use Time::Piece;

my @UTC_MONTHS = qw/january february march april may june july august september october november december/;
my @UTC_WEEKDAYS = qw/sunday monday tuesday wednesday thursday friday saturday/;

my $today = localtime();
if (scalar(@ARGV) > 0) {
    # User has enterered a manual date. Assume ISO8601 YYYY-mm-dd and parse it.
    $today = Time::Piece->strptime($ARGV[0], '%Y-%m-%d');
    #say "Parsed date: $today";
}

my $id;

if ($today->mday == 1) {
    if ($today->mon % 3 == 0) {
        $id = join '-', 'quarterly', $today->year, int($today->_mon / 3) + 1;
    } else {
        # TODO: also zero pad month.
        $id = join '-', 'monthly', sprintf('%02d', $today->mon), $today->month(@UTC_MONTHS);
    }
} elsif ($today->mday % 7 == 0) {
    $id = join '-', 'weekly', int($today->mday / 7);
} else {
    $id = join '-', 'daily', $today->wday, $today->day(@UTC_WEEKDAYS);
}

say $id;
