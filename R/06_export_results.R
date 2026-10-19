# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/06_export_results.R
# Auteur : Mwenza Bwira
# Description : Exportation finale du dataset maître consolidé pour reporting
# ==============================================================================

# 1. Chargement des packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor)

message("--> Début de l'étape 06 : Exportation finale du dataset maître...")

# 2. Chargement des données avec indicateurs
input_path <- "data/processed/04_indicators_data.rds"
output_master_csv <- "outputs/fsec_master_dataset.csv"
output_master_rds <- "data/processed/fsec_master_dataset.rds"

if (!file.exists(input_path)) {
  stop("ERREUR : Le fichier de l'étape 04 est introuvable. Veuillez exécuter '04_calculate_indicators.R' d'abord.")
}

master_data <- readRDS(input_path)

# 3. Sélection et réarrangement final des colonnes clés pour le portfolio
final_export <- master_data %>%
  select(
    hh_id, interview_date, enumerator_id, cluster_zone,
    respondent_sex, respondent_age, hh_size, children_u5,
    fcs_score, fcs_cat, rcsi_score, hdds_score
  )

# 4. Sauvegarde aux formats CSV et RDS finaux
dir.create("outputs", showWarnings = FALSE, recursive = TRUE)
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

write_csv(final_export, output_master_csv)
saveRDS(final_export, output_master_rds)

message(paste0("--> Pipeline 100% R exécuté de bout en bout avec succès ! Dataset maître exporté dans : '", output_master_csv, "'."))


# ---