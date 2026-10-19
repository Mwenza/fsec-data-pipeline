# FSEC Data Pipeline - Food Security & MEAL Analytics

## 📋 Description du projet
Ce projet présente un pipeline de données de bout en bout développé **100% en R**, conçu pour automatiser le traitement, le contrôle qualité et l'analyse des enquêtes de sécurité alimentaire et de suivi-évaluation (MEAL) dans le secteur humanitaire et du développement.

Il intègre les standards méthodologiques du PAM (Programme WFP) et de la FAO pour la gestion des données de vulnérabilité.

---

## 📂 Structure du dépôt
- **`R/`** : Contient les scripts modulaires du pipeline :
  - `01_import_data.R` : Importation et harmonisation des données brutes.
  - `02_clean_data.R` : Nettoyage et typage des variables.
  - `03_validate_dqa.R` : Moteur de contrôle qualité (Data Quality Assessment) et détection d'anomalies.
  - `04_calculate_indicators.R` : Calcul des indicateurs standardisés (FCS, rCSI, HDDS, HHS).
  - `05_analyze_data.R` : Analyses descriptives et agrégations par zone.
  - `06_export_results.R` : Exportation du dataset maître consolidé.
- **`xlsform/`** : Modèle de formulaire KoboToolbox validé pour la collecte terrain.
- **`outputs/`** : Rapports d'anomalies DQA et tableaux de synthèse statistiques.
- **`data/`** : Jeux de données simulés (bruts et traités).

---

## ⚙️ Prérequis et Utilisation
1. Ouvrir le projet RStudio (`fsec-data-pipeline.Rproj`).
2. S'assurer que le package `pacman` est installé.
3. Exécuter les scripts séquentiellement de `01` à `06`.

---
*Auteur : Mwenza Bwira*
