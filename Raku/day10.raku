#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day10_test.txt';
my $INPUT_FILE = 'day10_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 10: Factory";

my @machines = parse_machines(@input);

solve_part_one(@machines);
#solve_part_two(@input);

exit( 0 );

sub solve_part_one(@machines) {
    my $total_presses = 0;

    for @machines -> %m {
        my %data = ( 0 => 0 ); # State 0 (all off) => number of presses
        my $num_presses = 0;
        my $round = 1;
        while ($num_presses == 0) {
            my @states = %data.keys;
            for @states -> $state {
                my @buttons = %m{'buttons'}.List;
                for @buttons -> $button {
                    my $result = $state +^ $button; # $state xor $button is $result
                    if $result == %m{'goal'} {
                        $num_presses = $round;
                    }
                    %data{$result} = $round;
                }
            }
            $round++;
            die if $round > 1000; # safety
        }
        $total_presses += $num_presses;
    }

    say "Part One: the minimum total presses is $total_presses.";
}

sub solve_part_two(@input) {
	
    say "Part Two:  ";
}

sub parse_machines(@input) {
    my @result = ();

    for @input -> $line {
        if $line ~~ / \[(<[#\.]>+)\] \s+ (<[\(\)\,\d\s]>+) \s+ \{(<[\d\,]>+)\} /
        {
            my %machine = (
                'goal' => parse_goal($0),
                'buttons' => parse_buttons($1),
                'jolts' => parse_jolts($2)
            );
            @result.push(%machine);
        }
        else {
            die "Could not parse $line";
        }
    }

    return @result;
}

sub parse_goal($goal --> Int) {
    my $binary = $goal;
    $binary ~~ s:g/'#'/1/;
    $binary ~~ s:g/'.'/0/;
    return $binary.flip.parse-base(2).Int; # bits are in reverse order, need to flip
}

sub parse_buttons($buttons) {
    # e.g. '(3) (1,3) (2) (2,3) (0,2) (0,1)'
    my $str = $buttons;
    $str ~~ s:g/'('//;
    $str ~~ s:g/')'//;
    my @buttons = $str.split(' ');
    return @buttons.map(&parse_button).Array;
}

sub parse_button($button --> Int) {
    my @nums = $button.split(',');
    @nums ==> map(-> $s {2 ** $s}) ==> sum() ==> my $num;
    return $num.first;
}

sub parse_jolts($joltages) {
    my @nums = $joltages.split(',').map(*.Int);
    return @nums;
}