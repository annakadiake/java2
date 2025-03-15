<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Tableau de Bord Enseignant" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <h3 class="card-title">
                    <i class="fas fa-tachometer-alt me-2"></i>Tableau de Bord Enseignant
                </h3>
                <p class="card-text">Bienvenue <strong>${enseignant.prenom} ${enseignant.nom}</strong> dans votre espace enseignant.</p>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="card bg-primary text-white h-100">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Mes matières</h5>
                        <h2 class="mb-0">${nbMatieres}</h2>
                    </div>
                    <div>
                        <i class="fas fa-book fa-3x"></i>
                    </div>
                </div>
                <p class="mt-3 mb-0">
                    <a href="${pageContext.request.contextPath}/enseignant/matieres.jsp" class="text-white">
                        <i class="fas fa-arrow-circle-right me-1"></i>Voir mes matières
                    </a>
                </p>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card bg-success text-white h-100">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Mes étudiants</h5>
                        <h2 class="mb-0">${nbEtudiants}</h2>
                    </div>
                    <div>
                        <i class="fas fa-user-graduate fa-3x"></i>
                    </div>
                </div>
                <p class="mt-3 mb-0">
                    <a href="${pageContext.request.contextPath}/enseignant/etudiants.jsp" class="text-white">
                        <i class="fas fa-arrow-circle-right me-1"></i>Voir mes étudiants
                    </a>
                </p>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card bg-info text-white h-100">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Notes en attente</h5>
                        <h2 class="mb-0">${nbNotesEnAttente}</h2>
                    </div>
                    <div>
                        <i class="fas fa-clipboard-list fa-3x"></i>
                    </div>
                </div>
                <p class="mt-3 mb-0">
                    <a href="${pageContext.request.contextPath}/enseignant/notes.jsp" class="text-white">
                        <i class="fas fa-arrow-circle-right me-1"></i>Gérer les notes
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chalkboard-teacher me-2"></i>Informations personnelles
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-borderless">
                        <tbody>
                            <tr>
                                <th width="30%">Nom complet</th>
                                <td>${enseignant.prenom} ${enseignant.nom}</td>
                            </tr>
                            <tr>
                                <th>Email</th>
                                <td>${enseignant.email}</td>
                            </tr>
                            <tr>
                                <th>Spécialité</th>
                                <td>${enseignant.specialite}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-clipboard-list me-2"></i>Actions rapides
                </h5>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/enseignant/saisie-notes.jsp" class="btn btn-primary">
                        <i class="fas fa-pen me-1"></i>Saisir des notes
                    </a>
                    <a href="${pageContext.request.contextPath}/enseignant/absences.jsp" class="btn btn-danger">
                        <i class="fas fa-calendar-times me-1"></i>Signaler des absences
                    </a>
                    <a href="${pageContext.request.contextPath}/enseignant/documents.jsp" class="btn btn-success">
                        <i class="fas fa-file-upload me-1"></i>Partager des documents
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chart-bar me-2"></i>Statistiques des notes
                </h5>
            </div>
            <div class="card-body">
                <canvas id="notesChart" width="100%" height="250"></canvas>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-bullhorn me-2"></i>Dernières alertes
                </h5>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <c:choose>
                        <c:when test="${not empty alertes}">
                            <c:forEach var="alerte" items="${alertes}">
                                <li class="list-group-item">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-1">${alerte.titre}</h6>
                                        <small>${alerte.date}</small>
                                    </div>
                                    <p class="mb-1">${alerte.message}</p>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li class="list-group-item">
                                <p class="text-muted mb-0">Aucune alerte à afficher.</p>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Graphique pour les statistiques des notes
    var ctx = document.getElementById('notesChart').getContext('2d');
    
    // Récupérer les données via AJAX
    $.ajax({
        url: '${pageContext.request.contextPath}/api/enseignants/${enseignant.id}/stats-notes',
        type: 'GET',
        success: function(data) {
            var notesChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.matieres,
                    datasets: [
                        {
                            label: 'Moyenne',
                            data: data.moyennes,
                            backgroundColor: 'rgba(23, 162, 184, 0.7)',
                            borderColor: 'rgba(23, 162, 184, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Note max',
                            data: data.maximums,
                            backgroundColor: 'rgba(40, 167, 69, 0.7)',
                            borderColor: 'rgba(40, 167, 69, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Note min',
                            data: data.minimums,
                            backgroundColor: 'rgba(220, 53, 69, 0.7)',
                            borderColor: 'rgba(220, 53, 69, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 20
                        }
                    }
                }
            });
        },
        error: function() {
            document.getElementById('notesChart').innerHTML = 'Erreur lors du chargement des statistiques';
        }
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />