$varsToRemove = @(
    "ANTHROPIC_BASE_URL",
    "ANTHROPIC_AUTH_TOKEN",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL",
    "ANTHROPIC_DEFAULT_SONNET_MODEL",
    "ANTHROPIC_DEFAULT_OPUS_MODEL"
)

foreach ($key in $varsToRemove) {
    # Remove from persistent User-level env vars
    [System.Environment]::SetEnvironmentVariable($key, $null, "User")
    
    # Remove from current session env vars (if they exist)
    if (Test-Path "Env:$key") {
        Remove-Item "Env:$key"
    }
}

Write-Host "All 3rd-party Claude environment variables have been successfully deleted!"
Write-Host "IMPORTANT: Please restart your terminal, IDE, or code editor to apply the changes."
