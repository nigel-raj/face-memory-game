
library("shiny")

function(input, output, session) {
   output$myname <- renderText({
    paste("Victory Belongs to you ",input$nama)})
  
  start <- callModule(module = welcome, id = "welcome")
  timer <- callModule(module = time, id = "timer", start = start)
  
  hex_png <- sample(list.files(path = "www/hex/", pattern = "png$"), n_hex)
  hex_png <- sample(rep(hex_png, 2))
  
  results_mods <- reactiveValues()
  results_mods_parse <- reactiveValues(all = NULL, show1 = NULL, show2 = NULL, show3 = NULL)
  reset <- reactiveValues(x = NULL)
  block <- reactiveValues(x = NULL)
  
  lapply(
    X = seq_len(n_hex * 2),
    FUN = function(x) {
      results_mods[[paste0("module", x)]] <- callModule(module = hex,id = paste0("module", x),hex_logo = hex_png[x],reset = reset,block = block) 
      }
  )
  
  observe({
    res_mod <- lapply(
      X = reactiveValuesToList(results_mods), 
      FUN = reactiveValuesToList
    )
    results_mods_parse$all <- res_mod
    results_mods_parse$show1 <- which_show(res_mod, 1)
    results_mods_parse$show2 <- which_show(res_mod, 2)
    results_mods_parse$show3 <- which_show(res_mod, 3)
  })
  
  observeEvent(results_mods_parse$show2, {
    hex1 <- which_hex(results_mods_parse$all, results_mods_parse$show1)
    hex2 <- which_hex(results_mods_parse$all, results_mods_parse$show2)
    if (identical(hex1, hex2)) {
      block$x <- hex1
      showNotification(
        ui = tags$div(
          style = "font-size: 160%; font-weight: bold;",
          sample(
            x = c("Well done!", "Bravo!", "Great!", 
                  "Amazing!", "That's a match!"),
            size = 1
          )
        ), type = "message"
      )
    }  })
  
  observeEvent(results_mods_parse$show3, {
    reset$x <- which_hex(
      results_mods_parse$all,
      c(results_mods_parse$show1, results_mods_parse$show2)
    )
    results_mods_parse$show1 <- NULL
    results_mods_parse$show2 <- NULL
    results_mods_parse$show1 <- results_mods_parse$show3
    results_mods_parse$show3 <- NULL
  })
  
  
  observe({
    allfound <- all_found(results_mods_parse$all)
    if (isTRUE(allfound)) {
      showModal(modalDialog(
        tags$div(
          style = "text-align: center;",
          tags$h2(
            tags$span(icon("trophy"), style = "color: #F7E32F;"),
            "Well done!",
            tags$span(icon("trophy"), style = "color: #F7E32F;"),
              textOutput("myname"),
          ),
          tags$br(),
          tags$h5("You've found all matching faces in"),
          tags$h1(isolate(timer()), "seconds!"),
          tags$br(),
          if (isolate(timer()) < 70){
            style = "font-weight: bold,font-family:verdana; "
            tags$h5("You are a Genius because you have phenomenal memory power!")
          }
          else if (isolate(timer()) < 100){
            style = "font-weight: bold,font-family:verdana ; "
            tags$h5("You have great memory power. Keep it up!")
          }
          else if (isolate(timer()) < 120){
            style = "font-weight: bold,font-family:verdana; "
            tags$h5("You have good memory power. Practice more to improve your memory power")
          }
          else {
            style = "font-weight: bold ,font-family:verdana; "
            tags$h5("Play this Face Memory Game more frequently to improve your memory power")
          },
          
          if (isolate(timer()) < input$timeLimit){
            style = "font-weight: bold,font-family:verdana; "
            tags$h5("You completed it within the time limit!")
          }
          else{
            style = "font-weight: bold ,font-family:verdana; "
            tags$h5("You didn't complete it within the time limit. Set a lower time limit next time.")
          },

          actionButton(
            inputId = "reload",
            label = "Play again !",
            style = "width: 100%;"
          )
        ),
        footer = NULL,
        easyClose = FALSE
      ))
    }
  })
  
  
  observeEvent(input$reload, {
    session$reload()
  }, ignoreInit = TRUE)
  


  
}
