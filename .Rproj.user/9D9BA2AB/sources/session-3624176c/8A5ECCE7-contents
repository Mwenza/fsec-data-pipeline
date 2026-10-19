# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/01_import_data.R
# Auteur : Mwenza Bwira
# Description : Importation des données brutes KoboToolbox et vérification des structures
# ==============================================================================

# 1. Chargement des packages nécessaires
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor, readxl)

message("--> Début de l'étape 01 : Importation des données...")

# 2. Définition des chemins de fichiers
raw_data_path <- "data/raw/fsec_simulated_raw.csv"
output_rds_path <- "data/processed/01_imported_data.rds"

# 3. Vérification de l'existence du fichier brut
if (!file.exists(raw_data_path)) {
  warning("ATTENTION : Le fichier 'fsec_simulated_raw.csv' n'a pas encore été placé dans 'data/raw/'.")
  warning("Un jeu de données de démonstration temporaire va être généré pour tester le pipeline.")
  
  # Génération d'une structure minimale de test si le CSV n'existe pas encore
  set.seed(123)
  df_dummy <- tibble(
    hh_id = paste0("HH_", 1001:1015),
    interview_date = Sys.Date() - sample(1:10, 15, replace = TRUE),
    enumerator_id = sample(c("ENV_001", "ENV_002", "ENV_003"), 15, replace = TRUE),
    cluster_zone = sample(c("cluster_1", "cluster_2", "cluster_3"), 15, replace = TRUE),
    respondent_sex = sample(c("female", "male"), 15, replace = TRUE),
    respondent_age = sample(18:65, 15, replace = TRUE),
    hh_size = sample(3:10, 15, replace = TRUE),
    children_u5 = sample(0:3, 15, replace = TRUE),
    fcs_cereals = sample(0:7, 15, replace = TRUE),
    fcs_pulses = sample(0:7, 15, replace = TRUE),
    fcs_vegetables = sample(0:7, 15, replace = TRUE),
    fcs_fruits = sample(0:7, 15, replace = TRUE),
    fcs_meat_fish = sample(0:7, 15, replace = TRUE),
    fcs_dairy = sample(0:7, 15, replace = TRUE),
    fcs_sugar = sample(0:7, 15, replace = TRUE),
    fcs_oil = sample(0:7, 15, replace = TRUE),
    rcsi_less_preferred = sample(0:7, 15, replace = TRUE),
    rcsi_borrow_food = sample(0:7, 15, replace = TRUE),
    rcsi_limit_portion = sample(0:7, 15, replace = TRUE),
    rcsi_reduce_adults = sample(0:7, 15, replace = TRUE),
    rcsi_reduce_meals = sample(0:7, 15, replace = TRUE),
    hdds_cereals = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_roots = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_vegetables = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_fruits = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_meat = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_eggs = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_fish = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_legumes_nuts = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_milk = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_oils = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_sweets = sample(c("yes", "no"), 15, replace = TRUE),
    hdds_spices = sample(c("yes", "no"), 15, replace = TRUE),
    hhs_no_food_occ = sample(c("yes", "no"), 15, replace = TRUE),
    hhs_no_food_freq = sample(c("rarely", "sometimes", "often"), 15, replace = TRUE),
    hhs_sleep_hungry_occ = sample(c("yes", "no"), 15, replace = TRUE),
    hhs_sleep_hungry_freq = sample(c("rarely", "sometimes", "often"), 15, replace = TRUE),
    hhs_whole_day_occ = sample(c("yes", "no"), 15, replace = TRUE),
    hhs_whole_day_freq = sample(c("rarely", "sometimes", "often"), 15, replace = TRUE)
  )
  
  dir.create("data/raw", showWarnings = FALSE, recursive = TRUE)
  write_csv(df_dummy, raw_data_path)
  message("--> Un jeu de données de démonstration a été créé automatiquement dans 'data/raw/fsec_simulated_raw.csv'.")
}

# 4. Importation réelle et nettoyage des noms de colonnes
raw_data <- read_csv(raw_data_path, show_col_types = FALSE) %>% 
  clean_names()

# 5. Sauvegarde du fichier RDS intermédiaire
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
saveRDS(raw_data, output_rds_path)

message(paste0("--> Étape 01 terminée avec succès ! ", nrow(raw_data), " lignes importées et sauvegardées."))