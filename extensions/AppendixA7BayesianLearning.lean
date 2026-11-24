import QX26AgenticDelegation.Prop1StrictFrontier

/-!
# Appendix A.7: algebra of Gaussian learning, separated from probabilistic conjugacy

Source: Quispe--Xu (2026), arXiv 2605.25438v2, Appendix A.7,
equations (28)-(29). A Normal prior and conditionally independent Gaussian
signals imply the posterior kernel displayed in the source. Here we prove
the ALGEBRAIC consequences of that kernel, given positive signal variances
and positive prior precision. We DO NOT construct Normal probability laws,
conditional independence, or a Bayesian regular conditional posterior.

A signal contributes inverse-variance precision 1 / variance(k).
The posterior mean is (priorPrecision * priorMean + sum x(k)/variance(k))
/ (priorPrecision + sum 1/variance(k)), equivalent to Eq. (29) if the
total signal precision is nonzero.

The older generated EconCSLib subtree lean/ is unchanged.
-/

namespace QX26AgenticDelegation

open Finset

/-- Total precision of L Gaussian signals, q in Equation (29). -/
noncomputable def bayesA7SignalPrecision
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ) : ℝ :=
  ∑ k ∈ L, 1 / variance k

/-- Sum of signals weighted by inverse variances. -/
noncomputable def bayesA7WeightedSignalNumerator
    {ι : Type*} (L : Finset ι)
    (variance signal : ι → ℝ) : ℝ :=
  ∑ k ∈ L, signal k / variance k

/-- Precision-weighted sample mean, defined for positive total precision. -/
noncomputable def bayesA7SignalMean
    {ι : Type*} (L : Finset ι)
    (variance signal : ι → ℝ) : ℝ :=
  bayesA7WeightedSignalNumerator L variance signal /
    bayesA7SignalPrecision L variance

/-- Updated precision pi' = pi + q (Equation 29). -/
noncomputable def bayesA7PosteriorPrecision
    {ι : Type*} (L : Finset ι)
    (priorPrecision : ℝ) (variance : ι → ℝ) : ℝ :=
  priorPrecision + bayesA7SignalPrecision L variance

/-- Updated mean in its direct weighted-numerator form.
This is algebraically equivalent to Equation (29) if q != 0. -/
noncomputable def bayesA7PosteriorMean
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) : ℝ :=
  (priorPrecision * priorMean +
    bayesA7WeightedSignalNumerator L variance signal) /
      bayesA7PosteriorPrecision L priorPrecision variance

/-- Nonnegative signal precision if every signal variance is positive. -/
theorem bayesA7_signal_precision_nonneg
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ)
    (hVariance : ∀ k ∈ L, 0 < variance k) :
    0 ≤ bayesA7SignalPrecision L variance := by
  unfold bayesA7SignalPrecision
  apply Finset.sum_nonneg
  intro k hk
  exact le_of_lt (one_div_pos.mpr (hVariance k hk))

/-- Strict precision gain requires at least one actual positive-precision
signal. With L empty, the source's informal word 'raises' is only weak. -/
theorem bayesA7_signal_precision_pos_of_witness
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ)
    (hVariance : ∀ k ∈ L, 0 < variance k)
    (k₀ : ι) (hk₀ : k₀ ∈ L) :
    0 < bayesA7SignalPrecision L variance := by
  unfold bayesA7SignalPrecision
  apply Finset.sum_pos'
  · intro k hk
    exact le_of_lt (one_div_pos.mpr (hVariance k hk))
  · exact ⟨k₀, hk₀, one_div_pos.mpr (hVariance k₀ hk₀)⟩

/-- Posterior precision is weakly greater than prior precision. -/
theorem bayesA7_posterior_precision_ge
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ)
    (priorPrecision : ℝ)
    (hVariance : ∀ k ∈ L, 0 < variance k) :
    priorPrecision ≤ bayesA7PosteriorPrecision L priorPrecision variance := by
  unfold bayesA7PosteriorPrecision
  have hq := bayesA7_signal_precision_nonneg L variance hVariance
  linarith

