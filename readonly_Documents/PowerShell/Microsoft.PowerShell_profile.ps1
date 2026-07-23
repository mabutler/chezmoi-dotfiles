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
Set-PSReadLineOption -BellStyle None

function touch ($f) { New-Item $f -ItemType File -Force | Out-Null }
function which ($c) { (Get-Command $c).Source }

function vsdev {
  $vsPath = & "{env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath
  Import-Module "$vsPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -Arch amd64
}

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Cache the rendered prompt per (history entry, directory) so Tab-completion redraws
# within the same unsubmitted line reuse it instead of re-running starship. Invalidates
# the instant a command actually runs or the directory changes.
$global:__promptCache = @{ Text = $null; HistoryId = -1; Pwd = $null }
$__originalPrompt = $function:prompt
function prompt {
    $historyId = (Get-History -Count 1).Id
    $cwd = $PWD.ProviderPath
    if ($null -ne $global:__promptCache.Text -and $historyId -eq $global:__promptCache.HistoryId -and $cwd -eq $global:__promptCache.Pwd) {
        return $global:__promptCache.Text
    }
    $result = & $__originalPrompt
    $global:__promptCache.Text = $result
    $global:__promptCache.HistoryId = $historyId
    $global:__promptCache.Pwd = $cwd
    return $result
}

$env:EDITOR = "powershell -NoProfile -ExecutionPolicy Bypass -File $env:USERPROFILE\bin\nvim-wezterm.ps1"
