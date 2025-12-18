# Report Yara

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
For the k-mer–based analysis, no significant differences in Shannon diversity were observed between 2, 4, and 6 months, indicating that alpha diversity remains stable across infants during the first six months of life. Interestingly, when looking at the alpha diversity calculated from ASV-based core metrics, there is a significant difference between months 2 and 4 (p = 0.048).

#### PcoA Bray-Curtis
PCoa based on Jaccard distances did not show visible any visible clustering, whereas PCoa using Bray-Curtis distances did. This indicates that the differences between the samples are driven by changes in relative abundance rather than the presence or absence of specific taxa.
PCoA on Bray–Curtis distances revealed distinct clusters by infant, with multiple subclusters forming within individual infants (see Figure X). When samples were labeled by timepoint, no clear clusters or visual patterns were observed (see Figure X). However, considering both infant and timepoint together showed that the subclusters that formed within individual infants corresponded to different timepoints (see Figure X).
This first visual inspection indicated that the microbiome of infants differs strongly between each other. Within individual infants, the microbiome appears to change over time. However, when excluding the infant_id information, no clear trends are observable across timepoints. 

#### Statistical Testing Beta diversity
Assessment of inter-infant differences with adonis revealed significant differences between infants (p < 0.001). Interestingly, there are also significant differences in between timepoins, where the pariwise comparison revealed that both 2 and 6 months (p < 0.001) and 4 and 6 months (p < 0.001), no significant differences were observed between 2 and 4 months (p = 0.295). Evidently, the microbiome in 6 month old infants seems to be very distinct from the microbiome in younger infants.

Assessment of inter-infant differences using Adonis revealed significant differences between infants (p < 0.001). Interestingly, significant differences were also observed between timepoints. The pairwise comparisons showed significant differences between 2 and 6 months (p < 0.001) and 4 and 6 months (p < 0.001), while no significant difference was found between 2 and 4 months (p = 0.295). This suggests that the microbiome of 6 month old infants is very distinct from that of younger infants.
Including both variable into the model revealed that the infant_id ($R^2$ = 0.64) explains substantially more of the variance in the distance matrix than timepoint ($R^2$ = 0.04).  
This also quantitatively confirms the observations from the PCoA analysis. Adonis showed that the effect of the infant is so strong that it can mask the effect of timepoint, explaining why no clear clustering by timepoint was observed when infant information was excluded.


## Discussion
- That literature also saw that alpha diversity is stable
- What does it mean if ASV based is significant and k-mer not
- extreme high variability in between infants (maybe find literature) - infant id can mask timepoint



## OLD VERSION

### Methods
#### Preprocessing
The preprocessing of the 16S rRNA amplicon sequencing data includes data importing, quality control, cutadapt and denoising, and taxonomic classification (see Figure x).

First the demulitplexed sequences, that were already provided as QIIME 2 articaft were imported, along with the corresponding metadata. Quality control was performed next. 
Preparation of the sequences involved verifying the potential presence of primers and readthrough using cutadapt. To verify whether primers are present in our sequences we perfomed an initial trimming attempt using V4 specific forward and reversed primers sequences [(16S Illumina Amplicon Protocol, n.d.)]. 
In a second attempt the reverse complements of the primers were used to assess the presence of readthrough. 
Readthrough was confirmed with cutadapt, which allowed to choose appropriate truncation lengths for denoising. Denoising was performed with truncation lengths of 220 bp for forward reads and 200 bp for reverse reads which is enough to remove read-thorugh sequences while keeping an overlap of ~130 bp to assure successfull merging. 
Taxanomic classification was performed using a weighted classifier optimized for stool samples. The classifier targets the 16S rRNA V4 region (515F/806R) and is based on the SILVA 138.2 database (99% NR).

The next step involved the preparation of feature table and metadata. 
The metadata consists of two files `metadata_per_samples`and `metadata_per_age`. Metadata_per_sample contains information for each sample, including the infant it comes from and the timepoint of collection. Metadata_per_age contains behavioural outcome measurements describing developmental state, sleep rhythm, and sleep quality for each infant at a specific timepoint. We merged both files into a complete metadata file to simplify handling in further analyses.  
The number of samples collected from each infant at a given timepoint varies, depending on how often a child produces a stool. This leads to uneven sampling frequency across infants and timepoints. 
Therefore we decided to work with two feature tables, non-collapsed and collapsed.   
The collapsed feature table contains one reference sample per timepoint per infant, where we averaged the abundance of each ASV. This version is used for correlating bahavioural outcome measures to prevent over-represented infants from skewing the results.
The non-collapse feature table is used for all other analyses to include all the data and prevent unnecessary information loss.

#### Diversity
Next we computed diversity metrics for both the non-collapsed and collapsed feature table. The diversity measures of the non-collapsed feature table will be used to assess inter-infant differences and temporal trajectories, whereas the diversity measures from the collapsed feature table will be used to correlate behavioural outcome measures (see Figure xx).  
We decided to use a k-mer based approach because it is computationally efficient while allowing us to assess genetic diversity and similarity without the need for traditional phylogenetic reconstruction.
To assess the impact of the sequencing depth on the diversity, we first performed rarefaction to identify an appropriate sampling threshold for further analysis. Rarefaction analysis showed that the Shannon entropy plateaued between 5000 and 10000 reads. We chose a sampling depth of 9000 reads, as it captures community diversity while retaining most samples.
To minimize the stochastic variation of subsampling, we used bootstrapping that averages diversity metrics across multiple iterations. For the k-mer size length selection, we evaluated the diversity estimates for k-mers with a length of 12, 14 and 16. Shannon and Pilou estimation was stable across all tested k-mer lengths of 12, 14 and 16. We chose a k-mer length of 12, as shorter k-mers are more likely to match across different sequences, improving the detection of related taxa.
The final diversity analysis was performed using a k-mer size of 12, a sampling depth of 9,000, and 100 iterations.
After a short discussion during our presentation, we additionally performed ASV-based diversity estimation to compare alpha diversity with the k-mer–based approach. However, the remaining of the analysis is based on k-mer–derived diversity.

