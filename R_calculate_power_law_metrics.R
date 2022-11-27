
rm(list=ls())



##Start Script



castPricingDate             <- function( df, dateStr ){
  
  dates                 <- df[ , c( dateStr) ]
  #PricingDate           <- chron( as.character( dates ) )
  #PricingDate2 <- chron(as.character( dates), format = c(dates = "m/d/Y"))
  PricingDate3<-as.Date(as.character( dates), format = "%m/%d/%Y")
  
  df[ , c( dateStr) ]   <- PricingDate3
  df
  
}


auxCalcHills_k <- function(arrSorted, k, Tnobs){
  k_index <- Tnobs - k
  denominator <- arrSorted[k_index]
  numerators <- arrSorted[(k_index+1):Tnobs]
  logRatio <- log(numerators/denominator)
  hills <- sum(logRatio) / k
  
  hills  
}


auxCalcSquaredHills_k <- function(arrSorted, k, Tnobs){
  
  k_index <- Tnobs - k
  denominator <- arrSorted[k_index]
  numerators <- arrSorted[(k_index+1):Tnobs]
  logRatio <- log(numerators/denominator)^2
  squaredHills <- sum(logRatio) / k
  
  squaredHills  
}


auxCalcGamma_M_k <- function(arrSorted, k, Tnobs){
  
  # hills is the Hill's estimator of the power law index
  # gamma_M is the modification of the Hill's estimator discussed in Beirlant et al (2005) paper eqn (6) and following formulas
  
  hills <- auxCalcHills_k(arrSorted, k, Tnobs)
  squaredHills <- auxCalcSquaredHills_k(arrSorted, k, Tnobs)
  
  gamma_M <- hills + 1 - 0.5 * (1 / (1 - hills^2 / squaredHills ))
  gamma_M <- hills + 1 - 0.5 * (1 - hills^2 / squaredHills )^(-1)
  
  gamma_M
}


hillsEstimatorEyeBall <- function(arr){
  
  arrSorted <- sort(arr)
  Tnobs <- length(arrSorted)
  w <- ceiling(0.01*Tnobs)
  Tnobs_w <- Tnobs - w
  
  arr_k<-rep(0,Tnobs_w-1)
  arr_alpha_hills <- rep(0,Tnobs_w-1)
  arr_alpha_gamma_M <- rep(0,Tnobs_w-1)
  for(k in 2:Tnobs_w){
    hills_k<- auxCalcHills_k(arrSorted, k, Tnobs)
    gamma_m_k<- auxCalcGamma_M_k(arrSorted, k, Tnobs)
    arr_alpha_hills[k] <- 1/hills_k
    arr_alpha_gamma_M[k] <- 1/gamma_m_k
    arr_k[k] <- k
  }
  
  dfOut               <- data.frame( "k" = arr_k, "alpha_hills" = arr_alpha_hills, "alpha_gamma_M" = arr_alpha_gamma_M )
  
  dfOut  
}


library(chron)



# 1. GET DATA

# get crypto & NFT market cap data
# SPECIFY YOUR OWN PATH
pPath <- "C:\\Users\\SPECIFY YOUR OWN PATH"
pFileReturns <- "pd_crypto_nft_marketcaps.csv"  
fileName <- paste(c(pPath,"\\", pFileReturns), collapse="")
dfMarketCaps <- read.csv(fileName)


# 2. ESTIMATE POWER LAW INDEX FOR CRYPTO FROM RETURN DATA

# estimate power law index for crypto projects
thisSector = 'crypto'
thisVal <- dfMarketCaps[,c(thisSector)]
idx <- !is.na(thisVal)
thisVal<-thisVal[idx]

dfOut <- hillsEstimatorEyeBall(thisVal)
dfOut$ticker <- thisSector

# estimate power law index for nft projects
thisSector = 'nft'
thisVal <- dfMarketCaps[,c(thisSector)]
idx <- !is.na(thisVal)
thisVal<-thisVal[idx]

dfOut_tmp <- hillsEstimatorEyeBall(thisVal)
dfOut_tmp$ticker <- thisSector

dfOut <- rbind(dfOut, dfOut_tmp)


# 3. write to file
fileNameOut <- paste(c(pPath,"\\power_law_estimates.csv"), collapse = "")
write.csv(  dfOut , fileNameOut )














