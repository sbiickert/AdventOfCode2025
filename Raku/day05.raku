#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day05_test.txt';
my $INPUT_FILE = 'day05_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 5: Cafeteria";

my @fresh = ();
my @ingredients = ();

parse_input;

solve_part_one();
#solve_part_two(@input);

exit( 0 );

sub solve_part_one() {
    my $fresh_count = 0;

    for @ingredients -> $i {
        for @fresh -> $range {
            if $i ~~ $range {
                $fresh_count++;
                last;
            }
        }
    }
	
    say "Part One: the number of fresh ingredients is $fresh_count";
}

sub solve_part_two(@input) {
	
    say "Part Two:  ";
}

sub parse_input() {
    # Ranges
    my @r = @input[0].flat;
    for @r -> $r_str {
        if $r_str ~~ /(\d+) \- (\d+)/ {
            @fresh.push($0..$1);
        }
    }

    # Ingredient IDs
    @input[1].flat ==> map(-> $s {$s.int}) ==> @ingredients;
}