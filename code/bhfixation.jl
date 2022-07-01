using Distributions
using TickTock
using Base.Threads

tick()

function env_select(pA) # function that randomly generates the environment
    env = rand()
    return env <= pA
    # if returns true ==> in env. A; if returns false ==> in env. B
end

function pheno(pSpec, BHcount)
    SpecPhe = rand(Binomial(BHcount, pSpec))
    # generates number of bet hedgers with specialist phenotype
    ConsPhe = BHcount-SpecPhe
    return [SpecPhe, ConsPhe]
    # returns a list with the # of bet hedgers with specialist and conservative phenotypes respectively
end

function average_fitness(PopNum, wBH, wWT)
    return (PopNum[1]*wBH+PopNum[2]*wWT)/(sum(PopNum))
end

function reproduction(env, PopNum, PopSize, spec, cons, phenotype_counts)
    # simulates random wright fisher reproduction in one generation
    wBH = Float64 # bet hedger fitness
    wWT = Float64 # wild type specialist fitness
    if env # collapse if else statement
        # if in env. A
        wBH = phenotype_counts[1]/PopNum[1]*spec[1]+phenotype_counts[2]/PopNum[1]*cons[1]
        wWT = spec[1]
    else
        # else in env. B
        wBH = phenotype_counts[1]/PopNum[1]*spec[2]+phenotype_counts[2]/PopNum[1]*cons[2]
        wWT = spec[2]
    end
    wBar = average_fitness(PopNum, wBH, wWT)
    p=PopNum[1]/PopSize * wBH/wBar
    PopNum[1] = rand(Binomial(PopSize, p))
    # number of bet hedger offspring is pulled randomly from a binomial distribution whose
    # expectation is based on the relative fitness of the bet hedger
    PopNum[2] = PopSize-PopNum[1]
    return PopNum
end

function generation(PopNum, spec, cons, pA, pSpec)
    env = env_select(pA) # determines the environment for this generation
    phenotype_counts = pheno(pSpec, PopNum[1]) # determines the realized phenotypic makeup of the BH
    PopNum = reproduction(env, PopNum, sum(PopNum), spec, cons, phenotype_counts)
    # simulates random wright fisher reproduction
    return PopNum
end

function simulate(PopSize::Int64, pA::Float64, pSpec::Float64, wc::Float64)
    InitNum = 1 # number of bh to start
    PopNum = [InitNum,PopSize-InitNum]
    # PopNum = [# of BH, # of WT]
    spec = [2, 0.5] # specialist phenotype in Env. A and Env. B respectively
    cons = [wc, wc] # conservative phenotype in Env. A and Env. B respectively
    generations::Int64 = 1
    while 0<PopNum[1]<PopSize
        PopNum=generation(PopNum, spec, cons, pA, pSpec)
        generations+=1
    end
    return PopNum[1]==PopSize
    # returns True (1) if BH win, False (0) otherwise
end

# ----------------environment parameters-----------------

# A
# B

pA = 0.5 # probability of being in env. A (normal environment)
sun = Float64 # degree of sunlight. range?
soilPH = Float64 # [1,14] maybe draw from some probability distribution
drought = Float64 # range?
competition = Float64 # range?
pollinator = Float64 # birds, butterflies, etc. range?

# -------------------------------------------------------

# ----------------population parameters------------------

pSpec = 0.5 # proportion of BH offspring with specialist phenotype
# if 0, conservative bet hedger. if 1, WT specialist. if float, diversified bet hedger
wc = 1.0 # fitness of conservative phenotype

germ1WT = Float64 # wt 1st year germ rate
germ1BH = Float64 # bh 1st year germ rate
germ2WT = Float64 # wt 2nd year germ rate
# OR
# assume 100% wt germinates in the 1st year
germ2BH = Float64 # bh 2nd year germ rate
# OR
germLateBH = # represent the late years as a discrete function

maxn = 3 # log(maximum population size). Larger than 6 and the code will take forever to run
a=range(0, stop=maxn, length = 15)
allN=[convert(Int64,floor(10^i)) for i in a] # creates a vector of 10 population
# sizes that are evenly spaced on a log scale

reps = floor(1000*10^maxn) # number of replicates

# -------------------------------------------------------

out = open("results/bhfix_$wc.$pSpec.csv", "w") # creates a new output file whose filename includes parameters
write(out, join(allN, ","), "\n") # populates output file with vector of 10 population sizes
close(out)

println(allN)

Npfix = Float64[] # creates an empty vector where normalized pfix values will be added
for N in allN # repeats this process at each population size
    c = 0 # counts number of replicates that reach fixation
    for run = 1:reps
        c += simulate(N, pA, pSpec, wc) # c increases by 1 for each rep that reaches fixation
    end
    push!(Npfix,((c/reps)*N))
end
println(Npfix)
out = open("results/bhfix_$wc.$pSpec.csv", "a") # adds the NPfix vector to the output file
write(out, join(Npfix, ","), "\n")
close(out)
# end

tock()
