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
                <#elseif msgKey?contains("invalidUserMessage") || msgKey?contains("invalidPasswordMessage") || msgKey?contains("invalidUsernameOrPasswordMessage")>
                    Usuário ou senha inválidos.
                <#elseif msgKey?contains("userDisabledMessage")>
                    Esta conta está desativada. Entre em contato com o suporte.
                <#elseif msgKey?contains("userTemporarilyDisabledMessage")>
                    Conta temporariamente bloqueada por excesso de tentativas.

                <#-- ERROS DE CADASTRO -->
                <#elseif msgKey?contains("usernameExistsMessage")>
                    Essa Matrícula já está cadastrada.
                <#elseif msgKey?contains("emailExistsMessage")>
                    Este e-mail já está cadastrado.
                <#elseif msgKey?contains("passwordConfirmNotMatchMessage")>
                    As senhas informadas não coincidem.
                <#elseif msgKey?contains("missingUsernameMessage")>
                    Por favor, informe um nome de usuário.
                <#elseif msgKey?contains("missingFirstNameMessage")>
                    Por favor, informe seu nome.

                <#-- ERROS DE SISTEMA / SESSÃO -->
                <#elseif msgKey?contains("expiredCodeMessage") || msgKey?contains("actionLifecycleMessage")>
                    A sessão expirou. Por favor, tente novamente do início.
                <#elseif msgKey?contains("invalidCodeMessage")>
                    Código de verificação inválido ou expirado.
                
                <#-- CASO NÃO MAPEADO -->
                <#else>
                    ${msgKey}
                </#if>
            </span>
        </div>
    </#if>
</#macro>