param(
    [switch]$help,
    [string]$template,
    [string]$lang = "",
    [int]$Counter = 1
)


# STARTUP

$mainDir = [System.Environment]::GetEnvironmentVariable("PROMPT_ASSISTANT_ROOT", "User")
Set-Location $mainDir
Import-Module ./Utils/PromptTools.psm1
$promptData = Import-Csv "data/prompts.csv"
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
$text = Set-PromptLanguage -PromptText $text -Language $lang
$text = Set-PromptCounter -PromptText $text -Counter $Counter

$prompt = $text + ("`n" * 2) + $context
Set-Clipboard $prompt
