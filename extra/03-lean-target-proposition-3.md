# Lean target inventory for Proposition 3

## Purpose

This file defines the mathematical claims we want the EconCSLib paper-formalization workflow to locate and verify. It is planning material only. The required `lean/` directory must later be copied exactly from our own EconCSLib run.

## Recommended source-facing objects

- A finite set of initially unfamiliar languages.
- Two hazard functions $p^1,p^2$ taking real values.
- Probability hypotheses $0\le p^1_k\le p^2_k\le1$.
- A natural-number event-time horizon $s$.
- The cumulative-effect finite sum.

## Target 1: nonnegativity

Mathematical statement:

$$
\forall k,\ 0\le p^1_k\le p^2_k\le1
\quad\Longrightarrow\quad
0\le\sum_k\left[(1-p^1_k)^{s+1}-(1-p^2_k)^{s+1}\right].
$$

Candidate Lean shape:

```lean
theorem cumulative_effect_nonneg
    {ι : Type*} [DecidableEq ι]
    (U : Finset ι) (p1 p2 : ι → ℝ) (s : ℕ)
    (hprob : ∀ k ∈ U, 0 ≤ p1 k ∧ p1 k ≤ p2 k ∧ p2 k ≤ 1) :
    0 ≤ ∑ k in U,
      ((1 - p1 k) ^ (s + 1) - (1 - p2 k) ^ (s + 1)) := by
  -- proof to be produced and checked inside EconCSLib
  sorry
```

Expected proof ingredients: nonnegativity of both survival bases, monotonicity of natural powers on nonnegative reals, nonnegativity of each difference, and `Finset.sum_nonneg`.

## Target 2: first-difference identity

Mathematical statement:

$$
d(s+1)-d(s)
=p^2(1-p^2)^{s+1}-p^1(1-p^1)^{s+1}.
$$

This is a ring identity after rewriting powers with $x^{n+1}=x^n x$. It should require no probability library.

## Target 3: corrected strict growth

Hypotheses:

$$
p^1=0,
\qquad
0<p^2<1.
$$

Conclusion:

$$
1-(1-p^2)^{s+1}
<1-(1-p^2)^{s+2}.
$$

The key positive product is

$$
p^2(1-p^2)^{s+1}>0.
$$

## Target 4: corrected strict concavity

Under the same hypotheses, formalize decreasing forward differences:

$$
d(s+2)-d(s+1)<d(s+1)-d(s).
$$

After algebra, this is equivalent to

$$
-(p^2)^2(1-p^2)^{s+1}<0.
$$

## Target 5: endpoint counterexample

At $p^1=0$ and $p^2=1$,

$$
d(s)=1
$$

for every $s\in\mathbb N_0$. In particular,

$$
d(s+1)=d(s),
$$

so the paper’s strict conclusion does not hold at this included probability endpoint.

## Formalization boundary to report

If EconCSLib proves these targets over real-valued hazards and natural powers, Lean verifies the algebraic implication from the hazard assumptions to the cumulative-effect inequalities. It does not verify:

- that the observed data follow a geometric first-use process;
- that hazards are constant across event time;
- that Claude Code causally raises the hazards; or
- that the finite-horizon empirical estimates identify the model parameters.

The required Lean slide should state this boundary explicitly.

