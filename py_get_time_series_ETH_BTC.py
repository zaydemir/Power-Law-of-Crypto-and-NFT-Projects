# -*- coding: utf-8 -*-
"""
Created on Mon Sep  6 09:11:18 2021

@author: zayde
"""


from cryptocmd import CmcScraper
import pandas as pd
from datetime import datetime, timedelta


p_working_dir = r"C:\Users\zayde\OneDrive\Documents\TYPE IN YOUR OWN PATH" 


p_coins = ['BTC', 'ETH']
today = datetime.today()
p_date_today = datetime.strftime(today, '%d-%m-%Y')
yesterday = datetime.today() - timedelta(1)
p_date_yesterday = datetime.strftime(yesterday, '%d-%m-%Y')


date_query = p_date_yesterday    # change to date_today for production
date_query_start = '01-01-2016'
#date_query = p_date_today 
pd_closing_prices = pd.DataFrame()
pd_closing_prices = pd.DataFrame()
for this_coin in p_coins:
    print(this_coin)
    scraper = CmcScraper(this_coin, date_query_start, date_query)
    pd_tmp = scraper.get_dataframe()[['Date', 'Close']]
    pd_tmp['ticker'] = this_coin
    pd_closing_prices = pd.concat([pd_closing_prices, pd_tmp],axis=0)

file_name = p_working_dir+"\\pd_closing_prices_BTC_ETH.csv"
pd_closing_prices.to_csv(file_name )    