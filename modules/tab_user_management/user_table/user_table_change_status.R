user_table_change_status_ui <- function(id) {
  ns <- shiny::NS(id)

  as.character(
    shiny::actionButton(
      inputId = ns("change_status"),
      label = NULL,
      icon = shiny::icon("edit"),
      class = "primary",
      onclick = glue::glue(
        'Shiny.setInputValue(\"{inputId}\", this.id + Math.random())',
        inputId = ns("change_status")
      )
    )
  )
}

user_table_change_status_server <- function(id, .values, user_name, status) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      ns <- session$ns

      shiny::observeEvent(input$change_status, {
        if (user_name == .values$user_rvs$name) {
          shiny::showModal(shiny::modalDialog(
            easyClose = TRUE,
            title = "Access denied!",
            htmltools::div(
              "Administrators can't change their own status."
            ),
            footer = shiny::modalButton(
              label = NULL,
              icon = shiny::icon("window-close")
            )
          ))

          return()
        }

        shiny::showModal(shiny::modalDialog(
          title = "Change status",
          easyClose = TRUE,
          shiny::selectInput(
            inputId = ns("user_status"),
            label = "Status",
            choices = c(
              Administrator = "admin",
              Benutzer = "user"
            ),
            selected = status
          ),
          footer = shiny::actionButton(
            inputId = ns("confirm_status"),
            label = "Confirm"
          )
        ))
      })

      shiny::observeEvent(input$confirm_status, {
        shiny::removeModal()

        success <- db_set_user_status(.values$db, user_name, input$user_status)

        if (success) {
          bs4Dash::toast(
            title = paste0(
              "The status of user \"",
              user_name,
              "\" was succesfully changed to \"",
              .values$settings$status_dict[input$user_status],
              "\"."
            ),
            options = .values$settings$toast(
              class = "bg-success"
            )
          )
        } else {
          bs4Dash::toast(
            title = paste0(
              "The status of user \"",
              user_name,
              "\" couldn't be changed."
            ),
            options = .values$settings$toast(
              class = "bg-danger"
            )
          )
        }

        .values$update$db_user_rv(.values$update$db_user_rv() + 1)
      })
    }
  )
}
