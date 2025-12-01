import pandas as pd

print("Start script to collapse metadata (and intermediate metadata file that is needed to collapse feature table)...")

data_dir = "data/raw"

metadata = pd.read_csv(f"{data_dir}/metadata.tsv", sep="\t")

# delete current sampleid column
metadata = metadata.drop(columns=["sampleid"])

# create new column with: infant_ID_timepoint
metadata["infant_time"] = (
    "infant_" +
    metadata["infant_id"].astype(str) +
    "_" +
    metadata["timepoint"].astype(str).str[0]
)

#rename infant_time to sampleid
metadata = metadata.rename(columns={"infant_time":"sampleid"})

# set sampleid as index
metadata = metadata.set_index("sampleid")

# collapse metadata to have one representative sample per infant per timepoint 
metadata_collapsed = metadata.groupby("sampleid").first() 


metadata_collapsed.to_csv(f"{data_dir}/metadata_collapsed.tsv", sep="\t", index=True)

print("Collapsed metadata file created successfully...")