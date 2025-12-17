#!/usr/bin/env pwsh
<#
.SYNOPSIS
Verifica a saúde da stack Microinfra local, incluindo bancos de dados via docker exec.
.DESCRIPTION
Carrega variáveis do .env, testa endpoints HTTP e bancos PostgreSQL nos containers.
#>

$ErrorActionPreference = "Stop"

# ===================== CARREGAR .ENV =====================
$envFile = ".env"
if (Test-Path $envFile) {
    Write-Host "🔄 Carregando variáveis do $envFile..." -ForegroundColor Cyan
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*#') { return } # Ignora comentários
        if ($_ -match '^(.*?)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim().Trim('"')
            Set-Item -Path Env:$key -Value $value
        }
    }
} else {
    Write-Host "❌ Arquivo .env não encontrado!" -ForegroundColor Red
    exit 1
}

# ===================== CONFIGURAÇÃO =====================
$allHealthy = $true

# Endpoints HTTP/REST
$services = @(
    @{Name="minio"; URL="http://localhost:9000/minio/health/ready"},
    @{Name="keycloak"; URL="http://localhost:8081/realms/$env:KEYCLOAK_REALM"},
    @{Name="rabbitmq"; URL="http://localhost:15672/"},
    @{Name="redis-exporter"; URL="http://localhost:9121/metrics"},
    @{Name="prometheus"; URL="http://localhost:9090/-/ready"},
    @{Name="grafana"; URL="http://localhost:3001/api/health"},
    @{Name="academic-service"; URL="http://localhost:8080/api/docs"},
    @{Name="import-and-report-service"; URL="http://localhost:8082/api/docs"}
)

# Bancos PostgreSQL dentro dos containers
$databases = @(
    @{Container="academicdb"; User=$env:SPRING_DATASOURCE_USERNAME; Db="academicdb"},
    @{Container="keycloakdb"; User=$env:KC_DB_USERNAME; Db="keycloak"}
)

# ===================== TESTE HTTP =====================
Write-Host "`n🔍 Verificando endpoints HTTP/REST..." -ForegroundColor Cyan

foreach ($svc in $services) {
    try {
        $response = Invoke-WebRequest -Uri $svc.URL -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $($svc.Name) respondendo em $($svc.URL)" -ForegroundColor Green
        } else {
            Write-Host "❌ $($svc.Name) respondeu com HTTP $($response.StatusCode)" -ForegroundColor Red
            $allHealthy = $false
        }
    } catch {
        Write-Host "❌ $($svc.Name) não respondeu em $($svc.URL)" -ForegroundColor Red
        $allHealthy = $false
    }
}

# ===================== TESTE POSTGRES =====================
Write-Host "`n🔍 Verificando bancos PostgreSQL..." -ForegroundColor Cyan

foreach ($db in $databases) {
    $user = if ($db.User) { $db.User } else { "postgres" }

    try {
        $cmd = "docker exec -i $($db.Container) psql -U $user -d $($db.Db) -c `"SELECT 1;`""
        Write-Host "📝 Executando: $cmd"
        $result = docker exec -i $($db.Container) psql -U $user -d $($db.Db) -c "SELECT 1;" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Banco $($db.Db) no container $($db.Container) OK" -ForegroundColor Green
        } else {
            Write-Host "❌ Banco $($db.Db) no container $($db.Container) falhou: $result" -ForegroundColor Red
            $allHealthy = $false
        }
    } catch {
        Write-Host "❌ Erro ao acessar $($db.Db) no container $($db.Container): $_" -ForegroundColor Red
        $allHealthy = $false
    }
}

# ===================== RESULTADO FINAL =====================
if ($allHealthy) {
    Write-Host "`n🎉 Todos os serviços estão funcionando corretamente!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n❌ Alguns serviços não estão funcionando corretamente!" -ForegroundColor Red
    exit 1
}
