#!/usr/bin/perl -w
use strict;

# This should be 34 for the FFCP
my $nozzleDistance = 34;

# The distance between the center of the priming tower (which has a radius of 6mm), and the nearest coordinate that occurs in the print. This should be at least 10 mm.
my $squareMargin = 12;

# Optional time to let the nozzles sit idle in between the tool change and priming the active nozzle.
# Set to 0 to disable.
my $dwell = 5;

# Number of perimeters to print while printing a non-priming layer of the priming tower.
# 2 perimeters should be sufficient. Set to 0 to print a full layer.
my $towerMaintainPerimeters = 2;


# These values will be overridden with those found in the file.
my @retractLen = (1, 1);
my @retractLenTC = (3, 3);

# These values will be parsed from the file unless the names have changed, and the scale factors
# will be computed using these original values, which represent the values with which the
# coordinates below were calculated.
my ($layer_height, $first_layer_height) = (0.2, 0.25);
my @filament_diameters = (1.75, 1.75);
my @nozzle_diameters = (0.4, 0.4);
my @extrusion_multipliers = (1.0, 1.0);

# I might also want to override some of these with values from the file, but these should be sensible values for all cases.
my $travelFeedRate = 8400;
my $retractFeedRate = 1800;
my $wipeFeedRate = 4000;
my $layer1FeedRate = 1200;
my $innerFeedRate = 1200;
my $outerFeedRate = 1200;

# Layer 1 coordinates were generated for a 0.25mm layer, with a 0.4mm nozzle, printing 1.75mm filament at 20mm/s, 0.6mm width.
my @squareLayer1Travels = (
[2.497, -1.997],
[3.044, -2.544],
[3.590, -3.090],
[4.137, -3.637],
[4.683, -4.183],
[5.229, -4.729],
[5.776, -5.276],
[6.322, -5.822],
[6.868, -6.368],
[7.415, -6.915],
[7.961, -7.461],
[8.507, -8.007],
[9.054, -8.554],
[9.600, -9.100]
);
my @squareLayer1Coords = (
[[2.497, 2.997, 0.28364], [-2.497, 2.997, 0.56729], [-2.497, -1.997, 0.85093], [2.437, -1.997, 1.13117]],
[[3.044, 3.544, 1.47686], [-3.044, 3.544, 1.82256], [-3.044, -2.544, 2.16825], [2.984, -2.544, 2.51054]],
[[3.590, 4.090, 2.91828], [-3.590, 4.090, 3.32602], [-3.590, -3.090, 3.73377], [3.530, -3.090, 4.13811]],
[[4.137, 4.637, 4.60790], [-4.137, 4.637, 5.07770], [-4.137, -3.637, 5.54749], [4.077, -3.637, 6.01388]],
[[4.683, 5.183, 6.54572], [-4.683, 5.183, 7.07757], [-4.683, -4.183, 7.60941], [4.623, -4.183, 8.13785]],
[[5.229, 5.729, 8.73175], [-5.229, 5.729, 9.32564], [-5.229, -4.729, 9.91954], [5.169, -4.729, 10.51003]],
[[5.776, 6.276, 11.16597], [-5.776, 6.276, 11.82192], [-5.776, -5.276, 12.47787], [5.716, -5.276, 13.13040]],
[[6.322, 6.822, 13.84840], [-6.322, 6.822, 14.56640], [-6.322, -5.822, 15.28439], [6.262, -5.822, 15.99898]],
[[6.868, 7.368, 16.77903], [-6.868, 7.368, 17.55908], [-6.868, -6.368, 18.33912], [6.808, -6.368, 19.11576]],
[[7.415, 7.915, 19.95786], [-7.415, 7.915, 20.79996], [-7.415, -6.915, 21.64206], [7.355, -6.915, 22.48075]],
[[7.961, 8.461, 23.38489], [-7.961, 8.461, 24.28904], [-7.961, -7.461, 25.19319], [7.901, -7.461, 26.09393]],
[[8.507, 9.007, 27.06013], [-8.507, 9.007, 28.02633], [-8.507, -8.007, 28.99252], [8.447, -8.007, 29.95532]],
[[9.054, 9.554, 30.98356], [-9.054, 9.554, 32.01181], [-9.054, -8.554, 33.04006], [8.994, -8.554, 34.06490]],
[[9.600, 10.100, 35.15520], [-9.600, 10.100, 36.24550], [-9.600, -9.100, 37.33580], [9.540, -9.100, 38.42269]]
);

