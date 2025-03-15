<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion des Notes" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-clipboard-list me-2"></i>Gestion des Notes
                </h3>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#ajouterNoteModal">
                    <i class="fas fa-plus-circle me-1"></i>Ajouter une note
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
                            <i class="fas fa-filter me-2"></i>Filtrer par matière
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
                    <table class="table table-striped table-hover" id="tableNotes">
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Étudiant</th>
                                <th>Matière</th>
                                <th>Note/20</th>
                                <th>Date de saisie</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="note" items="${notes}">
                                <tr data-matiere="${note.matiere.id}">
                                    <td>${note.etudiant.matricule}</td>
                                    <td>${note.etudiant.prenom} ${note.etudiant.nom}</td>
                                    <td>${note.matiere.nom} (${note.matiere.code})</td>
                                    <td>
                                        <span class="
                                            <c:choose>
                                                <c:when test="${note.valeur >= 16}">text-success</c:when>
                                                <c:when test="${note.valeur >= 12}">text-info</c:when>
                                                <c:when test="${note.valeur >= 10}">text-warning</c:when>
                                                <c:otherwise>text-danger</c:otherwise>
                                            </c:choose>
                                        ">
                                            <strong>${note.valeur}</strong>
                                        </span>
                                    </td>
                                    <td>${note.dateSaisie}</td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-warning" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modifierNoteModal" 
                                                    data-id="${note.id}"
                                                    data-etudiant="${note.etudiant.id}"
                                                    data-matiere="${note.matiere.id}"
                                                    data-valeur="${note.valeur}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#supprimerNoteModal" 
                                                    data-id="${note.id}"
                                                    data-etudiant="${note.etudiant.prenom} ${note.etudiant.nom}"
                                                    data-matiere="${note.matiere.nom}">
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
                    <i class="fas fa-chart-pie me-2"></i>Répartition des notes
                </h5>
            </div>
            <div class="card-body">
                <canvas id="notesPieChart" width="100%" height="250"></canvas>
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
                <p>Importez plusieurs notes à la fois à partir d'un fichier CSV ou Excel.</p>
                <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="importerNotes">
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
                        <label for="fichierNotes" class="form-label">Fichier de notes (CSV, XLS, XLSX)</label>
                        <input type="file" class="form-control" id="fichierNotes" name="fichierNotes" accept=".csv,.xls,.xlsx" required>
                        <div class="form-text">Le fichier doit contenir les colonnes : Matricule, Nom, Prénom, Note</div>
                    </div>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-file-upload me-1"></i>Importer les notes
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ajouter Note -->
<div class="modal fade" id="ajouterNoteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter une note
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="ajouterNote">
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
                        <label for="valeurNote" class="form-label">Note (sur 20)</label>
                        <input type="number" class="form-control" id="valeurNote" name="valeur" min="0" max="20" step="0.25" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Modifier Note -->
<div class="modal fade" id="modifierNoteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Modifier une note
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="modifierNote">
                <input type="hidden" name="noteId" id="modifierNoteId">
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
                        <label for="modifierValeurNote" class="form-label">Note (sur 20)</label>
                        <input type="number" class="form-control" id="modifierValeurNote" name="valeur" min="0" max="20" step="0.25" required>
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

<!-- Modal Supprimer Note -->
<div class="modal fade" id="supprimerNoteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-trash-alt me-2"></i>Supprimer une note
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer cette note ?</p>
                <p>Cette action est irréversible.</p>
                <p><strong>Étudiant:</strong> <span id="supprimerNoteEtudiant"></span></p>
                <p><strong>Matière:</strong> <span id="supprimerNoteMatiere"></span></p>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="supprimerNote">
                <input type="hidden" name="noteId" id="supprimerNoteId">
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
        var table = document.getElementById('tableNotes');
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
        var table = document.getElementById('tableNotes');
        var rows = table.getElementsByTagName('tr');
        
        for (var i = 1; i < rows.length; i++) {
            var etudiantCell = rows[i].cells[1];
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
    
    // Graphique en camembert pour la répartition des notes
    var ctx = document.getElementById('notesPieChart').getContext('2d');
    var notesPieChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: ['≥ 16/20', 'Entre 12 et 16', 'Entre 10 et 12', '< 10/20'],
            datasets: [{
                data: [${nbNotesExcellentes}, ${nbNotesBonnes}, ${nbNotesMoyennes}, ${nbNotesInsuffisantes}],
                backgroundColor: [
                    'rgba(40, 167, 69, 0.7)',
                    'rgba(23, 162, 184, 0.7)',
                    'rgba(255, 193, 7, 0.7)',
                    'rgba(220, 53, 69, 0.7)'
                ],
                borderColor: [
                    'rgba(40, 167, 69, 1)',
                    'rgba(23, 162, 184, 1)',
                    'rgba(255, 193, 7, 1)',
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
    
    // Modifier une note
    $('#modifierNoteModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        var etudiantId = button.data('etudiant');
        var matiereId = button.data('matiere');
        var valeur = button.data('valeur');
        
        $('#modifierNoteId').val(id);
        $('#modifierEtudiantId').val(etudiantId);
        $('#modifierMatiereId').val(matiereId);
        $('#modifierValeurNote').val(valeur);
    });
    
    // Supprimer une note
    $('#supprimerNoteModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        var etudiant = button.data('etudiant');
        var matiere = button.data('matiere');
        
        $('#supprimerNoteId').val(id);
        $('#supprimerNoteEtudiant').text(etudiant);
        $('#supprimerNoteMatiere').text(matiere);
    });
</script>
<jsp:include page="/WEB-INF/includes/footer.jsp" />