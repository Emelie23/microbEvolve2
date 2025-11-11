#!/bin/bash
data_dir="$HOME/microbEvolve2/data"

#merge shannon data from 12,14,16 kmer size together
qiime tools export \
  --input-path $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --output-path shannon_12

qiime tools export \
  --input-path $data_dir/raw/boots_kmer_diversity_14/alpha_diversities/shannon.qza \
  --output-path shannon_14

qiime tools export \
  --input-path $data_dir/raw/boots_kmer_diversity_16/alpha_diversities/shannon.qza \
  --output-path shannon_16


#importing exported files
shannon12 = pd.read_csv("shannon-12/alpha-diversity.tsv", sep="\t")
shannon14 = pd.read_csv("shannon-14/alpha-diversity.tsv", sep="\t")
shannon16 = pd.read_csv("shannon-16/alpha-diversity.tsv", sep="\t")

#rename for clarity
shannon12.rename(columns={"Unnamed: 0": "SampleID", "shannon_entropy": "shannon_k12"}, inplace=True)
shannon14.rename(columns={"Unnamed: 0": "SampleID", "shannon_entropy": "shannon_k14"}, inplace=True)
shannon16.rename(columns={"Unnamed: 0": "SampleID", "shannon_entropy": "shannon_k16"}, inplace=True)

#merging via SampleID
merged = shannon12.merge(shannon14, on="SampleID").merge(shannon16, on="SampleID")

#save as new table
merged.to_csv("shannon-combined.tsv", sep="\t", index=False)

#plot
merged.set_index("SampleID")[["shannon_k12","shannon_k14","shannon_k16"]].plot(kind="box")
plt.ylabel("Shannon Diversity")
plt.title("Comparison of Shannon values for different k-mer sizes")
plt.show()


#merge pielous evenness index from 12,14,16 kmer size together
qiime tools export \
  --input-path $data_dir/raw/boots_kmer_diversity/alpha_diversities/pielou.qza \
  --output-path pielou_12

qiime tools export \
  --input-path $data_dir/raw/boots_kmer_diversity_14/alpha_diversities/pielou.qza \
  --output-path pielou_14

qiime tools export \
  --input-path $data_dir/raw/boots_kmer_diversity_16/alpha_diversities/pielou.qza \
  --output-path pielou_16
  
#importing exported files
pielou12 = pd.read_csv("pielou_12/alpha-diversity.tsv", sep="\t")
pielou14 = pd.read_csv("pielou_14/alpha-diversity.tsv", sep="\t")
pielou16 = pd.read_csv("pielou_16/alpha-diversity.tsv", sep="\t")

#rename for clarity
pielou12.rename(columns={"Unnamed: 0": "SampleID", "pielou_evenness": "pielou_k12"}, inplace=True)
pielou14.rename(columns={"Unnamed: 0": "SampleID", "pielou_evenness": "pielou_k14"}, inplace=True)
pielou16.rename(columns={"Unnamed: 0": "SampleID", "pielou_evenness": "pielou_k16"}, inplace=True)

#merging via SampleID
merged = pielou12.merge(pielou14, on="SampleID").merge(pielou16, on="SampleID")

#save as new table
merged.to_csv("pielou-combined.tsv", sep="\t", index=False)

merged.set_index("SampleID")[["pielou_k12","pielou_k14","pielou_k16"]].plot(kind="box")
plt.ylabel("Pielous evenness index")
plt.title("Comparison of Pielous evenness index for different k-mer sizes")
plt.show()