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
    "model": "claude-sonnet-4-6-thinking",
    "id": "custom:claude-sonnet-4-6-thinking-0",
    "index": 0,
    "baseUrl": "https://api.quatarly.cloud/",
    "apiKey": "your-api-key",
    "displayName": "claude-sonnet-4-6-thinking",
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
| `claude-sonnet-4-6-thinking` | anthropic | `https://api.quatarly.cloud/` |
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

## Using Claude Code as a Client

You can use [Claude Code](https://docs.anthropic.com/en/docs/claude-code) as a CLI client pointed at Quatarly instead of Anthropic directly. No Anthropic account or API key needed — just your Quatarly key.

### Step 1 — Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

---

### Step 2 — Set Environment Variables

**Option A — Let your LLM agent do it**

Paste this prompt into any LLM agent (Factory Droid, Claude Code, etc.):

```
Follow the Claude Code setup instructions at https://raw.githubusercontent.com/himanshu91081/Quatarly-setup/main/README.md

My Quatarly API key is: <your-api-key>

Run the appropriate setup script for my OS (set-claude-env.ps1 for Windows, set-claude-env.sh for macOS/Linux)
to set the environment variables so Claude Code routes through Quatarly.
```

---

**Option B — Run manually (humans)**

Download the setup script and run it with your API key:

**Windows** (PowerShell):
```powershell
.\set-claude-env.ps1 -ApiKey "qua_trail_your-key-here"
```

**macOS / Linux** (Bash):
```bash
bash set-claude-env.sh qua_trail_your-key-here
```

The variables are set **globally** (user-level persistent) — they survive terminal restarts.

- **New terminal**: picks up automatically
- **Current terminal**: run `source ~/.zshrc` (macOS) or `source ~/.bashrc` (Linux) to apply immediately
- **GUI apps / VS Code / system services**: require a **full logout or system restart** to pick up the new env vars

---

**Option C — Set manually without any script**

If you just want to set it for the current terminal session only:

**macOS / Linux:**
```bash
export ANTHROPIC_BASE_URL="https://api.quatarly.cloud/"
export ANTHROPIC_AUTH_TOKEN="qua_trail_your-key-here"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5-20251001"
export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-6-thinking"
export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-6-thinking"
```

**Windows (PowerShell):**
```powershell
$env:ANTHROPIC_BASE_URL             = "https://api.quatarly.cloud/"
$env:ANTHROPIC_AUTH_TOKEN           = "qua_trail_your-key-here"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL  = "claude-haiku-4-5-20251001"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6-thinking"
$env:ANTHROPIC_DEFAULT_OPUS_MODEL   = "claude-opus-4-6-thinking"
```

To make it permanent, add the `export` lines to your `~/.zshrc` (macOS) or `~/.bashrc` (Linux), or use `[System.Environment]::SetEnvironmentVariable(...)` on Windows. After doing so, **restart your system** (or log out and back in) so all apps pick up the changes.

---

This sets the following environment variables:

| Variable | Value |
|----------|-------|
| `ANTHROPIC_BASE_URL` | `https://api.quatarly.cloud/` |
| `ANTHROPIC_AUTH_TOKEN` | your Quatarly API key |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `claude-haiku-4-5-20251001` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `claude-sonnet-4-6-thinking` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `claude-opus-4-6-thinking` |

### Step 3 — Run Claude Code

```bash
claude
```

Claude Code will now route all requests through Quatarly using your API key and credit balance.

---

## Files

| File | Platform | Purpose |
|------|----------|---------|
| `add-quatarly-models.ps1` | Windows (PowerShell) | Factory AI Droid custom models |
| `add-quatarly-models.sh` | macOS / Linux (Bash) | Factory AI Droid custom models |
| `set-claude-env.ps1` | Windows (PowerShell) | Claude Code env setup |
| `set-claude-env.sh` | macOS / Linux (Bash) | Claude Code env setup |
