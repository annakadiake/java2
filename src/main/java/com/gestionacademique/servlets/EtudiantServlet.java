package com.gestionacademique.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.gestionacademique.dao.EtudiantDAO;
import com.gestionacademique.dao.MatiereDAO;
import com.gestionacademique.dao.NoteDAO;
import com.gestionacademique.dao.AbsenceDAO;
import com.gestionacademique.model.Etudiant;
import com.gestionacademique.model.Matiere;
import com.gestionacademique.model.Note;
import com.gestionacademique.model.Absence;

@WebServlet("/EtudiantServlet")
public class EtudiantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    private NoteDAO noteDAO = new NoteDAO();
    private AbsenceDAO absenceDAO = new AbsenceDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"etudiant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=access");
            return;
        }
        
        try {
            Long etudiantId = (Long) session.getAttribute("etudiantId");
            if (etudiantId == null) {
                String email = (String) session.getAttribute("email");
                Etudiant etudiant = etudiantDAO.trouverParEmail(email);
                if (etudiant != null) {
                    etudiantId = etudiant.getId();
                    session.setAttribute("etudiantId", etudiantId);
                } else {
                    response.sendRedirect("login.jsp?error=etudiant_introuvable");
                    return;
                }
            }
            
            // Récupération de l'étudiant
            Etudiant etudiant = etudiantDAO.trouverParId(etudiantId);
            request.setAttribute("etudiant", etudiant);
            
            // Récupération des matières
            List<Matiere> matieres = matiereDAO.trouverParEtudiant(etudiantId);
            request.setAttribute("matieres", matieres);
            
            // Récupération des notes
            List<Note> notes = noteDAO.trouverParEtudiant(etudiantId);
            request.setAttribute("notes", notes);
            
            // Calcul de la moyenne
            float moyenne = noteDAO.calculerMoyenne(etudiantId);
            request.setAttribute("moyenneGenerale", String.format("%.2f", moyenne));
            
            // Calcul de la moyenne pondérée
            float moyennePonderee = noteDAO.calculerMoyennePonderee(etudiantId);
            request.setAttribute("moyennePonderee", String.format("%.2f", moyennePonderee));
            
            // Récupération des absences
            List<Absence> absences = absenceDAO.trouverParEtudiant(etudiantId);
            request.setAttribute("absences", absences);
            
            // Compter les absences justifiées/non justifiées
            int nbAbsencesJustifiees = 0;
            for (Absence absence : absences) {
                if (absence.getJustification() != null && !absence.getJustification().isEmpty()) {
                    nbAbsencesJustifiees++;
                }
            }
            request.setAttribute("nbAbsences", absences.size());
            request.setAttribute("nbAbsencesJustifiees", nbAbsencesJustifiees);
            request.setAttribute("nbAbsencesNonJustifiees", absences.size() - nbAbsencesJustifiees);
            
            // Répartition des notes
            int nbNotesExcellentes = 0; // >= 16
            int nbNotesTresBien = 0;    // >= 14 et < 16
            int nbNotesBien = 0;        // >= 12 et < 14
            int nbNotesPassable = 0;    // >= 10 et < 12
            int nbNotesInsuffisantes = 0; // < 10
            
            int totalCoefficients = 0;
            float noteTotale = 0;
            
            for (Note note : notes) {
                Matiere matiere = matiereDAO.trouverParId(note.getMatiereId());
                int coefficient = matiere != null ? matiere.getCoefficient() : 1;
                totalCoefficients += coefficient;
                noteTotale += note.getValeur() * coefficient;
                
                if (note.getValeur() >= 16) {
                    nbNotesExcellentes++;
                } else if (note.getValeur() >= 14) {
                    nbNotesTresBien++;
                } else if (note.getValeur() >= 12) {
                    nbNotesBien++;
                } else if (note.getValeur() >= 10) {
                    nbNotesPassable++;
                } else {
                    nbNotesInsuffisantes++;
                }
            }
            
            request.setAttribute("totalCoefficients", totalCoefficients);
            request.setAttribute("noteTotale", noteTotale);
            request.setAttribute("nbNotesExcellentes", nbNotesExcellentes);
            request.setAttribute("nbNotesTresBien", nbNotesTresBien);
            request.setAttribute("nbNotesBien", nbNotesBien);
            request.setAttribute("nbNotesPassable", nbNotesPassable);
            request.setAttribute("nbNotesInsuffisantes", nbNotesInsuffisantes);
            
            // Déterminer quelle page afficher
            String page = request.getParameter("page");
            if (page == null || page.isEmpty()) {
                page = "dashboard";
            }
            
            switch (page) {
                case "notes":
                    request.getRequestDispatcher("etudiant/notes.jsp").forward(request, response);
                    break;
                case "absences":
                    request.getRequestDispatcher("etudiant/absences.jsp").forward(request, response);
                    break;
                case "matieres":
                    request.getRequestDispatcher("etudiant/matieres.jsp").forward(request, response);
                    break;
                case "bulletin":
                    request.getRequestDispatcher("etudiant/bulletin.jsp").forward(request, response);
                    break;
                case "dashboard":
                default:
                    // Nombre de matières pour le tableau de bord
                    request.setAttribute("nbMatieres", matieres.size());
                    request.getRequestDispatcher("etudiant/dashboard.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"etudiant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=access");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            Long etudiantId = (Long) session.getAttribute("etudiantId");
            
            switch (action) {
                case "inscrireMatiere":
                    Long matiereId = Long.parseLong(request.getParameter("matiereId"));
                    etudiantDAO.inscrireMatiere(etudiantId, matiereId);
                    response.sendRedirect("EtudiantServlet?page=matieres&success=inscrit");
                    break;
                case "desincrireMatiere":
                    matiereId = Long.parseLong(request.getParameter("matiereId"));
                    // Méthode pour désinscrire l'étudiant d'une matière (à implémenter dans EtudiantDAO)
                    // etudiantDAO.desincrireMatiere(etudiantId, matiereId);
                    response.sendRedirect("EtudiantServlet?page=matieres&success=desinscrit");
                    break;
                case "justifierAbsence":
                    Long absenceId = Long.parseLong(request.getParameter("absenceId"));
                    String justification = request.getParameter("justification");
                    
                    // Récupérer l'absence
                    Absence absence = absenceDAO.trouverParId(absenceId);
                    
                    // Vérifier que l'absence appartient bien à cet étudiant
                    if (absence != null && absence.getEtudiantId().equals(etudiantId)) {
                        absence.setJustification(justification);
                        absenceDAO.mettre_a_jour(absence);
                        response.sendRedirect("EtudiantServlet?page=absences&success=justifiee");
                    } else {
                        response.sendRedirect("EtudiantServlet?page=absences&error=acces_refuse");
                    }
                    break;
                default:
                    response.sendRedirect("EtudiantServlet");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }
}