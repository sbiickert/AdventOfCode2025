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
solve_part_two(@coords);

exit( 0 );

sub solve_part_one(@coords) {
	my @pairs = @coords.combinations(2);
	@pairs
		==> map(->@p {
			# calculate area
			(abs(@p[0].x - @p[1].x)+1) * (abs(@p[0].y - @p[1].y)+1);
		})
		==> max()
		==> my $max;

	say "Part One: the largest area is $max ";
}

sub solve_part_two(@coords) {
	my %comp_map = Coord.create_compression_map(@coords);
	
	my @comp_coords = @coords.map(->$c {
		my $comp_x = %comp_map{'x_compress'}{$c.x};
		my $comp_y = %comp_map{'y_compress'}{$c.y};
		Coord.new( x => $comp_x, y => $comp_y);
	});

	my $grid = paint_grid(@comp_coords);
	# $grid.print;
	# die;

	my $max_area = 0;
	my @pairs = @comp_coords.combinations(2);
	for @pairs -> @pair {
		my $ext = Extent.from_coords(@pair);
		my $ok = True;
		for $ext.all_coords -> $c {
			if ($grid.get($c) ne '#') {
				$ok = False;
				last;
			}
		}
		if ($ok) {
			my $expanded_min = Coord.from_ints(%comp_map{'x_expand'}{$ext.min.x}, %comp_map{'y_expand'}{$ext.min.y});
			my $expanded_max = Coord.from_ints(%comp_map{'x_expand'}{$ext.max.x}, %comp_map{'y_expand'}{$ext.max.y});
			my $expanded_ext = Extent.from_coords(($expanded_min, $expanded_max));
			if ($expanded_ext.area > $max_area) {
				$max_area = $expanded_ext.area ;
				say $max_area;
			}
		}
	}
	
	say "Part Two: the maximum area is $max_area";
}

sub parse_coords(@input) {
	@input
		==> map(->$line {'[' ~ $line ~ ']'})
		==> map(->$s {Coord.from_str($s)})
		==> my @coords;
	return @coords;
}

sub paint_grid(@comp_coords --> Grid) {
	my $grid = Grid.new( default => '.', rule => AdjacencyRule::ROOK);
	
	# Mark the corners
	for @comp_coords -> $c {
		$grid.set($c, '#');
	}
	
	# Draw the edges
	for 0..@comp_coords.end -> $i {
		my $j = $i == @comp_coords.end ?? 0 !! $i + 1;
		walk($grid, @comp_coords[$i], @comp_coords[$j]);
	}

	# Fill
	for $grid.extent.min.x .. $grid.extent.max.x -> $x {
		my $coord = Coord.from_ints($x, $grid.extent.min.y);
		my $south = Coord.from_ints($x, $grid.extent.min.y + 1);
		if ($grid.get($coord) eq '#' && $grid.get($south) eq '.') {
			$grid.flood_fill($south, '#');
		}
	}

	return $grid;
}

sub walk(Grid $grid, Coord $from, Coord $to) {
	my $segment = Segment.new( from => $from, to => $to );
	my $pos = Position.new(coord => $from, dir => $segment.direction);
	$pos = $pos.move_forward();
	while (($pos.coord eqv $to) == False) {
		$grid.set($pos.coord, '#');
		$pos = $pos.move_forward(1);
	}
}