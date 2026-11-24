import QX26AgenticDelegation.AppendixA7ScalarJointFactorization

/-!
# Appendix A.7: Tonelli bridge to the true observed-data marginal

The true scalar (one-signal) prior/signal joint law was previously
proved to have a Gaussian product density relative to Lebesgue^2.
This module applies Tonelli to prove, as an equality of MEASURES,
that its observed-signal marginal is absolutely continuous with a
density given by the Lebesgue integral of that actual joint density
over latent productivity.

This is the crucial bridge from an arbitrary candidate evidence
formula to the real generative observational measure. Identification
of the integral with the closed-form scalar evidence factor is an
additional, separately tracked obligation, as is exact Gaussian
posterior disintegration. Nothing about posterior identity is assumed.

The original generated paper lean/ subtree remains unchanged.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- Generic Tonelli theorem in the form needed by Bayesian inference:
the second marginal of a product-reference density is the
withDensity measure obtained by integrating out the first coordinate.
Neither conditional probabilities nor posterior formulas are assumed. -/
theorem bayesA7_tonelli_snd_of_product_density
    {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]
    (μ : Measure α) (ν : Measure β)
    [SFinite μ] [SFinite ν]
    (f : α × β → ℝ≥0∞) (hf : Measurable f) :
    ((μ.prod ν).withDensity f).snd =
      ν.withDensity (fun y => ∫⁻ x, f (x, y) ∂μ) := by
  ext s hs
  rw [Measure.snd_apply hs]
  have hPre : (Prod.snd ⁻¹' s : Set (α × β)) =
      Set.univ ×ˢ s := by
    ext z
    simp
  rw [hPre]
  rw [withDensity_apply f (MeasurableSet.univ.prod hs)]
  rw [setLIntegral_prod_symm f (hf.aemeasurable.restrict)]
  rw [withDensity_apply _ hs]
  simp

/-- The TRUE marginal distribution of the observed scalar signal,
obtained from the ORIGINAL forward Gaussian kernel, has exactly
the Lebesgue density given by the integral of prior-pdf times
likelihood-pdf over the latent theta.

This is a measure equality, not merely a normalized function name.
The nonnegative scalar density on the RHS is not assumed to be the
marginal; the equality is deduced from the jointly verified model. -/
theorem bayesA7_scalar_observation_marginal_integral_density
    (priorMean priorPrecision variance : ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : 0 < variance) :
    (bayesA7ScalarSignalKernel variance) ∘ₘ
      bayesA7PriorMeasure priorMean priorPrecision =
    (volume : Measure ℝ).withDensity
      (fun x : ℝ => ∫⁻ θ : ℝ,
        gaussianPDF priorMean
          (Real.toNNReal (1 / priorPrecision)) θ *
        gaussianPDF θ (Real.toNNReal variance) x
        ∂(volume : Measure ℝ)) := by
  have hf : Measurable (fun z : ℝ × ℝ =>
      gaussianPDF priorMean
        (Real.toNNReal (1 / priorPrecision)) z.1 *
      gaussianPDF z.1 (Real.toNNReal variance) z.2) :=
    ((measurable_gaussianPDF _ _).comp measurable_fst).mul
      (bayesA7_scalar_likelihood_density_measurable variance)
  calc
    (bayesA7ScalarSignalKernel variance) ∘ₘ
        bayesA7PriorMeasure priorMean priorPrecision =
      ((bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
        bayesA7ScalarSignalKernel variance).snd := by
          exact (Measure.snd_compProd
            (bayesA7PriorMeasure priorMean priorPrecision)
            (bayesA7ScalarSignalKernel variance)).symm
    _ = (((volume : Measure ℝ).prod (volume : Measure ℝ)).withDensity
        (fun z : ℝ × ℝ =>
          gaussianPDF priorMean
            (Real.toNNReal (1 / priorPrecision)) z.1 *
          gaussianPDF z.1 (Real.toNNReal variance) z.2)).snd := by
          rw [bayesA7_scalar_joint_eq_joint_gaussian_density
            priorMean priorPrecision variance hPrior hVar]
    _ = (volume : Measure ℝ).withDensity
        (fun x : ℝ => ∫⁻ θ : ℝ,
          gaussianPDF priorMean
            (Real.toNNReal (1 / priorPrecision)) θ *
          gaussianPDF θ (Real.toNNReal variance) x
          ∂(volume : Measure ℝ)) := by
            exact bayesA7_tonelli_snd_of_product_density
              (volume : Measure ℝ) (volume : Measure ℝ) _ hf

end QX26AgenticDelegation
