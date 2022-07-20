# old params
# bhwtRatio, bhGermRate, pD, wGood, wBad, maxN, file
oldParams = Dict(
    # neutral: all BH seeds germinate, BH and WT behave identically
    "neutctr" => 
    [0.5, 1.0, 0.0, 1.5, 0.8, 3, "ctr_neut"],
    # positive control: delayed germination is beneficial when environment is consistently bad (dry)
    "posctr" => 
    [0.5, 0.6, 1.0, 1.5, 0.8, 3, "ctr_pos"],
    # negative control: delayed germination is deleterious when environment is consistently good
    "negctr" => 
    [0.5, 0.6, 0.0, 1.5, 0.8, 3, "ctr_neg"]
)

# bhwtRatio, bhGermRate, survivalRate(place holder), seedProduction(place holder), w, envVariance, maxN, file
params = Dict(
    # neutral: all BH seeds germinate, BH and WT behave identically, fitness = 1
    # neutral0: variance=0
    "neutctr0" => 
    [0.5, 1.0, -1.0, -1.0, 1.0, 0.0, 3,  "ctr_neut0"],
    # neutral1: low variance
    "neutctr1" => 
    [0.5, 1.0, -1.0, -1.0, 1.0, 0.1, 3,  "ctr_neut1"],
    # neutral2: high variance
    "neutctr2" => 
    [0.5, 1.0, -1.0, -1.0, 1.0, 0.2, 4,  "ctr_neut2"],

    # positive control: delayed germination is beneficial when environment has high variance
    "posctr" => 
    [0.5, 0.6, -1.0, -1.0, 1.0, 0.3, 3,  "ctr_pos"],
    # negative control: delayed germination is deleterious when environment has low variance
    "negctr" => 
    [0.5, 0.6, -1.0, -1.0, 1.0, 0.05, 3,  "ctr_neg"],
    # test: Echinocystis lobata
    "test" =>
    [0.5, 0.76, -1.0, -1.0, 1.0, 0.1, 4, "test"],
    # test: Cardamine impatiens
    "test1" =>
    [0.1, 0.8, -1.0, -1.0, 5000.0, 0.3, 4, "test1"],
)

# invasion params: nativeGermRate, nativeSurvivalRate, nativeSeedProduction, nativeW
#                  invasiveGermRate, invasiveSurvivalRate, invasiveSeedProduction, nativeW
#                  envVariance, maxN, file
invasionParams = Dict(
    "ctr" => 
    [0.8, -1.0, -1.0, 1.0, 
    0.7, -1.0, -1.0, 1.0,
    0.2, 3,  "ctr"],
)