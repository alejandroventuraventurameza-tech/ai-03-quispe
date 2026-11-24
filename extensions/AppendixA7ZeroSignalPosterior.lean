import QX26AgenticDelegation.AppendixA7JointDensityFactorization

/-!
# Appendix A.7: genuine posterior identification in the no-signal limit

A noncircular base case of the Gaussian posterior-identification gap.
When n=0, the observed signal vector is the unique function Fin 0 -> R.
Its conditional law is independent of latent productivity, and the
precision-weighted Gaussian candidate equals the prior.

We show that this candidate satisfies the EXACT joint disintegration
identity and is therefore almost everywhere equal to Mathlib's
regular posterior of the original sampling model. This is not yet
the positive-signal n>0 identification, which remains open.

No modification of the original generated lean/ folder.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- The only possible zero-dimensional vector of observed signals. -/
def bayesA7EmptySignal : Fin 0 → ℝ := fun k => Fin.elim0 k

/-- With no observed coordinates, the forward kernel is the Dirac
measure on the unique empty signal vector, independent of theta. -/
theorem bayesA7_zero_signal_kernel_eq_dirac
    (variance : Fin 0 → ℝ) (θ : ℝ) :
    bayesA7SignalKernel 0 variance θ =
      Measure.dirac bayesA7EmptySignal := by
  rw [bayesA7_signal_kernel_eq_gaussian_product]
  exact Measure.pi_of_empty
    (fun k : Fin 0 =>
      gaussianReal θ (Real.toNNReal (variance k)))
    bayesA7EmptySignal

/-- With no observations the updated precision equals prior
precision, and the updated mean equals the prior mean. Thus the
explicit Gaussian candidate is the prior for every empty vector. -/
theorem bayesA7_zero_signal_candidate_eq_prior
    (priorPrecision priorMean : ℝ)
    (variance : Fin 0 → ℝ) (x : Fin 0 → ℝ)
    (hPrior : 0 < priorPrecision) :
    bayesA7ExplicitGaussianKernel 0 priorPrecision priorMean variance x =
      bayesA7PriorMeasure priorMean priorPrecision := by
  have hEmpty : (Finset.univ : Finset (Fin 0)) = ∅ := Finset.univ_eq_empty
  have hP : bayesA7PosteriorPrecision Finset.univ
      priorPrecision variance = priorPrecision := by
    simp [bayesA7PosteriorPrecision, bayesA7SignalPrecision, hEmpty]
  have hM : bayesA7PosteriorMean Finset.univ
      priorPrecision priorMean variance x = priorMean := by
    simp [bayesA7PosteriorMean, bayesA7PosteriorPrecision,
      bayesA7SignalPrecision, bayesA7WeightedSignalNumerator,
      hEmpty, ne_of_gt hPrior] <;>
      field_simp [ne_of_gt hPrior] <;> ring
  rw [bayesA7_explicit_gaussian_kernel_apply]
  unfold bayesA7GaussianCandidateLaw bayesA7PriorMeasure
  rw [hM, hP]

/-- The explicit Gaussian candidate genuinely disintegrates the
original latent-signal joint model when n=0. No hypothesis of
posterior identity is assumed. -/
theorem bayesA7_zero_signal_explicit_disintegration
    (priorPrecision priorMean : ℝ)
    (variance : Fin 0 → ℝ)
    (hPrior : 0 < priorPrecision) :
    ((bayesA7SignalKernel 0 variance) ∘ₘ
      bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
      bayesA7ExplicitGaussianKernel 0 priorPrecision priorMean variance =
    ((bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
      bayesA7SignalKernel 0 variance).map Prod.swap := by
  have hQ : bayesA7SignalKernel 0 variance =
      Kernel.const ℝ (Measure.dirac bayesA7EmptySignal) := by
    apply Kernel.ext
    intro θ
    exact bayesA7_zero_signal_kernel_eq_dirac variance θ
  have hG : bayesA7ExplicitGaussianKernel
      0 priorPrecision priorMean variance =
      Kernel.const (Fin 0 → ℝ)
        (bayesA7PriorMeasure priorMean priorPrecision) := by
    apply Kernel.ext
    intro x
    exact bayesA7_zero_signal_candidate_eq_prior
      priorPrecision priorMean variance x hPrior
  rw [hQ, hG]
  simp only [Measure.const_comp, measure_univ, one_smul,
    Measure.compProd_const, Measure.prod_swap]

/-- The explicit candidate is the true regular conditional posterior
almost surely when there are zero observed signals. This uses the
exact disintegration and uniqueness proved earlier, rather than
concluding a conditional-distribution result from a density shape. -/
theorem bayesA7_zero_signal_explicit_eq_posterior_ae
    (priorPrecision priorMean : ℝ)
    (variance : Fin 0 → ℝ)
    (hPrior : 0 < priorPrecision) :
    bayesA7ExplicitGaussianKernel 0 priorPrecision priorMean variance
      =ᵐ[(bayesA7SignalKernel 0 variance) ∘ₘ
          bayesA7PriorMeasure priorMean priorPrecision]
        bayesA7PosteriorKernel 0 priorMean priorPrecision variance := by
  exact bayesA7_posterior_unique_ae
    0 priorMean priorPrecision variance
    (bayesA7ExplicitGaussianKernel 0 priorPrecision priorMean variance)
    (bayesA7_zero_signal_explicit_disintegration
      priorPrecision priorMean variance hPrior)

end QX26AgenticDelegation
