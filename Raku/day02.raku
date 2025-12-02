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

my $re;
solve_part_one();
solve_part_two();

exit( 0 );

sub solve_part_one() {
    $re =  / ^ (\d+) $0 $ /;
	my $sum = sum_invalid_ids();
    say "Part One: the sum of invalid ids is $sum";
}

sub solve_part_two() {
    $re = / ^ (\d+) $0+ $ /;
	my $sum = sum_invalid_ids();
    say "Part Two: the sum of invalid ids is $sum";
}

sub sum_invalid_ids() {
    my @sum_per_range = @ranges>>.&sum_invalid_ids_for_range;
    return @sum_per_range.sum();
}

sub sum_invalid_ids_for_range($r) {
    my @range = parseRange($r);
    my @values = @range.map(-> $id {$id ~~ $re ?? $id !! 0});
    return @values.sum();
}

sub parseRange($rStr) {
    my @rStr = split('-', $rStr);
    return (@rStr[0]+0)..(@rStr[1]+0);
}