package com.gestionacademique.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.gestionacademique.model.Enseignant;
import com.gestionacademique.utils.DatabaseConnection;

public class EnseignantDAO {
    
    // Insérer un nouvel enseignant
    public Enseignant inserer(Enseignant enseignant) throws SQLException {
        String sql = "INSERT INTO enseignants (nom, prenom, email, specialite) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, enseignant.getNom());
            pstmt.setString(2, enseignant.getPrenom());
            pstmt.setString(3, enseignant.getEmail());
            pstmt.setString(4, enseignant.getSpecialite());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    enseignant.setId(rs.getLong(1));
                }
                rs.close();
            }
        }
        
        return enseignant;
    }
    
    // Mettre à jour un enseignant
    public void mettre_a_jour(Enseignant enseignant) throws SQLException {
        String sql = "UPDATE enseignants SET nom = ?, prenom = ?, email = ?, specialite = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, enseignant.getNom());
            pstmt.setString(2, enseignant.getPrenom());
            pstmt.setString(3, enseignant.getEmail());
            pstmt.setString(4, enseignant.getSpecialite());
            pstmt.setLong(5, enseignant.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    // Supprimer un enseignant
    public void supprimer(Long id) throws SQLException {
        String sql = "DELETE FROM enseignants WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // Trouver un enseignant par ID
    public Enseignant trouverParId(Long id) throws SQLException {
        String sql = "SELECT * FROM enseignants WHERE id = ?";
        Enseignant enseignant = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                enseignant = extractEnseignantFromResultSet(rs);
            }
        }
        
        return enseignant;
    }
    
    // Trouver un enseignant par email
    public Enseignant trouverParEmail(String email) throws SQLException {
        String sql = "SELECT * FROM enseignants WHERE email = ?";
        Enseignant enseignant = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                enseignant = extractEnseignantFromResultSet(rs);
            }
        }
        
        return enseignant;
    }
    
    // Trouver tous les enseignants
    public List<Enseignant> trouverTous() throws SQLException {
        String sql = "SELECT * FROM enseignants";
        List<Enseignant> enseignants = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                enseignants.add(extractEnseignantFromResultSet(rs));
            }
        }
        
        return enseignants;
    }
    
    // Attribuer une matière à un enseignant
    public void attribuerMatiere(Long enseignantId, Long matiereId) throws SQLException {
        String sql = "UPDATE matieres SET enseignant_id = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, enseignantId);
            pstmt.setLong(2, matiereId);
            pstmt.executeUpdate();
        }
    }
    
    // Méthode utilitaire pour extraire un enseignant d'un ResultSet
    private Enseignant extractEnseignantFromResultSet(ResultSet rs) throws SQLException {
        Enseignant enseignant = new Enseignant();
        enseignant.setId(rs.getLong("id"));
        enseignant.setNom(rs.getString("nom"));
        enseignant.setPrenom(rs.getString("prenom"));
        enseignant.setEmail(rs.getString("email"));
        enseignant.setSpecialite(rs.getString("specialite"));
        return enseignant;
    }
}