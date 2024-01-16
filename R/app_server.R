#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  dataset <- golem::get_golem_options("dataset")
  mod_relevel_server("relevel_1", dataset)
}
