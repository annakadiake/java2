<!-- src/main/webapp/etudiant/matieres.jsp -->
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
                <p class="card-text">Consultez les matières auxquelles vous êtes inscrit(e).</p>
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
                    <p>
                        <strong>Enseignant:</strong> 
                        <c:choose>
                            <c:when test="${not empty matiere.enseignant}">
                                ${matiere.enseignant.prenom} ${matiere.enseignant.nom}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Non assigné</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>
                        <strong>Note:</strong> 
                        <c:choose>
                            <c:when test="${not empty matiere.note}">
                                <span class="
                                    <c:choose>
                                        <c:when test="${matiere.note >= 16}">text-success</c:when>
                                        <c:when test="${matiere.note >= 12}">text-info</c:when>
                                        <c:when test="${matiere.note >= 10}">text-warning</c:when>
                                        <c:otherwise>text-danger</c:otherwise>
                                    </c:choose>
                                ">
                                    <strong>${matiere.note}/20</strong>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Non notée</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="card-footer">
                    <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#detailsMatiereModal" data-id="${matiere.id}">
                        <i class="fas fa-eye me-1"></i>Détails
                    </button>
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
                        <p class="mb-1"><strong>Enseignant:</strong> <span id="detailsMatiereEnseignant"></span></p>
                        <p class="mb-1"><strong>Note:</strong> <span id="detailsMatiereNote"></span></p>
                    </div>
                </div>
                
                <ul class="nav nav-tabs" id="matiereDetailsTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button" role="tab">Description</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="resources-tab" data-bs-toggle="tab" data-bs-target="#resources" type="button" role="tab">Ressources</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="cours-tab" data-bs-toggle="tab" data-bs-target="#cours" type="button" role="tab">Cours</button>
                    </li>
                </ul>
                <div class="tab-content" id="matiereDetailsContent">
                    <div class="tab-pane fade show active p-3" id="description" role="tabpanel">
                        <p id="detailsMatiereDescription"></p>
                    </div>
                    <div class="tab-pane fade p-3" id="resources" role="tabpanel">
                        <div id="detailsMatiereResources">
                            <!-- Ressources insérées dynamiquement -->
                        </div>
                    </div>
                    <div class="tab-pane fade p-3" id="cours" role="tabpanel">
                        <div id="detailsMatiereCours">
                            <!-- Cours insérés dynamiquement -->
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Détails d'une matière
    $('#detailsMatiereModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les détails de la matière
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + id,
            type: 'GET',
            success: function(matiere) {
                $('#detailsMatiereNom').text(matiere.nom);
                $('#detailsMatiereCode').text(matiere.code);
                $('#detailsMatiereCoefficient').text(matiere.coefficient);
                
                if (matiere.enseignant) {
                    $('#detailsMatiereEnseignant').text(matiere.enseignant.prenom + ' ' + matiere.enseignant.nom);
                } else {
                    $('#detailsMatiereEnseignant').html('<span class="text-muted">Non assigné</span>');
                }
                
                if (matiere.note) {
                    var noteClass = '';
                    if (matiere.note >= 16) {
                        noteClass = 'text-success';
                    } else if (matiere.note >= 12) {
                        noteClass = 'text-info';
                    } else if (matiere.note >= 10) {
                        noteClass = 'text-warning';
                    } else {
                        noteClass = 'text-danger';
                    }
                    $('#detailsMatiereNote').html('<span class="' + noteClass + '"><strong>' + matiere.note + '/20</strong></span>');
                } else {
                    $('#detailsMatiereNote').html('<span class="text-muted">Non notée</span>');
                }
                
                // Description de la matière
                if (matiere.description) {
                    $('#detailsMatiereDescription').text(matiere.description);
                } else {
                    $('#detailsMatiereDescription').text('Aucune description disponible pour cette matière.');
                }
                
                // Ressources de la matière
                if (matiere.resources && matiere.resources.length > 0) {
                    var resourcesHtml = '<ul class="list-group">';
                    matiere.resources.forEach(function(resource) {
                        resourcesHtml += '<li class="list-group-item d-flex justify-content-between align-items-center">';
                        resourcesHtml += '<div><i class="fas fa-file-pdf me-2"></i>' + resource.title + '</div>';
                        resourcesHtml += '<a href="' + resource.url + '" class="btn btn-sm btn-outline-primary" target="_blank">';
                        resourcesHtml += '<i class="fas fa-download me-1"></i>Télécharger</a>';
                        resourcesHtml += '</li>';
                    });
                    resourcesHtml += '</ul>';
                    $('#detailsMatiereResources').html(resourcesHtml);
                } else {
                    $('#detailsMatiereResources').html('<p class="text-muted">Aucune ressource disponible pour cette matière.</p>');
                }
                
                // Cours de la matière
                if (matiere.cours && matiere.cours.length > 0) {
                    var coursHtml = '<div class="list-group">';
                    matiere.cours.forEach(function(cours) {
                        coursHtml += '<a href="#" class="list-group-item list-group-item-action">';
                        coursHtml += '<div class="d-flex w-100 justify-content-between">';
                        coursHtml += '<h5 class="mb-1">' + cours.title + '</h5>';
                        coursHtml += '<small>' + new Date(cours.date).toLocaleDateString() + '</small>';
                        coursHtml += '</div>';
                        coursHtml += '<p class="mb-1">' + cours.description + '</p>';
                        coursHtml += '</a>';
                    });
                    coursHtml += '</div>';
                    $('#detailsMatiereCours').html(coursHtml);
                } else {
                    $('#detailsMatiereCours').html('<p class="text-muted">Aucun cours disponible pour cette matière.</p>');
                }
            },
            error: function() {
                alert('Erreur lors du chargement des données de la matière');
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<!-- src/main/webapp/etudiant/bulletin.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Mon Bulletin" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <h3 class="card-title">
                    <i class="fas fa-file-alt me-2"></i>Mon Bulletin
                </h3>
                <p class="card-text">Visualisez votre bulletin de notes complet.</p>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-9">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-file-alt me-2"></i>Bulletin de notes
                    </h5>
                    <a href="${pageContext.request.contextPath}/BulletinServlet" class="btn btn-primary btn-sm">
                        <i class="fas fa-file-pdf me-1"></i>Télécharger en PDF
                    </a>
                </div>
            </div>
            <div class="card-body">
                <!-- En-tête du bulletin -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h4>Ecole Supérieure Multinationale des Télécommunications</h4>
                        <p>Année académique: 2024-2025</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <p><strong>Étudiant:</strong> ${etudiant.prenom} ${etudiant.nom}</p>
                        <p><strong>Matricule:</strong> ${etudiant.matricule}</p>
                        <p><strong>Niveau:</strong> ${etudiant.niveau}</p>
                        <p><strong>Filière:</strong> ${etudiant.filiere}</p>
                    </div>
                </div>
                
                <!-- Tableau des notes -->
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="table-primary">
                            <tr>
                                <th>Matière</th>
                                <th>Code</th>
                                <th>Enseignant</th>
                                <th>Coefficient</th>
                                <th>Note/20</th>
                                <th>Note pondérée</th>
                                <th>Appréciation</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="note" items="${notes}">
                                <tr>
                                    <td>${note.matiere.nom}</td>
                                    <td>${note.matiere.code}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty note.matiere.enseignant}">
                                                ${note.matiere.enseignant.prenom} ${note.matiere.enseignant.nom}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Non assigné</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${note.matiere.coefficient}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${note.valeur >= 16}">
                                                <span class="text-success">${note.valeur}</span>
                                            </c:when>
                                            <c:when test="${note.valeur >= 12}">
                                                <span class="text-info">${note.valeur}</span>
                                            </c:when>
                                            <c:when test="${note.valeur >= 10}">
                                                <span class="text-warning">${note.valeur}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger">${note.valeur}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${note.valeur * note.matiere.coefficient}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${note.valeur >= 16}">Excellent</c:when>
                                            <c:when test="${note.valeur >= 14}">Très bien</c:when>
                                            <c:when test="${note.valeur >= 12}">Bien</c:when>
                                            <c:when test="${note.valeur >= 10}">Passable</c:when>
                                            <c:otherwise>Insuffisant</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr class="table-primary">
                                <th colspan="3">TOTAL</th>
                                <th>${totalCoefficients}</th>
                                <th>-</th>
                                <th>${noteTotale}</th>
                                <th>-</th>
                            </tr>
                            <tr class="table-success">
                                <th colspan="3">MOYENNE GÉNÉRALE</th>
                                <th colspan="2">${moyenneGenerale}/20</th>
                                <th colspan="2">
                                    <c:choose>
                                        <c:when test="${moyenneGenerale >= 16}">Excellent</c:when>
                                        <c:when test="${moyenneGenerale >= 14}">Très bien</c:when>
                                        <c:when test="${moyenneGenerale >= 12}">Bien</c:when>
                                        <c:when test="${moyenneGenerale >= 10}">Passable</c:when>
                                        <c:otherwise>Insuffisant</c:otherwise>
                                    </c:choose>
                                </th>
                            </tr>
                            <tr class="table-info">
                                <th colspan="3">DÉCISION</th>
                                <th colspan="4">
                                    <c:choose>
                                        <c:when test="${moyenneGenerale >= 10}">
                                            <span class="text-success">ADMIS(E)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger">AJOURNÉ(E)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                
                <!-- Commentaires et signature -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">Observations</div>
                            <div class="card-body">
                                <p class="mb-0">
                                    <c:choose>
                                        <c:when test="${moyenneGenerale >= 16}">
                                            Excellent parcours ! Félicitations pour ces résultats remarquables.
                                        </c:when>
                                        <c:when test="${moyenneGenerale >= 14}">
                                            Très bons résultats. Continuez dans cette voie.
                                        </c:when>
                                        <c:when test="${moyenneGenerale >= 12}">
                                            Bon travail dans l'ensemble. Quelques matières pourraient être améliorées.
                                        </c:when>
                                        <c:when test="${moyenneGenerale >= 10}">
                                            Résultats satisfaisants. Des efforts supplémentaires sont nécessaires dans certaines matières.
                                        </c:when>
                                        <c:otherwise>
                                            Résultats insuffisants. Un travail important est nécessaire dans la plupart des matières.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 text-end">
                        <p><strong>Fait à Dakar, le:</strong> <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></p>
                        <p><strong>Le Directeur des Études</strong></p>
                        <div style="height: 60px;"></div>
                        <p>Pr. Moustapha DER</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chart-pie me-2"></i>Répartition des notes
                </h5>
            </div>
            <div class="card-body">
                <canvas id="notesPieChart" width="100%" height="200"></canvas>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-info-circle me-2"></i>Légende
                </h5>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Excellent
                        <span class="badge bg-success rounded-pill">≥ 16/20</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Très bien
                        <span class="badge bg-info rounded-pill">14-15.99</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Bien
                        <span class="badge bg-primary rounded-pill">12-13.99</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Passable
                        <span class="badge bg-warning rounded-pill">10-11.99</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Insuffisant
                        <span class="badge bg-danger rounded-pill">< 10</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Graphique en camembert pour la répartition des notes
    var ctx = document.getElementById('notesPieChart').getContext('2d');
    var notesPieChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Excellent', 'Très bien', 'Bien', 'Passable', 'Insuffisant'],
            datasets: [{
                data: [${nbNotesExcellentes}, ${nbNotesTresBien}, ${nbNotesBien}, ${nbNotesPassable}, ${nbNotesInsuffisantes}],
                backgroundColor: [
                    'rgba(40, 167, 69, 0.7)',  // Vert
                    'rgba(23, 162, 184, 0.7)', // Bleu clair
                    'rgba(13, 110, 253, 0.7)', // Bleu foncé
                    'rgba(255, 193, 7, 0.7)',  // Jaune
                    'rgba(220, 53, 69, 0.7)'   // Rouge
                ],
                borderColor: [
                    'rgba(40, 167, 69, 1)',
                    'rgba(23, 162, 184, 1)',
                    'rgba(13, 110, 253, 1)',
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
                    position: 'bottom',
                    labels: {
                        boxWidth: 15
                    }
                }
            }
        }
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />