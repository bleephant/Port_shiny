
shinyServer(function(input, output) {
  
  # Overview
  output$usa_map <- renderPlot(
    ggplot(data=states, aes(x=long, y=lat))+
      xlab("") +
      ylab("") +
      theme_bw() +
      coord_map() +
      theme(axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.border = element_blank(),
            panel.grid.major = element_blank(),
            legend.position="none") +
      geom_polygon() +
      # geom_polygon(aes(group = group, fill = group))+
      geom_point(aes(x=-118.216458, y=33.754185, size=3, color='red')) +
      annotate("text", label = "Long Beach", x = -120, y = 32, size = 5, colour = "red")+
      geom_point(aes(x=-118.76205, y=34.029186, size=3, color='red')) +
      annotate("text", label = "Los Angeles", x = -120.5, y = 37, size = 5, colour = "red")+
      geom_point(aes(x=-81.151097, y=32.128705, size=3, color='red')) +
      annotate("text", label = "Savannah", x = -74, y = 31, size = 5, colour = "red")+
      geom_point(aes(x=-74.045556, y=40.668333, size=3, color='red')) +
      annotate("text", label = "NY/NJ", x = -70, y = 39, size = 5, colour = "red")
  )
  
  output$top_table <- renderTable(
    ttports %>%  
      group_by(Port) %>% 
      summarise("TEUs" = prettyNum(X2018.TEUs,big.mark=',')) %>% 
      arrange(., desc(TEUs))
    
  )
  output$info_table <- renderTable(
    info.ports %>%  
      group_by(Port) %>% 
      summarise("Top Import" = Top.Import,"Top Export" = Top.Export, "Top Trading Partners"=Top.Trading.Partners) 
  ) 
  
  output$summary_table <- renderTable(
    psummary %>%  
      group_by(Port) %>% 
      summarise("Peak Import Month" = Peak.Import.Month,"Peak Import Product" = Peak.Import.Product, "Peak Sales Month"=Peak.Sales.Month,
                "Time Delay" = Sales.Month...Import.Month) 
  ) 
  
  output$topTEU_interactive <- renderPlot( 
    ports_all %>% 
      filter(grepl(input$year_choice, year)) %>% 
      group_by(port) %>% 
      summarise(Annual_TEUs=sum(Total.TEUs)) %>% 
      ggplot(.,aes(x = port, y=Annual_TEUs)) + geom_bar(stat='identity', fill='red') +
      ylab("Total TEUs") + xlab("Port") + theme(legend.position="none") +ylim(0,1E7)
  )
  
  output$monthly_TEUs <- renderPlot(
    ports_all %>% 
      filter(., year>2014, year<2020) %>%
      group_by(., month, year) %>% 
      summarise(.,avg_totals=mean(Total.TEUs)) %>% 
      group_by(month) %>% 
      mutate(mean_totals = mean(avg_totals)) %>% 
      ggplot() + 
      geom_col(aes(x = month, y = avg_totals, fill = year), position = "dodge") +
      geom_point(aes(x = month, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
      ggtitle('Monthly TEUs 2015-2019') + #theme(legend.title=element_blank()) +
      xlab("Months") + ylab("Total Exports") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  
  output$annual_out <- renderPlot(
    ports_all %>%
      filter(.,port=='Long Beach') %>% 
      group_by(year) %>% 
      summarise(.,Annual_TEUs=sum(Total.TEUs)) %>% 
      ggplot(.,aes(x = year, y=Annual_TEUs)) + geom_bar(stat='identity', fill='blue')+
      scale_x_discrete("Year", labels = c(1995,'','','','',2000,'','','','',2005,'','','','',2010,'','','','',2015,'','','','',2020))+
      ylab("Annual TEUs (Long Beach)")
  )
  
  output$stock_out <- renderPlot(
    stocks %>% 
      ggplot()+
      geom_line(aes(x=day, y=Close), color='red') +
      scale_x_date(limit=c(as.Date("1995-01-01"),as.Date("2020-10-12")))+
      ylab("S&P500 Index")+
      xlab("Year")
  )
  
  output$port_balance <- renderPlot(    
    ports_all %>%
      filter(.,port=='Long Beach', (year>1994 & year<2020)) %>% 
      group_by(year) %>% 
      summarise(.,Annual_Balance=sum(Balance)) %>% 
      ggplot(.,aes(x = year, y=Annual_Balance)) + geom_bar(stat='identity', fill='blue')+
      scale_x_discrete("Year", labels = c(1995,'','','','',2000,'','','','',2005,'','','','',2010,'','','','',2015,'','','',''))+
      ylab("Exports - Imports TEUs (Long Beach)")
  )
  output$national_balance <-renderPlot(
    trade %>%
      filter(.,(year>1994 & year<2020)) %>% 
      ggplot(.,aes(x=year,y=balance))+ geom_bar(stat='identity', fill='red')+
      ylab("US Trade Imbalance Goods (millions $)")
  ) 
  
  output$trade_interactive <- renderPlot(
    ports_all %>% 
      filter(.,year>2016) %>%
      filter(port %in% c(input$checkGroup1)) %>%
      group_by(., port, year) %>% 
      summarise(.,total_bal=sum(Balance)) %>% 
      ggplot() + 
      geom_col(aes(x = year, y = total_bal, fill = port), position = "dodge") +
      ggtitle('Annual Trade Imbalance') + #theme(legend.title=element_blank()) +
      xlab("Years") + ylab("Exports - Imports (TEUs)") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  
  output$furniture_sales <- renderPlot(
    furn_sales %>% 
      filter(.,(year>2014 & year<2020)) %>%
      group_by(., month.name, year) %>% 
      summarise(.,avg_totals=mean(normsales)) %>% 
      group_by(month.name) %>% 
      mutate(mean_totals = mean(avg_totals)) %>% 
      ggplot() + 
      geom_col(aes(x = month.name, y = avg_totals, fill = year), position = "dodge") +
      geom_line(aes(x = month.name, y = mean_totals), size = 1.3,color = "red", group=1)+
      geom_point(aes(x = month.name, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
      ggtitle("Furniture Sales 2015-2019") + #theme(legend.title=element_blank()) +
      xlab("Months") + ylab("Furniture Sales (M$)") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  
  output$gas_sales <- renderPlot(
    gas_sales %>% 
      filter(.,(year>2014 & year<2020)) %>%
      group_by(., month.name, year) %>% 
      summarise(.,avg_totals=mean(normsales)) %>% 
      group_by(month.name) %>% 
      mutate(mean_totals = mean(avg_totals)) %>% 
      ggplot() + 
      geom_col(aes(x = month.name, y = avg_totals, fill = year), position = "dodge") +
      geom_line(aes(x = month.name, y = mean_totals), size = 1.3,color = "red", group=1)+
      geom_point(aes(x = month.name, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
      ggtitle("Gas Sales 2015-2019") + 
      xlab("Months") + ylab("Gas Sales (M$)") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  output$long_beach_imports <- renderPlot(
    ports_all %>% 
      filter(.,port=='Long Beach', (year>2014 & year<2020)) %>%
      group_by(., month, year) %>% 
      summarise(.,avg_totals=mean(Total.Imports)) %>% 
      group_by(month) %>% 
      mutate(mean_totals = mean(avg_totals)) %>% 
      ggplot() + 
      geom_col(aes(x = month, y = avg_totals, fill = year), position = "dodge") +
      geom_line(aes(x = month, y = mean_totals), size = 1.3,color = "red", group=1)+
      geom_point(aes(x = month, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
      ggtitle("Monthly Imports Long Beach 2015-2019") + 
      xlab("Months") + ylab("Imports (TEUs)") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  
  output$los_angeles_imports <- renderPlot(
    ports_all %>% 
      filter(.,port=='LA', (year>2014 & year<2020)) %>%
      group_by(., month, year) %>% 
      summarise(.,avg_totals=mean(Total.Imports)) %>% 
      group_by(month) %>% 
      mutate(mean_totals = mean(avg_totals)) %>% 
      ggplot() + 
      geom_col(aes(x = month, y = avg_totals, fill = year), position = "dodge") +
      geom_line(aes(x = month, y = mean_totals), size = 1.3,color = "red", group=1)+
      geom_point(aes(x = month, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
      ggtitle("Monthly Imports Los Angeles 2015-2019") + 
      xlab("Months") + ylab("Imports (TEUs)") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  
  output$port_export_interactive <- renderPlot( 
    ports_all %>%
      filter(grepl(input$port_choice, port)) %>% 
      filter(., (year>2014 & year<2020)) %>%
      group_by(., month, year) %>% 
      summarise(.,avg_totals=mean(Total.Exports)) %>% 
      group_by(month) %>% 
      mutate(mean_totals = mean(avg_totals)) %>% 
      ggplot() + 
      geom_col(aes(x = month, y = avg_totals, fill = year), position = "dodge") +
      geom_line(aes(x = month, y = mean_totals), size = 1.3,color = "red", group=1)+
      geom_point(aes(x = month, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
      ggtitle("Monthly Exports 2015-2019") + 
      xlab("Months") + ylab("Exports") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
  output$covid_imports <- renderPlot(
  ports_all %>% 
    filter(year %in% c(2019,2020)) %>%
    group_by(month, year) %>%
    summarise(tot_act = sum(Total.Imports)) %>%
    ggplot(aes(x = month, y = tot_act)) +
    geom_line(size = 1.3, aes(group = factor(year), color = factor(year))) +
    theme(legend.title=element_blank()) + 
    ggtitle("Comparison of Total Imports 2019 and 2020") + xlab("Months") + ylab("Imports (TEUs)")
  )
  
  output$covid_exports <- renderPlot(
    ports_all %>% 
      filter(year %in% c(2019,2020)) %>%
      group_by(month, year) %>%
      summarise(tot_act = sum(Total.Exports)) %>%
      ggplot(aes(x = month, y = tot_act)) +
      geom_line(size = 1.3, aes(group = factor(year), color = factor(year))) +
      theme(legend.title=element_blank()) + 
      ggtitle("Comparison of Total Exports 2019 and 2020") + xlab("Months") + ylab("Imports (TEUs)")
  )
  output$covid_TEUs <- renderPlot(
    ports_all %>% 
      filter(year %in% c(2019,2020)) %>%
      group_by(month, year) %>%
      summarise(tot_act = sum(Total.TEUs)) %>%
      ggplot(aes(x = month, y = tot_act)) +
      geom_line(size = 1.3, aes(group = factor(year), color = factor(year))) +
      theme(legend.title=element_blank()) + 
      ggtitle("Comparison of Total TEUs 2019 and 2020") + xlab("Months") + ylab("Imports (TEUs)")
  )
  
  output$port_import_interactive <- renderPlot( 
    ports_all %>%
      filter(grepl(input$port_choice2, port)) %>% 
      filter(.,year %in% c(2019,2020), month.num <9) %>%
      arrange(year) %>% 
      group_by(., month) %>%
      summarise(.,per_change=100*(Total.Imports-lag(Total.Imports))/Total.Imports) %>% 
      ggplot(.,aes(x = month, y=per_change)) + geom_bar(stat='identity', fill='blue') + 
      ggtitle("Percent Change Imports between 2020 and 2019") + 
      xlab("Months") + ylab("Change Imports (%)") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
  )
})
