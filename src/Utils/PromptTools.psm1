
function Set-PromptLanguage {
    param (
        [string]$PromptText,
        [string]$Language
    )

    if ($Language -and $PromptText.Contains("<LANG>")) {
        return $PromptText.Replace("<LANG>", " $Language ")
    }
    elseif ($PromptText.Contains("<LANG>")) {
        return $PromptText.Replace("<LANG>", " ")
    }
    else {
        return $PromptText
    }
  
}


function Set-PromptCounter {
    param (
        [string]$PromptText,
        [string]$Counter
    )

    if ($PromptText.Contains("<COUNTER>")) {
        return $PromptText.Replace("<COUNTER>", [string]$Counter)
    }
    else {
        return $PromptText
    }
    
}


function Add-ClipboardContent {
    param([switch]$UsesClipboard)

    if ($UsesClipboard) {
        return Get-Clipboard
    }
    else {
        return ""
    }
    
}