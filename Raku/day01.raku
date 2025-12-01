#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day01_test.txt';
my $INPUT_FILE = 'day01_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 1: Secret Entrance";

@input ==> map(-> $line {$line.trans("LR" => "-+") + 0;}) ==> my @numbers;

solve_part_one(@numbers);
solve_part_two(@numbers);

exit( 0 );

sub solve_part_one(@numbers) {
    my $zero_count = 0;
    my $value = 50;

    for @numbers -> $num {
        $value += $num;
        $value = $value % 100;
        $zero_count++ if $value == 0;
    }
	say "Part One: the number times ending at 0 is $zero_count";
}

sub solve_part_two(@input) {
    my $zero_count = 0;
    my $value = 50;

    for @numbers -> $num {
        my $step = $num / abs($num);
        for 1..abs($num) {
            $value += $step;
            $value = $value % 100;
            $zero_count++ if $value == 0;
        }
    }
	say "Part One: the number times passing 0 is $zero_count";
}
