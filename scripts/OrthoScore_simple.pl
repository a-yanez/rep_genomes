use strict;

my $matrix = $ARGV[0]; #The matrix file
#my $rastID = $ARGV[1]; #The RAST jobID file

#The first task, counting the columns.

my $sample= `head -n1 $matrix`;
my @columns = split(/\t/,$sample);
my $colnum = scalar(@columns)-1;
#print("$colnum\n");
my %columnweigth;

open (FILE,$matrix) or die $!;
	foreach my $line (<FILE>){
		my @columnarray;
		#print($line);
		#The next line discards the first line, which has the jobID from RAST
		if ($line!~/^\t.*/){
			@columnarray=split(/\t/,$line);
			#print("$columnarray[0]\n");
			my $weigth=0;
			for my $i (1..$colnum){
				#print("$i\t$columnarray[$i]\n");
				$weigth=$weigth+scalar($columnarray[$i]);
			}
			my $percentweigth=$weigth/$colnum;
			$columnweigth{$columnarray[0]}=$percentweigth;			
		}
	#print("$columnarray[0]\t$columnweigth{$columnarray[0]}\n");
	}
close FILE;

my $jobID=`head -n1 $matrix | tr '\t' '\n' | sed '/^\$/d'`;
my @rastID=split(/\n/,$jobID);
#print("@rastID\n");
foreach my $ID(@rastID){
	my $value=0;
	my @columnas=(1);
	my $number =`head -n1 $matrix| tr '\t' '\n' | cat -n | grep -w $ID | cut -f1 | sed -e 's/^[ \t]*//'`;
	chomp $number;
	push (@columnas,$number);
	my $cutFeed=join(",",@columnas);
	my $minifile=`cut -f $cutFeed $matrix | tail -n +2`;
	my @arrayminifile=split(/\n/,$minifile);
	#print("$arrayminifile[0]");
	foreach my $llave (sort keys %columnweigth){	
		my @extract = (grep { $_ =~ /$llave\t/ } @arrayminifile);
		#print("$llave\t@extract\n");
		#print("$extract[0]\n");		
		my @breaks=split("\t",$extract[0]);
		#print("$breaks[1]\n")
		#print("$columnweigth{$llave}\t$breaks[1]\n");
		$value=$value+($columnweigth{$llave}*$breaks[1]);		
	}
	print("$ID\t$value\n");	
}



