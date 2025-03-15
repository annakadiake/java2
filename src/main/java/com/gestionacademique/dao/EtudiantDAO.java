package com.gestionacademique.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.gestionacademique.model.Etudiant;
import com.gestionacademique.utils.DatabaseConnection;

public class EtudiantDAO {
    
    // Insérer un nouvel étudiant
    public Etudiant inserer(Etudiant etudiant) throws SQLException {
        String sql = "INSERT INTO etudiants (matricule, nom, prenom, email, date_naissance, filiere, niveau) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, etudiant.getMatricule());
            pstmt.setString(2, etudiant.getNom());
            pstmt.setString(3, etudiant.getPrenom());
            pstmt.setString(4, etudiant.getEmail());
            pstmt.setDate(5, new java.sql.Date(etudiant.getDateNaissance().getTime()));
            pstmt.setString(6, etudiant.getFiliere());
            pstmt.setString(7, etudiant.getNiveau());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    etudiant.setId(rs.getLong(1));
                }
                rs.close();
            }
        }
        
        return etudiant;
    }
    
    // Mettre à jour un étudiant
    public void mettre_a_jour(Etudiant etudiant) throws SQLException {
        String sql = "UPDATE etudiants SET matricule = ?, nom = ?, prenom = ?, email = ?, date_naissance = ?, filiere = ?, niveau = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, etudiant.getMatricule());
            pstmt.setString(2, etudiant.getNom());
            pstmt.setString(3, etudiant.getPrenom());
            pstmt.setString(4, etudiant.getEmail());
            pstmt.setDate(5, new java.sql.Date(etudiant.getDateNaissance().getTime()));
            pstmt.setString(6, etudiant.getFiliere());
            pstmt.setString(7, etudiant.getNiveau());
            pstmt.setLong(8, etudiant.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    // Supprimer un étudiant
    public void supprimer(Long id) throws SQLException {
        String sql = "DELETE FROM etudiants WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // Trouver un étudiant par ID
    public Etudiant trouverParId(Long id) throws SQLException {
        String sql = "SELECT * FROM etudiants WHERE id = ?";
        Etudiant etudiant = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                etudiant = extractEtudiantFromResultSet(rs);
            }
        }
        
        return etudiant;
    }
    
    // Trouver un étudiant par email
    public Etudiant trouverParEmail(String email) throws SQLException {
        String sql = "SELECT * FROM etudiants WHERE email = ?";
        Etudiant etudiant = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                etudiant = extractEtudiantFromResultSet(rs);
            }
        }
        
        return etudiant;
    }
    
    // Trouver tous les étudiants
    public List<Etudiant> trouverTous() throws SQLException {
        String sql = "SELECT * FROM etudiants";
        List<Etudiant> etudiants = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                etudiants.add(extractEtudiantFromResultSet(rs));
            }
        }
        
        return etudiants;
    }
    
    // Inscrire un étudiant à une matière
    public void inscrireMatiere(Long etudiantId, Long matiereId) throws SQLException {
        String sql = "INSERT INTO etudiant_matiere (etudiant_id, matiere_id) VALUES (?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            pstmt.setLong(2, matiereId);
            pstmt.executeUpdate();
        }
    }
    
    // Méthode utilitaire pour extraire un étudiant d'un ResultSet
    private Etudiant extractEtudiantFromResultSet(ResultSet rs) throws SQLException {
        Etudiant etudiant = new Etudiant();
        etudiant.setId(rs.getLong("id"));
        etudiant.setMatricule(rs.getString("matricule"));
        etudiant.setNom(rs.getString("nom"));
        etudiant.setPrenom(rs.getString("prenom"));
        etudiant.setEmail(rs.getString("email"));
        etudiant.setDateNaissance(rs.getDate("date_naissance"));
        etudiant.setFiliere(rs.getString("filiere"));
        etudiant.setNiveau(rs.getString("niveau"));
        return etudiant;
    }
}