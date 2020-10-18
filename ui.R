shinyUI(dashboardPage(
  dashboardHeader(title = 'Container Port Analysis'),
  dashboardSidebar(sidebarMenu(
    menuItem('Introduction', tabName = "intro", icon = icon('info')),
    menuItem("Overview", tabName = "overview", icon = icon("calendar")),
    menuItem("National Trends", tabName = "national", icon = icon("flag-usa")),
    menuItem("Sales Data", tabName = "sales", icon = icon("dollar-sign")),
    menuItem("COVID-19 Impact", tabName = "corona", icon = icon("briefcase-medical")),
    menuItem('About Me', tabName = "me", icon = icon("smile"))
  )),
  dashboardBody(tabItems(
    tabItem(tabName = "intro", 
            fluidPage(
              fluidRow(box(width = 10, h1(tags$b("Container Port Traffic Monitoring")))),
              br(),
              fluidRow(
                box(width = 10,
                  p("For this project, I analyzed the import and export traffic at the top four container ports in the United States. Container ports
                    are centers for transferring containers of imported and exported products between large ocean vessels and trucks or trains 
                    for inland transport. Most container ports provide monthly figures for imported and exported containers on their websites, differentiating between
                    empty and full containers. The unit of measure is the TEU or Twenty-Foot Equivalent Unit.  This is the size of a standard 20 foot 
                    shipping container (20 feet long and 8 feet tall). Collections of containers are shown in the photo."), 
                  div(img(src = "containers.png", height=200),style='text-align:center'))
              ),
              fluidRow(
                box(width = 10, h2(tags$b("Goals")), background = "green", 
                    p("The goals of the project were to explore the relationship between container port traffic and other useful economic indicators
                      such as sales, stock prices, and national trade figures.  Because of the long times and complicated logistics involved in 
                      ocean travel, port traffic provides a snapshot of the consensus of what demand will be for the shipped products 2-4 months in
                      the future. This can be useful in making pricing and space allocation predictions. Port traffic can also be disrupted by local,
                      national and international crisis, such as hurricanes, floods, or pandemics (eg., COVID) and this will also impact demand and
                      pricing.")) 
              ), 
              fluidRow(
                       box(width = 10, h2(tags$b("Conclusions")), background = "navy", 
                           p("The data show a strong correlation between container port traffic and national econonic indicators, with variations due
                             to the types of products being shipped through each port. Monthly variations in port traffic do in fact correlate with 
                             national sales numbers for shipped products, with a time lag of 2-4 months. Finally, the impact of COVID can be clearly 
                             observed in the port traffic, with a steep drop in trade followed by a equally sharp recovery."), 
                           br(), div(img(src = "vessel.png", width="425px",height="250px",style='text-align:center;')), br(), br(), 
                           p("Future work includes the possibility of tracking vessel traffic from top trading partner countries in order to predict container port congestion
                             and provide a more up-to-date measure of trade figures."))
              )
            )
    ),
    tabItem(tabName= 'overview',
            fluidPage(
              h2("Ports Included in this Study"),
              box(width = 8, p("The top four ports in terms of total TEUs transported were chosen for the study: Los Angeles, Long Beach, NYC/NJ, and Savannah.
                                 As shown in the table below, each port has different top export and import products and this impacts traffic 
                                 flow. China is the top trading partner for each port, while the east coast ports do more trade with Europe. Top exports
                                 are typically wood, paper, or agricultural products.")),
              fluidRow(
                box(width = 8, plotOutput("usa_map",width="375px",height="250px"),h4("Map showing the location of ports used in this study. 
                                                                                     Both west coast and east coast ports were used. Los Angeles
                                                                                     Long Beach are sometimes considered one large port but have 
                                                                                     different import/export characteristics and report their traffic 
                                                                                     numbers seperately.")),
                box(width = 4, background = "yellow", align = "center",
                    h4(tags$b("Top Ten Ports (2018)")), br(), tableOutput('top_table'))
                
              ),
              h2("Port Information"),
              fluidRow(
                box(width=11, background = "light-blue", tableOutput('info_table'))
              ),
              fluidRow(h2("Single Year Total TEUs for Top Ports")),
              fluidRow(
                selectInput("year_choice", label = h4("Select Year"),
                            choices = list("2020" = 2020, "2019" = 2019, "2018" = 2018, "2017" = 2017, "2016" = 2016, "2015" = 2015),
                            selected="2019"),
                box(width = 12, plotOutput("topTEU_interactive"), title="The Ranking of Ports Unchanged over Multiple Years")
              ),
              h2("Monthly Total TEUs"),
              fluidRow(
                box(width=11, plotOutput("monthly_TEUs"), title = "Container Port Trade Peaks in July, August, January")
              )
            )
            ),
    tabItem(tabName= 'national',
            fluidPage(
              h2("Comparing Port Traffic with US Data: Stocks Prices and Trade"),
              
              fluidRow(
                box(width = 10, background = "light-blue",
                    h4(tags$b("Strong Correlation between Port Traffic and National Indicators")), 
                    p("It is not obvious that local port traffic should be a strong indicator of what is happening in the country as a whole.
                                Here it is shown, however, that the traffic at an individual port (Long Beach)matches with the S&P 500 
                                closing price when plotted over a long period of time (1995-2020).  Recessions occuring in 2002 and 2008 are 
                                clearly observed. The US trade imbalance as reported by the US government also correlates well with the 
                      Total Exports - Total Imports of containers coming into an indiviudal port.  As shown below, the trade imabalance 
                      varies between different ports.  Further analysis is needed to determine the products where the trade imbalance is highest.")),
                tabBox(width=8,
                       tabPanel("Stocks", plotOutput("annual_out"),
                                plotOutput("stock_out")
                       ),
                       tabPanel("Trade", plotOutput("port_balance"),
                                plotOutput("national_balance")
                       )
                )

                ),
              h2("Annual Trade Imbalance for Individual Ports"),
              fluidRow(
                box(width = 8, plotOutput("trade_interactive")),
                box(width = 4, align = "center", checkboxGroupInput("checkGroup1", label = h3("Ports"),
                                                                    choices = list("Los Angeles" = "LA",  "NYC/NJ" = "NYC", "Long Beach",
                                                                                   "Savannah"), selected = c("LA", "Long Beach", "NYC","Savannah")))
              )
            )
    ),
    tabItem(tabName= 'sales',
            fluidPage(
              h2("Comparing Port Imports with Sales Figures"),
              fluidRow(
                box(width = 10, background = "light-blue",
                    h4(tags$b("Port Imports Reach Peak Prior to Sales")), 
                    p("The plots below show the variation in imports by month for Los Angeles and Long Beach. Monthly figures are averaged 
                      over the last five years. This is compared with monthly variation in sales for top import products for the two ports: furntiure sales
                      for Los Angeles and gasoline sales for Long Beach. In both cases it can be seen that imports reach their peak 2-4 months prior to sales.
                      This shows how port traffic is a leading indicator for future product sales. Given further time a quantitative correlation between port 
                      traffic and sales data should be calculated.")),
                tabBox(width=8,
                       tabPanel("Los Angeles", plotOutput("los_angeles_imports"),
                                plotOutput("furniture_sales")
                       ),
                       tabPanel("Long Beach", plotOutput("long_beach_imports"),
                                plotOutput("gas_sales")
                       )
                )),
              h2("Import Peak Proceeds Sales Peak"),
              fluidRow(
                box(width=11, background = "light-blue", tableOutput('summary_table'))
              ),
              fluidRow(
                box(width = 12, background = "light-blue",
                    h4(tags$b("Port Exports Show Small Monthly Variation")), 
                    p("Variation in exports by month is plotted allowing selection of the port.  In general, there is less monthly 
                      variation in exports than in imports.  This is presumably because agricultural products have a smaller seasonal variation
                      in usage than consumer products or petroleum.")),
                h2("Monthly Exports for Top Ports")),
              fluidRow(
                selectInput("port_choice", label = h4("Select Port"),
                            choices = list("Los Angeles" = "LA", "Long Beach", "NYC/ NJ" = "NYC",  "Savannah"),
                            selected="Los Angeles"),
                box(width = 12, plotOutput("port_export_interactive"), title="Small Monthly Variation in Exports")
              )
            )
            ),
    tabItem(tabName = 'corona',
            fluidPage(
              h2("Impact of COVID on Port Traffic"),
              fluidRow(
                box(width = 12, background = "light-blue",
                    h4(tags$b("COVID Impact Clearly Observed in Port Traffic")), 
                    p("Port traffic dropped precipitously in March 2020 due to the pandemic. This is observed in both import and export data. 
                      The time resolution is not fine enough to distinguish between the different stages of the pandemic when the data is 
                      summarized between all four ports.  Individual ports show some interesting differences. Los Angeles and Savannah experienced a recovery
                      in April, but then dropped again before recovering completely. NYC did not experience a major drop until May.  This is presumably 
                      becuase of the relatively large number of European trading partners with NYC, and the later onset of the virus in Europe compared 
                      with China.")),
                tabBox(width=8,
                       tabPanel("Imports",plotOutput("covid_imports")),
                       tabPanel("Exports",plotOutput("covid_exports")),
                       tabPanel("TEUs",plotOutput("covid_TEUs"))
                )
              ),
              fluidRow(h2("Change in Imports Due to COVID: Individual Ports")),
              fluidRow(
                selectInput("port_choice2", label = h4("Select Port"),
                            choices = list("Los Angeles" = "LA", "Long Beach", "NYC/ NJ" = "NYC",  "Savannah"),
                            selected="Los Angeles"),
                box(width = 12, plotOutput("port_import_interactive"), title="Drop and Recovery in Imports due to COVID")
              )
            )),
    tabItem(tabName = 'me',
            fluidPage(
              h2("About Me"),
              br(),
              fluidRow(
                column(8, box(width = 10,
                    p(tags$b("Bruce Alphenaar")),
                    p("linkedin.com/in/brucealphenaar"), 
                    p("github.com/bleephant"),
                    p("Ph.D. in Applied Physics, Yale University. Expertise in materials science, semiconductors, advanced manufacturing. "), 
                    )),
                column(4, 
                       div(img(src = "bruce.png", height="200px" ),style='text-align:left'))
              )
                
            )
  )
  )          
  )
)
)

    