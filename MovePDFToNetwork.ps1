<#
.SYNOPSIS
    Moves PDF files to a network folder structure based on filename prefix.

.DESCRIPTION
    This script moves PDF files to a hierarchical network folder structure.
    It searches for destination folders based on the first characters of the filename,
    validates the structure, checks for duplicates, and creates a backup before moving.

.PARAMETER FilePath
    The path to the PDF file to move (provided via drag-and-drop or command line).

.PARAMETER BaseFolder
    The base network folder path (default: "\\srvfs1\commesse").

.PARAMETER BackupFolder
    The folder where backup copies are stored (default: "C:\Scansioni\BackupScansioni").

.PARAMETER PrefixLength
    Number of characters from filename to use for folder matching (default: 5).

.PARAMETER SubfolderPath
    Subfolder path within the matched folder (default: "Produzione").

.PARAMETER NestedSearch
    If true, searches for an additional nested folder with the same prefix (default: $true).

.EXAMPLE
    # Drag and drop a PDF file onto the script
    .\MovePDFToNetwork.ps1

.EXAMPLE
    # Run with custom parameters
    .\MovePDFToNetwork.ps1 -FilePath "12345_document.pdf" -PrefixLength 5
#>

param(
    [Parameter(Position = 0)]
    [string]$FilePath = $args[0],
    
    [Parameter()]
    [string]$BaseFolder = "\\srvfs1\commesse",
    
    [Parameter()]
    [string]$BackupFolder = "C:\Scansioni\BackupScansioni",
    
    [Parameter()]
    [int]$PrefixLength = 5,
    
    [Parameter()]
    [string]$SubfolderPath = "Produzione",
    
    [Parameter()]
    [bool]$NestedSearch = $true
)

# Verifica se è stato trascinato almeno un file
if ([string]::IsNullOrEmpty($FilePath)) {
    Write-Host "ERRORE: Trascina il file da spostare su questo script e riprova."
    pause
    exit 1
}

# Verifica che il file esista
if (-not (Test-Path -Path $FilePath)) {
    Write-Host "ERRORE: Il file specificato non esiste: $FilePath"
    pause
    exit 1
}

$fileInfo = Get-Item $FilePath

# Verifica se il file è un PDF
if ($fileInfo.Extension -ne ".pdf") {
    Write-Host "ERRORE: Il file trascinato non e' un file PDF."
    pause
    exit 1
}

# Estrai il nome del file e il prefisso
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)

# Verifica che il nome del file sia abbastanza lungo
if ($fileName.Length -lt $PrefixLength) {
    Write-Host "ERRORE: Il nome del file e' troppo corto. Lunghezza minima richiesta: $PrefixLength caratteri."
    pause
    exit 1
}

$parteNome = $fileName.Substring(0, $PrefixLength)

# Verifica che la cartella base esista
if (-not (Test-Path -Path $BaseFolder)) {
    Write-Host "ERRORE: La cartella base non esiste: $BaseFolder"
    pause
    exit 1
}

# Trova la sottocartella in base al prefisso del nome del file
$cartellaDiDestinazione = Get-ChildItem -Path $BaseFolder -Directory | Where-Object { $_.Name.StartsWith($parteNome) }

# Se non è stata trovata nessuna sottocartella, esci dallo script
if ($cartellaDiDestinazione -eq $null) {
	Write-Host "*****"
	Write-Host "*****"
    Write-Host "***** Nessuna sottocartella trovata con il nome $parteNome. *****"
	Write-Host "*****"
	Write-Host "*****"
    pause
    exit
}

# Aggiungi la sotto-cartella al percorso della cartella di destinazione
if (-not [string]::IsNullOrEmpty($SubfolderPath)) {
    $cartellaDiDestinazione = Join-Path -Path $cartellaDiDestinazione.FullName -ChildPath $SubfolderPath
}

# Se la cartella di destinazione non esiste dai errore
if (-not (Test-Path -Path $cartellaDiDestinazione)) {
	Write-Host "*****"
	Write-Host "*****"
    Write-Host "****** La sottocartella produzione qui non esiste, fai controllare ******"
	Write-Host "*****"
	Write-Host "*****"
    pause
    exit
}

# Controlla se esiste già un file che inizia con lo stesso nome del file di input
Write-Host $cartellaDiDestinazione "primo controllo file"
$fileEsistente = Get-ChildItem -Path $cartellaDiDestinazione -File | Where-Object { $_.Name.StartsWith($fileName) }
if ($fileEsistente -ne $null) {
	Write-Host "*****"
	Write-Host "*****"
    Write-Host "***** Esiste già un file con lo stesso nome nella cartella di destinazione. *****"
	Write-Host "*****"
	Write-Host "*****"
    pause
    exit
}

########### Ricerca sottocartella annidata (opzionale) ###########

if ($NestedSearch) {
    # Trova la sottocartella in base al nome del file
    $cartellaDiDestinazione = Get-ChildItem -Path $cartellaDiDestinazione -Directory | Where-Object { $_.Name.StartsWith($parteNome) }

    # Se non è stata trovata nessuna sottocartella, esci dallo script
    if ($cartellaDiDestinazione -eq $null) {
        Write-Host "*****"
        Write-Host "*****"
        Write-Host "***** Nessuna sottocartella trovata dentro $SubfolderPath con il nome $parteNome. *****"
        Write-Host "*****"
        Write-Host "*****"
        pause
        exit 1
    }

    # Controlla se esiste già un file che inizia con lo stesso nome del file di input
    $fileEsistente2 = Get-ChildItem -Path $cartellaDiDestinazione.FullName -File | Where-Object { $_.Name.StartsWith($fileName) }

    if ($fileEsistente2 -ne $null) {
        Write-Host "*****"
        Write-Host "*****"
        Write-Host "***** Esiste gia' un file con lo stesso nome nella cartella di destinazione.*****"
        Write-Host "*****"
        Write-Host "*****"
        pause
        exit 1
    }
}

# Sposta il file nella cartella di destinazione
# Crea backup se la cartella di backup esiste o può essere creata
if (-not [string]::IsNullOrEmpty($BackupFolder)) {
    try {
        if (-not (Test-Path -Path $BackupFolder)) {
            New-Item -Path $BackupFolder -ItemType Directory -Force | Out-Null
            Write-Host "Cartella backup creata: $BackupFolder"
        }
        Copy-Item -Path $FilePath -Destination $BackupFolder -ErrorAction Stop
        Write-Host "Backup creato in: $BackupFolder"
    } catch {
        Write-Host "ATTENZIONE: Impossibile creare il backup: $_"
        Write-Host "Continuare senza backup? (S/N)"
        $risposta = Read-Host
        if ($risposta -ne "S" -and $risposta -ne "s") {
            exit 1
        }
    }
}

# Sposta il file
try {
    Move-Item -Path $FilePath -Destination $cartellaDiDestinazione.FullName -ErrorAction Stop
    Write-Host ""
    Write-Host "====================================="
    Write-Host "Il file e' stato spostato con successo!"
    Write-Host "Destinazione: $($cartellaDiDestinazione.FullName)"
    Write-Host "====================================="
} catch {
    Write-Host "ERRORE durante lo spostamento del file: $_"
    pause
    exit 1
}

pause