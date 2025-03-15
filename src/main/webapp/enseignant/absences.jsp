<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion des Absences" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-calendar-times me-2"></i>Gestion des Absences
                </h3>
                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#ajouterAbsenceModal">
                    <i class="fas fa-plus-circle me-1"></i>Signaler une absence
                </button>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header bg-light">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-filter me-2"></i>Filtrer
                        </h5>
                    </div>
                    <div class="col-md-4">
                        <select id="matiereFilter" class="form-select">
                            <option value="">Toutes les matières</option>
                            <c:forEach var="matiere" items="${matieres}">
                            <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <input type="text" id="searchEtudiant" class="form-control" placeholder="Rechercher un étudiant...">
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="tableAbsences">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Matricule</th>
                                <th>Étudiant</th>
                                <th>Matière</th>
                                <th>Justification</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="absence" items="${absences}">
                                <tr data-matiere="${absence.matiere.id}">
                                    <td><fmt:formatDate value="${absence.dateAbsence}" pattern="dd/MM/yyyy" /></td>
                                    <td>${absence.etudiant.matricule}</td>
                                    <td>${absence.etudiant.prenom} ${absence.etudiant.nom}</td>
                                    <td>${absence.matiere.nom} (${absence.matiere.code})</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty absence.justification}">
                                                <span class="text-success">
                                                    <i class="fas fa-check-circle me-1"></i>Justifiée
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger">
                                                    <i class="fas fa-times-circle me-1"></i>Non justifiée
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-warning" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modifierAbsenceModal" 
                                                    data-id="${absence.id}"
                                                    data-etudiant="${absence.etudiant.id}"
                                                    data-matiere="${absence.matiere.id}"
                                                    data-date="${absence.dateAbsence}"
                                                    data-justification="${absence.justification}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#supprimerAbsenceModal" 
                                                    data-id="${absence.id}"
                                                    data-etudiant="${absence.etudiant.prenom} ${absence.etudiant.nom}"
                                                    data-matiere="${absence.matiere.nom}"
                                                    data-date="<fmt:formatDate value='${absence.dateAbsence}' pattern='dd/MM/yyyy' />">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chart-pie me-2"></i>Répartition des absences
                </h5>
            </div>
            <div class="card-body">
                <canvas id="absencesPieChart" width="100%" height="250"></canvas>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-check-circle me-2"></i>Import par lot
                </h5>
            </div>
            <div class="card-body">
                <p>Importez plusieurs absences à la fois à partir d'un fichier CSV ou Excel.</p>
                <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="importerAbsences">
                    <div class="mb-3">
                        <label for="matiereImport" class="form-label">Matière</label>
                        <select id="matiereImport" name="matiereId" class="form-select" required>
                            <option value="">Sélectionner une matière...</option>
                            <c:forEach var="matiere" items="${matieres}">
                                <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="dateAbsence" class="form-label">Date d'absence</label>
                        <input type="date" class="form-control" id="dateAbsence" name="dateAbsence" required>
                        <div class="form-text">Cette date sera appliquée à toutes les absences importées</div>
                    </div>
                    <div class="mb-3">
                        <label for="fichierAbsences" class="form-label">Fichier d'absences (CSV, XLS, XLSX)</label>
                        <input type="file" class="form-control" id="fichierAbsences" name="fichierAbsences" accept=".csv,.xls,.xlsx" required>
                        <div class="form-text">Le fichier doit contenir les colonnes : Matricule, Nom, Prénom</div>
                    </div>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-file-upload me-1"></i>Importer les absences
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ajouter Absence -->
<div class="modal fade" id="ajouterAbsenceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle me-2"></i>Signaler une absence
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="ajouterAbsence">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="etudiantId" class="form-label">Étudiant</label>
                        <select id="etudiantId" name="etudiantId" class="form-select" required>
                            <option value="">Sélectionner un étudiant...</option>
                            <c:forEach var="etudiant" items="${etudiants}">
                                <option value="${etudiant.id}">${etudiant.prenom} ${etudiant.nom} (${etudiant.matricule})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="matiereId" class="form-label">Matière</label>
                        <select id="matiereId" name="matiereId" class="form-select" required>
                            <option value="">Sélectionner une matière...</option>
                            <c:forEach var="matiere" items="${matieres}">
                                <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="dateAbsenceAjout" class="form-label">Date d'absence</label>
                        <input type="date" class="form-control" id="dateAbsenceAjout" name="dateAbsence" required>
                    </div>
                    <div class="mb-3">
                        <label for="justification" class="form-label">Justification (optionnel)</label>
                        <textarea class="form-control" id="justification" name="justification" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Signaler l'absence</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Modifier Absence -->
