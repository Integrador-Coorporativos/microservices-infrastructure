<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <title>SADT - Login</title>
    <link rel="stylesheet" href="resources/css/custom.css"/>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Login</span></h1>
        <p>Controle suas finanças. Faça login para começar!</p>
        <form id="kc-form-login" action="${url.loginAction}" method="post">
            <input type="text" name="username" placeholder="Email" required/>
            <input type="password" name="password" placeholder="Senha" required/>
            <button type="submit">Entrar</button>
        </form>
        <p>Não tem uma conta? <a href="${url.registrationUrl}">Cadastre-se</a></p>
    </div>
</body>
</html>
