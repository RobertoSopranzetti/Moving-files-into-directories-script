# PowerShell PDF Management Scripts

A collection of generic and versatile PowerShell scripts for automated PDF file management, designed to work with drag-and-drop functionality and configurable via parameters.

## 📋 Table of Contents

- [Available Scripts](#available-scripts)
- [Features](#features)
- [Requirements](#requirements)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Configurable Parameters](#configurable-parameters)
- [Advanced Examples](#advanced-examples)

## 🔧 Available Scripts

### 1. Rename_Scan.ps1
Adds a customizable suffix to PDF filenames.

**Use case:** Quickly rename scanned files by adding labels such as "minutes", "final", "draft", etc.

### 2. MovePDFToNetwork.ps1
Moves PDF files to a hierarchical network folder structure based on filename prefix, with support for automatic backup and nested search.

**Use case:** Automatic archiving of documents in an organized structure by order/project code on network servers.

### 3. MovePdfToLocal.ps1
Simplified version of the network script, designed for single-level local folder structures.

**Use case:** Local testing, development environments, or document organization on local drives.

## ✨ Features

### Genericity and Versatility

The scripts are designed to be **generic and reusable** in different contexts:

- **Complete parameterization**: All paths, prefix lengths, and behaviors are configurable
- **No hardcoding**: Default values can be overridden without modifying the code
- **Robust validation**: Extensive checks on files, folders, and duplicates with clear error messages
- **Error handling**: Proper error management with exit codes and informative messages
- **Usage flexibility**: Support for both drag-and-drop and command-line execution
- **Inline documentation**: Built-in help accessible with `Get-Help`

### Differences Between MovePDFToNetwork and MovePdfToLocal

| Feature | Network | Local |
|---------|---------|-------|
| Default path | Network (`\\server\share`) | Local (`C:\...`) |
| Nested search | Yes (two levels) | No (one level) |
| Automatic backup | Yes | No |
| Folder creation | No | Optional (with confirmation) |
| Recommended use | Production | Testing/Development |

## 📋 Requirements

- Windows PowerShell 5.1 or higher
- PowerShell execution permissions configured
- Read/write access to involved folders
- For MovePDFToNetwork: access to corporate network

## 🚀 Installation and Setup

### 1. PowerShell Permissions Configuration

Before using the scripts, you need to configure execution permissions:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Note:** You may need to run PowerShell as Administrator.

### 2. Download Scripts

Clone the repository or download the scripts to your preferred folder.

### 3. Create Shortcuts (Optional)

To facilitate drag-and-drop usage, you can create shortcuts to the scripts on your desktop or in frequently used folders.

**Command to create a shortcut:**

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Rename PDF.lnk")
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = '-File "C:\path\to\Rinomina_Scansioni.ps1"'
$Shortcut.Save()
```

## 📖 Usage

### Method 1: Drag and Drop

Simply drag a PDF file onto the script icon (or shortcut).

### Method 2: From PowerShell

```powershell
.\Rinomina_Scansioni.ps1 -FilePath "document.pdf"
```

### Method 3: With Custom Parameters

```powershell
.\Rinomina_Scansioni.ps1 -FilePath "document.pdf" -Suffix "final"
```

## ⚙️ Configurable Parameters

### Rinomina_Scansioni.ps1

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `FilePath` | string | - | Path to the file to rename |
| `Suffix` | string | "verbale" | Suffix to add to the name |
| `FileExtension` | string | ".pdf" | File extension to validate |

### MovePDFToNetwork.ps1

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `FilePath` | string | - | Path to the file to move |
| `BaseFolder` | string | "\\\\srvfs1\\commesse" | Network base folder |
| `BackupFolder` | string | "C:\\Scansioni\\BackupScansioni" | Backup folder |
| `PrefixLength` | int | 5 | Prefix length for matching |
| `SubfolderPath` | string | "Produzione" | Intermediate subfolder |
| `NestedSearch` | bool | $true | Enable nested search |

### MovePdfToLocal.ps1

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `FilePath` | string | - | Path to the file to move |
| `BaseFolder` | string | "C:\\Users\\calda\\Desktop\\commesse" | Local base folder |
| `PrefixLength` | int | 5 | Prefix length for matching |
| `SubfolderPath` | string | "Produzione" | Subfolder to search |

## 💡 Advanced Examples

### Example 1: Rename with Custom Suffix

```powershell
.\Rinomina_Scansioni.ps1 -FilePath "report.pdf" -Suffix "_APPROVED"
# Output: report_APPROVED.pdf
```

### Example 2: Network Move with Custom Prefix

```powershell
.\MovePDFToNetwork.ps1 -FilePath "ABC123_document.pdf" -PrefixLength 3
# Searches for folders starting with "ABC"
```

### Example 3: Local Move Without Subfolder

```powershell
.\MovePdfToLocal.ps1 -FilePath "12345_file.pdf" -SubfolderPath ""
# Moves directly to the found folder, without searching for "Produzione"
```

### Example 4: Network Without Nested Search

```powershell
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -NestedSearch $false
# Stops search at first level (doesn't search inside "Produzione")
```

### Example 5: Testing with Temporary Folder

```powershell
.\MovePdfToLocal.ps1 -FilePath "test.pdf" -BaseFolder "C:\Temp\Test" -PrefixLength 4
# Uses a custom test folder
```

## 🔍 How Folder Matching Works

The scripts use the **filename prefix** to find the destination folder:

1. **Filename:** `12345_document_final.pdf`
2. **Extracted prefix:** `12345` (first 5 characters, configurable)
3. **Folder search:** Searches for a folder whose name starts with `12345`
4. **Match example:** `12345 - Project Alpha` ✅
5. **No match example:** `54321 - Project Beta` ❌

## 🛠️ Customizing for Your Environment

To adapt the scripts to your environment:

1. **Modify default values** in the `param()` block of the scripts
2. **Or** create custom wrapper scripts:

```powershell
# my-custom-move.ps1
.\MovePDFToNetwork.ps1 -BaseFolder "\\myserver\myshare" -PrefixLength 6
```

## 📝 Best Practices

1. **Always test on sample data** before using in production
2. **Maintain backups** of important files (MovePDFToNetwork does this automatically)
3. **Use complete UNC paths** for network shares
4. **Verify permissions** on destination folders
5. **Check PowerShell logs** in case of errors

## 🐛 Troubleshooting

### "Cannot run script"
- Check execution permissions with `Get-ExecutionPolicy`
- Run `Set-ExecutionPolicy RemoteSigned`

### "Folder not found"
- Verify that the path exists
- Check that the file prefix matches a folder name
- Verify access permissions

### "File already exists"
- A file with the same name already exists in the destination
- Rename the source file or remove the duplicate

## 📄 License

These scripts are provided "as is" for general use. Feel free to modify and adapt them to your needs.

## 🤝 Contributions

Contributions, bug reports, and feature requests are welcome!

---

**Version:** 2.0  
**Last update:** November 2025
