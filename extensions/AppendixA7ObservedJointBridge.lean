import QX26AgenticDelegation.AppendixA7JointDrawSplit
import Mathlib.Probability.Kernel.Composition.Lemmas

/-!
# Appendix A.7: the observed joint law is the prior-signal compProd

This closes the previously open joint-model bridge:
  (theta, independent errors) -> (theta, theta + errors)
has the same measure as
  prior(theta) compProd conditionalSignals(theta).

There are two separate proven claims below:
(1) an explicit Fubini/composition-product identity for any number of
    signals and any Gaussian variances represented by Mathlib measures;
(2) applying the Option-indexed product draw splitting verified in
    AppendixA7JointDrawSplit.lean.

Neither statement identifies the conditional posterior with the
explicit precision-weighted Gaussian candidate. That is a different
Bayes density/disintegration theorem.

The original generated lean/ files are never edited.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- Observation map from a latent parameter and independent errors. -/
def bayesA7PriorNoiseToObservedPair (n : ℕ) :
    (ℝ × (Fin n → ℝ)) → (ℝ × (Fin n → ℝ)) :=
  fun z => (z.1, bayesA7SignalMap n z)

/-- Measurability of the joint latent/signal observation map. -/
theorem bayesA7_prior_noise_to_observed_pair_measurable (n : ℕ) :
    Measurable (bayesA7PriorNoiseToObservedPair n) := by
  unfold bayesA7PriorNoiseToObservedPair bayesA7SignalMap
  fun_prop

/-- Fubini identity: the prior times independent noise law, mapped
through the observed signal map, is exactly the joint composition-
product of the prior with the forward conditional-signal kernel. -/
theorem bayesA7_prior_noise_observed_eq_compProd
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    ((bayesA7PriorMeasure priorMean priorPrecision).prod
      (bayesA7NoiseLaw n variance)).map
        (bayesA7PriorNoiseToObservedPair n) =
      (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
        (bayesA7SignalKernel n variance) := by
  let μ := bayesA7PriorMeasure priorMean priorPrecision
  let ν := bayesA7NoiseLaw n variance
  let f := bayesA7PriorNoiseToObservedPair n
  have hf : Measurable f := bayesA7_prior_noise_to_observed_pair_measurable n
  change (μ.prod ν).map f = μ ⊗ₘ bayesA7SignalKernel n variance
  ext s hs
  rw [Measure.map_apply hf hs, Measure.prod_apply (hs.preimage hf)]
  rw [Measure.compProd_apply hs]
  congr 1
  funext θ
  rw [bayesA7_signal_kernel_apply_eq_shifted_noise]
  rw [Measure.map_apply (bayesA7_signal_shift_measurable n θ)
    (measurable_prodMk_left hs)]
  rfl

/-- The actual original Option-indexed sampling experiment yields
exactly the joint prior/conditional-data distribution used by
the regular posterior disintegration theorem. -/
theorem bayesA7_joint_draw_observed_eq_compProd
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    (bayesA7JointDrawLaw n priorMean priorPrecision variance).map
      (fun ω : Option (Fin n) → ℝ =>
        (ω none, fun k : Fin n => ω none + ω (some k))) =
      (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
        (bayesA7SignalKernel n variance) := by
  let split : (Option (Fin n) → ℝ) → (ℝ × (Fin n → ℝ)) :=
    fun ω => (ω none, fun k => ω (some k))
  let f := bayesA7PriorNoiseToObservedPair n
  have hsplit : Measurable split := by
    dsimp [split]
    fun_prop
  have hf : Measurable f := bayesA7_prior_noise_to_observed_pair_measurable n
  calc
    (bayesA7JointDrawLaw n priorMean priorPrecision variance).map
        (fun ω : Option (Fin n) → ℝ =>
          (ω none, fun k : Fin n => ω none + ω (some k))) =
      ((bayesA7JointDrawLaw n priorMean priorPrecision variance).map split).map f := by
        rw [Measure.map_map hf hsplit]
        rfl
    _ = ((bayesA7PriorMeasure priorMean priorPrecision).prod
          (bayesA7NoiseLaw n variance)).map f := by
        rw [show
          (bayesA7JointDrawLaw n priorMean priorPrecision variance).map split =
            (bayesA7PriorMeasure priorMean priorPrecision).prod
              (bayesA7NoiseLaw n variance) from
                bayesA7_draw_law_split_prior_noise n priorMean priorPrecision variance]
    _ = (bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
          (bayesA7SignalKernel n variance) := by
        exact bayesA7_prior_noise_observed_eq_compProd n priorMean priorPrecision variance

end QX26AgenticDelegation
