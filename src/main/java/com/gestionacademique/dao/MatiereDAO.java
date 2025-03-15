package com.gestionacademique.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.gestionacademique.model.Matiere;
import com.gestionacademique.utils.DatabaseConnection;

public class MatiereDAO {
    
    // Insérer une nouvelle matière
    public Matiere inserer(Matiere matiere) throws SQLException {
        String sql = "INSERT INTO matieres (nom, code, coefficient, enseignant_id) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, matiere.getNom());
            pstmt.setString(2, matiere.getCode());
            pstmt.setInt(3, matiere.getCoefficient());
            if (matiere.getEnseignantId() != null) {
                pstmt.setLong(4, matiere.getEnseignantId());
            } else {
                pstmt.setNull(4, java.sql.Types.BIGINT);
            }
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    matiere.setId(rs.getLong(1));
                }
                rs.close();
            }
        }
        
        return matiere;
    }
    
    // Mettre à jour une matière
    public void mettre_a_jour(Matiere matiere) throws SQLException {
        String sql = "UPDATE matieres SET nom = ?, code = ?, coefficient = ?, enseignant_id = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, matiere.getNom());
            pstmt.setString(2, matiere.getCode());
            pstmt.setInt(3, matiere.getCoefficient());
            if (matiere.getEnseignantId() != null) {
                pstmt.setLong(4, matiere.getEnseignantId());
            } else {
                pstmt.setNull(4, java.sql.Types.BIGINT);
            }
            pstmt.setLong(5, matiere.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    // Supprimer une matière
    public void supprimer(Long id) throws SQLException {
        String sql = "DELETE FROM matieres WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // Trouver une matière par ID
    public Matiere trouverParId(Long id) throws SQLException {
        String sql = "SELECT * FROM matieres WHERE id = ?";
        Matiere matiere = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                matiere = extractMatiereFromResultSet(rs);
            }
        }
        
        return matiere;
    }
    
    // Trouver tous les matières
    public List<Matiere> trouverTous() throws SQLException {
        String sql = "SELECT * FROM matieres";
        List<Matiere> matieres = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                matieres.add(extractMatiereFromResultSet(rs));
            }
        }
        
        return matieres;
    }
    
    // Trouver les matières par enseignant
    public List<Matiere> trouverParEnseignant(Long enseignantId) throws SQLException {
        String sql = "SELECT * FROM matieres WHERE enseignant_id = ?";
        List<Matiere> matieres = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, enseignantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                matieres.add(extractMatiereFromResultSet(rs));
            }
        }
        
        return matieres;
    }
    
    // Trouver les matières par étudiant
    public List<Matiere> trouverParEtudiant(Long etudiantId) throws SQLException {
        String sql = "SELECT m.* FROM matieres m " +
                     "JOIN etudiant_matiere em ON m.id = em.matiere_id " +
                     "WHERE em.etudiant_id = ?";
        List<Matiere> matieres = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                matieres.add(extractMatiereFromResultSet(rs));
            }
        }
        
        return matieres;
    }
    
    // Méthode utilitaire pour extraire une matière d'un ResultSet
    private Matiere extractMatiereFromResultSet(ResultSet rs) throws SQLException {
        Matiere matiere = new Matiere();
        matiere.setId(rs.getLong("id"));
        matiere.setNom(rs.getString("nom"));
        matiere.setCode(rs.getString("code"));
        matiere.setCoefficient(rs.getInt("coefficient"));
        
        Long enseignantId = rs.getLong("enseignant_id");
        if (!rs.wasNull()) {
            matiere.setEnseignantId(enseignantId);
        }
        
        return matiere;
    }
}