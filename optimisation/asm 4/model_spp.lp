\ Model Truck
\ LP format - for model browsing. Use MPS format to capture full model detail.
Minimize
  400 x_1,2 + 950 x_1,3 + 800 x_1,4 + 1800 x_2,5 + 900 x_2,6 + 1100 x_3,5
   + 600 x_3,6 + 600 x_4,6 + 1200 x_4,7 + 900 x_6,5 + 1000 x_6,7
   + 400 x_5,8 + 1300 x_6,8 + 600 x_7,8
Subject To
 start_flow: x_1,2 + x_1,3 + x_1,4 = 1
 end_flow: x_1,2 + x_1,3 + x_1,4 = 1
 flow_conservation: = 0
 flow_conservation: x_1,2 - x_2,5 - x_2,6 = 0
 flow_conservation: x_1,3 - x_3,5 - x_3,6 = 0
 flow_conservation: x_1,4 - x_4,6 - x_4,7 = 0
 flow_conservation: x_2,5 + x_3,5 + x_6,5 - x_5,8 = 0
 flow_conservation: x_2,6 + x_3,6 + x_4,6 - x_6,5 - x_6,7 - x_6,8 = 0
 flow_conservation: x_4,7 + x_6,7 - x_7,8 = 0
 flow_conservation: = 0
Bounds
Binaries
 x_1,2 x_1,3 x_1,4 x_2,5 x_2,6 x_3,5 x_3,6 x_4,6 x_4,7 x_6,5 x_6,7 x_5,8
 x_6,8 x_7,8
End
