#!/bin/zsh

DB_FOLDER="$HOME/.shli"
PROJECT_DB="$DB_FOLDER/projects.json"
PROJECT_FOLDER="$HOME/code/labs/shell-aliases"
SCRIPT_DIR="$PROJECT_FOLDER/scripts"

_shli_autocomplete() {
    local cur prev opts scripts

    # Capture the current and previous word
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"

    # Define main commands
    opts="go update edit changes diff show project del_node_modules help"

    # Handle autocompletion for "shli show <script>"
    if [[ "$prev" == "show" ]]; then
        # Find all script files in the specified directory, remove the .sh extension, and store them in an array
        scripts=$(find "$SCRIPT_DIR" -type f -name "*.sh" -exec basename {} .sh \;)

        # Use compgen to generate possible completions based on the script filenames
        COMPREPLY=($(compgen -W "$scripts" -- "$cur"))
    elif [[ "$prev" == "project" ]]; then
        # get projects from PROJECT_DB file, it may be empty
        projects=$(jq -r 'keys[]' "$PROJECT_DB")

        # Use compgen to generate possible completions based on the project names
        COMPREPLY=($(compgen -W "$projects" -- "$cur"))
    else
        # Default completion for main commands
        COMPREPLY=($(compgen -W "$opts" -- "$cur"))
    fi

    return 0
}

# Register the autocomplete function for the `shli` command
complete -F _shli_autocomplete shli
