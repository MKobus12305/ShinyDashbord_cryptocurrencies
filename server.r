server <- function(input, output) {
    
  output$picture <- renderImage({
    return(list(src = "needed_files/PP_logotyp.png",contentType = "image/png", width = "95%"))
  }, deleteFile = FALSE)

  
  # select cryptocurrency for basic data
  select_crypto <- eventReactive(input$go_basic, {
    crypto_name <- input$stock
    dates <- input$true_date
    
    df_crypto1 <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    
    df_crypto <- df_crypto1 %>%
      filter(Date>as.Date(dates[1]) & Date<as.Date(dates[2]))
    
    return(df_crypto)
  })
  
  # select cryptocurrencies for comparison
  select_cryptos <- eventReactive(input$go_comp, {
    
    crypto_name1 <- input$stock1
    crypto_name2 <- input$stock2
    
    dates1 <- input$true_date1
    
    df_crypto1 <- crypto_all %>% 
      filter(cryptocurrency == crypto_name1)
    
    df_crypto2 <- crypto_all %>% 
      filter(cryptocurrency == crypto_name2)
    
    df_crypto1_filtered <- df_crypto1 %>%
      filter(Date>as.Date(dates1[1]) & Date<as.Date(dates1[2]))
    
    df_crypto2_filtered <- df_crypto2 %>%
      filter(Date>as.Date(dates1[1]) & Date<as.Date(dates1[2]))
    
    final_data <- list("df1" =df_crypto1_filtered, "df2" = df_crypto2_filtered)
    
    return(final_data)
    
  })
  
  #time input
  output$timedate_data <- renderUI({
    crypto_name <- input$stock
    
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    
    min_time <- min(df$Date)
    max_time <- max(df$Date)
    dateRangeInput("true_date", "Analysis date",
                   end = max_time,
                   start = min_time,
                   min  = min_time,
                   max  = max_time,
                   format = "dd/mm/yy",
                   separator = " - ")
  })
  
  #time input for comparison
  output$timedate_comp <- renderUI({
    crypto_name1 <- input$stock1
    crypto_name2 <- input$stock2
    
    df1 <- crypto_all %>% 
      filter(cryptocurrency == crypto_name1)
    
    df2<- crypto_all %>% 
      filter(cryptocurrency == crypto_name2)
    
    
    min_time <- max(min(df1$Date), min(df2$Date))
    max_time <- min(max(df1$Date), max(df2$Date))
    
    dateRangeInput("true_date1", "Analysis date",
                   end = max_time,
                   start = min_time,
                   min  = min_time,
                   max  = max_time,
                   format = "dd/mm/yy",
                   separator = " - ")
  })
  
  
  #########drawing graphs (output)

  output$piechart_about <- renderPlotly({
    crypto_all$Date <- ymd(crypto_all$Date)
    marketcap_value <- subset(crypto_all, crypto_all$Date == "2021-02-27")

    plott <- plot_ly(crypto_all, labels = crypto_all$cryptocurrency, values = marketcap_value, name = 'Pie chart', 
            type = 'pie', hole=0.6)
    plott
    
  })
  
  output$Crypto_name <- renderValueBox({
    valueBox(
      input$stock, 
      subtitle = "Currency",
      icon = icon("coins"), 
      width = 20,
      color = "yellow"
    )
  })
  
  output$When_on_stock <-renderValueBox({
    crypto_name <- input$stock
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    min_time <- min(df$Date)
    min_time <- as.Date(min_time)
    valueBox(
      min_time,
      subtitle = "When first noted on the stock", 
      icon = icon("calendar-alt"),
      color = "orange"
    )
  })

  output$Min_value <-renderValueBox({
    df <- select_crypto()
    min_v <- min(df$Close, na.rm = TRUE)
    
    valueBox(
      paste0(round(min_v,digits=2),"$"),
      subtitle = "Minimum value", 
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  output$Max_value <-renderValueBox({
    df <- select_crypto()
    max_v <- max(df$Close, na.rm = TRUE)
    
    valueBox(
      paste0(round(max_v,digits=2),"$"),
      subtitle = "Maximum value", 
      icon = icon("arrow-up"),
      color = "green"
    )
  })
  
  output$Mean_value <-renderValueBox({
    df <- select_crypto()
    mean_v <- df %>% select(Close) %>% colMeans()
    
    valueBox(
      paste0(round(mean_v,digits=2),"$"),
      subtitle = "Mean value", 
      icon = icon("balance-scale-right"),
      color = "light-blue"
    )
  })
  
  
  output$price_basic_graph <- renderPlotly({
    df <- select_crypto()
    
    aux <- df$Close %>% na.omit() %>% as.numeric()
    aux1 <- min(aux)
    aux2 <- max(aux)
    
    df$Date <- ymd(df$Date)

    plot_ly(x = df$Date, y = df$Close, name = 'Close cryptocurrency prize at a given day', 
            type = 'scatter', mode = 'lines', color = "Set1")
    
  })
  
  output$volume_basic_hist <- renderPlotly({
    df <- select_crypto()
    aux <- df$Close %>% na.omit() %>% as.numeric()
    aux1 <- min(aux)
    aux2 <- max(aux)
    
    df$Date <- ymd(df$Date)

    plot_ly(x = df$Date, y=df$Volume, name = 'Volume of the cryptocurrency at a given day', 
            type = 'bar', color = "Set1")
    
  })
  
  output$price_comp_graph <- renderPlotly({
    
    df <- select_cryptos()
    
    dataframe1 <- df$df1
    dataframe2 <- df$df2
    
    aux <- dataframe1$Close %>% na.omit() %>% as.numeric()
    aux1 <- min(aux)
    aux2 <- max(aux)
    
    dataframe1$Date <- ymd(dataframe1$Date)
    dataframe2$Date <- ymd(dataframe2$Date)

    plott = plot_ly(x = dataframe1$Date, y = dataframe1$Close, name = dataframe1$cryptocurrency[1], 
                    type = 'scatter', mode = 'lines', color = "deepskyblue")
    plott = plott %>% add_trace(x = dataframe2$Date, y = dataframe2$Close, name = dataframe2$cryptocurrency[1],
                                type = 'scatter', mode = 'lines', color = "darkblue")
    
    plott = plott %>% layout(legend = list(orientation = 'h',
                                           yanchor="upper"))
    
    plott
    # add_trace(y = ~trace_1, name = 'trace 1', mode = 'lines+markers')
  })
  
  
  output$advanced <- renderPlotly({
    
    df <- select_crypto()
    Change <- ifelse(df$Open < df$Close, "Increasing", "Decreasing")
    df <- cbind(df, Change )
    df$Date <- ymd(df$Date)
    increase <- list(line = list(color = 'darkgreen'))
    decrease <- list(line = list(color = 'red'))
    
    candle_plot <- plot_ly(x = df$Date, showlegend = T,  name=df$cryptocurrency[1],
                           type="candlestick", showlegend = TRUE,
                           open = df$Open, close = df$Close,
                           high = df$High, low = df$Low,
                           increasing=increase, decreasing=decrease) %>%
      layout(legend = list(x = 0.1, y = 0.9))
    
    
    volume_plot <- plot_ly(x = df$Date, y = df$Volume, showlegend = T,
                           type ='bar',name="Volume",
                           color = df$Change,
                           colors = c('darkgreen','red')) %>%
      layout(yaxis = list(title = "Volume"))
    
    
    marketcap_plot <- plot_ly(x = df$Date, y = df$Marketcap, showlegend = T,
                              type ='bar', name="Marketcap", 
                              color = df$Change,
                              colors = c('darkgreen','red')) %>%
      layout(yaxis = list(title = "Market cap"))
    
    
    range_selector <- list(x = 0.75, y = 0.95, bgcolor = "fontcolor",
                           buttons = list(
                             list( count = 7,
                                   label = "Week",
                                   step = "day",
                                   stepmode = "backward"),
                             list( count = 1,
                                   label = "Month",
                                   step = "month",
                                   stepmode = "backward"),
                             list( count = 3,
                                   label = "3 Months",
                                   step = "month",
                                   stepmode = "backward"),
                             list( count = 6,
                                   label = "6 Months",
                                   step = "month",
                                   stepmode = "backward"),
                             list( count = 1,
                                   label = "1 Year",
                                   step = "year",
                                   stepmode = "backward"),
                             list( count = 1,
                                   label = "All",
                                   step = "all")))
    
    
    plott <- subplot(candle_plot, volume_plot, marketcap_plot,
                          heights = c(0.6,0.2,0.2), nrows=3, shareX = TRUE, titleY = TRUE) %>%
      layout(title =df$cryptocurrency[1],
             xaxis = list(rangeselector = range_selector))
    
    plott
  })
  
  output$Cryptos_1 <- renderValueBox({
    df <- select_cryptos()
    dataframe1 <- df$df1

    crypto_name <- dataframe1$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    min_time <- min(df$Date)
    min_time <- as.Date(min_time)
    
    valueBox(
      crypto_name, 
      subtitle = tags$p(paste("On stock since:", min_time), style = "font-size: 120%;"),
      icon = icon("coins"), 
      width = 20,
      color = "yellow"
      )
  })
  
  output$Cryptos_2 <- renderValueBox({
    df <- select_cryptos()
    dataframe2 <- df$df2
    
    crypto_name <- dataframe2$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    min_time <- min(df$Date)
    min_time <- as.Date(min_time)
    
    valueBox(
      crypto_name, 
      subtitle = tags$p(paste("On stock since:", min_time), style = "font-size: 120%;"),
      icon = icon("coins"), 
      width = 20,
      color = "yellow"
    )
  })
  
  output$Min_value_1 <-renderValueBox({
    df <- select_cryptos()
    dataframe1 <- df$df1
    
    crypto_name <- dataframe1$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    
    min_v <- min(df$Close, na.rm = TRUE)
    
    valueBox(
      paste0(round(min_v,digits=2),"$"),
      subtitle = "MIN value", 
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  output$Max_value_1 <-renderValueBox({
    df <- select_cryptos()
    dataframe1 <- df$df1
    
    crypto_name <- dataframe1$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    max_v <- max(df$Close, na.rm = TRUE)
    
    valueBox(
      paste0(round(max_v,digits=2),"$"),
      subtitle = "MAX value", 
      icon = icon("arrow-up"),
      color = "green"
    )
  })
  
  output$Mean_value_1 <-renderValueBox({
    df <- select_cryptos()
    dataframe1 <- df$df1
    
    crypto_name <- dataframe1$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    mean_v <- df %>% select(Close) %>% colMeans()
    
    valueBox(
      paste0(round(mean_v,digits=2),"$"),
      subtitle = "MEAN value", 
      icon = icon("balance-scale-right"),
      color = "light-blue"
    )
  })
  
  output$Min_value_2 <-renderValueBox({
    df <- select_cryptos()
    dataframe2 <- df$df2
    
    crypto_name <- dataframe2$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    
    min_v <- min(df$Close, na.rm = TRUE)
    
    valueBox(
      paste0(round(min_v,digits=2),"$"),
      subtitle = "MIN value", 
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  output$Max_value_2 <-renderValueBox({
    df <- select_cryptos()
    dataframe2 <- df$df2
    
    crypto_name <- dataframe2$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    max_v <- max(df$Close, na.rm = TRUE)
    
    valueBox(
      paste0(round(max_v,digits=2),"$"),
      subtitle = "MAX value", 
      icon = icon("arrow-up"),
      color = "green"
    )
  })
  
  output$Mean_value_2 <-renderValueBox({
    df <- select_cryptos()
    dataframe2 <- df$df2
    
    crypto_name <- dataframe2$cryptocurrency[1]
    df <- crypto_all %>% 
      filter(cryptocurrency == crypto_name)
    mean_v <- df %>% select(Close) %>% colMeans()
    
    valueBox(
      paste0(round(mean_v,digits=2),"$"),
      subtitle = "MEAN value", 
      icon = icon("balance-scale-right"),
      color = "light-blue"
    )
  })

  output$volume_comp_hist <- renderPlotly({
    
    df <- select_cryptos()
    
    dataframe1 <- df$df1
    dataframe2 <- df$df2
    
    aux <- dataframe1$Close %>% na.omit() %>% as.numeric()
    aux1 <- min(aux)
    aux2 <- max(aux)
    
    dataframe1$Date <- ymd(dataframe1$Date)
    dataframe2$Date <- ymd(dataframe2$Date)

    plott = plot_ly(x = dataframe1$Date, y = dataframe1$Volume, name = dataframe1$cryptocurrency[1], 
                    type = 'scatter', mode = 'lines',fill = 'tozeroy',  color = "deepskyblue")
    
    plott = plott %>% add_trace(x = dataframe2$Date, y = dataframe2$Volume, name = dataframe2$cryptocurrency[1],
                                type = 'scatter', mode = 'lines', fill = 'tozeroy', color = "deepblue" )
    
    plott = plott %>% layout(legend = list(orientation = 'h',
                                           yanchor="upper"))
    
    plott
  })
  
  
  output$mytable <- renderDataTable({
    crypto_all
  })

}
