#!/usr/bin/env pwsh
param (
    [switch]$Update
)

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

if (-not (Test-Path $ServicesDir)) {
    New-Item -ItemType Directory -Path $ServicesDir | Out-Null
}

Write-Host "`n📦 Verificando repositórios..." -ForegroundColor Yellow

foreach ($Service in $Repos.Keys) {
    $ServicePath = Join-Path $ServicesDir $Service
    $RepoUrl = $Repos[$Service]

    if (Test-Path (Join-Path $ServicePath ".git")) {
        if ($Update) {
            Push-Location $ServicePath
            try {
                $CurrentBranch = git branch --show-current
                Write-Host "🔄 ${Service}: Atualizando via 'git pull origin $CurrentBranch'..." -ForegroundColor Gray
                
                # Verifica se há alterações locais para evitar que o pull falhe no meio
                $isDirty = git status --porcelain
                if ($null -eq $isDirty) {
                    # Tenta fazer o pull direto do origin na branch atual
                    git pull origin $CurrentBranch -q
                    
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "✅ ${Service} atualizado com sucesso!" -ForegroundColor Green
                    } else {
                        Write-Host "❌ ${Service}: Erro ao tentar sincronizar com origin." -ForegroundColor Red
                    }
                } else {
                    Write-Host "⚠️  ${Service}: Você tem alterações locais. Pulei o pull para evitar conflitos." -ForegroundColor DarkYellow
                }
            } finally {
                Pop-Location
            }
        } else {
            Write-Host "✅ ${Service} já existe." -ForegroundColor Green
        }
    }
    else {
        Write-Host "⬇️  ${Service} não encontrado. Clonando..." -ForegroundColor Cyan
        git clone $RepoUrl $ServicePath
        if ($LASTEXITCODE -ne 0) {
            Write-Error "❌ Falha ao clonar $Service"
            exit 1
        }
    }
}

Write-Host "`n🔐 Verificando arquivo .env..." -ForegroundColor Yellow
if (-not (Test-Path $EnvFile)) {
    if (Test-Path $EnvExampleFile) {
        Copy-Item $EnvExampleFile $EnvFile
        Write-Host "📝 .env criado a partir de .env-example" -ForegroundColor Green
    } else {
        Write-Error "❌ .env-example não encontrado!"
        exit 1
    }
} else {
    Write-Host "✅ .env já existe." -ForegroundColor Green
}

Write-Host "`n🎉 Bootstrap finalizado!" -ForegroundColor Cyan