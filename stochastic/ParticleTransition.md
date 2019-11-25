

## Stochastic Madrid Particles

Let  $\sum_j q_{ij} $ be the probability of particle transtition from $i$ to other areas and $q_i$ the particles escaping to the atmosphere, where $\sum_j q_{ij} + q_i = 1$.  So that the total transition of particles to area $j$ is given by $\sum_i q_{ij}$. 

Let the total number of particles present on area $j$ on day $n$ be a random variable $W_j^n$. And let the number of particles transited from area $i$ to area $j$ on day $n$ be a random variable $B_{ij}^{n}$.   

Then, the expected total number of particles transited to area $j$ will be given by 

$$
\mathbb{E}[B_{ij}^{n}] = \sum_i q_{ij}W_i^{n-1}
$$

Or the total particles on area $i$ weighted with the probability of transition to area $j$. Therefore, this can be reformulated as the success that a particle transits from area $i$ to area $j$. Such that

$$
B_{ij}^n \sim Bin(W_i^{n-1}, q_{ij})
$$

An area $j$ emits every day a number of particles given by the random variable $U_j$. So that the total number of particles on day $n$ on area $j$, $W_j^n$, will be given by the particles emitted that day plus the particles of the previous day transited from other areas. That is

$$
W_j^n = U_j + \sum_iB_{ij}^n
$$

Being the expected number of particles on day $n$

$$
\mathbb{E}[W_j^n] = \mathbb{E}[U_j] + \sum_i q_{ij}W_i^{n-1}
$$




