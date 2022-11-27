# Power-Law-of-Crypto-and-NFT-Projects
This repository stores the R code for the estimation of the power law index for crytpocurrency and NFT projects, respectively. This code is used to estimate the strength of the power law which is further discussed in the publication "Cryptocurrency Investment DAOs As a New Venture Capital Platform: Power Law in Startup Returns". The paper is published in SSRN (link), and also uploaded in this github project.

# The Data
The data for both the crypto and NFT projects is already stored in the csv file pd_crytpo_nft_marketcaps.csv. 

For cryptocurrencies, I use the market capitalization data from CoinMarketCap as of 4/4/2022. For cryptocurrency projects, I queried and saved the top 1249 largest projects in terms of their market capitalization based on the circulating supply, measured in USD. For NFTs, I use the data of the top 100 collectible projects from OpenSea in terms of cumulative transacted volumes in ETH as of 4/4/2022. I think that cumulative transacted volumes in ETH are a more reliable measure of an NFT collectible’s overall valuation as they are directly indicative of the cashflows that they generate thanks to the perpetual royalties that flow to the NFT creators.

# Running the Code
After uploading the files to your own machine/platform, you will need to run the R script R_calculate_power_law_metrics.R. Before running the script, specify the path to your location where you saved the files and where you will write the output csv file (I use the same path for both). 

pPath <- "C:\\Users\\SPECIFY YOUR OWN PATH"

pFileReturns <- "pd_crypto_nft_marketcaps.csv"  

fileName <- paste(c(pPath,"\\", pFileReturns), collapse="")

dfMarketCaps <- read.csv(fileName)

# Purpose of the Code
The code calculates non-parametric estimates for the power law index using Hill's estimate and a more robust estimator as discussed in Beirlant et al (2005): “Estimation of the Extreme-Value Index and Generalized Quantile Plots.” For further details, you can refer to the research paper.
