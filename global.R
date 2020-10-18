library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(maps)

states= map_data("usa")

ports_all = read.csv('data/Ports_all.csv')
furn_sales = read.csv('data/furniture_all.csv')
gas_sales = read.csv('data/gas_salesA.csv')
stocks = read.csv('data/stocks.csv')
stocks$day = mdy(stocks$Date)
trade = read.csv('data/trade_total.csv')
ttports = read.csv("data/Top_ten_ports.csv")
info.ports = read.csv("data/Port_info.csv")
psummary = read.csv("data/peak_month_summary.csv")

ports_all$month=factor(ports_all$month, levels = c('Jan','Feb','Mar','April','May','June','July','Aug','Sep','Oct','Nov','Dec'))
furn_sales$month.name=factor(furn_sales$month.name, levels = c('Jan','Feb','Mar','April','May','June','July','Aug','Sep','Oct','Nov','Dec'))
gas_sales$month.name=factor(gas_sales$month.name, levels = c('Jan','Feb','Mar','April','May','June','July','Aug','Sep','Oct','Nov','Dec'))

gas_sales = gas_sales %>% mutate(year=as.character(year))
furn_sales = furn_sales %>% mutate(year=as.character(year))
ports_all = ports_all %>% mutate(year=as.character(year))


