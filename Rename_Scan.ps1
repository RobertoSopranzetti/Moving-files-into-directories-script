<#
.SYNOPSIS
    Adds a custom suffix to PDF filenames.

.DESCRIPTION
    This script renames PDF files by appending a configurable suffix to the filename.
    Designed to work with drag-and-drop functionality.

.PARAMETER FilePath
    The path to the file to rename (provided via drag-and-drop or command line).

.PARAMETER Suffix
    The suffix to append to the filename (default: "verbale").

.PARAMETER FileExtension
    The file extension to validate (default: ".pdf").

.EXAMPLE
    # Drag and drop a PDF file onto the script
    .\Rinomina_Scansioni.ps1

.EXAMPLE
    # Run with custom suffix
    .\Rinomina_Scansioni.ps1 -FilePath "document.pdf" -Suffix "final"
#>

param(
    [Parameter(Position = 0)]
    [string]$FilePath = $args[0],
    
    [Parameter()]
    [string]$Suffix = "verbale",
    
    [Parameter()]
    [string]$FileExtension = ".pdf"
)

# Controlla se è stato fornito un file
if ([string]::IsNullOrEmpty($FilePath)) {
    Write-Host "ERRORE: Nessun file fornito. Trascina un file sullo script o forniscilo come parametro."
    Pause
    exit 1
}

# Verifica che il file esista
if (-not (Test-Path -Path $FilePath)) {
    Write-Host "ERRORE: Il file specificato non esiste: $FilePath"
    Pause
    exit 1
}

# Ottieni informazioni sul file
$file = Get-Item -Path $FilePath

# Controlla l'estensione del file
if ($file.Extension -ne $FileExtension) {
    Write-Host "ERRORE: Il file non ha l'estensione corretta. Richiesta: $FileExtension, Trovata: $($file.Extension)"
    Pause
    exit 1
}

# Crea il nuovo nome file aggiungendo il suffisso
$newFileName = "$($file.BaseName)$Suffix$($file.Extension)"
$newFilePath = Join-Path -Path $file.DirectoryName -ChildPath $newFileName

# Verifica se esiste già un file con il nuovo nome
if (Test-Path -Path $newFilePath) {
    Write-Host "ATTENZIONE: Esiste già un file con il nome: $newFileName"
    Pause
    exit 1
}

# Rinomina il file
try {
    Rename-Item -Path $file.FullName -NewName $newFileName -ErrorAction Stop
    Write-Host "File rinominato con successo!"
    Write-Host "Vecchio nome: $($file.Name)"
    Write-Host "Nuovo nome: $newFileName"
} catch {
    Write-Host "ERRORE durante la rinomina del file: $_"
    Pause
    exit 1
}

Pause