/-- Under at least one observed signal, precision strictly rises. -/
theorem bayesA7_posterior_precision_gt
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ)
    (priorPrecision : ℝ)
    (hVariance : ∀ k ∈ L, 0 < variance k)
    (k₀ : ι) (hk₀ : k₀ ∈ L) :
    priorPrecision < bayesA7PosteriorPrecision L priorPrecision variance := by
  unfold bayesA7PosteriorPrecision
  have hq := bayesA7_signal_precision_pos_of_witness
    L variance hVariance k₀ hk₀
  linarith

/-- Equation (29): the posterior mean equals the precision-weighted
prior mean and aggregate signal mean. q>0 avoids dividing by zero. -/
theorem bayesA7_posterior_mean_eq_source
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ)
    (hq : 0 < bayesA7SignalPrecision L variance)
    (hden : 0 < bayesA7PosteriorPrecision L priorPrecision variance) :
    bayesA7PosteriorMean L priorPrecision priorMean variance signal =
      (priorPrecision * priorMean +
        bayesA7SignalPrecision L variance *
          bayesA7SignalMean L variance signal) /
        bayesA7PosteriorPrecision L priorPrecision variance := by
  have hcancel :
      bayesA7SignalPrecision L variance *
          (bayesA7WeightedSignalNumerator L variance signal /
            bayesA7SignalPrecision L variance) =
        bayesA7WeightedSignalNumerator L variance signal := by
    field_simp [ne_of_gt hq]
  unfold bayesA7PosteriorMean bayesA7SignalMean
  rw [hcancel]

/-- A.7's quadratic exponent: expanding the product of a Normal prior
kernel with conditionally independent signal kernels collects the
coefficient of theta^2 as pi + q and its linear coefficient as
-2 * (pi*mu + sum(signal/variance)). This is algebra, not a proof that
the conditional posterior law exists or is Normal. -/
theorem bayesA7_normal_kernel_quadratic
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean θ : ℝ)
    (variance signal : ι → ℝ) :
    priorPrecision * (θ - priorMean)^2 +
        ∑ k ∈ L, (signal k - θ)^2 / variance k =
      bayesA7PosteriorPrecision L priorPrecision variance * θ^2 -
        2 * (priorPrecision * priorMean +
          bayesA7WeightedSignalNumerator L variance signal) * θ +
        (priorPrecision * priorMean^2 +
          ∑ k ∈ L, (signal k)^2 / variance k) := by
  have hsum :
      (∑ k ∈ L, (signal k - θ)^2 / variance k) =
        ∑ k ∈ L, ((signal k)^2 / variance k -
          (2 * θ) * (signal k / variance k) +
          θ^2 * (1 / variance k)) := by
    apply Finset.sum_congr rfl
    intro k hk
    ring
  rw [hsum]
  unfold bayesA7PosteriorPrecision bayesA7SignalPrecision
    bayesA7WeightedSignalNumerator
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
    ← Finset.mul_sum]
  ring

/-- The algebraic model does not force the posterior mean to increase.
For positive pi and q, evidence can move it toward either side of the
signal mean; a sign claim would need an additional comparison. -/
theorem bayesA7_weighted_mean_below_prior_of_signal_below
    (priorPrecision priorMean signalMean q : ℝ)
    (hπ : 0 < priorPrecision)
    (hq : 0 ≤ q)
    (hs : signalMean ≤ priorMean) :
    (priorPrecision * priorMean + q * signalMean) /
      (priorPrecision + q) ≤ priorMean := by
  have hden : 0 < priorPrecision + q := by linarith
  apply (div_le_iff₀ hden).2
  nlinarith [mul_nonneg hq (sub_nonneg.mpr hs)]

end QX26AgenticDelegation
