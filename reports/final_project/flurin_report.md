# Final Report - Draft

## Methods

### Differential Abundance / Temporal Trajectories

In order to quantify global temporal trends in microbiome composition in the gut microbiome of infants, ANCOM-BC2 (citation) is implemented. 
To control for repeated sampling, a random intercept is fitted for each infant. 
As the SILVA databased used for taxonomy classification does not provide reliable species level information, the taxa were collapsed on genus level.
Taxa that are present in fewer than 10 samples were filtered and a prevalence cutoff of 0.05 was provided to ANCOM-BC2

Inter-infant variability of these trends is assessed with the feature-volatility action in the longitudinal QIIME plugin (citation).
We train a Random Forest Regressor to identify taxa that are important for predicting the time point of gut microbiome sampling. 
Plotting the relative frequency of these taxa for each infant over time gives insight into infant-specific changes as well as global trends.

PICRUSt2 (citation) allows us to predict the functional potential of the gut microbiome based on amplicon data.
The resulting pathway abundance are analyzed with ANCOM-BC2 analogous to the method described before.
In order to identify overarching themes of biological activity at the different timepoints, we perform Gene Set Enrichment Analysis (cite original GSEA paper https://www.gsea-msigdb.org/gsea/index.jsp) as implemented in GSEApy (citation).
Pathway sets used for this analysis are based on the secondary pathway level of the MetaCyc database (citation [https://doi.org/10.1093/nar/gkt1103](https://doi.org/10.1093/nar/gkt1103)). 
The enrichment rank of each pathway is determined by calculating $-\operatorname{sgn}(\text{LFC}) \log_{10}(q)$ and sorting the set in descending order.
This sorted set is then used for preranked GSEA.  

### Gut Microbiome Diversity and Behavioral Outcome

Pearson correlation of the behavioral measures "Behavioral Development", "Sleep Quality", "Sleep Rhythmiticity", and "Attenuated Caring Style" with each other and the age of the infants is calculated. 
To quantify the contribution of k-mer-based Shannon entropy to the outcome measures, a Mixed Linear Model is fit using QIIME longitudinal (citation).
By controlling for infant age and repeated sampling (infant_id), we isolate the effect of the gut microbiome diversity.

### Predicting Behaviour with Microbiome Composition

## Results

### Differential Abundance / Temporal Trajectories

*Figure relative abundance* shows clear changes in microbiome composition over time. Enterobacteria and Bifidobacteria decrease slightly in abundance, whereas Veillonella increase in abundance and dominate the gut microbiome of older infants.
Multiple members of the Bacillota phylum are significantly enriched (q < 0.05) at 6 months compared to two months, such as Phascolarctobacterium, Ruminococcus and Enterococcus. 
Other members, such as Clostridum and Staphylococcus, are depleted significantly. 
The gram-negative genus Klebsiella shows significantly lower abundance  at 6 months.

The taxa volatility plot for Veillonella (see Figure) show a general trend of increased abundance from 4 to 6 months. 
Nevertheless, not all infants follow this trend, as multiple do not show increased abundance over time. 
The inverse is true for the Enterobacteriaceae family, as there is a general decrease in abundance but two infants that show contradictory behaviour.

Differential abundance analysis of predicted pathway abundance in the gut microbiome at two and 6 months reveals multiple trends (Figure). 
Acetly-CoA fermentation (PWY-5676) is enriched 2-fold at 6 compared to 2 months. 
Fucose and N-acetylneuraminate degradation is significantly depleted at 6 months. 
Multiple pathways related to gram-negative bacteria (LPS synthesis, O-antigen biosynthesis and enterobacterial common antigen synthesis) are less abundant at 6 months.

GSEA reveals no significantly enriched or depleted pathway sets between 2 and 6 months. 

### Gut Microbiome Diversity and Behavioral Outcome

Figure heatmap shows the correlation and corresponding significance levels of the outcome measures. 
Sleep quality and sleep rhtyhmicity correlate positively with age. 
Sleep rhythmiticity also correlates positively with an attenuated caring style of parents.
The behavioral development score correlates negatively with age. 

K-mer based Shannon entropy does not have a significant effect on any outcome measure tested. 
The slope of the relationship between microbiome diversity and behavioral outcome is near zero for three out of four measures (see Figure correlation) with non-significant p-values. 
Only sleep rhythmiticity has a moderately positive association with Shannon entropy. 
The same analysis performed with conventional Shannon entropy yields nearly identical results. 

### Predicting Behaviour with Microbiome Composition
