# Repository 3 — Quispe and Xu 2026

Quispe, Alexander, and Kevin Xu. 2026. “Agentic Delegation and the Language Frontier of Software Developers: A Model and Evidence from Claude Code on GitHub.” [arXiv:2605.25438v2](https://arxiv.org/abs/2605.25438v2).

## What question the paper answers

Does access to an AI coding agent let developers ship work in programming languages they had not used before, and do GitHub records show that expansion around adoption of Claude Code?

## The answer and its boundary

The model says yes when delegation lowers the entry threshold for an unfamiliar language. It creates an activation band of projects that are not worthwhile under solo or conversational production but become worthwhile when an agent performs part of the language-specific execution. In the data, developers’ language portfolios expand sharply around their first detectable use of Claude Code.

The empirical result is an event-time association, not a definitive causal effect. Adoption is voluntary and may occur precisely because a developer has decided to begin a project in an unfamiliar language.

## The developer’s problem

For every developer-language-month opportunity, the developer chooses the best available production mode. Before agentic adoption the menu is

$$
\mathcal M_1=\{S,C\},
$$

where $S$ is solo production and $C$ is conversational or copilot assistance. Agentic adoption expands the menu to

$$
\mathcal M_2=\{S,C,D\},
$$

where $D$ is delegated production. The language is active under generation $g$ when the best available certainty-equivalent surplus is nonnegative:

$$
Z^g_{ik,t}=\mathbf 1\!\left[\max_{m\in\mathcal M_g}V^m_{ik,t}\ge 0\right].
$$

Conversational assistance adds value proportional to existing language-specific skill. Delegation instead substitutes agent execution for part of that skill, while requiring the developer’s general ability to specify and verify the work.

## Main result with its conditions

Let $T^S$ be the solo activation threshold and $T^D$ the delegation threshold for an unfamiliar language. Assumption 1 requires conversational assistance not to lower the unfamiliar-language threshold, so $T^1=T^S$. Define the delegation advantage as

$$
B=T^S-T^D.
$$

Using the model’s primitives, this difference is

$$
B=\lambda[az(A)-s\mu]-\kappa(a,s)-r_D
+\frac{\rho}{2}\left[
\frac{(2\lambda-\lambda^2)s^2}{\pi}-\sigma_D^2(a,s,A)
\right].
$$

If $B>0$, then $T^D<T^S$ and Proposition 2 gives

$$
Z^2_{ik,t}-Z^1_{ik,t}
=\mathbf 1\!\left[T^D_{ik,t}\le \omega_{ik,t}<T^S_{ik,t}\right].
$$

Thus delegation activates exactly the middle band of opportunities that were too weak for solo or conversational production but are strong enough under delegation. With a continuous conditional opportunity distribution $F$, the activation probability is

$$
F(T^S_{ik,t})-F(T^D_{ik,t}).
$$

Menu expansion also implies the weak path-by-path result $N^2_{it}\ge N^1_{it}$ because the developer can always ignore the delegation option. This is an expansion of the **production frontier**, not proof that the developer learned the unfamiliar language.

A line-by-line derivation and the first endpoint audit are in [the model tutorial](extra/02-model-thresholds-and-activation-band.md).

### Dynamic implication

Let $p^g_{ik}$ be the constant per-period first-use hazard for an initially unfamiliar language under generation $g$. For an integer horizon $s\ge0$, if $0\le p^1_{ik}\le p^2_{ik}\le1$ for every unfamiliar language, Proposition 3 gives

$$
\Delta C_i(s)=\sum_{k\in\mathcal U_i}
\left[(1-p^1_{ik})^{s+1}-(1-p^2_{ik})^{s+1}\right]\ge0.
$$

In the closed-frontier benchmark $p^1_{ik}=0$, the effect is strictly increasing and strictly concave when $0<p^2_{ik}<1$. The endpoint $p^2_{ik}=1$ requires a correction to the paper’s strict claim: the language enters immediately and the cumulative effect is flat thereafter. The [Proposition 3 tutorial](extra/03-proposition-3-dynamics.md) gives the proof and endpoint audit.

## Evidence in one paragraph

The paper studies 5,346 developers over a 28-month panel and reconstructs approximately 3.2 million commits touching 57 million files. Around first detectable Claude Code use, active languages rise by 2.5 from a pre-adoption mean of 0.9, newly used languages rise by 1.2, and language entropy rises by 0.38. The estimates survive several mechanical-exposure and activity checks, but they cannot eliminate selection into the timing of adoption.

## Sources

- [Paper, version 2](https://arxiv.org/abs/2605.25438v2)
- [Course issue and submission requirements](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/2)
- [Worked repository template](https://github.com/alexanderquispe/ai-01-aouad)
