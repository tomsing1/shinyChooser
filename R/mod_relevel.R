#' relevel UI Function
#'
#' @description A shiny Module that allows users to interactively relevel
#' factors
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_relevel_ui <- function(id, levels){
  ns <- NS(id)
  tagList(
    bslib::card(
      bslib::card_header("Reorder factors"),
      bslib::layout_column_wrap(
        width = 1/2, height = 200,
        bslib::card(
          min_height = 200,
          selectInput(NS(id, "covariate"),
                      label = "Covariates",
                      choices = c(""))
        ),

        bslib::card(
          min_heigth = 200,
          uiOutput(NS(id, "chooser"))
        )
      ),
      bslib::card(
        verbatimTextOutput(NS(id, "reordered"))
      )
    )
  )
}

#' relevel Server Functions
#'
#' @noRd
mod_relevel_server <- function(id, dataset){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # identify all factors in the dataset
    covariates <- reactive({
      colnames(dataset)[vapply(dataset, is.factor, logical(1))]
    })

    observeEvent(covariates, {
      updateSelectInput(inputId = "covariate", choices = covariates())
    })

    available_levels <- reactive({
      req(input$covariate)
      base::levels(dataset[[input$covariate]])
    })
    # update chooser with the available factor levels for this covariate
    output$chooser <- renderUI({
      chooserInput(NS(id, "levels"),
                   "Available levels",
                   "Selected levels",
                   available_levels(),
                   c(),
                   size = 5,
                   multiple = TRUE
      )
    })
    reordered_levels <- reactive({
      c(input$levels$right, setdiff(available_levels(), input$levels$right))
    })
    output$reordered <- renderPrint(reordered_levels())

  })
}

## To be copied in the UI
# mod_relevel_ui("relevel_1")

## To be copied in the server
# mod_relevel_server("relevel_1")

