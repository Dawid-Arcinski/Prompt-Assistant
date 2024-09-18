param(
    [switch]$help,
    [string]$template
)

# STARTUP

$mainDir = [System.Environment]::GetEnvironmentVariable("PROMPT_ASSISTANT_HOME", "User")
Set-Location $mainDir
$promptData = Import-Csv 'data/prompts.csv'
$templates = $promptData.template

# VALIDATION

if ($help) {
    $promptData | Format-Table -Wrap
    Exit
}

if ($template -and ($templates -notcontains $template)) {
    Write-Error "Template $template is not present in prompt data"
    Exit
}

# PROCESSING

foreach ($entry in $promptData) {
    if ($entry.template -eq $template) {
        $text = $entry.text
    }
}

$context = Get-Clipboard
$prompt = $text + ("`n" * 2) + $context
Set-Clipboard $prompt

