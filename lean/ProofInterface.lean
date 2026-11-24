import QX26AgenticDelegation.PaperInterface

/-!
# Proof Interface: Agentic Delegation and the Language Frontier of Software Developers

Exact-type proof endpoints for the transparent propositions in
`PaperInterface.lean`. Each theorem has exactly its `...Spec : Prop` type; the
proofs follow the paper's appendix argument (10_appendix.tex), abstracted to the
real-valued quantities the arguments actually use.
-/

namespace QX26AgenticDelegation

open Finset

/-- Proof endpoint for `frontier_expansionSpec` (Proposition 1).
`V² ≥ V¹` pointwise (menu inclusion) ⇒ indicator sums are monotone ⇒ `N² ≥ N¹`. -/
theorem frontier_expansion :
    frontier_expansionSpec := by
  intro ι K V1 V2 hV
  apply Finset.sum_le_sum
  intro k hk
  exact indicator_mono (hV k hk)

/-- Proof endpoint for `activation_bandSpec` (Proposition 2).
With `T^D ≤ T^S`, the two entry indicators differ exactly on the middle band
`T^D ≤ ω < T^S`. -/
theorem activation_band :
    activation_bandSpec := by
  intro TD TS ω h
  by_cases hD : TD ≤ ω
  · by_cases hS : TS ≤ ω
    · have hns : ¬ ω < TS := not_lt.mpr hS
      simp [hD, hS, hns]
    · have hlt : ω < TS := not_le.mp hS
      simp [hD, hS, hlt]
  · have hnS : ¬ TS ≤ ω := fun hc => hD (le_trans h hc)
    simp [hD, hnS]

/-- Proof endpoint for `cumulative_effect_nonnegSpec` (Proposition 3,
nonnegativity). `p² ≥ p¹`, both ≤ 1 ⇒ `0 ≤ 1−p² ≤ 1−p¹` ⇒ each summand ≥ 0. -/
theorem cumulative_effect_nonneg :
    cumulative_effect_nonnegSpec := by
  intro ι U p1 p2 s h
  apply Finset.sum_nonneg
  intro k hk
  obtain ⟨h0, h12, h21⟩ := h k hk
  have hb2 : 0 ≤ 1 - p2 k := by linarith
  have hble : 1 - p2 k ≤ 1 - p1 k := by linarith
  have hkey : (1 - p2 k) ^ (s + 1) ≤ (1 - p1 k) ^ (s + 1) := by gcongr
  linarith

/-- Proof endpoint for `cumulative_gap_first_differenceSpec` (Proposition 3
proof). A ring identity after `x^{n+1}=x^n·x`. -/
theorem cumulative_gap_first_difference :
    cumulative_gap_first_differenceSpec := by
  intro p1 p2 s
  ring

/-- Proof endpoint for `cumulative_effect_strict_mono_closedFrontierSpec`
(Proposition 3, corrected strict increase). `0<p²<1` ⇒ forward difference
`p²(1−p²)^{s+1}>0`. -/
theorem cumulative_effect_strict_mono_closedFrontier :
    cumulative_effect_strict_mono_closedFrontierSpec := by
  intro p2 s h0 h1
  have hb : 0 < 1 - p2 := by linarith
  have hpos : 0 < (1 - p2) ^ (s + 1) := pow_pos hb (s + 1)
  have hstep : (1 - p2) ^ (s + 2) = (1 - p2) ^ (s + 1) * (1 - p2) := by
    rw [pow_succ]
  rw [hstep]
  nlinarith [mul_pos hpos h0]

/-- Proof endpoint for `cumulative_effect_strict_concave_closedFrontierSpec`
(Proposition 3, corrected strict concavity). Second difference
`−(p²)²(1−p²)^{s+1} < 0`. -/
theorem cumulative_effect_strict_concave_closedFrontier :
    cumulative_effect_strict_concave_closedFrontierSpec := by
  intro p2 s h0 h1
  have hb : 0 < 1 - p2 := by linarith
  have hpos : 0 < (1 - p2) ^ (s + 1) := pow_pos hb (s + 1)
  have e2 : (1 - p2) ^ (s + 2) = (1 - p2) ^ (s + 1) * (1 - p2) := by
    rw [pow_succ]
  have e3 : (1 - p2) ^ (s + 3) = (1 - p2) ^ (s + 1) * (1 - p2) * (1 - p2) := by
    rw [pow_succ, pow_succ]
  rw [e2, e3]
  nlinarith [mul_pos (mul_pos hpos h0) h0, hpos, h0, h1]

/-- Proof endpoint for `cumulative_effect_endpoint_flatSpec` (Proposition 3,
endpoint counterexample). At `p²=1` the gap is `1` for every `s`, so strictness
fails at the included endpoint. -/
theorem cumulative_effect_endpoint_flat :
    cumulative_effect_endpoint_flatSpec := by
  intro s
  have h : (1 - (1 : ℝ)) = 0 := by norm_num
  rw [h, zero_pow (by omega : s + 1 ≠ 0), zero_pow (by omega : s + 2 ≠ 0)]
  norm_num

/-- Proof endpoint for `specialist_heterogeneitySpec` (Proposition 4).
Linearity of expectation over identical increments: a Finset sum of a constant
is `card • constant`. -/
theorem specialist_heterogeneity :
    specialist_heterogeneitySpec := by
  intro ι U p
  rw [Finset.sum_const, nsmul_eq_mul]

/-- Proof endpoint for `repository_expansionSpec` (Proposition 5).
`c² ≤ c¹` ⇒ `Ω−c¹ ≤ Ω−c²` ⇒ each repository indicator weakly rises. -/
theorem repository_expansion :
    repository_expansionSpec := by
  intro ρ R Ω c1 c2 hc
  apply Finset.sum_le_sum
  intro r hr
  apply indicator_mono
  have := hc r hr
  linarith

end QX26AgenticDelegation
