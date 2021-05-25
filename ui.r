header <- dashboardHeader(title = "Cryptocurrency dashboard")

sidebar <- dashboardSidebar(
  sidebarMenu(width=200,
              menuItem("About", tabName = 'about', icon = icon("address-card")),
              menuItem("Help", tabName = 'help', icon = icon("life-ring")),
              menuItem("Basics", tabName = 'data', icon = icon("chart-line")),
              menuItem('Compare cryptocurrencies', tabName = 'comp', icon = icon("chart-bar")),
              menuItem("Datatable", tabName = 'datatable', icon = icon("th-list"))
  )
)

body <- dashboardBody(
  tabItems(
    #About
    tabItem(tabName = 'about',
            
            fluidRow(
              box(width = 12,
                  imageOutput("picture")),
              box(width = 12,
                includeMarkdown("needed_files/aboutProject.md"))
            ),
            fluidRow(
              box(title = "Marketcap of the currencies in February 2021", width = 12, solidHeader = TRUE,
                  plotlyOutput('piechart_about')
              )
            ),
            fluidRow(
              box(width = 12,
                  includeMarkdown("needed_files/aboutUs.md"))
            ),
    ),
    
    
    #Help 
    tabItem(tabName = 'help',
            
            fluidRow(
              box(width = 12,
                  includeMarkdown("needed_files/help.md"))
            ),
    ),
    
    #Basic Data
    tabItem(tabName = 'data',
            fluidRow(
              box(title = 'Select the currency', width=12, solidHeader = TRUE, status='primary', color = 'blue',
                  selectInput('stock', 'cryptocurrency', crypto_list, multiple=FALSE),
                  uiOutput("timedate_data"),
                  helpText("Note: The plots and analysis will be visible after choosing the currency and the timeframe and clicking 'Apply' button"),
                  actionButton('go_basic', 'Apply')
              )
            ),
            
            
            fluidRow(
              valueBoxOutput("Crypto_name", width = 6),
              infoBoxOutput("When_on_stock", width = 6)
            ),
            
            fluidRow(
              valueBoxOutput("Min_value"),
              valueBoxOutput("Max_value"),
              valueBoxOutput("Mean_value")
            ),
            
            fluidRow(
              box(title = "Closing Price graph", width = 12, solidHeader = TRUE,
                  plotlyOutput('price_basic_graph')
              )
            ),
            
            fluidRow(
              box(title = "Histogram (Volume)", width = 12, solidHeader = TRUE,
                  plotlyOutput('volume_basic_hist')
              )
            ),
            fluidRow(
              box(title = "Advanced analysis", hight = "200%", width = 12, solidHeader = TRUE,
                  plotlyOutput('advanced')
              )
            ),
            
    ),
    #Compare cryptocurrencies 
    tabItem(tabName = 'comp',
            fluidRow(
              box(title = 'Select the currencies', width=12, solidHeader = TRUE, status='primary',
                  selectInput('stock1', 'cryptocurrency 1', crypto_list, multiple=FALSE),
                  selectInput('stock2', 'cryptocurrency 2', crypto_list, multiple=FALSE),
                  uiOutput("timedate_comp"),
                  helpText("Note: The plots and analysis will be visible after choosing the currencies,the timeframe and clicking 'Apply' button"),
                  actionButton('go_comp', 'Apply')
              )
            ),
            fluidRow(
              valueBoxOutput("Cryptos_1", width = 6),
              valueBoxOutput("Cryptos_2", width = 6)
            ),
            
            fluidRow(
              column(width = 6,
                     valueBoxOutput("Min_value_1"),
                     valueBoxOutput("Max_value_1"),
                     valueBoxOutput("Mean_value_1")
              ),
              column(width = 6,
                     valueBoxOutput("Min_value_2"),
                     valueBoxOutput("Max_value_2"),
                     valueBoxOutput("Mean_value_2")
              )
            ),
            
            fluidRow(
              box(title = "Closing Price graph", width = 12, solidHeader = TRUE,
                  plotlyOutput('price_comp_graph')
              )
            ),
            fluidRow(
              box(title = "Histogram (Volume)", width = 12, solidHeader = TRUE,
                  plotlyOutput('volume_comp_hist')
              )
            ),
    ),
    #Datatable 
    tabItem(tabName = 'datatable',
            dataTableOutput("mytable")
    )
  )
)

ui <- dashboardPage(
  skin = 'blue',
  header, sidebar, body)