param([Parameter(ValueFromRemainingArguments = $true)][string[]]$FileArgs)

$file = $FileArgs[-1]
$paneId = (& wezterm cli spawn --cwd (Get-Location).Path -- nvim $file | Select-Object -Last 1).Trim()

do {
    Start-Sleep -Milliseconds 400
    $stillOpen = (wezterm cli list --format json | ConvertFrom-Json) | Where-Object { $_.pane_id -eq [int]$paneId }
} while ($stillOpen)
