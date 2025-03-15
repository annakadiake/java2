package com.gestionacademique.rest;

import java.sql.SQLException;
import java.util.List;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import com.gestionacademique.dao.EnseignantDAO;
import com.gestionacademique.model.Enseignant;

@Path("/enseignants")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EnseignantResource {
    
    private EnseignantDAO enseignantDAO = new EnseignantDAO();
    
    @GET
    public Response getAllEnseignants() {
        try {
            List<Enseignant> enseignants = enseignantDAO.trouverTous();
            return Response.ok(enseignants).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des enseignants: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/{id}")
    public Response getEnseignantById(@PathParam("id") Long id) {
        try {
            Enseignant enseignant = enseignantDAO.trouverParId(id);
            if (enseignant != null) {
                return Response.ok(enseignant).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Enseignant non trouvé avec l'ID: " + id)
                              .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération de l'enseignant: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    public Response createEnseignant(Enseignant enseignant) {
        try {
            Enseignant newEnseignant = enseignantDAO.inserer(enseignant);
            return Response.status(Response.Status.CREATED)
                          .entity(newEnseignant)
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la création de l'enseignant: " + e.getMessage())
                          .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response updateEnseignant(@PathParam("id") Long id, Enseignant enseignant) {
        try {
            Enseignant existingEnseignant = enseignantDAO.trouverParId(id);
            if (existingEnseignant == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Enseignant non trouvé avec l'ID: " + id)
                              .build();
            }
            
            enseignant.setId(id);
            enseignantDAO.mettre_a_jour(enseignant);
            return Response.ok(enseignant).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la mise à jour de l'enseignant: " + e.getMessage())
                          .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteEnseignant(@PathParam("id") Long id) {
        try {
            Enseignant enseignant = enseignantDAO.trouverParId(id);
            if (enseignant == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Enseignant non trouvé avec l'ID: " + id)
                              .build();
            }
            
            enseignantDAO.supprimer(id);
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la suppression de l'enseignant: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    @Path("/{enseignantId}/attribuer-matiere/{matiereId}")
    public Response attribuerMatiereEnseignant(@PathParam("enseignantId") Long enseignantId, 
                                              @PathParam("matiereId") Long matiereId) {
        try {
            enseignantDAO.attribuerMatiere(enseignantId, matiereId);
            return Response.status(Response.Status.OK)
                          .entity("Matière attribuée avec succès à l'enseignant")
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de l'attribution de la matière à l'enseignant: " + e.getMessage())
                          .build();
        }
    }
}