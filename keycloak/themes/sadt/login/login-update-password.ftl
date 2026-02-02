<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>SADT - Nova Senha</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-login.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Senha</span></h1>
        <p>Você precisa definir uma nova senha para continuar.</p>

        <@ui.displayMessage />

        <form action="${url.loginAction}" method="post">
            <input type="password" name="password-new" placeholder="Nova Senha" required autofocus/>
            <input type="password" name="password-confirm" placeholder="Confirme a Nova Senha" required/>
            <button type="submit">Atualizar Senha</button>
        </form>
    </div>
</body>
</html>