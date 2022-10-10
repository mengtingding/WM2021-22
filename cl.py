# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 11:06:43 2017

@author: jrbrad
"""

import requests
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('ID',metavar = 'ID',type = str,help='playerID')
parser.add_argument('year',metavar = 'year',type = str, help = 'season year')
args = parser.parse_args()
ID = args.ID
year = args.year
my_wm_username = 'mding'

try:
    int(ID)
    int(year)
    valid = True
except:
    valid = False

if valid:
    url_template = 'https://buckets.peterbeshai.com/api/?player=%s&season=%s'
    search_url = url_template % (ID,year)
    response = requests.get(search_url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"})
 

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
    if numJumpShotsAttempt ==0:
        print("season year is not valid for the player.")
    else:
        percJumpShotMade = numJumpShotsMade/numJumpShotsAttempt
        print('WM username:',my_wm_username)
        print('Jump shots attempt:',numJumpShotsAttempt)
        print('Jump shots made:',numJumpShotsMade)
        print('percent Jump shot made',percJumpShotMade)
else:
    print("ID or season year not valid.")
    