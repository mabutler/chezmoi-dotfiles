function prompt {
  $p = $executionContext.SessionState.Path.CurrentLocation
  if ($p.Provider.Name -eq 'FileSystem') {
    $esc = [char]27
    Write-Host -NoNewline "$esc]7;file://$env:COMPUTERNAME/$($p.ProviderPath -replace '\\','/')$esc\"
  }
  "PS $p$('>' * ($nestedPromptLevel + 1)) "
}