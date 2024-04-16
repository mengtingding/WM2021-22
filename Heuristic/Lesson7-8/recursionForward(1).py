dist = {}

def f_star(net,state,dest):
    if state == dest:
        dist[state] = [0, dest]
        return dist[state]
    elif state in net.keys():
        alts = []
        for (key,cost) in net[state]:
            f_star_cost , f_star_path = f_star(net,key,dest)
            alts.append(([cost + f_star_cost,  state + '-' + f_star_path]))
        dist[state] = min(alts)
        return dist[state]

if __name__ == "__main__":
    """ shortest path Wmsbg to LA """
    #arcs1 = {'LA': [('B',115),('SD',120)],'B':[('DE',904),('A',677)],'SD':[('D',1358)],'A':[('OK',504),('DE',449)],'DE':[('SL',851)],'OK':[('SL',498),('LR',389)],'D':[('W',1340),('LR',319)],'LR':[('W',1012)],'SL':[('W',878)]}   
    links = {'W':[('D',1340),('LR',1012),('SL',878)], 'B':[('LA',115)] , 'SD':[('LA',120)], 'DE':[('B',904),('A',449)],'A':[('B',677)],'D':[('SD',1358)],'OK':[('A',504)],'SL':[('DE',851),('OK',498)],'LR':[('OK',389),('D',319)]}
    origin = 'W'
    dest = 'LA'
    dist['LA'] = (0,'LA')

    f_star(links,origin,dest)
    
    print('\nRoute:',dist[origin][1],', Mileage:', dist[origin][0],'\n')
    
    print('\n', dist,'\n')
    for loc in dist.keys():
        print(dist[loc][1],":",dist[loc][0])
    
    print()
    for key in links.keys():
        print(key, links[key])