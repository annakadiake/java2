package com.gestionacademique.rest;

import java.sql.SQLException;
import java.util.List;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import com.gestionacademique.dao.AbsenceDAO;
import com.gestionacademique.model.Absence;

@Path("/absences")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AbsenceResource {
    
    private AbsenceDAO absenceDAO = new AbsenceDAO();
    
    @GET
    @Path("/etudiant/{etudiantId}")
    public Response getAbsencesByEtudiant(@PathParam("etudiantId") Long etudiantId) {
        try {
            List<Absence> absences = absenceDAO.trouverParEtudiant(etudiantId);
            return Response.ok(absences).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des absences par étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/matiere/{matiereId}")
    public Response getAbsencesByMatiere(@PathParam("matiereId") Long matiereId) {
        try {
            List<Absence> absences = absenceDAO.trouverParMatiere(matiereId);
            return Response.ok(absences).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des absences par matière: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/{id}")
    public Response getAbsenceById(@PathParam("id") Long id) {
        try {
            Absence absence = absenceDAO.trouverParId(id);
            if (absence != null) {
                return Response.ok(absence).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Absence non trouvée avec l'ID: " + id)
                              .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération de l'absence: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    public Response createAbsence(Absence absence) {
        try {
            Absence newAbsence = absenceDAO.inserer(absence);
            return Response.status(Response.Status.CREATED)
                          .entity(newAbsence)
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la création de l'absence: " + e.getMessage())
                          .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response updateAbsence(@PathParam("id") Long id, Absence absence) {
        try {
            Absence existingAbsence = absenceDAO.trouverParId(id);
            if (existingAbsence == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Absence non trouvée avec l'ID: " + id)
                              .build();
            }
            
            absence.setId(id);
            absenceDAO.mettre_a_jour(absence);
            return Response.ok(absence).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la mise à jour de l'absence: " + e.getMessage())
                          .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteAbsence(@PathParam("id") Long id) {
        try {
            Absence absence = absenceDAO.trouverParId(id);
            if (absence == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Absence non trouvée avec l'ID: " + id)
                              .build();
            }
            
            absenceDAO.supprimer(id);
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la suppression de l'absence: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/count/etudiant/{etudiantId}")
    public Response countAbsencesByEtudiant(@PathParam("etudiantId") Long etudiantId) {
        try {
            int count = absenceDAO.compterAbsencesParEtudiant(etudiantId);
            return Response.ok("{\"count\": " + count + "}").build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors du comptage des absences: " + e.getMessage())
                          .build();
        }
    }
}