<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>SADT - Recuperar Senha</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-login.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Reset</span></h1>
        <p>Esqueceu sua senha? Digite seu e-mail ou usuário para receber as instruções.</p>
        <@ui.displayMessage />

        <form action="${url.loginAction}" method="post">
            <input type="text" name="username" placeholder="Usuário ou E-mail" required autofocus/>
            <button type="submit">Enviar Instruções</button>
        </form>

        <p class="footer-text">Lembrou a senha? <a href="${url.loginUrl}">Voltar ao Login</a></p>

        <#if message?exists>
            <div class="alert-error">${message.summary?no_esc}</div>
        </#if>
    </div>
</body>
</html>