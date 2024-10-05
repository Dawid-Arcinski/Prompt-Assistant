param(
    [Alias("h")]
    [switch]$Help,
    [Alias("t")]
    [string]$Template,
    [Alias("w")]
    [string]$Words = "",
    [Alias("c")]
    [int]$Counter = 1
)


# SETUP

$CurrentDir = Get-Location
$MainDir = [System.Environment]::GetEnvironmentVariable("PROMPT_ASSISTANT_ROOT", "User")
Set-Location $MainDir

Import-Module ./Utils/PromptTools.psm1
Import-Module ./Utils/DataTools.psm1

$PromptData = Get-PromptData -Path "data/prompts.csv"
$Templates = $PromptData.template
$BigCounterTreshold = 20


# VALIDATION

if ($Help) {
    Write-Output $PromptData
    Exit
}

if ($Template -and ($Templates -notcontains $Template)) {
    Write-Error "Template $Template is not present in prompt data"
    Exit
}


# PREPROCESSING

foreach ($Entry in $PromptData) {
    if ($Entry.template -eq $Template) {
        $PromptTemplate = $Entry
    }
}

if ($PromptTemplate.compute_heavy -eq "true" -and $Counter -ge $BigCounterTreshold) {
    Write-Warning "Selected prompt is resource-intesive. Press 'y' to continue or any other key to abort: "
    $userInput = Read-Host

    if ($userInput.ToLower() -ne "y") {
        Write-Output "Terminating script"
        Exit
    }
}

if ($PromptTemplate.uses_clipboard) {
    $Context = Get-Clipboard
    $Context = "`n`n$Context"
}
else {
    $Context = ""
}



# APPLYING OPTIONS

$Text = $PromptTemplate.text
$Text = Set-PromptWords -PromptText $text -Words $Words
$Text = Set-PromptCounter -PromptText $text -Counter $Counter

$prompt = $Text + $Context
Set-Clipboard $prompt


# CLEANUP

Set-Location $CurrentDir
