import pandas as pd

print("Filtering metadata for ...")

data_dir = "data/raw"


metadata_filtered = metadata.groupby("infant_id")["timepoint"].nunique().eq(3)
metadata_filtered_index = metadata_filtered[metadata_filtered].index
metadata_filtered = metadata[metadata["infant_id"].isin(metadata_filtered_index)]

# print("Number of infant in original metadata: ", metadata["infant_id"].nunique())
# print("Number of infants left after filtering: ", metadata_filtered["infant_id"].nunique())

# print("Number of samples per infant per timepoint: ")
# metadata_filtered.groupby(["infant_id", "timepoint"]).size().unstack()

metadata_filtered.to_csv(f"{data_dir}/raw/metadata_filtered.tsv", sep="\t", header=True, index=True)

print(f"Filtered metadata file written to {data_dir}/raw/metadata_filtered.tsv")