# Setup Guide

## PowerShell Execution Permissions

To run PowerShell scripts on your system, you need to configure appropriate execution permissions.

### Quick Setup

Open PowerShell as **Administrator** and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Explanation

- **RemoteSigned**: Allows execution of local scripts without digital signature, but requires scripts downloaded from the Internet to be signed by a trusted publisher.
- **-Scope CurrentUser**: Applies the policy only to the current user, without modifying system settings.

### Verify Configuration

To check the current policy:

```powershell
Get-ExecutionPolicy -List
```

### Alternatives

If you need more flexibility (not recommended for security reasons):

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

---

## Creating Shortcuts for Drag-and-Drop

To facilitate script usage via drag-and-drop, you can create desktop shortcuts.

### Shortcut Format

When creating a shortcut to a PowerShell script, you need to configure it correctly:

**Target:**
```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\full\path\to\script.ps1"
```

### Practical Example

1. **Right-click on desktop** → New → Shortcut
2. **Enter the path:**
   ```
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\Users\Roberto\Desktop\Script per lo stagista\Rinomina_Scansioni.ps1"
   ```
3. **Name the shortcut:** E.g., "Rename PDF"
4. **Finish**

### Automated Script to Create Shortcuts

You can use this script to automatically create shortcuts:

```powershell
# Create shortcut for Rinomina_Scansioni.ps1
$ScriptPath = "C:\Users\Roberto\Desktop\Script per lo stagista\Rinomina_Scansioni.ps1"
$ShortcutPath = "$env:USERPROFILE\Desktop\Rename PDF.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = "-File `"$ScriptPath`""
$Shortcut.WorkingDirectory = Split-Path -Parent $ScriptPath
$Shortcut.IconLocation = "powershell.exe,0"
$Shortcut.Description = "Rename PDF files by adding a suffix"
$Shortcut.Save()

Write-Host "Shortcut created: $ShortcutPath"
```

### Modifying Existing Shortcuts

If you already have shortcuts pointing to scripts with old names:

1. **Right-click on shortcut** → Properties
2. **In the "Target" field**, modify the script path
3. **Apply** and **OK**

---

## Configuring Paths for Your Environment

The scripts contain default values that may need to be adapted to your environment.

### MovePDFToNetwork.ps1

Modify these default parameters in the `param()` block:

```powershell
[Parameter()]
[string]$BaseFolder = "\\yourserver\yourshare",      # <-- Change here

[Parameter()]
[string]$BackupFolder = "C:\YourFolder\Backup",      # <-- And here
```

### MovePdfToLocal.ps1

```powershell
[Parameter()]
[string]$BaseFolder = "C:\YourPath\folder",          # <-- Change here
```

### Alternative: Wrapper Scripts

Instead of modifying the original scripts, create custom wrapper scripts:

```powershell
# my-move-pdf.ps1
.\MovePDFToNetwork.ps1 -BaseFolder "\\myserver\documents" -PrefixLength 6
```

---

## Testing the Configuration

Before using the scripts in production, test on sample data:

### 1. Create a Test Structure

```powershell
# Create test folders
New-Item -Path "C:\Test\Orders\12345 - Test Project\Production\12345 - Test Project" -ItemType Directory -Force
New-Item -Path "C:\Test\TestPDF.pdf" -ItemType File -Force
```

### 2. Test the Local Script

```powershell
.\MovePdfToLocal.ps1 -FilePath "C:\Test\12345_document.pdf" -BaseFolder "C:\Test\Orders"
```

### 3. Verify the Result

Check that the file has been moved correctly to the destination folder.

---

## Common Troubleshooting

### Error: "Script execution is disabled"

**Solution:**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "Access denied"

**Possible causes:**
- You don't have permissions on the destination folder
- The file is open in another application
- The network folder is not accessible

**Solution:**
- Verify permissions with: `Get-Acl "C:\path"`
- Close the PDF file if open
- Verify network connection: `Test-Path "\\server\share"`

### Shortcut doesn't work

**Check:**
1. The script path in the shortcut is correct
2. The path uses double quotes
3. The format is: `powershell.exe -File "path\to\script.ps1"`

---

## Security

### Recommendations

1. **Don't use ExecutionPolicy Unrestricted** in production environments
2. **Always verify the source** of scripts before executing them
3. **Maintain backups** of important files
4. **Test on sample data** before production use
5. **Limit permissions** to only necessary folders

### Audit

To see which scripts have been executed:

```powershell
Get-WinEvent -LogName "Windows PowerShell" -MaxEvents 50 | 
    Where-Object {$_.Message -like "*Script*"} | 
    Select-Object TimeCreated, Message
```

---

## Support

For issues or questions:
1. Check the documentation in README.md
2. Verify PowerShell logs
3. Run scripts with `-Verbose` for more details
4. Consult inline documentation with `Get-Help .\script.ps1 -Full`
