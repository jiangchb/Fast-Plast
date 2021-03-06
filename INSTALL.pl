#!/usr/bin/env perl -w
use strict;

use FindBin;
use lib ("$FindBin::Bin/PerlLib");
use File::Spec;
use Env qw(PATH);

BEGIN {

    $ENV{FP_HOME} = "$FindBin::Bin";

}

my $FPROOT = "$FindBin::RealBin";

print "Thank you for dowloading the Fast-Plast pipeline. If you have not looked at the dependencies for Fast-Plast, please visit https://github.com/mrmckain/Fast-Plast and download them.\n\n";


print "Do you have all dependecies installed? Yes/No: ";

my $answer = <STDIN>;
chomp ($answer);

if($answer =~ /n/i){

	print "\nDo you want me to try to install them? Yes/No: ";
	$answer = <STDIN>;
	chomp($answer);
	if($answer =~ /n/i){
		die "\nPlease install all dependencies prior to installing Fast-Plast.\n";
	}
	else{
		print "\nOK. I am only going to try to install the Linux binaries. Let's do this one-by-one. Would you like me to install Trimmomatic? Yes/No: ";
		$answer = <STDIN>;
		chomp($answer);
		my $trimmomatic;
		if($answer =~ /y/i){
			chdir("bin/");
			system("wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip");
			
			if(-e "Trimmomatic-0.36.zip"){
				system("unzip Trimmomatic-0.36.zip");
				$trimmomatic = $FPROOT . "/bin/Trimmomatic-0.36/";
				$trimmomatic = glob ("$trimmomatic/*.jar");
			}
			else{
				print "\nUnable to install Trimmomatic.\n";
			}

		}
		else{
			print "Please provide the absolute path to the Trimmomatic directory. If Trimmomatic is in your PATH already, just type PATH: ";

my $trimmomatic = <STDIN>;
chomp ($trimmomatic);

if($trimmomatic =~ /path/i){
	$trimmomatic= <"trimmomatic*.jar">;
	if(!$trimmomatic){

		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /trimmomatic/i){
				$trimmomatic = glob ("$pot/*.jar");
			}
		}
		if(!$trimmomatic){
			die "\nSorry. I cannot locate the Trimmomatic jar file in your path\. Please check again.\n";
		}
	}	

}
else{
	my $temp_trim = $trimmomatic;
	$trimmomatic = glob ("$trimmomatic/*.jar");
	if(!$trimmomatic){
		die "\nSorry. I cannot locate the Trimmomatic jar file in $temp_trim\. Please check again.\n";
	}
}

print "\nTrimmomatic jar file located: $trimmomatic\n";
		}

		`perl -pi -e "s/my \$TRIMMOMATIC;/my \$TRIMMOMATIC = $trimmomatic\;/" $FPROOT/fast-plast.pl`;

		print "\nWould you like me to install bowtie2? Yes/No: ";
		$answer = <STDIN>;
		chomp($answer);
		my $bowtie2;
		if($answer =~ /y/i){
			
			system("wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.9/bowtie2-2.2.9-linux-x86_64.zip");
			
			if(-e "bowtie2-2.2.9-linux-x86_64.zip"){
				system("unzip bowtie2-2.2.9-linux-x86_64.zip");
				$bowtie2 = $FPROOT . "/bin/bowtie2-2.2.9-linux-x86_64/";
				$bowtie2 = glob ("$bowtie2/bowtie2");
			}
			else{
				print "\nUnable to install bowtie2.\n";
			}
		}
		else{
			print "\nPlease provide the absolute path to the bowtie2 executable. If bowtie2 is in your PATH already, just type PATH: ";

my $bowtie2 = <STDIN>;
chomp ($bowtie2);

if($bowtie2 =~ /path/i){
	$bowtie2=<"bowtie2">;
	if(!$bowtie2){
		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /$bowtie2/i){
				$bowtie2 = glob ("$pot/bowtie2");
			}
		}
		if(!$bowtie2){
			die "\nSorry. I cannot locate the bowtie2 executable file in your path\. Please check again.\n";
		}
	}

}
else{
	my $temp_bow = $bowtie2;
	$trimmomatic = glob ("$bowtie2/bowtie2");
	if(!$bowtie2){
		die "\nSorry. I cannot locate the bowtie2 executable file in $temp_bow\. Please check again.\n";
	}
}

