#!/usr/bin/perl -w
use strict;

# TODO: parse this from the file (retract_length)
my @retractLen = (1, 1);

# This should be 34 for the FFCP
my $nozzleDistance = 34;

my $travelFeedRate = 8400;
my $wipeFeedRate = 4000;
my $layer1FeedRate = 1200;
my $innerFeedRate = 1200;
my $outerFeedRate = 1800;
my $retractFeedRate = 1800;
# The distance between the center of the priming tower (which has a radius of 6mm), and the nearest coordinate that occurs in the print. This should be at least 6 mm.
my $squareMargin = 8;

# Optional time to let the nozzles sit idle in between the tool change and priming the active nozzle.
# Set to 0 to disable.
my $dwell = 0;

# Layer 1 coordinates were generated for a 0.25mm layer, with a 0.4mm nozzle, printing 1.75mm filament at 20mm/s, 0.6mm width.
my @squareLayer1Travels = (
[0.237, 0.263],
[0.783, -0.283],
[1.329, -0.829],
[1.876, -1.376],
[2.422, -1.922],
[2.968, -2.468],
[3.515, -3.015],
[4.061, -3.561],
[4.607, -4.107],
[5.154, -4.654],
[5.700, -5.200]
);
my @squareLayer1Coords = (
[[0.237, 0.737, 0.02686], [-0.237, 0.737, 0.05372], [-0.237, 0.263, 0.08058], [0.177, 0.263, 0.10404]],
[[0.783, 1.283, 0.19295], [-0.783, 1.283, 0.28186], [-0.783, -0.283, 0.37077], [0.723, -0.283, 0.45627]],
[[1.329, 1.829, 0.60724], [-1.329, 1.829, 0.75820], [-1.329, -0.829, 0.90916], [1.269, -0.829, 1.05671]],
[[1.876, 2.376, 1.26973], [-1.876, 2.376, 1.48274], [-1.876, -1.376, 1.69575], [1.816, -1.376, 1.90535]],
[[2.422, 2.922, 2.18042], [-2.422, 2.922, 2.45548], [-2.422, -1.922, 2.73054], [2.362, -1.922, 3.00220]],
[[2.968, 3.468, 3.33931], [-2.968, 3.468, 3.67642], [-2.968, -2.468, 4.01354], [2.908, -2.468, 4.34724]],
[[3.515, 4.015, 4.74641], [-3.515, 4.015, 5.14557], [-3.515, -3.015, 5.54473], [3.455, -3.015, 5.94049]],
[[4.061, 4.561, 6.40170], [-4.061, 4.561, 6.86292], [-4.061, -3.561, 7.32413], [4.001, -3.561, 7.78194]],
[[4.607, 5.107, 8.30520], [-4.607, 5.107, 8.82846], [-4.607, -4.107, 9.35173], [4.547, -4.107, 9.87159]],
[[5.154, 5.654, 10.45690], [-5.154, 5.654, 11.04222], [-5.154, -4.654, 11.62753], [5.094, -4.654, 12.20944]],
[[5.700, 6.200, 12.85680], [-5.700, 6.200, 13.50417], [-5.700, -5.200, 14.15153], [5.640, -5.200, 14.79549]]
);

# Coordinates were generated for a 0.2mm layer, with a 0.4mm nozzle, printing 1.75mm filament at 20mm/s 0.6mm width (inner) and 30; 0.4 (outer).
my @squareTravels = (
[0.329, 0.171],
[0.886, -0.386],
[1.443, -0.943],
[2.000, -1.500],
[2.558, -2.058],
[3.115, -2.615],
[3.672, -3.172],
[4.229, -3.729],
[4.786, -4.286],
[5.343, -4.843],
[5.800, -5.300]
);
my @squareCoords = (
[[0.329, 0.829, 0.03050], [-0.329, 0.829, 0.06100], [-0.329, 0.171, 0.09150], [0.269, 0.171, 0.11922]],
[[0.886, 1.386, 0.20132], [-0.886, 1.386, 0.28343], [-0.886, -0.386, 0.36554], [0.826, -0.386, 0.44487]],
[[1.443, 1.943, 0.57859], [-1.443, 1.943, 0.71230], [-1.443, -0.943, 0.84602], [1.383, -0.943, 0.97696]],
[[2.000, 2.500, 1.16229], [-2.000, 2.500, 1.34761], [-2.000, -1.500, 1.53294], [1.940, -1.500, 1.71549]],
[[2.558, 3.058, 1.95242], [-2.558, 3.058, 2.18936], [-2.558, -2.058, 2.42629], [2.498, -2.058, 2.66045]],
[[3.115, 3.615, 2.94900], [-3.115, 3.615, 3.23754], [-3.115, -2.615, 3.52609], [3.055, -2.615, 3.81185]],
[[3.672, 4.172, 4.15201], [-3.672, 4.172, 4.49216], [-3.672, -3.172, 4.83232], [3.612, -3.172, 5.16969]],
[[4.229, 4.729, 5.56145], [-4.229, 4.729, 5.95322], [-4.229, -3.729, 6.34498], [4.169, -3.729, 6.73397]],
[[4.786, 5.286, 7.17734], [-4.786, 5.286, 7.62071], [-4.786, -4.286, 8.06409], [4.726, -4.286, 8.50468]],
[[5.343, 5.843, 8.99966], [-5.343, 5.843, 9.49465], [-5.343, -4.843, 9.98963], [5.283, -4.843, 10.48183]],
[[5.800, 6.300, 10.82625], [-5.800, 6.300, 11.17067], [-5.800, -5.300, 11.51509], [5.740, -5.300, 11.85772]]
);


