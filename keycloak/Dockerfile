# Usamos a imagem oficial estável
FROM quay.io/keycloak/keycloak:25.0

# Definimos o diretório de trabalho
WORKDIR /opt/keycloak

# O SEGREDO: Usamos --chown para dar permissão ao usuário keycloak
# Isso evita erros de "Acesso Negado" ao carregar o tema sadt
COPY --chown=keycloak:keycloak ./realms/import /opt/keycloak/data/import
COPY --chown=keycloak:keycloak ./themes/sadt /opt/keycloak/themes/sadt

# O comando para iniciar o Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

# Adicionei o argumento --http-relative-path caso você use subcaminhos, 
# mas o principal é o --import-realm
CMD ["start-dev", "--import-realm"]