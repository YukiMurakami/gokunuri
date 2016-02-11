import pprint

f = open("results_160208.csv")
lines = f.readlines()

scores = {}
wins = {}

for line in lines:
    elems = line.rstrip().split(",")
    key = ",".join(elems[0:5])
    if not key in scores:
        scores[key] = []
        wins[key] = []
    if(elems[5] == "1"):
        scores[key].append(float(elems[6])-300)
    else:
        scores[key].append(float(elems[6]))
    if(elems[5] != "2"):
        wins[key].append(float(elems[5]))

aves = {}
winrates = {}

for k,v in scores.items():
    aves[k] = sum(v)/len(v)
for k,v in wins.items():
    winrates[k] = sum(v)/len(v)

aves = sorted(aves.items(), key=lambda x:x[1])
winrates = sorted(winrates.items(),key=lambda x:x[1])

pprint.pprint(aves)
pprint.pprint(winrates)