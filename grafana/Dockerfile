FROM grafana/grafana-oss:12.3.1

# Usuário root para instalar pacotes e criar pastas
USER root

# Instala curl para baixar os dashboards da API do Grafana
RUN apk add --no-network --no-cache curl || apk add --no-cache curl

# Cria a estrutura de pastas para o provisionamento
RUN mkdir -p /etc/grafana/provisioning/dashboards/files /etc/grafana/provisioning/datasources

# 1. Baixa os Dashboards JSON automaticamente (IDs que discutimos)
# Spring Boot (19004), Redis (11835), RabbitMQ (10991), MinIO (13502)
RUN curl -sL https://grafana.com/api/dashboards/19004/revisions/1/download -o /etc/grafana/provisioning/dashboards/files/spring-boot.json && \
    curl -sL https://grafana.com/api/dashboards/11835/revisions/1/download -o /etc/grafana/provisioning/dashboards/files/redis.json && \
    curl -sL https://grafana.com/api/dashboards/10991/revisions/11/download -o /etc/grafana/provisioning/dashboards/files/rabbitmq.json && \
    curl -sL https://grafana.com/api/dashboards/13502/revisions/1/download -o /etc/grafana/provisioning/dashboards/files/minio.json

COPY provisioning/ /etc/grafana/provisioning/

# Volta para o usuário padrão do Grafana por segurança
USER grafana

EXPOSE 3000