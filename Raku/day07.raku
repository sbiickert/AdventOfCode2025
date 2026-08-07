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

my ($s1, $s2) = solve($grid);
say "Part One: the number of times the beam was split is $s1";
say "Part Two: the total number of parallel universes is $s2";

exit( 0 );

sub solve($grid) {
    my $split_count = 0;
	my $emit = $grid.coords('S').first;
    my %beams = ($emit => 1);
    for 0..$grid.extent.max.y -> $y {
        my %next_beams = ();
        for %beams.kv -> $beam_str, $beam_count {
            my $beam = Coord.from_str($beam_str);
            my $down = $beam.offset("S");
            my $val = $grid.get($down);
            if ($val eq '^') {
                my $down_l = $beam.offset('SW');
                my $down_r = $beam.offset('SE');
                %next_beams{$down_l} += $beam_count;
                %next_beams{$down_r} += $beam_count;
                $split_count++;
            }
            else {
                %next_beams{$down} += $beam_count;
            }
        }
        %beams = %next_beams;
    }
    return ($split_count, %beams.values.sum());
}
