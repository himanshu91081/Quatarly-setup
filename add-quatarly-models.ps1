# Platform: Windows

$SettingsPath = "$env:USERPROFILE\.factory\settings.json"

if (-not (Test-Path $SettingsPath)) {
    Write-Host "Error: settings.json not found at $SettingsPath"
    exit 1
}

Write-Host "Found settings.json at $SettingsPath"
$ApiKey = Read-Host "Enter your Quatarly API key"

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    Write-Host "Error: API key cannot be empty"
    exit 1
}

Copy-Item $SettingsPath "$SettingsPath.backup" -Force

$TempScript = [System.IO.Path]::GetTempFileName() + ".py"

$PythonCode = 'import json, codecs

settings_path = ' + '"' + $SettingsPath.Replace('\','\\') + '"' + '
api_key = ' + '"' + $ApiKey + '"' + '

new_models = [
    {"model": "claude-sonnet-4-6-20250929", "baseUrl": "https://api.quatarly.cloud/",   "apiKey": api_key, "provider": "anthropic", "displayName": "claude-sonnet-4-6-20250929"},
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

with open(settings_path, "rb") as f:
    raw = f.read()
if raw.startswith(codecs.BOM_UTF8):
    raw = raw[3:]
settings = json.loads(raw.decode("utf-8").strip() or "{}")

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
            "id":             "custom:" + m["model"] + "-" + str(next_index),
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

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2)

print("Done. " + str(added) + " new models added, " + str(updated) + " existing models updated.")
print("customModels total: " + str(len(existing)))
'

[System.IO.File]::WriteAllText($TempScript, $PythonCode, [System.Text.Encoding]::UTF8)
python3 $TempScript
Remove-Item $TempScript -Force
