FusionMaParse.pl
================
#  This script will parse FusionMap v2014-01-01 output according to a percentage threshold. 
#  -Put your FusionMap output in a directory named "data"  
#  -It will will output all fusion/chimearic transcripts above your threshold to the bottom of your screen
#  -It can be used to quickly scan large FusionMap data sets, so the code is not elegant:
#  
#  it will output e.g. the fusion geneX-geneY at all counts above your threshold.
#  e.g. if you have 10 samples, a cutoff of 60%, and the fusion C1orf86->LOC100128003 is found in 7 out of 10 samples.
#    the fusion transcript C1orf86->LOC100128003 count is *6* and has reached the accepted threshold and is considered overrepresented in the group
#    the fusion transcript C1orf86->LOC100128003 count is *7* and has reached the accepted threshold and is considered overrepresented in the group
# 
