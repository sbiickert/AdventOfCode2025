#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day03_test.txt';
my $INPUT_FILE = 'day03_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 3: Lobby";

solve_part_one(@input);

solve_part_two(@input);
# say "Part Two:  $solution2";

exit( 0 );

sub solve_part_one(@input) {
	@input ==> map(-> $s {$s.comb})
           ==> map(-> @d {largest_joltage_p1(@d)})
           ==> my @joltages;
    my $result = @joltages.sum;
    say "Part One: the sum of max joltages is $result";
}

sub largest_joltage_p1(@jolts) {
    my @ints = @jolts.map(-> $s {$s.int});
    my @sorted = @ints.sort.reverse;
    my $i1 = 0;
    my $i = @ints.first(@sorted[$i1], :k);
    if ($i == @ints.end) {
        $i1 = 1;
        $i = @ints.first(@sorted[$i1], :k);
    }
    my $i2 = 0;
    my $j = @ints.first(@sorted[$i2], :end, :k);
    while ($i2 == $i1 || $j <= $i) {
        $i2++;
        $j = @ints.first(@sorted[$i2], :end, :k);
    }
    my $s = [@sorted[$i1], @sorted[$i2]].join;
    my $joltage = $s.int;
    return $joltage;
}

sub solve_part_two(@input) {
	@input ==> map(-> $s {$s.comb})
           ==> map(-> @d {largest_joltage_p2(@d)})
           ==> my @joltages;
    my $result = @joltages.sum;
    say "Part Two: the sum of max joltages is $result";
}

sub largest_joltage_p2(@jolts) {
    my @ints = @jolts.map(-> $s {$s.int});
    # Repeatedly remove the first digit that is smaller than the one following it
    while (@ints.elems > 12) {
        for 0..@ints.end -> $i {
            if ($i == @ints.end) {
                @ints.splice($i, 1);
            }
            elsif (@ints[$i] < @ints[$i+1]) {
                @ints.splice($i, 1);
                last;
            }
        }
    }
    my $s = @ints.join;
    my $joltage = $s.int;
    return $joltage;
}
