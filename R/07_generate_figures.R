# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : R/07_generate_figures.R
# Auteur : Mwenza Bwira
# Description : Génération de graphiques et visualisations clés (N = 800)
# ==============================================================================

# 1. Chargement des packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor)

message("--> Début de l'étape 07 : Génération des graphiques analytiques...")

# 2. Chargement du dataset maître
input_path <- "outputs/fsec_master_dataset.csv"
output_fig_dir <- "outputs/figures/"

if (!file.exists(input_path)) {
  stop("ERREUR : Le dataset maître est introuvable. Veuillez exécuter '06_export_results.R' d'abord.")
}

data <- read_csv(input_path, show_col_types = FALSE)

# Création du dossier pour stocker les figures
dir.create(output_fig_dir, showWarnings = FALSE, recursive = TRUE)

# 3. Graphique 1 : Répartition des catégories de Score de Consommation Alimentaire (FCS) par zone
fcs_plot <- data %>%
  count(cluster_zone, fcs_cat) %>%
  group_by(cluster_zone) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ggplot(aes(x = cluster_zone, y = pct, fill = fcs_cat)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_brewer(palette = "RdYlGn", direction = 1) +
  labs(
    title = "Répartition des catégories de Sécurité Alimentaire (FCS)",
    subtitle = "Analyse par zone d'enquête (N = 800 ménages)",
    x = "Zone d'enquête",
    y = "Proportion des ménages",
    fill = "Catégorie FCS"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    axis.text.x = element_text(angle = 15, hjust = 1),
    legend.position = "bottom"
  )

# Sauvegarde du graphique 1
ggsave(filename = paste0(output_fig_dir, "fcs_distribution_by_zone.png"), plot = fcs_plot, width = 8, height = 5, dpi = 300)

# 4. Graphique 2 : Distribution de l'indice des stratégies d'adaptation (rCSI)
rcsi_plot <- data %>%
  ggplot(aes(x = rcsi_score, fill = cluster_zone)) +
  geom_histogram(binwidth = 2, alpha = 0.7, color = "white", position = "identity") +
  facet_wrap(~ cluster_zone, scales = "free_y") +
  labs(
    title = "Distribution de l'indice des stratégies d'adaptation (rCSI)",
    subtitle = "Comparaison inter-zones",
    x = "Score rCSI",
    y = "Nombre de ménages"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    legend.position = "none"
  )

# Sauvegarde du graphique 2
ggsave(filename = paste0(output_fig_dir, "rcsi_distribution.png"), plot = rcsi_plot, width = 9, height = 6, dpi = 300)

message("--> Étape 07 terminée avec succès ! Graphiques générés et enregistrés dans 'outputs/figures/'.")