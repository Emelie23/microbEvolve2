"""
BROKEN
"""

import os
import warnings
import sys
import shutil

from ritme.evaluate_tuned_models import evaluate_tuned_models
from ritme.find_best_model_config import (
    _load_experiment_config,
    _load_taxonomy,
    find_best_model_config,
    save_best_models,
)
from ritme.split_train_test import _load_data, split_train_test

# Suppress warnings
warnings.filterwarnings("ignore", category=FutureWarning)

def main():
    
    # --- Configuration ---
    # Adjust paths to be relative to where the script is run, or use absolute paths
    # Assuming script is run from the 'scripts' directory or project root
    
    # If running from project root, data is in ./data
    # If running from scripts/, data is in ../data
    # We'll try to detect or assume standard structure. 
    # Based on notebook: data_dir = "../data"
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    data_dir = os.path.join(project_root, "data")
    
    path_to_ft = f"{data_dir}/raw/dada2_table.qza"
    path_to_md = f"{data_dir}/raw/metadata.tsv"
    path_to_tax = f"{data_dir}/raw/taxonomy_weighted_stool.qza"
    
    experiment_name = "v1_experiment"
    ritme_base_dir = f"{data_dir}/ritme"
    os.makedirs(ritme_base_dir, exist_ok=True)

    # Config is expected to be in scripts/ritme/ or similar
    model_config_path = os.path.join(script_dir, "ritme", f"{experiment_name}.json")
    
    print(f"Data directory: {data_dir}")
    print(f"Config path: {model_config_path}")
    
    # --- Load Data & Config ---
    print("Loading configuration and data...")
    if not os.path.exists(model_config_path):
        raise FileNotFoundError(f"Config file not found at {model_config_path}")

    config = _load_experiment_config(model_config_path)
    train_size = 0.8
    
    md, ft = _load_data(path_to_md, path_to_ft)
    print(f"Metadata shape: {md.shape}, Feature table shape: {ft.shape}")

    # --- Split Data ---
    print("Splitting data into train/val and test...")
    train_val, test = split_train_test(
        md,
        ft,
        group_by_column=config["group_by_column"],
        train_size=train_size,
        seed=config["seed_data"],
    )

    # --- Run Optimization ---
    print("Starting model optimization...")
    
    # Clean up existing experiment directory if it exists
    exp_path = os.path.join(ritme_base_dir, config['experiment_tag'])
    if os.path.exists(exp_path):
        print(f"Removing existing experiment directory: {exp_path}")
        shutil.rmtree(exp_path)
        
    tax = _load_taxonomy(path_to_tax)
    
    # path_store_model_logs should be the parent folder where the experiment folder will be created
    best_model_dict, path_to_exp = find_best_model_config(
        config=config, 
        train_val=train_val, 
        tax=tax, 
        tree_phylo=None, 
        path_store_model_logs=ritme_base_dir
    )

    # --- Save Best Models ---
    path_to_store_best_models = f"{path_to_exp}/best_models"
    os.makedirs(path_to_store_best_models, exist_ok=True)
    save_best_models(best_model_dict, path_to_store_best_models)
    print(f"Best models saved to: {path_to_store_best_models}")

    # --- Evaluate on Test Set ---
    print("Evaluating best models on test set...")
    metrics, scatter = evaluate_tuned_models(best_model_dict, config, train_val, test)
    print("\nTest Set Metrics:")
    print(metrics)

    print(f"\nTo view the experiment logs, run: mlflow ui --backend-store-uri {path_to_exp}/mlruns")

if __name__ == "__main__":
    main()
