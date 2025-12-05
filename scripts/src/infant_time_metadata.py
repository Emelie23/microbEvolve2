import pandas as pd

print("Create new metadata file with infant id + timepoint...")

data_dir = "../data"


metadata = pd.read_csv(f"{data_dir}/raw/metadata.tsv", sep="\t", index_col=0)

# create new column with: infant_ID_timepoint
metadata["infant_time"] = (
    "infant_" +
    metadata["infant_id"].astype(str) +
    "_" +
    metadata["timepoint"].astype(str).str[0]
)

metadata.to_csv(f"{data_dir}/raw//metadata_infant_time.tsv", sep="\t", index=True)

print("Metadata file created successfuly...")