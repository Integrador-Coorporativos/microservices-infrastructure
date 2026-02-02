<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SADT - Cadastro</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-register.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
</head>
<body>
    <div class="kc-register-container">
        <h1>SADT<span>Register</span></h1>
        <p>Crie sua conta para acessar o sistema acadêmico.</p>

        <@ui.displayMessage />
        
        <form id="kc-register-form" action="${url.registrationAction}" method="post">
            
            <#-- Nome (Mapeado para firstName internamente) -->
            <input type="text" id="firstName" name="firstName" placeholder="Nome completo" 
                   value="${(register.formData.firstName!'')}" required/>

            <#-- Username (Obrigatório para o Keycloak) -->
            <input type="text" id="username" name="username" placeholder="Matrícula" 
                   value="${(register.formData.username!'')}" required/>

            <#-- Email -->
            <input type="email" id="email" name="email" placeholder="Seu e-mail Acadêmico" 
                   value="${(register.formData.email!'')}" required/>

            <div class="custom-select-wrapper" style="text-align: left; margin-bottom: 15px;">
                <label style="font-size: 12px; color: #666; margin-left: 5px;">Você é?</label>
                <select name="user.attributes.type_user" id="type_user" required>
                    <option value="Aluno"
                        <#if (register.formData['user.attributes.type_user']!'') == 'Aluno'>selected</#if>>
                        Aluno
                    </option>
                    <option value="Professor"
                        <#if (register.formData['user.attributes.type_user']!'') == 'Professor'>selected</#if>>
                        Professor
                    </option>
                </select>
            </div>

            <#-- Senhas -->
            <input type="password" id="password" name="password" placeholder="Senha" required/>
            <input type="password" id="password-confirm" name="password-confirm" placeholder="Confirme a senha" required/>

            <button type="submit">Criar Conta</button>
        </form>

        <p class="footer-text">Já tem uma conta? <a href="${url.loginUrl}">Login</a></p>
        
    </div>
</body>
</html>