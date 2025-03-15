<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Espace Étudiant</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Bienvenue, <%= request.getAttribute("prenom") %> <%= request.getAttribute("nom") %></h1>
    <p>Email : <%= request.getAttribute("email") %></p>
    <p>Filière : <%= request.getAttribute("filiere") %></p>
    <p>Niveau : <%= request.getAttribute("niveau") %></p>

    <h2>📚 Notes</h2>
    <table border="1">
        <tr>
            <th>Matière</th>
            <th>Note</th>
        </tr>
        <% 
            ResultSet notes = (ResultSet) request.getAttribute("notes");
            while (notes != null && notes.next()) { 
        %>
        <tr>
            <td><%= notes.getString("nom") %></td>
            <td><%= notes.getFloat("note") %></td>
        </tr>
        <% } %>
    </table>

    <h2>🚫 Absences</h2>
    <table border="1">
        <tr>
            <th>Matière</th>
            <th>Date</th>
            <th>Justification</th>
        </tr>
        <% 
            ResultSet absences = (ResultSet) request.getAttribute("absences");
            while (absences != null && absences.next()) { 
        %>
        <tr>
            <td><%= absences.getString("nom") %></td>
            <td><%= absences.getDate("date_absence") %></td>
            <td><%= absences.getString("justification") != null ? absences.getString("justification") : "Non justifiée" %></td>
        </tr>
        <% } %>
    </table>
    <h2>📜 Bulletin</h2>
<a href="BulletinServlet"><button>Télécharger le Bulletin PDF</button></a>
    

    <a href="logout.jsp">Se déconnecter</a>
</body>
</html>
