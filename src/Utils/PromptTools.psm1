
function Set-PromptWords {
    param (
        [string]$PromptText,
        [string]$Words
    )

    if ($Words -and $PromptText.Contains("<WORD>")) {
        return $PromptText.Replace("<WORD>", " $Words ")
    }
    elseif ($PromptText.Contains("<WORD>")) {
        return $PromptText.Replace("<WORD>", " ")
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
