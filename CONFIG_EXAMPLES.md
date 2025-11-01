# Configuration Template / Template di Configurazione

Questo file fornisce esempi di configurazione per personalizzare gli script in base alle tue esigenze.
This file provides configuration examples to customize the scripts according to your needs.

---

## 🇮🇹 ITALIANO

### Configurazione Rinomina_Scansioni.ps1

```powershell
# Esempio 1: Suffisso personalizzato
.\Rinomina_Scansioni.ps1 -FilePath "documento.pdf" -Suffix "_BOZZA"

# Esempio 2: Lavorare con file Word
.\Rinomina_Scansioni.ps1 -FilePath "relazione.docx" -Suffix "_v2" -FileExtension ".docx"

# Esempio 3: Aggiungere data corrente
$data = Get-Date -Format "yyyyMMdd"
.\Rinomina_Scansioni.ps1 -FilePath "report.pdf" -Suffix "_$data"
```

### Configurazione MovePDFToNetwork.ps1

```powershell
# Configurazione per ambiente aziendale
$config = @{
    BaseFolder = "\\srv-files\documenti"
    BackupFolder = "D:\Backup\PDF"
    PrefixLength = 6
    SubfolderPath = "Archivio"
    NestedSearch = $true
}

.\MovePDFToNetwork.ps1 -FilePath "123456_ordine.pdf" @config

# Configurazione per disabilitare il backup
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -BackupFolder ""

# Configurazione per ricerca semplice (solo primo livello)
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -NestedSearch $false
```

### Configurazione MovePdfToLocal.ps1

```powershell
# Configurazione per testing locale
.\MovePdfToLocal.ps1 `
    -FilePath "test.pdf" `
    -BaseFolder "C:\Progetti\Test" `
    -PrefixLength 4 `
    -SubfolderPath "Documenti"

# Configurazione senza sottocartella
.\MovePdfToLocal.ps1 -FilePath "file.pdf" -SubfolderPath ""
```

### Script Wrapper Personalizzati

Crea uno script personalizzato che richiama gli script base con i tuoi parametri:

```powershell
# sposta-ordini.ps1
param([string]$FilePath)

.\MovePDFToNetwork.ps1 `
    -FilePath $FilePath `
    -BaseFolder "\\srv01\ordini" `
    -BackupFolder "C:\Backup\Ordini" `
    -PrefixLength 6 `
    -SubfolderPath "Anno2025\Produzione"
```

Poi usa semplicemente:
```powershell
.\sposta-ordini.ps1 -FilePath "123456_ordine.pdf"
```

---

## 🇬🇧 ENGLISH

### Rinomina_Scansioni.ps1 Configuration

```powershell
# Example 1: Custom suffix
.\Rinomina_Scansioni.ps1 -FilePath "document.pdf" -Suffix "_DRAFT"

# Example 2: Working with Word files
.\Rinomina_Scansioni.ps1 -FilePath "report.docx" -Suffix "_v2" -FileExtension ".docx"

# Example 3: Add current date
$date = Get-Date -Format "yyyyMMdd"
.\Rinomina_Scansioni.ps1 -FilePath "report.pdf" -Suffix "_$date"
```

### MovePDFToNetwork.ps1 Configuration

```powershell
# Corporate environment configuration
$config = @{
    BaseFolder = "\\srv-files\documents"
    BackupFolder = "D:\Backup\PDF"
    PrefixLength = 6
    SubfolderPath = "Archive"
    NestedSearch = $true
}

.\MovePDFToNetwork.ps1 -FilePath "123456_order.pdf" @config

# Configuration to disable backup
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -BackupFolder ""

# Configuration for simple search (first level only)
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -NestedSearch $false
```

### MovePdfToLocal.ps1 Configuration

```powershell
# Local testing configuration
.\MovePdfToLocal.ps1 `
    -FilePath "test.pdf" `
    -BaseFolder "C:\Projects\Test" `
    -PrefixLength 4 `
    -SubfolderPath "Documents"

# Configuration without subfolder
.\MovePdfToLocal.ps1 -FilePath "file.pdf" -SubfolderPath ""
```

### Custom Wrapper Scripts

Create a custom script that calls the base scripts with your parameters:

```powershell
# move-orders.ps1
param([string]$FilePath)

.\MovePDFToNetwork.ps1 `
    -FilePath $FilePath `
    -BaseFolder "\\srv01\orders" `
    -BackupFolder "C:\Backup\Orders" `
    -PrefixLength 6 `
    -SubfolderPath "Year2025\Production"
```

Then simply use:
```powershell
.\move-orders.ps1 -FilePath "123456_order.pdf"
```

---

## 📋 Variabili d'Ambiente / Environment Variables

### Impostare variabili globali / Set global variables

```powershell
# Nel profilo PowerShell (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
# In PowerShell profile (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)

$env:PDF_BASE_FOLDER = "\\srv01\documenti"
$env:PDF_BACKUP_FOLDER = "C:\Backup\PDF"

# Poi usare / Then use:
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -BaseFolder $env:PDF_BASE_FOLDER
```

---

## 🔧 Esempi Avanzati / Advanced Examples

### Elaborazione batch / Batch processing

```powershell
# Rinomina tutti i PDF in una cartella
Get-ChildItem "C:\Scansioni\*.pdf" | ForEach-Object {
    .\Rinomina_Scansioni.ps1 -FilePath $_.FullName -Suffix "_firmato"
}

# Sposta tutti i PDF che corrispondono a un pattern
Get-ChildItem "C:\Download\*.pdf" | Where-Object {$_.Name -match '^\d{5}'} | ForEach-Object {
    .\MovePDFToNetwork.ps1 -FilePath $_.FullName
}
```

### Con logging / With logging

```powershell
# Crea log delle operazioni
$logFile = "C:\Logs\pdf-operations.log"

.\MovePDFToNetwork.ps1 -FilePath "file.pdf" *>&1 | 
    Tee-Object -FilePath $logFile -Append
```

### Schedulazione / Scheduling

```powershell
# Crea un task schedulato che processa automaticamente i file
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument '-File "C:\Scripts\MovePDFToNetwork.ps1" -FilePath "C:\Inbox\*.pdf"'

$trigger = New-ScheduledTaskTrigger -Daily -At 9am

Register-ScheduledTask -TaskName "ProcessPDFs" -Action $action -Trigger $trigger
```

---

## 💾 File di Configurazione JSON

Per configurazioni complesse, puoi usare un file JSON:

### config.json
```json
{
  "network": {
    "baseFolder": "\\\\srv01\\commesse",
    "backupFolder": "C:\\Backup\\PDF",
    "prefixLength": 5,
    "subfolderPath": "Produzione",
    "nestedSearch": true
  },
  "local": {
    "baseFolder": "C:\\Test\\Commesse",
    "prefixLength": 5,
    "subfolderPath": "Produzione"
  },
  "rename": {
    "defaultSuffix": "verbale",
    "fileExtension": ".pdf"
  }
}
```

### Script per usare la configurazione / Script to use configuration

```powershell
# load-config.ps1
$config = Get-Content "config.json" | ConvertFrom-Json

.\MovePDFToNetwork.ps1 `
    -FilePath $args[0] `
    -BaseFolder $config.network.baseFolder `
    -BackupFolder $config.network.backupFolder `
    -PrefixLength $config.network.prefixLength `
    -SubfolderPath $config.network.subfolderPath `
    -NestedSearch $config.network.nestedSearch
```

---

## 📞 Supporto / Support

Per ulteriori esempi di configurazione, consulta il README.md
For more configuration examples, see README.md
