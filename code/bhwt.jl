using Distributions
using TickTock
using Base.Threads
include("parameters.jl")

function bhGerminate(bhGermRate::Float64, bhSeedNum)
    active = rand(Binomial(bhSeedNum, bhGermRate))
    bhSeeds = [active, bhSeedNum - active]
    return bhSeeds
end

function getFitness(s::Float64, cv::Float64)
    expectedW = 1 + s
    if cv > 0.2
        realizedW = rand(TruncatedNormal(expectedW, cv, 0, expectedW)) # play w this
    else
        realizedW = rand(truncated(Normal(expectedW, cv); lower=0.0))
    end
    return realizedW
end

function randRep(wt::Int64, bhActive::Int64, realizedW::Float64)
    expectedBH = realizedW * bhActive
    expectedWT = realizedW * wt
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

function reproduce(k::Int64, wt::Int64, bhActive::Int64, s::Float64, cv::Float64)
    # randomize pD
    # pD = rand(truncated(Normal(pD, 0.05); lower=0.0))
    # get w (fitness) as function of env
    realizedW = getFitness(s, cv)
    # random reproduction: expected offspring = w * current counts
    # currently no randomization for realizedOffsprings bc w is randomized
    realizedOffsprings = randRep(wt, bhActive, realizedW)
    # resize to carrying capacity
    newSeeds = resizePop(realizedOffsprings, k)
    return newSeeds
end

function bankStatement(newSeeds, bhDormant::Int64)
    # for negative control, assume all seeds in seedbank die (bet hedging ineffective)
    (bh, wt) = newSeeds
    nextGenSeedNum = [bh + bhDormant, wt]
    return nextGenSeedNum
end

function getNextGen(k::Int64, seedNum, bhGermRate::Float64, s::Float64, cv::Float64)
    # generate [bh active seeds, bh dormant seeds] 
    (bhActive, bhDormant) = bhGerminate(bhGermRate, seedNum[1])
    # wt seeds unchanged
    wt = seedNum[2]
    # reproduction, input only active seeds, [bh active seeds, wt seeds]
    newSeeds = reproduce(k, wt, bhActive, s, cv)
    # combine seed bank with new seeds, [bh, wt] 
    nextGenSeedNum = bankStatement(newSeeds, bhDormant)
    return nextGenSeedNum
end

function simulate(k::Int64, bhGermRate::Float64, s::Float64, cv::Float64)
    initBH = ceil(Int64, ratio * k)
    # number of seeds for BH population and non-BH population, respectively
    seedNum = [initBH, k - initBH]
    generations::Int64 = 1
    # while loop simulates as long as both populations are present. ends when one (or both) go extinct
    while 0 < seedNum[1] && 0 < seedNum[2]
        seedNum = getNextGen(k, seedNum, bhGermRate, s, cv)
        generations += 1
    end
    return seedNum[1] > 0
    # returns True (1) if BH win, False (0) otherwise
end

# parameters: 
#   r(bhwtRatio), g(bh germination rate), s(selection coefficient), cv(coefficient of variation), mln(max log population size), f(fileName)

# p = "negctr"
# (r, g, s, cv, mln, f) = bhwtParams[p]

# reps = floor(500 * 10^mln) # number of replicates
# a = range(start=0, stop=mln, length=10)
# allN = [convert(Int64, floor(10^i)) for i in a] # creates a vector of 10 population sizes evenly spaced on a log scale
# popfirst!(allN)

# file = "results/$f.csv"
# out = open(file, "w")
# write(out, join(["k", "g", "s", "cv", "npf"], ","), "\n") 
# close(out)

# println("********************************************************")
# println(raw"carrying capacities: " * "$allN")
# println("parameters: r(bhwtRatio), g(bh germination rate), s(fitness), cv(coefficient of variation), mln(max log population size), f(fileName)")
# println(bhwtParams[p])
# println(raw"reps: " * "$reps")
# println("********************************************************")

# Npfix = Float64[] # creates an empty vector where normalized pfix values will be added
# for k in allN # repeats this process at each population size, or carrying capacity
#     c = 0 # counts number of replicates that reach fixation
#     tick()
#     for run = 1 : reps
#         c += simulate(k, g, s, cv# c increases by 1 for each rep that reaches fixation
#     end
#     npf = ((c / reps) / r) # calculates normalized probability of fixation

#     output = open(file, "a") # adds the NPfix value to the output file
#     write(output, join([k, g, s, cv, npf], ","), "\n")
#     close(output)

#     push!(Npfix, npf)

#     tock()

#     println(raw"carrying capacity: "*"$k"*", bh fixation count: "*"$c")
#     println("========================================================")
# end

# result generation
ratio = 0.5
G = [0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]
S = [0, 0.01, 0.1, 0.5, 1]
K = [10, 100, 1000]
CV = S
# CV = [0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45]
reps = 500 * 10^3

file = "plotting/results/final_results.csv"

for k in K
    for g in G
        for s in S
            for cv in CV
                tick()
                count = 0
                for run = 1 : reps
                    count += simulate(k, g, s, cv)
                end
                npf = ((count / reps) / ratio)
                output = open(file, "a")
                write(output, join([k, g, s, cv, npf], ","), "\n")
                close(output)
                tock()
            end
        end
    end
end

