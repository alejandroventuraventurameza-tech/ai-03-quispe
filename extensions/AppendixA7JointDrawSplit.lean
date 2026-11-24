import QX26AgenticDelegation.AppendixA7PosteriorDisintegration
import Mathlib.MeasureTheory.Constructions.Pi

/-!
# Appendix A.7: split the original Option-indexed joint sampling measure

The initial construction samples a prior theta and one independent
Gaussian error per signal through Measure.pi over Option (Fin n).
The later kernel construction starts from the prior and an independent
noise-vector law. Before identifying their observed-signal joint laws,
we prove the exact measure-theoretic coordinate splitting lemma:
the Option-indexed Measure.pi pushes forward to noise product prior.

This is NOT yet a proof that the posterior regular conditional kernel
is the explicit Gaussian candidate; that separate kernel identity still
requires a joint-density / disintegration argument.

No changes to the generated lean/ paper folder.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- The earlier Option-indexed Gaussian draw law is exactly the product
of the n-dimensional independent-noise law and prior theta law, upon
the canonical measurable reindexing. No positivity assumptions are
needed for this identity, because both sides use the same Mathlib
Gaussian measures (degenerate at zero variance if necessary). -/
theorem bayesA7_draw_law_split_noise_prior
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    Measure.map
        (MeasurableEquiv.piOptionEquivProd
          (fun _ : Option (Fin n) => ℝ))
        (bayesA7JointDrawLaw n priorMean priorPrecision variance) =
      (bayesA7NoiseLaw n variance).prod
        (bayesA7PriorMeasure priorMean priorPrecision) := by
  let e := MeasurableEquiv.piOptionEquivProd
    (fun _ : Option (Fin n) => ℝ)
  have hpi :
      Measure.map e.symm
          ((bayesA7NoiseLaw n variance).prod
            (bayesA7PriorMeasure priorMean priorPrecision)) =
        bayesA7JointDrawLaw n priorMean priorPrecision variance := by
    simpa [e, bayesA7JointDrawLaw, bayesA7NoiseLaw,
      bayesA7PriorMeasure, bayesA7DrawCoordLaw] using
      (Measure.pi_map_piOptionEquivProd
        (bayesA7DrawCoordLaw n priorMean priorPrecision variance))
  change Measure.map e
    (bayesA7JointDrawLaw n priorMean priorPrecision variance) =
      (bayesA7NoiseLaw n variance).prod
        (bayesA7PriorMeasure priorMean priorPrecision)
  rw [← hpi]
  rw [Measure.map_map e.measurable e.symm.measurable]
  simpa [Function.comp_def] using
    (Measure.map_id :
      Measure.map id
        ((bayesA7NoiseLaw n variance).prod
          (bayesA7PriorMeasure priorMean priorPrecision)) =
        (bayesA7NoiseLaw n variance).prod
          (bayesA7PriorMeasure priorMean priorPrecision))


/-- The coordinate split with the economically natural order:
first the latent productivity prior, then the independent errors.
It follows from the noise-first split via the measurable swap of
the product measure; no independence axiom is added. -/
theorem bayesA7_draw_law_split_prior_noise
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    Measure.map
      (fun ω : Option (Fin n) → ℝ =>
        (ω none, fun k : Fin n => ω (some k)))
      (bayesA7JointDrawLaw n priorMean priorPrecision variance) =
      (bayesA7PriorMeasure priorMean priorPrecision).prod
        (bayesA7NoiseLaw n variance) := by
  let e := MeasurableEquiv.piOptionEquivProd
    (fun _ : Option (Fin n) => ℝ)
  calc
    Measure.map
        (fun ω : Option (Fin n) → ℝ =>
          (ω none, fun k : Fin n => ω (some k)))
        (bayesA7JointDrawLaw n priorMean priorPrecision variance) =
      Measure.map (Prod.swap : ((Fin n → ℝ) × ℝ) → (ℝ × (Fin n → ℝ)))
        (Measure.map e
          (bayesA7JointDrawLaw n priorMean priorPrecision variance)) := by
        rw [Measure.map_map measurable_swap e.measurable]
        congr 1
    _ = Measure.map Prod.swap
          ((bayesA7NoiseLaw n variance).prod
            (bayesA7PriorMeasure priorMean priorPrecision)) := by
        rw [bayesA7_draw_law_split_noise_prior]
    _ = (bayesA7PriorMeasure priorMean priorPrecision).prod
          (bayesA7NoiseLaw n variance) := by
        exact Measure.prod_swap

end QX26AgenticDelegation
