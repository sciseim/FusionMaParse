#!/usr/bin/perl 
use strict;
use Term::ANSIColor;

################################################################################################################################################################
# FusionMapCutoff.pl - this script does something awful.
# By Inge Seim
# 1/2014
################################################################################################################################################################
print color 'blue' ;
print "# ###############################################################################" . "\n" ;
print color 'reset';


print color 'red' ;
# add your threshold (percentage. e.g. 50 for 50%)
print "Please enter your desired chimaera/fusion transcript cutoff" . "\n" ;
print "e.g. 50 for 50%: ";
my $percentagecutoff = <STDIN>; 
chomp $percentagecutoff; # Get rid of newline character at the end
exit 0 if ($percentagecutoff eq ""); # If empty string, exit.
print color 'reset';
system("clear");

################################################################################################################################################################
system("mkdir ./output");
system("rm ./temp.txt");
system("rm ./fusiongeneswithcount.txt");
system("rm ./fusionsAboveThreshold.txt");

system("clear");
################################################################################################################################################################
my $fusiongeneswithcount = "" ;

# want to count the # of samples!
my %counts = ();

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my @sampledata = "" ;
# delete element 0
splice @sampledata, 0, 1;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my @fusionsraw = "" ;
# delete element 0
splice @fusionsraw, 0, 1;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my @fusionsrawunique = "" ;
# delete element 0
splice @fusionsrawunique, 0, 1;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# GROUP
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# open them files!
# my $dir ;
opendir DIR, "./data";
# my @filenames = grep { $_ ne '.' && $_ ne '..' } readdir DIR;
my @filenames = grep(/\.txt$/,readdir(DIR));
closedir DIR;


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# NOW OPEN EACH FILE AND GRAB FUSION GENE DATA
# COUNT UNIQUE FUSION GENES - THAT IS, ONLY LIST A VALUE ONCE!
# $#array gives the index of the last array element 
foreach my $index (0 .. $#filenames) { 
$counts{$_}++ ;
my $filedata = "" ; # call here since it will be recycled
my $filedataname = $filenames[$index] ; # call here since it will be recycled
# print "the filedataname variable is " . $filedataname . "\n" ;   # print the file name
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# open the file!
open (FILE, "./data/$filedataname") ;  #   # e.g. opened once.txt
local $/=undef;  # give me the whole file at once!
chomp ($filedata = (<FILE>)) ; # remove line break

# each file is now open, the entire file is a single string
# retrieve elements from line
my @lineelements1 = split /\n/, $filedata ;  # feed each newline into a new element
splice @lineelements1, 0, 1; # get rid of headers!
#@ print "lineelement 0 is:" . "\n" . $lineelements1[0] . "\n" ;    # print the first data line! here the fusion-transcript "single"
# print "lineelement 1" . "\n" . $lineelements1[1] . "\n" ; 


# for each file get rid of replicate fusion genes them output to common file!
my @fusionarray = "" ;
splice @fusionarray, 0, 1;

# obtain FusionGene information for this sample!
foreach my $index (0 .. $#lineelements1) { 
my $target1 = $lineelements1[$index] ;
my ($FusionID, $UniqueCuttingPositionCount, $SeedCount, $RescuedCount, $Strand, $Chromosome1, $Position1, $Chromosome2,	$Position2,	$KnownGene1, $KnownTranscript1,	$KnownExonNumber1,	$KnownTranscriptStrand1,	$KnownGene2,	$KnownTranscript2,	$KnownExonNumber2,	$KnownTranscriptStrand2,	$FusionJunctionSequence,	$FusionGene,	$SplicePattern,	$SplicePatternClass,	$FrameShift,	$FrameShiftClass,	$Distance,	$OnExonBoundary) = split("\t", $target1);
#@ print "the fusion genes listed in " . $filedataname . " are:  " . $FusionGene . "\n" ;
# will repeat the action for each here
push (@fusionarray, $FusionGene) ;
}

#@ print "@fusionarray" . " fusion array" . "\n" ;


my %seen ;
my @unique = grep {defined && ! $seen{$_}++} @fusionarray;
#@ print "@unique" . " unique array" . "\n" ;

my %temp_hash = map { $_, 0 } @fusionarray;
my @uniq_array = keys %temp_hash;	
# may now output
foreach my $index (0 .. $#unique) { 
my $printout = $unique[$index]; 
open (FILE, ">>./temp.txt") ;  #open for write, append 
print FILE $printout  . "\n" ;          
# print FILE "@uniq_array"  . "\n" ;    
         close(FILE) ;
 print $printout . "\n" ; 
 
}

 # close the loop. Group 1, e.g. luminal is ready!
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# this is used to simply count the # of samples
#
my $realcount = "" ;
foreach my $keys (keys %counts) {
# the number of samples. Later you want to only allow fusion that has the same count as this. 
# print "$counts{$keys}" . " is the number of samples examined in group 1" . "\n" . "\n" ;
$realcount = "$counts{$keys}" ;
# print $realcount . " i bank" . "\n" ;
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# OK, now open 
local $/=undef;  # give me the whole file at once!
open (FILE, "./temp.txt") ;  #
my $mergedfile1  ;
chomp ($mergedfile1 = (<FILE>)) ; # remove line break
close(FILE) ;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my @mergedelements1unique = "" ;
# delete element 0
splice @mergedelements1unique, 0, 1;

my @mergedelements1 = split /\n/, $mergedfile1 ;  # split by new line

# count how many times each fusion is present and save to tmp file
my %countFUSION;
map { $countFUSION{$_}++ } @mergedelements1;
open (FILE, ">>./fusiongeneswithcount.txt") ;  #open for write, append 
                      print FILE "$_" . "\t" . "$countFUSION{$_}\n" foreach sort {$a<=>$b} keys %countFUSION ;    
         close(FILE) ;

# OK, now open again
local $/=undef;  # give me the whole file at once!
open (FILE, "./fusiongeneswithcount.txt") ;  #
my $fusiongeneswithcount  ;
chomp ($fusiongeneswithcount = (<FILE>)) ; # remove line break
# have a large string that contains the entire data set of e.g. luminal
close(FILE) ;
# ok, now go through each element and only OK if the count is acceptable!

# feed string into array!
my @fusiongeneswithcountarray = split /\n/, $fusiongeneswithcount ;  

foreach my $index (0 .. $#fusiongeneswithcountarray) { 
my $mergedelements1INDEX = $fusiongeneswithcountarray[$index]; 
my ($FusionGene, $FusionGeneCount) = split("\t", $mergedelements1INDEX) ;

my $acceptablecutoff = ($realcount * $percentagecutoff)/100 ;
#@ print $acceptablecutoff . " is the value after correcting for % threshold" . "\n" ;
# my $targetcount = $realcount ;
my $targetcount = $acceptablecutoff ;
if ($FusionGeneCount >= $targetcount) {


print color 'yellow' ;
print "###############################################################################################################################################################" . "\n" ;
print color 'reset';

print "the fusion transcript " ;
print color 'black on_white' ;
print $FusionGene ;
print color 'reset';
print " count is " . "\*" ;
print color 'black on_white' ;
print $FusionGeneCount ;
print color 'reset';
print  "\* and has reached the accepted threshold and is considered overrepresented in the group" . "\n" ;

}         

# end of loop for EACH sample
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

}
}
print color 'yellow' ;
print "###############################################################################################################################################################" . "\n" ;
print color 'reset';

print color 'red' ;
print "THIS IS A LIST OF CHIMAERIC TRANSCRIPTS ABOVE YOUR THRESHOLD, WHICH IS " . $percentagecutoff . "\%" . "\n" ;
print color 'reset';


system("rm ./temp.txt");
system("rm ./fusiongeneswithcount.txt");
