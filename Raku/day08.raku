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
my @sorted = sorted_pairs_by_distance(@distances);
my $limit = @boxes.elems == 20 ?? 10 !! 1000;
my @circuits = build_circuits($limit);

solve_part_one();
#solve_part_two();

exit( 0 );

sub solve_part_one() {
    my @sizes =@circuits[0..2].map(*.elems);
    my $product = [*] @sizes;

    say "Part One: the product of the sizes of the three largest circuits is $product";
}

sub solve_part_two(@input) {
	
    say "Part Two:  ";
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
            my $d = @boxes[$i].distance_to(@boxes[$j]);
            @distances[$i][$j] = $d;
        }
    }

    #dd @distances;
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

    # dd @sorted;
    return @sorted;
}

sub build_circuits($limit) {
    my @circuits = ();
    for 0..@boxes.end -> $id {
        @circuits.push( set($id) );
    }

    for 0..$limit-1 -> $count {
        my %distance_info = @sorted[$count]; # These are the ids of the two closest boxes and their distance
        # say %distance_info;
        # Find the circuit with each id in it
        my $circuit_i = -1; my $circuit_j = -1;
        for 0..@circuits.end -> $c {
            $circuit_i = $c if @circuits[$c] ∋ %distance_info{'i'};
            $circuit_j = $c if @circuits[$c] ∋ %distance_info{'j'};

            last if $circuit_i >= 0 && $circuit_j >= 0;
        }

        if ($circuit_i != $circuit_j) {
            # say "Merging $circuit_i, $circuit_j";
            @circuits[$circuit_i] = @circuits[$circuit_i] ∪ @circuits[$circuit_j];
            splice( @circuits, $circuit_j, 1);
            # dd @circuits;
        }
    }
    return @circuits.sort(*.elems).reverse;
}