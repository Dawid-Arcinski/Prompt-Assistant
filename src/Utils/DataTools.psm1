
function Get-PromptData {
    param (
        [string]$Path
    )

    $CSVData = Import-Csv $Path
    $PromptData = [System.Collections.ArrayList]::new()

    for ($i = 0; $i -lt $CSVData.Length; $i++) {


        $Template = $CSVData[$i]
        $Template.uses_clipboard = [System.Convert]::ToBoolean($Template.uses_clipboard)
        $Template.compute_heavy = [System.Convert]::ToBoolean($Template.compute_heavy)
        $PromptData.Add($Template)
     
    }

    return $PromptData
  
}
