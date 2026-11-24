import QX26AgenticDelegation.AppendixA7NormalizedPosteriorDensity
import Mathlib.Probability.Independence.Basic

/-!
# Appendix A.7: genuine joint Gaussian prior and independent signal noises

The previously checked files establish the normalized fixed-data posterior
Gaussian PDF, but not a joint model for prior productivity and data.
This module constructs ONE actual finite-dimensional probability space:
  coordinate none   = latent productivity theta, N(mu, 1/pi)
  coordinate some k = noise epsilon_k, N(0, variance_k).

The coordinate random variables are mutually independent by Mathlib's
finite product-measure theorem. The observed data are X_k = theta + epsilon_k.
Hence the model provides the original prior and Gaussian signal marginals,
including the unconditional Gaussian marginal of each X_k.

The signals X_k are generally NOT unconditionally independent because they
share theta. Conditional independence GIVEN theta and an equality of the
regular conditional law of theta given all X remain additional theorems.
No such conclusion is smuggled into this file via a hypothesis.

The generated EconCSLib lean/ subtree remains unchanged.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- Gaussian law for each coordinate of the joint sampling space.
The coordinate 'none' carries the latent prior; 'some k' carries a
zero-mean signal noise. Positivity of variance and precision are stated
separately when an economic Normal-with-positive-variance claim is made. -/
noncomputable def bayesA7DrawCoordLaw
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) (j : Option (Fin n)) : Measure ℝ :=
  match j with
  | none => gaussianReal priorMean (Real.toNNReal (1 / priorPrecision))
  | some k => gaussianReal 0 (Real.toNNReal (variance k))

/-- Each coordinate law is a probability measure. Registering this
instance explicitly is essential to allow Mathlib to infer the
whole family-level product-probability and independence instances. -/
instance bayesA7_draw_coordinate_probability
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) (j : Option (Fin n)) :
    IsProbabilityMeasure (bayesA7DrawCoordLaw n priorMean priorPrecision variance j) := by
  cases j with
  | none =>
      unfold bayesA7DrawCoordLaw
      infer_instance
  | some k =>
      unfold bayesA7DrawCoordLaw
      infer_instance

/-- Product probability space supporting one prior draw and n
independent centered Gaussian noise draws. -/
noncomputable def bayesA7JointDrawLaw
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) : Measure (Option (Fin n) → ℝ) :=
  Measure.pi (bayesA7DrawCoordLaw n priorMean priorPrecision variance)

/-- The actual product law is a probability measure. -/
theorem bayesA7_joint_draw_probability
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    IsProbabilityMeasure (bayesA7JointDrawLaw n priorMean priorPrecision variance) := by
  unfold bayesA7JointDrawLaw
  infer_instance

/-- Under the product joint law, the latent productivity coordinate
and all Gaussian errors are mutually independent. -/
theorem bayesA7_joint_coordinates_independent
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    iIndepFun (fun j : Option (Fin n) =>
      fun ω : Option (Fin n) → ℝ => ω j)
      (bayesA7JointDrawLaw n priorMean priorPrecision variance) := by
  unfold bayesA7JointDrawLaw
  simpa only [id_eq] using
    (iIndepFun_pi
      (μ := bayesA7DrawCoordLaw n priorMean priorPrecision variance)
      (X := fun _ : Option (Fin n) => (id : ℝ → ℝ))
      (fun _ => (measurable_id : Measurable (id : ℝ → ℝ)).aemeasurable))

/-- The actual latent variable in the joint model has the
specified Gaussian prior distribution. -/
theorem bayesA7_joint_prior_marginal
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    (bayesA7JointDrawLaw n priorMean priorPrecision variance).map
      (fun ω : Option (Fin n) → ℝ => ω none) =
      gaussianReal priorMean (Real.toNNReal (1 / priorPrecision)) := by
  simpa only [bayesA7JointDrawLaw, bayesA7DrawCoordLaw] using
    (measurePreserving_eval
      (μ := bayesA7DrawCoordLaw n priorMean priorPrecision variance)
      (none : Option (Fin n))).map_eq

/-- Every actual noise coordinate has its prescribed centered
Gaussian distribution, not merely a named hypothetical law. -/
theorem bayesA7_joint_noise_marginal
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) (k : Fin n) :
    (bayesA7JointDrawLaw n priorMean priorPrecision variance).map
      (fun ω : Option (Fin n) → ℝ => ω (some k)) =
      gaussianReal 0 (Real.toNNReal (variance k)) := by
  simpa only [bayesA7JointDrawLaw, bayesA7DrawCoordLaw] using
    (measurePreserving_eval
      (μ := bayesA7DrawCoordLaw n priorMean priorPrecision variance)
      (some k : Option (Fin n))).map_eq

/-- Prior draw and any individual noise coordinate are independent
under the constructed probability measure. -/
theorem bayesA7_prior_independent_of_noise
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) (k : Fin n) :
    (fun ω : Option (Fin n) → ℝ => ω none) ⟂ᵢ[
      bayesA7JointDrawLaw n priorMean priorPrecision variance]
    (fun ω : Option (Fin n) → ℝ => ω (some k)) := by
  exact (bayesA7_joint_coordinates_independent
    n priorMean priorPrecision variance).indepFun
      (by simp : (none : Option (Fin n)) ≠ some k)

/-- The observed signal X_k = theta + epsilon_k is itself Gaussian.
The shared latent draw is retained: no (incorrect) unconditional
independence of the observed signals is asserted. -/
theorem bayesA7_observed_signal_marginal
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) (k : Fin n) :
    (bayesA7JointDrawLaw n priorMean priorPrecision variance).map
      (fun ω : Option (Fin n) → ℝ => ω none + ω (some k)) =
      gaussianReal priorMean
        (Real.toNNReal (1 / priorPrecision) + Real.toNNReal (variance k)) := by
  simpa only [Pi.add_apply, add_zero] using
    (gaussianReal_add_gaussianReal_of_indepFun
      (bayesA7_prior_independent_of_noise n priorMean priorPrecision variance k)
      (bayesA7_joint_prior_marginal n priorMean priorPrecision variance)
      (bayesA7_joint_noise_marginal n priorMean priorPrecision variance k))

end QX26AgenticDelegation