# Coordinates were generated for a 0.2mm layer, with a 0.4mm nozzle, printing 1.75mm filament at 22mm/s, 0.6mm width.
my @squareTravels = (
[-3.043, -2.543],
[-3.600, -3.100],
[-4.158, -3.658],
[-4.715, -4.215],
[-5.272, -4.772],
[-5.829, -5.329],
[-6.386, -5.886],
[-6.943, -6.443],
[-7.500, -7.000]
);
my @squareCoords = (
[[3.043, -2.543, 0.28194], [3.043, 3.543, 0.56389], [-3.043, 3.543, 0.84584], [-3.043, -2.483, 1.12500]],
[[3.600, -3.100, 1.45856], [3.600, 4.100, 1.79211], [-3.600, 4.100, 2.12567], [-3.600, -3.040, 2.45644]],
[[4.158, -3.658, 2.84161], [4.158, 4.658, 3.22677], [-4.158, 4.658, 3.61194], [-4.158, -3.598, 3.99432]],
[[4.715, -4.215, 4.43109], [4.715, 5.215, 4.86787], [-4.715, 5.215, 5.30464], [-4.715, -4.155, 5.73864]],
[[5.272, -4.772, 6.22702], [5.272, 5.772, 6.71540], [-5.272, 5.772, 7.20378], [-5.272, -4.712, 7.68939]],
[[5.829, -5.329, 8.22938], [5.829, 6.329, 8.76937], [-5.829, 6.329, 9.30936], [-5.829, -5.269, 9.84658]],
[[6.386, -5.886, 10.43818], [6.386, 6.886, 11.02978], [-6.386, 6.886, 11.62138], [-6.386, -5.826, 12.21020]],
[[6.943, -6.443, 12.85341], [6.943, 7.443, 13.49663], [-6.943, 7.443, 14.13984], [-6.943, -6.383, 14.78027]],
[[7.500, -7.000, 15.47509], [7.500, 8.000, 16.16991], [-7.500, 8.000, 16.86473], [-7.500, -6.940, 17.55677]]
);


###### MAIN ######
my $inFile = shift;
die "Need input file as argument!\n" if(!$inFile);

my @extruScale = (1, 1);
my @extruScaleL1 = (1, 1);
my (@header, @footer, @layerHeights);
# Chunks of code grouped per tool and per layer height. Each layer height may contain multiple groups of code blocks. The key is "${tool}_${layerheight}".
my %toolLayers;

my ($minX, $minY, $maxX, $maxY, $highestToolChange) = parseInputFile($inFile, \@header, \@footer, \%toolLayers, \@layerHeights);
print STDERR "Found XY bounds as ${minX}~${maxX}, ${minY}~${maxY}\n"; #DEBUG
print STDERR "Normal extrusion scale factors:  $extruScale[0], $extruScale[1]\n"; #DEBUG
print STDERR "Layer 1 extrusion scale factors: $extruScaleL1[0], $extruScaleL1[1]\n"; #DEBUG
my ($squareX, $squareY) = (($minX + $maxX)/2, $maxY + $squareMargin);

# Scale factor = layer_height/0.2 * filament_diameter/1.75 * nozzle_diameter/0.4 * extrusion_multiplier
# Layer 1 SF = first_layer_height/0.25 * filament_diameter/1.75 * nozzle_diameter/0.4 * extrusion_multiplier

# Preprocess the code blocks: wipe any retract command or irrelevant junk (comments, whitespace) at
# the very end, because we'll be replacing these with our own retracts. (Moreover, Slic3r first
# changes layer and then retracts, so there will be blocks that only have a retract in them.)
foreach my $layerZ (@layerHeights) {
	foreach my $key ("0_${layerZ}", "1_${layerZ}") {
		my $blockListRef = $toolLayers{$key};
		if($blockListRef) {
			my @cleanedBlocks;
			foreach my $blockRef (@{$blockListRef}) {
				while(@{$blockRef} && $$blockRef[-1] =~ /^(G1 E\S+ |\s*;|\s*$)/) {
					pop(@{$blockRef});  # zap final retract, empty lines, and comment junk
				}
				push(@cleanedBlocks, $blockRef) if(@{$blockRef});
			}
			if(@cleanedBlocks) {
				$toolLayers{$key} = \@cleanedBlocks;
			}
			else {
				delete $toolLayers{$key};
			}
		}
	}
}

