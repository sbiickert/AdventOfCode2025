#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day07_test.txt';
my $INPUT_FILE = 'day07_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 7: Laboratories";

my @filtered = @input.grep(/\^|S/);

my $grid = Grid.new(default => ' ', rule => AdjacencyRule::ROOK);
$grid.load(@filtered);

solve_part_one($grid);

#$grid = Grid.new(default => ' ', rule => AdjacencyRule::ROOK);
#$grid.load(@input);
#solve_part_two(@input);

exit( 0 );

sub solve_part_one($grid) {
    my $count = 0;
	my $emit = $grid.coords('S').first;
    my @beams = ($emit);
    for 0..$grid.extent.max.y -> $y {
        my %next_beams = ();
        for @beams -> $beam {
            my $down = $beam.offset("S");
            my $val = $grid.get($down);
            if ($val eq '^') {
                my $down_l = $beam.offset('SW');
                my $down_r = $beam.offset('SE');
                %next_beams{$down_l} = $down_l;
                %next_beams{$down_r} = $down_r;
                $count++;
            }
            else {
                %next_beams{$down} = $down;
            }
        }
        @beams = %next_beams.values;
    }
    
    say "Part One: the number of times the beam was split is $count";
}

sub solve_part_two(@input) {
	
    say "Part Two:  ";
}
