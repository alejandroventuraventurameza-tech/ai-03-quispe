# Appendix A.7 — Gaussian posterior kernel, candidate law, and boundary of the proof

**Source:** Quispe and Xu (2026), arXiv `2605.25438v2`, Appendix A.7, Equations (28)–(29). **Exact author-source bytes:** [source-manifest](PRIMARY_SOURCE_PIN_20261124.md), including the SHA-256 of `sections/10_appendix.tex`. **Lean file:** [`AppendixA7GaussianKernelBridge.lean`](../extensions/AppendixA7GaussianKernelBridge.lean).

## 1. Mathematical bridge

Let \(\theta\) be unknown productivity; let the normal prior have mean \(\mu\) and precision \(\pi>0\). Conditional on \(\theta\), agent-interaction signals are \(x_\ell=\theta+\varepsilon_\ell\) with \(\varepsilon_\ell\sim N(0,v_\ell)\), \(v_\ell>0\). Under conditional independence, the product of the prior and signal Gaussian **kernels** has exponent

\[
-\frac12 \left[\pi(\theta-\mu)^2+
 \sum_{\ell=1}^L\frac{(x_\ell-\theta)^2}{v_\ell}\right].
\]

Writing \(q=\sum_\ell 1/v_\ell,\;z=\sum_\ell x_\ell/v_\ell,\;P=\pi+q,\;m=(\pi\mu+z)/P\), the square-completion identity is

\[
\pi(\theta-\mu)^2+
 \sum_{\ell=1}^L\frac{(x_\ell-\theta)^2}{v_\ell}
=P(\theta-m)^2+C,
\quad
C=\pi\mu^2+\sum_\ell\frac{x_\ell^2}{v_\ell}-Pm^2.
\]

Thus the unnormalized prior-times-likelihood kernel is

\[
\exp\!\left[-\frac12\left(\pi(\theta-\mu)^2+
 \sum_{\ell}\frac{(x_\ell-\theta)^2}{v_\ell}\right)\right]
=\exp(-C/2)\exp[-P(\theta-m)^2/2].
\]

The factor \(\exp(-C/2)\) is independent of \(\theta\), which justifies reading off the Normal **shape**. Furthermore, \(P>0\) and \(1/P>0\) under positive prior precision and positive signal variances.

## 2. Source-facing proof endpoints

The extension, distinct from the seven previously verified algebraic results in `AppendixA7BayesianLearning.lean`, adds:

1. `bayesA7_posterior_precision_pos`: \(P>0\).
2. `bayesA7_reciprocal_precision_pos`: \(1/P>0\).
3. `bayesA7_complete_square`: exact quadratic completion, with \(C\) independent of \(\theta\).
4. `bayesA7_exponential_kernel_factorization`: exact product of exponential factors.
5. `bayesA7_gaussian_candidate_probability`: `gaussianReal m ((1/P).toNNReal)` is an actual normalized probability measure in Mathlib.
6. `bayesA7_gaussian_candidate_mean`: its actual integral mean is \(m\), using Mathlib's Gaussian theorem.

**Status — VERIFIED IN LEAN:** [GitHub Actions #45333297951](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333297951) **PASS** at commit `7da8bb7d23d7baf8663c5b92a6fee86009000363`: **8,323 compile jobs**, **46 theorem endpoints** inspected without `sorryAx` or `unsafeAx`, paper-scoped `check --fast` passed (**8,315 jobs**), and the new Gaussian bridge emitted **no compiler warnings**. [Execution artifact](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333297951/artifacts/14893230416). The earlier [#45332885440](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45332885440) also passed but produced a harmless unreachable-tactic lint warning, eliminated before the clean rerun.

## 3. Precise stopping point

- **Demonstrated by algebra (subject to Lean CI):** the posterior kernel can be put in Gaussian quadratic form, with explicit mean and precision.
- **A genuine probability measure is constructed:** the Mathlib Gaussian with those parameters. Its normalization and mean are inherited from Mathlib's independent existing Gaussian measure theory.
- **Not demonstrated:** equality of that candidate with the conditional law of \(\theta\) given signals \((x_\ell)_\ell\) under a constructed joint prior-and-signal probability space; conditional independence has **not** been represented by joint random variables. Nor has the normalized Bayes density (prior density × likelihood / marginal evidence) been shown equal to the candidate's density.
- **No statistical identification claim:** this is a theoretical property of a specified Gaussian information model, not an inference from developer-level GitHub adoption outcomes.

Even if the new CI is green, the above absence prevents classifying **full Normal–Normal Bayesian conjugacy** as formally proved. Nor does this extension replace the source-to-`Spec` v11 receipt of EconCSLib.

## 4. Provenance and repeatability

The generated paper folder `lean/` is preserved unchanged. The reviewed six new endpoints live solely in `extensions/`, and a separate GitHub Actions runner imports the entire extension chain and checks it under the pinned Lean/Mathlib revision. [Source v2 SHA-256 manifest](PRIMARY_SOURCE_PIN_20261124.md). No Codex, OpenAI API or manual edits to generated validation status are used.
