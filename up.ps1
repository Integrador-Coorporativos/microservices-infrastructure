#!/usr/bin/env pwsh
param (
    [switch]$Update,
    [switch]$Build,
    [switch]$Prod    # Novo parâmetro para identificar o ambiente
)

# --- DETECÇÃO UNIVERSAL DO COMANDO DOCKER COMPOSE ---
# Tenta 'docker compose' (V2), se falhar usa 'docker-compose' (V1)
$DockerCmd = "docker-compose"
try {
    # Testa se o plugin 'compose' do comando 'docker' responde
    docker compose version > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        $DockerCmd = "docker compose"
    }
} catch {
    $DockerCmd = "docker-compose"
}

# Nome da rede
$networkName = "infra"

# Verifica se a rede existe
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

    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Erro no bootstrap. Abortando."
        exit 1
    }
}

# Em produção, garantimos o pull das imagens
if ($Prod) {
    Write-Host "📥 Atualizando imagens do ECR/Docker Hub..." -ForegroundColor Gray
    # Usamos o operador de chamada '&' para executar a variável como comando
    & (Get-Variable DockerCmd -ValueOnly) -f $ComposeFile pull
}

# Docker compose args (Removido o 'up' e '-d' fixos para usar dinamicamente no comando final)
$ComposeArgs = @("-f", $ComposeFile, "up", "-d", "--remove-orphans")

if ($Build) {
    $ComposeArgs += "--build"
}

Write-Host "`n🐳 Executando: $DockerCmd -f $ComposeFile up -d $($Build ? '--build' : '')" -ForegroundColor Cyan

# Execução Final
& (Get-Variable DockerCmd -ValueOnly) @ComposeArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Infraestrutura iniciada com sucesso via $ComposeFile!" -ForegroundColor Green
} else {
    Write-Host "`n❌ Falha ao iniciar containers." -ForegroundColor Red
    exit 1
}
