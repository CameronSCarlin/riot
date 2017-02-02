import json

####### Loads JSON match data from:
#https://s3-us-west-1.amazonaws.com/riot-api/seed_data/
#https://s3-us-west-1.amazonaws.com/riot-api/seed_data/matches1.json

MatchHistory = json.load(open("/Users/Cameron/riot/DataCollected/matches1.json"))

print MatchHistory['matches'][0] # All information about first match
print MatchHistory['matches'][0]['teams']   # First Match, basic team stats
print MatchHistory['matches'][0]['teams'][0]['bans'] # Bans for team 1
print MatchHistory['matches'][0]['teams'][1]['bans'] # Bans for team 2

####### My Ranked History
