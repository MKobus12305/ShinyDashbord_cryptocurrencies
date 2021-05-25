library(quantmod)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(DT)
library(tidyverse)
library(tidyquant)
library(lubridate)
library(readr)
library(plotly)
library(reactable)
library(RColorBrewer)
library(markdown)



bitcoin <- read_csv("data/coin_Bitcoin.csv")
bitcoin <- bitcoin[ -c(1:3)]
cryptocurrency <- rep("Bitcoin", nrow(bitcoin))
bitcoin <- cbind(bitcoin, cryptocurrency)

cardano <- read_csv("data/coin_Cardano.csv")
cardano <- cardano[ -c(1:3)]
cryptocurrency <- rep("Cardano", nrow(cardano))
cardano <- cbind(cardano, cryptocurrency)

ethereum <- read_csv("data/coin_Ethereum.csv")
ethereum <- ethereum[ -c(1:3)]
cryptocurrency <- rep("Ethereum", nrow(ethereum))
ethereum <- cbind(ethereum, cryptocurrency)

litecoin <- read_csv("data/coin_Litecoin.csv")
litecoin <- litecoin[ -c(1:3)]
cryptocurrency <- rep("Litecoin", nrow(litecoin))
litecoin <- cbind(litecoin, cryptocurrency)

tether <- read_csv("data/coin_Tether.csv")
tether <- tether[ -c(1:3)]
cryptocurrency <- rep("Tether", nrow(tether))
tether <- cbind(tether, cryptocurrency)

aave <- read_csv("data/coin_Aave.csv")
aave <- aave[ -c(1:3)]
cryptocurrency <- rep("Aave", nrow(aave))
aave <- cbind(aave, cryptocurrency)

binanceCoin <- read_csv("data/coin_BinanceCoin.csv")
binanceCoin <- binanceCoin[ -c(1:3)]
cryptocurrency <- rep("BinanceCoin", nrow(binanceCoin))
binanceCoin <- cbind(binanceCoin, cryptocurrency)

dogecoin <- read_csv("data/coin_Dogecoin.csv")
dogecoin <- dogecoin[ -c(1:3)]
cryptocurrency <- rep("Dogecoin", nrow(dogecoin))
dogecoin <- cbind(dogecoin, cryptocurrency)

eos <- read_csv("data/coin_EOS.csv")
eos <- eos[ -c(1:3)]
cryptocurrency <- rep("EOS", nrow(eos))
eos <- cbind(eos, cryptocurrency)

iota <- read_csv("data/coin_Iota.csv")
iota <- iota[ -c(1:3)]
cryptocurrency <- rep("Iota", nrow(iota))
iota <- cbind(iota, cryptocurrency)

monero <- read_csv("data/coin_Monero.csv")
monero <- monero[ -c(1:3)]
cryptocurrency <- rep("Monero", nrow(monero))
monero <- cbind(monero, cryptocurrency)

stellar <- read_csv("data/coin_Stellar.csv")
stellar <- stellar[ -c(1:3)]
cryptocurrency <- rep("Stellar", nrow(stellar))
stellar <- cbind(stellar, cryptocurrency)

tron <- read_csv("data/coin_Tron.csv")
tron <- tron[ -c(1:3)]
cryptocurrency <- rep("Tron", nrow(tron))
tron <- cbind(tron, cryptocurrency)

xrp <- read_csv("data/coin_XRP.csv")
xrp <- xrp[ -c(1:3)]
cryptocurrency <- rep("XRP", nrow(xrp))
xrp <- cbind(xrp, cryptocurrency)

# one dataframe
crypto_all <- union_all(bitcoin, ethereum)
crypto_all <- union_all(crypto_all, litecoin)
crypto_all <- union_all(crypto_all, cardano)
crypto_all <- union_all(crypto_all, tether)
crypto_all <- union_all(crypto_all, aave)
crypto_all <- union_all(crypto_all, binanceCoin)
crypto_all <- union_all(crypto_all, dogecoin)
crypto_all <- union_all(crypto_all, eos)
crypto_all <- union_all(crypto_all, iota)
crypto_all <- union_all(crypto_all, monero)
crypto_all <- union_all(crypto_all, stellar)
crypto_all <- union_all(crypto_all, tron)
crypto_all <- union_all(crypto_all, xrp)

crypto_all$Date <- strptime(crypto_all$Date, format='%Y-%m-%d')
crypto_list <- c('Bitcoin', 'Ethereum', 'Cardano', 'Litecoin', 'Tether', 'Aave', 'BinanceCoin', 'Dogecoin', 'EOS', 'Iota', 'Monero', 'Stellar', 'Tron', 'XRP')
