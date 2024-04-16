# -*- coding: utf-8 -*-
"""
Created on Tue Jan 28 07:47:03 2020

@author: apblossom
"""

def P(prev_score,next_score,temperature):
    if next_score > prev_score:
        return 1.0
    else:
        return math.exp( -abs(next_score-prev_score)/temperature )