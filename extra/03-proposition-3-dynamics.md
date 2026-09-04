# Model tutorial 2: Proposition 3 and cumulative language dynamics

## Scope and main message

Proposition 2 explains which unfamiliar-language opportunities can be activated by delegation. Proposition 3 asks what happens after those first uses begin to arrive over time.

The key distinction is between a **flow** and a **stock**:

- Newly used languages are a flow. A particular language can be new only once.
- Cumulative languages are a stock. Once a first use occurs, that language remains in the running count.

This is why the first-use flow can spike and then return toward zero while the cumulative stock continues to rise.

## 1. Formal setup and hidden assumptions

Fix developer $i$ and an initially unfamiliar language $k\in\mathcal U_i$. Let

$$
p^g_{ik}\in[0,1]
$$

be the per-period probability of first use under generation $g\in\{1,2\}$, conditional on the language not having been used previously. Generation 1 is the pre-agent menu and Generation 2 is the menu that includes delegation.

Let

$$
\mathcal T^g_{ik}
$$

be the first period in which the language is used. Event time begins at zero, so horizon $s\in\mathbb N_0$ contains $s+1$ opportunities: periods $0,1,\ldots,s$.

The geometric survival formula used in the paper assumes a constant conditional hazard over these periods:

$$
\Pr(\mathcal T^g_{ik}>s)=(1-p^g_{ik})^{s+1}.
$$

This formula can be read as repeated survival. The language must avoid first use in period 0, then again in period 1, and so on through period $s$. Each survival probability is $1-p^g_{ik}$, producing $s+1$ factors.

The derivation therefore relies on:

1. a discrete horizon $s\ge0$;
2. a valid probability $p^g_{ik}\in[0,1]$;
3. a time-homogeneous conditional first-use hazard, or another assumption strong enough to imply the same geometric survival function; and
4. first use being absorbing for the cumulative count.

Independence across different languages is **not** required for the expectation result. Linearity of expectation is enough when we sum their first-use indicators.

## 2. From survival to cumulative use

Define the cumulative-use indicator

$$
C^g_{ik}(s)=\mathbf 1[\mathcal T^g_{ik}\le s].
$$

It equals one if language $k$ has appeared at least once by horizon $s$. Its expectation is the probability of at least one use:

$$
\mathbb E[C^g_{ik}(s)]
=\Pr(\mathcal T^g_{ik}\le s).
$$

The events $\{\mathcal T^g_{ik}\le s\}$ and $\{\mathcal T^g_{ik}>s\}$ are complements. Therefore

$$
\begin{aligned}
\Pr(\mathcal T^g_{ik}\le s)
&=1-\Pr(\mathcal T^g_{ik}>s)\\
&=1-(1-p^g_{ik})^{s+1}.
\end{aligned}
$$

For developer $i$, the cumulative count contributed by languages that were initially unfamiliar is

$$
C^g_i(s)=\sum_{k\in\mathcal U_i}C^g_{ik}(s).
$$

Taking expectations and applying linearity,

$$
\mathbb E[C^g_i(s)]
=\sum_{k\in\mathcal U_i}
\left[1-(1-p^g_{ik})^{s+1}\right].
$$

## 3. Deriving the treatment contrast

Define the expected cumulative-language effect as

$$
\Delta C_i(s)
=\mathbb E[C^2_i(s)]-\mathbb E[C^1_i(s)].
$$

Substitute the preceding expressions:

$$
\begin{aligned}
\Delta C_i(s)
={}&\sum_{k\in\mathcal U_i}
\left[1-(1-p^2_{ik})^{s+1}\right]\\
&-\sum_{k\in\mathcal U_i}
\left[1-(1-p^1_{ik})^{s+1}\right].
\end{aligned}
$$

Combine the sums. The two constant terms cancel language by language:

$$
\boxed{
\Delta C_i(s)=
\sum_{k\in\mathcal U_i}
\left[
(1-p^1_{ik})^{s+1}-(1-p^2_{ik})^{s+1}
\right]
}.
$$

This is Equation (10) in the paper.

## 4. Why the cumulative effect is nonnegative

Assume

$$
0\le p^1_{ik}\le p^2_{ik}\le1
$$

for every initially unfamiliar language. Subtracting each probability from one reverses the order:

$$
0\le1-p^2_{ik}\le1-p^1_{ik}\le1.
$$

Raising nonnegative ordered numbers to the positive integer power $s+1$ preserves the order:

$$
(1-p^2_{ik})^{s+1}
\le
(1-p^1_{ik})^{s+1}.
$$

