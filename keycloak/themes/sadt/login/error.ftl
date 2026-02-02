<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>SADT - Erro</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-login.css"/>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Ops!</span></h1>
        <p>Ocorreu um erro inesperado.</p>
        
        <div class="alert-error">
            <#-- O "!" após a variável evita o erro 500 caso a mensagem venha vazia -->
            ${(message.summary)!''?no_esc}
        </div>

        <p class="footer-text" style="margin-top: 20px;">
            <a href="${url.loginUrl}" style="text-decoration: none; color: #2e7d32; font-weight: bold;">
                « Voltar para o início
            </a>
        </p>
    </div>
</body>
</html>