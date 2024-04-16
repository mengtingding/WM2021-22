# -*- coding: utf-8 -*-
"""
Created on Tue Mar 29 10:59:35 2022

@author: jhwilck
"""
'''
Objective:
Computing the length of the hypotenuse of a right triangle.
'''

''' Import Packages '''
import math

''' Functions '''
def hypot(sides):
    h = sides[0]**2 + sides[1]**2
    h = math.sqrt(h)
    return h

''' Define Data (Please insert the two sides of the triangle here) '''
inputsides = [3,4]

''' Call Function '''
outputH=hypot(inputsides)

''' Print statement '''
print('Hypotenuse length for sides (%f, %f) is %f' % (inputsides[0], inputsides[1], outputH))
