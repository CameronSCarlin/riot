import urllib2
import json

# Riot API key from file
keypath = "/Users/Cameron/Documents/AuthStuff/RiotAPI.txt"
with open(keypath) as keyfile:
    key = keyfile.readline() # Reading my API key

# Subset of my friends list
friends = ['cj6446','sonofdawn','eindride', 'kittyyawns', 'aeousz', 'albertmayday', 'armweak', 'f4_Zudrane',
           'Hamburg_SV', 'grumpykittykat', 'mike182838', 'MyBackHurtz', 'planourescape',  'WinD3e',
           'puffy_nip_nip','Yatsen', 'KatanaBladesman', 'zudrane', 'CamoLoco']

friends_str = ','.join(friends)

#summoner-v1.4 : Returns JSON for summonername and ID (and icon id and...)
"""
SummonerIDURL = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/%s?api_key=%s"
SummonerIDURLResponse = urllib2.urlopen(SummonerIDURL % (friends_str, key))
SummonerIDJSON = SummonerIDURLResponse.read()

with open('FriendID.json','w') as text_file:
    text_file.write(SummonerIDJSON)
"""

SumIDJSON = json.load(open("FriendID.json"))
text_file = open("FriendID.csv", "w")
for summoner in SumIDJSON:
    text_file.write(str(summoner)+","+str(SumIDJSON[summoner]['id'])+'\n')
text_file.close()