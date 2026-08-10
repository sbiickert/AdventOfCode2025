#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day09_test.txt';
my $INPUT_FILE = 'day09_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 9: Movie Theater";

my @coords = parse_coords(@input);

solve_part_one(@coords);
#solve_part_two(@input);

exit( 0 );

sub solve_part_one(@coords) {
	my @pairs = @coords.combinations(2);
    my @areas = @pairs.map(->@p {Extent.from_coords(@p).area});
    my $max = @areas.max;

    say "Part One: the largest area is $max ";
}

sub solve_part_two(@input) {
	
    say "Part Two:  ";
}

sub parse_coords(@input) {
    @input
        ==> map(->$line {'[' ~ $line ~ ']'})
        ==> map(->$s {Coord.from_str($s)})
        ==> my @coords;
    return @coords;
}