#!/bin/bash

# Get the directory of the current loader.sh script
script_dir="$WORKSPACE/shli"

utils_folder="$script_dir/utils"
scripts_folder="$script_dir/scripts"

# Check if the folder exists
if [[ ! -d "$scripts_folder" ]]; then
  echo "Scripts folder not found: $scripts_folder"
  exit 1
fi

if [[ -d "$utils_folder" ]]; then
  for script in "$utils_folder"/*.sh; do
    if [[ -r "$script" ]]; then
      source "$script"
    else
      echo "Warning: Cannot read utility script $script"
    fi
  done
fi

# Loop through all .sh files in the scripts folder and source them
for script in "$scripts_folder"/*.sh; do
  # Check if the script is a readable file
  if [[ -r "$script" ]]; then
    source "$script"
  else
    echo "Warning: Cannot read script $script"
  fi
done

source "$script_dir/completions.sh"
