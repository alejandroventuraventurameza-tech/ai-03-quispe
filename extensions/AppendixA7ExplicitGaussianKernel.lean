import QX26AgenticDelegation.AppendixA7ObservedJointBridge

/-!
# Appendix A.7: explicit precision-weighted Gaussian as a Markov kernel

Earlier files proved the posterior mean and precision algebra for
each fixed vector of observations, and built the regular posterior
through Mathlib's disintegration. Here the explicit Gaussian candidate
is upgraded to a *measurable Markov kernel* x -> N(m(x),1/tau).

We construct the kernel without assuming any version of Bayes' theorem:
sample a Gaussian with mean zero and variance 1/tau, and add the
measurable precision-weighted mean m(x). All output laws are genuine
Gaussian probability measures (degenerate if variance is zero).
An explicit positivity lemma below gives the economic nondegenerate
domain pi > 0, v_k > 0.

The equality with the regular posterior of the joint sampling model
is NOT asserted by this module and still requires a disintegration
identity for the explicitly defined candidate kernel. The generated
lean/ paper folder and audit/status artifacts are unchanged.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- Weighted posterior mean as a function of the entire observation
vector. The finite signal set is Finset.univ. -/
noncomputable def bayesA7PosteriorMeanOnSignals
    (n : ℕ) (priorPrecision priorMean : ℝ)
    (variance : Fin n → ℝ) (x : Fin n → ℝ) : ℝ :=
  bayesA7PosteriorMean Finset.univ priorPrecision priorMean variance x

/-- Measurability of the normal posterior's updated mean; this is
required to construct a genuine Markov kernel in observation x. -/
theorem bayesA7_posterior_mean_on_signals_measurable
    (n : ℕ) (priorPrecision priorMean : ℝ)
    (variance : Fin n → ℝ) :
    Measurable (bayesA7PosteriorMeanOnSignals
      n priorPrecision priorMean variance) := by
  unfold bayesA7PosteriorMeanOnSignals
    bayesA7PosteriorMean bayesA7WeightedSignalNumerator
  fun_prop

/-- Measurable candidate posterior kernel: for observed signal vector
x, sample centered Gaussian noise with updated variance and shift by
m(x). This construction requires no circular assumption that the
resulting kernel is already a regular conditional distribution. -/
noncomputable def bayesA7ExplicitGaussianKernel
    (n : ℕ) (priorPrecision priorMean : ℝ)
    (variance : Fin n → ℝ) : Kernel (Fin n → ℝ) ℝ :=
  Kernel.map
    (Kernel.prod
      (Kernel.deterministic
        (bayesA7PosteriorMeanOnSignals n priorPrecision priorMean variance)
        (bayesA7_posterior_mean_on_signals_measurable
          n priorPrecision priorMean variance))
      (Kernel.const (Fin n → ℝ)
        (gaussianReal 0
          (Real.toNNReal (1 /
            bayesA7PosteriorPrecision Finset.univ priorPrecision variance)))))
    (fun z : ℝ × ℝ => z.1 + z.2)

/-- The explicit Gaussian kernel is Markov: each observation x is
mapped to a probability measure in latent productivity theta. -/
instance bayesA7_explicit_gaussian_isMarkovKernel
    (n : ℕ) (priorPrecision priorMean : ℝ)
    (variance : Fin n → ℝ) :
    IsMarkovKernel (bayesA7ExplicitGaussianKernel
      n priorPrecision priorMean variance) := by
  unfold bayesA7ExplicitGaussianKernel
  exact Kernel.IsMarkovKernel.map _ (by fun_prop)

/-- The law of the explicit kernel at every x is exactly the
previously proved precision-weighted Gaussian candidate law.
This is equality of measures for fixed data, not yet equality with
the posterior obtained from the joint experiment. -/
theorem bayesA7_explicit_gaussian_kernel_apply
    (n : ℕ) (priorPrecision priorMean : ℝ)
    (variance : Fin n → ℝ) (x : Fin n → ℝ) :
    bayesA7ExplicitGaussianKernel n priorPrecision priorMean variance x =
      bayesA7GaussianCandidateLaw Finset.univ
        priorPrecision priorMean variance x := by
  unfold bayesA7ExplicitGaussianKernel
  rw [Kernel.map_apply _ (by fun_prop)]
  rw [Kernel.prod_apply]
  simp only [Kernel.deterministic_apply, Kernel.const_apply]
  rw [Measure.dirac_prod]
  rw [Measure.map_map (by fun_prop) (by fun_prop)]
  unfold bayesA7GaussianCandidateLaw
  change (gaussianReal 0
      (Real.toNNReal (1 /
        bayesA7PosteriorPrecision Finset.univ priorPrecision variance))).map
      (fun z : ℝ =>
        bayesA7PosteriorMeanOnSignals n priorPrecision priorMean variance x + z) =
      gaussianReal
        (bayesA7PosteriorMean Finset.univ
          priorPrecision priorMean variance x)
        (Real.toNNReal (1 /
          bayesA7PosteriorPrecision Finset.univ priorPrecision variance))
  unfold bayesA7PosteriorMeanOnSignals
  simpa only [zero_add] using
    (gaussianReal_map_const_add (μ := 0)
      (v := Real.toNNReal (1 /
        bayesA7PosteriorPrecision Finset.univ priorPrecision variance))
      (bayesA7PosteriorMean Finset.univ
        priorPrecision priorMean variance x))

/-- Strictly positive updated precision for economic parameters. -/
theorem bayesA7_explicit_gaussian_updated_precision_pos
    (n : ℕ) (priorPrecision : ℝ)
    (variance : Fin n → ℝ)
    (hPrior : 0 < priorPrecision)
    (hVar : ∀ k : Fin n, 0 < variance k) :
    0 < bayesA7PosteriorPrecision Finset.univ
      priorPrecision variance := by
  exact bayesA7_posterior_precision_pos
    Finset.univ variance priorPrecision hPrior
    (fun k _ => hVar k)

end QX26AgenticDelegation
