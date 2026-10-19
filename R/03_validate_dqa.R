# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/03_validate_dqa.R
# Auteur : Mwenza Bwira
# Description : Moteur DQA (Data Quality Assessment) et détection d'anomalies
# ==============================================================================

# 1. Chargement des packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor)

message("--> Début de l'étape 03 : Exécution du moteur DQA...")

# 2. Chargement des données nettoyées
input_path <- "data/processed/02_cleaned_data.rds"
output_report_path <- "outputs/reports/dqa_anomaly_report.csv"

if (!file.exists(input_path)) {
  stop("ERREUR : Le fichier de l'étape 02 est introuvable. Veuillez exécuter '02_clean_data.R' d'abord.")
}

data <- readRDS(input_path)

# 3. Contrôles de qualité (DQA Rules)
anomalies_list <- list()

# Règle A : Détection des doublons d'identifiants ménages (hh_id)
duplicates_hh <- data %>%
  get_dupes(hh_id) %>%
  mutate(anomaly_type = "Doublon d'identifiant ménage (hh_id)")

if (nrow(duplicates_hh) > 0) {
  anomalies_list$duplicates <- duplicates_hh %>% select(hh_id, anomaly_type)
}

# Règle B : Incohérence démographique (enfants U5 > taille du ménage)
invalid_children <- data %>%
  filter(children_u5 > hh_size) %>%
  mutate(anomaly_type = "Incohérence : Enfants de moins de 5 ans > Taille du ménage")

if (nrow(invalid_children) > 0) {
  anomalies_list$children <- invalid_children %>% select(hh_id, anomaly_type)
}

# Règle C : Valeurs aberrantes sur l'âge du répondant (< 18 ou > 120 ans)
invalid_age <- data %>%
  filter(respondent_age < 18 | respondent_age > 120) %>%
  mutate(anomaly_type = "Valeur aberrante : Âge du répondant hors normes (18-120)")

if (nrow(invalid_age) > 0) {
  anomalies_list$age <- invalid_age %>% select(hh_id, anomaly_type)
}

# Règle D : Scores FCS hors limites (en dehors de 0 à 7 jours)
invalid_fcs <- data %>%
  filter(across(starts_with("fcs_"), ~ . < 0 | . > 7) %>% rowSums() > 0) %>%
  mutate(anomaly_type = "Valeur aberrante : Score FCS hors intervalle [0-7]")

if (nrow(invalid_fcs) > 0) {
  anomalies_list$fcs <- invalid_fcs %>% select(hh_id, anomaly_type)
}

# 4. Compilation et export du rapport d'anomalies
dir.create("outputs/reports", showWarnings = FALSE, recursive = TRUE)

if (length(anomalies_list) > 0) {
  dqa_report <- bind_rows(anomalies_list)
  write_csv(dqa_report, output_report_path)
  message(sprintf("--> DQA terminé : %d anomalie(s) détectée(s) et consignées dans '%s'.", nrow(dqa_report), output_report_path))
} else {
  # Création d'un rapport vide mais structuré si aucune anomalie n'est trouvée
  dqa_report <- tibble(hh_id = character(), anomaly_type = character())
  write_csv(dqa_report, output_report_path)
  message("--> DQA terminé avec succès : Aucune anomalie critique détectée dans le jeu de données !")
}


# ---