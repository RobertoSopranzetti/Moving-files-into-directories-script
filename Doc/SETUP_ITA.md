# Guida alla Configurazione

## Permessi di Esecuzione PowerShell

Per eseguire script PowerShell sul tuo sistema, è necessario configurare i permessi di esecuzione appropriati.

### Configurazione Rapida

Apri PowerShell come **Amministratore** ed esegui:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Spiegazione

- **RemoteSigned**: Consente l'esecuzione di script locali senza firma digitale, ma richiede che gli script scaricati da Internet siano firmati da un publisher fidato.
- **-Scope CurrentUser**: Applica la policy solo all'utente corrente, senza modificare le impostazioni di sistema.

### Verifica Configurazione

Per verificare la policy attuale:

```powershell
Get-ExecutionPolicy -List
```

### Alternative

Se hai bisogno di maggiore flessibilità (non consigliato per motivi di sicurezza):

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

---

## Creazione di Collegamenti per Drag-and-Drop

Per facilitare l'uso degli script tramite drag-and-drop, puoi creare collegamenti sul desktop.

### Formato del Collegamento

Quando crei un collegamento a uno script PowerShell, devi configurarlo correttamente:

**Destinazione:**
```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\percorso\completo\dello\script.ps1"
```

### Esempio Pratico

1. **Tasto destro sul desktop** → Nuovo → Collegamento
2. **Inserisci il percorso:**
   ```
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\Users\Roberto\Desktop\Script per lo stagista\Rinomina_Scansioni.ps1"
   ```
3. **Dai un nome al collegamento:** Es. "Rinomina PDF"
4. **Fine**

### Script Automatico per Creare Collegamenti

Puoi usare questo script per creare automaticamente i collegamenti:

```powershell
# Crea collegamento per Rinomina_Scansioni.ps1
$ScriptPath = "C:\Users\Roberto\Desktop\Script per lo stagista\Rinomina_Scansioni.ps1"
$ShortcutPath = "$env:USERPROFILE\Desktop\Rinomina PDF.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = "-File `"$ScriptPath`""
$Shortcut.WorkingDirectory = Split-Path -Parent $ScriptPath
$Shortcut.IconLocation = "powershell.exe,0"
$Shortcut.Description = "Rinomina file PDF aggiungendo un suffisso"
$Shortcut.Save()

Write-Host "Collegamento creato: $ShortcutPath"
```

### Modificare i Collegamenti Esistenti

Se hai già collegamenti esistenti che puntano agli script con i vecchi nomi:

1. **Tasto destro sul collegamento** → Proprietà
2. **Nel campo "Destinazione"**, modifica il percorso dello script
3. **Applica** e **OK**

---

## Configurazione Percorsi per il Tuo Ambiente

Gli script contengono valori predefiniti che potrebbero dover essere adattati al tuo ambiente.

### MovePDFToNetwork.ps1

Modifica questi parametri predefiniti nel blocco `param()`:

```powershell
[Parameter()]
[string]$BaseFolder = "\\iltuoserver\lacondivisione",  # <-- Cambia qui

[Parameter()]
[string]$BackupFolder = "C:\TuaCartella\Backup",       # <-- E qui
```

### MovePdfToLocal.ps1

```powershell
[Parameter()]
[string]$BaseFolder = "C:\TuoPercorso\cartella",       # <-- Cambia qui
```

### Alternativa: Wrapper Script

Invece di modificare gli script originali, crea script wrapper personalizzati:

```powershell
# mio-sposta-pdf.ps1
.\MovePDFToNetwork.ps1 -BaseFolder "\\mioserver\documenti" -PrefixLength 6
```

---

## Test della Configurazione

Prima di usare gli script in produzione, testa su dati di esempio:

### 1. Crea una Struttura di Test

```powershell
# Crea cartelle di test
New-Item -Path "C:\Test\Commesse\12345 - Progetto Test\Produzione\12345 - Progetto Test" -ItemType Directory -Force
New-Item -Path "C:\Test\TestPDF.pdf" -ItemType File -Force
```

### 2. Testa lo Script Locale

```powershell
.\MovePdfToLocal.ps1 -FilePath "C:\Test\12345_documento.pdf" -BaseFolder "C:\Test\Commesse"
```

### 3. Verifica il Risultato

Controlla che il file sia stato spostato correttamente nella cartella di destinazione.

---

## Risoluzione Problemi Comuni

### Errore: "L'esecuzione di script è disabilitata"

**Soluzione:**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Errore: "Accesso negato"

**Possibili cause:**
- Non hai permessi sulla cartella di destinazione
- Il file è aperto in un'altra applicazione
- La cartella di rete non è accessibile

**Soluzione:**
- Verifica i permessi con: `Get-Acl "C:\percorso"`
- Chiudi il file PDF se aperto
- Verifica connessione di rete: `Test-Path "\\server\share"`

### Il collegamento non funziona

**Verifica:**
1. Il percorso dello script nel collegamento è corretto
2. Il percorso usa le doppie virgolette
3. Il formato è: `powershell.exe -File "percorso\script.ps1"`

---

## Sicurezza

### Raccomandazioni

1. **Non usare ExecutionPolicy Unrestricted** in ambienti di produzione
2. **Verifica sempre la fonte** degli script prima di eseguirli
3. **Mantieni backup** dei file importanti
4. **Testa su dati di esempio** prima dell'uso in produzione
5. **Limita i permessi** alle sole cartelle necessarie

### Audit

Per vedere quali script sono stati eseguiti:

```powershell
Get-WinEvent -LogName "Windows PowerShell" -MaxEvents 50 | 
    Where-Object {$_.Message -like "*Script*"} | 
    Select-Object TimeCreated, Message
```

---

## Supporto

Per problemi o domande:
1. Controlla la documentazione nel README.md
2. Verifica i log di PowerShell
3. Esegui gli script con `-Verbose` per maggiori dettagli
4. Consulta la documentazione inline con `Get-Help .\script.ps1 -Full`
