<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tableau de Bord Administrateur</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Bienvenue, Administrateur</h1>

    <h2>📌 Ajouter un Étudiant</h2>
    <form action="AdminServlet" method="post">
        <input type="hidden" name="action" value="ajouterEtudiant">
        <label>Nom :</label> <input type="text" name="nom" required>
        <label>Prénom :</label> <input type="text" name="prenom" required>
        <label>Email :</label> <input type="email" name="email" required>
        <label>Filière :</label> <input type="text" name="filiere" required>
        <label>Niveau :</label> <input type="text" name="niveau" required>
        <button type="submit">Ajouter</button>
    </form>

    <h2>👨‍🏫 Ajouter un Enseignant</h2>
    <form action="AdminServlet" method="post">
        <input type="hidden" name="action" value="ajouterEnseignant">
        <label>Nom :</label> <input type="text" name="nom" required>
        <label>Prénom :</label> <input type="text" name="prenom" required>
        <label>Email :</label> <input type="email" name="email" required>
        <label>Spécialité :</label> <input type="text" name="specialite" required>
        <button type="submit">Ajouter</button>
    </form>

    <h2>📚 Ajouter une Matière</h2>
    <form action="AdminServlet" method="post">
        <input type="hidden" name="action" value="ajouterMatiere">
        <label>Nom de la Matière :</label> <input type="text" name="nom" required>
        <label>Coefficient :</label> <input type="number" name="coefficient" required>
        <button type="submit">Ajouter</button>
    </form>

    <h2>📊 Statistiques</h2>
    <p>Nombre d'Étudiants : <%= request.getAttribute("totalEtudiants") %></p>
    <p>Nombre d'Enseignants : <%= request.getAttribute("totalEnseignants") %></p>
    <p>Nombre de Matières : <%= request.getAttribute("totalMatieres") %></p>

    <a href="logout.jsp">Se déconnecter</a>
</body>
</html>
