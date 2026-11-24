import QX26AgenticDelegation.AppendixA7PredictiveEvidenceIntegral
import Mathlib.Probability.Kernel.CompProdEqIff

/-!
# Appendix A.7 — scalar Gaussian likelihood as an actual kernel density

This is a noncircular measure-theoretic bridge for ONE observed signal.
Unlike the pointwise likelihood algebra, we prove an equality of
conditional measures and then an equality of JOINT probability measures
obtained by composing the prior with the signal kernel.

The scalar kernel is not invented independently of the original model:
it is the pushforward under evaluation at 0 of the already proved
`bayesA7SignalKernel 1` on `Fin 1 -> ℝ`.

We do not yet prove the explicit candidate Gaussian is a regular
posterior for one or more signals. That still requires identifying the
marginal signal density and comparing the swapped joint measures.

Original generated lean/ remains unchanged.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- The observed scalar signal from the exact `Fin 1` kernel model. -/
noncomputable def bayesA7ScalarSignalKernel (variance : ℝ) : Kernel ℝ ℝ :=
  Kernel.map
    (bayesA7SignalKernel 1 (fun _ : Fin 1 => variance))
    (fun x : Fin 1 → ℝ => x 0)

/-- The one-coordinate scalar conditional signal law is Markov. -/
instance bayesA7_scalar_signal_markov (variance : ℝ) :
    IsMarkovKernel (bayesA7ScalarSignalKernel variance) := by
  unfold bayesA7ScalarSignalKernel
  exact Kernel.IsMarkovKernel.map _ (by fun_prop)

/-- The single observed signal, conditional on latent productivity
theta, has precisely the N(theta,variance) measure, not merely a
matching Gaussian-shaped unnormalized function. -/
theorem bayesA7_scalar_signal_apply
    (variance θ : ℝ) :
    bayesA7ScalarSignalKernel variance θ =
      gaussianReal θ (Real.toNNReal variance) := by
  unfold bayesA7ScalarSignalKernel
  rw [Kernel.map_apply _ (by fun_prop)]
  exact bayesA7_conditional_signal_marginal
    1 (fun _ : Fin 1 => variance) θ 0

/-- The scalar Gaussian likelihood is jointly measurable in latent
productivity and the observed signal, for fixed variance. -/
theorem bayesA7_scalar_likelihood_density_measurable
    (variance : ℝ) :
    Measurable
      (fun z : ℝ × ℝ =>
        gaussianPDF z.1 (Real.toNNReal variance) z.2) := by
  unfold gaussianPDF gaussianPDFReal
  fun_prop

/-- Stronger than the fixed-signal likelihood expression:
the genuine Markov kernel equals a Lebesgue-density kernel for
strictly positive signal variance. -/
theorem bayesA7_scalar_signal_eq_withDensity
    (variance : ℝ) (hVar : 0 < variance) :
    bayesA7ScalarSignalKernel variance =
      Kernel.withDensity (Kernel.const ℝ (volume : Measure ℝ))
        (fun θ x => gaussianPDF θ (Real.toNNReal variance) x) := by
  have hf :
      Measurable (Function.uncurry
        (fun θ x : ℝ => gaussianPDF θ (Real.toNNReal variance) x)) := by
    exact bayesA7_scalar_likelihood_density_measurable variance
  apply Kernel.ext
  intro θ
  rw [bayesA7_scalar_signal_apply, Kernel.withDensity_apply _ hf]
  exact gaussianReal_of_var_ne_zero θ
    (ne_of_gt (Real.toNNReal_pos.mpr hVar))

/-- The actual one-signal joint model is a bona fide WITH-DENSITY
measure relative to prior(theta) × Lebesgue(x). This is an equality
of measures on (theta,x), not only a pointwise pdf formula. -/
theorem bayesA7_scalar_joint_eq_withDensity
    (priorMean priorPrecision variance : ℝ)
    (hVar : 0 < variance) :
    (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
      bayesA7ScalarSignalKernel variance =
    ((bayesA7PriorMeasure priorMean priorPrecision).prod
      (volume : Measure ℝ)).withDensity
        (fun z : ℝ × ℝ =>
          gaussianPDF z.1 (Real.toNNReal variance) z.2) := by
  have hf :
      Measurable (Function.uncurry
        (fun θ x : ℝ => gaussianPDF θ (Real.toNNReal variance) x)) :=
    bayesA7_scalar_likelihood_density_measurable variance
  have hK := bayesA7_scalar_signal_eq_withDensity variance hVar
  let κ := Kernel.const ℝ (volume : Measure ℝ)
  let f := fun (θ x : ℝ) => gaussianPDF θ (Real.toNNReal variance) x
  haveI : IsSFiniteKernel (Kernel.withDensity κ f) := by
    have h : Kernel.withDensity κ f = bayesA7ScalarSignalKernel variance :=
      hK.symm
    rw [h]
    infer_instance
  calc
    (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
        bayesA7ScalarSignalKernel variance =
      (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
        (Kernel.withDensity κ f) := by rw [hK]
    _ = ((bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ κ).withDensity
          (fun z : ℝ × ℝ => f z.1 z.2) := by
        exact Measure.compProd_withDensity hf
    _ = ((bayesA7PriorMeasure priorMean priorPrecision).prod
          (volume : Measure ℝ)).withDensity
            (fun z : ℝ × ℝ =>
              gaussianPDF z.1 (Real.toNNReal variance) z.2) := by
        rw [Measure.compProd_const]

end QX26AgenticDelegation