print "\nbowtie2 executable located: $bowtie2\n";
		}

		`perl -pi -e "s/my \$BOWTIE2;/my \$BOWTIE2 = $bowtie2\;/" $FPROOT/fast-plast.pl`;
		print "\nWould you like me to install SPAdes? Yes/No: ";
		$answer = <STDIN>;
		chomp($answer);
		my $spades;
		if($answer =~ /y/i){
			
			system("wget http://spades.bioinf.spbau.ru/release3.9.0/SPAdes-3.9.0-Linux.tar.gz");
			
			if(-e "SPAdes-3.9.0-Linux.tar.gz"){
				system("tar -xvzf SPAdes-3.9.0-Linux.tar.gz");
				$spades = $FPROOT . "/bin/SPAdes-3.9.0-Linux/";
				$spades = glob ("$spades/bin/spades.py");
			}
			else{
				print "\nUnable to install SPAdes.\n";
			}
		}
		else{
			print "\nPlease provide the absolute path to the SPAdes program directory. If SPAdes is in your PATH already, just type PATH: ";

my $spades = <STDIN>;
chomp ($spades);

if($spades =~ /path/i){
	$spades=<"spades.py">;
	if(!$spades){
		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /spades/i){
				$spades = glob ("$pot/bin/spades.py");
			}
		}
		if(!$spades){
			die "\nSorry. I cannot locate the SPAdes executable file in your path\. Please check again.\n";
		}
	}
}
else{
	my $temp_spades = $spades;
	$spades = glob ("$spades/spades.py");
	if(!$spades){
		$spades = glob ("$temp_spades/bin/spades.py");
	}
	if(!$spades){
		die "\nSorry. I cannot locate the SPAdes executable file in $temp_spades\. Please check again.\n";
	}
}

print "\nSPAdes executable located: $spades\n";
		}

		`perl -pi -e "s/my \$SPADES;/my \$SPADES = $spades\;/" $FPROOT/fast-plast.pl`;

		print "\nWould you like me to install BLAST+? Yes/No: ";
		$answer = <STDIN>;
		chomp($answer);
		my $blastn;
		if($answer =~ /y/i){
			
			system("wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.5.0+-x64-linux.tar.gz");
			
			if(-e "ncbi-blast-2.5.0+-x64-linux.tar.gz"){
				system("tar -xvzf ncbi-blast-2.5.0+-x64-linux.tar.gz");
				$blastn = $FPROOT . "/bin/ncbi-blast-2.5.0+/";
				$blastn = glob ("$blastn/bin/blastn");
			}
			else{
				print "\nUnable to install BLAST+.\n";
			}
		}
		else{
			print "\nPlease provide the absolute path to the blastn executable. If blastn is in your PATH already, just type PATH: ";

			my $blastn = <STDIN>;
			chomp ($blastn);

			if($blastn =~ /path/i){
				$blastn=<"blastn">;
			if(!$blastn){
		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /blast/i){
				$blastn = glob ("$pot/blastn");
				if(!$blastn){
					$blastn = glob ("$pot/bin/blastn");
				}
			}
		}
		if(!$blastn){
			die "\nSorry. I cannot locate the blastn executable in your path\. Please check again.\n";
		}
	}
}
else{
	my $temp_blastn = $blastn;
	$blastn = glob ("$blastn/blastn");
	if(!$blastn){
		$blastn = glob ("$temp_blastn/bin/blastn");
	}
	if(!$blastn){
		die "\nSorry. I cannot locate the blastn executable in $temp_blastn\. Please check again.\n";
	}
}
		}
		`perl -pi -e "s/my \$BLAST;/my \$BLAST = $blastn\;/" $FPROOT/fast-plast.pl`;
		

		print "\nWould you like me to install Jellyfish 2? Yes/No: ";
		$answer = <STDIN>;
		chomp($answer);
		my $jellyfish;
		if($answer =~ /y/i){
			
			system("wget https://github.com/gmarcais/Jellyfish/releases/download/v2.2.6/jellyfish-2.2.6.tar.gz");
			
			if(-e "jellyfish-2.2.6.tar.gz"){
				system("tar -xvzf jellyfish-2.2.6.tar.gz");
				$jellyfish = $FPROOT . "/bin/jellyfish-2.2.6/";
				$jellyfish = glob ("$jellyfish/jellyfish");
			}
			else{
				print "\nUnable to install BLAST+.\n";
			}
		}
		else{
			print "\nPlease provide the absolute path to the Jellyfish 2 executable. If Jellyfish is in your PATH already, just type PATH: ";

			my $jellyfish = <STDIN>;
			chomp ($jellyfish);

			if($jellyfish =~ /path/i){
				$jellyfish=<"jellyfish">;
				if(!$jellyfish){
					my @path = split(/:/, $PATH);
					for my $pot (@path){
						if($pot =~ /jellyfish/i){
							$jellyfish = glob ("$pot/jellyfish");
							if(!$jellyfish){
								$jellyfish = glob ("$pot/bin/jellyfish");
							}
						}
					}
					if(!$jellyfish){
						die "\nSorry. I cannot locate the jellyfish executable in your path\. Please check again.\n";
					}
				}
			}
			else{
				my $temp_jellyfish = $jellyfish;
				$jellyfish = glob ("$jellyfish/jellyfish");
				if(!$jellyfish){
					$jellyfish = glob ("$temp_jellyfish/bin/jellyfish");
					if(!$jellyfish){
						die "\nSorry. I cannot locate the jellyfish executable file in $temp_jellyfish\. Please check again.\n";
					}
				}
			}

			print "\njellyfish executable located: $jellyfish\n";

			`perl -pi -e "s/my \$JELLYFISH;/my \$JELLYFISH = $jellyfish\;/" $FPROOT/Coverage_Analysis/coverage.pl`;
		}

	}
}

