import QX26AgenticDelegation.AppendixA7JointGaussianSignals
import Mathlib.Probability.Kernel.Composition.Prod

/-!
# Appendix A.7: conditional Gaussian signal Markov kernel

Source: Quispe and Xu (2026), arXiv:2605.25438v2,
Appendix A.7, equations (28)-(29).

This module constructs a TRUE Markov kernel theta -> Law(X | theta)
from a finite product of independent, centered Gaussian noise laws.
The signal vector is X_k = theta + epsilon_k.

We verify the kernel is Markov, prove its probability law at every theta
is the product of N(theta, variance_k) measures, and prove conditional
independence of its signal coordinates in that precise measure-theoretic
sense. These are NOT assertions that the observed signals are
unconditionally independent. We do not yet identify a regular
conditional posterior of theta given the entire observed signal vector.

No changes to generated lean/ source or its status/audit JSON.
-/

namespace QX26AgenticDelegation

open MeasureTheory ProbabilityTheory

/-- Product distribution of the independent centered Gaussian errors. -/
noncomputable def bayesA7NoiseLaw
    (n : ℕ) (variance : Fin n → ℝ) : Measure (Fin n → ℝ) :=
  Measure.pi (fun k : Fin n => gaussianReal 0 (Real.toNNReal (variance k)))

/-- The independent noise vector has a genuine probability law. -/
instance bayesA7_noise_probability
    (n : ℕ) (variance : Fin n → ℝ) :
    IsProbabilityMeasure (bayesA7NoiseLaw n variance) := by
  unfold bayesA7NoiseLaw
  infer_instance

/-- The noise coordinates are mutually independent (unconditionally). -/
theorem bayesA7_noise_coordinates_independent
    (n : ℕ) (variance : Fin n → ℝ) :
    iIndepFun (fun k : Fin n => fun ε : Fin n → ℝ => ε k)
      (bayesA7NoiseLaw n variance) := by
  unfold bayesA7NoiseLaw
  simpa only [id_eq] using
    (iIndepFun_pi
      (μ := fun k : Fin n => gaussianReal 0 (Real.toNNReal (variance k)))
      (X := fun _ : Fin n => (id : ℝ → ℝ))
      (fun _ => (measurable_id : Measurable (id : ℝ → ℝ)).aemeasurable))

/-- Observed signals are a location shift of the independent noises. -/
def bayesA7SignalShift (n : ℕ) (θ : ℝ) :
    (Fin n → ℝ) → (Fin n → ℝ) :=
  fun ε k => θ + ε k

/-- Joint map on a latent draw and a vector of independent noises. -/
def bayesA7SignalMap (n : ℕ) :
    (ℝ × (Fin n → ℝ)) → (Fin n → ℝ) :=
  fun z k => z.1 + z.2 k

/-- Signal vector as a function of the noise vector is measurable. -/
theorem bayesA7_signal_shift_measurable (n : ℕ) (θ : ℝ) :
    Measurable (bayesA7SignalShift n θ) := by
  unfold bayesA7SignalShift
  fun_prop

/-- Joint observation map is measurable. -/
theorem bayesA7_signal_map_measurable (n : ℕ) :
    Measurable (bayesA7SignalMap n) := by
  unfold bayesA7SignalMap
  fun_prop

/-- The Markov kernel of the signal vector GIVEN latent theta:
sample independent centered errors, pair them with theta, then add
theta to each error. This avoids assuming conditional independence. -/
noncomputable def bayesA7SignalKernel
    (n : ℕ) (variance : Fin n → ℝ) :
    Kernel ℝ (Fin n → ℝ) :=
  Kernel.map
    (Kernel.prod
      (Kernel.deterministic (id : ℝ → ℝ) measurable_id)
      (Kernel.const ℝ (bayesA7NoiseLaw n variance)))
    (bayesA7SignalMap n)

/-- The conditional signal kernel assigns a probability measure to
each possible theta; normalization is proved by Mathlib's kernel rules. -/
theorem bayesA7_signal_kernel_markov
    (n : ℕ) (variance : Fin n → ℝ) :
    IsMarkovKernel (bayesA7SignalKernel n variance) := by
  unfold bayesA7SignalKernel
  exact Kernel.IsMarkovKernel.map _ (bayesA7_signal_map_measurable n)

