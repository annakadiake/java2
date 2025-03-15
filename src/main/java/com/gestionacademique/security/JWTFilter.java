// src/main/java/com/gestionacademique/security/JWTFilter.java
package com.gestionacademique.security;

import java.io.IOException;
import java.lang.reflect.Method;
import jakarta.annotation.Priority;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.container.ResourceInfo;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.HttpHeaders;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;

@Provider
@Secured
@Priority(Priorities.AUTHENTICATION)
public class JWTFilter implements ContainerRequestFilter {
    
    private static final String BEARER_PREFIX = "Bearer ";
    
    @Context
    private ResourceInfo resourceInfo;
    
    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
        String authHeader = requestContext.getHeaderString(HttpHeaders.AUTHORIZATION);
        
        // Vérifier si le header d'autorisation existe et commence par "Bearer "
        if (authHeader == null || !authHeader.startsWith(BEARER_PREFIX)) {
            abortWithUnauthorized(requestContext, "Authentification requise");
            return;
        }
        
        // Extraire le token (supprimer "Bearer ")
        String token = authHeader.substring(BEARER_PREFIX.length());
        
        try {
            // Valider le token
            if (!JWTUtil.isTokenValid(token)) {
                abortWithUnauthorized(requestContext, "Token invalide");
                return;
            }
            
            // Extraire les informations du token pour les utiliser dans les ressources
            String role = JWTUtil.getRoleFromToken(token);
            String email = JWTUtil.getEmailFromToken(token);
            
            // Vérification du rôle si nécessaire
            Method resourceMethod = resourceInfo.getResourceMethod();
            if (resourceMethod != null) {
                Secured secured = resourceMethod.getAnnotation(Secured.class);
                if (secured != null && secured.value().length > 0) {
                    boolean authorized = false;
                    for (String allowedRole : secured.value()) {
                        if (allowedRole.equals(role)) {
                            authorized = true;
                            break;
                        }
                    }
                    
                    if (!authorized) {
                        abortWithForbidden(requestContext, "Rôle insuffisant");
                        return;
                    }
                }
            }
            
            // Stocker les informations de l'utilisateur pour une utilisation dans les ressources
            requestContext.setProperty("email", email);
            requestContext.setProperty("role", role);
            
        } catch (Exception e) {
            abortWithUnauthorized(requestContext, "Token invalide: " + e.getMessage());
        }
    }
    
    private void abortWithUnauthorized(ContainerRequestContext requestContext, String message) {
        requestContext.abortWith(
            Response.status(Response.Status.UNAUTHORIZED)
                   .entity(message)
                   .build());
    }
    
    private void abortWithForbidden(ContainerRequestContext requestContext, String message) {
        requestContext.abortWith(
            Response.status(Response.Status.FORBIDDEN)
                   .entity(message)
                   .build());
    }
}