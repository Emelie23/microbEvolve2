import pandas as pd

print("Merging metadata...")

data_dir = "../data"

metadata_per_sample = pd.read_csv(
    f"{data_dir}/raw/metadata_per_sample.tsv", sep="\t", index_col="sampleid"
)
metadata_per_sample["infant_id"] = metadata_per_sample["infant_id"].astype("category")

metadata_per_age = pd.read_csv(
    f"{data_dir}/raw/metadata_per_age.tsv", sep="\t", index_col=0
)

metadata = metadata_per_sample.reset_index().merge(
    right=metadata_per_age, how="left", on=["infant_id", "timepoint"]
)

metadata.to_csv(f"{data_dir}/raw/metadata.tsv", sep="\t", header=True, index=False)
print(f"Metadata file written to {data_dir}/raw/metadata.tsv")

type_information = pd.DataFrame(
    # index=["#q2:types"],
    columns=metadata.columns,
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
metadata_withtypes = pd.concat([type_information, metadata])

metadata_withtypes.to_csv(
    f"{data_dir}/raw/metadata_withtypes.tsv", sep="\t", header=True, index=False
)
print(
    f"Metadata file with type information written to {data_dir}/raw/metadata_withtypes.tsv"
)