#### Statistical Testing Alpha diversity
To assess inter-infant differences and changes over temporal trajectories we analyzed diversity metrics estimated from the non-collapsed feature table (see Figure x). 
We assessed alpha diversity differences between timepoints (2, 4, and 6 months) using the Kruskal–Wallis test. Shannon diversity was used as the metric because it accounts for both richness and evenness. This was done for both k-mer and ASV-based diversity, allowing comparison between the two approaches.

#### PCoA and Statistical Testing Beta diversity
Before performing statistical testing on beta diversity, we examined the distance matrices Jaccard and Bray-Curtis using PCoA and UMAP. For the final report, we included visualizations based on data from infants with samples at all three timepoints, which sufficiently highlights the main trends without overcrowding the plots. Additionally, we focus on PCoA, as the distances are proportional, while UMAP applies a non-linear transformation, making distances less directly comparable.

Statistical testing of beta diversity was performed using Adonis, which allows for multivariate analysis of variance using permutations. This approach accounts for the longitudinal design of our study, handling repeated measures across multiple timepoints per infant and the non-independence of samples within and between infants.
As the adonis function exposed in the QIIME plugin q2-longitudinal is currently broken, we used R in our Jupyter Notebooks to perform the analysis. 
When looking at differences between infants, we must consider that samples were taken at multiple timepoints. The developmental stage (timepoint) likely has a strong effect on the microbiome which could mask individual differences. To control for this, we can stratify the permutations by timepoint. 
Similarly, when looking at differences between timepoints, we need to consider that the same infants are present in multiple timepoint groups. This makes the timepoint groups no longer independant from each other. Additionally, the differences between timepoints may be masked by the effect of the infants. Using adonis, we can stratify the permutations by infant_id, in order to control for it.

### Results
#### Preprocessing
Assessment of paired end reads during quality control, revealed that the data is very clean and was likely already pre-processed. Forward reads displayed a median quality score of 34 for all base positions, likewise the reverse reads displayed median quality score of 34, which however dropped to 20 for the last base positions. The variability was higher overall for the reversed reads and increased substantially from position 221 onward (see Figure x). Lastly, forward and reversed sequences both displayed a read length of 301 bases. 
The V4 region of the 16S rRNA gene is shorter than 301 bp, which lead to the assumption that we still had primers in our reads [16S rRNA and 16S rRNA Gene – EzBioCloud Help Center, n.d.]. Performing cutadapt with V4 specific forward and reverse primers did result in zero sequences being trimmed, meaning that the primer sequences were already removed by the sequencing facility. The other possibility that could explain the length of our reads was readthrough, which was confirmed by performing cutadapt with the reverse complement of the primers. Approximately 4.5 million sequences were truncated successfully, which resulted in reads with a length of approximately 250 bases, which likely represents the true length of the amplicon. Truncation failed for many reversed reads, which was likely due to the low base quality towards the end of the reads that prevented cutadapt from recognizing the reverse complement forward primer. To assure trimming of every read, we decided to truncate during denoising directly, The truncation length of 220 for foraward reads and 200 for reverse reads would yield in theoretical overlap of 130 bp while removing any readthrough. 
These resulted in good denoising performance, with around 90% passing the filtering step and nearly all reads being merged.
The last step of preprocessing, taxonomic classification was performed successfuly.

#### Inter-Infant differences and temporal trajectories
##### Statistical Testing Alpha diversity
In the k-mer–based analysis, no significant differences in Shannon diversity were detected between 2,4 and 6 months, indicating that overall alpha diversity remained stable across the sampled period. Interestingly, ASV-based diversity metrics detected a significant pairwise difference between months 2 and 4 (p = 0.048).

#### PCoA for Bray-Curtis
PCoA did not reveal any visible clusering using the Jaccard distances. It did however for PcoA for Bray-Curtis distances. which indicates that differences in between samples are driven in changes in relative abundances rather than the presence or absence of specific taxa.
When labelling the samples PcoA on Braycurtis by infant_id, distinct clusters are forming. However, within the same infant there are multiple clusters forming (see Figure x). When labelling for timepoint, no clear pattern is visible, neighter are clusers forming. Combining infant_id and timepoint shows that the subclusers that form within one infant originate from different timepoints. 
This indicates that the microbiome of infants differs between each other. Additionally, the microbiome within a individual infant seems to change over time. However, there are no observable trend across timpoints, when excluding the infant_id information.

##### Statistical Testing Beta diversity
Adonis revealed that there are significant differences in between the infants (p < 0.001). Likewise, there are significant differences in between timepoins, where the pariwise comparison revealed that both 2 and 6 months (p < 0.001) and 4 and 6 months (p < 0.001) are significantly different. Comparison of 2 and 4 months is not significant. Evidently, the microbiome in 6 month old infants seems to be very distinct from the microbiome in younger infants.
Including both variables into the model, allows to compare the effect size of both variables. Infant Id (R^2 = 0.64) explains much more of the variance in the distance matrix than timepoint (R^2 = 0.04).
With these results here, we are able to quantitatively confirm the observations we did in PCoA. There, clustering of samples from the same infant over different timepoints cluster together more closely than samples from the same timepoint of different infants.

### Discussion
- alpha diversity constant
- what does it imply if ASV based alpha diversity is significant
- what does it imply if we see clustering in bray curtis but not jaccard
