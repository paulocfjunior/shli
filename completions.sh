#!/bin/zsh

# For Zsh: Initialize compinit if it is not already loaded
if [[ -n $ZSH_VERSION ]]; then
    autoload -Uz compinit
    compinit
fi

# Get the directory of the current loader.sh script
completion_dir="$WORKSPACE/labs/shell-aliases"

# Define the folder where completions are located
completions_folder="$completion_dir/completions"

# Check if the folder exists
if [[ ! -d "$completions_folder" ]]; then
    echo "Completions folder not found: $completions_folder"
    exit 1
fi

# Loop through all .sh files in the completions folder and source them
for completion in "$completions_folder"/*.sh; do
    # Check if the completion is a readable file
    if [[ -r "$completion" ]]; then
        source "$completion"
    else
        echo "Warning: Cannot read completion $completion"
    fi
done
