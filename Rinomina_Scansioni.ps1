# Controlla se è stato trascinato un file sullo script
if ($null -eq $args[0]) {
    Write-Host "Nessun file è stato trascinato sullo script."
    Pause
    exit
}

# Ottieni il percorso del file trascinato
$filePath = $args[0]

# Controlla se il file è un PDF
if ($filePath -like "*.pdf") {
    # Aggiungi "verbale" al nome del file
    $file = Get-Item -Path $filePath
    $newFileName = "$($file.BaseName)verbale.pdf"
    Rename-Item -Path $file.FullName -NewName $newFileName
} else {
    Write-Host "Il file non è un PDF."
    Pause
    exit
}