# Assumption: we always start with T0 and always print a skirt on layer 1.
# Even if there is no T0 material in the first layer, Slic3r will print a skirt with T0 and then swap tools.
# If this ever changes or someone deems a skirt unnecessary, this script will break.
my $activeTool = 0;
my @originalE = (0, 0);  # How much was extruded by the original file at the current input line.
my @offsetE   = (0, 0);  # The offset we're adding, i.e. how much extra filament my extra code has pushed out
my @retracted = (0, -1);  # How far the extruders are currently retracted (regardless of done by the original code, or mine). These values can only be negative or 0. Mind that we assume that T1 starts out retracted, this should be valid when using my start G-code and considering the way Slic3r handles dualstrusion.

# Reassemble the file in optimal order and insert retractions and priming code where necessary.
# For every layer:
# Check what tools are used
# If $activeTool is in this layer, start printing with it.
#   Remove any retract moves at the end of each block and replace with normal or TC retract.
#     Normal retract if there is another block, or no other tool block follows in this or the next layer.
# If there is no other tool in this layer and this tool is in the next layer, top up priming tower.
#   Else: swap and prime, and print any blocks of the other tool in this layer.
my @output;
for(my $layerId = 0; $layerId <= $#layerHeights; $layerId++) {
	my $isLayer1 = ($layerId == 0);
	my $layerZ = $layerHeights[$layerId];
	my $nextLayerZ = ($layerId < $#layerHeights ? $layerHeights[$layerId + 1] : 0);

	print STDERR "LAYER ${layerId}: ${layerZ}\n"; #DEBUG
	# Check what tools are active in this layer and the next.
	my (@activeToolBlocks, @otherToolBlocks);
	my $otherTool = ($activeTool == 0 ? 1 : 0);
	if($toolLayers{"${activeTool}_${layerZ}"}) {
		foreach my $ref (@{$toolLayers{"${activeTool}_${layerZ}"}}) {
			push(@activeToolBlocks, $ref);
		}
	}
	if($toolLayers{"${otherTool}_${layerZ}"}) {
		foreach my $ref (@{$toolLayers{"${otherTool}_${layerZ}"}}) {
			push(@otherToolBlocks, $ref);
		}
	}
	# Optimisation: if the next layer will start with the other tool, do not top up the tower
	# but prime the next tool instead.
	my $toolStillActiveNextLayer = defined($toolLayers{"${activeTool}_${nextLayerZ}"});
	
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract') unless($retracted[$activeTool]);
	push(@output, sprintf('G1 Z%.3f F%d ; LAYER %d', $layerZ, $travelFeedRate, 1 + $layerId));
	if(@activeToolBlocks) {
		print STDERR "  CONTINUE WITH ACTIVE TOOL $activeTool: ". (1+$#activeToolBlocks) ." BLOCKS\n"; #DEBUG
		for(my $i=0; $i<=$#activeToolBlocks; $i++) {
			outputTransformedCode($activeToolBlocks[$i]);
			if($i < $#activeToolBlocks) {
				push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract');
			}
		}
	}
	# Because Slic3r does tool changes at the start of a layer, our previous detection of
	# highestToolChange may be off by one due to the optimisation.
	if($layerZ <= $highestToolChange && !($layerZ == $highestToolChange && !@otherToolBlocks)) {
		if(!@otherToolBlocks && $toolStillActiveNextLayer) {
			print STDERR "  TOP UP PRIMING TOWER\n"; #DEBUG
			outputTopUpPrimingTower($isLayer1);
		}
		else {
			print STDERR "  SWITCH TO OTHER TOOL $otherTool\n"; #DEBUG
			print STDERR "  AND PRINT ". (1+$#otherToolBlocks) ." BLOCKS\n"; #DEBUG
			push(@output, doRetractMove(-$retractLenTC[$activeTool]) .' ; tool change retract');
			outputToolChangeAndPrime($isLayer1);
			for(my $i=0; $i<=$#otherToolBlocks; $i++) {
				outputTransformedCode($otherToolBlocks[$i]);
				if($i < $#otherToolBlocks) {
					push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract');
				}
			}
		}
	}
	next;
}

print join("\n", (@header, @output, @footer)) ."\n";



###### SUBROUTINES ######
sub parseInputFile
# Chop up the file into header, footer, and code blocks grouped per layer and per tool.
# Returns print bounds and layer height at which the last tool change occurs.
# Requires @header, @footer, @layerHeights, and %toolLayers to be defined.
{
	my $fName = shift;
	open(my $fHandle, '<', $fName) or die "FAIL: cannot read file: $!";

	my ($isHeaderPart1, $isHeaderPart2, $isFooter, $inToolChangeCode) = (1, 0, 0, 0);
	my ($currentZ, $layerNumber, $activeTool) = (0) x 3;
	# This code will fail for printers with a print bed larger than 65 metres. Too bad.
	my ($minX, $minY, $maxX, $maxY) = (32768, 32768, -32768, -32768);
	my $highestToolChange = 0;

	# Reference to the anonymous array inside %toolLayers to which we're currently appending code lines
	my $toolLayerRef;
	my $lineNumber = 0;

	my ($layerHeightOK, $firstLayerHOK, $filaDiamOK, $nozzleDiamOK, $extruMultiOK) = (0) x 5;

	foreach my $line (<$fHandle>) {
		$lineNumber++;
		chomp($line);

		if($isHeaderPart1) {
			# First unconditionally treat everything up to the "@body" marker as header.
			if($line =~ /;\@body(\s|;|$)/) {
				$isHeaderPart1 = 0;
				$isHeaderPart2 = 1;
			}
			push(@header, $line);
			next;
		}
		elsif($isHeaderPart2) {
			# Then look for the point where the main code has 'moved' to the first layer height.
			if($line =~ /^G1 Z(\S+)([ ;]|$)/) {
				$isHeaderPart2 = 0;
				# Do not skip, leave it up to the layer change statement below to handle this.
			}
			else {
				push(@header, $line);
				next;
			}
		}
		elsif($isFooter || $line =~ /^;- - - Custom finish printing G-code/) {
			$isFooter = 1;
			push(@footer, $line);
			# Use the OK flags to avoid adjusting the factors multiple times, should the file
			# contain copy-pasted junk.
			if($line =~ /^; layer_height = (.*)/ && !$layerHeightOK) {
				my $factor = $1/$layer_height;
				@extruScale = ($extruScale[0] * $factor, $extruScale[1] * $factor);
				$layerHeightOK = 1;
			}
			elsif($line =~ /^; first_layer_height = (.*)/ && !$firstLayerHOK) {
				my $factor = $1/$first_layer_height;
				@extruScaleL1 = ($extruScaleL1[0] * $factor, $extruScaleL1[1] * $factor);
				$firstLayerHOK = 1;
			}
			elsif($line =~ /^; filament_diameter = (.*)/ && !$filaDiamOK) {
				my ($dia0, $dia1) = split(/,/, $1);
				my ($factor0, $factor1) = ($dia0/$filament_diameters[0],
				                           $dia1/$filament_diameters[1]);
				@extruScale = ($extruScale[0] * $factor0, $extruScale[1] * $factor1);
				@extruScaleL1 = ($extruScaleL1[0] * $factor0, $extruScaleL1[1] * $factor1);
				$filaDiamOK = 1;
			}
			elsif($line =~ /^; nozzle_diameter = (.*)/ && !$nozzleDiamOK) {
				my ($dia0, $dia1) = split(/,/, $1);
				my ($factor0, $factor1) = ($dia0/$nozzle_diameters[0],
				                           $dia1/$nozzle_diameters[1]);
				@extruScale = ($extruScale[0] * $factor0, $extruScale[1] * $factor1);
				@extruScaleL1 = ($extruScaleL1[0] * $factor0, $extruScaleL1[1] * $factor1);
				$nozzleDiamOK = 1;
			}
			elsif($line =~ /^; extrusion_multiplier = (.*)/ && !$extruMultiOK) {
				my ($mul0, $mul1) = split(/,/, $1);
				my ($factor0, $factor1) = ($mul0/$extrusion_multipliers[0],
				                           $mul1/$extrusion_multipliers[1]);
				@extruScale = ($extruScale[0] * $factor0, $extruScale[1] * $factor1);
				@extruScaleL1 = ($extruScaleL1[0] * $factor0, $extruScaleL1[1] * $factor1);
				$extruMultiOK = 1;
			}
			elsif($line =~ /^; retract_length = (.*)/ ) {
				@retractLen = split(/,/, $1);
			}
			elsif($line =~ /^; retract_length_toolchange = (.*)/ ) {
				@retractLenTC = split(/,/, $1);
			}
			next;
		}

		if($line =~ /^G1 X(\S+) Y(\S+) /) {  # Regular print or travel move
			$minX = $1 if($1 < $minX);
			$maxX = $1 if($1 > $maxX);
			$minY = $2 if($2 < $minY);
			$maxY = $2 if($2 > $maxY);
		}
		elsif($line =~ /^;- - - Custom G-code for tool change/) {
			# Skip these blocks because we're going to replace them entirely
			$inToolChangeCode = 1;
			next;
		}
		elsif($line =~ /^;- - - End custom G-code for tool change/ ) {
			$inToolChangeCode = 0;
			next;
		}

		if($line =~ /^T(0|1)/) {  # Tool change
			my $previousTool = $activeTool;
			$activeTool = $1;
			die "ERROR: more than 2 tools not supported.\n" if($activeTool > 1);
			if($previousTool == $activeTool) {
				print STDERR "WARNING: tool change to same tool detected at line ${lineNumber}, ignoring\n";
				next;
			}
			$toolLayers{"${activeTool}_${currentZ}"} = [] if(!defined($toolLayers{"${activeTool}_${currentZ}"}));
			push($toolLayers{"${activeTool}_${currentZ}"}, []);  # Start a new block
			$toolLayerRef = $toolLayers{"${activeTool}_${currentZ}"}[-1];
			$highestToolChange = $currentZ;
			next;
		}
		elsif($line =~ /^G1 Z(\S+)([ ;]|$)/) {  # Layer change
			my $z = $1;
			# For some reason Slic3r repeats G1 Zz commands even if the layer does not change.
			if($z != $currentZ) {
				$layerNumber++;
				$currentZ = 1.0 * $z;
				push(@layerHeights, $currentZ);
				$toolLayers{"${activeTool}_${currentZ}"} = [] if(!defined($toolLayers{"${activeTool}_${currentZ}"}));
				push($toolLayers{"${activeTool}_${currentZ}"}, []);  # Start a new block
				$toolLayerRef = $toolLayers{"${activeTool}_${currentZ}"}[-1];
			}
			next;
		}

		push(@{$toolLayerRef}, $line) if(!$inToolChangeCode); 
	}
	if(!($layerHeightOK && $firstLayerHOK && $filaDiamOK && $nozzleDiamOK && $extruMultiOK)) {
		print STDERR "WARNING: not all extrusion parameters could be parsed from the file.\nExtrusion values may be wrong. Check the input file!\n";
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
	# If there was extra length on unretract, add it to the offset. This assumes that only my code
	# will use extra length, extra unretract set in Slic3r is not supported!
	if($retracted[$activeTool] > 0) {
		$offsetE[$activeTool] += $retracted[$activeTool];
		$retracted[$activeTool] = 0;
	}

	return sprintf('G1 E%.5f F%d', $newE, $retractFeedRate);
}

sub generateSquare
# Generate G-code for printing a square consisting of perimeters only, starting at the center.
# The extruder may be retracted, it will be unretracted before printing starts.
# All perimeters except the outer one are printed at the inner feed rate, unless maxPerim is non-zero.
# The 'pos' variables specify the offset, and scaleE allows to scale the E coordinates.
# If isLayer1 is true, first layer coordinates and speed will be used.
# If maxPerim is non-zero, only that many outer perimeters will be printed at the outer perimeter speed.
# Return value is the total increase in E coordinate.
{
	my ($posX, $posY, $posE, $scaleE, $isLayer1, $maxPerim) = @_;
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
		push(@output, sprintf('G1 X%.3f Y%.3f F%.0f',
		                      $travels[$i][0] + $posX,
		                      $travels[$i][1] + $posY,
		                      $travelFeedRate));
		push(@output, doRetractMove(-$retracted[$activeTool]) .' ; unretract') if($retracted[$activeTool]);
		push(@output, "G1 F${feedRate}");
		foreach my $coord (@{$coords[$i]}) {
			push(@output, sprintf('G1 X%.3f Y%.3f E%.5f',
			                      ${$coord}[0] + $posX,
			                      ${$coord}[1] + $posY,
			                      ($shiftE + ${$coord}[2]) * $scaleE + $posE));
		}
	}

	return ($shiftE + $coords[-1][-1][2]) * $scaleE;
}

sub outputTransformedCode
# Transforms and appends commands in a block of code to @output, to fit within the optimised
# output file.
{
	my $codeRef = shift;

	foreach my $line (@{$codeRef}) {
		if($line =~ /^G1 X(\S+) Y(\S+) E(\S+)($|;.*|\s.*)/) {
			# Print move: transform the E coordinate
			my ($x, $y, $e, $extra) = ($1, $2, $3, $4);
			$extra = '' if(! defined($extra));
			if($retracted[$activeTool]) {
				# The priming code retracted the nozzle (or something is fishy about the original code).
				push(@output, doRetractMove(-$retracted[$activeTool]) .' ; UNRETRACT INSERTED');
			}
			push(@output, sprintf('G1 X%s Y%s E%.5f%s', $x, $y, $e + $offsetE[$activeTool], $extra));
			$originalE[$activeTool] = $e;
		}
		elsif($line =~ /^G1 F(\S+)($|;.*|\s.*)/) {
			# Feedrate command which should always signal that printing will begin.
			if($retracted[$activeTool]) {
				# The priming code retracted the nozzle (or something is fishy about the original code).
				push(@output, doRetractMove(-$retracted[$activeTool]) .' ; UNRETRACT INSERTED');
			}
			push(@output, $line);
		}
		elsif($line =~ /^G1 E(\S+) (.*)/) {
			# Retract or unretract
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
				# If it is a retract move and we're already retracted, ignore unless the retract
				# is deeper, in that case retract further.
				$move += -$retracted[$activeTool];
			}
			else {
				$move = 0;
			}
			$retracted[$activeTool] += $move;
			$retracted[$activeTool] = 0 if($retracted[$activeTool] > 0);
			push(@output, sprintf('G1 E%.5f %s', $e + $offsetE[$activeTool], $extra)) if($move);
		}
		else {  # Anything else
			push(@output, $line);
		}
	}
}

sub outputToolChangeAndPrime
# Appends commands to @output to perform the tool change and prime the new nozzle.
{
	my $isLayer1 = shift;

	push(@output, '; - - - - - START TOOL CHANGE AND PRIME NOZZLE - - - - -');
	# Move to the tower
	push(@output, sprintf('G1 X%.3f Y%.3f F%d', $squareX, $squareY, $travelFeedRate));
	# Do the tool swap. Use workaround to do the move at a reasonable speed, because it is not accelerated.
	# TODO: I could parse the original tool change code from the file and fill in the template.
	$activeTool = ($activeTool == 0 ? 1 : 0);
	push(@output, ('G1 F5000; speed for tool change.', "T${activeTool}; do actual tool swap", 'G4 P0; flush pipeline'));
	push(@output, 'G4 P'. int(1000 * $dwell) .' ; wait') if($dwell);

	# Unretract from any last tool change retraction
	my $extrusionScale = ($isLayer1 ? $extruScaleL1[$activeTool] : $extruScale[$activeTool]);

	# Print a full tower layer to prime the nozzle.
	push(@output, '; Print priming tower (full)');
	$offsetE[$activeTool] +=
		generateSquare($squareX, $squareY,
		               $originalE[$activeTool] + $offsetE[$activeTool],
		               $extrusionScale, $isLayer1, 0);
	# Do a normal retract. The logic in transformCodeBlock will ensure an unretract when normal code resumes.
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract');
	# Wipe the ooze from the deactivated nozzle
	push(@output, sprintf('G1 X%.3f Y%.3f F%d', $squareX, $squareY, $travelFeedRate));
	my $move = $nozzleDistance;
	$move *= -1 if($activeTool == 1);
	push(@output, sprintf('G1 X%.3f Y%.3f F%d ; wipe nozzle on tower', $squareX + $move, $squareY, $wipeFeedRate));
	push(@output, '; - - - - - END TOOL CHANGE AND PRIME NOZZLE - - - - -');
}

sub outputTopUpPrimingTower
{
	my $isLayer1 = shift;

	push(@output, '; - - - - - START MAINTAINING PRIMING TOWER - - - - -');
	# Retract for the travel move
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract') if(! $retracted[$activeTool]);
	# Don't move to the tower center, the tower code will make the travel move directly to the starting point.
	my $extrusionScale = ($isLayer1 ? $extruScaleL1[$activeTool] : $extruScale[$activeTool]);

	# Print a minimal tower layer to ensure continuity of the tower.
	my $how = $isLayer1 ? 'full' : 'hollow';
	push(@output, "; Print priming tower (${how})");
	my $maxPerim = $isLayer1 ? 0 : $towerMaintainPerimeters;
	$offsetE[$activeTool] +=
		generateSquare($squareX, $squareY,
		               $originalE[$activeTool] + $offsetE[$activeTool],
		               $extrusionScale, $isLayer1, $maxPerim);
	# Retract before handing over control to the original code again.
	# The logic in transformCodeBlock will ensure that an unretract is added when resuming
	# printing, and additional attempts at retracts are ignored.
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract');
	push(@output, '; - - - - - END MAINTAINING PRIMING TOWER - - - - -');
}
