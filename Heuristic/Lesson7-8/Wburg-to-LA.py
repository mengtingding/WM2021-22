dist = {}    #Global variable; key: location; value: tuple: (shortest distance to destination, path)

def f_star(net):
    for state in net.keys():
        alts = []
        d = [x[0] for x in net[state]]
        if set(d).issubset(dist.keys()):
            for dest in net[state]:
                alts.append((dist[dest[0]][0] + dest[1], dest[0]))
            dist[state] = min(alts)
            return state
        
if __name__ == "__main__":
    """ Wmsbg to LA car travel data """
    links = {'B':[('LA',115)] , 'SD':[('LA',120)], 'DE':[('B',904),('A',449)],'A':[('B',677)],'D':[('SD',1358)],'OK':[('A',504)],'SL':[('DE',851),('OK',498)],'LR':[('OK',389),('D',319)],'W':[('D',1340),('LR',1012),('SL',878)]}
    dest = 'LA'
    origin = 'W'
    dist[dest] = (0,dest)

    while len(links) > 0:
        state = f_star(links)
        del links[state]
    
    print('\n\n', dist, '\n')
    for loc in dist.keys():
        print(dist[loc][1],":",dist[loc][0])

    print('\n')
    print('Optimal Mileage:', dist[origin][0])
    
    ''' reconstruct optimal path '''
    path = origin
    loc = origin
    while loc != dest:
        loc = dist[loc][1]
        path += '-' + loc
    print('Optimal path: ' + path)    