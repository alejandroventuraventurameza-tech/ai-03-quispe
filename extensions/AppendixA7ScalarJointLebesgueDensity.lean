import QX26AgenticDelegation.AppendixA7ScalarLikelihoodDensity

/-!
# Appendix A.7 — one-signal joint density w.r.t. Lebesgue × Lebesgue

The preceding module proved that the genuine forward conditional
signal kernel for Fin 1 is Gaussian, and that prior ⊗ₘ signal has a
density with respect to prior × Lebesgue.

This module performs the remaining prior-density conversion:
the Gaussian prior is also a withDensity of Lebesgue, so the actual
joint prior/signal distribution is a withDensity of Lebesgue² whose
density is the *product of the prior pdf and the signal likelihood pdf*.

This is a true equality of measures for the original (evaluated)
one-signal experiment. It does NOT automatically identify the
posterior regular conditional measure; the swapped disintegration
and explicit predictive marginal still need to be derived.

No changes to generated lean/ artifacts.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- Under positive prior precision, the original latent-productivity
prior measure equals the corresponding Gaussian Lebesgue density. -/
theorem bayesA7_prior_eq_gaussian_withDensity
    (priorMean priorPrecision : ℝ)
    (hPrior : 0 < priorPrecision) :
    bayesA7PriorMeasure priorMean priorPrecision =
      (volume : Measure ℝ).withDensity
        (gaussianPDF priorMean (Real.toNNReal (1 / priorPrecision))) := by
  unfold bayesA7PriorMeasure
  exact gaussianReal_of_var_ne_zero priorMean
    (ne_of_gt (Real.toNNReal_pos.mpr (one_div_pos.mpr hPrior)))

/-- Joint PRIOR x one-signal observation law is exactly a
Gaussian product-of-pdfs density relative to Lebesgue^2.
There are no posterior assumptions in this proof. -/
theorem bayesA7_scalar_joint_eq_joint_gaussian_density
    (priorMean priorPrecision variance : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : 0 < variance) :
    (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
      bayesA7ScalarSignalKernel variance =
    ((volume : Measure ℝ).prod (volume : Measure ℝ)).withDensity
      (fun z : ℝ × ℝ =>
        gaussianPDF priorMean
          (Real.toNNReal (1 / priorPrecision)) z.1 *
        gaussianPDF z.1 (Real.toNNReal variance) z.2) := by
  rw [bayesA7_scalar_joint_eq_withDensity priorMean priorPrecision variance hVar]
  rw [bayesA7_prior_eq_gaussian_withDensity priorMean priorPrecision hPrior]
  have hf :
      Measurable (gaussianPDF priorMean
        (Real.toNNReal (1 / priorPrecision))) :=
    measurable_gaussianPDF _ _
  rw [prod_withDensity_left hf]
  have hg : Measurable (fun z : ℝ × ℝ =>
      gaussianPDF z.1 (Real.toNNReal variance) z.2) :=
    bayesA7_scalar_likelihood_density_measurable variance
  rw [← withDensity_mul
    ((volume : Measure ℝ).prod (volume : Measure ℝ))
    (hf.comp measurable_fst) hg]
  rfl

end QX26AgenticDelegation