print "Great! Do you want to install the main Fast-Plast pipleline or just the Coverage Analysis pipeline? You will be prompted to install the Coverage Pipeline after the main Fast-Plast pipeline. Please, enter Fast-Plast or Coverage: ";

$answer = <STDIN>;
chomp ($answer);

if($answer =~ /fast/i){


print "To get started, we are going to set the paths to Trimmomatic, bowtie2, SPAdes, and BLAST+.  After set up for the main pipeline, we will try to set up the Coverage Analysis pipeline.\n\n";

print "Please provide the absolute path to the Trimmomatic directory. If Trimmomatic is in your PATH already, just type PATH: ";

my $trimmomatic = <STDIN>;
chomp ($trimmomatic);

if($trimmomatic =~ /path/i){
	$trimmomatic= <"trimmomatic*.jar">;
	if(!$trimmomatic){

		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /trimmomatic/i){
				$trimmomatic = glob ("$pot/*.jar");
			}
		}
		if(!$trimmomatic){
			die "\nSorry. I cannot locate the Trimmomatic jar file in your path\. Please check again.\n";
		}
	}	

}
else{
	my $temp_trim = $trimmomatic;
	$trimmomatic = glob ("$trimmomatic/*.jar");
	if(!$trimmomatic){
		die "\nSorry. I cannot locate the Trimmomatic jar file in $temp_trim\. Please check again.\n";
	}
}

print "\nTrimmomatic jar file located: $trimmomatic\n";

print "\nPlease provide the absolute path to the bowtie2 executable. If bowtie2 is in your PATH already, just type PATH: ";

my $bowtie2 = <STDIN>;
chomp ($bowtie2);

if($bowtie2 =~ /path/i){
	$bowtie2=<"bowtie2">;
	if(!$bowtie2){
		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /$bowtie2/i){
				$bowtie2 = glob ("$pot/bowtie2");
			}
		}
		if(!$bowtie2){
			die "\nSorry. I cannot locate the bowtie2 executable file in your path\. Please check again.\n";
		}
	}

}
else{
	my $temp_bow = $bowtie2;
	$trimmomatic = glob ("$bowtie2/bowtie2");
	if(!$bowtie2){
		die "\nSorry. I cannot locate the bowtie2 executable file in $temp_bow\. Please check again.\n";
	}
}

print "\nbowtie2 executable located: $bowtie2\n";


print "\nPlease provide the absolute path to the SPAdes program directory. If SPAdes is in your PATH already, just type PATH: ";

my $spades = <STDIN>;
chomp ($spades);

