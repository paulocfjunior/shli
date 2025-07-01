#!/bin/zsh
DB_FOLDER="$HOME/.shli"
CONNECTIONS_DB="$DB_FOLDER/connections.json"

_connect_autocomplete() {
    local cur prev opts sub_opts

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"

    # Define the main function options
    opts="add rm go list mv upload"

    connection_opts=$(jq -r 'keys[]' "$CONNECTIONS_DB")

    all_opts="$opts $connection_opts"

    COMPREPLY=($(compgen -W "${all_opts}" -- "$cur"))

    return 0
}

complete -F _connect_autocomplete connect
