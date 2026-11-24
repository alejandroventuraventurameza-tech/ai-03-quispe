import QX26AgenticDelegation.AppendixA7ZeroSignalPosterior

/-!
# Appendix A.7: analytic Bayesian evidence is the integrated joint density

The preceding files have verified:
* a pointwise Gaussian joint-density factorization into evidence
  times a precision-weighted normalized Gaussian density;
* normalization of the candidate density to total integral one.

This module combines them to show that the proposed evidence factor
equals the EXACT Lebesgue integral of the scalar joint-density
expression over the latent productivity theta.

This is a substantive likelihood-normalization identity, not a claim
that the finite-dimensional observed-data marginal measure has yet
been identified with this scalar density. The latter requires the
Gaussian product-law / density bridge and Fubini over observations.

The generated lean/ subtree and its historical audit files remain
unchanged.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory

/-- Integrating the prior-times-likelihood Gaussian joint-density
expression over latent theta yields precisely the explicit,
observation-only evidence factor. This step is proved from the
previously verified POINTWISE factorization and the independently
proved unit normalization of the Gaussian candidate. -/
theorem bayesA7_predictive_factor_eq_integral_joint_density
    {ι : Type*} (L : Finset ι)
    (priorPrecision priorMean : ℝ)
    (variance signal : ι → ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k ∈ L, 0 < variance k) :
    (∫ θ : ℝ,
      bayesA7HeightNormalizedJointDensity
        L priorPrecision priorMean variance signal θ) =
      bayesA7PredictiveDensityFactor
        L priorPrecision priorMean variance signal := by
  have hFactor :
      (fun θ : ℝ =>
        bayesA7HeightNormalizedJointDensity
          L priorPrecision priorMean variance signal θ) =
      (fun θ : ℝ =>
        bayesA7PredictiveDensityFactor
          L priorPrecision priorMean variance signal *
        bayesA7NormalizedKernelDensity
          L priorPrecision priorMean variance signal θ) := by
    funext θ
    exact bayesA7_joint_density_eq_evidence_mul_candidate
      L priorPrecision priorMean variance signal θ hPrior hVar
  rw [hFactor, integral_const_mul]
  rw [bayesA7_normalized_density_integral_one
    L priorPrecision priorMean variance signal hPrior hVar]
  ring

/-- The same identity with the finite collection consisting of ALL
n observed signals, including the empty index set n=0. -/
theorem bayesA7_predictive_factor_all_signals
    (n : ℕ) (priorPrecision priorMean : ℝ)
    (variance signal : Fin n → ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k : Fin n, 0 < variance k) :
    (∫ θ : ℝ,
      bayesA7HeightNormalizedJointDensity
        Finset.univ priorPrecision priorMean variance signal θ) =
      bayesA7PredictiveDensityFactor
        Finset.univ priorPrecision priorMean variance signal := by
  exact bayesA7_predictive_factor_eq_integral_joint_density
    Finset.univ priorPrecision priorMean variance signal
    hPrior (fun k _ => hVar k)

end QX26AgenticDelegation
