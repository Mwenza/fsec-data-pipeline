# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/01_import_data.R
# Auteur : Mwenza Bwira
# Description : Importation des données brutes KoboToolbox et génération d'un 
#               échantillon simulé robuste (N = 800 ménages)
# ==============================================================================

# 1. Chargement des packages nécessaires
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor, readxl)

message("--> Début de l'étape 01 : Importation et préparation des données...")

# 2. Définition des chemins de fichiers
raw_data_path <- "data/raw/fsec_simulated_raw.csv"
output_rds_path <- "data/processed/01_imported_data.rds"

# 3. Vérification de l'existence du fichier brut et génération si absent (N = 800)
if (!file.exists(raw_data_path)) {
  warning("ATTENTION : Le fichier 'fsec_simulated_raw.csv' n'a pas encore été placé dans 'data/raw/'.")
  warning("Génération d'un jeu de données simulé réaliste de N = 800 ménages...")
  
  set.seed(2026) # Assure la reproductibilité exacte
  n_obs <- 800
  
  df_dummy <- tibble(
    hh_id = paste0("HH_", sprintf("%04d", 1:n_obs)),
    interview_date = Sys.Date() - sample(1:60, n_obs, replace = TRUE),
    enumerator_id = sample(c("ENV_001", "ENV_002", "ENV_003", "ENV_004", "ENV_005"), n_obs, replace = TRUE),
    cluster_zone = sample(c("cluster_Goma_Nord", "cluster_Goma_Sud", "cluster_Nyiragongo", "cluster_Masisi_Ref"), n_obs, replace = TRUE, prob = c(0.3, 0.3, 0.2, 0.2)),
    respondent_sex = sample(c("female", "male"), n_obs, replace = TRUE, prob = c(0.65, 0.35)),
    respondent_age = sample(18:75, n_obs, replace = TRUE),
    hh_size = sample(2:12, n_obs, replace = TRUE, prob = c(0.05, 0.1, 0.2, 0.25, 0.15, 0.1, 0.05, 0.04, 0.03, 0.02, 0.01)),
    children_u5 = sample(0:4, n_obs, replace = TRUE, prob = c(0.2, 0.4, 0.3, 0.08, 0.02)),
    
    # Scores de Consommation Alimentaire (FCS) - Fréquence sur 7 jours (0 à 7)
    fcs_cereals = sample(0:7, n_obs, replace = TRUE, prob = c(0.02, 0.03, 0.05, 0.1, 0.15, 0.2, 0.25, 0.2)),
    fcs_pulses = sample(0:7, n_obs, replace = TRUE),
    fcs_vegetables = sample(0:7, n_obs, replace = TRUE),
    fcs_fruits = sample(0:7, n_obs, replace = TRUE),
    fcs_meat_fish = sample(0:7, n_obs, replace = TRUE, prob = c(0.4, 0.2, 0.15, 0.1, 0.08, 0.04, 0.02, 0.01)),
    fcs_dairy = sample(0:7, n_obs, replace = TRUE),
    fcs_sugar = sample(0:7, n_obs, replace = TRUE),
    fcs_oil = sample(0:7, n_obs, replace = TRUE),
    
    # Stratégies d'adaptation réduite (rCSI) - Fréquence sur 7 jours (0 à 7)
    rcsi_less_preferred = sample(0:7, n_obs, replace = TRUE),
    rcsi_borrow_food = sample(0:7, n_obs, replace = TRUE),
    rcsi_limit_portion = sample(0:7, n_obs, replace = TRUE),
    rcsi_reduce_adults = sample(0:7, n_obs, replace = TRUE),
    rcsi_reduce_meals = sample(0:7, n_obs, replace = TRUE),
    
    # Diversité Alimentaire du Ménage (HDDS - Oui/Non)
    hdds_cereals = sample(c("yes", "no"), n_obs, replace = TRUE, prob = c(0.9, 0.1)),
    hdds_roots = sample(c("yes", "no"), n_obs, replace = TRUE, prob = c(0.7, 0.3)),
    hdds_vegetables = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_fruits = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_meat = sample(c("yes", "no"), n_obs, replace = TRUE, prob = c(0.3, 0.7)),
    hdds_eggs = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_fish = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_legumes_nuts = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_milk = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_oils = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_sweets = sample(c("yes", "no"), n_obs, replace = TRUE),
    hdds_spices = sample(c("yes", "no"), n_obs, replace = TRUE),
    
    # Échelle de Faim dans le Ménage (HHS)
    hhs_no_food_occ = sample(c("yes", "no"), n_obs, replace = TRUE, prob = c(0.4, 0.6)),
    hhs_no_food_freq = sample(c("rarely", "sometimes", "often"), n_obs, replace = TRUE),
    hhs_sleep_hungry_occ = sample(c("yes", "no"), n_obs, replace = TRUE, prob = c(0.3, 0.7)),
    hhs_sleep_hungry_freq = sample(c("rarely", "sometimes", "often"), n_obs, replace = TRUE),
    hhs_whole_day_occ = sample(c("yes", "no"), n_obs, replace = TRUE, prob = c(0.15, 0.85)),
    hhs_whole_day_freq = sample(c("rarely", "sometimes", "often"), n_obs, replace = TRUE)
  )
  
  dir.create("data/raw", showWarnings = FALSE, recursive = TRUE)
  write_csv(df_dummy, raw_data_path)
  message(paste0("--> Un jeu de données simulé de ", n_obs, " ménages a été créé dans 'data/raw/fsec_simulated_raw.csv'."))
}

# 4. Importation réelle et nettoyage des noms de colonnes
raw_data <- read_csv(raw_data_path, show_col_types = FALSE) %>%  
  clean_names()

# 5. Sauvegarde du fichier RDS intermédiaire
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
saveRDS(raw_data, output_rds_path)

message(paste0("--> Étape 01 terminée avec succès ! ", nrow(raw_data), " lignes importées et sauvegardées."))