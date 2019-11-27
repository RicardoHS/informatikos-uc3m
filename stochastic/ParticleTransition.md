## Stochastic Madrid Particles

## 2A

Graph &  classify

### 2Ba

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

### 2Bb

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

TODO

### 2Bc

Being 

$$
\mathbf w^n = \begin{bmatrix}w_1^n\\w_2^n\\w_3^n\\w_4^n\\w_5^n \\ \end{bmatrix} 
\qquad
\mathbf u = \begin{bmatrix}u_1\\u_2\\u_3\\u_4\\u_5\end{bmatrix} \qquad 
\mathbf Q = \begin{bmatrix}q_{11} & \dots & q_{15}  \\ 
    \vdots & \ddots & \vdots  \\
    q_{51} & \dots & q_{55}  \\

    \end{bmatrix}
$$

Show that the expected total number of particles on day $n$ is equal to the sum of emitted particles weighted with the transition probabilities.

$$


\mathbf{w}^n = \mathbf u + \mathbf{uQ} + \dots + \mathbf{uQ^{n-1}} = \mathbf u\sum_{i=0}^{n-1} \mathbf Q^i

$$

Knowing that the expected number of particles is given by

$$
\begin{aligned}
\mathbb{E}[W_j^n] &= \mathbb{E}[U_j] + \sum_i q_{ij}\mathbb{E}[W_i^{n-1}] \\
w_j^n &= u_j + \sum_i q_{ij}w_i^{n-1} \\
\mathbf w^n &= \mathbf u + \mathbf Q\mathbf w^{n-1} \\
\end{aligned}
$$

For the initial state $n=0$, without any transitioning of particles , the statement is true such that $\mathbf w^0 = \mathbf u$ , where $\mathbf w^{-1} = 0$

Asumming that for any state $n\in\mathbb N$ the statement is true we prove that for state $n+1$ it is also true.

$$
\begin{aligned}
\mathbf w^{n+1} &= \mathbf u + \mathbf Q\mathbf w^{n} = \mathbf u + \mathbf Q(\mathbf u + \mathbf Q\mathbf w^{n-1}) \\ 
& =\mathbf u + \mathbf u \mathbf Q + \mathbf Q^{n+1 - (n-1)}\mathbf w^{n-1} = \ldots \\ 
& = \mathbf u \sum_{i=0}^{n} \mathbf Q^i
\end{aligned}
$$

## 2C

Show that $\mathbf w^n \xrightarrow[n\rightarrow \infin]{} \mathbf w$ and show how to compute $\mathbf w$ from $\mathbf u$.

Knowing that $\mathbf w^n = \mathbf u \sum_{i=0}^{n-1} \mathbf Q^i$  we want to study the long term behaviour of $\mathbf w^n$ such that

$$
\lim_{n \rightarrow \infin} \mathbf w^n = \lim_{n \rightarrow \infin} \mathbf u \sum_{i=0}^{n-1}\mathbf Q^i = \mathbf u \sum_{i=0}^{\infin}\mathbf Q^i

$$

Since all states of $\mathbf Q$ are transitories and $0 \leq \sum_j q_{ij} < 1 \ \forall i $ we know that $\mathbf Q^n$ converges to $\mathbf 0$ as $n \rightarrow \infin$. Then,

$$
\sum^\infin_{i=0}\mathbf Q^i = (\mathbb I - \mathbf Q)^{-1}
$$

Therefore, 

$$
\mathbf w = \lim_{n \rightarrow \infin} \mathbf w^n = \mathbf u \sum_{i=0}^{\infin}\mathbf Q^i = \mathbf u (\mathbb I - \mathbf Q)^{-1}
$$

## 2D

> The city council wants to limit pollution levels to a prescribed level by prescribing the amount of particle present every day in each area. Show how to determine the number of emited particles that would result in a prescribed total number of particles.

In order to limit the pollution levels and the amount of $PM_{10}$ ($W_j$), regardless of the possible transitions of particles, constant over time and beyond the scope of the city council, the only way to achieve this limit is, as previously seen, by the random variable $U_i$ that defines the emissions on each area $i$ such that

$$
W_j^n = U_j + \sum_iB_{ij}^n
$$

Therefore, depending on the distribution of $U_j$ and, consequently, its expectation, the number of particles could be controled and prescribed.


