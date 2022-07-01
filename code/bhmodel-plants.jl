using Distributions
using TickTock
using Base.Threads

# tick()


function bhGerminate(bhGermRate, bhSeedNum)
    bhGermRate = rand(Normal(bhGermRate, 0.05))
    active = round(bhGermRate * bhSeedNum)
    bhSeeds = [active, bhSeedNum - active]
    # [bh active seeds, bh dormant seeds]
    return bhSeeds
end

function envSelect(pD, survivalRateGood, survivalRateBad)
    # CHANGE FUNCTION NAME?
    # NEED SURVIVAL RATES?
    if pD > 0.7
        w = 0.01
    else
        w = 4
    end
    return w
end

function randRep(wt, bhActive, w)
    expectedBH = round(w * bhActive)
    expectedWT = round(w * wt)
    realizedOffsprings = [expectedBH, expectedWT]
    return realizedOffsprings
end


function resizePop(realizedOffsprings, cc)
    # PULL from binomial
    newPop = sum(realizedOffsprings)
    if newPop > cc
        newSeeds = realizedOffsprings / (newPop / cc)
    else 
        newSeeds = realizedOffsprings
    end
    return newSeeds
end

function reproduce(k, wt, bhActive, pD, survivalRateGood, survivalRateBad)
    # get w (fitness) as function of env
    w = envSelect(pD, survivalRateGood, survivalRateBad)
    # random reproduction: expected offspring = w * current counts
    # pull from distribution with expectation/mean = expected offspring (Poisson)
    realizedOffsprings = randRep(wt, bhActive, w)
    # get carrying capacity
    # cc = getCC(k)
    cc = k
    # resize to carrying capacity
    newSeeds = resizePop(realizedOffsprings, cc)
    return newSeeds
end

# depending on data, bhDormant can be a vector 
# where each entry represents seeds that stay dormant for n years

# RESIZE POPULATION BEFORE OR AFTER BANK STATEMENT?

function bankStatement(newSeeds, bhDormant)
    (bh, wt) = newSeeds
    nextGenSeedNum = [bh + bhDormant, wt]
    return nextGenSeedNum
end

function getNextGen(k, seedNum, pD, bhGermRate, survivalRateGood, survivalRateBad)
    # generate [bh active seeds, bh dormant seeds] 
    (bhActive, bhDormant) = bhGerminate(bhGermRate, seedNum[1])
    # wt seeds unchanged
    wt = seedNum[2]
    # reproduction, input only active seeds, [bh active seeds, wt seeds]
    newSeeds = reproduce(k, wt, bhActive, pD, survivalRateGood, survivalRateBad)
    # combine seed bank with new seeds, [bh, wt] 
    nextGenSeedNum = bankStatement(newSeeds, bhDormant)
    return nextGenSeedNum
end

function simulate(k::Int64, pD::Float64, germRate::Float64, survivalRateGood::Float64, survivalRateBad::Float64)
    initBH = ceil(bhwtRatio * k)
    # seedNum = [initBH, k - initBH] # number of seeds for BH population and non-BH population, respectively
    seedNum = [initBH, k - initBH]
    generations::Int64 = 1
    # while loop simulates as long as both populations are present. ends when one (or both) go extinct
    while 0 < seedNum[1] && 0 < seedNum[2]
        seedNum = getNextGen(k, seedNum, rand(Normal(pD, 0.05)), germRate, survivalRateGood, survivalRateBad)
        generations += 1
    end
    return seedNum[1] > 0
    # returns True (1) if BH win, False (0) otherwise
end

# PARTITION INITIAL [BH, WT] IN 1:1 RATIO?
bhwtRatio = 0.5

# function means(pD, germRate, survivalRateGood, survivalRateBad)
#     #create a function that calculates the arithmetic and geometric mean fitness of a species in a specific env context
#     #not needed to simulate things, but will be really useful in interpreting your results and making predictions
#     #i don't really know how to do this with this system
#     return [AMF, GMF]
# end

# parameters

bhGermRate = 1.0
pD = 0.7
survivalRateGood = -1.0
survivalRateBad = -1.0

maxN = 3 # log(maximum population size). Larger than 6 and the code will take forever to run
a = range(start=0, stop=maxN, length=10)
allN = [convert(Int64, floor(10^i)) for i in a] # creates a vector of 10 population sizes evenly spaced on a log scale
# allN = [1, 3, 12, 46, 166, 599, 2154, 7742, 27825, 100000]
reps = floor(500 * 10^maxN) # number of replicates

out = open("results/plantsim_$bhGermRate`$pD.csv", "w") # creates a new output file whose filename includes parameters
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
    output = open("results/plantsim_$bhGermRate`$pD.csv", "a") # adds the NPfix value to the output file
    write(output, join([k, npf], ","), "\n")
    close(output)

    push!(Npfix, npf)
    tock()
end



# tock()
