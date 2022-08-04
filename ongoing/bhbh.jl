using Distributions
using TickTock
using Base.Threads
include("parameters.jl")

function bhGerminate(bhGermRate::Float64, bhSeedNum)
    active = rand(Binomial(bhSeedNum, bhGermRate))
    bhSeeds = [active, bhSeedNum - active]
    return bhSeeds
end

function getFitness(survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    if occursin("ctr", p)
        expectedW = w
    else
        expectedW = survivalRate * offspringCount
    end

    threshold = 0.3 
    
    nVariance = envVariance

    if nVariance > threshold # bad env
        realizedW = rand(TruncatedNormal(expectedW, nVariance, 0.0, expectedW))
    else # good env
        realizedW = rand(truncated(Normal(expectedW, nVariance); lower=0.0))
    end
    return realizedW
end

function randRep(active1::Int64, active2::Int64, realizedW::Float64)
    expectedBH1 = realizedW * active1
    expectedBH2 = realizedW * active2
    realizedOffsprings = [rand(Poisson(expectedBH1)), rand(Poisson(expectedBH2))]
    return realizedOffsprings
end

function resizePop(realizedOffsprings, k::Int64)
    newPop = sum(realizedOffsprings)
    if  newPop > k
        bh1 = rand(Binomial(k, realizedOffsprings[1] / newPop))
        bh2 = k - bh1
        return [bh1, bh2]
    else 
        return [round(Int64, realizedOffsprings[1]), round(Int64, realizedOffsprings[2])]
    end
end

function reproduce(k::Int64, active1::Int64, active2::Int64, survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    realizedW = getFitness(survivalRate, offspringCount, w, envVariance)
    realizedOffsprings = randRep(active1, active2, realizedW)
    newSeeds = resizePop(realizedOffsprings, k)
    return newSeeds
end

function bankStatement(newSeeds, dormantSeeds)
    if occursin("neg", p)
        return newSeeds
    else
        return newSeeds + dormantSeeds
    end
end

function getNextGen(k::Int64, seedNum, germRate1::Float64, germRate2::Float64, survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    (active1, dormant1) = bhGerminate(germRate1, seedNum[1])
    (active2, dormant2) = bhGerminate(germRate2, seedNum[2])
    newSeeds = reproduce(k, active1, active2, survivalRate, offspringCount, w, envVariance)
    nextGenSeedNum = bankStatement(newSeeds, [dormant1, dormant2])
    return nextGenSeedNum
end

function simulate(k::Int64, germRate1::Float64, germRate2::Float64, survivalRate::Float64, offspringCount::Float64, w::Float64, envVariance::Float64)
    bh1 = ceil(Int64, bh12ratio * k)
    seedNum = [bh1, k - bh1]
    generations::Int64 = 1
    while 0 < seedNum[1] && 0 < seedNum[2]
        seedNum = getNextGen(k, seedNum, germRate1, germRate2, survivalRate, offspringCount, w, envVariance)
        generations += 1
    end
    return seedNum[1] > 0
end

# parameters:
p = "neutctr2"
(bh12ratio, germRate1, germRate2, survivalRate, offspringCount, w, envVariance, maxN, file) = bhbhParams[p]

reps = floor(500 * 10^maxN) # number of replicates
a = range(start=0, stop=maxN, length=10)
allN = [convert(Int64, floor(10^i)) for i in a] # creates a vector of 10 population sizes evenly spaced on a log scale

f = "results/$file g1=$germRate1 g2=$germRate2 s2=$envVariance.csv"
out = open(f, "w") # creates a new output file whose filename includes parameters
write(out, join(["CarryingCap", "NPfix"], ","), "\n") # populates output file with vector of 10 population sizes
close(out)

println("********************************************************")
println(raw"population sizes: " * "$allN")
println("parameters: bh12ratio, germRate1, germRate2, survivalRate(place holder), offspringCount(place holder), w, envVariance, maxN, file")
println(bhbhParams[p])
println(raw"reps: " * "$reps")
println("********************************************************")

Npfix = Float64[] # creates an empty vector where normalized pfix values will be added
for k in allN # repeats this process at each population size, or carrying capacity
    c = 0 # counts number of replicates that reach fixation
    tick()
    for run = 1 : reps
        c += simulate(k, germRate1, germRate2, survivalRate, offspringCount, w, envVariance) # c increases by 1 for each rep that reaches fixation
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
