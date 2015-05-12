## ui.R ##
library(shinydashboard)

header <- dashboardHeader(title = "Basic dashboard")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", tabName = "widgets", icon = icon("th")),
    menuItem(htmlOutput("caseOpenRange")),
    menuItem(htmlOutput("nationalitySelector"))
    
  )
)

body <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "dashboard",            
            fluidRow(
              box(
                width = 4,
                title = "Gender", status = "primary", solidHeader = TRUE,
                plotOutput("gender")  
              ),
              box(
                width = 4,
                title = "Age", status = "primary", solidHeader = TRUE,
                plotOutput("age")  
              ),
              box(
                width = 4,
                title = "Nationality", status = "primary", solidHeader = TRUE,
                plotOutput("nationality")  
              )
            )
    ),
    
    # Second tab content
    tabItem(tabName = "widgets",
            h2("Widgets tab content")
    )
  )
)

ui <- dashboardPage(header, sidebar, body)