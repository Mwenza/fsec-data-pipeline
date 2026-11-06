# ==============================================================================
# Projet : FSEC Data Pipeline - Food Security & MEAL Analytics
# Fichier : dashboard/app.R
# Auteur : Mwenza Bwira
# Description : Tableau de bord R Shiny interactif pour le suivi de la sécurité alimentaire
# ==============================================================================

# 1. Chargement des packages nécessaires
if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, bslib, tidyverse, plotly, DT, janitor)

# 2. Chargement du dataset maître généré par le pipeline
# (Chemin ajusté selon l'emplacement du fichier app.R dans le dossier dashboard)
data_path <- "fsec_master_dataset.csv"

if (!file.exists(data_path)) {
  stop("ERREUR : Le dataset maître est introuvable. Veuillez exécuter le pipeline R d'abord.")
}

df <- read_csv(data_path, show_col_types = FALSE)

# 3. Interface Utilisateur (UI)
ui <- page_sidebar(
  title = "FSEC Analytics Dashboard | Nord-Kivu",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  sidebar = sidebar(
    title = "Filtres & Paramètres",
    
    # Filtre par Zone d'enquête
    selectInput(
      inputId = "zone_filter",
      label = "Sélectionner la zone :",
      choices = c("Toutes les zones" = "all", unique(df$cluster_zone)),
      selected = "all"
    ),
    
    # Filtre par Sexe du répondant
    selectInput(
      inputId = "sex_filter",
      label = "Sexe du répondant :",
      choices = c("Tous" = "all", "Femme" = "female", "Homme" = "male"),
      selected = "all"
    ),
    
    hr(),
    helpText("Données simulées basées sur les méthodologies PAM/FAO (N = 800 ménages).")
  ),
  
  # Contenu principal du Dashboard
  layout_column_wrap(
    width = 1/3,
    value_box(
      title = "Ménages enquêtés",
      value = textOutput("total_hh"),
      theme = "primary",
      icon = icon("house-user")
    ),
    value_box(
      title = "Score FCS Moyen",
      value = textOutput("mean_fcs"),
      theme = "info",
      icon = icon("bowl-food")
    ),
    value_box(
      title = "Score rCSI Moyen",
      value = textOutput("mean_rcsi"),
      theme = "warning",
      icon = icon("triangle-exclamation")
    )
  ),
  
  navset_card_tab(
    nav_panel(
      title = "Vue d'ensemble & Graphiques",
      layout_column_wrap(
        width = 1/2,
        card(
          card_header("Répartition des catégories FCS par zone"),
          plotlyOutput("fcs_plot")
        ),
        card(
          card_header("Distribution de l'indice rCSI"),
          plotlyOutput("rcsi_plot")
        )
      )
    ),
    nav_panel(
      title = "Données détaillées",
      card(
        card_header("Tableau maître des ménages"),
        DTOutput("table_data")
      )
    )
  )
)

# 4. Logique Serveur (Server)
server <- function(input, output, session) {
  
  # Données réactives filtrées selon les sélections de l'utilisateur
  filtered_data <- reactive({
    res <- df
    if (input$zone_filter != "all") {
      res <- res %>% filter(cluster_zone == input$zone_filter)
    }
    if (input$sex_filter != "all") {
      res <- res %>% filter(respondent_sex == input$sex_filter)
    }
    res
  })
  
  # Valeurs textuelles pour les Cartes (Value Boxes)
  output$total_hh <- renderText({
    nrow(filtered_data())
  })
  
  output$mean_fcs <- renderText({
    round(mean(filtered_data()$fcs_score, na.rm = TRUE), 1)
  })
  
  output$mean_rcsi <- renderText({
    round(mean(filtered_data()$rcsi_score, na.rm = TRUE), 1)
  })
  
  # Graphique 1 : FCS interactif avec Plotly
  output$fcs_plot <- renderPlotly({
    p <- filtered_data() %>%
      count(cluster_zone, fcs_cat) %>%
      group_by(cluster_zone) %>%
      mutate(pct = n / sum(n) * 100) %>%
      ggplot(aes(x = cluster_zone, y = pct, fill = fcs_cat)) +
      geom_bar(stat = "identity", position = "fill") +
      scale_y_continuous(labels = scales::percent_format()) +
      scale_fill_brewer(palette = "RdYlGn", direction = 1) +
      labs(x = "Zone", y = "Proportion", fill = "FCS Cat") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 15, hjust = 1))
    
    ggplotly(p)
  })
  
  # Graphique 2 : rCSI interactif avec Plotly
  output$rcsi_plot <- renderPlotly({
    p <- filtered_data() %>%
      ggplot(aes(x = rcsi_score, fill = cluster_zone)) +
      geom_histogram(binwidth = 2, alpha = 0.7, color = "white") +
      labs(x = "Score rCSI", y = "Nombre de ménages") +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(p)
  })
  
  # Tableau interactif DT
  output$table_data <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 10, scrollX = TRUE))
  })
}

# 5. Lancement de l'application Shiny
shinyApp(ui = ui, server = server)