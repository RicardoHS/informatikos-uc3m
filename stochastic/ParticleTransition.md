## Stochastic Madrid Particles

## 2A

Let  $\sum_j q_{ij} $ be the probability of particle transtition from $i$ to other areas and $q_i$ the particles escaping to the atmosphere, where $\sum_j q_{ij} + q_i = 1$.  So that the total transition of particles to area $j$ is given by $\sum_i q_{ij}$. 

Let the total number of particles present on area $j$ on day $n$ be a random variable $W_j^n$. And let the number of particles transited from area $i$ to area $j$ on day $n$ be a random variable $B_{ij}^{n}$.   

Then, the expected total number of particles transited to area $j$ will be given by 

$$
\mathbb{E}[B_{ij}^{n}] = \sum_i q_{ij}\mathbb{E}[W_i^{n-1}]
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
\mathbb{E}[W_j^n] = \mathbb{E}[U_j] + \sum_i q_{ij}\mathbb{E}[W_i^{n-1}]
$$

## 2B

> Give an expression of $\textbf w^n = (w_i^n)_i$ in terms of $\mathbf w^{n+1} = (w_i^{n-1})_i$  by means of the law of total expectation

Let $X$ be a random variable and let $A_1, \dots, A_k$ be a sequence of events that partition the sample space. Then, 

$$
\mathbb{E}[X] = \sum \mathbb{E}[X|A_i]P(A_i)
$$

In the same way, let $Y$ be any random variable on the same probability space than $X$. Then,

$$
\mathbb{E}[X] = \mathbb{E}[\mathbb{E}[X|Y]]
$$

Given the Markov Chain problem previously defined, where $w_i^n$ is the expectation of the random variable $W_i^n$ or the expected total number of particles present on area $i$ on day $n$. 

Since $W_i^n$ and $W_i^{n-1}$ follow the same distribution, then

$$
\mathbb{E}[W_i^n] = \mathbb{E}[\mathbb{E}[W_i^n | W_i^{n-1}]]
$$




