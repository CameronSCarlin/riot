##################################
####### Function Directory #######
##################################
# API Key


####### API Key #######
# Input: Directory containing API txt file as a string
# Output: API Key as a string

def GetAPIKey(directory):
    with open(directory) as keyfile:
        return(keyfile.readline())  # Returning API key

# Example
# keypath = "/Users/Cameron/riot/FakeKey.txt"
# print GetAPIKey(keypath)