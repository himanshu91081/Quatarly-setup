#!/bin/bash
# Platform: macOS / Linux

SETTINGS_PATH="$HOME/.factory/settings.json"

if [ ! -f "$SETTINGS_PATH" ]; then
    echo "Error: settings.json not found at $SETTINGS_PATH"
    exit 1
fi

echo "Found settings.json at $SETTINGS_PATH"
read -p "Enter your Quatarly API key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo "Error: API key cannot be empty"
    exit 1
fi

cp "$SETTINGS_PATH" "$SETTINGS_PATH.backup"

python3 - "$SETTINGS_PATH" "$API_KEY" <<'PYEOF'
import json, sys

settings_path = sys.argv[1]
api_key = sys.argv[2]

new_models = [
    {"model": "claude-sonnet-4-6-thinking", "baseUrl": "https://api.quatarly.cloud/",   "apiKey": api_key, "provider": "anthropic", "displayName": "claude-sonnet-4-6-thinking"},
    {"model": "claude-opus-4-6-thinking",   "baseUrl": "https://api.quatarly.cloud/",   "apiKey": api_key, "provider": "anthropic", "displayName": "claude-opus-4-6-thinking"  },
    {"model": "claude-haiku-4-5-20251001",  "baseUrl": "https://api.quatarly.cloud/",   "apiKey": api_key, "provider": "anthropic", "displayName": "claude-haiku-4-5-20251001" },
    {"model": "gemini-3.1-pro",             "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gemini-3.1-pro"            },
    {"model": "gemini-3-flash",             "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gemini-3-flash"            },
    {"model": "gpt-5.1",                    "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gpt-5.1"                   },
    {"model": "gpt-5.1-codex",              "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gpt-5.1-codex"             },
    {"model": "gpt-5.1-codex-max",          "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gpt-5.1-codex-max"         },
    {"model": "gpt-5.2",                    "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gpt-5.2"                   },
    {"model": "gpt-5.2-codex",              "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gpt-5.2-codex"             },
    {"model": "gpt-5.3-codex",              "baseUrl": "https://api.quatarly.cloud/v1", "apiKey": api_key, "provider": "openai",    "displayName": "gpt-5.3-codex"             },
]

raw = open(settings_path, "r").read().strip()
settings = json.loads(raw) if raw else {}

existing = settings.get("customModels", [])
existing_names = {m["model"] for m in existing}

max_index = max((m.get("index", -1) for m in existing), default=-1)
next_index = max_index + 1

added = 0
updated = 0
for m in new_models:
    if m["model"] in existing_names:
        for e in existing:
            if e["model"] == m["model"]:
                e["apiKey"] = m["apiKey"]
                e["baseUrl"] = m["baseUrl"]
                e["provider"] = m["provider"]
        updated += 1
    else:
        existing.append({
            "model":          m["model"],
            "id":             f"custom:{m['model']}-{next_index}",
            "index":          next_index,
            "baseUrl":        m["baseUrl"],
            "apiKey":         m["apiKey"],
            "displayName":    m["displayName"],
            "noImageSupport": False,
            "provider":       m["provider"],
        })
        next_index += 1
        added += 1

settings["customModels"] = existing

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print(f"Done. {added} new models added, {updated} existing models updated.")
print(f"Backup saved at {settings_path}.backup")
PYEOF
