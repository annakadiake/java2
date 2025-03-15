
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Tableau de Bord Administrateur" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <h3 class="card-title">
                    <i class="fas fa-tachometer-alt me-2"></i>Tableau de Bord Administrateur
                </h3>
                <p class="card-text">Bienvenue dans le système de gestion académique. Voici un aperçu des statistiques de l'établissement.</p>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="card bg-primary text-white">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Total Étudiants</h5>
                        <h2 class="mb-0">${totalEtudiants}</h2>
                    </div>
                    <div>
                        <i class="fas fa-user-graduate fa-3x"></i>
                    </div>
                </div>
                <p class="mt-3 mb-0">
                    <a href="${pageContext.request.contextPath}/admin/etudiants.jsp" class="text-white">
                        <i class="fas fa-arrow-circle-right me-1"></i>Voir détails
                    </a>
                </p>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card bg-success text-white">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Total Enseignants</h5>
                        <h2 class="mb-0">${totalEnseignants}</h2>
                    </div>
                    <div>
                        <i class="fas fa-chalkboard-teacher fa-3x"></i>
                    </div>
                </div>
                <p class="mt-3 mb-0">
                    <a href="${pageContext.request.contextPath}/admin/enseignants.jsp" class="text-white">
                        <i class="fas fa-arrow-circle-right me-1"></i>Voir détails
                    </a>
                </p>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card bg-info text-white">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Total Matières</h5>
                        <h2 class="mb-0">${totalMatieres}</h2>
                    </div>
                    <div>
                        <i class="fas fa-book fa-3x"></i>
                    </div>
                </div>
                <p class="mt-3 mb-0">
                    <a href="${pageContext.request.contextPath}/admin/matieres.jsp" class="text-white">
                        <i class="fas fa-arrow-circle-right me-1"></i>Voir détails
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter un étudiant
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                    <input type="hidden" name="action" value="ajouterEtudiant">
                    
                    <div class="mb-3">
                        <label for="matricule" class="form-label">Matricule</label>
                        <input type="text" class="form-control" id="matricule" name="matricule" required>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nom" class="form-label">Nom</label>
                            <input type="text" class="form-control" id="nom" name="nom" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="prenom" class="form-label">Prénom</label>
                            <input type="text" class="form-control" id="prenom" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="dateNaissance" class="form-label">Date de naissance</label>
                        <input type="date" class="form-control" id="dateNaissance" name="dateNaissance">
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="filiere" class="form-label">Filière</label>
                            <input type="text" class="form-control" id="filiere" name="filiere" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="niveau" class="form-label">Niveau</label>
                            <select class="form-select" id="niveau" name="niveau" required>
                                <option value="">Sélectionner...</option>
                                <option value="Licence 1">Licence 1</option>
                                <option value="Licence 2">Licence 2</option>
                                <option value="Licence 3">Licence 3</option>
                                <option value="Master 1">Master 1</option>
                                <option value="Master 2">Master 2</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus-circle me-1"></i>Ajouter
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter un enseignant
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                    <input type="hidden" name="action" value="ajouterEnseignant">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nomEnseignant" class="form-label">Nom</label>
                            <input type="text" class="form-control" id="nomEnseignant" name="nom" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="prenomEnseignant" class="form-label">Prénom</label>
                            <input type="text" class="form-control" id="prenomEnseignant" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="emailEnseignant" class="form-label">Email</label>
                        <input type="email" class="form-control" id="emailEnseignant" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="specialite" class="form-label">Spécialité</label>
                        <input type="text" class="form-control" id="specialite" name="specialite" required>
                    </div>
                    
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-plus-circle me-1"></i>Ajouter
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter une matière
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                    <input type="hidden" name="action" value="ajouterMatiere">
                    
                    <div class="mb-3">
                        <label for="nomMatiere" class="form-label">Nom de la matière</label>
                        <input type="text" class="form-control" id="nomMatiere" name="nom" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="codeMatiere" class="form-label">Code</label>
                        <input type="text" class="form-control" id="codeMatiere" name="code" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="coefficient" class="form-label">Coefficient</label>
                        <input type="number" class="form-control" id="coefficient" name="coefficient" min="1" max="10" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="enseignantId" class="form-label">Enseignant</label>
                        <select class="form-select" id="enseignantId" name="enseignantId">
                            <option value="">Sélectionner un enseignant...</option>
                            <c:forEach var="enseignant" items="${enseignants}">
                                <option value="${enseignant.id}">${enseignant.prenom} ${enseignant.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-info text-white">
                        <i class="fas fa-plus-circle me-1"></i>Ajouter
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chart-bar me-2"></i>Statistiques récentes
                </h5>
            </div>
            <div class="card-body">
                <canvas id="statsChart" width="400" height="250"></canvas>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Graphique pour les statistiques
    var ctx = document.getElementById('statsChart').getContext('2d');
    var statsChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Étudiants', 'Enseignants', 'Matières', 'Notes', 'Absences'],
            datasets: [{
                label: 'Statistiques de l\'établissement',
                data: [${totalEtudiants}, ${totalEnseignants}, ${totalMatieres}, 120, 45],
                backgroundColor: [
                    'rgba(13, 110, 253, 0.7)',
                    'rgba(25, 135, 84, 0.7)',
                    'rgba(13, 202, 240, 0.7)',
                    'rgba(255, 193, 7, 0.7)',
                    'rgba(220, 53, 69, 0.7)'
                ],
                borderColor: [
                    'rgba(13, 110, 253, 1)',
                    'rgba(25, 135, 84, 1)',
                    'rgba(13, 202, 240, 1)',
                    'rgba(255, 193, 7, 1)',
                    'rgba(220, 53, 69, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />