# Quatarly — Custom Models Setup for Factory AI Droid

Connect Factory AI Droid to [Quatarly](https://api.quatarly.cloud) to access Claude, Gemini, and GPT models using your Quatarly API key.

## What You Get

- **Claude** — Sonnet 4.6, Opus 4.6 Thinking, Haiku 4.5
- **Gemini** — 3.1 Pro, 3 Flash
- **GPT** — 5.1, 5.1 Codex, 5.1 Codex Max, 5.2, 5.2 Codex, 5.3 Codex
- All models accessible through a single Quatarly API key

---

## Step 1 — Install Factory AI

**Windows:**
```powershell
irm https://app.factory.ai/cli/windows | iex
```

**macOS / Linux:**
```bash
curl -fsSL https://app.factory.ai/cli | sh
```

---

## Step 2 — Create a Factory Account

Go to [app.factory.ai](https://app.factory.ai) and create a free account. After signing up, open a terminal and run:

```bash
droid 
```
then login in your factory account

This will create `~/.factory/settings.json` on your machine.

---

## Step 3 — Run the Setup Script

You need your **Quatarly API key** (format: `qua_trail_...` or `qua_...`).

**Option A — Let your LLM agent do it**

Paste this prompt into Factory Droid (or any LLM agent):

```
Follow the setup instructions at https://raw.githubusercontent.com/himanshu91081/Quatarly-setup/main/README.md

My Quatarly API key is: <your-api-key>

Run the appropriate setup script for my OS to add Quatarly custom models to ~/.factory/settings.json
```

**Option B — Run manually**

**Windows** (PowerShell):
```powershell
.\add-quatarly-models.ps1
```

**macOS / Linux** (Bash):
```bash
bash add-quatarly-models.sh
```

The script will prompt you for your API key and automatically update `~/.factory/settings.json`.

---

## Step 4 — Verify

After running the script, check that `~/.factory/settings.json` contains a `customModels` section:

**Windows:**
```powershell
Get-Content "$env:USERPROFILE\.factory\settings.json" | Select-String "customModels" -A 5
```

**macOS / Linux:**
```bash
grep -A 5 "customModels" ~/.factory/settings.json
```

It should look like this:

```json
"customModels": [
  {
    "model": "claude-sonnet-4-6-20250929",
    "id": "custom:claude-sonnet-4-6-20250929-0",
    "index": 0,
    "baseUrl": "https://api.quatarly.cloud/",
    "apiKey": "your-api-key",
    "displayName": "claude-sonnet-4-6-20250929",
    "noImageSupport": false,
    "provider": "anthropic"
  },
  {
    "model": "gpt-5.1",
    "id": "custom:gpt-5.1-5",
    "index": 5,
    "baseUrl": "https://api.quatarly.cloud/v1",
    "apiKey": "your-api-key",
    "displayName": "gpt-5.1",
    "noImageSupport": false,
    "provider": "openai"
  }
]
```

---

## Models Added

| Model | Provider | Base URL |
|-------|----------|----------|
| `claude-sonnet-4-6-20250929` | anthropic | `https://api.quatarly.cloud/` |
| `claude-opus-4-6-thinking` | anthropic | `https://api.quatarly.cloud/` |
| `claude-haiku-4-5-20251001` | anthropic | `https://api.quatarly.cloud/` |
| `gemini-3.1-pro` | openai | `https://api.quatarly.cloud/v1` |
| `gemini-3-flash` | openai | `https://api.quatarly.cloud/v1` |
| `gpt-5.1` | openai | `https://api.quatarly.cloud/v1` |
| `gpt-5.1-codex` | openai | `https://api.quatarly.cloud/v1` |
| `gpt-5.1-codex-max` | openai | `https://api.quatarly.cloud/v1` |
| `gpt-5.2` | openai | `https://api.quatarly.cloud/v1` |
| `gpt-5.2-codex` | openai | `https://api.quatarly.cloud/v1` |
| `gpt-5.3-codex` | openai | `https://api.quatarly.cloud/v1` |

---

## Notes

- Running the script again with a new API key updates all existing models — it will not create duplicates.
- A backup of your original `settings.json` is saved as `settings.json.backup` before any changes.
- The script requires Python 3 (pre-installed on most systems).

---

## Files

| File | Platform |
|------|----------|
| `add-quatarly-models.ps1` | Windows (PowerShell) |
| `add-quatarly-models.sh` | macOS / Linux (Bash) |
