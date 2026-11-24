import QX26AgenticDelegation.ProofInterface

/-!
# Independent proof extension: the aggregate no-catch-up condition

This module lives OUTSIDE the archived generated paper folder lean/.
It closes a mathematical gap identified in the paper-to-Lean coverage audit,
without claiming that finite-sum algebra formalizes the complete
first-use-hazard model or modifying generated audit/status artifacts.

For each language k, the algebraic first difference is
p2(k) * (1-p2(k))^(s+1) - p1(k) * (1-p1(k))^(s+1).
The aggregate cumulative gap is weakly increasing at s if and only if the
sum of these first differences is nonnegative. Hazard ordering by itself
does not ensure this for all horizons outside the closed-frontier benchmark.
-/

namespace QX26AgenticDelegation

open Finset

variable {ι : Type*}

def auditedCumulativeGap (U : Finset ι) (p1 p2 : ι → ℝ) (s : ℕ) : ℝ :=
  ∑ k ∈ U, ((1 - p1 k) ^ (s + 1) - (1 - p2 k) ^ (s + 1))

def auditedHazardAdvantage (U : Finset ι) (p1 p2 : ι → ℝ) (s : ℕ) : ℝ :=
  ∑ k ∈ U, (p2 k * (1 - p2 k) ^ (s + 1) -
    p1 k * (1 - p1 k) ^ (s + 1))

/-- Aggregate forward-difference identity, using the original
one-language Lean theorem termwise. -/
theorem auditedCumulativeGap_step
    (U : Finset ι) (p1 p2 : ι → ℝ) (s : ℕ) :
    auditedCumulativeGap U p1 p2 (s + 1) -
      auditedCumulativeGap U p1 p2 s =
      auditedHazardAdvantage U p1 p2 s := by
  unfold auditedCumulativeGap auditedHazardAdvantage
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro k hk
  simpa only [Nat.add_assoc] using
    (cumulative_gap_first_difference (p1 k) (p2 k) s)

/-- Necessary and sufficient condition for the cumulative frontier gap
to grow weakly over one discrete time step. This claim is not implied
by p2 >= p1 alone without further assumptions. -/
theorem auditedCumulativeGap_nocatchup_iff
    (U : Finset ι) (p1 p2 : ι → ℝ) (s : ℕ) :
    auditedCumulativeGap U p1 p2 s ≤
      auditedCumulativeGap U p1 p2 (s + 1) ↔
      0 ≤ auditedHazardAdvantage U p1 p2 s := by
  constructor
  · intro h
    have hdiff : 0 ≤ auditedCumulativeGap U p1 p2 (s + 1) -
        auditedCumulativeGap U p1 p2 s := sub_nonneg.mpr h
    simpa only [auditedCumulativeGap_step] using hdiff
  · intro h
    apply sub_nonneg.mp
    simpa only [auditedCumulativeGap_step] using h

end QX26AgenticDelegation
