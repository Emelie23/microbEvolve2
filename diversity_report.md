part for introduction
The colonization of the infant gut is a foundational event for long-term immune and metabolic health. During the first year of life, the microbiome transitions from a simple community to a complex ecosystem. However, this diversification is not always a steady, linear process. Research indicates that during the period of exclusive breastfeeding, the microbial community often remains relatively stable and low in diversity, with significant expansion occurring only after the introduction of solid foods (Stewart et al., 2018).

Beyond metabolic development, there is growing interest in the "microbiota-gut-brain axis". While research suggests that the gut microbiome exhibits its own circadian rhythms and is heavily influenced by exclusive breastfeeding (Cell Press, 2024), there is currently limited evidence directly linking these early colonization patterns to infant sleep rhythms. Consequently, the relationship between gut stability and behavioral regulation remains unclear.
(141 words)

Stewart, C. J., Ajami, N. J., O’Brien, J. L., Hutchinson, D. S., Smith, D. P., Wong, M. C., Ross, M. C., Lloyd, R. E., Doddapaneni, H. V., Metcalf, G. A., Muzny, D., Gibbs, R. A., Vatanen, T., Huttenhower, C., Xavier, R. J., Rewers, M., Hagopian, W., Toppari, J., Ziegler, A. G., … Petrosino, J. F. (2018). Temporal development of the gut microbiome in early childhood from the TEDDY study. Nature, 562(7728). https://doi.org/10.1038/s41586-018-0617-x

Cell Press. (2024, April 2). Infant gut microbes have their own circadian rhythm, and diet has little impact on how the microbiome assembles. ScienceDaily. Retrieved December 15, 2025 from www.sciencedaily.com/releases/2024/04/240402135806.htm

Hickman, B., Salonen, A., Ponsero, A. J., Jokela, R., Kolho, K. L., de Vos, W. M., & Korpela, K. (2024). Gut microbiota wellbeing index predicts overall health in a cohort of 1000 infants. Nature Communications , 15(1). https://doi.org/10.1038/s41467-024-52561-6



Methods (500-1000 words) 
To evaluate whether sequencing depth limited diversity estimates, we first generated alpha rarefaction curves. Based on these curves, we quantified alpha diversity using an alignment-free k-mer approach, calculating Shannon entropy and Pielou’s evenness without phylogenetic reconstruction. Because this approach ignores phylogenetic structure, we validated the results using phylogeny-based core diversity metrics.
For downstream analyses, we fixed a subsampling depth of 9,000 reads and a k-mer size of 12. We justified this choice by comparing diversity estimates across k-mer sizes of 12, 14, and 16. To reduce stochastic effects from rarefaction, we applied bootstrapping and averaged diversity metrics across repeated resamples at the chosen depth.
Finally, we tested differences between timepoints using non-parametric Kruskal–Wallis tests on collapsed metadata.
(118 words) 

Results (1500 words)
Methodological validation supported the selected parameters. Rarefaction analysis showed that Shannon entropy plateaued between 5,000 and 10,000 reads. This plateau indicates that a depth of 9,000 reads captured community diversity while retaining most samples. Consistent with this, diversity estimates were robust to k-mer size. Metrics at k = 12 matched those at higher resolutions (k = 14, 16), despite increased computational cost.
Biologically, alignment-free analyses showed no significant differences in alpha diversity across the 2-, 4-, and 6-month timepoints, with richness and evenness remaining stable. In contrast, phylogeny-based core metrics detected a significant pairwise difference between months 2 and 4 (p = 0.048). This result suggests subtle phylogenetic shifts that are not resolved by k-mer–based methods.
(117)

Discussion (250-500 words) 
The stability of alpha diversity during the first six months is consistent with reports that major microbial diversification occurs later, particularly after weaning (Ding et al., 2025; Oyedemi et al., 2022). Because diversity estimates were robust to k-mer size and subsampling strategy, this stability likely reflects a biological pattern rather than a methodological artifact. The discrepancy between stable alignment-free metrics and the significant core-metric difference between months 2 and 4 suggests limited phylogenetic restructuring without changes in overall richness.
(79 words) 

Oyedemi, O. T., Shaw, S., Martin, J. C., Ayeni, F. A., & Scott, K. P. (2022). Changes in the gut microbiota of Nigerian infants within the first year of life. PLoS ONE, 17(3 March). https://doi.org/10.1371/journal.pone.0265123

Ding, M., Ross, R. P., Dempsey, E., Li, B., & Stanton, C. (2025). Infant gut microbiome reprogramming following introduction of solid foods (weaning). In Gut Microbes (Vol. 17, Issue 1). https://doi.org/10.1080/19490976.2025.2571428


