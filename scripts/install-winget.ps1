#!/usr/bin/env pwsh
# Generate winget manifest for atomcode
$version = $args[0] ?? '0.1.0'
$manifest = "@https://github.com/lvyuan1688/atomcode/releases/download/v$version/atomcode-windows-amd64.zip"
Write-Output $manifest
