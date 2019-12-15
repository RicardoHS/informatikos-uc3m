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

As stated in section 11.5.1 of Ross, Sheldon _Introduction To Probability Models_, given $n$ events of a nonhomogeneous Poisson process by time $T$ the $n$ event times are independent with a common density function

$$
f(s) = \frac{\lambda(s)}{m(t)},\ 0<s<T, \quad m(T) = \int^T_0\lambda(s)ds
$$

By simulating $N(T)$, the number of events by time T, and then simulating $N(T)$ random variables from the previous density function we can generate a NHPP.

**COPIAR BONITO REJECTION METHOD**
