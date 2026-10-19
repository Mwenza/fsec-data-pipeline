# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/05_analyze_data.R
# Auteur : Mwenza Bwira
# Description : Analyses descriptives et agrégations des indicateurs FSL par zone
# ==============================================================================

# 1. Chargement des packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor, knitr)

message("--> Début de l'étape 05 : Analyses statistiques et agrégations...")

# 2. Chargement des données avec indicateurs
input_path <- "data/processed/04_indicators_data.rds"
output_summary_path <- "outputs/reports/fsl_summary_stats.csv"

if (!file.exists(input_path)) {
  stop("ERREUR : Le fichier de l'étape 04 est introuvable. Veuillez exécuter '04_calculate_indicators.R' d'abord.")
}

data <- readRDS(input_path)

# 3. Agrégations statistiques par zone d'enquête (cluster_zone)
fsl_summary_by_zone <- data %>%
  group_by(cluster_zone) %>%
  summarise(
    total_households = n(),
    mean_hh_size = round(mean(hh_size, na.rm = TRUE), 1),
    mean_fcs = round(mean(fcs_score, na.rm = TRUE), 1),
    mean_rcsi = round(mean(rcsi_score, na.rm = TRUE), 1),
    mean_hdds = round(mean(hdds_score, na.rm = TRUE), 1),
    pct_poor_fcs = round(mean(fcs_cat == "Pauvre (Poor)", na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

# Affichage du résumé dans la console RStudio
print(fsl_summary_by_zone)

# 4. Sauvegarde du tableau de synthèse
dir.create("outputs/reports", showWarnings = FALSE, recursive = TRUE)
write_csv(fsl_summary_by_zone, output_summary_path)

message(paste0("--> Étape 05 terminée avec succès ! Tableau de synthèse exporté dans '", output_summary_path, "'."))


# ---