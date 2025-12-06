import pandas as pd

print("Starting script infant_time_metadata...")

data_dir = "../data"

#load metadata into dataframe
metadata = pd.read_csv(f"{data_dir}/raw/metadata.tsv", sep="\t", index_col=0)

# create new column with: infant_ID_timepoint (that can later be used to collapse feature table and metadata)
metadata["infant_time"] = (
    "infant_" +
    metadata["infant_id"].astype(str) +
    "_" +
    metadata["timepoint"].astype(str).str[0]
)

#save dataframe as new .tsv file
metadata.to_csv(f"{data_dir}/raw/metadata_infant_time.tsv", sep="\t", index=True)

print("Intermediate metadata file metadata_infant_time.tsv created successfully!")