if($spades =~ /path/i){
	$spades=<"spades.py">;
	if(!$spades){
		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /spades/i){
				$spades = glob ("$pot/bin/spades.py");
			}
		}
		if(!$spades){
			die "\nSorry. I cannot locate the SPAdes executable file in your path\. Please check again.\n";
		}
	}
}
else{
	my $temp_spades = $spades;
	$spades = glob ("$spades/spades.py");
	if(!$spades){
		$spades = glob ("$temp_spades/bin/spades.py");
	}
	if(!$spades){
		die "\nSorry. I cannot locate the SPAdes executable file in $temp_spades\. Please check again.\n";
	}
}

print "\nSPAdes executable located: $spades\n";

print "\nPlease provide the absolute path to the blastn executable. If blastn is in your PATH already, just type PATH: ";

my $blastn = <STDIN>;
chomp ($blastn);

if($blastn =~ /path/i){
	$blastn=<"blastn">;
	if(!$blastn){
		my @path = split(/:/, $PATH);
		for my $pot (@path){
			if($pot =~ /blast/i){
				$blastn = glob ("$pot/blastn");
				if(!$blastn){
					$blastn = glob ("$pot/bin/blastn");
				}
			}
		}
		if(!$blastn){
			die "\nSorry. I cannot locate the blastn executable in your path\. Please check again.\n";
		}
	}
}
else{
	my $temp_blastn = $blastn;
	$blastn = glob ("$blastn/blastn");
	if(!$blastn){
		$blastn = glob ("$temp_blastn/bin/blastn");
	}
	if(!$blastn){
		die "\nSorry. I cannot locate the blastn executable in $temp_blastn\. Please check again.\n";
	}
}

print "\nblastn executable located: $blastn\n";


print "Would you like me to compile afin? Yes or No: ";

$answer = <STDIN>;
chomp($answer);

if($answer =~ /y/i){
	chdir("afin");
	`make`;
	if(! -e "afin"){
		die "Could not compile afin.  You might be missing a required library.  Check that you have GCC 4.5+ and go to https://github.com/mrmckain/Fast-Plast/tree/master/afin for more information.\n";
	}
	print "\nAfin installed successfully.\n";
	chdir ("../");
}

`perl -pi -e "s/my \$TRIMMOMATIC;/my \$TRIMMOMATIC = $trimmomatic\;/" $FPROOT/fast-plast.pl`;
`perl -pi -e "s/my \$BOWTIE2;/my \$BOWTIE2 = $bowtie2\;/" $FPROOT/fast-plast.pl`;
`perl -pi -e "s/my \$SPADES;/my \$SPADES = $spades\;/" $FPROOT/fast-plast.pl`;
`perl -pi -e "s/my \$BLAST;/my \$BLAST = $blastn\;/" $FPROOT/fast-plast.pl`;


print "\nInstallation of primary Fast-Plast is complete. Would you like to install the Coverage Analysis pipeline (recommended)? Yes or No: ";
$answer = <STDIN>;
chomp($answer);
}


if($answer =~ /y/i || $answer =~ /cov/i){
	print "\nLet's start the Coverage Pipeline installation.\n";
	print "\nPlease provide the absolute path to the Jellyfish 2 executable. If Jellyfish is in your PATH already, just type PATH: ";

	my $jellyfish = <STDIN>;
	chomp ($jellyfish);

	if($jellyfish =~ /path/i){
		$jellyfish=<"jellyfish">;
		if(!$jellyfish){
			my @path = split(/:/, $PATH);
			for my $pot (@path){
				if($pot =~ /jellyfish/i){
					$jellyfish = glob ("$pot/jellyfish");
					if(!$jellyfish){
						$jellyfish = glob ("$pot/bin/jellyfish");
					}
				}
			}
			if(!$jellyfish){
				die "\nSorry. I cannot locate the jellyfish executable in your path\. Please check again.\n";
			}
		}
	}
	else{
		my $temp_jellyfish = $jellyfish;
		$jellyfish = glob ("$jellyfish/jellyfish");
		if(!$jellyfish){
			$jellyfish = glob ("$temp_jellyfish/bin/jellyfish");
			if(!$jellyfish){
				die "\nSorry. I cannot locate the jellyfish executable file in $temp_jellyfish\. Please check again.\n";
			}
		}
	}

	print "\njellyfish executable located: $jellyfish\n";

	`perl -pi -e "s/my \$JELLYFISH;/my \$JELLYFISH = $jellyfish\;/" $FPROOT/Coverage_Analysis/coverage.pl`;

	print "\nThe Coverage Analysis pipeline is now installed. Remember, R must be available to run this pipeline.\n";
}




