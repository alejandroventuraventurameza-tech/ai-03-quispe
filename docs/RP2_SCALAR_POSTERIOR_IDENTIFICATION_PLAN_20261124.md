# RP2 continuation — scalar Gaussian posterior identification (24 November 2026)

## Status and scope

This note is a **proof plan and audit**, not a Lean-checked theorem. It leaves the originally generated `lean/` tree unchanged. The most recent verified baseline is Actions #45486549728 (99 audited declarations; paper check --fast PASS). Existing proved components:

1. `bayesA7_scalar_joint_eq_joint_gaussian_density`: the genuine scalar joint law has the prior-PDF times likelihood-PDF density with respect to Lebesgue squared.
2. `bayesA7_scalar_joint_pdf_eq_evidence_gaussian_pdf`: at the level of real functions, the true scalar joint density factors pointwise into the evidence factor and candidate posterior Gaussian PDF.
3. `bayesA7_scalar_observation_marginal_integral_density`: the *actual* observation marginal has a density obtained by integrating the true joint density in latent productivity; this is a measure equality derived by Tonelli.
4. `bayesA7_explicit_gaussian_kernel_eq_normalized_density`: the Gaussian candidate is a measurable Markov kernel with the indicated normalized density.
5. The posterior disintegration and a.e.-uniqueness bridge for the genuine experiment were proved separately, but have not yet been linked to the explicit Gaussian candidate for a positive number of signals.

## Mathematical target: one signal

Write `a > 0` for prior precision, `v > 0` for observation variance, `mu` for prior mean, and `x` for observed signal:

- Prior: `theta ~ N(mu, 1/a)`.
- Signal: `x | theta ~ N(theta, v)`.
- Posterior precision: `tau = a + 1/v > 0`.
- Posterior mean: `m(x) = (a*mu + x/v)/tau`.
- Posterior: `G_x = N(m(x), 1/tau)`.
- Evidence: `e(x) = pdf(N(mu, 1/a+v), x)`.

The completed-square identity, for every `theta,x`, is

`prior_pdf(theta) * likelihood_pdf(x|theta) = e(x) * posterior_pdf(theta|x)`.

Its integration over `theta` gives

`integral prior_pdf(theta) * likelihood_pdf(x|theta) dtheta = e(x)`,

because `G_x` is a probability measure. Combined with the already proven Tonelli result, the actual observation marginal is `volume.withDensity (ENNReal.ofReal ∘ e)`.

## Lean proof obligations (none claimed completed here)

**A. Conversion of real PDF factorization to ENNReal.** Prove nonnegativity of the true PDF factors, of the predictive evidence, and of the candidate posterior PDF under positive precisions/variances. Then use the corresponding `ENNReal.ofReal` multiplicativity lemma to obtain an equality of the actual joint density in the same `ENNReal` type used by `Measure.withDensity`. Do not silently coerce a real integral into a nonnegative Lebesgue integral.

**B. Exact predictive marginal.** Apply the established pointwise factorization under `lintegral`, pull out the nonnegative factor `e(x)`, and use that the conditional Gaussian PDF integrates to one. Derive an equality of actual measures, not merely pointwise formulas:
`observationLaw = volume.withDensity (fun x => ENNReal.ofReal (e x))`.

**C. Candidate posterior disintegration.** Prove the reversed joint measure identity:
`(observationLaw ⊗ₘ G) = (trueJointLaw).map Prod.swap`.
A robust route is to show both measures have identical densities on `volume.prod volume`, using the swap formula and the equality from B. Check the exact order of coordinates and the orientation of `Kernel.compProd`.

**D. Almost-everywhere identification.** Apply the previously proven regular-posterior disintegration and uniqueness theorem, with all kernel/standard-Borel hypotheses explicit, to deduce `G_x = P_x` for observationLaw-a.e. `x`. This is an a.e. assertion; do not strengthen it to all signals without a separate argument.

**E. Arbitrary positive signal count.** Only after A–D succeed for `Fin 1`, extend the density statement to finite products of conditional Gaussian kernels, and prove the vector analogue by Tonelli/Fubini. The `Fin 0` case is already established separately; neither case by itself proves the general theorem.

## Essential audit boundaries

- A `#print axioms` check and successful build certify the formal statement as actually encoded, not its equivalence to the paper.
- Nothing here upgrades the nine source-facing Specs to full equivalence, and none of the statements above should be entered in the theorem inventory as proven until the Lean code actually builds.
- The historical EconCSLib generation retains its original model attribution. Later GPT-6 work and author-declared XHIGH effort do **not** constitute evidence that the assignment's requested `gpt-5.6-sol`/xhigh run occurred.
- Keep PR #2 in draft pending semantic verification and the agent-provenance requirement.

## Immediate implementation order

First implement A and B in a new file under `extensions/`, import `AppendixA7ScalarObservedMarginal`, add precise `#print axioms` checks, run the scoped Lean CI, and only after a green run attempt C and D. The eventual implementation must not mutate the generated `lean/` subtree.