<div class="modal fade" id="modifierAbsenceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Modifier une absence
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="modifierAbsence">
                <input type="hidden" name="absenceId" id="modifierAbsenceId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="modifierEtudiantId" class="form-label">Étudiant</label>
                        <select id="modifierEtudiantId" name="etudiantId" class="form-select" required disabled>
                            <c:forEach var="etudiant" items="${etudiants}">
                                <option value="${etudiant.id}">${etudiant.prenom} ${etudiant.nom} (${etudiant.matricule})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="modifierMatiereId" class="form-label">Matière</label>
                        <select id="modifierMatiereId" name="matiereId" class="form-select" required disabled>
                            <c:forEach var="matiere" items="${matieres}">
                                <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="modifierDateAbsence" class="form-label">Date d'absence</label>
                        <input type="date" class="form-control" id="modifierDateAbsence" name="dateAbsence" required>
                    </div>
                    <div class="mb-3">
                        <label for="modifierJustification" class="form-label">Justification (optionnel)</label>
                        <textarea class="form-control" id="modifierJustification" name="justification" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-warning">Enregistrer les modifications</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Supprimer Absence -->
<div class="modal fade" id="supprimerAbsenceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-trash-alt me-2"></i>Supprimer une absence
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer cette absence ?</p>
                <p>Cette action est irréversible.</p>
                <p><strong>Étudiant:</strong> <span id="supprimerAbsenceEtudiant"></span></p>
                <p><strong>Matière:</strong> <span id="supprimerAbsenceMatiere"></span></p>
                <p><strong>Date:</strong> <span id="supprimerAbsenceDate"></span></p>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="supprimerAbsence">
                <input type="hidden" name="absenceId" id="supprimerAbsenceId">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Confirmer la suppression</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Filtrer par matière
    document.getElementById('matiereFilter').addEventListener('change', function() {
        var matiereId = this.value;
        var table = document.getElementById('tableAbsences');
        var rows = table.getElementsByTagName('tr');
        
        for (var i = 1; i < rows.length; i++) {
            if (matiereId === '' || rows[i].getAttribute('data-matiere') === matiereId) {
                rows[i].style.display = '';
            } else {
                rows[i].style.display = 'none';
            }
        }
    });
    
    // Rechercher un étudiant
    document.getElementById('searchEtudiant').addEventListener('keyup', function() {
        var input = this.value.toLowerCase();
        var table = document.getElementById('tableAbsences');
        var rows = table.getElementsByTagName('tr');
        
        for (var i = 1; i < rows.length; i++) {
            var etudiantCell = rows[i].cells[2];
            if (etudiantCell) {
                var etudiantText = etudiantCell.textContent.toLowerCase();
                
                if (etudiantText.indexOf(input) > -1) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        }
    });
    
    // Graphique en camembert pour la répartition des absences
    var ctx = document.getElementById('absencesPieChart').getContext('2d');
    var absencesPieChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: ['Justifiées', 'Non justifiées'],
            datasets: [{
                data: [${nbAbsencesJustifiees}, ${nbAbsencesNonJustifiees}],
                backgroundColor: [
                    'rgba(40, 167, 69, 0.7)',
                    'rgba(220, 53, 69, 0.7)'
                ],
                borderColor: [
                    'rgba(40, 167, 69, 1)',
                    'rgba(220, 53, 69, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'right'
                }
            }
        }
    });
    
    // Modifier une absence
    $('#modifierAbsenceModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        var etudiantId = button.data('etudiant');
        var matiereId = button.data('matiere');
        var date = button.data('date');
        var justification = button.data('justification');
        
        $('#modifierAbsenceId').val(id);
        $('#modifierEtudiantId').val(etudiantId);
        $('#modifierMatiereId').val(matiereId);
        $('#modifierDateAbsence').val(formatDate(date));
        $('#modifierJustification').val(justification ? justification : '');
    });
    
    // Supprimer une absence
    $('#supprimerAbsenceModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        var etudiant = button.data('etudiant');
        var matiere = button.data('matiere');
        var date = button.data('date');
        
        $('#supprimerAbsenceId').val(id);
        $('#supprimerAbsenceEtudiant').text(etudiant);
        $('#supprimerAbsenceMatiere').text(matiere);
        $('#supprimerAbsenceDate').text(date);
    });
    
    // Formater la date pour l'entrée date HTML
    function formatDate(date) {
        if (typeof date === 'string') {
            return date;
        }
        
        var d = new Date(date);
        var month = '' + (d.getMonth() + 1);
        var day = '' + d.getDate();
        var year = d.getFullYear();
        
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
        
        return [year, month, day].join('-');
    }
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
                            