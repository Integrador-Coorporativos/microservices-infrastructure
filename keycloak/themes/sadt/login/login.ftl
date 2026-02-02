<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SADT - Login</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-login.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Login</span></h1>
        <p>Acesse o sistema para gerenciar suas avaliações.</p>

        <@ui.displayMessage />

        <form id="kc-form-login" action="${url.loginAction}" method="post">
            
            <#-- Campo de Usuário/Email -->
            <input type="text" id="username" name="username" placeholder="Matrícula ou E-mail" 
                   value="${(login.username!'')}" autofocus autocomplete="off" required/>

            <#-- Campo de Senha -->
            <input type="password" id="password" name="password" placeholder="Sua senha" 
                   autocomplete="off" required/>

            <#-- Esqueci minha senha (Opcional) -->
            <#if realm.resetPasswordAllowed>
                <div class="forgot-password">
                    <a href="${url.loginResetCredentialsUrl}">Esqueceu a senha?</a>
                </div>
            </#if>

            <button type="submit">Entrar</button>
        </form>

        <#-- Link para o Cadastro -->
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <p class="footer-text">Não tem uma conta? <a href="${url.registrationUrl}">Cadastre-se</a></p>
        </#if>
    </div>
</body>
</html>