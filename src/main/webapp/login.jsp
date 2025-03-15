<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - Gestion Académique</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome pour les icônes -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            max-width: 450px;
            margin: 100px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            background-color: white;
        }
        .login-logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-logo i {
            font-size: 50px;
            color: #0d6efd;
        }
        .login-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        .form-floating {
            margin-bottom: 20px;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            font-weight: bold;
        }
        .login-footer {
            text-align: center;
            margin-top: 30px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="login-logo">
                <i class="fas fa-university"></i>
            </div>
            <h2 class="login-title">Connexion au Système de Gestion Académique</h2>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <% if ("invalid".equals(request.getParameter("error"))) { %>
                        Identifiants incorrects. Veuillez réessayer.
                    <% } else if ("session".equals(request.getParameter("error"))) { %>
                        Votre session a expiré. Veuillez vous reconnecter.
                    <% } else if ("access".equals(request.getParameter("error"))) { %>
                        Vous n'avez pas accès à cette ressource.
                    <% } else { %>
                        Une erreur s'est produite. Veuillez réessayer.
                    <% } %>
                </div>
            <% } %>
            
            <% if (request.getParameter("logout") != null) { %>
                <div class="alert alert-success" role="alert">
                    Vous avez été déconnecté avec succès.
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email" placeholder="nom@exemple.com" required>
                    <label for="email">Adresse e-mail</label>
                </div>
                <div class="form-floating">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Mot de passe" required>
                    <label for="password">Mot de passe</label>
                </div>
                <button type="submit" class="btn btn-primary btn-login">
                    <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                </button>
            </form>
            
            <div class="login-footer">
                <p>&copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> ESMT. Tous droits réservés.</p>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
