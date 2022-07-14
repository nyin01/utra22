# bhwtRatio, bhGermRate, pD, wGood, wBad, maxN, file
params = Dict(
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

# alternative set of parameters:
# bhwtRatio, bhGermRate, survivalRate(place holder), offspringCount(place holder), w, envVariance, maxN, file
altParams = Dict(
    # neutral: all BH seeds germinate, BH and WT behave identically
    "neutctr" => 
    [0.5, 1.0, -1.0, -1.0, 1.0, 0.05, 3,  "ctr_neut_alt"],
    "neutctr1" => 
    [0.5, 1.0, -1.0, -1.0, 1.0, 0.0, 3,  "ctr_neut_alt1"],
    "neutctr2" => 
    [0.5, 1.0, -1.0, -1.0, 1.0, 0.5, 3,  "ctr_neut_alt2"],
    # positive control: delayed germination is beneficial when environment has high variance
    "posctr" => 
    [0.5, 0.6, -1.0, -1.0, 1.0, 0.3, 3,  "ctr_pos_alt"],
    # negative control: delayed germination is deleterious when environment has low variance
    "negctr" => 
    [0.5, 0.6, -1.0, -1.0, 1.0, 0.05, 3,  "ctr_neg_alt"],
    # test: Echinocystis lobata
    "test" =>
    [0.5, 0.76, -1.0, -1.0, 1.0, 0.1, 4, "test"],
    # test: Cardamine impatiens
    "test1" =>
    [0.1, 0.8, -1.0, -1.0, 5000.0, 0.3, 4, "test1"],
)