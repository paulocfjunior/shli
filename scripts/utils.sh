#!/bin/zsh

alias ll="ls -lah"
alias c="clear"
alias mkcd="mkdir $1 && cd $1"

dir_size() {
    local folder=""
    local recursive=false
    local exclude=""
    local depth=""
    local detailed=false

    # Parse flags
    while [[ "$#" -gt 0 ]]; do
        case $1 in
        -r) recursive=true ;;
        -e)
            exclude=$2
            shift
            ;;
        -d)
            depth=$2
            shift
            ;;
        -l) detailed=true ;;
        *) folder=$1 ;;
        esac
        shift
    done

    # Validate folder
    if [[ -z $folder ]]; then
        echo "Usage: dir_size <folder> [-r] [-e <pattern>] [-d]"
        return 1
    fi

    # Build base du command
    local du_cmd="du"
    local options=()

    # Add exclude option if provided
    if [[ -n $exclude ]]; then
        options+=("--exclude=$exclude")
    fi

    if [[ -n $depth ]]; then
        options+=("-d" "$depth")
    fi

    # Configure options based on flags
    if $detailed; then
        options+=("-h")
    elif [[ -n $depth ]]; then
        options+=("-h")
    else
        options+=("-sh")
    fi

    # Add recursive behavior
    if $recursive; then
        find . -name "$folder" -type d -exec $du_cmd "${options[@]}" {} +
    else
        $du_cmd "${options[@]}" "$folder"
    fi
}

jcat() {
    cat $1 | jq ".$2"
}
