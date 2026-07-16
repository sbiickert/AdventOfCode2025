#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day04_test.txt';
my $INPUT_FILE = 'day04_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 4: Printing Department";

my $map = Grid.new(default => '.', rule => AdjacencyRule::QUEEN);
$map.load(@input);
# $map.print;

solve_part_one($map);
solve_part_two($map);

exit( 0 );

sub solve_part_one($map) {
    my $count = 0;
    for $map.coords('@') -> $coord {
        my @neighbors = $map.neighbors($coord);
        my %bag = @neighbors.map(-> $c {$map.get($c)}).Bag;
        %bag{'@'} //= 0; # Set to 0 if not defined to suppress warning
        $count++ if %bag<@> < 4;
    }
    say "Part One: the number of rolls with fewer than 4 adjacent rolls is $count.";
}

sub solve_part_two($map) {
    my $centroid = $map.extent.centroid;
    my $roll_count = -1;
    my @roll_coords = $map.coords('@');

    # Sort from outside to center
    my @sorted = @roll_coords.sort({$^a.manhattan_distance_to($centroid) <=> $^b.manhattan_distance_to($centroid)});

    # Cache neighbors
    my %neighbors = [];
    for @sorted -> $coord {
        %neighbors{$coord.Str} = $map.neighbors($coord);
    }

    while ($roll_count != @sorted.elems && @sorted.elems > 0) {
        $roll_count = @sorted.elems;
        for @sorted.end ... 0 -> $i {
            my $coord = @sorted[$i];
            my @neighbors = %neighbors{$coord.Str}.flat;
            my %bag = @neighbors.map(-> $c {$map.get($c)}).Bag;
            %bag{'@'} //= 0; # Set to 0 if not defined to suppress warning
            if (%bag<@> < 4) {
                $map.set($coord, '.');
                @sorted.splice($i, 1);
            }
        }
    }
    my $remove_count = @roll_coords.elems - @sorted.elems;
    say "Part Two: the number of removed rolls is $remove_count.";
}
