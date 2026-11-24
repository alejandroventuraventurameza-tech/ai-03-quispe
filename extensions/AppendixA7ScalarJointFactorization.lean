import QX26AgenticDelegation.AppendixA7ScalarJointLebesgueDensity

/-!
# Appendix A.7: exact scalar Gaussian joint-pdf Bayes factorization

This file connects the ACTUAL one-signal Gaussian joint density, whose
measure-theoretic representation was established previously, to the
completed-square evidence and explicit posterior-candidate Gaussian
density. The only assumptions are strictly positive prior precision
and signal variance.

The statements are pointwise, not the final posterior disintegration.
The next measure-theoretic obligation is to identify the observed
marginal with the evidence-weighted Lebesgue measure.

The generated `lean/` paper subtree remains unchanged.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory ProbabilityTheory

/-- The real pdf product of the genuine Gaussian prior and the single
Gaussian signal conditional is EXACTLY the height-normalized
prior-times-likelihood expression used in the Bayesian derivation. -/
theorem bayesA7_scalar_joint_real_pdf_eq_height_kernel
    (priorMean priorPrecision variance θ x : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : 0 < variance) :
    gaussianPDFReal priorMean (Real.toNNReal (1 / priorPrecision)) θ *
      gaussianPDFReal θ (Real.toNNReal variance) x =
    bayesA7HeightNormalizedJointDensity
      (Finset.univ : Finset (Fin 1))
      priorPrecision priorMean
      (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) θ := by
  have hExponent :
      -(θ - priorMean)^2 / (2 * (1 / priorPrecision)) +
        -(x - θ)^2 / (2 * variance) =
      -(priorPrecision * (θ - priorMean)^2 +
        (x - θ)^2 / variance) / 2 := by
    field_simp [ne_of_gt hPrior, ne_of_gt hVar]
    ring
  have hRight :
      bayesA7HeightNormalizedJointDensity
        (Finset.univ : Finset (Fin 1))
        priorPrecision priorMean
        (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) θ =
      ((Real.sqrt (2 * Real.pi * (1 / priorPrecision)))⁻¹ *
        (Real.sqrt (2 * Real.pi * variance))⁻¹) *
      Real.exp (-(priorPrecision * (θ - priorMean)^2 +
        (x - θ)^2 / variance) / 2) := by
    simp [bayesA7HeightNormalizedJointDensity,
      bayesA7PriorSignalHeights, bayesA7PriorLikelihoodKernel,
      Finset.univ_unique]
  rw [hRight]
  unfold gaussianPDFReal
  rw [Real.coe_toNNReal _ (le_of_lt (one_div_pos.mpr hPrior))]
  rw [Real.coe_toNNReal _ (le_of_lt hVar)]
  rw [← Real.exp_add, hExponent]
  ring

/-- The exact true scalar joint pdf factorizes pointwise as the
observation-only predictive factor times the normalized Bayesian
posterior-candidate pdf. This is a source-to-measure-density bridge:
the left side is the density already proved to represent the
genuine one-signal generative joint law. -/
theorem bayesA7_scalar_joint_pdf_eq_evidence_candidate
    (priorMean priorPrecision variance θ x : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : 0 < variance) :
    gaussianPDFReal priorMean (Real.toNNReal (1 / priorPrecision)) θ *
      gaussianPDFReal θ (Real.toNNReal variance) x =
      bayesA7PredictiveDensityFactor
        (Finset.univ : Finset (Fin 1))
        priorPrecision priorMean
        (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) *
      bayesA7NormalizedKernelDensity
        (Finset.univ : Finset (Fin 1))
        priorPrecision priorMean
        (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) θ := by
  rw [bayesA7_scalar_joint_real_pdf_eq_height_kernel
    priorMean priorPrecision variance θ x hPrior hVar]
  exact bayesA7_joint_density_eq_evidence_mul_candidate
    (Finset.univ : Finset (Fin 1))
    priorPrecision priorMean
    (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) θ
    hPrior (fun _ _ => hVar)

/-- Therefore the genuine joint density, on the scalar positive-variance
domain, is evidence times the precise Normal pdf with
precision-weighted mean and updated precision of Appendix A.7. -/
theorem bayesA7_scalar_joint_pdf_eq_evidence_gaussian_pdf
    (priorMean priorPrecision variance θ x : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : 0 < variance) :
    gaussianPDFReal priorMean (Real.toNNReal (1 / priorPrecision)) θ *
      gaussianPDFReal θ (Real.toNNReal variance) x =
      bayesA7PredictiveDensityFactor
        (Finset.univ : Finset (Fin 1))
        priorPrecision priorMean
        (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) *
      gaussianPDFReal
        (bayesA7PosteriorMean (Finset.univ : Finset (Fin 1))
          priorPrecision priorMean
          (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x))
        (Real.toNNReal (1 /
          bayesA7PosteriorPrecision (Finset.univ : Finset (Fin 1))
            priorPrecision (fun _ : Fin 1 => variance))) θ := by
  rw [bayesA7_scalar_joint_pdf_eq_evidence_candidate
    priorMean priorPrecision variance θ x hPrior hVar]
  rw [bayesA7_normalized_density_eq_gaussian_pdf
    (Finset.univ : Finset (Fin 1))
    priorPrecision priorMean
    (fun _ : Fin 1 => variance) (fun _ : Fin 1 => x) θ
    hPrior (fun _ _ => hVar)]

end QX26AgenticDelegation