###### MAIN ######
my $inFile = shift;
die "Need input file as argument!\n" if(!$inFile);
# TODO: derive these from the parameters. Also need a custom scale for first layer!
my @extruScale = (1, 1);

my ($minX, $minY, $maxX, $maxY, $highestToolChange) = findPrintBounds($inFile);
print STDERR "Found XY bounds as ${minX}~${maxX}, ${minY}~${maxY}\n"; #DEBUG
my ($squareX, $squareY) = (($minX + $maxX)/2, $maxY + $squareMargin);

open(my $fHandle, '<', $inFile) or die "FAIL: cannot read file: $!";
my ($header, $inToolChangeCode) = (1, 0);
my ($currentZ, $activeTool) = (0, 0);
my ($layerNumber, $toolChangesThisLayer) = (0, 0);
my @originalE = (0, 0);  # How much was extruded by the original file at the current input line.
my @offsetE = (0, 0);    # The offset we're adding, i.e. how much extra filament my extra code has pushed out
my @retracted = (0, 0);  # How far the extruders are currently retracted (regardless of done by the original code, or mine). These values can only be negative or 0.

my @output;
my $lineNumber = 0;

foreach my $line (<$fHandle>) {
	$lineNumber++;
	chomp($line);
	if($header) {
		$header = 0 if($line =~ /;\s*\@body(\s+|$)/);
		push(@output, $line);
		next;
	}

	if($line =~ /^G1 X(\S+) Y(\S+) E(\S+)($|;.*| .*)/) {  # Print move: transform the E coordinate
		my ($x, $y, $e, $extra) = ($1, $2, $3, $4);
		$extra = '' if(! defined($extra));
		if($retracted[$activeTool]) {
			# The priming code retracted the nozzle (or something is fishy about the original code).
			push(@output, doRetractMove(-$retracted[$activeTool]) .' ; UNRETRACT INSERTED');
		}
		push(@output, sprintf('G1 X%s Y%s E%.5f%s', $x, $y, $e + $offsetE[$activeTool], $extra));
		$originalE[$activeTool] = $e;
	}
	elsif($line =~ /^G1 E(\S+) (.*)/) {  # Retract or unretract
		my ($e, $extra) = ($1, $2);
		my $move = $e - ($originalE[$activeTool] + $retracted[$activeTool]);
		my $extraLength = $e - $originalE[$activeTool];  # positive if extra length on unretract is used
		$extraLength = 0 if($extraLength < 0);
		$originalE[$activeTool] = $e if($e > $originalE[$activeTool]);  # necessary if extraLength > 0

		if($move > 0) {
			# Assumption: the code will never try something exotic like a partial unretract.
			# If this is an unretract move, it must be a complete unretract.
			$move = -$retracted[$activeTool] + $extraLength;
		}
		elsif($move < $retracted[$activeTool]) {
			# If it is a retract move and we're already retracted, ignore unless the retract is deeper,
			# in that case retract further.
			$move += -$retracted[$activeTool];
		}
		else {
			$move = 0;
		}
		$retracted[$activeTool] += $move;
		$retracted[$activeTool] = 0 if($retracted[$activeTool] > 0);
		push(@output, sprintf('G1 E%.5f %s', $e + $offsetE[$activeTool], $extra)) if($move);
	}
	elsif($line =~ /^T(0|1)/) {  # Tool change
		my $previousExtruder = $activeTool;
		$activeTool = $1;
		if($previousExtruder == $activeTool) {
			print STDERR "WARNING: tool change to same tool detected at line ${lineNumber}, ignoring\n";
			next;
		}

		if($toolChangesThisLayer > 0) {
			die "FATAL: more than one tool change detected per layer, this is not supported (line ${lineNumber})\n";
		}

		push(@output, '; - - - - - START PRIMING CHANGED NOZZLE - - - - -');
		# Move to the tower
		push(@output, sprintf('G1 X%.3f Y%.3f %d', $squareX, $squareY, $travelFeedRate));
		# Do the tool swap. Use workaround to do the move at a reasonable speed, because it is not accelerated.
		push(@output, ('G1 F5000; speed for tool change.', "T${activeTool}; do actual tool swap", 'G4 P0; flush pipeline'));
		push(@output, 'G4 P'. int(1000 * $dwell) .' ; wait') if($dwell);

		# Unretract from any last tool change retraction
		push(@output, doRetractMove(-$retracted[$activeTool]) .' ; unretract') if($retracted[$activeTool]);
		my $isLayer1 = ($layerNumber == 1);
		# Print a full tower layer to prime the nozzle.
		push(@output, '; Print priming tower (full)');
		$offsetE[$activeTool] +=
			generateSquare(\@output, $squareX, $squareY,
			               $originalE[$activeTool] + $offsetE[$activeTool],
			               $extruScale[$activeTool], $isLayer1, 0);
		# Do a normal retract. The logic above will ensure an unretract when the normal code resumes.
		push(@output, doRetractMove(-$retractLen[$activeTool]));
		# Wipe the ooze from the deactivated nozzle
		push(@output, sprintf('G1 X%.3f Y%.3f %d', $squareX, $squareY, $travelFeedRate));
		my $move = $nozzleDistance;
		$move *= -1 if($activeTool == 1);
		push(@output, sprintf('G1 X%.3f Y%.3f %d ; wipe nozzle on tower', $squareX + $move, $squareY, $wipeFeedRate));
		push(@output, '; - - - - - END PRIMING CHANGED NOZZLE - - - - -');
		$toolChangesThisLayer++;
	}
	elsif($line =~ /^;- - - Custom G-code for tool change/) {
		$inToolChangeCode = 1;
	}
	elsif($line =~ /^;- - - End custom G-code for tool change/ ) {
		$inToolChangeCode = 0;
	}
	elsif($line =~ /^G1 Z(\S+)([ ;]|$)/) {  # Layer change
		my $z = $1;
		# For some reason Slic3r repeats G1 Zz commands even if the layer does not change.
		if($z != $currentZ) {
			# Do not act opon the very first Z command, because it signals the start of the first layer.
			if($layerNumber > 0 && !$toolChangesThisLayer && $currentZ <= $highestToolChange) {
				push(@output, '; - - - - - START MAINTAINING PRIMING TOWER - - - - -');
				# Retract for the travel move
				push(@output, doRetractMove(-$retractLen[$activeTool])) if(! $retracted[$activeTool]);
				# Move to the tower
				push(@output, sprintf('G1 X%.3f Y%.3f %d', $squareX, $squareY, $travelFeedRate));
				my $isLayer1 = ($layerNumber == 1);
				# Unretract
				push(@output, doRetractMove(-$retracted[$activeTool]) .' ; unretract');
				# Print a minimal tower layer to ensure continuity of the tower.
				push(@output, '; Print priming tower (hollow)');
				$offsetE[$activeTool] +=
					generateSquare(\@output, $squareX, $squareY,
					               $originalE[$activeTool] + $offsetE[$activeTool],
								   $extruScale[$activeTool], $isLayer1, 2);
				# Retract before handing over control to the original code again.
				# The above logic will ensure that an unretract is added when resuming
				# printing, and additional attempts at retracts are ignored.
				push(@output, doRetractMove(-$retractLen[$activeTool]));
				push(@output, '; - - - - - END MAINTAINING PRIMING TOWER - - - - -');
			}
			$layerNumber++;
			$currentZ = $z;
			$toolChangesThisLayer = 0;
		}
		push(@output, $line);
	}
	elsif(! $inToolChangeCode) {  # Anything else, except lines in tool change block we're replacing
		push(@output, $line);
	}
}

