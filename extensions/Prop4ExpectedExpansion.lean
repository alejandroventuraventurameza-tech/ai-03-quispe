import QX26AgenticDelegation.Prop2ThresholdBridge

/-!
# Proposition 4: conditional expectation and specialist heterogeneity

Source: Quispe-Xu (2026), arXiv:2605.25438v2, Appendix A.5, equations
(22)-(23), under Assumption 3 (comparable unfamiliar-language candidates).

Fix the developer's ability a and initially unfamiliar-language set U.
The input conditionalLaw a U is interpreted as the probability law of
opportunity shocks conditional on both characteristics. This module
DOES NOT construct a regular conditional distribution from a joint
probability space: it assumes the conditional law is supplied.

Z1 and Z2 are real-valued activation indicators in an application;
their 0/1 nature is not needed for linearity, but it is needed for the
economic interpretation and the probability bounds on p. Integrability
and the common conditional mean are explicit hypotheses. Independence
of language activations is NOT assumed or needed.

This extension is kept separate from the original generated lean/ folder.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory

/-- Appendix A.5 (22)-(23): under a supplied conditional opportunity law
for fixed ability a and candidate set U, and Assumption 3 that each
language has identical conditional mean activation increment p(a),
the expected number of activated unfamiliar languages is U.card * p(a).

Probability normalization and integrability are explicit. No
independence of the per-language random variables is required.
The model-level conditional law and p(a) must be substantiated
independently from the economic primitives and distributions. -/
theorem prop4_conditional_expected_expansion
    {ι Ω : Type*} [MeasurableSpace Ω]
    (U : Finset ι)
    (conditionalLaw : ℝ → Finset ι → Measure Ω)
    (a : ℝ)
    (Z1 Z2 : ι → Ω → ℝ)
    (p : ℝ → ℝ)
    (_hProbability : IsProbabilityMeasure (conditionalLaw a U))
    (hIntegrable : ∀ k ∈ U,
      Integrable (fun ω => Z2 k ω - Z1 k ω) (conditionalLaw a U))
    (hComparable : ∀ k ∈ U,
      (∫ ω, Z2 k ω - Z1 k ω ∂ (conditionalLaw a U)) = p a) :
    (∫ ω, (∑ k ∈ U, (Z2 k ω - Z1 k ω)) ∂ (conditionalLaw a U)) =
      (U.card : ℝ) * p a := by
  calc
    (∫ ω, (∑ k ∈ U, (Z2 k ω - Z1 k ω)) ∂ (conditionalLaw a U))
        = ∑ k ∈ U, (∫ ω, Z2 k ω - Z1 k ω ∂ (conditionalLaw a U)) := by
          rw [integral_finset_sum]
          intro k hk
          exact hIntegrable k hk
    _ = ∑ k ∈ U, p a := by
          apply Finset.sum_congr rfl
          intro k hk
          exact hComparable k hk
    _ = (U.card : ℝ) * p a := by
          rw [Finset.sum_const, nsmul_eq_mul]

/-- If activation probabilities are nonnegative, a larger stock of
unfamiliar candidates weakly raises the expected expansion, holding
ability and per-language activation probability fixed. -/
theorem prop4_more_candidates_weak
    {ι : Type*} (U V : Finset ι) (p : ℝ)
    (hUV : U.card ≤ V.card) (hp : 0 ≤ p) :
    (U.card : ℝ) * p ≤ (V.card : ℝ) * p := by
  exact mul_le_mul_of_nonneg_right (by exact_mod_cast hUV) hp

/-- Strict specialist effect requires strictly MORE candidates AND
a strictly positive per-language probability. It cannot follow from
candidate count alone when p=0. -/
theorem prop4_more_candidates_strict
    {ι : Type*} (U V : Finset ι) (p : ℝ)
    (hUV : U.card < V.card) (hp : 0 < p) :
    (U.card : ℝ) * p < (V.card : ℝ) * p := by
  exact mul_lt_mul_of_pos_right (by exact_mod_cast hUV) hp

/-- Greater ability weakly increases expected expansion provided that
the per-language expected activation increment increases with ability.
This monotonicity in p is a SOURCE ASSUMPTION, not a deduction from the
bare product formula or the threshold-cost derivatives. -/
theorem prop4_more_ability_weak
    {ι : Type*} (U : Finset ι) (p : ℝ → ℝ)
    (a1 a2 : ℝ)
    (hp : p a1 ≤ p a2) :
    (U.card : ℝ) * p a1 ≤ (U.card : ℝ) * p a2 := by
  exact mul_le_mul_of_nonneg_left hp (Nat.cast_nonneg _)

end QX26AgenticDelegation
