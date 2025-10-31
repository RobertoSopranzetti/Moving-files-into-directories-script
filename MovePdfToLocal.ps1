# Verifica se è stato trascinato almeno un file
if ($args.Count -eq 0) {
    Write-Host "Trascina il file da spostare su questo script e riprova."
    pause
    exit
}

# Imposta il percorso del file trascinato
$fileDaSpostare = $args[0]

$fileInfo = Get-Item $fileDaSpostare

# Verifica se il file è un pdf
if ($fileInfo.Extension -ne ".pdf") {
    Write-Host "ERRORE: Il file trascinato non è un file PDF."
    pause
    exit
}

# Estrai il nome del file
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($fileDaSpostare)
$parteNome = $fileName.Substring(0, 5)

# Prendi la cartella comune
$cartellaComune = "C:\Users\calda\Desktop\commesse"

# Trova la sottocartella in base al nome del file
$cartellaDiDestinazione = Get-ChildItem -Path $cartellaComune -Directory | Where-Object { $_.Name.StartsWith($parteNome) }

# Se non è stata trovata nessuna sottocartella, esci dallo script
if ($cartellaDiDestinazione -eq $null) {
    Write-Host "Nessuna sottocartella trovata con il nome $parteNome."
    pause
    exit
}

# Aggiungi la sotto-cartella al percorso della cartella di destinazione
$cartellaDiDestinazione = Join-Path -Path $cartellaDiDestinazione.FullName -ChildPath "Produzione"

# Se la cartella di destinazione non esiste dai errore
if (-not (Test-Path -Path $cartellaDiDestinazione)) {
    Write-Host "La sottocartella produzione qui non esiste, fai controllare"
    pause
    exit
}

# Controlla se esiste già un file che inizia con lo stesso nome del file di input
$fileEsistente = Get-ChildItem -Path $cartellaDiDestinazione -File | Where-Object { $_.Name.StartsWith($fileName) }
if ($fileEsistente -ne $null) {
    Write-Host "Esiste già un file con lo stesso nome nella cartella di destinazione."
    pause
    exit
}

# Sposta il file nella cartella di destinazione
# Assicurati che il percorso della cartella di destinazione sia valido
Move-Item -Path $fileDaSpostare -Destination $cartellaDiDestinazione

Write-Host "Il file è stato spostato con successo."
pause