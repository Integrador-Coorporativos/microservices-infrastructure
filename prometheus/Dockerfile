# Usa a imagem oficial como base
FROM prom/prometheus:latest

# Define o diretório de trabalho (padrão do prometheus)
WORKDIR /prometheus

# Copia o seu arquivo de configuração local para dentro da imagem
# Certifique-se de que o arquivo prometheus.yml está na mesma pasta que este Dockerfile
COPY ./prometheus/prometheus.yml /etc/prometheus/prometheus.yml

# Expõe a porta padrão
EXPOSE 9090

# Define o comando de inicialização com os parâmetros que você já usava
ENTRYPOINT [ "/bin/prometheus" ]
CMD [ "--config.file=/etc/prometheus/prometheus.yml", \
      "--storage.tsdb.path=/prometheus", \
      "--web.console.libraries=/usr/share/prometheus/console_libraries", \
      "--web.console.templates=/usr/share/prometheus/consoles" ]