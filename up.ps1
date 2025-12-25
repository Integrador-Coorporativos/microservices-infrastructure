#!/usr/bin/env pwsh
param (
    [switch]$Update,
    [switch]$Build,
    [switch]$Prod    # Novo parâmetro para identificar o ambiente
)

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
    Write-Host "🚀 AMBIENTE: PRODUÇÃO (EC2)" -ForegroundColor Magenta -Bold
} else {
    $ComposeFile = "docker-compose.local.yml"
    Write-Host "💻 AMBIENTE: LOCAL" -ForegroundColor Cyan
}

# =====================================================

# O Bootstrap geralmente só faz sentido localmente (para configurar certificados ou envs de dev)
# Se estiver em prod, podemos pular ou rodar apenas se necessário
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

# Docker compose args
$ComposeArgs = @("-f", $ComposeFile, "up", "-d", "--remove-orphans")

if ($Build) {
    $ComposeArgs += "--build"
}

# Em produção, geralmente queremos dar um pull antes para garantir as imagens do ECR
if ($Prod) {
    Write-Host "📥 Atualizando imagens do ECR/Docker Hub..." -ForegroundColor Gray
    docker-compose -f $ComposeFile pull
}

Write-Host "`n🐳 Executando: docker-compose -f $ComposeFile up -d $($Build ? '--build' : '')" -ForegroundColor Cyan
docker-compose @ComposeArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Infraestrutura iniciada com sucesso via $ComposeFile!" -ForegroundColor Green
} else {
    Write-Host "`n❌ Falha ao iniciar containers." -ForegroundColor Red
    exit 1
}
