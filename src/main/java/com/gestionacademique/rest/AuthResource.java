// src/main/java/com/gestionacademique/rest/AuthResource.java
package com.gestionacademique.rest;

import java.sql.SQLException;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import com.gestionacademique.dao.UtilisateurDAO;
import com.gestionacademique.model.Utilisateur;
import com.gestionacademique.security.JWTUtil;

@Path("/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthResource {
    
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    
    @POST
    @Path("/login")
    public Response login(@FormParam("email") String email, @FormParam("password") String password) {
        try {
            Utilisateur utilisateur = utilisateurDAO.authentifier(email, password);
            
            if (utilisateur != null) {
                // Générer un JWT token
                String token = JWTUtil.generateToken(utilisateur);
                
                // Renvoyer le token dans la réponse
                return Response.ok()
                              .entity("{\"token\": \"" + token + "\", \"role\": \"" + utilisateur.getRole() + "\"}")
                              .build();
            } else {
                return Response.status(Response.Status.UNAUTHORIZED)
                              .entity("Identifiants invalides")
                              .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de l'authentification: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    @Path("/register")
    public Response register(Utilisateur utilisateur) {
        try {
            // Vérifier si l'email existe déjà
            Utilisateur existingUser = utilisateurDAO.trouverParEmail(utilisateur.getEmail());
            if (existingUser != null) {
                return Response.status(Response.Status.CONFLICT)
                              .entity("Un utilisateur avec cet email existe déjà")
                              .build();
            }
            
            // Créer le nouvel utilisateur
            Utilisateur newUser = utilisateurDAO.inserer(utilisateur);
            return Response.status(Response.Status.CREATED)
                          .entity(newUser)
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de l'enregistrement: " + e.getMessage())
                          .build();
        }
    }
}