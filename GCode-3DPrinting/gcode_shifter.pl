#!/usr/bin/perl -w
use strict;

sub printUsage
{
	print "$0 file x [y [e]]\n".
	      "  Shift G-code coordinates in the file according to x, y, and e ofsets.\n".
	      "  Any G1 command will be affected, so you'll want to cut out the relevant part.\n";
}

my $fName = shift;
my $xShift = shift;
my $yShift = shift;
my $eShift = shift;
if(!$fName || !defined($xShift)) {
	printUsage();
	exit(2);
}

$yShift = 0 if(!$yShift);
$eShift = 0 if(!$eShift);


open(my $fHandle, '<', $fName) or die "FAIL: cannot read file: $!";

my $lineNumber = 0;
foreach my $line (<$fHandle>) {
	$lineNumber++;
	chomp($line);

	if($line =~ /^G1 X(\S+) Y(\S+) E(\S+)($|\s*;.*|\s+)/) {  # print move
		my ($x, $y, $e, $fluff) = ($1, $2, $3, $4);
		$fluff = '' if(!defined($fluff));
		printf("G1 X%.3f Y%.3f E%.5f%s\n", $x+$xShift, $y+$yShift, $e+$eShift, $fluff);
	}
	elsif($line =~ /^G1 X(\S+) Y(\S+) F(.*)/) {  # travel move
		my ($x, $y, $fluff) = ($1, $2, $3);
		printf("G1 X%.3f Y%.3f F%s\n", $x+$xShift, $y+$yShift, $fluff);
	}
	else {
		print "$line\n";
	}
}
close($fHandle);
