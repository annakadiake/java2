package com.gestionacademique.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.gestionacademique.dao.EnseignantDAO;
import com.gestionacademique.dao.EtudiantDAO;
import com.gestionacademique.dao.MatiereDAO;
import com.gestionacademique.dao.UtilisateurDAO;
import com.gestionacademique.model.Enseignant;
import com.gestionacademique.model.Etudiant;
import com.gestionacademique.model.Matiere;
import com.gestionacademique.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private EnseignantDAO enseignantDAO = new EnseignantDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=access");
            return;
        }
        
        try {
            // Compter les statistiques pour le tableau de bord
            int totalEtudiants = etudiantDAO.trouverTous().size();
            int totalEnseignants = enseignantDAO.trouverTous().size();
            int totalMatieres = matiereDAO.trouverTous().size();
            
            // Statistiques sur les matières
            List<Matiere> matieres = matiereDAO.trouverTous();
            int matieresAvecEnseignant = 0;
            int coefficientTotal = 0;
            
            for (Matiere matiere : matieres) {
                if (matiere.getEnseignantId() != null) {
                    matieresAvecEnseignant++;
                }
                coefficientTotal += matiere.getCoefficient();
            }
            
            int matieresSansEnseignant = totalMatieres - matieresAvecEnseignant;
            float coefficientMoyen = totalMatieres > 0 ? (float) coefficientTotal / totalMatieres : 0;
            
            // Récupérer la liste des enseignants pour le formulaire d'ajout de matière
            List<Enseignant> enseignants = enseignantDAO.trouverTous();
            
            // Définir les attributs pour le tableau de bord
            request.setAttribute("totalEtudiants", totalEtudiants);
            request.setAttribute("totalEnseignants", totalEnseignants);
            request.setAttribute("totalMatieres", totalMatieres);
            request.setAttribute("matieresAvecEnseignant", matieresAvecEnseignant);
            request.setAttribute("matieresSansEnseignant", matieresSansEnseignant);
            request.setAttribute("coefficientMoyen", String.format("%.2f", coefficientMoyen));
            request.setAttribute("enseignants", enseignants);
            
            // Déterminer quelle page afficher
            String page = request.getParameter("page");
            if (page == null || page.isEmpty()) {
                page = "dashboard";
            }
            
            switch (page) {
                case "etudiants":
                    List<Etudiant> etudiants = etudiantDAO.trouverTous();
                    request.setAttribute("etudiants", etudiants);
                    request.getRequestDispatcher("admin/etudiants.jsp").forward(request, response);
                    break;
                case "enseignants":
                    request.setAttribute("enseignants", enseignants);
                    request.getRequestDispatcher("admin/enseignants.jsp").forward(request, response);
                    break;
                case "matieres":
                    request.setAttribute("matieres", matieres);
                    request.setAttribute("enseignants", enseignants);
                    request.getRequestDispatcher("admin/matieres.jsp").forward(request, response);
                    break;
                case "dashboard":
                default:
                    request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=access");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "ajouterEtudiant":
                    ajouterEtudiant(request, response);
                    break;
                case "modifierEtudiant":
                    modifierEtudiant(request, response);
                    break;
                case "supprimerEtudiant":
                    supprimerEtudiant(request, response);
                    break;
                case "ajouterEnseignant":
                    ajouterEnseignant(request, response);
                    break;
                case "modifierEnseignant":
                    modifierEnseignant(request, response);
                    break;
                case "supprimerEnseignant":
                    supprimerEnseignant(request, response);
                    break;
                case "ajouterMatiere":
                    ajouterMatiere(request, response);
                    break;
                case "modifierMatiere":
                    modifierMatiere(request, response);
                    break;
                case "supprimerMatiere":
                    supprimerMatiere(request, response);
                    break;
                default:
                    response.sendRedirect("AdminServlet");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }
    
    private void ajouterEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException, ParseException {
        
        String matricule = request.getParameter("matricule");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String dateNaissanceStr = request.getParameter("dateNaissance");
        String filiere = request.getParameter("filiere");
        String niveau = request.getParameter("niveau");
        
        // Vérifier si l'étudiant existe déjà
        Etudiant existant = etudiantDAO.trouverParEmail(email);
        if (existant != null) {
            response.sendRedirect("AdminServlet?page=etudiants&error=email_existe");
            return;
        }
        
        // Créer un nouvel étudiant
        Etudiant etudiant = new Etudiant();
        etudiant.setMatricule(matricule);
        etudiant.setNom(nom);
        etudiant.setPrenom(prenom);
        etudiant.setEmail(email);
        etudiant.setFiliere(filiere);
        etudiant.setNiveau(niveau);
        
        // Convertir la date de naissance si elle est fournie
        if (dateNaissanceStr != null && !dateNaissanceStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateNaissance = sdf.parse(dateNaissanceStr);
            etudiant.setDateNaissance(dateNaissance);
        }
        
        // Insérer l'étudiant
        etudiant = etudiantDAO.inserer(etudiant);
        
        // Créer un compte utilisateur pour l'étudiant
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setEmail(email);
        utilisateur.setMotDePasse("password"); // Mot de passe par défaut, à changer lors de la première connexion
        utilisateur.setRole("etudiant");
        utilisateurDAO.inserer(utilisateur);
        
        response.sendRedirect("AdminServlet?page=etudiants&success=ajoute");
    }
    
    private void modifierEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException, ParseException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        String matricule = request.getParameter("matricule");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String dateNaissanceStr = request.getParameter("dateNaissance");
        String filiere = request.getParameter("filiere");
        String niveau = request.getParameter("niveau");
        
        // Récupérer l'étudiant existant
        Etudiant etudiant = etudiantDAO.trouverParId(id);
        if (etudiant == null) {
            response.sendRedirect("AdminServlet?page=etudiants&error=etudiant_inexistant");
            return;
        }
        
        // Mettre à jour les informations
        etudiant.setMatricule(matricule);
        etudiant.setNom(nom);
        etudiant.setPrenom(prenom);
        
        // Si l'email a changé, mettre à jour aussi le compte utilisateur
        if (!email.equals(etudiant.getEmail())) {
            Utilisateur utilisateur = utilisateurDAO.trouverParEmail(etudiant.getEmail());
            if (utilisateur != null) {
                utilisateur.setEmail(email);
                utilisateurDAO.mettre_a_jour(utilisateur);
            }
            etudiant.setEmail(email);
        }
        
        etudiant.setFiliere(filiere);
        etudiant.setNiveau(niveau);
        
        // Convertir la date de naissance si elle est fournie
        if (dateNaissanceStr != null && !dateNaissanceStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateNaissance = sdf.parse(dateNaissanceStr);
            etudiant.setDateNaissance(dateNaissance);
        }
        
        // Mettre à jour l'étudiant
        etudiantDAO.mettre_a_jour(etudiant);
        
        response.sendRedirect("AdminServlet?page=etudiants&success=modifie");
    }
    
    private void supprimerEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        
        // Récupérer l'étudiant
        Etudiant etudiant = etudiantDAO.trouverParId(id);
        if (etudiant == null) {
            response.sendRedirect("AdminServlet?page=etudiants&error=etudiant_inexistant");
            return;
        }
        
        // Supprimer le compte utilisateur associé
        Utilisateur utilisateur = utilisateurDAO.trouverParEmail(etudiant.getEmail());
        if (utilisateur != null) {
            utilisateurDAO.supprimer(utilisateur.getId());
        }
        
        // Supprimer l'étudiant
        etudiantDAO.supprimer(id);
        
        response.sendRedirect("AdminServlet?page=etudiants&success=supprime");
    }
    
    private void ajouterEnseignant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String specialite = request.getParameter("specialite");
        
        // Vérifier si l'enseignant existe déjà
        Enseignant existant = enseignantDAO.trouverParEmail(email);
        if (existant != null) {
            response.sendRedirect("AdminServlet?page=enseignants&error=email_existe");
            return;
        }
        
        // Créer un nouvel enseignant
        Enseignant enseignant = new Enseignant();
        enseignant.setNom(nom);
        enseignant.setPrenom(prenom);
        enseignant.setEmail(email);
        enseignant.setSpecialite(specialite);
        
        // Insérer l'enseignant
        enseignant = enseignantDAO.inserer(enseignant);
        
        // Créer un compte utilisateur pour l'enseignant
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setEmail(email);
        utilisateur.setMotDePasse("password"); // Mot de passe par défaut, à changer lors de la première connexion
        utilisateur.setRole("enseignant");
        utilisateurDAO.inserer(utilisateur);
        
        response.sendRedirect("AdminServlet?page=enseignants&success=ajoute");
    }
    
    private void modifierEnseignant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String specialite = request.getParameter("specialite");
        
        // Récupérer l'enseignant existant
        Enseignant enseignant = enseignantDAO.trouverParId(id);
        if (enseignant == null) {
            response.sendRedirect("AdminServlet?page=enseignants&error=enseignant_inexistant");
            return;
        }
        
        // Mettre à jour les informations
        enseignant.setNom(nom);
        enseignant.setPrenom(prenom);
        
        // Si l'email a changé, mettre à jour aussi le compte utilisateur
        if (!email.equals(enseignant.getEmail())) {
            Utilisateur utilisateur = utilisateurDAO.trouverParEmail(enseignant.getEmail());
            if (utilisateur != null) {
                utilisateur.setEmail(email);
                utilisateurDAO.mettre_a_jour(utilisateur);
            }
            enseignant.setEmail(email);
        }
        
        enseignant.setSpecialite(specialite);
        
        // Mettre à jour l'enseignant
        enseignantDAO.mettre_a_jour(enseignant);
        
        response.sendRedirect("AdminServlet?page=enseignants&success=modifie");
    }
    
    private void supprimerEnseignant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        
        // Récupérer l'enseignant
        Enseignant enseignant = enseignantDAO.trouverParId(id);
        if (enseignant == null) {
            response.sendRedirect("AdminServlet?page=enseignants&error=enseignant_inexistant");
            return;
        }
        
        // Supprimer le compte utilisateur associé
        Utilisateur utilisateur = utilisateurDAO.trouverParEmail(enseignant.getEmail());
        if (utilisateur != null) {
            utilisateurDAO.supprimer(utilisateur.getId());
        }
        
        // Supprimer l'enseignant
        enseignantDAO.supprimer(id);
        
        response.sendRedirect("AdminServlet?page=enseignants&success=supprime");
    }
    
    private void ajouterMatiere(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        String nom = request.getParameter("nom");
        String code = request.getParameter("code");
        int coefficient = Integer.parseInt(request.getParameter("coefficient"));
        String enseignantIdStr = request.getParameter("enseignantId");
        
        // Créer une nouvelle matière
        Matiere matiere = new Matiere();
        matiere.setNom(nom);
        matiere.setCode(code);
        matiere.setCoefficient(coefficient);
        
        // Assigner un enseignant si spécifié
        if (enseignantIdStr != null && !enseignantIdStr.isEmpty()) {
            Long enseignantId = Long.parseLong(enseignantIdStr);
            matiere.setEnseignantId(enseignantId);
        }
        
        // Insérer la matière
        matiereDAO.inserer(matiere);
        
        response.sendRedirect("AdminServlet?page=matieres&success=ajoute");
    }
    
    private void modifierMatiere(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String code = request.getParameter("code");
        int coefficient = Integer.parseInt(request.getParameter("coefficient"));
        String enseignantIdStr = request.getParameter("enseignantId");
        
        // Récupérer la matière existante
        Matiere matiere = matiereDAO.trouverParId(id);
        if (matiere == null) {
            response.sendRedirect("AdminServlet?page=matieres&error=matiere_inexistante");
            return;
        }
        
        // Mettre à jour les informations
        matiere.setNom(nom);
        matiere.setCode(code);
        matiere.setCoefficient(coefficient);
        
        // Assigner un enseignant si spécifié
        if (enseignantIdStr != null && !enseignantIdStr.isEmpty()) {
            Long enseignantId = Long.parseLong(enseignantIdStr);
            matiere.setEnseignantId(enseignantId);
        } else {
            matiere.setEnseignantId(null);
        }
        
        // Mettre à jour la matière
        matiereDAO.mettre_a_jour(matiere);
        
        response.sendRedirect("AdminServlet?page=matieres&success=modifie");
    }
    
    private void supprimerMatiere(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        
        // Supprimer la matière
        matiereDAO.supprimer(id);
        
        response.sendRedirect("AdminServlet?page=matieres&success=supprime");
    }
}