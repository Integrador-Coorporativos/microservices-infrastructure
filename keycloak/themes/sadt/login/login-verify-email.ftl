<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SADT - Verificar E-mail</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-login.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>E-mail</span></h1>
        
        <p>Enviamos um link de confirmação para o seu e-mail. <br> 
        Por favor, siga as instruções para ativar sua conta.</p>

        <@ui.displayMessage />

        <div class="verify-email-actions">
            <a href="${url.loginAction}" class="btn-link">
                <button type="button" style="width: 100%;">Reenviar E-mail</button>
            </a>
            
            <p style="margin-top: 20px; font-size: 0.9em;">
                Não recebeu? Verifique a caixa de spam ou 
                <a href="${url.loginUrl}" style="color: #2e7d32; text-decoration: none; font-weight: bold;">volte para o login</a>.
            </p>
        </div>
    </div>
</body>
</html>