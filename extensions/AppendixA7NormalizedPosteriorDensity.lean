import QX26AgenticDelegation.AppendixA7GaussianKernelBridge

/-!
# Appendix A.7: normalized Bayesian kernel as a Gaussian density

Source: Quispe--Xu (2026), arXiv:2605.25438v2,
Appendix A.7 equations (28)-(29).
Source TeX bytes are pinned separately in docs/PRIMARY_SOURCE_PIN_20261124.md.

We prove that the prior-times-independent-Gaussian-signal KERNEL,
when normalized by its explicitly defined Gaussian height and
observation-only exponential factor, is pointwise equal to Mathlib's
gaussianPDFReal for posterior mean m and variance 1/P.
Its Lebesgue integral equals 1 and the resulting withDensity
measure coincides with the previously constructed Gaussian candidate.

This proves an exact conditional-data density formula for each fixed
signal vector, NOT the disintegration of an explicitly constructed
joint prior+signals law. The signal independence is used in the
SOURCE derivation of the product likelihood, but it is not yet
encoded as independence of random variables in this module.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory

/-- Prior × independent-signal Gaussian *kernel* as a function of
unobserved productivity theta. Omits constants independent of theta. -/
noncomputable def bayesA7PriorLikelihoodKernel
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) (θ : ℝ) : ℝ :=
  Real.exp (-
    (priorPrecision * (θ - priorMean)^2 +
      ∑ k ∈ L, (signal k - θ)^2 / variance k) / 2)

/-- The observation-only Gaussian factor left by completing squares. -/
noncomputable def bayesA7EvidenceKernelFactor
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) : ℝ :=
  Real.exp (-
    (priorPrecision * priorMean^2 +
      ∑ k ∈ L, (signal k)^2 / variance k -
      bayesA7PosteriorPrecision L priorPrecision variance *
        (bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2)

/-- Pointwise normalized Bayes density. The denominator is never
zero; the Gaussian height is evaluated at variance 1/posterior precision.
For a genuine probability-density interpretation the precision and
every signal variance must be positive (hypotheses of the theorems). -/
noncomputable def bayesA7NormalizedKernelDensity
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) (θ : ℝ) : ℝ :=
  (Real.sqrt (2 * Real.pi *
    (1 / bayesA7PosteriorPrecision L priorPrecision variance)))⁻¹ *
      (bayesA7PriorLikelihoodKernel L priorPrecision priorMean variance signal θ /
        bayesA7EvidenceKernelFactor L priorPrecision priorMean variance signal)

/-- The normalizing observation-only factor is strictly positive. -/
theorem bayesA7_evidence_kernel_factor_pos
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) :
    0 < bayesA7EvidenceKernelFactor L priorPrecision priorMean variance signal := by
  unfold bayesA7EvidenceKernelFactor
  exact Real.exp_pos _

