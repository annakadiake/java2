<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion</title>
    
</head>
<body>
    <div class="container">
        <h2 class="text-center">Connexion</h2>
        <form action="LoginServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Email :</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mot de passe :</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Se connecter</button>
        </form>
        
        
        <% if (request.getParameter("error") != null) { %>
            <p class="text-danger text-center mt-3">Erreur de connexion. Vérifiez vos identifiants.</p>
        <% } %>
    </div>
</body>
</html>
