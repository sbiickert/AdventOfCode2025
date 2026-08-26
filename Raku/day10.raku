#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../Input';
my $INPUT_FILE = 'day10_test.txt';
# my $INPUT_FILE = 'day10_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2025, Day 10: Factory";

my @machines = parse_machines(@input);

solve_part_one(@machines);
solve_part_two(@machines);

exit( 0 );

sub solve_part_one(@machines) {
	my $total_presses = 0;

	for @machines -> %m {
		my ($num_presses, $button_presses) = solve_machine_parity_goal(%m{'goal'}, %m{'buttons1'}.List);
		$total_presses += $num_presses;
	}

	say "Part One: the minimum total presses is $total_presses.";
}

sub solve_part_two(@machines) {
	my $total_presses = 0;

	for @machines -> %m {
		my ($num_presses, $button_presses) = solve_machine_parity_goal(%m{'goal'}, %m{'buttons1'}.List);
		$total_presses += $num_presses;
	}

	say "Part Two: the minimum total presses is $total_presses.";
}

# https://old.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
sub bifurcate_to_victory() {

}

sub solve_machine_parity_goal(Int $goal, @buttons) {
	return 0 if $goal == 0;

	my %data = ( 0 => 0 ); # State 0 (all off) => button press bitmap
	my %evaluated = ();
	my $num_presses = 1000000; # large number
	my $result_button_presses = 0;
	my $round = 1;

	while ($num_presses == 1000000 && %data.elems > 0) {
		my @states = %data.keys;
		my %new_data = ();

		for %data.kv -> $state, $button_press_history {
			# say "$state => $button_press_history";
			%evaluated{$state} = 1;

			for @buttons.kv -> $i, $button {
				my $new_button_presses = $button_press_history + (2 ** $i);
				if ($button_press_history +& (2 ** $i)) == 0 {
					my $result = $state +^ $button; # $state xor $button is $result
					if $result == $goal {
						$num_presses = $round;
						$result_button_presses = $new_button_presses;
						last;
					}
					if !(%evaluated{$result}) {
						%new_data{$result} = $new_button_presses;
					}
				}
			}

			last if $num_presses != 1000000;
		}
		%data = %new_data;
		$round++;
	}

	return ($num_presses, $result_button_presses);
}

sub apply_button_presses_to_joltages($button_presses, @buttons, @joltages) {
	my @new_joltages = @joltages;
	for 0..@buttons.end -> $i {
		if $button_presses +& (2 ** $i) != 0 {
			# Button $i was pressed
			
		}
	}
}

sub solve_part_two_slow(@machines) {
	my $total_presses = 0;

	for @machines.kv -> $i, %m {
		print "$i: ";
		my $minimum_required_rounds = %m{'jolts'}.min;
		my $goal_str = %m{'jolts'}.Str;
		my @off_state = 0 xx %m{'jolts'}.elems;
		my %data = (@off_state => @off_state);
		my $num_presses = 0;
		my $round = 1;
		while ($num_presses == 0) {
			my @states = %data.values;
			%data = ();
			for @states -> @state {
				my @buttons = %m{'buttons2'}.List;
				for @buttons -> @button {
					my @result = @state <<+>> @button; # @state hyper operator add @button is @result
					# my @result = ();
					# for 0..@state.end -> $i { @result[$i] = @state[$i] + @button[$i] }
					# my @result = (0..@state.end).race.map(-> $i {@state[$i] + @button[$i]});
					my $result_str = @result.Str;

					if $result_str eq $goal_str {		# eqv is strict structural equality (values and positions)
						$num_presses = $round;
						say $num_presses;
						last;
					}

					if $round <= $minimum_required_rounds {
						%data{$result_str} = @result;
					}
					else {
						# If any of the joltages are greater than the target, don't keep evaluating
						my $all_le = [and] @result «<=» %m{'jolts'};  # hyper operator '<='' and the [and] junction
						if $all_le {
							%data{$result_str} = @result;
						}
					}
				}
				last if $num_presses > 0;
			}
			say $round ~ ' ' ~ @states.elems;
			$round++;
			die if $round > 10; # safety
		}
		$total_presses += $num_presses;
	}
	
	say "Part Two: the minimum total presses is $total_presses.";
}

sub parse_machines(@input) {
	my @result = ();

	for @input -> $line {
		if $line ~~ / \[(<[#\.]>+)\] \s+ (<[\(\)\,\d\s]>+) \s+ \{(<[\d\,]>+)\} /
		{
			my %machine = (
				'goal' => parse_goal($0),
				'buttons1' => parse_buttons($1, 1),
				'jolts' => parse_jolts($2)
			);
			%machine{'buttons2'} = parse_buttons($1, %machine{'jolts'}.elems);
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

sub parse_buttons($buttons, $jolt_count) {
	# e.g. '(3) (1,3) (2) (2,3) (0,2) (0,1)'
	my $str = $buttons;
	$str ~~ s:g/'('//;
	$str ~~ s:g/')'//;
	my @buttons = $str.split(' ');
	if $jolt_count == 1 {
		return @buttons.map(&parse_button_1).Array;
	}
	return @buttons.map( { parse_button_2($jolt_count, $_) }).Array;
}

sub parse_button_1($button --> Int) {
	my @nums = $button.split(',');
	@nums ==> map(-> $s {2 ** $s}) ==> sum() ==> my $num;
	return $num.first;
}

sub parse_button_2($jolt_count, $button) {
	my @nums = $button.split(',');
	@nums = @nums.map(*.Int);
	my @button = 0 xx $jolt_count;
	for @nums -> $num { @button[$num] = 1 }
	return @button;
}

sub parse_jolts($joltages) {
	my @nums = $joltages.split(',').map(*.Int);
	return @nums;
}