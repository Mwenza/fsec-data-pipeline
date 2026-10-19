# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/02_clean_data.R
# Auteur : Mwenza Bwira
# Description : Nettoyage, typage et standardisation des données brutes
# ==============================================================================

# 1. Chargement des packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor)

message("--> Début de l'étape 02 : Nettoyage et standardisation des données...")

# 2. Chargement des données issues de l'étape 01
input_path <- "data/processed/01_imported_data.rds"
output_path <- "data/processed/02_cleaned_data.rds"

if (!file.exists(input_path)) {
  stop("ERREUR : Le fichier de l'étape 01 est introuvable. Veuillez exécuter '01_import_data.R' d'abord.")
}

raw_data <- readRDS(input_path)

# 3. Traitement et nettoyage
clean_data <- raw_data %>%
  # Nettoyage global des chaînes de caractères (suppression des espaces superflus)
  mutate(across(where(is.character), str_trim)) %>%
  
  # Conversion et sécurisation des types de variables numériques
  mutate(
    respondent_age = as.numeric(respondent_age),
    hh_size = as.numeric(hh_size),
    children_u5 = as.numeric(children_u5),
    
    # Sécurisation des scores FCS (0 à 7)
    across(starts_with("fcs_"), ~ as.numeric(.)),
    
    # Sécurisation des scores rCSI (0 à 7)
    across(starts_with("rcsi_"), ~ as.numeric(.))
  ) %>%
  
  # Remplacement des éventuelles valeurs négatives accidentelles par NA (sécurité)
  mutate(
    respondent_age = ifelse(respondent_age < 0, NA, respondent_age),
    hh_size = ifelse(hh_size < 0, NA, hh_size)
  )

# 4. Sauvegarde des données nettoyées
saveRDS(clean_data, output_path)

message(paste0("--> Étape 02 terminée avec succès ! ", nrow(clean_data <- clean_data), " lignes nettoyées et prêtes pour le DQA."))

# ---