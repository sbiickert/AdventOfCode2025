#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day02_test.txt';
my $INPUT_FILE = 'day02_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 2: Gift Shop";

my @ranges = split(',', @input[0]);

my $part = 1;
my $sum1 = sum_invalid_ids();
say "Part One: the sum of invalid ids is $sum1";

$part = 2;
my $sum2 = sum_invalid_ids();
say "Part Two: the sum of invalid ids is $sum2";

exit( 0 );

sub sum_invalid_ids() {
    my @sum_per_range = @ranges>>.&sum_invalid_ids_for_range;
    return @sum_per_range.sum();
}

sub sum_invalid_ids_for_range($r) {
    my @range = parseRange($r);
    my @values = @range.map(-> $id {
        my $idStr = $id.Str;
        my $idLen = $idStr.chars;
        my $value = 0;
        if $part == 1 {
            if $idLen %% 2 {
                $value = $idStr.substr(0, $idLen/2) eq $idStr.substr($idLen/2) ?? $id !! 0;
            }
        }
        else {
            for 1..$idLen/2 -> $part_len {
                if $idLen %% $part_len {
                    my $remainder = $idStr.subst($idStr.substr(0, $part_len), '', :g);
                    if $remainder.chars == 0 {
                        $value = $id;
                        last;
                    }
                }
            }
        }
        $value;
    });
    return @values.sum();
}

sub parseRange($rStr) {
    my @rStr = split('-', $rStr);
    return (@rStr[0]+0)..(@rStr[1]+0);
}