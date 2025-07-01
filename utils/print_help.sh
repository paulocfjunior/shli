#!/bin/zsh

pretty() {
    local style_string="$1" # Capture the style string (e.g., "yellow bold underline")
    shift                   # Remove the style string from the arguments
    local text="$1"         # Capture the actual text to be formatted

    # Initialize the formatting variable
    local format=""

    # Split the style string into an array of styles compatible with zsh
    local style_arr=("${(@s/ /)style_string}")

    local style
    for style in "${style_arr[@]}"; do
        case "$style" in
        # Text colors
        black) format+="\e[30m" ;;
        red) format+="\e[31m" ;;
        green) format+="\e[32m" ;;
        yellow) format+="\e[33m" ;;
        blue) format+="\e[34m" ;;
        magenta) format+="\e[35m" ;;
        cyan) format+="\e[36m" ;;
        white) format+="\e[37m" ;;

        # Background colors
        bgBlack) format+="\e[40m" ;;
        bgRed) format+="\e[41m" ;;
        bgGreen) format+="\e[42m" ;;
        bgYellow) format+="\e[43m" ;;
        bgBlue) format+="\e[44m" ;;
        bgMagenta) format+="\e[45m" ;;
        bgCyan) format+="\e[46m" ;;
        bgWhite) format+="\e[47m" ;;

        # Text formatting styles
        bold) format+="\e[1m" ;;
        underline) format+="\e[4m" ;;
        italic) format+="\e[3m" ;;
        reverse) format+="\e[7m" ;;
        strike) format+="\e[9m" ;;
        reset) format="\e[0m" ;; # Reset formatting completely
        *)
            echo "Unknown style: $style" >&2
            ;;
        esac
    done

    # Return the formatted text instead of printing it
    echo -e "${format}${text}\e[0m"
}

print_usage() {
    local title="$1"
    shift
    local examples=("$@")

    pretty "bold" "\n$title"

    # Iterate over each example pair (command and description)
    for ((i = 0; i < ${#examples[@]}; i += 1)); do
        local command="${examples[i + 1]}"

        command=$(pretty "yellow bold" "$command")
        echo -e "  - ${command}"
    done
}

print_help() {
    local title="$1"
    shift
    local commands=("$@")

    pretty "bold cyan" "\n$title\n"

    # get the biggest command name and calculate the amount of chars
    local max_length=0
    for ((i = 0; i < ${#commands[@]}; i += 2)); do
        local command="${commands[i + 1]}"
        if [[ ${#command} -gt $max_length ]]; then
            max_length=${#command}
        fi
    done
    max_length=$((max_length + 5))

    # Print each command and its description
    for ((i = 0; i < ${#commands[@]}; i += 2)); do
        local command="${commands[i + 1]}"
        local description="${commands[i + 2]}"

        # Format: <command name> : <description>
        local command_name=$(pretty "yellow" "$command")
        description=$(pretty "white" "${description}")

        # Add spaces to align the descriptions
        local spaces=$((max_length - ${#command}))
        for ((j = 0; j < spaces; j += 1)); do
            command_name+=" "
        done

        local formatted_command="${command_name} ${description}"

        if [[ "$command" == "default" ]]; then
            local title=$(pretty "bold white" "Default Behavior (no params):")
            description=$(pretty "white" "${description}")
            formatted_command="${title} ${description} \n"
        fi

        echo -e "${formatted_command}"
    done
}

print_invalid() {
    pretty "red bold" "Invalid parameter. Use help to see the options."
}