print join("\n", @output) ."\n";



###### SUBROUTINES ######
sub generateSquare
# Generate G-code for printing a square consisting of perimeters only, starting at the center.
# All perimeters except the outer one are printed at the inner feed rate, unless maxPerim is non-zero.
# The 'pos' variables specify the offset, and scaleE allows to scale the E coordinates.
# If isLayer1 is true, first layer coordinates and speed will be used.
# If maxPerim is non-zero, only that many outer perimeters will be printed at the outer perimeter speed.
# Return value is the total increase in E coordinate.
{
	my ($outRef, $posX, $posY, $posE, $scaleE, $isLayer1, $maxPerim) = @_;
	my (@travels, @coords);
	my ($innerFR, $outerFR);
	# Obviously it would be way better to generate the coordinates and E values from scratch, but
	# I hope this will end up implemented in Slic3r, therefore reimplementing part of Slic3r in this
	# temporary script would be a waste of effort.
	if($isLayer1) {
		@travels = @squareLayer1Travels;
		@coords = @squareLayer1Coords;
		($innerFR, $outerFR) = ($layer1FeedRate, $layer1FeedRate);
	}
	else {
		@travels = @squareTravels;
		@coords = @squareCoords;
		($innerFR, $outerFR) = ($innerFeedRate, $outerFeedRate);
	}
	my $shiftE = 0;
	if($maxPerim) {
		# Another kludge due to working with a pre-computed table of coordinates:
		# We need to shift the E coordinates over the distance we skip
		$shiftE = -$coords[$#travels - $maxPerim][-1][2];
		splice(@travels, 0, 1 + $#travels - $maxPerim);
		splice(@coords, 0, 1 + $#coords - $maxPerim);
	}
	for(my $i=0; $i<=$#travels; $i++) {
		my $feedRate = $innerFR;
		$feedRate = $outerFR if($maxPerim || $i == $#travels);
		push(@{$outRef}, sprintf('G1 X%.3f Y%.3f F%.0f',
		                         $travels[$i][0] + $posX,
		                         $travels[$i][1] + $posY,
		                         $travelFeedRate));
		push(@{$outRef}, "G1 F${feedRate}");
		foreach my $coord (@{$coords[$i]}) {
			push(@{$outRef}, sprintf('G1 X%.3f Y%.3f E%.5f',
			                         ${$coord}[0] + $posX,
			                         ${$coord}[1] + $posY,
			                         ($shiftE + ${$coord}[2]) * $scaleE + $posE));
		}
	}

	return ($shiftE + $coords[-1][-1][2]) * $scaleE;
}

sub findPrintBounds
{
	my $fName = shift;
	open(my $fHandle, '<', $fName) or die "FAIL: cannot read file: $!";
	my ($header, $footer) = (1, 0);
	my ($minX, $minY, $maxX, $maxY) = (10000, 10000, -10000, -10000);
	my $highestToolChange = 0;
	my $currentZ = 0;
	foreach my $line (<$fHandle>) {
		chomp($line);
		if($header) {
			$header = 0 if($line =~ /;\s*\@body(\s+|$)/);
			next;
		}
		#G1 X-15.741 Y-12.333 F8400.000
		#G1 X-13.174 Y-12.746 E0.15803
		#G1 Z0.650 F8400.000  <- layer change
		#;- - - Custom G-code for tool change  <- tool change ??? or use T{0,1}? TODO
		if($line =~ /^G1 X(\S+) Y(\S+) /) {  # Regular print or travel move
			$minX = $1 if($1 < $minX);
			$maxX = $1 if($1 > $maxX);
			$minY = $2 if($2 < $minY);
			$maxY = $2 if($2 > $maxY);
		}
		elsif($line =~ /^G1 Z(\S+)([ ;]|$)/) {  # Layer change
			$currentZ = $1;
		}
		elsif($line =~ /^;- - - Custom G-code for tool change/) {
			$highestToolChange = $currentZ;
		}
		elsif($line =~ /^;- - - Custom finish printing G-code/) {
			$footer = 1;
			last; # TODO: parse footer
		}
	}
	return ($minX, $minY, $maxX, $maxY, $highestToolChange);
}

sub doRetractMove
# Generates code for a retract (negative argument) or unretract (positive) move,
# and updates the retract state of the current extruder.
# The originalE and offsetE values are not updated, that is the responsibility
# of the calling code.
{
	my $retractDist = shift;
	my $newE = $originalE[$activeTool] + $offsetE[$activeTool] + $retracted[$activeTool] + $retractDist;
	# This code allows partial unretracts, although they do not make any sense and should never occur.
	$retracted[$activeTool] += $retractDist;
	$retracted[$activeTool] = 0 if($retracted[$activeTool] > 0);

	return sprintf('G1 E%.5f F%d', $newE, $retractFeedRate);
}