Hence every summand satisfies

$$
(1-p^1_{ik})^{s+1}-(1-p^2_{ik})^{s+1}\ge0,
$$

and summing gives

$$
\Delta C_i(s)\ge0.
$$

**Verdict.** This part of Proposition 3 is correct at all probability endpoints. A weakly higher first-use hazard produces a weakly larger probability of having used the language by any fixed horizon.

## 5. Nonnegative does not mean increasing forever

For one language, write

$$
d(s)=(1-p^1)^{s+1}-(1-p^2)^{s+1}.
$$

Its change from horizon $s$ to $s+1$ is

$$
\begin{aligned}
d(s+1)-d(s)
={}&(1-p^1)^{s+2}-(1-p^2)^{s+2}\\
&-(1-p^1)^{s+1}+(1-p^2)^{s+1}.
\end{aligned}
$$

Factor the two pairs:

$$
\begin{aligned}
d(s+1)-d(s)
={}&(1-p^1)^{s+1}[(1-p^1)-1]\\
&-(1-p^2)^{s+1}[(1-p^2)-1].
\end{aligned}
$$

Since $(1-p)-1=-p$,

$$
\boxed{
d(s+1)-d(s)
=p^2(1-p^2)^{s+1}-p^1(1-p^1)^{s+1}
}.
$$

After summing over languages, $\Delta C_i(s)$ grows between $s$ and $s+1$ if and only if

$$
\sum_{k\in\mathcal U_i}
\left[
p^2_{ik}(1-p^2_{ik})^{s+1}
-p^1_{ik}(1-p^1_{ik})^{s+1}
\right]\ge0.
$$

The paper calls this the **no-catch-up condition**.

The condition $p^2\ge p^1$ alone does not guarantee that the gap increases at every horizon. When both hazards are positive, both regimes eventually use the language with probability one. Therefore their cumulative-use probabilities converge and the difference tends to zero:

$$
\lim_{s\to\infty}d(s)=0
\qquad\text{if }0<p^1\le p^2\le1.
$$

The Generation-1 process can eventually catch up even though Generation 2 remains weakly ahead at every finite horizon.

### Catch-up example

Let $p^1=0.2$ and $p^2=0.4$. Then

| Horizon $s$ | $d(s)$ |
|---:|---:|
| 0 | $0.8-0.6=0.2000$ |
| 1 | $0.8^2-0.6^2=0.2800$ |
| 2 | $0.8^3-0.6^3=0.2960$ |
| 3 | $0.8^4-0.6^4=0.2800$ |
| 4 | $0.8^5-0.6^5=0.24992$ |

The effect is always positive, peaks at $s=2$, and then shrinks. This is why the paper only claims strict growth under the stronger closed-frontier benchmark.

## 6. The closed-frontier benchmark

The closed-frontier benchmark sets

$$
p^1=0<p^2=p.
$$

Without agentic delegation, the initially unfamiliar language is never used. The one-language effect becomes

$$
d(s)=1-(1-p)^{s+1}.
$$

### Strict increase

The first difference is

$$
\begin{aligned}
d(s+1)-d(s)
&=\left[1-(1-p)^{s+2}\right]
-\left[1-(1-p)^{s+1}\right]\\
&=(1-p)^{s+1}-(1-p)^{s+2}\\
&=(1-p)^{s+1}[1-(1-p)]\\
&=p(1-p)^{s+1}.
\end{aligned}
$$

If

$$
0<p<1,
$$

both factors are strictly positive, so $d(s+1)>d(s)$.

### Strict discrete concavity

For a sequence, strict concavity means its first differences strictly decrease. Compare successive increments:

$$
\begin{aligned}
&[d(s+2)-d(s+1)]-[d(s+1)-d(s)]\\
&=p(1-p)^{s+2}-p(1-p)^{s+1}\\
&=p(1-p)^{s+1}[(1-p)-1]\\
&=-p^2(1-p)^{s+1}.
\end{aligned}
$$

For $0<p<1$ this expression is strictly negative. The stock keeps growing, but each additional period contributes less because fewer unused languages remain at risk.

### Intuitive numerical example

Let $p=0.4$. The cumulative probability of at least one use is

| Horizon $s$ | $d(s)=1-0.6^{s+1}$ | Increment from prior horizon |
|---:|---:|---:|
| 0 | 0.4000 | — |
| 1 | 0.6400 | 0.2400 |
| 2 | 0.7840 | 0.1440 |
| 3 | 0.8704 | 0.0864 |
| 4 | 0.92224 | 0.05184 |

