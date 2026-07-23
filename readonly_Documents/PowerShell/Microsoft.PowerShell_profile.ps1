function Invoke-Startship-PreCommand {
  $current_location = $executionContext.SessionState.Path.CurrentLocation
  if ($current_location.Provider.Name -eq 'FileSystem') {
    $ansi_escape = [char]27
    $provider_path = $current_location.ProviderPath -replace '\\','/'
    $host.ui.Write("$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\")
  }
}

Set-PSReadLineOption -EditMode vi
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineOption -PredictionSource None
Set-PSReadLineKeyHandler -Key Tab -Function Complete

function touch ($f) { New-Item $f -ItemType File -Force | Out-Null }
function which ($c) { (Get-Command $c).Source }

function vsdev {
  $vsPath = & "{env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath
  Import-Module "$vsPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -Arch amd64
}

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

$env:EDITOR = "powershell -NoProfile -ExecutionPolicy Bypass -File $env:USERPROFILE\bin\nvim-wezterm.ps1"
