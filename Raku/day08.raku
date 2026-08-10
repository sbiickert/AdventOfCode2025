#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day08_test.txt';
my $INPUT_FILE = 'day08_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 8: Playground";

my @boxes = parse_coords(@input);
my @distances = calc_distances(@boxes);
my @sorted = sorted_pairs_by_distance(@distances); # this is the slowest step

solve_part_one();
solve_part_two();

exit( 0 );

sub solve_part_one() {
    my $limit = @boxes.elems == 20 ?? 10 !! 1000;
    my @circuits = build_circuits($limit, ());
    my @sizes = @circuits[0..2].map(*.elems);
    my $product = [*] @sizes;

    say "Part One: the product of the sizes of the three largest circuits is $product";
}

sub solve_part_two() {
    my @last_merge_pair = ();
    my @circuits = build_circuits(-1, @last_merge_pair);
	my $product = @last_merge_pair[0].x * @last_merge_pair[1].x;

    say "Part Two: the product of the x of the last two merged boxes is $product";
}

sub parse_coords(@input) {
    @input
        ==> map(->$line {'[' ~ $line ~ ']'})
        ==> map(->$s {Coord3D.from_str($s)})
        ==> my @coords;
    return @coords;
}

sub calc_distances(@boxes) {
    my @distances = ();

    for 0..@boxes.end -> $i {
        @distances[$i] = [];
        for 0..@boxes.end -> $j {
            # Short circuit calculating distances we won't use
            my $d = $j <= $i ?? 0 !! @boxes[$i].distance_to(@boxes[$j]);
            @distances[$i][$j] = $d;
        }
    }

    return @distances;
}

sub sorted_pairs_by_distance(@distances) {
    my @data = ();

    for 0..@boxes.end-1 -> $i {
        for $i+1..@boxes.end -> $j {
            @data.push({i => $i, j => $j, d => @distances[$i][$j]});
        }
    }

    my @sorted = @data.sort: {$^a{'d'} <=> $^b{'d'}};
    return @sorted;
}

sub build_circuits($limit, @last_merge) {
    my @circuits = ();
    for 0..@boxes.end -> $id {
        @circuits.push( set($id) );
    }

    my $real_limit = $limit > 1 ?? $limit !! @sorted.elems;

    for 0..$real_limit-1 -> $count {
        my %distance_info = @sorted[$count]; # These are the ids of the two closest boxes and their distance

        # Find the circuit with each id in it
        my $circuit_i = -1; my $circuit_j = -1;
        for 0..@circuits.end -> $c {
            $circuit_i = $c if @circuits[$c] ∋ %distance_info{'i'};
            $circuit_j = $c if @circuits[$c] ∋ %distance_info{'j'};

            last if $circuit_i >= 0 && $circuit_j >= 0;
        }

        if ($circuit_i != $circuit_j) {
            @circuits[$circuit_i] = @circuits[$circuit_i] ∪ @circuits[$circuit_j];
            splice( @circuits, $circuit_j, 1);
            my $box_i = @boxes[%distance_info{'i'}];
            my $box_j = @boxes[%distance_info{'j'}];
            @last_merge = ($box_i, $box_j);
        }

        last if @circuits.elems == 1;
    }
    return @circuits.sort(*.elems).reverse;
}