The cumulative curve rises while flattening. The corresponding first-use flow shrinks because the pool of never-used languages is being depleted.

## 7. The endpoint problem in the paper’s strict claim

The paper states that the closed-frontier benchmark $p^1=0<p^2$ is strictly increasing and concave. If hazards are probabilities, this wording permits $p^2=1$.

At that endpoint,

$$
d(s)=1-(1-1)^{s+1}=1
$$

for every $s\ge0$. The language enters with certainty in the first period. The effect does not increase afterward, and its first differences are zero. Therefore it is neither strictly increasing nor strictly concave over multiple observed horizons.

The corrected statement is:

> In the closed-frontier benchmark $p^1=0$ and $0<p^2<1$, the expected cumulative-language effect is strictly increasing and strictly concave in the discrete event-time horizon. If $p^2=1$, it jumps to one at horizon zero and remains constant, so the conclusions hold only weakly.

This does not undermine the nonnegativity result or the model’s stock-flow intuition. It tightens the domain needed for the strict comparative statement.

## 8. Mapping the proposition to the evidence

The empirical sequence is qualitatively consistent with the stock-flow logic:

- Newly used languages: 1.193 at adoption, 0.126 at event time 1, and -0.018 at event time 2.
- Cumulative languages: 1.604 at adoption, 1.892 at event time 1, and 2.072 at event time 2.

Thus the measured first-use flow spikes and rapidly reverts, while the cumulative-language estimate rises across the reported horizons.

The cumulative outcome has an important weakness: four of its five pre-period coefficients are statistically significant. The paper accordingly treats the cumulative profile as descriptive evidence rather than a headline identified effect. Proposition 3 explains the shape that should arise from first-use hazards; it does not solve the empirical parallel-trends problem.

## 9. A more realistic time-varying extension

The constant-hazard assumption is convenient but strong. Adoption effects may be largest immediately, then decline as easy projects are exhausted or agent novelty fades.

Let $p^g_{ik,r}$ be the conditional first-use hazard in period $r$. The survival probability becomes

$$
\Pr(\mathcal T^g_{ik}>s)
=\prod_{r=0}^{s}(1-p^g_{ik,r}),
$$

and the cumulative effect becomes

$$
\Delta C_i(s)
=\sum_{k\in\mathcal U_i}
\left[
\prod_{r=0}^{s}(1-p^1_{ik,r})
-\prod_{r=0}^{s}(1-p^2_{ik,r})
\right].
$$

If $0\le p^1_{ik,r}\le p^2_{ik,r}\le1$ for every language and period, each Generation-2 survival factor is weakly smaller, so the cumulative effect remains nonnegative. This extension preserves the main ordering result without forcing the same hazard in every month.

## 10. What Lean should verify

The paper-level EconCSLib run must create the eventual `lean/` folder. We should not manufacture that folder inside this repository. For Proposition 3, the useful proof boundary is algebraic:

1. **Nonnegative cumulative effect.** For a finite set of languages, $0\le p^1_k\le p^2_k\le1$ implies the finite sum of powered survival differences is nonnegative.
2. **First-difference identity.** The change in the one-language gap equals $p^2(1-p^2)^{s+1}-p^1(1-p^1)^{s+1}$.
3. **Strict growth under the corrected domain.** If $p^1=0$ and $0<p^2<1$, the first difference is positive.
4. **Strict concavity under the corrected domain.** Under the same assumptions, the second difference is negative.
5. **Endpoint counterexample.** At $p^1=0$ and $p^2=1$, consecutive cumulative effects are equal.

Lean can verify these identities and inequalities without formalizing an entire probability space. What it would not verify under that approach is the behavioral claim that a constant hazard correctly describes developers. That remains an economic modelling assumption.

## 11. Final assessment

The core nonnegativity result follows cleanly from ordered hazards and is mathematically sound. The proposition also explains the difference between a temporary first-use flow and an accumulating stock.

The strict dynamic statement needs two qualifications:

- general ordered positive hazards can produce catch-up, so monotonicity requires the no-catch-up condition; and
- in the closed-frontier benchmark, strict increase and strict concavity require $0<p^2<1$, not merely $p^2>0$.

This endpoint correction is a strong candidate for the presentation’s “where we did not believe the AI or the paper” component because it is precise, consequential for the formal statement, and easy to demonstrate both by hand and in Lean.

## Sources

- [Version 2 PDF](https://arxiv.org/pdf/2605.25438v2): Proposition 3 on PDF-reader page 17 and its proof on pages 63–64.
- [Course issue](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/2): endpoint checking and handwritten-verification requirements.

