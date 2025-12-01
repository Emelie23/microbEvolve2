import pandas as pd

print("Merging metadata...")

data_dir = "data"

metadata_per_sample = pd.read_csv(
    f"{data_dir}/raw/metadata_per_sample.tsv", sep="\t", index_col="sampleid"
)
metadata_per_sample["infant_id"] = metadata_per_sample["infant_id"].astype("category")

metadata_per_age = pd.read_csv(
    f"{data_dir}/raw/metadata_per_age.tsv", sep="\t", index_col=0
)

metadata = (
    metadata_per_sample.reset_index()
    .merge(right=metadata_per_age, how="left", on=["infant_id", "timepoint"])
    .set_index("sampleid")
)

metadata["timepoint"] = metadata["timepoint"].replace(
    {"2 months": 2, "4 months": 4, "6 months": 6}
)

metadata.to_csv(f"{data_dir}/raw/metadata.tsv", sep="\t", header=True, index=True)

print(f"Metadata file written to {data_dir}/raw/metadata.tsv")
