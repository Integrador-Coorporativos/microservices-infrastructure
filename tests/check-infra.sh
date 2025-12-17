#!/usr/bin/env bash
# =============================================================================
# Verifica a saúde da stack Microinfra local (Linux/macOS)
# =============================================================================
set -e

ENV_FILE=".env"

# ===================== CARREGAR .ENV =====================
if [ -f "$ENV_FILE" ]; then
    echo "🔄 Carregando variáveis do $ENV_FILE..."
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Arquivo $ENV_FILE não encontrado!"
    exit 1
fi

allHealthy=true

# ===================== CONFIGURAÇÃO =====================
services=(
    "minio|http://localhost:9000/minio/health/ready"
    "keycloak|http://localhost:8081/realms/$KEYCLOAK_REALM"
    "rabbitmq|http://localhost:15672/"
    "redis-exporter|http://localhost:9121/metrics"
    "prometheus|http://localhost:9090/-/ready"
    "grafana|http://localhost:3001/api/health"
    "academic-service|http://localhost:8080/api/docs"
    "import-and-report-service|http://localhost:8082/api/docs"
)

databases=(
    "academicdb|$SPRING_DATASOURCE_USERNAME|academicdb"
    "keycloakdb|$KC_DB_USERNAME|keycloak"
)

# ===================== TESTE HTTP =====================
echo -e "\n🔍 Verificando endpoints HTTP/REST..."
for svc in "${services[@]}"; do
    name="${svc%%|*}"
    url="${svc##*|}"

    if curl --silent --fail --max-time 5 "$url" > /dev/null; then
        echo "✅ $name respondendo em $url"
    else
        echo "❌ $name não respondeu em $url"
        allHealthy=false
    fi
done

# ===================== TESTE POSTGRES =====================
echo -e "\n🔍 Verificando bancos PostgreSQL..."
for db in "${databases[@]}"; do
    container="${db%%|*}"
    rest="${db#*|}"
    user="${rest%%|*}"
    database="${rest##*|}"

    user="${user:-postgres}"

    echo "📝 Executando: docker exec -i $container psql -U $user -d $database -c 'SELECT 1;'"
    if docker exec -i "$container" psql -U "$user" -d "$database" -c "SELECT 1;" > /dev/null 2>&1; then
        echo "✅ Banco $database no container $container OK"
    else
        echo "❌ Banco $database no container $container falhou!"
        allHealthy=false
    fi
done

# ===================== RESULTADO FINAL =====================
if [ "$allHealthy" = true ]; then
    echo -e "\n🎉 Todos os serviços estão funcionando corretamente!"
    exit 0
else
    echo -e "\n❌ Alguns serviços não estão funcionando corretamente!"
    exit 1
fi
