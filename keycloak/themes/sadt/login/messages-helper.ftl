<#macro displayMessage>
    <#if message?exists>
        <div class="alert alert-${message.type}">
            <#if message.type == 'success'><span></span></#if>
            <#if message.type == 'error'><span></span></#if>
            <#if message.type == 'warning'><span></span></#if>
            <span class="kc-feedback-text">
                <#assign msgKey = message.summary>
                
                <#-- SUCESSO -->
                <#if msgKey?contains("updateProfileMessage")>
                    Perfil atualizado com sucesso!
                <#elseif msgKey?contains("emailSentMessage")>
                    E-mail enviado! Verifique sua caixa de entrada.
                <#elseif msgKey?contains("accountUpdatedMessage")>
                    Conta atualizada com sucesso.
                <#elseif msgKey?contains("passwordUpdatedMessage")>
                    Senha alterada com sucesso.

                <#-- ERROS DE LOGIN -->
                <#-- Nota: invalidUserMessage é usado quando o usuário não existe -->
                <#elseif msgKey?contains("invalidUserMessage") || msgKey?contains("invalidPasswordMessage") || msgKey?contains("invalidUsernameOrPasswordMessage")>
                    Matrícula/SIAPE ou senha inválidos.
                <#elseif msgKey?contains("userDisabledMessage")>
                    Esta conta está desativada. Entre em contato com o suporte.
                <#elseif msgKey?contains("userTemporarilyDisabledMessage")>
                    Conta temporariamente bloqueada por excesso de tentativas.

                <#-- NOVOS ERROS DE VALIDAÇÃO (USER PROFILE REGEX) -->
                <#elseif msgKey?contains("error-username-invalid-format")>
                    Identificador inválido. Use apenas números: 7 para SIAPE ou 14 para Matrícula.
                <#elseif msgKey?contains("error-email-domain-invalid")>
                    E-mail inválido. Use @academico.ifrn.edu.br ou @escolar.ifrn.edu.br.

                <#-- ERROS DE CADASTRO -->
                <#elseif msgKey?contains("usernameExistsMessage")>
                    Essa Matrícula/SIAPE já está cadastrada no SADT.
                <#elseif msgKey?contains("emailExistsMessage")>
                    Este e-mail já está cadastrado.
                <#elseif msgKey?contains("passwordConfirmNotMatchMessage")>
                    As senhas informadas não coincidem.
                <#elseif msgKey?contains("missingUsernameMessage") || msgKey?contains("error-invalid-username")>
                    Por favor, informe uma Matrícula ou SIAPE válido.
                <#elseif msgKey?contains("missingFirstNameMessage")>
                    Por favor, informe seu nome.
                <#elseif msgKey?contains("missingEmailMessage")>
                    Por favor, informe seu e-mail institucional.

                <#-- ERROS DE SISTEMA / SESSÃO -->
                <#elseif msgKey?contains("expiredCodeMessage") || msgKey?contains("actionLifecycleMessage")>
                    A sessão expirou. Por favor, tente novamente do início.
                <#elseif msgKey?contains("invalidCodeMessage")>
                    Código de verificação inválido ou expirado.

                <#-- ERROS DE POLÍTICA DE SENHA (PASSWORD POLICIES) -->
                <#elseif msgKey?contains("invalidPasswordMinLengthMessage")>
                    A senha é muito curta. Use pelo menos ${message.parameters[0]} caracteres.
                <#elseif msgKey?contains("invalidPasswordMinSpecialCharsMessage")>
                    A senha precisa de pelo menos um caractere especial (ex: @, #, $).
                <#elseif msgKey?contains("invalidPasswordMinUpperCaseMessage")>
                    A senha precisa de pelo menos uma letra maiúscula.
                <#elseif msgKey?contains("invalidPasswordNotUsernameMessage") || msgKey?contains("invalidPasswordContainsUsernameMessage")>
                    A senha não pode ser igual ou conter sua Matrícula/SIAPE.
                <#elseif msgKey?contains("invalidPasswordNotEmailMessage")>
                    A senha não pode ser o seu e-mail.
                <#elseif msgKey?contains("invalidPasswordMaxLengthMessage")>
                    A senha ultrapassou o limite máximo de caracteres permitido.
                
                <#-- CASO NÃO MAPEADO (Exibe o erro original do Keycloak) -->
                <#else>
                    ${msgKey}
                </#if>
            </span>
        </div>
    </#if>
</#macro>