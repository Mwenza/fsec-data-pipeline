# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/04_calculate_indicators.R
# Auteur : Mwenza Bwira
# Description : Calcul des indicateurs standardisés FSL (FCS, rCSI, HDDS, HHS)
# ==============================================================================

# 1. Chargement des packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor)

message("--> Début de l'étape 04 : Calcul des indicateurs FSL...")

# 2. Chargement des données nettoyées
input_path <- "data/processed/02_cleaned_data.rds"
output_path <- "data/processed/04_indicators_data.rds"

if (!file.exists(input_path)) {
  stop("ERREUR : Le fichier de l'étape 02 est introuvable. Veuillez exécuter '02_clean_data.R' d'abord.")
}

data <- readRDS(input_path)

# 3. Calcul des Indicateurs FSL
indicators_data <- data %>%
  mutate(
    # A. Calcul du Food Consumption Score (FCS) avec pondérations standard PAM
    # Pondérations : Céréales(2), Légumineuses(3), Légumes(1), Fruits(1), Viande/Poisson(4), Lait(4), Sucre(0.5), Huile(0.5)
    fcs_score = (fcs_cereals * 2) + 
      (fcs_pulses * 3) + 
      (fcs_vegetables * 1) + 
      (fcs_fruits * 1) + 
      (fcs_meat_fish * 4) + 
      (fcs_dairy * 4) + 
      (fcs_sugar * 0.5) + 
      (fcs_oil * 0.5),
    
    # Catégories FCS standard PAM (Seuils : 0-21 = Pauvre, 21.5-35 = Limite, >35 = Acceptable)
    fcs_cat = case_when(
      fcs_score <= 21   ~ "Pauvre (Poor)",
      fcs_score <= 35   ~ "Limite (Borderline)",
      fcs_score > 35    ~ "Acceptable",
      TRUE              ~ "Inconnu"
    ),
    
    # B. Calcul du Reduced Coping Strategies Index (rCSI) avec pondérations standard
    # Moins préférés(1), Emprunter nourriture(2), Limiter portions(1), Réduire adultes pour enfants(3), Réduire nombre de repas(1)
    rcsi_score = (rcsi_less_preferred * 1) + 
      (rcsi_borrow_food * 2) + 
      (rcsi_limit_portion * 1) + 
      (rcsi_reduce_adults * 3) + 
      (rcsi_reduce_meals * 1),
    
    # C. Calcul du Household Dietary Diversity Score (HDDS) (Somme des 'yes' sur 12 groupes)
    hdds_score = (hdds_cereals == "yes") + (hdds_roots == "yes") + 
      (hdds_vegetables == "yes") + (hdds_fruits == "yes") + 
      (hdds_meat == "yes") + (hdds_eggs == "yes") + 
      (hdds_fish == "yes") + (hdds_legumes_nuts == "yes") + 
      (hdds_milk == "yes") + (hdds_oils == "yes") + 
      (hdds_sweets == "yes") + (hdds_spices == "yes")
  )

# 4. Sauvegarde des données avec indicateurs calculés
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
saveRDS(indicators_data, output_path)

message(paste0("--> Étape 04 terminée avec succès ! Indicateurs FSL calculés pour ", nrow(indicators_data), " ménages."))


# ---