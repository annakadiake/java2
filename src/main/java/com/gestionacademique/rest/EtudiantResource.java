package com.gestionacademique.rest;

import java.sql.SQLException;
import java.util.List;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import com.gestionacademique.dao.EtudiantDAO;
import com.gestionacademique.model.Etudiant;

@Path("/etudiants")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EtudiantResource {
    
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    
    @GET
    public Response getAllEtudiants() {
        try {
            List<Etudiant> etudiants = etudiantDAO.trouverTous();
            return Response.ok(etudiants).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des étudiants: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/{id}")
    public Response getEtudiantById(@PathParam("id") Long id) {
        try {
            Etudiant etudiant = etudiantDAO.trouverParId(id);
            if (etudiant != null) {
                return Response.ok(etudiant).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Étudiant non trouvé avec l'ID: " + id)
                              .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération de l'étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    public Response createEtudiant(Etudiant etudiant) {
        try {
            Etudiant newEtudiant = etudiantDAO.inserer(etudiant);
            return Response.status(Response.Status.CREATED)
                          .entity(newEtudiant)
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la création de l'étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response updateEtudiant(@PathParam("id") Long id, Etudiant etudiant) {
        try {
            Etudiant existingEtudiant = etudiantDAO.trouverParId(id);
            if (existingEtudiant == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Étudiant non trouvé avec l'ID: " + id)
                              .build();
            }
            
            etudiant.setId(id);
            etudiantDAO.mettre_a_jour(etudiant);
            return Response.ok(etudiant).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la mise à jour de l'étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteEtudiant(@PathParam("id") Long id) {
        try {
            Etudiant etudiant = etudiantDAO.trouverParId(id);
            if (etudiant == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Étudiant non trouvé avec l'ID: " + id)
                              .build();
            }
            
            etudiantDAO.supprimer(id);
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la suppression de l'étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    @Path("/{etudiantId}/inscrire-matiere/{matiereId}")
    public Response inscrireEtudiantMatiere(@PathParam("etudiantId") Long etudiantId, 
                                           @PathParam("matiereId") Long matiereId) {
        try {
            etudiantDAO.inscrireMatiere(etudiantId, matiereId);
            return Response.status(Response.Status.OK)
                          .entity("Étudiant inscrit avec succès à la matière")
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de l'inscription de l'étudiant à la matière: " + e.getMessage())
                          .build();
        }
    }
}
