<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-update-profile.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/custom-alerts.css"/>
    <#import "messages-helper.ftl" as ui>
    <title>SADT - Atualizar Perfil</title>
</head>
<body>
    <div class="kc-login-container">
        <h1>SADT<span>Perfil</span></h1>
        <p>Atualize suas informações para continuar.</p>

        <@ui.displayMessage />

        <form id="kc-update-profile-form" action="${url.loginAction}" method="post">
            
            <div class="input-group">
                <label for="firstName">Nome Completo</label>
                <input type="text" id="firstName" name="firstName" value="${(user.firstName)!''}" required/>
            </div>

            <div class="input-group">
                <label for="username">Matrícula</label>
                <input type="text" id="username" name="username" value="${(user.username)!''}" required/>
            </div>

            <div class="input-group">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" value="${(user.email)!''}" required/>
            </div>

            <div class="input-group">
                <label for="type_user">Você é?</label>
                <select name="user.attributes.type_user" id="user.attributes.type_user">
                    <option value="ROLE_ALUNO" 
                        <#if (register.formData['user.attributes.type_user']!'') == 'ROLE_ALUNO'>selected</#if>>
                        Aluno
                    </option>
                    <option value="ROLE_PROFESSOR" 
                        <#if (register.formData['user.attributes.type_user']!'') == 'ROLE_PROFESSOR'>selected</#if>>
                        Professor
                    </option>
                </select>
            </div>
            
            <button type="submit">Salvar Alterações</button>
        </form>
    </div>
</body>
</html>