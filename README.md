# Simulating Bet Hedging Strategies of Native and Exotic Annual Plants
*Check out simulation results + more plots located under the plotting folder!* 

[updated 8/4]

## Parameters
### Germination rate(G)
Percentage of new seeds that germinate in the very next year; the rest go into seed bank
### Carrying Capacity(K)
Maximum sustainable population size; both populations are scaled down when K is exceeded
### Selection Coefficient(S)
Measures difference in relative fitness; expected fitness(E[W]) = 1 + S.

We use high selection coefficients to represent exotic species which typically have a larger advantage in the region.
### Coefficient of Variation(CV)
Measures the degree of environmental change; realized fitness(W) is drawn from a normal distribution of (E[W], CV).

We assume that when CV > 0.2 (when environment is changing rapidly and drastically), W should not be higher than expectation; therefore at CV > 0.2 we only draw W from the left side of the normal distribution.

## Measurement
### Normalized Probability of Fixation *of bet hedgers* (NPfix)
We count the simulations where BH reached fixation, divide it by the total number of simulations ran, and normalize the probability by the ratio of WT:BH (1:1).

## Code execution
### Testing
Testing parameters are located in parameters.jl under /code. K values are taken from 10 even intervals from a log scale. 
### Running
The actual simulation requires a slightly different way of execution; as a result the parameters are located directly in bhwt.jl below the commented section.

For every combination of parameters we run the simulation 500 * 10^3 times.
