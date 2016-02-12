#/usr/bin/python

import sys
import random


settingAll = open(sys.argv[1],"w")
settingInit = open(sys.argv[2],"r").read().split("\n")[:3]
result = open(sys.argv[3],"r").read().split("\n")[:-1]
childNum = int(sys.argv[4])
matchCount = int(sys.argv[5])
weapon = int(sys.argv[6])
amplitude = float(sys.argv[7])
minAmplitude = float(sys.argv[8])

def choiceBestParam(results):
    summary = []
    bestParams = []
    for i in range(3):
        summary.append({})
        bestParams.append([])
    for (i, res) in enumerate(results):
        no = i%3
        pid = res.rfind(" ",0,-2)
        psc = res.rfind(" ")
        param = res[:pid]
        score = int(res[pid+1:psc])
        winner = int(res[psc+1:])
        if not param in summary[no]:
            summary[no][param] = {"score":[],"winner":[]}
        summary[no][param]["score"].append(score)
        summary[no][param]["winner"].append(winner)
    for i in range(3):
        maxave = 0
        maxparam = ""
        for param in summary[i]:
            ave = sum(summary[i][param]["score"])/len(summary[i][param]["score"])
            if maxave < ave:
                maxave = ave
                maxparam = param
        bestParams[i] = map(float,maxparam.split(" "))
    return bestParams

def extractBestParam(settingAll, bestParams):
    for param in bestParams*2:
        p = map(str,param)
        settingAll.write(" ".join(p)+"\n")

def generateChildren(bestParams, weapon, amplitude):
    random.seed()
    children = []
    for i in range(childNum):
        child = bestParams[:]*2
        child[weapon] = [ bp * ( 1 + random.random() * amplitude ) for bp in bestParams[weapon] ]
        children.append(child)
    return children

def createSettingFile(settingAll, children):
    for child in children:
        for param in child:
            p = map(str,param)
            settingAll.write(" ".join(p)+"\n")
        for param in child[3:6]+child[0:3]:
            p = map(str,param)
            settingAll.write(" ".join(p)+"\n")

bestParams = [ map(float, si.split(" ")) for si in settingInit ] # first time
if len(result) != 0: # read result
    results = result[-6*2*matchCount*childNum:]
    bestParams = choiceBestParam(results)
print(bestParams)

if amplitude < minAmplitude:
    extractBestParam(settingAll, bestParams)
    sys.exit(0)

# generate children
children = generateChildren(bestParams, weapon, amplitude)

# create setting file
createSettingFile(settingAll, children)
