<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <title>SADT - Cadastro</title>
    <link rel="stylesheet" href="resources/css/custom.css.css"/>
</head>
<body>
    <div class="kc-register-container">
        <h1>SADT<span>Register</span></h1>
        <p>Vamos dar o primeiro passo rumo ao controle financeiro.</p>
        <form id="kc-register-form" action="${url.registrationAction}" method="post">
            <input type="text" name="firstName" placeholder="Primeiro nome" required/>
            <input type="text" name="lastName" placeholder="Sobrenome" required/>
            <input type="email" name="email" placeholder="Email" required/>
            <input type="password" name="password" placeholder="Senha" required/>
            <input type="password" name="password-confirm" placeholder="Confirme a senha" required/>
            <button type="submit">Criar Conta</button>
        </form>
        <p>Já tem uma conta? <a href="${url.loginUrl}">Login</a></p>
    </div>
</body>
</html>
