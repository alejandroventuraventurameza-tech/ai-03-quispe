import QX26AgenticDelegation.Prop4ExpectedExpansion

/-!
# Proposition 5: expected repository expansion and strictness

Source: Quispe--Xu (2026), arXiv:2605.25438v2, Appendix A.8.

The paper assumes repository r requires language ell(r) and participation is
possible if its opportunity value Omega(r) clears the relevant generation's
entry cost c_g(r). Delegation weakly lowers those entry costs. This module
represents the induced per-repository entry indicators, the finite count,
and its expectation under a GIVEN opportunity distribution mu.

Weak expansion needs weak cost ordering. Strict expansion requires a
specific repository with positive probability mass on its half-open
activation band: {omega | c2(r) <= Omega(r,omega) < c1(r)}.

This module DOES NOT construct entry costs from the developer-language
primitives, infer probability measures from adoption data, or establish
causal identification. The paper-generated lean/ subtree is unchanged.
-/

namespace QX26AgenticDelegation

open Finset MeasureTheory

/-- Number of repositories viable under a threshold schedule c.
Omega maps a repository and a realized opportunity shock to its value. -/
noncomputable def repo5Count
    {ρ ξ : Type*} (R : Finset ρ) (Ω : ρ → ξ → ℝ)
    (c : ρ → ℝ) (ω : ξ) : ℝ :=
  ∑ r ∈ R, if c r ≤ Ω r ω then (1 : ℝ) else 0

/-- The half-open repository activation band. -/
noncomputable def repo5Band
    {ρ ξ : Type*} (Ω : ρ → ξ → ℝ)
    (c1 c2 : ρ → ℝ) (r : ρ) (ω : ξ) : ℝ :=
  if c2 r ≤ Ω r ω ∧ Ω r ω < c1 r then (1 : ℝ) else 0

/-- Exact pathwise finite-repository counterpart of the original
activation-band indicator lemma, under weak cost reduction. -/
theorem prop5_count_gap_eq_band_sum
    {ρ ξ : Type*} (R : Finset ρ) (Ω : ρ → ξ → ℝ)
    (c1 c2 : ρ → ℝ) (ω : ξ)
    (hc : ∀ r ∈ R, c2 r ≤ c1 r) :
    repo5Count R Ω c2 ω - repo5Count R Ω c1 ω =
      ∑ r ∈ R, repo5Band Ω c1 c2 r ω := by
  unfold repo5Count
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro r hr
  simpa only [repo5Band] using
    (activation_band (c2 r) (c1 r) (Ω r ω) (hc r hr))

/-- Every realized opportunity profile has weakly more viable repositories
when each relevant repository's entry cost falls weakly. -/
theorem prop5_count_weak
    {ρ ξ : Type*} (R : Finset ρ) (Ω : ρ → ξ → ℝ)
    (c1 c2 : ρ → ℝ) (ω : ξ)
    (hc : ∀ r ∈ R, c2 r ≤ c1 r) :
    repo5Count R Ω c1 ω ≤ repo5Count R Ω c2 ω := by
  apply sub_nonneg.mp
  rw [prop5_count_gap_eq_band_sum R Ω c1 c2 ω hc]
  apply Finset.sum_nonneg
  intro r hr
  unfold repo5Band
  split_ifs <;> norm_num

/-- Expected number of viable repositories weakly rises under the SAME
opportunity law. The measure and integrability assumptions are explicit;
no assumption of independence of repository opportunity values is needed. -/
theorem prop5_expected_count_weak
    {ρ ξ : Type*} [MeasurableSpace ξ]
    (μ : Measure ξ) [IsProbabilityMeasure μ]
    (R : Finset ρ) (Ω : ρ → ξ → ℝ)
    (c1 c2 : ρ → ℝ)
    (hc : ∀ r ∈ R, c2 r ≤ c1 r)
    (hInt1 : Integrable (fun ω => repo5Count R Ω c1 ω) μ)
    (hInt2 : Integrable (fun ω => repo5Count R Ω c2 ω) μ) :
    (∫ ω, repo5Count R Ω c1 ω ∂μ) ≤
      (∫ ω, repo5Count R Ω c2 ω ∂μ) := by
  exact integral_mono hInt1 hInt2
    (fun ω => prop5_count_weak R Ω c1 c2 ω hc)

/-- The strict claim requires a positive-mass event, not merely a named
repository. If one r in the finite set has a positive-probability band
where delegation alone makes it viable, total expected participation
strictly increases; no cross-repository independence is assumed.

The indicator functions' integrability and cost order are explicit;
the statement does not posit that the opportunity shock is normally
distributed or that every repository requires only one language. -/
theorem prop5_expected_count_strict_of_positive_band_mass
    {ρ ξ : Type*} [MeasurableSpace ξ]
    (μ : Measure ξ) [IsProbabilityMeasure μ]
    (R : Finset ρ) (Ω : ρ → ξ → ℝ)
    (c1 c2 : ρ → ℝ)
    (hc : ∀ r ∈ R, c2 r ≤ c1 r)
    (hInt1 : Integrable (fun ω => repo5Count R Ω c1 ω) μ)
    (hInt2 : Integrable (fun ω => repo5Count R Ω c2 ω) μ)
    (r : ρ) (hr : r ∈ R)
    (hMass : 0 < μ {ω | c2 r ≤ Ω r ω ∧ Ω r ω < c1 r}) :
    (∫ ω, repo5Count R Ω c1 ω ∂μ) <
      (∫ ω, repo5Count R Ω c2 ω ∂μ) := by
  let gap : ξ → ℝ := fun ω =>
    repo5Count R Ω c2 ω - repo5Count R Ω c1 ω
  have hIntGap : Integrable gap μ := hInt2.sub hInt1
  have hNonneg : (0 : ξ → ℝ) ≤ gap := by
    intro ω
    exact sub_nonneg.mpr (prop5_count_weak R Ω c1 c2 ω hc)
  have hEventSubset : {ω | c2 r ≤ Ω r ω ∧ Ω r ω < c1 r} ⊆
      Function.support gap := by
    intro ω hEvent
    have hBandPos : 0 < repo5Band Ω c1 c2 r ω := by
      change c2 r ≤ Ω r ω ∧ Ω r ω < c1 r at hEvent
      simp [repo5Band, hEvent]
    have hSumPos :
        0 < ∑ k ∈ R, repo5Band Ω c1 c2 k ω := by
      apply Finset.sum_pos'
      · intro k hk
        unfold repo5Band
        split_ifs <;> norm_num
      · exact ⟨r, hr, hBandPos⟩
    have hGapPos : 0 < gap ω := by
      dsimp [gap]
      simpa only [prop5_count_gap_eq_band_sum R Ω c1 c2 ω hc] using hSumPos
    change gap ω ≠ 0
    exact ne_of_gt hGapPos
  have hSupportMass : 0 < μ (Function.support gap) :=
    lt_of_lt_of_le hMass (measure_mono hEventSubset)
  have hIntGapPos : 0 < ∫ ω, gap ω ∂μ :=
    (integral_pos_iff_support_of_nonneg hNonneg hIntGap).2 hSupportMass
  have hIntGapEq :
      (∫ ω, gap ω ∂μ) =
        (∫ ω, repo5Count R Ω c2 ω ∂μ) -
          (∫ ω, repo5Count R Ω c1 ω ∂μ) := by
    dsimp [gap]
    exact integral_sub hInt2 hInt1
  linarith

end QX26AgenticDelegation
