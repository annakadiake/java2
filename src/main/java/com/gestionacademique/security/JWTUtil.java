// src/main/java/com/gestionacademique/security/JWTUtil.java
package com.gestionacademique.security;

import java.util.Date;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import com.gestionacademique.model.Utilisateur;
import javax.crypto.SecretKey;

public class JWTUtil {
    // Clé secrète pour signer les tokens (à remplacer par une clé sécurisée en production)
    private static final SecretKey SECRET_KEY = Keys.hmacShaKeyFor(
        "votreCleSecretePourGestionAcademiqueDoit256bitsMinimum".getBytes()
    );
    
    // Durée de validité du token en millisecondes (24 heures)
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000;
    
    // Générer un token JWT pour un utilisateur
    public static String generateToken(Utilisateur utilisateur) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION_TIME);
        
        return Jwts.builder()
                .setSubject(utilisateur.getEmail())
                .claim("id", utilisateur.getId())
                .claim("role", utilisateur.getRole())
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SECRET_KEY)
                .compact();
    }
    
    // Vérifier et extraire les informations d'un token JWT
    public static Claims validateToken(String token) {
        try {
            JwtParser parser = Jwts.parserBuilder()
                                 .setSigningKey(SECRET_KEY)
                                 .build();
            
            Jws<Claims> claimsJws = parser.parseClaimsJws(token);
            return claimsJws.getBody();
        } catch (JwtException e) {
            throw new IllegalArgumentException("Token invalide ou expiré", e);
        }
    }
    
    // Extraire l'email d'un token JWT
    public static String getEmailFromToken(String token) {
        Claims claims = validateToken(token);
        return claims.getSubject();
    }
    
    // Extraire le rôle d'un token JWT
    public static String getRoleFromToken(String token) {
        Claims claims = validateToken(token);
        return claims.get("role", String.class);
    }
    
    // Vérifier si un token JWT est valide
    public static boolean isTokenValid(String token) {
        try {
            validateToken(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}