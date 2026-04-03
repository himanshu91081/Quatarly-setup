param(
    [Parameter(Mandatory=$true)]
    [string]$ApiKey
)

# Set both session-level and persistent User-level env vars
$vars = @{
    ANTHROPIC_BASE_URL             = "https://api.quatarly.cloud/"
    ANTHROPIC_AUTH_TOKEN           = $ApiKey
    ANTHROPIC_DEFAULT_HAIKU_MODEL  = "claude-haiku-4-5-20251001"
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6-thinking"
    ANTHROPIC_DEFAULT_OPUS_MODEL   = "claude-opus-4-6-thinking"
}

foreach ($key in $vars.Keys) {
    [System.Environment]::SetEnvironmentVariable($key, $vars[$key], "User")
    Set-Item "Env:$key" $vars[$key]
}

Write-Host "Claude Code env vars set (session + persistent):"
foreach ($key in $vars.Keys) {
    Write-Host "  $key = $($vars[$key])"
}
Write-Host ""
Write-Host "Restart your terminal to apply persistently, or use in current session now."
