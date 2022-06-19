library("shiny")
library("shinyWidgets")
library("shinythemes")

fluidPage(theme = shinythemes::shinytheme("united"),
  
  tags$head(
    tags$link(href="styles.css", rel="stylesheet", type="text/css"),
    tags$script(src = "http://platform.twitter.com/widgets.js"),
    includeHTML(path = "www/google-analytics.html")
  ),
  
  tags$div(
    class = "title-app",
    tags$h1("Face Memory Game"),
    tags$br(),
    tags$h4("Find all matching faces!"),
    setBackgroundImage(src = "https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&w=1080&fit=max&q=80&fm=jpg&crop=entropy&cs=tinysrgb", shinydashboard = FALSE)
  ),
  tags$br(),
  
  # verbatimTextOutput("test_res_show"),
  
  tags$div(
    style = "width: 650px; margin: auto;",
    time_UI("timer"),
    tags$br(),
    lapply(
      X = seq_len(n_hex * 2),
      FUN = function(x) {
        hex_UI(id = paste0("module", x))
      }
    )#,
    # verbatimTextOutput("test_res")
  )
  
)
