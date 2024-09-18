param(
    [switch]$help,
    [string]$template,
    [int]$multiplier
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
        $promptTemplate = $entry
    }
}

if ($promptTemplate.uses_clipboard -eq 'true') {
    $context = Get-Clipboard
}
else {
    $context = ''
}

$text = $promptTemplate.text

if ($multiplier -and $text.Contains('<MULTIPLIER>')) {
    $text = $text.Replace('<MULTIPLIER>', [string]$multiplier)
}
elseif ($text.Contains('<MULTIPLIER>')) {
    $text = $text.Replace('<MULTIPLIER>', '1')
}

$prompt = $text + ("`n" * 2) + $context
Set-Clipboard $prompt
