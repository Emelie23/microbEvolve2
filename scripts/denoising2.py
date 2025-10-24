import subprocess

data_dir = "$HOME/microbEvolve2/data"

truncation_lengths_f: list[int] = [0, 250]
truncation_lengths_r: list[int] = [0, 218]
min_overlaps: list[None | int] = [12, 12]

n_options = len(truncation_lengths_f)

for i, (truncation_length_f, truncation_length_r, min_overlap) in enumerate(
    zip(truncation_lengths_f, truncation_lengths_r, min_overlaps)
):
    print(f"Denoising: {i+1}/{n_options}")
    i += 2
    subprocess.run(
        f"""qiime dada2 denoise-paired \
        --i-demultiplexed-seqs {data_dir}/raw/demux_paired_end.qza \
        --p-trunc-len-f {truncation_length_f}\
        --p-trunc-len-r {truncation_length_r}\
        --p-min-overlap {min_overlap}\
        --p-n-threads 10 \
        --o-table {data_dir}/raw/dada2_table_{i}.qza \
        --o-representative-sequences {data_dir}/raw/dada2_rep_set_{i}.qza \
        --o-denoising-stats {data_dir}/raw/dada2_stats_{i}.qza""",
        shell=True,
    )

for i in range(n_options):
    i += 2
    print(f"Processing DADA2 output: {i+1}/{n_options}")
    subprocess.run(
        f"qiime metadata tabulate \
                --m-input-file {data_dir}/raw/dada2_stats_{i}.qza \
                --o-visualization {data_dir}/processed/dada2_stats_{i}.qzv",
        shell=True,
    )

    subprocess.run(
        f"qiime feature-table tabulate-seqs \
                --i-data {data_dir}/raw/dada2_rep_set_{i}.qza \
                --o-visualization {data_dir}/processed/dada2_rep_set_{i}.qzv",
        shell=True,
    )

    subprocess.run(
        f"qiime feature-table summarize \
                --i-table {data_dir}/raw/dada2_table_{i}.qza \
                --o-visualization {data_dir}/processed/dada2_table_{i}.qzv",
        shell=True,
    )
