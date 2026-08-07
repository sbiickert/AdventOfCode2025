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
solve_part_two($grid);

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

sub solve_part_two($grid) {
	my $emit = $grid.coords('S').first;
    $grid.set($emit, 1);
    for 0..$grid.extent.max.y -> $y {
        for 0..$grid.extent.max.x -> $x {
            my $beam = Coord.new(x => $x, y => $y);
            my $grid_value = $grid.get($beam);
            if ($grid_value eq '.' || $grid_value eq '^') { next }
            my $down = $beam.offset("S");
            my $down_value = $grid.get($down);
            if ($down_value eq '^') {
                my $down_l = $beam.offset('SW');
                my $down_r = $beam.offset('SE');
                add_to_coord($grid, $down_l, $grid_value);
                add_to_coord($grid, $down_r, $grid_value);
            }
            else {
                add_to_coord($grid, $down, $grid_value);
            }
        }
    }

    my $count = 0;
    my $y = $grid.extent.max.y;
    for 0..$grid.extent.max.x -> $x {
        my $grid_value = $grid.get(Coord.new(x => $x, y => $y));
        if ($grid_value eq '.' || $grid_value eq '^') { next }
        $count += $grid_value;
    }
    say "Part Two: the total number of parallel universes is $count";
}

sub add_to_coord($grid, $coord, $value) {
    my $grid_value = $grid.get($coord);
    given $grid_value {
        when '.' { $grid.set($coord, $value) }
        when '^' { $grid.print; die "Trying to set on a splitter $coord"}
        default  { $grid.set($coord, $value + $grid_value) }
    }
}
