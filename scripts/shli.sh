#!bin/zsh

PROJECT_FOLDER="$WORKSPACE/shli"
DB_FOLDER="$HOME/.shli"
PROJECT_DB="$DB_FOLDER/projects.json"

shli() {
    local scripts_folder="$PROJECT_FOLDER/scripts"
    local command=$1
    local subcommand=$2

    if [ ! -f "$PROJECT_DB" ]; then
        pretty "white" "Creating project database..."
        mkdir -p "$DB_FOLDER"
        echo "{}" >"$PROJECT_DB"
    fi

    case "$command" in
    "update" | "reload")
        source "$PROJECT_FOLDER/loader.sh"
        ;;

    "edit")
        code "$PROJECT_FOLDER"
        ;;

    "changes")
        git -C "$PROJECT_FOLDER" diff --stat
        ;;

    "diff")
        git config --global color.ui true
        git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

        git -C "$PROJECT_FOLDER" diff --color-words
        ;;

    "save")
        local commit_message="$2"

        if [[ ! -n $(git -C "$PROJECT_FOLDER" status -s) ]]; then
            pretty "green bold" "All good."
            cd "$curr_dir"
            return 0
        fi

        if [ -z "$commit_message" ]; then
            pretty "red" "Error: please provide a message for the commit"
            print_usage "Usage Examples:" \
                "shli save \"added new command save\""
            return 1
        fi

        curr_dir=$(pwd)
        cd "$PROJECT_FOLDER"

        {
            local message="Saving changes..."
            echo -ne "$message"

            quiet_git add .
            quiet_git commit -m "$commit_message"
            quiet_git push

            echo -ne "\r$message \e[32mOK\e[0m\n"
            cd "$curr_dir"
        } || {
            pretty_text "red bold" "\nFailed to save changes."
        }

        ;;
    "del_node_modules")
        # delete all node_modules folders inside the current folder
        find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
        ;;

    "show")
        source "$PROJECT_FOLDER/loader.sh"
        case "$subcommand" in
        "")
            for script in "$scripts_folder"/*.sh; do
                if [[ -r "$script" ]]; then
                    print_header "Script: $script"
                    cat "$script"
                else
                    pretty "yellow" "Warning: Cannot read script $script"
                fi
            done
            ;;
        *)
            local filename="$scripts_folder"/$subcommand.sh
            if [ -f "$filename" ]; then
                bat $filename
            else
                pretty "yellow" "File not found: $filename"
            fi
            ;;
        esac
        ;;

    "go")
        local project=${2-"shli"}

        shli project go "$project"
        ;;

    "project" | "projects")
        case "$subcommand" in
        "setup")
            pretty "white" "Creating project database..."

            # if the file does not exist, create it
            if [ ! -f "$PROJECT_DB" ]; then
                mkdir -p "$DB_FOLDER"
                echo "{}" >"$PROJECT_DB"
                return 0
            fi

            pretty "green" "Project database already exists!"
            ;;

        "add")
            local project_name=$3
            local project_dir=${4-$(pwd)}

            if [[ -z "$project_name" || -z "$project_dir" ]]; then
                print_usage "Usage Examples:" \
                    "shli project add <PROJECT_NAME> <PROJECT_DIR>"
                return 1
            fi

            project_dir=$(realpath "$project_dir")

            # Add the project name and directory to the JSON file
            jq --arg name "$project_name" --arg dir "$project_dir" '. + {($name): $dir}' "$PROJECT_DB" >tmp.$$.json && mv tmp.$$.json "$PROJECT_DB"
            echo "Project '$project_name' added successfully!"
            ;;

        "rm")
            local project_name=$3

            if [[ -z "$project_name" ]]; then
                print_usage "Usage Examples:" \
                    "shli project rm <PROJECT_NAME>"
                return 1
            fi

            # del the project from the JSON file
            jq --arg name "$project_name" 'del(.[$name])' "$PROJECT_DB" >tmp.$$.json && mv tmp.$$.json "$PROJECT_DB"
            echo "Project '$project_name' successfully removed from the list!"
            ;;

        "go")
            local project_name=$3

            local project_dir=$(validate_project_name "$project_name")

            if [[ -z "$project_dir" ]]; then
                return 1
            fi

            # Change to the project directory
            cd "$project_dir" || {
                echo "Failed to navigate to $project_dir"
                return 1
            }

            echo "Navigated to $project_dir"
            ;;

        "list" | "")
            echo "Current Projects:"
            jq '.' "$PROJECT_DB"

            print_usage "Useful commands from here:" \
                "shli project go tour" \
                "shli project rm tour"
            ;;

        *)
            shli project go "$subcommand"
            ;;

        esac
        ;;

    "help")
        print_help "Shli Commands" \
            "go" "Navigates into the shli project folder" \
            "update|reload" "Refreshes Aliases" \
            "edit" "Open shli project in the code editor" \
            "save" "Commits any uncommited changes from the shli project folder" \
            "show" "Prints all alias files or only one if a name is given" \
            "project" "Manages internal projects and locations for easy navigation" \
            "help" "Display this help message"

        print_usage "Usage Examples:" \
            "shli go" \
            "shli show" \
            "shli show git"

        ;;

    "")
        echo -n "Updating aliases..."
        source "$PROJECT_FOLDER/loader.sh"
        echo -e "\rUpdating aliases... \e[32mOK\e[0m"
        ;;

    *)
        print_invalid
        ;;

    esac
}

validate_project_name() {
    local project_name=$1

    if [[ -z "$project_name" ]]; then
        print_usage "Usage Examples:" \
            "shli project go <PROJECT_NAME>" >&2
        return 1
    fi

    # Retrieve the project directory from the JSON file
    local project_dir=$(jq -r --arg name "$project_name" '.[$name] // empty' "$PROJECT_DB")

    if [[ -z "$project_dir" ]]; then
        pretty "red bold" "Project '$project_name' not found!" >&2
        return 1
    fi

    echo "$project_dir"
}
