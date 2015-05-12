## server.R ##
library(shiny)

# Load data
loadCsv <- function(csv) {
  # first pass
  df <- read.csv(csv, header = T)
  colClasses <- sapply(df, class)
  
  # get the column names
  col_names <- colnames(df)
  
  # Assuming datetime format like 2011-01-01 16:10:10  
  setClass('myDateTime')
  setAs("character","myDateTime", function(from) as.POSIXlt(from, format="%Y-%m-%d %T") )
  
  setClass('myDate')
  setAs("character","myDate", function(from) as.Date(from, format="%Y-%m-%d") )
  
  myDateTime_cols <- match(c("case_opening_dt", "case_closing_dt", "created_on", 
                             "modified_on", "sg_arrival_date"), col_names)
  myDate_cols <- match(c("start_working_dt"), col_names)
  
  # Now swap in our 'correct' column classes
  colClasses[myDateTime_cols] <- "myDateTime"
  colClasses[myDate_cols] <- "myDate"
  
  # read in the data using our specified colClasses
  df <- read.csv(csv, header = T, colClasses = colClasses)
  return(df)
}

df_d <- loadCsv('data/domestic.csv')
case_open_dates <- sort(df_d$case_opening_dt)
case_open_start <- case_open_dates[1]
case_open_end <- case_open_dates[length(case_open_dates)]
rm(case_open_dates)
sorted_natl <- sort(levels(df_d$natl_code))

shinyServer <- function(input, output) {
  # Gender Pie Chart
  gender_chart <- function() {
    df <- dataInput()
    slices <- table(df$gender)
    lbls <- names(slices)
    pct <- round(slices/sum(slices)*100)
    lbls <- paste(lbls, pct) # add percents to labels
    lbls <- paste(lbls,"%",sep="") # add % to labels
    tryCatch(
      pie(slices, labels = lbls, col = c("pink", "lightblue")),
      error = function(e) plot.new()
    )
  }
  
  # Age Histogram
  age_chart <- function() {
    df <- dataInput()
    current_year <- as.numeric(format(Sys.Date(), "%Y"))
    ages <- current_year - na.omit(df$birth_dt)
    tryCatch(
      hist(ages, xlab="Age", col = "blue", main = ""),
      error = function(e) plot.new()
    )
  }
  
  # Nationality
  natl_chart <- function() {
    df <- dataInput()
    natl_counts <- tail(sort(table(df$natl_code)), 5)
    tryCatch(
      barplot(natl_counts, horiz = TRUE, col = rainbow(length(natl_counts))),
      error = function(e) plot.new()
    )
  }

  ##
  dataInput <- reactive({
    if (is.null(input$case_open)) {
      case_open_range <- c(case_open_start, case_open_end)
    } else {
      case_open_range <- input$case_open
    }
    
    df <- df_d[df_d$case_opening_dt >= as.POSIXlt(case_open_range[1]) & 
               df_d$case_opening_dt <= as.POSIXlt(case_open_range[2]), ]

    natl_code <- input$natl_code
    if (!is.null(natl_code)) {
      df <- df[df$natl_code == natl_code, ]
    }
    return(df)
  })
  
  output$caseOpenRange <- renderUI({
    dateRangeInput("case_open", "Case Opening Range:", start = case_open_start, 
                   end = case_open_end, startview = "year")
  })
  
  output$nationalitySelector <- renderUI({
    selectizeInput("natl_code", "Nationality", sorted_natl, multiple = TRUE)
  })
  
  output$gender <- renderPlot({
    gender_chart()
  })
  
  output$age <- renderPlot({
    age_chart()
  })
  
  output$nationality <- renderPlot({
    natl_chart()
  })
}