import QX26AgenticDelegation.AppendixA7BayesianLearning

/-!
# Appendix A.7: square completion and explicit Gaussian-law candidate

This extension uses the exact equations (28)-(29) in arXiv:2605.25438v2.
We establish that, given positive prior precision and positive signal
variances, the unnormalized product kernel is a strictly positive
theta-independent factor times the Gaussian posterior kernel.

We then construct the real Gaussian probability measure having the
computed posterior mean and reciprocal precision, and prove its mean
parameter. This is a candidate constructed from the kernel shape:
it is NOT yet a proof of a regular conditional distribution obtained
by disintegrating a joint Gaussian signal model.

The generated EconCSLib files in lean/ remain untouched.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory

/-- Positive prior precision and positive signal variances give a
strictly positive posterior precision, including when there are no signals. -/
theorem bayesA7_posterior_precision_pos
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ)
    (priorPrecision : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    0 < bayesA7PosteriorPrecision L priorPrecision variance := by
  unfold bayesA7PosteriorPrecision
  have hq := bayesA7_signal_precision_nonneg L variance hVar
  linarith

/-- As a consequence the reciprocal posterior precision is positive. -/
theorem bayesA7_reciprocal_precision_pos
    {ι : Type*} (L : Finset ι) (variance : ι → ℝ)
    (priorPrecision : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    0 < 1 / bayesA7PosteriorPrecision L priorPrecision variance := by
  exact one_div_pos.mpr
    (bayesA7_posterior_precision_pos L variance priorPrecision hPrior hVar)

/-- Completion of the square in the exponent. The additive correction
contains no latent theta and therefore only changes normalization. -/
theorem bayesA7_complete_square
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean θ : ℝ)
    (variance signal : ι → ℝ)
    (hPost : 0 < bayesA7PosteriorPrecision L priorPrecision variance) :
    priorPrecision * (θ - priorMean)^2 +
        ∑ k ∈ L, (signal k - θ)^2 / variance k =
      bayesA7PosteriorPrecision L priorPrecision variance *
        (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2 +
      (priorPrecision * priorMean^2 +
        ∑ k ∈ L, (signal k)^2 / variance k -
        bayesA7PosteriorPrecision L priorPrecision variance *
          (bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) := by
  let P : ℝ := bayesA7PosteriorPrecision L priorPrecision variance
  let M : ℝ := bayesA7PosteriorMean L priorPrecision priorMean variance signal
  let N : ℝ := priorPrecision * priorMean +
    bayesA7WeightedSignalNumerator L variance signal
  let C : ℝ := priorPrecision * priorMean^2 +
    ∑ k ∈ L, (signal k)^2 / variance k
  have hPM : P * M = N := by
    dsimp [P, M, N, bayesA7PosteriorMean]
    field_simp [ne_of_gt hPost]
  calc
    priorPrecision * (θ - priorMean)^2 +
        ∑ k ∈ L, (signal k - θ)^2 / variance k =
      P * θ^2 - 2 * N * θ + C := by
        simpa only [P, N, C] using
          (bayesA7_normal_kernel_quadratic
            L priorPrecision priorMean θ variance signal)
    _ = P * (θ - M)^2 + (C - P * M^2) := by
      rw [← hPM]
      ring

/-- Exact factorization of the unnormalized Bayesian kernel into a
theta-independent exponential and the Gaussian quadratic kernel.
This is stronger than reading off polynomial coefficients but does
not by itself prove normalization or a regular conditional law. -/
theorem bayesA7_exponential_kernel_factorization
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean θ : ℝ)
    (variance signal : ι → ℝ)
    (hPost : 0 < bayesA7PosteriorPrecision L priorPrecision variance) :
    Real.exp (- (priorPrecision * (θ - priorMean)^2 +
      ∑ k ∈ L, (signal k - θ)^2 / variance k) / 2) =
    Real.exp (- (priorPrecision * priorMean^2 +
      ∑ k ∈ L, (signal k)^2 / variance k -
      bayesA7PosteriorPrecision L priorPrecision variance *
        (bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2) *
    Real.exp (- (bayesA7PosteriorPrecision L priorPrecision variance *
      (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2) := by
  rw [bayesA7_complete_square L priorPrecision priorMean θ
    variance signal hPost]
  rw [show
    - (bayesA7PosteriorPrecision L priorPrecision variance *
      (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2 +
      (priorPrecision * priorMean^2 +
        ∑ k ∈ L, (signal k)^2 / variance k -
        bayesA7PosteriorPrecision L priorPrecision variance *
          (bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2)) / 2 =
    - (priorPrecision * priorMean^2 +
        ∑ k ∈ L, (signal k)^2 / variance k -
        bayesA7PosteriorPrecision L priorPrecision variance *
          (bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2 +
    - (bayesA7PosteriorPrecision L priorPrecision variance *
      (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2
    by ring]
  exact Real.exp_add _ _

/-- A genuine (normalized) Gaussian probability law with the
computed posterior mean and inverse precision. It is only a CANDIDATE
posterior until a joint signal model and Bayes conditioning are proved. -/
noncomputable def bayesA7GaussianCandidateLaw
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) : Measure ℝ :=
  ProbabilityTheory.gaussianReal
    (bayesA7PosteriorMean L priorPrecision priorMean variance signal)
    (Real.toNNReal (1 /
      bayesA7PosteriorPrecision L priorPrecision variance))

/-- The Mathlib Gaussian candidate is a probability measure. This
does NOT show that it equals a posterior conditional distribution. -/
theorem bayesA7_gaussian_candidate_probability
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) :
    IsProbabilityMeasure
      (bayesA7GaussianCandidateLaw L priorPrecision priorMean variance signal) := by
  unfold bayesA7GaussianCandidateLaw
  infer_instance

/-- The actual integral mean of the constructed Gaussian candidate
equals the source-updated mean. The probability law is defined as the
Gaussian with those parameters, not inferred by conditioning. -/
theorem bayesA7_gaussian_candidate_mean
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) :
    (∫ θ : ℝ, θ ∂
      bayesA7GaussianCandidateLaw L priorPrecision priorMean variance signal) =
      bayesA7PosteriorMean L priorPrecision priorMean variance signal := by
  unfold bayesA7GaussianCandidateLaw
  exact ProbabilityTheory.integral_id_gaussianReal

end QX26AgenticDelegation
