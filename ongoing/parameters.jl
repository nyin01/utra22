# invasive annuals seed production range [200, 3000] 
# native annuals seed production range []









# bh12ratio, germRate1, germRate2, survivalRate(place holder), seedProduction(place holder), w, envVariance, maxN, file
bhbhParams = Dict(
    "neutctr0" => 
    [0.5, 1.0, 1.0, -1.0, -1.0, 1.0, 0.0, 3,  "v2_ctr_neut0"],
    "neutctr1" => 
    [0.5, 1.0, 1.0, -1.0, -1.0, 1.0, 0.1, 3,  "v2_ctr_neut1"],
    "neutctr2" => 
    [0.5, 0.6, 0.6, -1.0, -1.0, 1.0, 0.1, 3,  "v2_ctr_neut2"],
)





# ================invasion params===============
# nativeGermRate, nativeSurvivalRate, nativeSeedProduction, nativeW, invasiveGermRate, invasiveSurvivalRate, invasiveSeedProduction, nativeW, envVariance, maxN, file
invasionParams = Dict(
)

# =================old params==================
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

