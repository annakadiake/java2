<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Mes Matières" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <h3 class="card-title">
                    <i class="fas fa-book me-2"></i>Mes Matières
                </h3>
                <p class="card-text">Consultez les matières que vous enseignez et gérez les ressources pédagogiques.</p>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <c:forEach var="matiere" items="${matieres}">
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">${matiere.nom}</h5>
                </div>
                <div class="card-body">
                    <p><strong>Code:</strong> ${matiere.code}</p>
                    <p><strong>Coefficient:</strong> ${matiere.coefficient}</p>
                    <p><strong>Nombre d'étudiants:</strong> ${matiere.nbEtudiants}</p>
                    <div class="progress mb-3">
                        <div class="progress-bar bg-info" role="progressbar" 
                             style="width: ${matiere.tauxCompletion}%;" 
                             aria-valuenow="${matiere.tauxCompletion}" aria-valuemin="0" aria-valuemax="100">
                            ${matiere.tauxCompletion}% complété
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#detailsMatiereModal" data-id="${matiere.id}">
                            <i class="fas fa-eye me-1"></i>Détails
                        </button>
                        <a href="${pageContext.request.contextPath}/enseignant/gestion-matiere.jsp?id=${matiere.id}" class="btn btn-success btn-sm">
                            <i class="fas fa-cog me-1"></i>Gérer
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<!-- Modal Détails Matière -->
<div class="modal fade" id="detailsMatiereModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-book me-2"></i>Détails de la matière
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h4 id="detailsMatiereNom"></h4>
                        <p class="mb-1"><strong>Code:</strong> <span id="detailsMatiereCode"></span></p>
                        <p class="mb-1"><strong>Coefficient:</strong> <span id="detailsMatiereCoefficient"></span></p>
                        <p class="mb-1"><strong>Nombre d'étudiants:</strong> <span id="detailsMatiereNbEtudiants"></span></p>
                    </div>
                </div>
                
                <ul class="nav nav-tabs" id="matiereDetailsTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="etudiants-tab" data-bs-toggle="tab" data-bs-target="#etudiants" type="button" role="tab">Étudiants</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="stats-tab" data-bs-toggle="tab" data-bs-target="#stats" type="button" role="tab">Statistiques</button>
                    </li>
                </ul>
                <div class="tab-content" id="matiereDetailsContent">
                    <div class="tab-pane fade show active p-3" id="etudiants" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Matricule</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Note</th>
                                        <th>Absences</th>
                                    </tr>
                                </thead>
                                <tbody id="detailsMatiereEtudiantsTable">
                                    <!-- Étudiants insérés dynamiquement -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade p-3" id="stats" role="tabpanel">
                        <div class="row">
                            <div class="col-md-6">
                                <canvas id="detailsMatiereNotesChart" width="100%" height="200"></canvas>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-3">
                                    <div class="card-header">Statistiques des notes</div>
                                    <div class="card-body">
                                        <p><strong>Moyenne:</strong> <span id="detailsMatiereMoyenne"></span>/20</p>
                                        <p><strong>Note max:</strong> <span id="detailsMatiereNoteMax"></span>/20</p>
                                        <p><strong>Note min:</strong> <span id="detailsMatiereNoteMin"></span>/20</p>
                                        <p><strong>Taux de réussite:</strong> <span id="detailsMatiereTauxReussite"></span>%</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                <a href="#" id="detailsMatiereGererLink" class="btn btn-success">
                    <i class="fas fa-cog me-1"></i>Gérer cette matière
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Détails d'une matière
    $('#detailsMatiereModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Mettre à jour le lien "Gérer cette matière"
        $('#detailsMatiereGererLink').attr('href', '${pageContext.request.contextPath}/enseignant/gestion-matiere.jsp?id=' + id);
        
        // Appel AJAX pour obtenir les détails de la matière
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + id,
            type: 'GET',
            success: function(matiere) {
                $('#detailsMatiereNom').text(matiere.nom);
                $('#detailsMatiereCode').text(matiere.code);
                $('#detailsMatiereCoefficient').text(matiere.coefficient);
                $('#detailsMatiereNbEtudiants').text(matiere.nbEtudiants || '0');
                
                // Récupérer les étudiants inscrits et leurs notes
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/' + id + '/etudiants',
                    type: 'GET',
                    success: function(etudiants) {
                        var html = '';
                        
                        if (etudiants && etudiants.length > 0) {
                            etudiants.forEach(function(etudiant) {
                                html += '<tr>';
                                html += '<td>' + etudiant.matricule + '</td>';
                                html += '<td>' + etudiant.nom + '</td>';
                                html += '<td>' + etudiant.prenom + '</td>';
                                html += '<td>';
                                if (etudiant.note) {
                                    var noteClass = '';
                                    if (etudiant.note >= 16) {
                                        noteClass = 'text-success';
                                    } else if (etudiant.note >= 12) {
                                        noteClass = 'text-info';
                                    } else if (etudiant.note >= 10) {
                                        noteClass = 'text-warning';
                                    } else {
                                        noteClass = 'text-danger';
                                    }
                                    html += '<span class="' + noteClass + '"><strong>' + etudiant.note + '/20</strong></span>';
                                } else {
                                    html += '<span class="text-muted">Non notée</span>';
                                }
                                html += '</td>';
                                html += '<td>' + (etudiant.nbAbsences || '0') + '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="5" class="text-center">Aucun étudiant inscrit à cette matière</td></tr>';
                        }
                        
                        $('#detailsMatiereEtudiantsTable').html(html);
                    },
                    error: function() {
                        $('#detailsMatiereEtudiantsTable').html('<tr><td colspan="5" class="text-center">Erreur lors du chargement des étudiants</td></tr>');
                    }
                });
                
                // Récupérer les statistiques pour cette matière
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/' + id + '/stats',
                    type: 'GET',
                    success: function(stats) {
                        $('#detailsMatiereMoyenne').text(stats.moyenne.toFixed(2));
                        $('#detailsMatiereNoteMax').text(stats.noteMax.toFixed(2));
                        $('#detailsMatiereNoteMin').text(stats.noteMin.toFixed(2));
                        $('#detailsMatiereTauxReussite').text(stats.tauxReussite.toFixed(2));
                        
                        // Graphique pour la répartition des notes
                        var ctx = document.getElementById('detailsMatiereNotesChart').getContext('2d');
                        var notesChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: ['≥ 16/20', 'Entre 12 et 16', 'Entre 10 et 12', '< 10/20'],
                                datasets: [{
                                    data: [stats.nbNotesExcellentes, stats.nbNotesBonnes, stats.nbNotesMoyennes, stats.nbNotesInsuffisantes],
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
                                        display: false
                                    },
                                    title: {
                                        display: true,
                                        text: 'Répartition des notes'
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });
                    },
                    error: function() {
                        $('#detailsMatiereMoyenne').text('N/A');
                        $('#detailsMatiereNoteMax').text('N/A');
                        $('#detailsMatiereNoteMin').text('N/A');
                        $('#detailsMatiereTauxReussite').text('N/A');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de la matière');
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />