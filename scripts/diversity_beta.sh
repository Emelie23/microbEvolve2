#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

#PERMANOVA test checking whether the observed categories are significantly grouped
qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/raw/boots_kmer_diversity/distance_matrices/braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --m-metadata-column timepoint \
    --p-pairwise \
    --o-visualization $data_dir/processed/boots_kmer_diversity/distance_matrices/braycurtis_significance \

#PERMANOVA test with filtered metadata
#filter metadata file
md = pd.read_csv("metadata_per_sample.tsv", sep="\t")
md_sub = md[md['timepoint'].isin(["2 months","4 months","6 months"])]

# Keep only infants that have all three timepoints
valid_ids = md_sub.groupby('infant_id').filter(lambda x: set(x['timepoint']) == {"2 months","4 months","6 months"})

# Rename the sample ID column 
valid_ids.rename(columns={"sampleid": "#SampleID"}, inplace=True)

# Reorder so #SampleID is the first column
cols = valid_ids.columns.tolist()
cols.insert(0, cols.pop(cols.index("#SampleID")))
valid_ids = valid_ids[cols]

# Strip whitespace/BOM from headers
valid_ids.columns = valid_ids.columns.str.strip()
valid_ids.columns = [c.replace("\ufeff", "") for c in valid_ids.columns]

# Save clean file with tabs, no quotes
valid_ids.to_csv("metadata_per_sample_filtered.tsv", sep="\t", index=False, quoting=csv.QUOTE_NONE)


#new filtered table containing filtered data
qiime feature-table filter-samples \
  --i-table /home/jovyan/microbEvolve2/data/raw/dada2_table.qza \
  --m-metadata-file metadata_per_sample_filtered.tsv \
  --o-filtered-table $data_dir/raw/infants_2_4_6_months.qza

qiime diversity beta \
  --i-table /home/jovyan/microbEvolve2/data/raw/infants_2_4_6.qza \
  --p-metric braycurtis \
  --o-distance-matrix /home/jovyan/microbEvolve2/data/raw/infants_2_4_6_braycurtis.qza

qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/raw/infants_2_4_6_braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata_filtered.tsv \
    --m-metadata-column timepoint \
    --p-pairwise \
    --o-visualization $data_dir/raw/boots_kmer_diversity/distance_matrices/braycurtis_significance_filtered \
    
    
