# PowerShell PDF Management Scripts

Una collezione di script PowerShell generici e versatili per la gestione automatizzata di file PDF, progettati per funzionare con il drag-and-drop e configurabili tramite parametri.

## 📋 Indice

- [Script Disponibili](#script-disponibili)
- [Caratteristiche](#caratteristiche)
- [Requisiti](#requisiti)
- [Installazione e Configurazione](#installazione-e-configurazione)
- [Utilizzo](#utilizzo)
- [Parametri Configurabili](#parametri-configurabili)
- [Esempi Avanzati](#esempi-avanzati)

## 🔧 Script Disponibili

### 1. Rinomina_Scansioni.ps1
Aggiunge un suffisso personalizzabile ai nomi dei file PDF.

**Caso d'uso:** Rinominare velocemente file scansionati aggiungendo etichette come "verbale", "finale", "bozza", ecc.

### 2. MovePDFToNetwork.ps1
Sposta file PDF in una struttura gerarchica di cartelle di rete basandosi sul prefisso del nome file, con supporto per backup automatico e ricerca annidata.

**Caso d'uso:** Archiviazione automatica di documenti in una struttura organizzata per codice commessa/progetto su server di rete.

### 3. MovePdfToLocal.ps1
Versione semplificata dello script di rete, progettata per strutture di cartelle locali a singolo livello.

**Caso d'uso:** Testing locale, ambienti di sviluppo o organizzazione di documenti su drive locali.

## ✨ Caratteristiche

### Genericità e Versatilità

Gli script sono stati progettati per essere **generici e riutilizzabili** in diversi contesti:

- **Parametrizzazione completa**: Tutti i percorsi, lunghezze di prefissi e comportamenti sono configurabili
- **Nessun hardcoding**: I valori predefiniti possono essere sovrascritti senza modificare il codice
- **Validazione robusta**: Controlli estesi su file, cartelle e duplicati con messaggi di errore chiari
- **Error handling**: Gestione appropriata degli errori con codici di uscita e messaggi informativi
- **Flessibilità d'uso**: Supporto sia per drag-and-drop che per esecuzione da riga di comando
- **Documentazione inline**: Help integrato accessibile con `Get-Help`

### Differenze tra MovePDFToNetwork e MovePdfToLocal

| Caratteristica | Network | Local |
|---------------|---------|-------|
| Percorso predefinito | Rete (`\\server\share`) | Locale (`C:\...`) |
| Ricerca annidata | Sì (due livelli) | No (un livello) |
| Backup automatico | Sì | No |
| Creazione cartelle | No | Opzionale (con conferma) |
| Uso consigliato | Produzione | Testing/Sviluppo |

## 📋 Requisiti

- Windows PowerShell 5.1 o superiore
- Permessi di esecuzione PowerShell configurati
- Accesso in lettura/scrittura alle cartelle coinvolte
- Per MovePDFToNetwork: accesso alla rete aziendale

## 🚀 Installazione e Configurazione

### 1. Configurazione Permessi PowerShell

Prima di utilizzare gli script, è necessario configurare i permessi di esecuzione:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Nota:** Potrebbe essere necessario eseguire PowerShell come Amministratore.

### 2. Download degli Script

Clona il repository o scarica gli script nella tua cartella preferita.

### 3. Creazione di Collegamenti (Opzionale)

Per facilitare l'uso drag-and-drop, puoi creare collegamenti agli script sul desktop o in cartelle di uso frequente.

**Comando per creare un collegamento:**

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Rinomina PDF.lnk")
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = '-File "C:\percorso\verso\Rinomina_Scansioni.ps1"'
$Shortcut.Save()
```

## 📖 Utilizzo

### Metodo 1: Drag and Drop

Trascina semplicemente un file PDF sull'icona dello script (o sul collegamento).

### Metodo 2: Da PowerShell

```powershell
.\Rinomina_Scansioni.ps1 -FilePath "documento.pdf"
```

### Metodo 3: Con Parametri Personalizzati

```powershell
.\Rinomina_Scansioni.ps1 -FilePath "documento.pdf" -Suffix "finale"
```

## ⚙️ Parametri Configurabili

### Rinomina_Scansioni.ps1

| Parametro | Tipo | Default | Descrizione |
|-----------|------|---------|-------------|
| `FilePath` | string | - | Percorso del file da rinominare |
| `Suffix` | string | "verbale" | Suffisso da aggiungere al nome |
| `FileExtension` | string | ".pdf" | Estensione file da validare |

### MovePDFToNetwork.ps1

| Parametro | Tipo | Default | Descrizione |
|-----------|------|---------|-------------|
| `FilePath` | string | - | Percorso del file da spostare |
| `BaseFolder` | string | "\\\\srvfs1\\commesse" | Cartella base di rete |
| `BackupFolder` | string | "C:\\Scansioni\\BackupScansioni" | Cartella backup |
| `PrefixLength` | int | 5 | Lunghezza prefisso per matching |
| `SubfolderPath` | string | "Produzione" | Sottocartella intermedia |
| `NestedSearch` | bool | $true | Abilita ricerca annidata |

### MovePdfToLocal.ps1

| Parametro | Tipo | Default | Descrizione |
|-----------|------|---------|-------------|
| `FilePath` | string | - | Percorso del file da spostare |
| `BaseFolder` | string | "C:\\Users\\calda\\Desktop\\commesse" | Cartella base locale |
| `PrefixLength` | int | 5 | Lunghezza prefisso per matching |
| `SubfolderPath` | string | "Produzione" | Sottocartella da cercare |

## 💡 Esempi Avanzati

### Esempio 1: Rinomina con Suffisso Personalizzato

```powershell
.\Rinomina_Scansioni.ps1 -FilePath "relazione.pdf" -Suffix "_APPROVATO"
# Output: relazione_APPROVATO.pdf
```

### Esempio 2: Spostamento su Rete con Prefisso Custom

```powershell
.\MovePDFToNetwork.ps1 -FilePath "ABC123_documento.pdf" -PrefixLength 3
# Cerca cartelle che iniziano con "ABC"
```

### Esempio 3: Spostamento Locale Senza Sottocartella

```powershell
.\MovePdfToLocal.ps1 -FilePath "12345_file.pdf" -SubfolderPath ""
# Sposta direttamente nella cartella trovata, senza cercare "Produzione"
```

### Esempio 4: Rete Senza Ricerca Annidata

```powershell
.\MovePDFToNetwork.ps1 -FilePath "file.pdf" -NestedSearch $false
# Ferma la ricerca al primo livello (non cerca dentro "Produzione")
```

### Esempio 5: Testing con Cartella Temporanea

```powershell
.\MovePdfToLocal.ps1 -FilePath "test.pdf" -BaseFolder "C:\Temp\Test" -PrefixLength 4
# Usa una cartella di test personalizzata
```

## 🔍 Come Funziona il Matching delle Cartelle

Gli script utilizzano il **prefisso del nome file** per trovare la cartella di destinazione:

1. **Nome file:** `12345_documento_finale.pdf`
2. **Prefisso estratto:** `12345` (primi 5 caratteri, configurabile)
3. **Ricerca cartella:** Cerca una cartella il cui nome inizia con `12345`
4. **Esempio match:** `12345 - Progetto Alpha` ✅
5. **Esempio no match:** `54321 - Progetto Beta` ❌

## 🛠️ Personalizzazione per il Tuo Ambiente

Per adattare gli script al tuo ambiente:

1. **Modifica i valori predefiniti** nel blocco `param()` degli script
2. **Oppure** crea script wrapper personalizzati:

```powershell
# my-custom-move.ps1
.\MovePDFToNetwork.ps1 -BaseFolder "\\myserver\myshare" -PrefixLength 6
```

## 📝 Best Practices

1. **Testa sempre su dati di esempio** prima di usare in produzione
2. **Mantieni backup** dei file importanti (MovePDFToNetwork lo fa automaticamente)
3. **Usa percorsi UNC completi** per le condivisioni di rete
4. **Verifica i permessi** sulle cartelle di destinazione
5. **Controlla i log di PowerShell** in caso di errori

## 🐛 Troubleshooting

### "Impossibile eseguire lo script"
- Verifica i permessi di esecuzione con `Get-ExecutionPolicy`
- Esegui `Set-ExecutionPolicy RemoteSigned`

### "Cartella non trovata"
- Verifica che il percorso esista
- Controlla il prefisso del file corrisponda al nome di una cartella
- Verifica i permessi di accesso

### "File già esistente"
- Un file con lo stesso nome esiste già nella destinazione
- Rinomina il file sorgente o rimuovi il duplicato

## 📄 Licenza

Questi script sono forniti "così come sono" per uso generale. Sentiti libero di modificarli e adattarli alle tue esigenze.

## 🤝 Contributi

Contributi, segnalazioni di bug e richieste di funzionalità sono benvenuti!

---

**Versione:** 2.0  
**Ultimo aggiornamento:** Novembre 2025
