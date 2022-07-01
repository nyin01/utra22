using Distributions
using TickTock

function bhGerminate(bhGermRate, bhSeedNum)
    bhSeeds = [bhGermRate * bhSeedNum, (1 - bhGermRate) * bhSeedNum]
    # [bh active seeds, bh dormant seeds]
    return bhSeeds
end

function randRep(wt, bhActive, w)
    expectedBH = w * bhActive
    expectedWT = w * wt
    realizedOffsprings = [rand(Poisson(expectedBH)), rand(Poisson(expectedWT))]
    return realizedOffsprings
end

function resizePop(realizedOffsprings, cc)
    newPop = sum(realizedOffsprings)
    if newPop > cc
        newSeeds = realizedOffsprings / (newPop / cc)
    else 
        newSeeds = realizedOffsprings
    end
    return newSeeds
end

function reproduce(cc, wt, bhActive, pD, survivalRateGood, survivalRateBad)
    w = envSelect(pD, survivalRateGood, survivalRateBad)
    realizedOffsprings = randRep(wt, bhActive, w)
    newSeeds = resizePop(realizedOffsprings, cc)
    return newSeeds
end

function bankStatement(newSeeds, bhDormant)
    (bh, wt) = newSeeds
    nextGenSeedNum = [bh + bhDormant, wt]
    return nextGenSeedNum
end

function getNextGen(k, seedNum, pD, bhGermRate, survivalRateGood, survivalRateBad)
    (bhActive, bhDormant) = bhGerminate(bhGermRate, seedNum[1])
    wt = seedNum[2]
    newSeeds = reproduce(k, wt, bhActive, pD, survivalRateGood, survivalRateBad)
    nextGenSeedNum = bankStatement(newSeeds, bhDormant)
    return nextGenSeedNum
end

k = 3

seedNum = [bhwtRatio * k, (1 - bhwtRatio) * k]

bhSeeds = bhGerminate(bhGermRate, bh)
survivalRateGood = -1.0
survivalRateBad = -1.0
bhActive = bhSeeds[1]
bhDormant = bhSeeds[2]
cc = 2

# function runThat(k, seedNum, pD, bhGermRate,survivalRateGood, survivalRateBad)
#     println(seedNum)
#     nextGen = getNextGen(k, seedNum, rand(Normal(pD, 0.05)), bhGermRate, survivalRateGood, survivalRateBad)
#     if nextGen[1] > 0 && nextGen[2] > 0
#         runThat(k, nextGen, pD, bhGermRate, survivalRateGood, survivalRateBad)
#     else 
#         print("final:")
#         println(nextGen)
#         println("====================")
#     end

# end

function simulate(k::Int64, pD::Float64, germRate::Float64, survivalRateGood::Float64, survivalRateBad::Float64)
    # initBH = 1 # number of bh to start
    # seedNum = [initBH, k - initBH] # number of seeds for BH population and non-BH population, respectively
    seedNum = [bhwtRatio * k, (1 - bhwtRatio) * k]
    generations::Int64 = 1
    # while loop simulates as long as both populations are present. ends when one (or both) go extinct
    while 0 < seedNum[1] && 0 < seedNum[2]
        seedNum = getNextGen(k, seedNum, rand(Normal(pD, 0.05)), germRate, survivalRateGood, survivalRateBad)
        generations += 1
    end
    return seedNum[1] > 0
    # returns True (1) if BH win, False (0) otherwise
end

reps=100000

tick()

out = open("results/plantsim_$bhGermRate`$pD.csv", "w") # creates a new output file whose filename includes parameters
write(out, join(["CarryingCap", "NPfix"], ","), "\n") # populates output file with vector of 10 population sizes
close(out)


Npfix = Float64[]
fix = 0
for run = 1 : reps
    global fix += simulate(k, pD, bhGermRate, survivalRateGood, survivalRateBad) # c increases by 1 for each rep that reaches fixation
end
npf = ((fix / reps) * k) # calculates normalized probability of fixation
output = open("results/plantsim_$bhGermRate`$pD.csv", "a") # adds the NPfix value to the output file
write(output, join([k, npf], ","), "\n")
close(output)
push!(Npfix, npf)

println(Npfix)

tock()


function envSelect(pD, survivalRateGood, survivalRateBad)
    if pD > 0.7
        w = 0.01
    else
        w = 4
    end
    return w
end

# allN = [1, 3, 12, 46, 166, 599, 2154, 7742, 27825, 100000]
bhwtRatio = 0.5
bhGermRate = 0.6
pD = 0.7

