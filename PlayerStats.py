import urllib2
import json

# Riot API key from file
keypath = "/Users/Cameron/Documents/AuthStuff/RiotAPI.txt"
with open(keypath) as keyfile:
    key = keyfile.readline()

# Season options: SEASON2017, SEASON2016, SEASON2015, SEASON2014, SEASON3
# using stats-v1.3 API

StatsURL = "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/%s/summary?season=%s&api_key=%s"
season = "SEASON2015"
id = "39756440"

StatsResponse = urllib2.urlopen(StatsURL % (id, season, key))
StatsJSON = StatsResponse.read()
print StatsJSON