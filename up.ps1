#!/usr/bin/env pwsh
param (
    [switch]$Update,
    [switch]$Build,
    [switch]$Prod    
)

# --- DETECÇÃO CORRIGIDA ---
$IsV2 = $false
try {
    # No terminal, 'docker compose' é um comando composto. 
    # Testamos se o plugin V2 responde.
    docker compose version > $null 2>&1
    if ($LASTEXITCODE -eq 0) { $IsV2 = $true }
} catch {}

# Função auxiliar para evitar o erro de "command not recognized"
function Invoke-DockerCompose {
    param([string[]]$Arguments)
    if ($IsV2) {
        docker compose @Arguments
    } else {
        docker-compose @Arguments
    }
}

# Nome da rede
$networkName = "infra"
$networkExists = docker network ls --format '{{.Name}}' | Select-String -Pattern "^$networkName$"

if (-not $networkExists) {
    Write-Host "🔧 Rede '$networkName' não encontrada. Criando..." -ForegroundColor Yellow
    docker network create $networkName
} else {
    Write-Host "✅ Rede '$networkName' já existe." -ForegroundColor Gray
}

# ================= CONFIG (DINÂMICA) =================
if ($Prod) {
    $ComposeFile = "docker-compose.prod.yml"
    Write-Host "🚀 AMBIENTE: PRODUÇÃO (EC2)" -ForegroundColor Magenta
} else {
    $ComposeFile = "docker-compose.local.yml"
    Write-Host "💻 AMBIENTE: LOCAL" -ForegroundColor Cyan
}

# =====================================================
if (-not $Prod) {
    Write-Host "🛠️ Executando Bootstrap..." -ForegroundColor Gray
    $BootstrapArgs = @()
    if ($Update) { $BootstrapArgs += "--update" }
    pwsh ./bootstrap.ps1 @BootstrapArgs
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

# Em produção, garantimos o pull das imagens
if ($Prod) {
    Write-Host "📥 Atualizando imagens do ECR/Docker Hub..." -ForegroundColor Gray
    Invoke-DockerCompose -Arguments @("-f", $ComposeFile, "pull")
}

# Preparando argumentos finais
$ComposeArgs = @("-f", $ComposeFile, "up", "-d", "--remove-orphans")
if ($Build) { $ComposeArgs += "--build" }

$CmdLabel = $IsV2 ? "docker compose" : "docker-compose"
Write-Host "`n🐳 Executando: $CmdLabel -f $ComposeFile up -d" -ForegroundColor Cyan

# CHAMADA FINAL CORRIGIDA
Invoke-DockerCompose -Arguments $ComposeArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Infraestrutura iniciada com sucesso via $ComposeFile!" -ForegroundColor Green
} else {
    Write-Host "`n❌ Falha ao iniciar containers." -ForegroundColor Red
    exit 1
}
