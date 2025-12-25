#!/usr/bin/env bash
set -e

ENV_FILE=".env"

# ===================== CARREGAR .ENV =====================
if [ -f "$ENV_FILE" ]; then
    echo "🔄 Carregando variáveis do $ENV_FILE..."
    # Usando a+ para garantir compatibilidade no export
    export $(grep -v '^#' "$ENV_FILE" | xargs -d '\n')
else
    echo "⚠️ Arquivo $ENV_FILE não encontrado! Tentando usar variáveis de ambiente do sistema..."
fi

allHealthy=true

# ===================== CONFIGURAÇÃO =====================
# Mudamos os endpoints para caminhos mais "estáveis"
services=(
    "minio|http://localhost:9000/minio/health/ready"
    "keycloak|http://localhost:8080/health/live" # Endpoint de saúde do Keycloak (Quarkus)
    "rabbitmq|http://localhost:15672/"
    "redis-exporter|http://localhost:9121/metrics"
    "prometheus|http://localhost:9090/-/ready"
    "grafana|http://localhost:3001/api/health"
    "academic-service|http://localhost:8085/actuator/health"
    "import-and-report-service|http://localhost:8082/actuator/health"
)

databases=(
    "academicdb|$SPRING_DATASOURCE_USERNAME|academicdb"
    "keycloakdb|$KC_DB_USERNAME|keycloak"
)

# ===================== TESTE HTTP (VERSÃO RESILIENTE) =====================
echo -e "\n🔍 Verificando endpoints HTTP/REST..."
for svc in "${services[@]}"; do
    name="${svc%%|*}"
    url="${svc##*|}"

    # Adicionamos || echo "000" para que o script não morra se o curl der erro 52 ou 7
    status_code=$(curl --silent --output /dev/null --write-out "%{http_code}" --max-time 10 "$url" || echo "000")

    if [[ "$status_code" =~ ^(200|401|302|404)$ ]]; then
        echo "✅ $name respondendo (Status: $status_code) em $url"
    else
        echo "❌ $name falhou! (Status: $status_code - Erro de conexão ou timeout) em $url"
        allHealthy=false
    fi
done

# ===================== TESTE POSTGRES (MANTIDO) =====================
echo -e "\n🔍 Verificando bancos PostgreSQL..."
for db in "${databases[@]}"; do
    container="${db%%|*}"
    rest="${db#*|}"
    user="${rest%%|*}"
    database="${rest##*|}"
    user="${user:-postgres}"

    if docker exec -i "$container" psql -U "$user" -d "$database" -c "SELECT 1;" > /dev/null 2>&1; then
        echo "✅ Banco $database no container $container OK"
    else
        echo "❌ Banco $database no container $container falhou!"
        allHealthy=false
    fi
done

# ===================== RESULTADO FINAL =====================
if [ "$allHealthy" = true ]; then
    echo -e "\n🎉 Infraestrutura validada com sucesso!"
    exit 0
else
    echo -e "\n❌ Falha na validação da infraestrutura!"
    exit 1
fi
