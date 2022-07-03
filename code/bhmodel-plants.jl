using Distributions
using TickTock
using Base.Threads
include("parameters.jl")

function bhGerminate(bhGermRate, bhSeedNum)
    active = rand(Binomial(bhSeedNum, bhGermRate))
    # active = round(rand(Normal(bhGermRate, 0.03)) * bhSeedNum)
    bhSeeds = [active, bhSeedNum - active]
    return bhSeeds
end

function envSelect(pD, wGood, wBad)
    # NEED SURVIVAL RATES?

    if pD > 0.7
        # return wBad 
        return rand(Normal(wBad, 0.001))
    else
        # return wGood
        return rand(Normal(wGood, 0.1))
    end
end

function randRep(wt, bhActive, w)
    expectedBH = round(w * bhActive)
    expectedWT = round(w * wt)
    realizedOffsprings = [expectedBH, expectedWT]
    return realizedOffsprings
end


function resizePop(realizedOffsprings, k)
    newPop = sum(realizedOffsprings)
    if  newPop > k
        # pull from binomial
        bh = rand(Binomial(k, realizedOffsprings[1] / newPop))
        wt = k - bh
        return [bh, wt]
    else 
        return realizedOffsprings
    end
end

function reproduce(k, wt, bhActive, pD, survivalRateGood, survivalRateBad)
    # randomize pD
    pD = rand(Normal(pD, 0.1))
    # get w (fitness) as function of env
    w = envSelect(pD, survivalRateGood, survivalRateBad)
    # random reproduction: expected offspring = w * current counts
    # currently no randomization for realizedOffsprings bc w is randomized
    realizedOffsprings = randRep(wt, bhActive, w)
    # get carrying capacity
    # k = k
    # resize to carrying capacity
    newSeeds = resizePop(realizedOffsprings, k)
    return newSeeds
end

# depending on data, bhDormant can be a vector 
# where each entry represents seeds that stay dormant for n years

function bankStatement(newSeeds, bhDormant)
    (bh, wt) = newSeeds
    nextGenSeedNum = [bh + bhDormant, wt]
    return nextGenSeedNum
end

function getNextGen(k, seedNum, pD, bhGermRate, wGood, wBad)
    # generate [bh active seeds, bh dormant seeds] 
    (bhActive, bhDormant) = bhGerminate(bhGermRate, seedNum[1])
    # wt seeds unchanged
    wt = seedNum[2]
    # reproduction, input only active seeds, [bh active seeds, wt seeds]
    newSeeds = reproduce(k, wt, bhActive, pD, wGood, wBad)
    # combine seed bank with new seeds, [bh, wt] 
    nextGenSeedNum = bankStatement(newSeeds, bhDormant)
    return nextGenSeedNum
end

function simulate(k::Int64, pD::Float64, germRate::Float64, wGood::Float64, wBad::Float64)
    initBH = ceil(bhwtRatio * k)
    # number of seeds for BH population and non-BH population, respectively
    seedNum = [initBH, k - initBH]
    generations::Int64 = 1
    # while loop simulates as long as both populations are present. ends when one (or both) go extinct
    while 0 < seedNum[1] && 0 < seedNum[2]
        seedNum = getNextGen(k, seedNum, pD, germRate, wGood, wBad)
        generations += 1
    end
    return seedNum[1] > 0
    # returns True (1) if BH win, False (0) otherwise
end

# parameters
(bhwtRatio, bhGermRate, pD, wGood, wBad, maxN, file) = params["pos control"]

reps = floor(500 * 10^maxN) # number of replicates
a = range(start=0, stop=maxN, length=10)
allN = [convert(Int64, floor(10^i)) for i in a] # creates a vector of 10 population sizes evenly spaced on a log scale

out = open(file, "w") # creates a new output file whose filename includes parameters
write(out, join(["CarryingCap", "NPfix"], ","), "\n") # populates output file with vector of 10 population sizes
close(out)

println(allN)

Npfix = Float64[] # creates an empty vector where normalized pfix values will be added
for k in allN # repeats this process at each population size, or carrying capacity
    c = 0 # counts number of replicates that reach fixation
    tick()
    for run = 1 : reps
        c += simulate(k, pD, bhGermRate, survivalRateGood, survivalRateBad) # c increases by 1 for each rep that reaches fixation
    end
    npf = ((c / reps) / bhwtRatio) # calculates normalized probability of fixation
    output = open(file, "a") # adds the NPfix value to the output file
    write(output, join([k, npf], ","), "\n")
    close(output)

    push!(Npfix, npf)
    tock()
end
