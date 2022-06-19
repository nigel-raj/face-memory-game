

# Welcome module ----------------------------------------------------------


welcome_UI <- function(id) {
  ns <- NS(id)
  modalDialog(
    title = tags$h1(
      style = "text-align: center;",
      "Face Memory Game"
    ),

    setBackgroundImage(src = "https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&w=1080&fit=max&q=80&fm=jpg&crop=entropy&cs=tinysrgb", shinydashboard = FALSE),
    tags$div(tags$h4(textInput("nama","Enter Name:",""), sliderInput("timeLimit", "Time limit (seconds):",
                                                                     min = 0, max = 100,
                                                                     value = 70), style = "text-align: justify;", "About:"),
                         
            ),
    
    tags$ul(
      style = "text-align: justify; font-size:1.18em",
      tags$li("Human memory is often likened to that of a computer memory system or a filing cabinet. But in fact, memory is far from perfect - most people do not remember every single thing that has happened to them, and memories are often changed and can become distorted."),
      tags$br(),
      tags$li("Memory strength is just like muscular strength. The more you use it, the stronger it gets. But you can't lift the same size weight every day and expect to get stronger. You'll need to keep your brain constantly challenged."),
      tags$br(),
      tags$li("This simple face memory game not only improves your ability to remember faces, but really teaches you to pay attention to detail. After all, you can't remember something if you never fully noticed it in the first place."),
      tags$br(),
      tags$li("This game enables critical thinking and that helps children nurture their attention to detail. Memory games can improve visual recognition. With many memory games based on spotting differences, or linking two related images, children improve their visual discrimination.")
    ), 
    footer = actionButton(
      inputId = ns("play"),
      label = "Play !",
      icon = icon("play"),
      style = "width: 100%"
    ),
  )
}

welcome <- function(input, output, session) {
  
  id <- gsub("-$", "", session$ns(""))
  showModal(ui = welcome_UI(id))
  
  observeEvent(input$play,{
   showModal(modalDialog(
     tags$div(tags$h3(style = "text-align: justify;", "Instructions:"), tags$br(),),
     tags$ol(
       style = "text-align: justified; font-size:1.18em",
       tags$li("Find all matching faces as soon as possible."),
       tags$li("Click on a face to reveal it."),
       tags$li("You can only have two faces revealed at the same time."),
       tags$li("When you're ready, click the button below to play."),
     )
   ))
  })
  


  
  return(reactive(input$play))
}

