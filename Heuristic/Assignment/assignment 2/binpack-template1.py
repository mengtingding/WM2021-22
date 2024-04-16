# Determine start time
import time
start = time.time()

import datetime
import json

def getData():
    f = open('binpack.json','r')
    x = json.load(f)
    f.close()
    for i in range(len(x)):
        myData = x[i]['data']
        x[i]['data'] = {}
        for j in range(len(myData)):
            x[i]['data'][j] = myData[j] 
    return x

def checkCapacity(articles, bin_contents, bin_cap):
    """ articles: a dictionary of the items to be loaded into the bins: the key is the article id and the value is the article volume """
    """ bin_contents is expected to be a list of lists, where each sub-list is the contents of each bin vis article ids  """
    """ bin_cap: capacity of each of the identical bins """
    """ This function returns two parameters, the first of which is the number of bins that are within capacity and, the second, the number of overloaded bins """
    
    num_ok = 0
    num_over = 0
    if isinstance(articles,dict):
        if isinstance(bin_contents,list):
            item_key_good = True
            for this_bin in bin_contents:
                if isinstance(this_bin,list):
                    load = 0.0
                    for this_item in this_bin:
                        if this_item not in items.keys():
                            item_key_good = False
                        else:
                            load += articles[this_item]
                    if item_key_good == False:
                        print("function checkCapacity(), bad item key")
                        return 'bad_key', 'bad_key'
                    elif load <= bin_cap:
                        num_ok += 1
                    else:
                        num_over += 1
                else:
                    print("function checkCapacity(),contents of each bin must be in a sub-list")
                    return 'sublist_error','sublist_error'
            return num_ok, num_over
        else:
            print("function checkCapacity(), bin_contents must be in a list")
            return 'list_needed', 'list_needed'
    else:
        print("function checkCapacity(), articles argument requires a dictionary")
        return 'dict_needed', 'dict_needed'
        
def checkAllPoints(articles, bin_contents):
    """ Check to be sure that all items are packed in one bin """
    
    err_mess = ""
    err_mult= False
    checkit = {}
    for this_bin in bin_contents:
        for this_art in this_bin:
            checkit[this_art] = checkit.get(this_art,0) + 1
            if checkit[this_art] > 1:
                err_mult = True
                err_mess += "Loc assigned mult times"
                
    err_all = False
    for key_art in articles.keys():
        if key_art not in checkit.keys():
            err_all = True
            err_mess += "Some locs not assigned to bins"
            
    return err_mult, err_all, err_mess

def binpack(articles,bin_cap):
    """ Write your heuristic bin packing algorithm in this function using the argument values that are passed
             articles: a dictionary of the items to be loaded into the bins: the key is the article id and the value is the article volume
             bin_cap: the capacity of each (identical) bin (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             bin_contents: A list of lists, where each sub-list indicates the dictionary keys for the items assigned to each bin.      
                           Each sublist contains the item id numbers (integers) for the items contained in that bin.  The integers refer to 
                           keys in the items dictionary. 
   """
    bin_contents = []    # use this list document the article ids for the contents of 
                         # each bin, the contents of each is to be listed in a sub-list
   
    #max_bin = -1
    bins = {}      # dictionary to store items in each bin, each dictionary entry is a bin, its value is a tuple with the current volume and a list of the item ids
    
    items_list = [(k,v) for k,v in articles.items()]
    items_list.sort(key=lambda x:x[1],reverse=False)
    
    """ Insert code here.  You may adjust lines 93-94 (above) or 99-100 (below) if needed
    """
    import math
    
    #lower bound on bins
    lb = math.ceil(sum([v for r, v in items_list])/bin_cap) #divided by bin capacity to get the minimum bins needed
    print("wilck lower bound", lb)
    #create min bins needed for packing
    binlist = [[] for i in range(lb)]
    
    #create a list of volumnes for each bin
    caplist = [bin_cap for i in range(lb)]
    
    #iterate through the list of tuples (k=item and v=volume)
    for k, v in items_list:
        #iterate through the bins from first to last
        for b in range(len(binlist)):
            #if volume of item is less than the capacity of bin, then place in bin
            if v <= caplist[b]:
                caplist[b] = caplist[b] - v #reduce bin volume
                binlist[b].append(k)
                break #found bin so we break the loops
            
            #if all bins are full then add a new bin
            elif (b+1) == len(binlist):
                binlist.append([k])
                caplist.append(bin_cap-v) #append updated volume of new bin
            
        bin_contents = binlist #list of lists
            
    #for this_key in bins.keys():
     #   bin_contents.append(bins[this_key][1])
    
    # Print the contents of the different bins.
    # If you comment out the print line below, then you will only have total 
    # number of bins.
    #print(bin_contents)            
    return bin_contents

""" Get solutions based on submission """
probData = getData()
problems = range(len(probData)) 
silent_mode = False    # use this variable to turn on/off appropriate messaging depending on student or instructor use

for problem_id in problems:
    bin_cap = probData[problem_id]['cap']
    items = probData[problem_id]['data']
    #finished = False
    errors = False
    response = None
    
    #while finished == False:
    response = binpack(items,bin_cap)
    print(response)
    #if not isinstance(response,str):
    if isinstance(response,list):
        num_ok, num_over = checkCapacity(items, response, bin_cap)
        if not isinstance(num_ok,int) or not isinstance(num_over,int):
            errors = True
            if silent_mode:
                status = num_ok
            else:
                print("P"+str(problem_id)+num_ok+"_")
                
        err_mult, err_all, err_mess = checkAllPoints(items, response)
        if err_mult or err_all:
            errors = True
            if silent_mode:
                status += "_" + err_mess
            else:
                print("P"+str(problem_id)+err_mess+"_")
    else:
        errors = True
        if silent_mode:
            status = "response not a list"
        else:
            print("P"+str(problem_id)+"reponse_must_be_list_")
            
    if errors == False:
        
        if silent_mode:
            status = "P"+str(problem_id)+"bin_pack_"
        else:
            print("Bins Packed for Problem ", str(problem_id)," ....")
        
        if silent_mode:
            print(status+"; num_ok: "+num_ok+"; num_over: "+num_over)
        else:
            print("num_ok/num_over: ", num_ok,"/",num_over)
        this_time = datetime.datetime.now()     # not use; formerly planned as iput to DB
        
# Determine ending time
end = time.time()

# Print total time.
print("For a total time in seconds of ")
print(end - start)