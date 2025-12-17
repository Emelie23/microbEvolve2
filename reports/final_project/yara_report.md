# Report Parts Yara

## Methods
The preprocessing of the 16S rRNA amplicon sequencing data includes data importing, quality control, cutadapt and denoising, and taxonomic classification (see Figure x).

First the demulitplexed sequences, that were already provided as QIIME 2 articaft were imported, along with the corresponding metadata. Quality control was performed next. 
Preparation of the sequences involved verifying the potential presence of primers and readthrough using cutadapt. To verify whether primers are present in our sequences we perfomed an initial trimming attempt using V4 specific forward and reversed primers sequences [(16S Illumina Amplicon Protocol, n.d.)]. In a second attempt the reverse complements of the primers were used to assess the presence of readthrough. 



## Results
Assessment of paired end reads during quality control, revealed that the data is very clean and was likely already pre-processed. Forward reads displayed a median quality score of 34 for all base positions, likewise the reverse reads displayed median quality score of 34, which however dropped to 20 for the last base positions. The variability was higher overall for the reversed reads and increased substantially from position 221 onward (see Figure x). Lastly, forward and reversed sequences displayed a read length of 301 bases. 
The V4 region of the 16S rRNA gene is much shorter than 301 bp 

## Discussion