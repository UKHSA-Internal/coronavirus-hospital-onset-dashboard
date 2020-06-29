# Define server logic required to draw a histogram
server <- function(input, output) {

    output$hist <- renderPlot({
        hist(rnorm(input$num))
    })
}
