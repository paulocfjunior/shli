print_header() {
    local header_text="$1"
    local border_length="${#header_text}"
    local border=""

    # Define color codes
    local color_red="\e[31m"   # Red color
    local color_green="\e[32m" # Green color
    local color_blue="\e[34m"  # Blue color
    local reset_color="\e[0m"  # Reset color to default

    # Choose colors for the header and border (change these as desired)
    local header_color="$color_green"
    local border_color="$color_green"

    # Create a border of dashes that matches the length of the header text
    for ((i = 0; i < border_length + 12; i++)); do
        border+="-"
    done

    echo "\n"
    echo -e "${border_color}${border}${reset_color}"
    echo -e "${border_color}| ${header_color}${header_text}${reset_color}         ${border_color}|${reset_color}"
    echo -e "${border_color}${border}${reset_color}"
}
