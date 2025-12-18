# Report Yara

## Intro

During the first years of life, the gut microbiome undergoes a rapid and extensive development before stabilizing into an adult-like state (milani,bottino, yassour). This rapid development is influenced by multiple factors including the maternal microbiota, mode of delivery, feeding method and antibiotic exposure (zimmermann,  bottino, bokulich).
The gut microbial communities play a key role in immune, metabolic, and endocrine pathways, and therefore directly influence host development (robertson, bokulich). This also explains why altered colonization events in early life are associated with the development of inflammatory disorders, metabolic diseases, and neurocognitive outcomes.

Growing evidence suggests a bidirectional relationship between sleep and gut microbiome composition, with many sleep disorders linked to alterations in the microbiome (sen).
Identifying key microbial differences linked to neurocognitive functions, such as sleep quality or rhythmicity could uncover potential therapeutic targets, for example through targeted nutritional interventions to improve sleep.

The goals of this project are to analyze the development of microbial diversity in infants during their first six months of life. We also aim to assess compositional changes and explore their functional implications. In a second part, we investigate how microbiome changes relate to behavioural outcomes measured and attempt to predict these outcomes from microbial profiles.

We worked with the data from an observational longitudinal cohort study that followed healthy infants during their first six months of life (fannie keff). Stool samples were collected at 2, 4 and 6 months, along with behavioural measures. The V4 region of the 16S rRNA gene was sequenced using Illumina NextSeq2000.


## Methods
### Preprocessing
The preprocessing of the 16S rRNA amplicon sequencing data includes data importing, quality control, cutadapt and denoising, and taxonomic classification (see Figure workflow).

First, the demultiplexed sequences which were provided as QIIME 2 artifacts were imported along with the corresponding metadata. Quality control was performed next. Forward reads displayed a median quality score of 34 for all base positions. The reverse reads also displayed a median of 34, which dropped to 20 for the last base positions. The variability was higher overall for the reverse reads and increases substantially from position 221 and onward (see Figure x). Lastly, both forward and reverse sequences displayed a read length of 301 bp. 
The V4 region of the 16S rRNA gene is shorter than 301 bp, which indicated the presence of primers or read-through in the sequences [16S rRNA and 16S rRNA Gene – EzBioCloud Help Center, n.d.]. To verify the presence of primers, we performed an initial trimming attempt with Cutadapt using V4-specific forward and reverse primer sequences [(16S Illumina Amplicon Protocol, n.d.)]. This resulted in zero sequences being trimmed, meaning that the primers were already removed by the sequencing facility. Another possible explanation for the read length was read-through, which was confirmed by running Cutadapt with the reverse complements of the primers. Approximately 4.5 million sequences were successfully truncated, resulting in reads of ~250 bases, likely representing the true amplicon length. Truncation failed for many reversed reads, likely due to the low base quality at the ends, preventing Cutadapt from recognizing the reverse complement primer. To assure truncation of all reads, truncation was applied directly during denoising. 
Forward and reverse reads were truncated to 220 bp and 200 bp, which is sufficient to remove the read-through while maintaining an overlap of ~130 base pairs. This resulted in good denoising performance, with 90% of reads passing filtering and nearly all reads successfully merged.    
Lastly, taxanomic classification was performed using a weighted classifier optimized for stool samples. The classifier targets the 16S rRNA V4 region (515F/806R) and is based on the SILVA 138.2 database (99% NR).  

The next step involved preparation of the feature table and metadata. The metadata consist of two files: one with per sample information and one with per-age information, including behavioural outcome measures at each timepoint. Both files were merged into a complete metadata file to simplify further analysis.
The number of samples collected per infant at a given timepoint varies depending on stool frequency, resulting in uneven sampling across infants and timepoints. Therefore, two feature tables were used for downstream analysis: non-collapsed and collapsed. The collapsed feature table contains one reference sample per infant and timepoint, obtained by averaging all ASV abundances from that infant at that timepoint. This version is used for correlating behavioural outcome measures, ensuring that over-represented infants do not skew the results. The non-collapsed feature table is used for all other analyses to retain all data and avoid unnecessary information loss (see Figure workflow x).

