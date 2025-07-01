# Shli - Shell Utility Loader and Auto-Completion

This project provides a modular shell script loader (`loader.sh`) that sources all `.sh` scripts from a designated `scripts/` directory. It includes support for auto-completion of custom commands, making it easier to work with aliases, functions, and other utilities.

## 📂 Project Structure

```
/
├── loader.sh                     # Main loader script to source all utilities
├── completions.sh                # Auto-completion script
├── scripts/                      # Folder containing individual scripts
│   ├── git_aliases.sh            # Example script for Git aliases
│   ├── docker_aliases.sh         # Example script for Docker aliases
│   └── db_utils.sh               # Example script for database utilities
└── README.md                     # Documentation for this project
```

- **`loader.sh`**: This script automatically sources all `.sh` files in the `scripts/` folder and initializes the auto-completion functionality.
- **`scripts/`**: Contains individual scripts for modularized aliases, functions, or utilities.
- **`completions.sh`**: Contains individual scripts for modularized completion for the other aliases.

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/paulocfjunior/shli.git
cd shli
```

### 2. Add the `loader.sh` to Your `.bashrc` or `.zshrc`

Add the following line to your `.bashrc` or `.zshrc` to source the loader each time you start a new shell session:

```bash
source /path/to/your/repo/loader.sh
```

Replace `/path/to/your/repo` with the actual path to the cloned repository.

### 3. Create Custom Scripts

Add your own `.sh` scripts to the `scripts/` folder. For example, you can create a `my_aliases.sh` file with custom aliases:

```bash
# scripts/my_aliases.sh
alias ll='ls -la'
alias gs='git status'
```

### 4. Create completions for your Scripts

The `completions` folder can have multiple completion files, so you can create new files with completions for new functions.
