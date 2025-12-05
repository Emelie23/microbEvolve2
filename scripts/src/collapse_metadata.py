import pandas as pd

print(
    "Start script to collapse metadata (and intermediate metadata file that is needed to collapse feature table)..."
)

data_dir = "../data"

metadata = pd.read_csv(f"{data_dir}/raw/metadata.tsv", sep="\t")

# delete current sampleid column
metadata = metadata.drop(columns=["sampleid"])

# create new column with: infant_ID_timepoint
metadata["infant_time"] = (
    "infant_"
    + metadata["infant_id"].astype(str)
    + "_"
    + metadata["timepoint"].astype(str).str[0]
)

# rename infant_time to sampleid
metadata = metadata.rename(columns={"infant_time": "sampleid"})

# # set sampleid as index
# metadata = metadata.set_index("sampleid")

# collapse metadata to have one representative sample per infant per timepoint
metadata_collapsed = metadata.groupby("sampleid", as_index=False).first()
metadata_collapsed.to_csv(f"{data_dir}/raw/metadata_collapsed.tsv", sep="\t", index=False)


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
metadata_collapsed_withtypes = pd.concat([type_information, metadata_collapsed])
metadata_collapsed_withtypes.to_csv(
    f"{data_dir}/raw/metadata_collapsed_withtypes.tsv", sep="\t", index=False
)

print("Collapsed metadata file created successfully...")
