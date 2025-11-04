#!/usr/bin/env raku

constant TEMPLATE = 'template.txt';
constant PROGRAM = 'Program.fs';
constant PROJECT = 'AoC2025.fsproj';
my $tag := '<##>';

sub MAIN(Int $day, Str $challenge_name) {
	my $filename = createFSharpFile($day, $challenge_name);
	addToProgram($day, $challenge_name);
    addToFSProj($filename);
}

sub pad_day(Int $day) {
    '%02s'.sprintf($day);
}

sub createFSharpFile(Int $day, Str $challenge_name) {
	my $padded_day = pad_day($day);
	
	my $filename = "Day$padded_day.fs";
	!$filename.IO.e or die "File $filename already exists. Exiting.";

	my @lines = TEMPLATE.IO.lines;
	@lines = @lines.map(-> $line {
		my $temp = $line.subst("\"$tag\"", "\"$challenge_name\"", :g);
		$temp = $temp.subst($tag, $padded_day);
	});
	
	my $fh = open $filename, :w;
	for @lines -> $line {
		$fh.say($line);
	}
	$fh.close;

    $filename
}

sub addToProgram(Int $day, Str $challenge_name) {
	my $padded_day = pad_day($day);

    my $fh = open PROGRAM, :a;
	$fh.say("solveDay$padded_day true |> ignore   // $challenge_name");
	$fh.close;

}

sub addToFSProj(Str $filename) {
    my @lines = PROJECT.IO.lines;
    my $grid = "<Compile Include=\"AoCGrid.fs\" />";
    my $new_line = "    <Compile Include=\"$filename\" />";
	@lines = @lines.map(-> $line {
		my $temp = $line.subst($grid, "$grid\n$new_line", :g);
		$temp;
	});
	
	my $fh = open PROJECT, :w;
	for @lines -> $line {
		$fh.say($line);
	}
	$fh.close;

}
