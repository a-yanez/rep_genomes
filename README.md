# Selection for representative genomes out of a group of genomes  
The scripts in this repository were made in order to score bacterial genomes based in the gene families shared amongst them.  

## Things needed for the scripts to work
You will need a *.end* output file from FastOrtho (you still can get FastOrtho [here](https://github.com/olsonanl/FastOrtho)). Also, a list of the genome file names used for the BLAST input for FastOrtho.

## The scripts
### Create gene families matrixes
The *MatrixMaker_simple.pl* and *MatrixMaker_counter.pl* are perl scripts that use the *.end* output file to generate gene family matrixes. *MatrixMaker_simple.pl* creates a simple presence-abscence matrix of the families found within a genome set, while *MatrixMaker_counter.pl* displays the number of sequences per genome within each family.  
 
Usage:    
`perl MatrixMaker_simple.pl <genome_file_names> <.end output file> > <your_matrix_file>`  
`perl MatrixMaker_counter.pl <genome_file_names> <.end output file> > <your_matrix_file>`  
  
For both scripts use an *>* symbol to redirect the output to a file.

### Score the genomes
The *OrthoScore_simple.pl* and the *OrthoScore_mode.pl* scripts perform the scoring process using the matrixes created by MatrixMaker scripts. 

The *simple* script explores each gene family and explores how many different genes have a member present and scores the family accordingly, that means, a gene family present in every genome in the genome set has a higher score than one that is only present in a few. The total score for a single genome is equal to the sum of all the individual scores of the gene families it possesses.

The *mode* script has a similar approach, however while making the sum for the total score of a given genome it penalizes the score of each gene family deppending of the mode for the number of gene members per genome within each family. Lets say, genome A has 2 members within gene family 1 and the mode of member number amongst the genome set is 1, then family 1 score for genome A will be penalized according to the difference with the mode. 

Usage:    
`perl OrthoScore_simple.pl <your_matrix_file> > <your_score_file>`  
`perl OrthoScore_mode.pl <your_matrix_file> > <your_score_file>`  
  
For both scripts use an *>* symbol to redirect the output to a file.    
**NOTE:** The *simple* script needs a matrix file created by *MatrixMaker_simple.pl*, while the *mode* scripts uses a matrix created by *MatrixMaker_mode.pl*.  

## Example
### The example files
Go to the *example_files* directory and download all the files cotained within.

The first file is named *fastortho_output.end*. It is an output file from FastOrtho, ran on a 19 genome set, using the default parameters.

The second file is named *nameslist*. It contains the names of the genomes files used by FastOrtho to create the file named *fastortho_output.end* and it is the way we inform the *MatrixMaker* scripts which genome fasta files were used for the BLAST input for FastOrtho. All the names of *nameslist* file have been stripped of their extension (in this case *.faa*) as that is the form they appear in the *.end* files generated by FastOrtho. So, this must be considered when creating your own *nameslist* files:

| The original names | How they must appear in the names file |
|:------------------:|:--------------------------------------:|
|     123456.faa     |                 123456                 |
|  666666.456789.faa |              666666.456789             |

### Trying the scripts
Download the scripts *MatrixMaker_simple.pl* or the *MatrixMaker_counter.pl* in the *scripts* directory. Type in the command line either:

`perl MatrixMaker_simple.pl nameslist fastortho_output.end > output_simple.matrix`  
`perl MatrixMaker_counter.pl nameslist fastortho_output.end > output_counter.matrix`

The *simple* script output should look like this:

|              | 175717 | 175718 | 373137 | 373154 | 425043 |
|:------------:|:------:|:------:|:------:|:------:|:------:|
|   ORTHOMCL0  |    1   |    1   |    1   |    1   |    1   |
| ORTHOMCL2500 |    1   |    1   |    1   |    0   |    1   |
| ORTHOMCL2600 |    0   |    1   |    1   |    0   |    1   |

The *counter* script output should look like this:

|           | 175717 | 175718 | 373137 | 373154 | 425043 |
|:---------:|:------:|:------:|:------:|:------:|:------:|
| ORTHOMCL0 |   12   |   13   |   13   |   11   |   13   |
| ORTHOMCL1 |   10   |   10   |   10   |   11   |   10   |
| ORTHOMCL2 |    5   |    8   |    6   |    5   |    6   |

Now for the scoring process download *OrthoScore_simple.pl* or the *OrthoScore_mode.pl* scripts. Type in the command line either:

`perl OrthoScore_simple.pl output_simple.matrix > simple.score`  
`perl OrthoScore_mode.pl output_counter.matrix > mode.score`

The outputs should look like this:

| 175717 | 2569.42 |
|--------|---------|
| 175718 | 2538.63 |
| 373137 | 2626.63 |
| 373154 | 2562.00 |
| 425043 | 2582.63 |
| 425044 | 2514.73 |
| 425045 | 2640.26 |
| 431399 | 2607.31 |
| 594099 | 2537.63 |
| 594147 | 2550.94 |
| 729566 | 2679.84 |
| 729568 | 2675.31 |
| 729572 | 2646.26 |
| 729577 | 2627.36 |
| 819930 | 2661.94 |
| 820006 | 2686.42 |
| 820007 | 2691.73 |
| 820008 | 2703.31 |
| 820010 | 2689.89 |

The column on the left represent the name of each genome and the column on the right is the score for each genome. The genome with the highest score should be the genome that best represent the set of genomes, based on the gene families shared amongst them.
