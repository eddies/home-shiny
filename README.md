# home-shiny
A [Shiny](http://shiny.rstudio.com/) data dashboard for [HOME](http://home.org.sg/).

![home-shiny-screenshot](https://cloud.githubusercontent.com/assets/149985/7592340/65a908d6-f905-11e4-8530-414901cee5eb.png)

## Prerequisites

 * [r](http://cran.r-project.org/)
 * [shinydashboard](https://rstudio.github.io/shinydashboard/index.html)
 
Install R as you like: via the pre-built binaries for your system as linked to from above or via your system's package manager.

Once you have R installed and have an R console available, install the shinydashboard package (which should also install the `shiny` package as a dependency):

```r
install.packages("shinydashboard")
```

## Installation
### Clone the repo
```bash
git clone git@github.com:eddies/home-shiny.git
```

### Add data:
home-shiny expects two data files, `data/domestic.csv` and `data/non-domestic.csv`. 
These files are not included in the GitHub repo, for data privacy reasons.

You're done!

## Fire it up
From an R console with your working directory (`setwd(/path/to/home-shiny)`):
```r
runApp()
```
