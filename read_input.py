# helper utils for reading in data

import numpy as np

# reads a list of filepaths, stores in list
def read_list(path):
    collection = []
    with open(path) as infile:
        for line in infile:
            newline = line.strip()
            collection.append(newline)
    return collection

# reads a list of filepaths, stores in dict
def read_dict(path):
    collection, counter = {}, 0
    with open(path) as infile:
        for line in infile:
            newline = line.strip()
            collection[counter] = newline
            counter += 1
    return collection

# reads a list of floats, stores in list
def read_single_value(path):
    collection = []
    with open(path) as infile:
        for line in infile:
            with open(line.strip()) as individual_file:
                newline = float(individual_file.readline().strip())
                collection.append(newline)
    return collection

# reads a list of floats, stores in dict
def read_single_value_dict(path):
    collection, counter = {}, 0
    with open(path) as infile:
        for line in infile:
            with open(line.strip()) as individual_file:
                newline = float(individual_file.readline().strip())
                collection[counter] = newline
                counter += 1
    return collection

# numpy-load list of floats, store as list
def load_single_value(path):
    collection = []
    with open(path) as infile:
        for line in infile:
            newline = np.load(line.strip())
            collection.append(newline)
    return collection

# numpy-load list of floats, store as dict
def load_single_value_dict(path):
    collection, counter = {}, 0
    with open(path) as infile:
        for line in infile:
            newline = np.load(line.strip())
            collection[counter] = newline
            counter += 1
    return collection

# read table of lat+long coords, store in list
def read_locs(path):
    collection = []
    with open(path) as infile:
        for line in infile:
            newline = line.strip().split()
            newline = list(map(float,newline))
            collection.append(newline)
    return collection

# fill a dictionary with a single value
def fill_dict_single_value(val, reps):
    collection={}
    for i in range(reps):
        collection[i] = val
    return collection

# convert list to dictionary with ordinal keys
def dict_from_list(mylist):
    collection = {}
    for i in range(len(mylist)):
        collection[i] = mylist[i]
    return collection

# parse tree sequence provenance for sigma and map width
def parse_provenance(ts, param):
    prov = str(ts.provenance(0)).split()
    for i in range(len(prov)):
        if param+"=" in prov[i]:
            val = float(prov[i].split("=")[1].split("\"")[0])
            break
    return(val)
            

