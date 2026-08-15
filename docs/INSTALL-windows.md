# Windows Install

## Option A: winget (recommended)
```powershell
winget install lvyuan1688.atomcode
```

## Option B: standalone binary
1. Download atomcode-windows-amd64.zip from Releases
2. Extract to C:\atomcode
3. Add to PATH: `setx PATH "%PATH%;C:\atomcode"`

## Verify
```powershell
atomcode --version
```
