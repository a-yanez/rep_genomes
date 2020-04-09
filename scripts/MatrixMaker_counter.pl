use strict;

#This script counts the number of homologue sequences per genome found in each sequence family by FastOrtho and creates a matrix of sequence families vs genome set. We used to think that FastOrtho (under default parameters) clustered aa sequences of a given genome set in orthologue families, however we noticed that several genes from the same genome were in the same family (group). 

#This script needs:
#The .end output file from FastOrtho 
#A list of the fasta files' names used to create the BLASTp input file for FastOrtho 


#Usage: perl MatrixMaker_counter.pl <names list> <.end file> 


my $RASTid=$ARGV[0]; #The RAST id file
my $file=$ARGV[1]; #The .end file from FastOrtho



my $familynames=`cut -f1 $file | cut -f1 -d' '`;
my @families=split(/\n/,$familynames);

my $jobs=`cut -f1 $RASTid`;
my @jobnumber=split (/\n/,$jobs);
foreach my $num(sort @jobnumber) {
	print "\t$num";    
}
print "\n";

foreach my $family (@families){
	my %genomes=createCTHash($RASTid);	
	chomp $family;
	print "$family";
	my $jobIDs=`grep -w $family $file | cut -f2 | tr ' ' '\n'`;
	chomp $jobIDs;
	$jobIDs=~ s/.*\(|\)|^\n//g;
	#print "$jobIDs\n";
	my @presentIDs=split(/\n/,$jobIDs);
	foreach my $genome (sort keys %genomes){
		chomp $genome;
		#print "$genome\n";
		foreach my $ID (@presentIDs){
			chomp $ID;
			#print "$ID\n";
			if ($genome == $ID){
				$genomes{$genome}=$genomes{$genome}+1;
			}
		}
	}
	foreach my $RAST (sort keys %genomes){
		print("\t$genomes{$RAST}");
	}			
	print "\n";	
}

# # # This subroutine gets the jobID of every genome from the RASTid file and puts them in an array.
sub createCTHash {
	my $PREarr= shift;
	my $again=`cut -f1 $PREarr`;
	my @arr=split (/\n/,$again);
	my %RASTnumber;
	
	foreach my $number(@arr) {
		#print ("$number\t");    
		$RASTnumber{$number}=0;
	}

  return %RASTnumber;
}
	