/-- Factorization identifies the normalized density with a Gaussian
quadratic kernel at the parameters of equation (29). -/
theorem bayesA7_normalized_kernel_eq_gaussian_shape
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) (θ : ℝ)
    (hP : 0 < bayesA7PosteriorPrecision L priorPrecision variance) :
    bayesA7NormalizedKernelDensity L priorPrecision priorMean variance signal θ =
      (Real.sqrt (2 * Real.pi *
        (1 / bayesA7PosteriorPrecision L priorPrecision variance)))⁻¹ *
      Real.exp (-
        (bayesA7PosteriorPrecision L priorPrecision variance *
        (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2) := by
  have hFactor :
      bayesA7PriorLikelihoodKernel L priorPrecision priorMean variance signal θ =
        bayesA7EvidenceKernelFactor L priorPrecision priorMean variance signal *
        Real.exp (-
          (bayesA7PosteriorPrecision L priorPrecision variance *
          (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2) := by
    unfold bayesA7PriorLikelihoodKernel bayesA7EvidenceKernelFactor
    exact bayesA7_exponential_kernel_factorization
      L priorPrecision priorMean θ variance signal hP
  have hDiv :
      bayesA7PriorLikelihoodKernel L priorPrecision priorMean variance signal θ /
          bayesA7EvidenceKernelFactor L priorPrecision priorMean variance signal =
        Real.exp (-
          (bayesA7PosteriorPrecision L priorPrecision variance *
          (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2) := by
    apply (div_eq_iff (ne_of_gt
      (bayesA7_evidence_kernel_factor_pos L priorPrecision priorMean variance signal))).2
    simpa only [mul_comm] using hFactor
  unfold bayesA7NormalizedKernelDensity
  rw [hDiv]

/-- Fixed-data normalized Bayesian density is *pointwise* the Mathlib
Gaussian PDF with updated mean and variance. Thus this is more than
matching unnormalized kernels or constructing a candidate by name. -/
theorem bayesA7_normalized_density_eq_gaussian_pdf
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) (θ : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    bayesA7NormalizedKernelDensity L priorPrecision priorMean variance signal θ =
      ProbabilityTheory.gaussianPDFReal
        (bayesA7PosteriorMean L priorPrecision priorMean variance signal)
        (Real.toNNReal (1 / bayesA7PosteriorPrecision L priorPrecision variance)) θ := by
  have hP : 0 < bayesA7PosteriorPrecision L priorPrecision variance :=
    bayesA7_posterior_precision_pos L variance priorPrecision hPrior hVar
  rw [bayesA7_normalized_kernel_eq_gaussian_shape
    L priorPrecision priorMean variance signal θ hP]
  unfold ProbabilityTheory.gaussianPDFReal
  rw [Real.coe_toNNReal _ (le_of_lt (one_div_pos.mpr hP))]
  have hExponent :
      - (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2 /
        (2 * (1 / bayesA7PosteriorPrecision L priorPrecision variance)) =
      - (bayesA7PosteriorPrecision L priorPrecision variance *
        (θ - bayesA7PosteriorMean L priorPrecision priorMean variance signal)^2) / 2 := by
    field_simp [ne_of_gt hP]
  rw [hExponent]

/-- The observed-data normalized Bayes density has integral 1 under
Lebesgue volume; this is not imposed as an external normalization axiom. -/
theorem bayesA7_normalized_density_integral_one
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    (∫ θ : ℝ, bayesA7NormalizedKernelDensity L priorPrecision priorMean
      variance signal θ) = 1 := by
  have hv :
      Real.toNNReal (1 / bayesA7PosteriorPrecision L priorPrecision variance) ≠ 0 :=
    ne_of_gt (Real.toNNReal_pos.mpr
      (bayesA7_reciprocal_precision_pos L variance priorPrecision hPrior hVar))
  have hEq :
      (fun θ : ℝ =>
        bayesA7NormalizedKernelDensity L priorPrecision priorMean variance signal θ) =
      ProbabilityTheory.gaussianPDFReal
        (bayesA7PosteriorMean L priorPrecision priorMean variance signal)
        (Real.toNNReal (1 / bayesA7PosteriorPrecision L priorPrecision variance)) := by
    funext θ
    exact bayesA7_normalized_density_eq_gaussian_pdf
      L priorPrecision priorMean variance signal θ hPrior hVar
  rw [hEq]
  exact ProbabilityTheory.integral_gaussianPDFReal_eq_one _ hv

/-- The Lebesgue withDensity measure built from the *normalized* Bayes
kernel equals the Gaussian candidate from the previous module.
This is measure equality, conditional on an OBSERVED finite signal
vector; it is not a theorem about disintegration of a joint law. -/
theorem bayesA7_normalized_density_measure_eq_gaussian_candidate
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    volume.withDensity
      (fun θ : ℝ => ENNReal.ofReal
        (bayesA7NormalizedKernelDensity L priorPrecision priorMean variance signal θ)) =
      bayesA7GaussianCandidateLaw L priorPrecision priorMean variance signal := by
  have hv :
      Real.toNNReal (1 / bayesA7PosteriorPrecision L priorPrecision variance) ≠ 0 :=
    ne_of_gt (Real.toNNReal_pos.mpr
      (bayesA7_reciprocal_precision_pos L variance priorPrecision hPrior hVar))
  unfold bayesA7GaussianCandidateLaw
  rw [ProbabilityTheory.gaussianReal_of_var_ne_zero _ hv]
  congr 1
  funext θ
  change ENNReal.ofReal
    (bayesA7NormalizedKernelDensity L priorPrecision priorMean variance signal θ) =
    ENNReal.ofReal
      (ProbabilityTheory.gaussianPDFReal
        (bayesA7PosteriorMean L priorPrecision priorMean variance signal)
        (Real.toNNReal (1 / bayesA7PosteriorPrecision L priorPrecision variance)) θ)
  exact congrArg ENNReal.ofReal
    (bayesA7_normalized_density_eq_gaussian_pdf
      L priorPrecision priorMean variance signal θ hPrior hVar)

end QX26AgenticDelegation
