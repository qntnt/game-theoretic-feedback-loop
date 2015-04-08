from colorama import Fore, Back, Style, init
from iCLAP_helpers import pathCost
init()

class switch(object):
    def __init__(self, value):
        self.value = value
        self.fall = False

    def __iter__(self):
        """Return the match method once, then stop"""
        yield self.match
        raise StopIteration

    def match(self, *args):
        """Indicate whether or not to enter a case suite"""
        if self.fall or not args:
            return True
        elif self.value in args: # changed for v1.5, see below
            self.fall = True
            return True
        else:
            return False


class logger():

    def __init__(self, verbose=False, debug=False):
        self.verbose = verbose
        self.debug = debug
        self.path_cost_log = open("./path_cost.csv", "w")
        self.path_log = open("./path.csv", "w")
        self.state_log = open("./state_log.csv", "w")
        self.OUTPUT("Log created")

    def close(self):
        self.path_log.close()
        self.path_cost_log.close()
        self.state_log.close()

    def write_path(self, iteration, path):
        self.path_cost_log.write(str(iteration)+','+str(abs(pathCost(path)))+"\n")

    def write_states(self, graph):
        for state in graph.keys():
            self.state_log.write(str(state.position._get_x())+", "+str(state.position._get_y())+", "+str(state.cost)+"\n")

    def OUTPUT(self, out, lvl=1):
        for case in switch(lvl):
            if case(1):
                print(out)
                break
            if case(2):
                print("- "+out)
                break
            if case(3):
                print("-- "+out)
                break
            if case(4):
                print("--- "+out)
                break

    def VERBOUT(self, out, lvl=1):
    	if self.verbose:
    		self.OUTPUT(out, lvl=lvl)

    def DEBOUT(self, out):
    	if self.debug:
    		print("DEBUG: "+out)

    def WARNING(self, out):
    	print(Fore.ORANGE+"WARNING: "+out+Fore.RESET)

    def ERROR(self, out):
    	print(Fore.RED+"ERROR: "+out+Fore.RESET)
