import json
import pandas as pd

####### My Ranked History #######
myRankedHist = json.load(open("/Users/Cameron/riot/DataCollected/myRankedHistory.json"))


print myRankedHist['matches'][58] # My first ranked game with Warwick jungle... that loss was painful
d = myRankedHist['matches']
myRankedDF = pd.DataFrame.from_records(d)
print myRankedDF['champion'].value_counts() # every champion I've played in ranked by ID (16=Soraka, 51 = Caitlyn)
print myRankedDF['role'].value_counts() # Roles played in ranked
print myRankedDF['season'].value_counts() # Games per season