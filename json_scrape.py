# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 11:06:43 2017

@author: jrbrad
"""

import requests

my_wm_username = 'mding'
search_url = 'https://buckets.peterbeshai.com/api/?player=201939&season=2015'
response = requests.get(search_url, headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"})
 

numJumpShotsAttempt = 0
numJumpShotsMade = 0
percJumpShotMade = 0.0

# Write your program here to populate the appropriate variables
action_type = []
for shot in response.json():
    action_type.append(shot["ACTION_TYPE"])

numJumpShotsAttempt = action_type.count("Jump Shot")
for shot in response.json():
    if (shot["ACTION_TYPE"] == "Jump Shot" and shot['EVENT_TYPE'] == "Made Shot"):
        numJumpShotsMade += 1
percJumpShotMade = numJumpShotsMade/numJumpShotsAttempt

print(my_wm_username)
print(numJumpShotsAttempt)
print(numJumpShotsMade)
print(percJumpShotMade)