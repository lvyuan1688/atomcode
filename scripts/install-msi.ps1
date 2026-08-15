#!/usr/bin/env pwsh
# Build MSI for atomcode using WiX
param([string]$Version = "0.1.0")
$dir = "dist/msi-$Version"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Copy-Item target/release/atomcode.exe $dir/
Write-Output "MSI staging at $dir (WiX candle+light required to compile)"
