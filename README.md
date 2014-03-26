########################################################################
# FusionMapCutoff.pl                                                   #
#                                                                      #
#                                                                      #
#                                                                      #
########################################################################

We provide a Perl script that will parse FusionMap v2014-01-01 reports and output
fusion/chimaeric transcripts above a desired percentage threshold. The code is not elegant, but the script can be used to quickly interrogate large FusionMap data sets --in particular cancer samples, where the number of candidate fusion transcripts can range from less than ten to thousands. 


- The script has been tested on linux (Debian) and Mac OSX. 
- No additional Perl modules are required, however for colouring please install Term::ANSIColor from cpan (http://search.cpan.org/~rra/Term-ANSIColor-4.02/ANSIColor.pm).
- Written in the spirit of http://www.nature.com/news/2010/101013/full/467753a.html. *Please feel free to fork and rewrite* 

Guidelines
----------

1. Put your FusionMap output in a directory named "data" (i.e. in ./data)
  
  e.g. tumour1.txt tumour2.txt etc

2. Ensure that FusionMapCutoff.pl is in your PATH —-or simply call the script using its absolute path— and run the script one directory down from the directory named “data”
  
  the script will display "Please enter your desired chimaera/fusion transcript cutoff" 

  type in e.g. 50 for 50% and press the Enter key


3. The script will output all fusion/chimearic transcripts above your threshold at the bottom of your screen and to the file **output.txt**

   e.g. if you have 10 samples, a cutoff of 60%, and the fusion C1orf86->LOC100128003 is found in 7 out of 10 samples.

- the fusion transcript C1orf86->LOC100128003 count is *6* and has reached the accepted threshold and is considered overrepresented in the group
- the fusion transcript C1orf86->LOC100128003 count is *7* and has reached the accepted threshold and is considered overrepresented in the group

  output.txt will say C1orf86->LOC100128003     70%

Next: validate interesting chimaera candidates by PCR and/or write a proper script.