### Diversity 
Diversity metrics were calculated for both the collapsed and non-collapsed feature tables. A k-mer–based approach was used, which allows assessment of genetic similarity without a computationally intensive phylogenetic reconstruction.  
To determine an appropriate sampling threshold, rarefaction was performed. Shannon entropy plateaued between 5'000 and 10'000 reads, so a sampling depth of 9'000 reads was chosen to capture community diversity while retaining most samples. Bootstrapping was used to reduce stochastic variation of subsampling. For the k-mer size selection, bootstrapping was performed for k = 12, 14, and 16. Shannon and Pilou metrics were stable across all lengths, so k = 12 was chosen to increase the likelihood of matches across sequences and improve detection of related taxa.
The final diversity analysis was performed with a k-mer size of 12, a sampling depth of 9'000 and 100 iterations.
After the discussion in our presentation, ASV-based diversity estimation was also performed to compare temporal changes in alpha diversity with the k-mer based approach. However, the rest of the analysis is based on k-mer derived diversity.

### Inter-Infant differences and temporal trajectories
#### Statistical Testing Alpha diversity
Differences in alpha diversity between timepoints (2, 4, and 6 months) were assessed using the Kruskal–Wallis test. Shannon diversity was used as the metric, as it accounts for both richness and evenness. The analysis was performed for both k-mer and ASV derived diversity.

#### PCoA and Statistical Testing Beta diversity
The distance matrices Jaccard and Bray-curtis were examined with PcoA. Visualizations in this report are based on data from infants that had samples at all three timepoints (2, 4 and 6 months).  
Statistical testing of beta diversity on braycurtis distances was performed using Adnois, a multivariate analysis of variance with permutations. This approach accounts for the longitudinal study design and controls for repeated sampling per infant as well as the non-independence of samples across timepoints.
R was used to perform this analysis, since the adonis function in the q2-longitudinal plugin is currently not functional. [https://github.com/qiime2/q2-diversity/issues/380 , https://github.com/qiime2/q2-diversity/issues/243].

## Results
### Inter-Infant differences and temporal trajectories
#### Statistical Testing Alpha diversity
For the k-mer–based analysis, no significant differences in Shannon diversity were observed between 2, 4, and 6 months, indicating that alpha diversity remains stable across infants during the first six months of life. Interestingly, when looking at the alpha diversity calculated from ASV-based core metrics, there is a significant difference between 2 and 4 months (p = 0.051) and 2 and 6 months (p=0.059).

#### PcoA Bray-Curtis
PCoa based on Jaccard distances did not show visible any visible clustering, whereas PCoa using Bray-Curtis distances did. This indicates that the differences between the samples are driven by changes in relative abundance rather than the presence or absence of specific taxa.
PCoA on Bray–Curtis distances revealed distinct clusters by infant, with multiple subclusters forming within individual infants (see Figure X). When samples were labeled by timepoint, no clear clusters or visual patterns were observed (see Figure X). However, considering both infant and timepoint together showed that the subclusters that formed within individual infants corresponded to different timepoints (see Figure X).
This first visual inspection indicated that the microbiome of infants differs strongly between each other. Within individual infants, the microbiome appears to change over time. However, when excluding the infant_id information, no clear trends are observable across timepoints. 

#### Statistical Testing Beta diversity
Assessment of inter-infant differences using Adonis revealed significant differences between infants (p < 0.001). Interestingly, significant differences were also observed between timepoints. The pairwise comparisons showed significant differences between 2 and 6 months (p < 0.001) and 4 and 6 months (p < 0.001), while no significant difference was found between 2 and 4 months (p = 0.295). This suggests that the microbiome of 6 month old infants is very distinct from that of younger infants.
Including both variable into the model revealed that the infant_id ($R^2$ = 0.64) explains substantially more of the variance in the distance matrix than timepoint ($R^2$ = 0.04).  
This also quantitatively confirms the observations from the PCoA analysis. Adonis showed that the effect of the infant is so strong that it can mask the effect of timepoint, explaining why no clear clustering by timepoint was observed when infant information was excluded.

## Discussion
- That literature also saw that alpha diversity is stable
- What does it mean if ASV based is significant and k-mer not
- extreme high variability in between infants (maybe find literature) - infant id can mask timepoint

### Discussion
- alpha diversity constant
- what does it imply if ASV based alpha diversity is significant
- what does it imply if we see clustering in bray curtis but not jaccard
- talk about developmental measures