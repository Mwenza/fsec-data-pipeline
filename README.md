# FSEC Data Pipeline - Food Security & MEAL Analytics

## 📋 Description du projet
Ce projet présente un pipeline de données de bout en bout développé **100% en R**, conçu pour automatiser le traitement, le contrôle qualité et l'analyse des enquêtes de sécurité alimentaire et de suivi-évaluation (MEAL) dans le secteur humanitaire et du développement.

Il intègre les standards méthodologiques du PAM (Programme WFP) et de la FAO pour la gestion des données de vulnérabilité. Cette version mise à jour gère un échantillon simulé robuste de **800 ménages** répartis dans les zones du Nord-Kivu (Goma, Nyiragongo, Masisi). Pour tester et visualiser le tableau de bord interactif de ce projet, veuillez cliquer [ici.](https://mwenza.shinyapps.io/dashboard/)

---

## 📂 Structure du dépôt
- **`R/`** : Contient les scripts modulaires du pipeline :
  - `01_import_data.R` : Importation, génération et harmonisation des données brutes (N = 800).
  - `02_clean_data.R` : Nettoyage, typage et standardisation des variables.
  - `03_validate_dqa.R` : Moteur de contrôle qualité avancé (Data Quality Assessment) et détection d'anomalies.
  - `04_calculate_indicators.R` : Calcul des indicateurs standardisés (FCS, rCSI, HDDS, HHS).
  - `05_analyze_data.R` : Analyses descriptives et agrégations statistiques par zone d'enquête.
  - `06_export_results.R` : Exportation du dataset maître consolidé.
  - `07_generate_figures.R` : Génération automatisée des graphiques analytiques (`ggplot2`).
- **`dashboard/`** : 
  - `app.R` : Tableau de bord interactif **R Shiny** (filtrage dynamique, value boxes, graphiques `plotly` et tables `DT`).
- **`reports/`** : Rapports narratifs et synthèses analytiques du projet.
- **`tests/`** : Scripts de tests unitaires pour la validation de la qualité des données.
- **`xlsform/`** : Modèle de formulaire KoboToolbox validé pour la collecte terrain.
- **`outputs/`** : Rapports d'anomalies DQA, tableaux de synthèse et graphiques exportés.
- **`data/`** : Jeux de données simulés (bruts et traités aux formats CSV/RDS).
---

## ⚙️ Prérequis et Utilisation
1. Ouvrir le projet RStudio (`fsec-data-pipeline.Rproj`).
2. S'assurer que le package `pacman` est installé (ou installer manuellement `tidyverse`, `janitor`, `shiny`, `bslib`, `plotly`, `DT`).
3. Exécuter les scripts de l'étape `01` à `06` séquentiellement pour alimenter le pipeline.
4. Lancer le tableau de bord interactif en ouvrant le fichier `dashboard/app.R` et en cliquant sur **"Run App"** dans RStudio (ou via la commande `shiny::runApp("dashboard")`).

---
*Auteur : Mwenza Bwira*
