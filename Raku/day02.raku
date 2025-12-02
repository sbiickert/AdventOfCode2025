#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
my $INPUT_FILE = 'day02_test.txt';
# my $INPUT_FILE = 'day02_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 2: Gift Shop";

my @ranges = parseRanges(@input[0]);

solve_part_one();
solve_part_two();

exit( 0 );


sub solve_part_one() {
    my $re =  / ^ (\d+) $0 $ /;
	my $sum = sum_invalid_ids($re);

    say "Part One: the sum of invalid ids is $sum";
}

sub solve_part_two() {
    my $re = / ^ (\d+) $0+ $ /;
	my $sum = sum_invalid_ids($re);
	
    say "Part Two: the sum of invalid ids is $sum";
}

sub sum_invalid_ids($re) {
    my $sum = 0;

    for @ranges -> @range {
        for @range[0]..@range[*-1] -> $id {
            if $id ~~ $re {
                $sum += $id;
            }
        }
    }
    return $sum;
}

sub parseRanges($line) {
    my @ranges = ();

    for split(',', $line) -> $rStr {
        my @rStr = split('-', $rStr);
        @rStr ==> map(-> $s { $s + 0 }) ==> my @rInts;
        @ranges.push(@rInts);
    }

    return @ranges;
}