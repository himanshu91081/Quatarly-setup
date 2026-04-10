#!/bin/bash

vars_to_remove=(
    "ANTHROPIC_BASE_URL"
    "ANTHROPIC_AUTH_TOKEN"
    "ANTHROPIC_DEFAULT_HAIKU_MODEL"
    "ANTHROPIC_DEFAULT_SONNET_MODEL"
    "ANTHROPIC_DEFAULT_OPUS_MODEL"
)

# Common shell configuration files where persistent vars are usually stored
config_files=(
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.zshrc"
    "$HOME/.profile"
)

for key in "${vars_to_remove[@]}"; do
    # 1. Unset from the current session (Requires sourcing the script to take effect in parent shell)
    unset "$key"
    
    # 2. Remove from persistent shell configuration files
    for file in "${config_files[@]}"; do
        if [ -f "$file" ]; then
            # Filters out lines starting with 'export VAR=' or 'VAR=' 
            # Uses a temporary file for cross-platform compatibility (macOS/Linux)
            grep -vE "^(export )?$key=" "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
        fi
    done
done

echo "All 3rd-party Claude environment variables have been successfully deleted!"
echo "IMPORTANT: Please restart your terminal, IDE, or code editor to apply the changes."
