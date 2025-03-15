package com.gestionacademique.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.gestionacademique.model.Utilisateur;
import com.gestionacademique.utils.DatabaseConnection;

public class UtilisateurDAO {
    
    // Insérer un nouvel utilisateur
    public Utilisateur inserer(Utilisateur utilisateur) throws SQLException {
        String sql = "INSERT INTO utilisateurs (email, mot_de_passe, role) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, utilisateur.getEmail());
            pstmt.setString(2, utilisateur.getMotDePasse());
            pstmt.setString(3, utilisateur.getRole());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    utilisateur.setId(rs.getLong(1));
                }
                rs.close();
            }
        }
        
        return utilisateur;
    }
    
    // Mettre à jour un utilisateur
    public void mettre_a_jour(Utilisateur utilisateur) throws SQLException {
        String sql = "UPDATE utilisateurs SET email = ?, mot_de_passe = ?, role = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, utilisateur.getEmail());
            pstmt.setString(2, utilisateur.getMotDePasse());
            pstmt.setString(3, utilisateur.getRole());
            pstmt.setLong(4, utilisateur.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    // Supprimer un utilisateur
    public void supprimer(Long id) throws SQLException {
        String sql = "DELETE FROM utilisateurs WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // Trouver un utilisateur par ID
    public Utilisateur trouverParId(Long id) throws SQLException {
        String sql = "SELECT * FROM utilisateurs WHERE id = ?";
        Utilisateur utilisateur = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                utilisateur = extractUtilisateurFromResultSet(rs);
            }
        }
        
        return utilisateur;
    }
    
    // Trouver un utilisateur par email
    public Utilisateur trouverParEmail(String email) throws SQLException {
        String sql = "SELECT * FROM utilisateurs WHERE email = ?";
        Utilisateur utilisateur = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                utilisateur = extractUtilisateurFromResultSet(rs);
            }
        }
        
        return utilisateur;
    }
    
    // Authentifier un utilisateur
    public Utilisateur authentifier(String email, String motDePasse) throws SQLException {
        String sql = "SELECT * FROM utilisateurs WHERE email = ? AND mot_de_passe = ?";
        Utilisateur utilisateur = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, motDePasse);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                utilisateur = extractUtilisateurFromResultSet(rs);
            }
        }
        
        return utilisateur;
    }
    
    // Trouver tous les utilisateurs
    public List<Utilisateur> trouverTous() throws SQLException {
        String sql = "SELECT * FROM utilisateurs";
        List<Utilisateur> utilisateurs = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                utilisateurs.add(extractUtilisateurFromResultSet(rs));
            }
        }
        
        return utilisateurs;
    }
    
    // Méthode utilitaire pour extraire un utilisateur d'un ResultSet
    private Utilisateur extractUtilisateurFromResultSet(ResultSet rs) throws SQLException {
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setId(rs.getLong("id"));
        utilisateur.setEmail(rs.getString("email"));
        utilisateur.setMotDePasse(rs.getString("mot_de_passe"));
        utilisateur.setRole(rs.getString("role"));
        return utilisateur;
    }
}