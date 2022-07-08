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

function normalizeVariance(envVariance)
    return -1.
end

# alternative function:
# when envVariance is within an acceptable range (env is good)
#   pull realizedW from a normal distribution (fitness slightly fluctuates)
#   or some distribution skewed right (can get higher fitness)
# when envVariance is outside the range (env is bad/unstable)
#   pull from distribution skewed left (can get lower fitness)
# not fully implemented
function getFitness(survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    expectedW = w
    # expectedW = survivalRate * offspringCount

    threshold = 0.2 # might make this global or a param

    nVariance = envVariance
    # might need to scale variance to use in distribution:
    # nVariance = normalizeVariance(envVariance)

    if nVariance > threshold # bad env
        realizedW = rand(TruncatedNormal(expectedW, nVariance, 0.0, expectedW))
    else # good env
        realizedW = rand(truncated(Normal(expectedW, nVariance); lower=0.0))
    end
    return realizedW
end

function randRep(wt::Int64, bhActive::Int64, realizedW::Float64)
    expectedBH = realizedW * bhActive
    expectedWT = realizedW * wt
    # realizedOffsprings = [expectedBH, expectedWT]
    realizedOffsprings = [rand(Poisson(expectedBH)), rand(Poisson(expectedWT))]
    return realizedOffsprings
end

function resizePop(realizedOffsprings, k::Int64)
    newPop = sum(realizedOffsprings)
    if  newPop > k
        bh = rand(Binomial(k, realizedOffsprings[1] / newPop))
        wt = k - bh
        return [bh, wt]
    else 
        return [round(Int64, realizedOffsprings[1]), round(Int64, realizedOffsprings[2])]
    end
end

function reproduce(k::Int64, wt::Int64, bhActive::Int64, survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    # randomize pD
    # pD = rand(truncated(Normal(pD, 0.05); lower=0.0))
    # get w (fitness) as function of env
    realizedW = getFitness(survivalRate, offspringCount, w, envVariance)
    # random reproduction: expected offspring = w * current counts
    # currently no randomization for realizedOffsprings bc w is randomized
    realizedOffsprings = randRep(wt, bhActive, realizedW)
    # resize to carrying capacity
    newSeeds = resizePop(realizedOffsprings, k)
    return newSeeds
end

function bankStatement(newSeeds, bhDormant::Int64)
    (bh, wt) = newSeeds
    nextGenSeedNum = [bh + bhDormant, wt]
    return nextGenSeedNum
end

function getNextGen(k::Int64, seedNum, bhGermRate::Float64, survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    # generate [bh active seeds, bh dormant seeds] 
    (bhActive, bhDormant) = bhGerminate(bhGermRate, seedNum[1])
    # wt seeds unchanged
    wt = seedNum[2]
    # reproduction, input only active seeds, [bh active seeds, wt seeds]
    newSeeds = reproduce(k, wt, bhActive, survivalRate, offspringCount, w, envVariance)
    # combine seed bank with new seeds, [bh, wt] 
    nextGenSeedNum = bankStatement(newSeeds, bhDormant)
    return nextGenSeedNum
end

function simulate(k::Int64, bhGermRate::Float64, survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    initBH = ceil(Int64, bhwtRatio * k)
    # number of seeds for BH population and non-BH population, respectively
    seedNum = [initBH, k - initBH]
    generations::Int64 = 1
    # while loop simulates as long as both populations are present. ends when one (or both) go extinct
    while 0 < seedNum[1] && 0 < seedNum[2]
        seedNum = getNextGen(k, seedNum, bhGermRate, survivalRate, offspringCount, w, envVariance)
        generations += 1
    end
    return seedNum[1] > 0
    # returns True (1) if BH win, False (0) otherwise
end

# parameters:
p = "negctr"
(bhwtRatio, bhGermRate, survivalRate, offspringCount, w, envVariance, maxN, file) = altParams[p]

reps = floor(500 * 10^maxN) # number of replicates
a = range(start=0, stop=maxN, length=10)
allN = [convert(Int64, floor(10^i)) for i in a] # creates a vector of 10 population sizes evenly spaced on a log scale

f = "results/$file g=$bhGermRate s2=$envVariance.csv"
out = open(f, "w") # creates a new output file whose filename includes parameters
write(out, join(["CarryingCap", "NPfix"], ","), "\n") # populates output file with vector of 10 population sizes
close(out)

println("********************************************************")
println(raw"population sizes: " * "$allN")
println("parameters: bhwtRatio, bhGermRate, survivalRate(place holder), offspringCount(place holder), w, envVariance, maxN, file")
println(altParams[p])
println(raw"reps: " * "$reps")
println("********************************************************")

Npfix = Float64[] # creates an empty vector where normalized pfix values will be added
for k in allN # repeats this process at each population size, or carrying capacity
    c = 0 # counts number of replicates that reach fixation
    tick()
    for run = 1 : reps
        c += simulate(k, bhGermRate, survivalRate, offspringCount, w, envVariance) # c increases by 1 for each rep that reaches fixation
    end
    npf = ((c / reps) / bhwtRatio) # calculates normalized probability of fixation

    output = open(f, "a") # adds the NPfix value to the output file
    write(output, join([k, npf], ","), "\n")
    close(output)

    push!(Npfix, npf)

    tock()

    println(raw"carrying capacity: "*"$k"*", bh fixation count: "*"$c")
    println("========================================================")
end
