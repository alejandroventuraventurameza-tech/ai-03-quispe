import QX26AgenticDelegation.Prop5RepositoryExpectation

/-!
# Proposition 1: menus, pointwise frontier expansion, and strict-witness corollary

Source: Quispe--Xu (2026), arXiv:2605.25438v2,
Section 4.2, Proposition 1, and Appendix A.3 (equation 21).

The original Proposition 1 establishes weak expansion path by path.
Appendix A.3 gives a STRICT COROLLARY when one previously inactive
language is activated only by delegation. We formalize that extra
witness condition, keeping it separate from the original statement.

The value functions come from the already checked Proposition-2 bridge:
soloValue, copilotValue, delegationValue, soloThreshold,
delegationThreshold. There is no probability or causal identification
claim here: opportunity values are held fixed.

No edits are made to the generated lean/ subtree.
-/

namespace QX26AgenticDelegation

open Finset

/-- Number of active languages under the pre-agent menu {S,C}. -/
noncomputable def prop1CountBefore
    {ι : Type*} (K : Finset ι) (p : ι → DelegationPrimitives)
    (ω : ι → ℝ) : ℝ :=
  ∑ k ∈ K, if 0 ≤ max (soloValue (p k) (ω k))
        (copilotValue (p k) (ω k)) then (1 : ℝ) else 0

/-- Number of active languages under the extended menu {S,C,D}. -/
noncomputable def prop1CountAfter
    {ι : Type*} (K : Finset ι) (p : ι → DelegationPrimitives)
    (ω : ι → ℝ) : ℝ :=
  ∑ k ∈ K, if 0 ≤
      max (max (soloValue (p k) (ω k))
        (copilotValue (p k) (ω k)))
          (delegationValue (p k) (ω k)) then (1 : ℝ) else 0

/-- Proposition 1 as a full menu construction, not an abstract order
hypothesis: adding D cannot remove an already active language. -/
theorem prop1_menu_count_weak
    {ι : Type*} (K : Finset ι) (p : ι → DelegationPrimitives)
    (ω : ι → ℝ) :
    prop1CountBefore K p ω ≤ prop1CountAfter K p ω := by
  unfold prop1CountBefore prop1CountAfter
  apply Finset.sum_le_sum
  intro k hk
  exact indicator_mono (menu_surplus_weak_expansion (p k) (ω k))

/-- The aggregate increase is exactly the sum of the pointwise differences
between extended-menu and original-menu activation indicators. -/
theorem prop1_count_gap_eq_sum
    {ι : Type*} (K : Finset ι) (p : ι → DelegationPrimitives)
    (ω : ι → ℝ) :
    prop1CountAfter K p ω - prop1CountBefore K p ω =
      ∑ k ∈ K,
        ((if 0 ≤ max (max (soloValue (p k) (ω k))
              (copilotValue (p k) (ω k)))
              (delegationValue (p k) (ω k)) then
            (1 : ℝ) else 0) -
         (if 0 ≤ max (soloValue (p k) (ω k))
              (copilotValue (p k) (ω k)) then
            (1 : ℝ) else 0)) := by
  unfold prop1CountAfter prop1CountBefore
  rw [← Finset.sum_sub_distrib]

/-- Strictness (A.3) with a concrete witness:
one language has BOTH old surpluses below zero, but a nonnegative
delegation surplus. This witness is not in the weak-only main
Proposition-1 statement; it is in the appendix proof. -/
theorem prop1_count_strict_of_new_mode_witness
    {ι : Type*} (K : Finset ι) (p : ι → DelegationPrimitives)
    (ω : ι → ℝ)
    (k₀ : ι) (hk₀ : k₀ ∈ K)
    (hOld : max (soloValue (p k₀) (ω k₀))
        (copilotValue (p k₀) (ω k₀)) < 0)
    (hD : 0 ≤ delegationValue (p k₀) (ω k₀)) :
    prop1CountBefore K p ω < prop1CountAfter K p ω := by
  have hPositive :
      0 < ∑ k ∈ K,
        ((if 0 ≤ max (max (soloValue (p k) (ω k))
              (copilotValue (p k) (ω k)))
              (delegationValue (p k) (ω k)) then
            (1 : ℝ) else 0) -
         (if 0 ≤ max (soloValue (p k) (ω k))
              (copilotValue (p k) (ω k)) then
            (1 : ℝ) else 0)) := by
    apply Finset.sum_pos'
    · intro k hk
      exact sub_nonneg.mpr
        (indicator_mono (menu_surplus_weak_expansion (p k) (ω k)))
    · refine ⟨k₀, hk₀, ?_⟩
      have hOldFalse : ¬ 0 ≤ max (soloValue (p k₀) (ω k₀))
          (copilotValue (p k₀) (ω k₀)) := not_le.mpr hOld
      have hNewTrue : 0 ≤
          max (max (soloValue (p k₀) (ω k₀))
              (copilotValue (p k₀) (ω k₀)))
            (delegationValue (p k₀) (ω k₀)) :=
        le_trans hD (le_max_right _ _)
      simp [hOldFalse, hNewTrue]
  apply sub_pos.mp
  rw [prop1_count_gap_eq_sum]
  exact hPositive

/-- If opportunity value is in [T^D,T^S), then the delegation threshold
is strictly below the solo threshold. Via the checked algebraic
identity B=T^S-T^D, the delegation advantage is strictly positive. -/
theorem prop1_band_implies_positive_delegation_advantage
    (p : DelegationPrimitives) (ω : ℝ)
    (hBand : delegationThreshold p ≤ ω ∧ ω < soloThreshold p) :
    0 < delegationAdvantage p := by
  rw [delegationAdvantage_eq_threshold_difference]
  linarith [hBand.1, hBand.2]

/-- Strict frontier expansion from an economic *opportunity band*.
Assumption 1 is explicit: copilot cannot improve an unfamiliar
language at the entry margin. The band supplies one genuine newly
activated language; other languages may have arbitrary characteristics.
No extra positivity of B is assumed: it follows from the band itself. -/
theorem prop1_count_strict_of_delegation_band
    {ι : Type*} (K : Finset ι) (p : ι → DelegationPrimitives)
    (ω : ι → ℝ)
    (k₀ : ι) (hk₀ : k₀ ∈ K)
    (hFoothold : (p k₀).copilotProductivity * (p k₀).skill -
        (p k₀).copilotCost ≤ 0)
    (hBand : delegationThreshold (p k₀) ≤ ω k₀ ∧
        ω k₀ < soloThreshold (p k₀)) :
    prop1CountBefore K p ω < prop1CountAfter K p ω := by
  have hSolo : soloValue (p k₀) (ω k₀) < 0 := by
    rw [soloValue_eq_opportunity_sub_threshold]
    linarith [hBand.2]
  have hCopilot : copilotValue (p k₀) (ω k₀) < 0 := by
    unfold copilotValue
    linarith [hSolo, hFoothold]
  have hOld : max (soloValue (p k₀) (ω k₀))
      (copilotValue (p k₀) (ω k₀)) < 0 :=
    (max_lt_iff).mpr ⟨hSolo, hCopilot⟩
  have hDelegation : 0 ≤ delegationValue (p k₀) (ω k₀) := by
    rw [delegationValue_eq_opportunity_sub_threshold]
    linarith [hBand.1]
  exact prop1_count_strict_of_new_mode_witness K p ω
    k₀ hk₀ hOld hDelegation

end QX26AgenticDelegation
