use strict;

#This script creates an abscense-presence matrix of sequence families vs genome set, that is a 0 when a sequence family is present in a genome and a 0 when it is not.
 
#This script needs:
#The .end output file from FastOrtho 
#A list of the fasta files' names used to create the BLASTp input file for FastOrtho 


#Usage: perl MatrixMaker.pl <names list> <.end file> 


my $R_Ids=$ARGV[0]; #The names list
my $name=$ARGV[1]; #The .end file from FastOrtho


my %result= Splits($name);
my @genomes=GenoList($R_Ids);

foreach my $headline (sort @genomes){
	print ("\t$headline");
}
foreach my $key (sort keys %result){
	print("\n");	
	print "$key\t";
	foreach my $variable (sort @genomes){
		my $flag=0;
		foreach my $value (@{$result{$key}}){
			if ($variable eq $value){	
				$flag=1;	
			}
		}
		print "$flag\t";
	}
}


##########################################################################
sub GenoList{
	my $file = shift;
	my $list = `cut -f 1 $file`;
	my @array= split('\n',$list);
	return @array;
}
##########################################################################
#Split the .end file in single lines. Each line is an orthologue family.
sub Splits{
	my $nombre=shift;
	my %dictionary;
	open(FILE,$nombre)or die $!;
	#print("Se abrio el archivo $nombre\n");
	my $count=0;
	#Next split the lines of orthologues into genes found in each family. 
	foreach my $line (<FILE>){
		chomp $line;
		my @matrixArray=();
		#The structure of the lines is like this: ORTHOMCL338 (2 genes,2 taxa):	fig|6666666.320563.peg.3168|564672(564672) fig|		6666666.320586.peg.1305|564695(564695). So, first we take out the first column separated by ":".
	       	my @st = split (/:/,$line);
		#Next we split the line to separate the genes found in the orthologue family, they are separated by a space " ". 
		my @first = split (/\s/,$st[0]);				
		$count++;
		#print ("linea $count : $first[0] \n");
		my @others = split (/\s/,$st[1]);
    		
		foreach my $line2 (@others){
			#Here it takes only the RAST job numbers of the genomes where the genes were found (between the parentheses).
			my @others2 = split (/\(/,$line2);						
			$others2[1]=~s/\)//;
			if ($others2[1]=~/\d+/){	
				push (@matrixArray,$others2[1]);				
			}	
		}	
		my %seen;
		my @unique = grep { not $seen{$_} ++ } @matrixArray;
		if(!exists $dictionary{$first[0]}) {$dictionary{$first[0]}=();}		
		@{$dictionary{$first[0]}}=@unique;			
		#print("$first[0] -> @unique-> $dictionary{$first[0]}\n");
	}
close FILE;
return %dictionary;
}
##########################################################################

#___________________________________________________________________________________________

