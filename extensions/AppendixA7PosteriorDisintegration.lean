import QX26AgenticDelegation.AppendixA7SignalKernel
import Mathlib.Probability.Kernel.Posterior

/-!
# Appendix A.7: actual posterior kernel and disintegration

The forward conditional signal Markov kernel Q_theta was proved in
AppendixA7SignalKernel.lean, including conditional Gaussian coordinate
independence and the product law for every theta.

We now form a genuine Bayesian joint probability law
  prior_theta \otimes_m Q
and use Mathlib's general posterior construction (for real, standard
Borel latent space) to build its regular conditional distribution
  P_x = Law(theta | signals = x)
as an actual Markov kernel. This is not merely a density name: we
prove the Bayes disintegration identity and posterior uniqueness a.e.

The additional, ECONOMICALLY EXPLICIT identification
  P_x = Gaussian(precision-weighted-mean(x), 1/updated-precision)
has NOT yet been proved. The fixed-data Gaussian measure proved in
AppendixA7NormalizedPosteriorDensity.lean is a candidate requiring
this identification. The joint law just defined also has not been
identified here with the Option-indexed sampling law from the earlier
AppendixA7JointGaussianSignals.lean.

No edits to generated lean/ files or their audit/status metadata.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory
open scoped ProbabilityTheory

/-- Genuine Gaussian prior measure on the latent productivity θ. -/
noncomputable def bayesA7PriorMeasure
    (priorMean priorPrecision : ℝ) : Measure ℝ :=
  gaussianReal priorMean (Real.toNNReal (1 / priorPrecision))

/-- Regardless of parameter signs, Mathlib's Gaussian measure
(concentrated at its mean when variance is zero) is a probability.
Economic nondegeneracy separately requires priorPrecision > 0. -/
instance bayesA7_prior_measure_probability
    (priorMean priorPrecision : ℝ) :
    IsProbabilityMeasure (bayesA7PriorMeasure priorMean priorPrecision) := by
  unfold bayesA7PriorMeasure
  infer_instance

/-- Register the previously demonstrated Markov property of Q_theta,
so the general mathematical posterior construction can be applied. -/
instance bayesA7_signal_kernel_isMarkov
    (n : ℕ) (variance : Fin n → ℝ) :
    IsMarkovKernel (bayesA7SignalKernel n variance) :=
  bayesA7_signal_kernel_markov n variance

/-- The actual posterior Markov kernel for the joint model built from
the Gaussian prior and conditional Gaussian signal kernel Q_theta. -/
noncomputable def bayesA7PosteriorKernel
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) : Kernel (Fin n → ℝ) ℝ :=
  ProbabilityTheory.posterior
    (bayesA7SignalKernel n variance)
    (bayesA7PriorMeasure priorMean priorPrecision)

/-- The newly constructed posterior is Markov: for every observed
signal vector x, its value is a probability measure on θ. -/
theorem bayesA7_posterior_is_markov
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    IsMarkovKernel (bayesA7PosteriorKernel n priorMean priorPrecision variance) := by
  unfold bayesA7PosteriorKernel
  infer_instance

/-- Genuine Bayesian disintegration: the joint law of signal vector
then posterior θ equals the swapped joint law of prior θ and
forward signal kernel Q_theta. Unlike a normalized fixed-data density
identity, this is a measure equality of joint distributions. -/
theorem bayesA7_posterior_disintegration
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    ((bayesA7SignalKernel n variance) ∘ₘ
      bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ
        (bayesA7PosteriorKernel n priorMean priorPrecision variance) =
      (bayesA7PriorMeasure priorMean priorPrecision ⊗ₘ
        bayesA7SignalKernel n variance).map Prod.swap := by
  exact ProbabilityTheory.compProd_posterior_eq_map_swap
    (κ := bayesA7SignalKernel n variance)
    (μ := bayesA7PriorMeasure priorMean priorPrecision)

/-- Bayesian averaging of the posterior over signals recovers the
original prior measure. This is an identity of measures, not a formula
for an unproved conditional expectation. -/
theorem bayesA7_posterior_recovers_prior
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ) :
    (bayesA7PosteriorKernel n priorMean priorPrecision variance) ∘ₘ
      (bayesA7SignalKernel n variance) ∘ₘ
        (bayesA7PriorMeasure priorMean priorPrecision) =
      bayesA7PriorMeasure priorMean priorPrecision := by
  exact ProbabilityTheory.posterior_comp_self
    (κ := bayesA7SignalKernel n variance)
    (μ := bayesA7PriorMeasure priorMean priorPrecision)

/-- Any alternative finite posterior kernel satisfying the same exact
joint disintegration agrees with the constructed posterior almost
surely under the marginal law of observed signals. -/
theorem bayesA7_posterior_unique_ae
    (n : ℕ) (priorMean priorPrecision : ℝ)
    (variance : Fin n → ℝ)
    (η : Kernel (Fin n → ℝ) ℝ)
    [IsFiniteKernel η]
    (hJoint :
      ((bayesA7SignalKernel n variance) ∘ₘ
        bayesA7PriorMeasure priorMean priorPrecision) ⊗ₘ η =
        (bayesA7PriorMeasure priorMean priorPrecision ⊗ₘ
          bayesA7SignalKernel n variance).map Prod.swap) :
    η =ᵐ[(bayesA7SignalKernel n variance) ∘ₘ
      bayesA7PriorMeasure priorMean priorPrecision]
      bayesA7PosteriorKernel n priorMean priorPrecision variance := by
  exact ProbabilityTheory.ae_eq_posterior_of_compProd_eq
    (κ := bayesA7SignalKernel n variance)
    (μ := bayesA7PriorMeasure priorMean priorPrecision) hJoint

end QX26AgenticDelegation
