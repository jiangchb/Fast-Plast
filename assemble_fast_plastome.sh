#!/bin/bash

java -classpath ~/bin/Trimmomatic-0.36/trimmomatic-0.36.jar org.usadellab.trimmomatic.TrimmomaticPE -threads 4 -phred33 $1 $2 $3.trimmed_P1.fq $3.trimmed_U1.fq $3.trimmed_P2.fq $3.trimmed_U2.fq ILLUMINACLIP:Trimmomatic-0.36/adapters/NEB-PE.fa:1:30:10 SLIDINGWINDOW:10:20 MINLEN:40



bowtie2 --very-sensitive-local --al map_hits.fq --al-conc map_pair_hits.fq -x ~/Andropogoneae_Plastomes/FINISHED/androplast -1 $3.trimmed_P1.fq -2 $3.trimmed_P2.fq -U $3.trimmed_U1.fq,$3.trimmed_U2.fq -S $3.sam

time python ~/bin/SPAdes-3.6.0-Linux/bin/spades.py -o spades_iter1 -1 map_pair_hits.1.fq -2 map_pair_hits.2.fq -s map_hits.fq --only-assembler -k 55,87,121 -t 4
perl /home/mmckain/Joshua_Tree/Chris_Data/Joshua_Tree_Plastid_Assembly/filter_coverage_assembly.pl spades_iter1/contigs.fasta
~/bin/afin -c filtered_spades_contigs.fsa -r $3.trimmed* -l 50 -f .1 -d 100 -x 100 -p 20 -i 2 -o $3_afin
/home/mmckain/DASH_Phylogeny/GSS_Plastomes/plastome_finisher.sh $3 /home/mmckain/Andropogoneae_Plastomes/FINISHED/positional_genes.fsa