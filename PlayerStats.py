import urllib2
import json
import pprint

# Using stats-v1.3 API

# Takes in ID as string, List of seasons desired, and API key as string
def GetAggregates(SummonerID, SeasonList, key):
    StatsURL = "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/%s/summary?season=%s&api_key=%s"
    MyAggregates = {}
    for season in SeasonList:
        StatsResponse = urllib2.urlopen(StatsURL % (SummonerID, season, key)) # Goes to StatsURL to get JSON blob
        StatsStr = StatsResponse.read() # Reading JSON blob of my stats summaries into string
        StatsJSON = json.loads(StatsStr) # Turn into JSON object from string
        MyAggregates[season] = StatsJSON # Add to dictionary as Season: SeasonStats
    return MyAggregates # Returns aggregated stats

# Riot API key from file
keypath = "/Users/Cameron/Documents/AuthStuff/RiotAPI.txt"
with open(keypath) as keyfile:
    key = keyfile.readline()

myID = "39756440"
Seasons = ['SEASON2017', 'SEASON2016', 'SEASON2015', 'SEASON2014', 'SEASON3'] # Available seasons for data

MyAggregateStats = GetAggregates(myID, Seasons, key)

pprint.pprint(MyAggregateStats) # Pretty printout of JSON blob

with open('MyAggregateStats.json','w') as text_file: # Write JSON blob to file
    json.dump(MyAggregateStats, text_file)