$repoPath = $PSScriptRoot
$imageExts = @('.jpg', '.jpeg', '.png', '.webp')
$pending = $null

Write-Host "Watching repo for new images... (Ctrl+C to stop)"

function Get-PendingImages {
    $raw = & git -C $repoPath status --porcelain
    $files = @()
    foreach ($line in $raw) {
        $file = $line.Trim().Substring(2).Trim()
        $ext = [System.IO.Path]::GetExtension($file).ToLower()
        if ($imageExts -contains $ext) {
            $files += $file
        }
    }
    return $files
}

function New-CommitMessage($files) {
    if ($files.Count -eq 1) {
        $name = [System.IO.Path]::GetFileName($files[0])
        return "add $name"
    }
    $names = ($files | ForEach-Object { [System.IO.Path]::GetFileName($_) }) -join ', '
    return "add images: $names"
}

while ($true) {
    Start-Sleep -Seconds 2

    $images = Get-PendingImages

    if ($images.Count -gt 0 -and $null -eq $pending) {
        Write-Host "Detected $($images.Count) image(s) - waiting 10 seconds to confirm..."
        $pending = @{ files = $images; detectedAt = Get-Date }
    }
    elseif ($null -ne $pending) {
        $elapsed = ((Get-Date) - $pending.detectedAt).TotalSeconds

        if ($elapsed -ge 10) {
            $current = Get-PendingImages
            if ($current.Count -gt 0) {
                $msg = New-CommitMessage $current
                Write-Host "Committing: $msg"
                foreach ($f in $current) {
                    & git -C $repoPath add $f
                }
                & git -C $repoPath commit -m $msg
                & git -C $repoPath push
                Write-Host "Pushed to origin."
            } else {
                Write-Host "Files gone before push - skipping."
            }
            $pending = $null
        }
    }
}
