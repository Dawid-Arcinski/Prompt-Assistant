
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


function Set-PromptMultiplier {
    param (
        [string]$PromptText,
        [string]$Multiplier
    )

    if ($PromptText.Contains("<MULTIPLIER>")) {
        return $PromptText.Replace("<MULTIPLIER>", [string]$Multiplier)
    }
    else {
        return $PromptText
    }
    
}