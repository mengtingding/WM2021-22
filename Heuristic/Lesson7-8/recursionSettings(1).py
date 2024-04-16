import sys, threading

sys.setrecursionlimit(800000)
threading.stack_size(100000000)

def factorial(x):
    if x == 1:
        return 1
    else:
        return x * factorial(x-1)

def main():
    print(factorial(1000))

thread = threading.Thread(target=main)
thread.start()