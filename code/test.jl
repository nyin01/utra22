using Distributions
using TickTock
using Base.Threads
include("parameters.jl")

function bhGerminate(bhGermRate::Float64, bhSeedNum)
    active = rand(Binomial(bhSeedNum, bhGermRate))
    # active = round(rand(Normal(bhGermRate, 0.03)) * bhSeedNum)
    bhSeeds = [active, bhSeedNum - active]
    return bhSeeds
end

function envSelect(pD::Float64, wGood::Float64, wBad::Float64)
    # NEED SURVIVAL RATES?
    if pD > 0.5
        # return wBad 
        return rand(Normal(wBad, 0.001))
    else
        # return wGood
        return rand(Normal(wGood, 0.1))
    end
end

function randRep(wt::Int64, bhActive::Int64, w::Float64)
    expectedBH = w * bhActive
    expectedWT = w * wt
    realizedOffsprings = [expectedBH, expectedWT]
    return realizedOffsprings
end

function resizePop(realizedOffsprings, k::Int64)
    newPop = sum(realizedOffsprings)
    if  newPop > k
        # pull from binomial
        bh = rand(Binomial(k, realizedOffsprings[1] / newPop))
        wt = k - bh
        return [bh, wt]
    else 
        return [round(Int64, realizedOffsprings[1]), round(Int64, realizedOffsprings[2])]
    end
end

function reproduce(k::Int64, wt::Int64, bhActive::Int64, pD::Float64, survivalRateGood, survivalRateBad)
    # randomize pD
    pD = rand(Normal(pD, 0.05))
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

function bankStatement(newSeeds, bhDormant::Int64)
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
    initBH = round(Int64, bhwtRatio * k)
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
(bhwtRatio, bhGermRate, pD, wGood, wBad, maxN, tag, survivalRateGood, survivalRateBad) = params["neutctr"]

function runthat(seeds)
    println(seeds)
    println("============")
    seeds = getNextGen(1000, seeds, pD, bhGermRate, wGood, wBad)
    if seeds[1] > 0 && seeds[2] > 0
        runthat(seeds)
    # elseif seeds[2] == 0
    #     return 1
    else 
        println(seeds)
    end
end

runthat([500,500])