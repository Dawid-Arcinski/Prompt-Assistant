param(
    [switch]$help,
    [string]$template,
    [string]$lang = "",
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

# PREPROCESSING

foreach ($entry in $promptData) {
    if ($entry.template -eq $template) {
        $promptTemplate = $entry
    }
}

if ($promptTemplate.uses_clipboard -eq 'true') {
    $context = Get-Clipboard
}
else {
    $context = ""
}

# APPLYING OPTIONS

$text = $promptTemplate.text

if ($lang -and $text.Contains('<LANG>')) {
    $text = $text.Replace('<LANG>', " $lang")
}
elseif ($text.Contains('<LANG>')) {
    $text = $text.Replace('<LANG>', "")
}

if ($multiplier -and $text.Contains('<MULTIPLIER>')) {
    $text = $text.Replace('<MULTIPLIER>', [string]$multiplier)
}
elseif ($text.Contains('<MULTIPLIER>')) {
    $text = $text.Replace('<MULTIPLIER>', '1')
}

$prompt = $text + ("`n" * 2) + $context
Set-Clipboard $prompt
