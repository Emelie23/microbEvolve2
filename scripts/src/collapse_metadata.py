import pandas as pd

print("Starting script collapse_metadata script...")

data_dir = "../data"

metadata = pd.read_csv(f"{data_dir}/raw/metadata_infant_time.tsv", sep="\t")

# delete current sampleid column (as we won't further need these)
metadata = metadata.drop(columns=["sampleid"])

# rename infant_time to sampleid (as this is our new unique sample id)
metadata = metadata.rename(columns={"infant_time": "sampleid"})

# collapse the metadata to obtain one representative entry per infant per timepoint. Since all samples from the same timepoint share identical metadata values, we simply keep the first entry for each group
metadata_collapsed = metadata.groupby("sampleid", as_index=False).first()
metadata_collapsed.to_csv(f"{data_dir}/raw/metadata_collapsed.tsv", sep="\t", index=False)

#create metadata file with type information for every column
type_information = pd.DataFrame(
    # index=["#q2:types"],
    columns=metadata_collapsed.columns,
    data=[
        [
            "#q2:types",
            "categorical",
            "categorical",
            "categorical",
            "numeric",
            "categorical",
            "categorical",
            "categorical",
            "numeric",
            "categorical",
            "numeric",
            "numeric",
            "numeric",
            "numeric",
        ]
    ],
)

# collapse metadata with type information to have one representative sample per infant per timepoint
metadata_collapsed_withtypes = pd.concat([type_information, metadata_collapsed])
metadata_collapsed_withtypes.to_csv(f"{data_dir}/raw/metadata_collapsed_withtypes_test.tsv", sep="\t", index=False)

print(f"Metadata collapsed successfully, collapsed_metadata.tsv and metadata_collapsed_withtypes.tsv stored in {data_dir}/raw")
