<#
.SYNOPSIS
    Moves PDF files to a local folder structure based on filename prefix.

.DESCRIPTION
    This script moves PDF files to a hierarchical local folder structure.
    It searches for destination folders based on the first characters of the filename,
    validates the structure, and checks for duplicates.
    This is a simplified version designed for local testing or single-level folder structures.

.PARAMETER FilePath
    The path to the PDF file to move (provided via drag-and-drop or command line).

.PARAMETER BaseFolder
    The base local folder path (default: "C:\Users\calda\Desktop\commesse").

.PARAMETER PrefixLength
    Number of characters from filename to use for folder matching (default: 5).

.PARAMETER SubfolderPath
    Subfolder path within the matched folder (default: "Produzione").

.EXAMPLE
    # Drag and drop a PDF file onto the script
    .\MovePdfToLocal.ps1

.EXAMPLE
    # Run with custom parameters
    .\MovePdfToLocal.ps1 -FilePath "12345_document.pdf" -BaseFolder "C:\MyFolder"
#>

param(
    [Parameter(Position = 0)]
    [string]$FilePath = $args[0],
    
    [Parameter()]
    [string]$BaseFolder = "C:\Users\calda\Desktop\commesse",
    
    [Parameter()]
    [int]$PrefixLength = 5,
    
    [Parameter()]
    [string]$SubfolderPath = "Produzione"
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
    Write-Host "ERRORE: Il file trascinato non è un file PDF."
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
    Write-Host "Creare la cartella? (S/N)"
    $risposta = Read-Host
    if ($risposta -eq "S" -or $risposta -eq "s") {
        try {
            New-Item -Path $BaseFolder -ItemType Directory -Force | Out-Null
            Write-Host "Cartella creata con successo."
        } catch {
            Write-Host "ERRORE: Impossibile creare la cartella: $_"
            pause
            exit 1
        }
    } else {
        exit 1
    }
}

# Trova la sottocartella in base al prefisso del nome del file
$cartellaDiDestinazione = Get-ChildItem -Path $BaseFolder -Directory | Where-Object { $_.Name.StartsWith($parteNome) }

# Se non è stata trovata nessuna sottocartella, esci dallo script
if ($cartellaDiDestinazione -eq $null) {
    Write-Host "ERRORE: Nessuna sottocartella trovata con il prefisso '$parteNome' in $BaseFolder"
    pause
    exit 1
}

# Aggiungi la sotto-cartella al percorso della cartella di destinazione
if (-not [string]::IsNullOrEmpty($SubfolderPath)) {
    $cartellaDiDestinazione = Join-Path -Path $cartellaDiDestinazione.FullName -ChildPath $SubfolderPath
}

# Se la cartella di destinazione non esiste, gestisci l'errore
if (-not (Test-Path -Path $cartellaDiDestinazione)) {
    Write-Host "ERRORE: La sottocartella '$SubfolderPath' non esiste in: $($cartellaDiDestinazione)"
    pause
    exit 1
}

# Controlla se esiste già un file che inizia con lo stesso nome del file di input
$fileEsistente = Get-ChildItem -Path $cartellaDiDestinazione -File | Where-Object { $_.Name.StartsWith($fileName) }
if ($fileEsistente -ne $null) {
    Write-Host "ERRORE: Esiste già un file con lo stesso nome nella cartella di destinazione."
    Write-Host "File esistente: $($fileEsistente.Name)"
    pause
    exit 1
}

# Sposta il file nella cartella di destinazione
try {
    Move-Item -Path $FilePath -Destination $cartellaDiDestinazione -ErrorAction Stop
    Write-Host ""
    Write-Host "====================================="
    Write-Host "Il file è stato spostato con successo!"
    Write-Host "Destinazione: $cartellaDiDestinazione"
    Write-Host "====================================="
} catch {
    Write-Host "ERRORE durante lo spostamento del file: $_"
    pause
    exit 1
}

pause