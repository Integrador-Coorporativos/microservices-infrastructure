#!/usr/bin/env pwsh

Write-Host "🚀 Inicializando ambiente do projeto..." -ForegroundColor Cyan

# ================= CONFIGURAÇÃO =================

$ServicesDir = "services"

$Repos = @{
    "academic_service"           = "https://github.com/Integrador-Coorporativos/academic_service.git"
    "import_and_report_service"  = "https://github.com/Integrador-Coorporativos/import_and_report_service.git"
}

$EnvFile        = ".env"
$EnvExampleFile = ".env-example"

# ================================================

# Garante diretório services
if (-not (Test-Path $ServicesDir)) {
    New-Item -ItemType Directory -Path $ServicesDir | Out-Null
}

Write-Host "`n📦 Verificando repositórios..." -ForegroundColor Yellow

foreach ($Service in $Repos.Keys) {
    $ServicePath = Join-Path $ServicesDir $Service
    $RepoUrl = $Repos[$Service]

    if (Test-Path (Join-Path $ServicePath ".git")) {
        Write-Host "✅ $Service já existe. Pulando clone." -ForegroundColor Green
    }
    else {
        Write-Host "⬇️  Clonando $Service..." -ForegroundColor Cyan
        git clone $RepoUrl $ServicePath

        if ($LASTEXITCODE -ne 0) {
            Write-Error "❌ Falha ao clonar $Service"
            exit 1
        }
    }
}

Write-Host "`n🔐 Verificando arquivo .env..." -ForegroundColor Yellow

if (Test-Path $EnvFile) {
    Write-Host "✅ .env já existe." -ForegroundColor Green
}
else {
    if (Test-Path $EnvExampleFile) {
        Copy-Item $EnvExampleFile $EnvFile
        Write-Host "📝 .env criado a partir de .env-example" -ForegroundColor Green
        Write-Host "⚠️  Edite o arquivo .env antes de subir os containers." -ForegroundColor DarkYellow
    }
    else {
        Write-Error "❌ .env-example não encontrado!"
        exit 1
    }
}

Write-Host "`n🎉 Ambiente preparado com sucesso!" -ForegroundColor Cyan
Write-Host "👉 Execute: docker compose -f docker-compose.local.yml up -d" -ForegroundColor White
