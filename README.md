# Selection for representative genomes out of a group of genomes  
The scripts in this repository were made in order to score bacterial genomes based in the gene families shared amongst them.  

## Things needed for the scripts to work
You will need a *.end* output file from FastOrtho (you still can get FastOrtho [here](https://github.com/olsonanl/FastOrtho)). Also, a list of the genome file names used for the BLAST input for FastOrtho.

## Instructions
### Create gene families matrixes
Download the scripts *MatrixMaker_simple.pl* and *MatrixMaker_counter.pl*. This are perl scripts that use the *.end* output file to generate gene family matrixes. *MatrixMaker.pl* creates a simple presence-abscence matrix of the families found within a genome set, while *MatrixMaker_counter.pl* displays the number of sequences per genome within each family.  
 
Usage:    
`perl MatrixMaker_simple.pl <genome_file_names> <.end output file> > <your_matrix_file>`  
`perl MatrixMaker_counter.pl <genome_file_names> <.end output file> > <your_matrix_file>`  
  
For both scripts use an *>* symbol to redirect the output to a file.

### Score the genomes
Download *OrthoScore_simple.pl* and the *OrthoScore_mode.pl* scripts. These scripts perform the scoring process using the matrixes created by MatrixMaker scripts. 

The *simple* script explores each gene family and explores how many different genes have a member present and scores the family accordingly, that means, a gene family present in every genome in the genome set has a higher score than one that is only present in a few. The total score for a single genome is equal to the sum of all the individual scores of the gene families it possesses.

The *mode* script has a similar approach, however while making the sum for the total score of a given genome it penalizes the score of each gene family deppending of the mode for the number of gene members per genome within each family. Lets say, genome A has 2 members within gene family 1 and the mode of member number amongst the genome set is 1, then family 1 score for genome A will be penalized according to the difference with the mode. 

Usage:    
`perl OrthoScore_simple.pl <your_matrix_file > > <your_score_file>`  
`perl OrthoScore_mode.pl <your_matrix_file> > <your_score_file>`  
  
For both scripts use an *>* symbol to redirect the output to a file.    
*NOTE:* The *simple* script needs a matrix file created by *MatrixMaker_simple.pl*, while the *mode* scripts uses a matrix created by *MatrixMaker_mode.pl*.  

## Example
Therethe *example_files* directory
**THIS REPOSITORY IS UNDER CONSTRUCTION AND EVERY EXPLANATION WILL BE IMPROVED I PROMISE**
