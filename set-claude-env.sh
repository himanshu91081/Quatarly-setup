#!/bin/bash
# Set Claude Code environment variables for macOS and Linux
# Usage: bash set-claude-env.sh <your-quatarly-api-key>
# Example: bash set-claude-env.sh qua_trail_abc123...

API_KEY="${1:-}"

if [ -z "$API_KEY" ]; then
    echo "Usage: bash set-claude-env.sh <your-quatarly-api-key>"
    echo "Example: bash set-claude-env.sh qua_trail_abc123..."
    exit 1
fi

BASE_URL="https://api.quatarly.cloud/"
HAIKU_MODEL="claude-haiku-4-5-20251001"
SONNET_MODEL="claude-sonnet-4-6-thinking"
OPUS_MODEL="claude-opus-4-6-thinking"

VARS="
export ANTHROPIC_BASE_URL=\"$BASE_URL\"
export ANTHROPIC_AUTH_TOKEN=\"$API_KEY\"
export ANTHROPIC_DEFAULT_HAIKU_MODEL=\"$HAIKU_MODEL\"
export ANTHROPIC_DEFAULT_SONNET_MODEL=\"$SONNET_MODEL\"
export ANTHROPIC_DEFAULT_OPUS_MODEL=\"$OPUS_MODEL\""

OS="$(uname -s)"

set_in_file() {
    local FILE="$1"
    if [ -f "$FILE" ]; then
        # Remove old entries
        sed -i.bak '/ANTHROPIC_BASE_URL\|ANTHROPIC_AUTH_TOKEN\|ANTHROPIC_DEFAULT_HAIKU_MODEL\|ANTHROPIC_DEFAULT_SONNET_MODEL\|ANTHROPIC_DEFAULT_OPUS_MODEL/d' "$FILE"
    fi
    echo "$VARS" >> "$FILE"
    echo "  Written to: $FILE"
}

if [ "$OS" = "Darwin" ]; then
    # macOS — write to user shell config files
    SHELL_NAME="$(basename "$SHELL")"
    if [ "$SHELL_NAME" = "zsh" ]; then
        set_in_file "$HOME/.zshrc"
        set_in_file "$HOME/.zprofile"
    else
        set_in_file "$HOME/.bashrc"
        set_in_file "$HOME/.bash_profile"
    fi
else
    # Linux — write to user shell config + /etc/profile.d if root
    SHELL_NAME="$(basename "$SHELL")"
    if [ "$SHELL_NAME" = "zsh" ]; then
        set_in_file "$HOME/.zshrc"
    else
        set_in_file "$HOME/.bashrc"
        set_in_file "$HOME/.bash_profile"
    fi

    # Also write system-wide if running as root
    if [ "$EUID" -eq 0 ]; then
        PROFILE_FILE="/etc/profile.d/claude-env.sh"
        echo "$VARS" > "$PROFILE_FILE"
        chmod 644 "$PROFILE_FILE"
        echo "  Written to: $PROFILE_FILE (system-wide)"

        # /etc/environment (no export keyword, Linux only)
        ENV_FILE="/etc/environment"
        if [ -f "$ENV_FILE" ]; then
            sed -i '/ANTHROPIC_BASE_URL\|ANTHROPIC_AUTH_TOKEN\|ANTHROPIC_DEFAULT_HAIKU_MODEL\|ANTHROPIC_DEFAULT_SONNET_MODEL\|ANTHROPIC_DEFAULT_OPUS_MODEL/d' "$ENV_FILE"
        fi
        {
            echo "ANTHROPIC_BASE_URL=\"$BASE_URL\""
            echo "ANTHROPIC_AUTH_TOKEN=\"$API_KEY\""
            echo "ANTHROPIC_DEFAULT_HAIKU_MODEL=\"$HAIKU_MODEL\""
            echo "ANTHROPIC_DEFAULT_SONNET_MODEL=\"$SONNET_MODEL\""
            echo "ANTHROPIC_DEFAULT_OPUS_MODEL=\"$OPUS_MODEL\""
        } >> "$ENV_FILE"
        echo "  Written to: $ENV_FILE (non-login shells)"
    fi
fi

# Apply to current session
export ANTHROPIC_BASE_URL="$BASE_URL"
export ANTHROPIC_AUTH_TOKEN="$API_KEY"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="$HAIKU_MODEL"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$SONNET_MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="$OPUS_MODEL"

echo ""
echo "Claude Code env vars set:"
echo "  ANTHROPIC_BASE_URL             = $ANTHROPIC_BASE_URL"
echo "  ANTHROPIC_AUTH_TOKEN           = $ANTHROPIC_AUTH_TOKEN"
echo "  ANTHROPIC_DEFAULT_HAIKU_MODEL  = $ANTHROPIC_DEFAULT_HAIKU_MODEL"
echo "  ANTHROPIC_DEFAULT_SONNET_MODEL = $ANTHROPIC_DEFAULT_SONNET_MODEL"
echo "  ANTHROPIC_DEFAULT_OPUS_MODEL   = $ANTHROPIC_DEFAULT_OPUS_MODEL"
echo ""
echo "Restart your terminal or run: source ~/.zshrc (or ~/.bashrc) to apply."
