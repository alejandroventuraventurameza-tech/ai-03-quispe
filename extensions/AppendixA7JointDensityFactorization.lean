import QX26AgenticDelegation.AppendixA7ExplicitGaussianKernel

/-!
# Appendix A.7: scalar Gaussian joint-density factorization

For a Gaussian prior N(mu0, 1/pi) and finite independent Gaussian
signal likelihoods N(theta, v_k), the height-normalized unnormalized
joint density is the product of the prior/signal Gaussian normalizers
times the exponential prior-likelihood kernel already derived in Lean.

We prove an *exact pointwise factorization* of this expression into an
observation-only evidence factor and the previously normalized
Gaussian posterior-candidate density.

This is not, by itself, a proof of equality of product-space measures
or identification of the conditional posterior with the Gaussian
candidate. That final disintegration theorem remains open.

No edits to the generated lean/ directory.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory

/-- Product of Gaussian height constants in the prior and all
observed signal likelihoods. The proof that these constants represent
the corresponding Gaussian pdf product is a separate measure step. -/
noncomputable def bayesA7PriorSignalHeights
    {ι : Type*} (L : Finset ι)
    (priorPrecision : ℝ) (variance : ι → ℝ) : ℝ :=
  (Real.sqrt (2 * Real.pi * (1 / priorPrecision)))⁻¹ *
    ∏ k ∈ L, (Real.sqrt (2 * Real.pi * variance k))⁻¹

/-- The height-normalized joint prior/likelihood kernel, in theta
and the fixed vector of signals. -/
noncomputable def bayesA7HeightNormalizedJointDensity
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) (θ : ℝ) : ℝ :=
  bayesA7PriorSignalHeights L priorPrecision variance *
    bayesA7PriorLikelihoodKernel L
      priorPrecision priorMean variance signal θ

/-- The Gaussian posterior pdf height. -/
noncomputable def bayesA7PosteriorGaussianHeight
    {ι : Type*} (L : Finset ι)
    (priorPrecision : ℝ) (variance : ι → ℝ) : ℝ :=
  (Real.sqrt (2 * Real.pi *
    (1 / bayesA7PosteriorPrecision L priorPrecision variance)))⁻¹

/-- The observation-only factor obtained by completing squares,
divided by the posterior Gaussian height. This is the candidate
predictive density factor; its equality with an observed-data
marginal measure density is not asserted here. -/
noncomputable def bayesA7PredictiveDensityFactor
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) : ℝ :=
  bayesA7PriorSignalHeights L priorPrecision variance *
    bayesA7EvidenceKernelFactor L
      priorPrecision priorMean variance signal /
    bayesA7PosteriorGaussianHeight L priorPrecision variance

/-- Exact Bayes factorization of Gaussian-height-normalized
joint density into a theta-independent evidence factor times
the NORMALIZED posterior candidate pdf. The result is genuinely
pointwise for every theta and fixed signal vector, without any
circular posterior-as-conditional-law hypothesis. -/
theorem bayesA7_joint_density_eq_evidence_mul_candidate
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ) (θ : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    bayesA7HeightNormalizedJointDensity
        L priorPrecision priorMean variance signal θ =
      bayesA7PredictiveDensityFactor
        L priorPrecision priorMean variance signal *
      bayesA7NormalizedKernelDensity
        L priorPrecision priorMean variance signal θ := by
  have hPost : 0 < bayesA7PosteriorPrecision
      L priorPrecision variance :=
    bayesA7_posterior_precision_pos
      L variance priorPrecision hPrior hVar
  let H : ℝ := bayesA7PosteriorGaussianHeight
    L priorPrecision variance
  let E : ℝ := bayesA7EvidenceKernelFactor
    L priorPrecision priorMean variance signal
  let C : ℝ := bayesA7PriorSignalHeights
    L priorPrecision variance
  let K : ℝ := bayesA7PriorLikelihoodKernel
    L priorPrecision priorMean variance signal θ
  have hE : E ≠ 0 :=
    ne_of_gt (bayesA7_evidence_kernel_factor_pos
      L priorPrecision priorMean variance signal)
  have hInv : 0 < 1 / bayesA7PosteriorPrecision
      L priorPrecision variance := one_div_pos.mpr hPost
  have hRoot : 0 < Real.sqrt (2 * Real.pi *
      (1 / bayesA7PosteriorPrecision L priorPrecision variance)) := by
    apply Real.sqrt_pos.2
    positivity
  have hH : H ≠ 0 := by
    dsimp [H, bayesA7PosteriorGaussianHeight]
    exact inv_ne_zero (ne_of_gt hRoot)
  change C * K = (C * E / H) * (H * (K / E))
  field_simp [hE, hH]
  ring

end QX26AgenticDelegation
