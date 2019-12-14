# Stochastic Assignment 2

Knowing that, as stated in Section 6.7 of Dobrow RP *Introduction to Stochastic Processes with R*, a nonhomogeneous Poisson process is a counting process $(N_t)_{t\geq0}$ with intensity function $\lambda(t)$ if

- $N_0 = 0$

- For all $t>0$, $N_t$ has a Poisson distribution with mean
  
  $$
  \mathbb{E}[N_t] = \int^t_0\lambda(x)dx
  $$

- For $0\leq q < r \leq s < t$, $N_r - N_q$ and $N_t - N_s$ are independent random variables.

We can model the number of retweets (counting process) with a nonhomogeneous process with intensity function $\lambda(t) = \theta e^{-\theta t}$.



## 1C

Since nonhomogeneous Poisson processes expected values follow a Poisson distribution such that $\mathbb{E}[N_t] = \int^t_0\lambda(x)dx$ we can, for any time interval, simulate data for any given process.

As stated in section 11.5.1 of Ross, Sheldon _Introduction To Probability Models_


