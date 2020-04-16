use strict;

#Usage: perl OrthoScore_mode.pl <MatrixMaker_counter.pl output file> > Output_file_name

my $matrix = $ARGV[0]; #The matrix file


#The first task, counting the rows.

my $sample= `head -n1 $matrix`;
my @rows = split(/\t/,$sample);
my $rownum = scalar(@rows)-1;
#print("$colnum\n");
my %rowweigth;
my %modeweigth;

open (FILE,$matrix) or die $!;
	foreach my $line (<FILE>){
		my @rowarray;
		#print($line);
		#The next line discards the first line, which has the jobID from RAST
		if ($line!~/^\t.*/){
			@rowarray=split(/\t/,$line);
			#print("$rowarray[0]\n");
			my $weigth=0;
			my $counter=1;
			for my $i (1..$rownum){
				#print("$i\t$rowarray[$i]\n");
				#These lines are for assigning a weight for each row according to the value in each row. If a row has a value of more than 0 in each row, its weigth is 1. The value decreases with each 0.
				if ($rowarray[$i]>0){
					$weigth=$weigth+$counter;
				}	
			}
			my $percentweigth=$weigth/$rownum;
			$rowweigth{$rowarray[0]}=$percentweigth;
			#Now let's get the mode and frequencies of each value and the penalties for each one.
			my %freq;
			my @numberset=splice(@rowarray,1);
			foreach (@numberset) {$freq{$_}++};
			my @sorted_array = sort { $freq{$a} <=> $freq{$b} } keys %freq;
			my $mode = pop(@sorted_array);
			foreach (sort keys %freq){
				my $modevalue=1-(abs($freq{$_}-$freq{$mode})/(($freq{$_}+$freq{$mode})/2));
				$modeweigth{$rowarray[0]}{$_}=$modevalue;
			}			
		}
	#print("$rowarray[0]\t$rowweigth{$rowarray[0]}\n");
	}
close FILE;

my $jobID=`head -n1 $matrix | tr '\t' '\n' | sed '/^\$/d'`;
my @rastID=split(/\n/,$jobID);
#print("@rastID\n");
foreach my $ID(@rastID){
	my $value=0;
	my @filas=(1);
	my $number =`head -n1 $matrix| tr '\t' '\n' | cat -n | grep -w $ID | cut -f1 | sed -e 's/^[ \t]*//'`;
	chomp $number;
	push (@filas,$number);
	my $cutFeed=join(",",@filas);
	my $minifile=`cut -f $cutFeed $matrix | tail -n +2`;
	my @arrayminifile=split(/\n/,$minifile);
	#print("$arrayminifile[0]");
	foreach my $llave (sort keys %rowweigth){	
		my @extract = (grep { $_ =~ /$llave\t/ } @arrayminifile);
		#print("$llave\t@extract\n");
		#print("$extract[0]\n");		
		my @breaks=split("\t",$extract[0]);
		#print("$breaks[1]\n")
		#print("$rowweigth{$llave}\t$breaks[1]\n");
		$value=$value+($rowweigth{$llave}*$modeweigth{$breaks[0]}{$breaks[1]});		
	}
	print("$ID\t$value\n");	
}



