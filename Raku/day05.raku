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
optimize_fresh;

solve_part_one();
solve_part_two();

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

sub solve_part_two() {

    @fresh
        ==> map(*.elems) 
        ==> sum() 
        ==> my $fresh_count;

    say "Part Two: the total number of potential fresh ingredient ids is $fresh_count";
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

sub optimize_fresh() {
    my @sorted = @fresh.sort(*.min);
    my @result = ();

    my $current = @sorted.shift;

    for @sorted -> $next {
        # Check if the next range overlaps or touches the current one
        if $next.min <= $current.max {
            # Merge them by updating the max boundary
            $current = $current.min .. max($current.max, $next.max);
        } else {
            # No overlap, save the current range and move to the next
            @result.push($current);
            $current = $next;
        }
    }
    @result.push($current) if $current;
    @fresh = @result;
}