#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;

my $INPUT_PATH = '../Input';
# my $INPUT_FILE = 'day06_test.txt';
my $INPUT_FILE = 'day06_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 6: Trash Compactor";

my @ops = get_operators(@input.tail);
@input = @input[0..*-2];    # Drop the last line with operators
my @blocks = get_number_blocks(@input);
@ops = @ops[0..*-2];        # Drop the bogus operator used for parsing

my $s1 = solve_part(1);
say "Part One: the total is $s1";

my $s2 = solve_part(2);
say "Part Two: the total is $s2";

exit( 0 );

sub solve_part($part) {
    my $sum = 0;
    for 0..@ops.end -> $i {
        my $op = @ops[$i][1];

        my @block;
        given $part {
            when 1 {@block = @blocks[$i].flat}
            when 2 {@block = pivot_number_block(@blocks[$i])}
        }
        
        $sum += $op eq '+' ?? @block.sum !! [*] @block.flat;
    }
    return $sum;
}

sub get_operators($line) {
    my @result = ();

    for $line.comb.kv -> $index, $char {
        if $char ne ' ' {
            @result.push([$index, $char]);
        }
    }
    @result.push([$line.chars + 2, '']);
    return @result;
}

sub get_number_blocks(@lines) {
    my @blocks = ();
	for 0..@ops.end-1 -> $i {
        my @block = ();
        my ($index, $op) = @ops[$i];
        my $next_index = @ops[$i+1][0] - 2;
        for @lines -> $line {
            my $num = substr($line, $index..$next_index);
            @block.push($num);
        }
        @blocks.push(@block);
    }
    return @blocks;
}

sub pivot_number_block(@block) {
    my @pivot = ();
    my $cols = @block[0].chars-1;
    my $rows = @block.end;
    for 0..$cols -> $c {
        my $str = '';
        for 0..$rows -> $r {
            $str = $str ~ substr(@block[$r], $c..$c);
        }
        @pivot.push($str);
    }
    return @pivot;
}