/-- The kernel at a fixed theta is precisely the pushforward of the
independent noise law under the common location shift. -/
theorem bayesA7_signal_kernel_apply_eq_shifted_noise
    (n : ℕ) (variance : Fin n → ℝ) (θ : ℝ) :
    bayesA7SignalKernel n variance θ =
      (bayesA7NoiseLaw n variance).map (bayesA7SignalShift n θ) := by
  unfold bayesA7SignalKernel
  rw [Kernel.map_apply _ (bayesA7_signal_map_measurable n)]
  rw [Kernel.prod_apply]
  simp only [Kernel.deterministic_apply, Kernel.const_apply, id_eq]
  rw [Measure.dirac_prod]
  rw [Measure.map_map (bayesA7_signal_map_measurable n) (by fun_prop)]
  congr 1
  funext ε k
  rfl

/-- A common theta shift of independent Gaussian errors is the product
of Gaussian marginals N(theta, variance_k). In particular the
joint conditional law is derived from independent errors, not postulated. -/
theorem bayesA7_shifted_noise_eq_gaussian_product
    (n : ℕ) (variance : Fin n → ℝ) (θ : ℝ) :
    (bayesA7NoiseLaw n variance).map (bayesA7SignalShift n θ) =
      Measure.pi (fun k : Fin n => gaussianReal θ (Real.toNNReal (variance k))) := by
  haveI : ∀ k : Fin n,
      SigmaFinite ((gaussianReal 0 (Real.toNNReal (variance k))).map
        (fun z : ℝ => θ + z)) := fun k => by
    letI : IsProbabilityMeasure
        ((gaussianReal 0 (Real.toNNReal (variance k))).map
          (fun z : ℝ => θ + z)) :=
      Measure.isProbabilityMeasure_map (by fun_prop)
    infer_instance
  have hprod :
      (bayesA7NoiseLaw n variance).map (bayesA7SignalShift n θ) =
        Measure.pi (fun k : Fin n =>
          (gaussianReal 0 (Real.toNNReal (variance k))).map
            (fun z : ℝ => θ + z)) := by
    unfold bayesA7NoiseLaw bayesA7SignalShift
    exact Measure.pi_map_pi
      (μ := fun k : Fin n => gaussianReal 0 (Real.toNNReal (variance k)))
      (f := fun _ : Fin n => (fun z : ℝ => θ + z))
      (fun _ => (by fun_prop : AEMeasurable (fun z : ℝ => θ + z)
        (gaussianReal 0 (Real.toNNReal (variance _)))))
  rw [hprod]
  congr 1
  funext k
  simpa only [zero_add] using
    (gaussianReal_map_const_add
      (μ := 0) (v := Real.toNNReal (variance k)) θ)

/-- The conditional signal kernel is exactly a finite product of
N(theta, variance_k), for every theta. -/
theorem bayesA7_signal_kernel_eq_gaussian_product
    (n : ℕ) (variance : Fin n → ℝ) (θ : ℝ) :
    bayesA7SignalKernel n variance θ =
      Measure.pi (fun k : Fin n => gaussianReal θ (Real.toNNReal (variance k))) := by
  rw [bayesA7_signal_kernel_apply_eq_shifted_noise]
  exact bayesA7_shifted_noise_eq_gaussian_product n variance θ

/-- The coordinates are independent under each conditional law. This
is the precise finite-dimensional conditional-independence claim. -/
theorem bayesA7_signals_independent_given_theta
    (n : ℕ) (variance : Fin n → ℝ) (θ : ℝ) :
    iIndepFun (fun k : Fin n => fun x : Fin n → ℝ => x k)
      (bayesA7SignalKernel n variance θ) := by
  rw [bayesA7_signal_kernel_eq_gaussian_product]
  simpa only [id_eq] using
    (iIndepFun_pi
      (μ := fun k : Fin n => gaussianReal θ (Real.toNNReal (variance k)))
      (X := fun _ : Fin n => (id : ℝ → ℝ))
      (fun _ => (measurable_id : Measurable (id : ℝ → ℝ)).aemeasurable))

/-- Each observed coordinate is N(theta, variance_k) under the
conditional kernel. This is not its unconditional marginal. -/
theorem bayesA7_conditional_signal_marginal
    (n : ℕ) (variance : Fin n → ℝ) (θ : ℝ) (k : Fin n) :
    (bayesA7SignalKernel n variance θ).map
      (fun x : Fin n → ℝ => x k) =
      gaussianReal θ (Real.toNNReal (variance k)) := by
  rw [bayesA7_signal_kernel_eq_gaussian_product]
  exact (measurePreserving_eval
    (μ := fun k : Fin n => gaussianReal θ (Real.toNNReal (variance k))) k).map_eq

end QX26AgenticDelegation
