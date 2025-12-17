#!/usr/bin/env pwsh
param (
    [switch]$Update,
    [switch]$Build
)

# Nome da rede
$networkName = "infra"

# Verifica se a rede existe
$networkExists = docker network ls --format '{{.Name}}' | Select-String -Pattern "^$networkName$"

if (-not $networkExists) {
    Write-Host "🔧 Rede '$networkName' não encontrada. Criando..."
    docker network create $networkName
} else {
    Write-Host "✅ Rede '$networkName' já existe."
}


Write-Host "🐳 Inicialização do Docker Compose (LOCAL)" -ForegroundColor Cyan

# ================= CONFIG =================

$ComposeFile = "docker-compose.local.yml"

# ==========================================

# Bootstrap
$BootstrapArgs = @()
if ($Update) { $BootstrapArgs += "--update" }

pwsh ./bootstrap.ps1 @BootstrapArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Erro no bootstrap. Abortando."
    exit 1
}

# Docker compose args
$ComposeArgs = @("-f", $ComposeFile, "up", "-d")

if ($Build) {
    $ComposeArgs += "--build"
}

Write-Host "`n🐳 docker compose -f $ComposeFile up -d $($Build ? '--build' : '')" -ForegroundColor Cyan
docker compose @ComposeArgs
