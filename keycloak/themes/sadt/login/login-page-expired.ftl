<#import "template.ftl" as layout>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-login.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Link Expirado</span></h1>
        <p>A página de autenticação expirou devido à inatividade ou erro de envio.</p>
        <@ui.displayMessage />
        <p class="footer-text"><a href="${url.loginUrl}">« Tentar logar novamente</a></p>
    </div>
</body>
</html>