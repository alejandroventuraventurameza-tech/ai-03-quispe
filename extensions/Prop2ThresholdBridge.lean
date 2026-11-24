import QX26AgenticDelegation.Prop3NoCatchUp

/-!
# Independent economic-to-Lean bridge for Proposition 2

Source: Quispe and Xu (2026), arXiv:2605.25438v2,
sections 4.1-4.2 and Appendix A.2-A.4 (equations 16-20 and Proposition 2).

This extension records the three certainty-equivalent *surplus formulas* as
economic algebraic primitives. It does not derive CARA-normal expected utility,
the underlying probability law, or comparative-static derivative assumptions.

It verifies: surplus = opportunity minus threshold; solo/copilot foothold;
the fully expanded delegation advantage B; and the activation band when the
foothold holds and B > 0. B <= 0 gives no novel activation under the foothold.
The generated EconCSLib folder remains untouched.
-/

namespace QX26AgenticDelegation

/-- The local quantities entering the one-language threshold comparison.
agentExecution stands for a * z(A), already evaluated at the developer/agent.
All are real algebraic inputs; economic sign/domain restrictions must be
introduced when an application requires them. -/
structure DelegationPrimitives where
  entryCost : ℝ
  skill : ℝ
  meanMatch : ℝ
  precision : ℝ
  riskAversion : ℝ
  delegatedShare : ℝ
  agentExecution : ℝ
  verificationCost : ℝ
  computeCost : ℝ
  residualVariance : ℝ
  copilotProductivity : ℝ
  copilotCost : ℝ

noncomputable def soloValue (p : DelegationPrimitives) (ω : ℝ) : ℝ :=
  ω + p.skill * p.meanMatch -
    (p.riskAversion / 2) * (p.skill ^ 2 / p.precision) - p.entryCost

noncomputable def copilotValue (p : DelegationPrimitives) (ω : ℝ) : ℝ :=
  soloValue p ω + p.copilotProductivity * p.skill - p.copilotCost

noncomputable def delegationValue (p : DelegationPrimitives) (ω : ℝ) : ℝ :=
  ω + (1 - p.delegatedShare) * p.skill * p.meanMatch +
    p.delegatedShare * p.agentExecution - p.verificationCost -
    p.computeCost - p.entryCost -
    (p.riskAversion / 2) *
      (((1 - p.delegatedShare) ^ 2 * p.skill ^ 2) / p.precision +
        p.residualVariance)

noncomputable def soloThreshold (p : DelegationPrimitives) : ℝ :=
  p.entryCost - p.skill * p.meanMatch +
    (p.riskAversion / 2) * (p.skill ^ 2 / p.precision)

noncomputable def copilotThreshold (p : DelegationPrimitives) : ℝ :=
  soloThreshold p - (p.copilotProductivity * p.skill - p.copilotCost)

noncomputable def delegationThreshold (p : DelegationPrimitives) : ℝ :=
  p.entryCost - (1 - p.delegatedShare) * p.skill * p.meanMatch -
    p.delegatedShare * p.agentExecution + p.verificationCost +
    p.computeCost + (p.riskAversion / 2) *
      (((1 - p.delegatedShare) ^ 2 * p.skill ^ 2) / p.precision +
        p.residualVariance)

/-- The best available entry threshold before/after delegation. -/
noncomputable def preThreshold (p : DelegationPrimitives) : ℝ :=
  min (soloThreshold p) (copilotThreshold p)

noncomputable def postThreshold (p : DelegationPrimitives) : ℝ :=
  min (preThreshold p) (delegationThreshold p)

/-- The explicit advantage from Appendix A.2, equation (20). -/
noncomputable def delegationAdvantage (p : DelegationPrimitives) : ℝ :=
  p.delegatedShare * (p.agentExecution - p.skill * p.meanMatch) -
    p.verificationCost - p.computeCost +
    (p.riskAversion / 2) *
      (((2 * p.delegatedShare - p.delegatedShare ^ 2) *
        p.skill ^ 2) / p.precision - p.residualVariance)

/-- Eq. (16) as a proper bridge from the source surplus, not an abstract V. -/
theorem soloValue_eq_opportunity_sub_threshold
    (p : DelegationPrimitives) (ω : ℝ) :
    soloValue p ω = ω - soloThreshold p := by
  unfold soloValue soloThreshold
  ring

/-- Eq. (17): copilot option shifts the solo threshold by the net gain. -/
theorem copilotValue_eq_opportunity_sub_threshold
    (p : DelegationPrimitives) (ω : ℝ) :
    copilotValue p ω = ω - copilotThreshold p := by
  unfold copilotValue copilotThreshold
  rw [soloValue_eq_opportunity_sub_threshold]
  ring

/-- Eq. (19): delegated surplus equals opportunity minus its threshold. -/
theorem delegationValue_eq_opportunity_sub_threshold
    (p : DelegationPrimitives) (ω : ℝ) :
    delegationValue p ω = ω - delegationThreshold p := by
  unfold delegationValue delegationThreshold
  ring

/-- Eq. (20): B = T^S - T^D, with the complete risk substitution term. -/
theorem delegationAdvantage_eq_threshold_difference
    (p : DelegationPrimitives) :
    delegationAdvantage p = soloThreshold p - delegationThreshold p := by
  unfold delegationAdvantage soloThreshold delegationThreshold
  ring

/-- Assumption 1 (foothold): gamma*s-rC <= 0 makes solo the best old option. -/
theorem preThreshold_eq_solo_of_foothold
    (p : DelegationPrimitives)
    (hfoot : p.copilotProductivity * p.skill - p.copilotCost ≤ 0) :
    preThreshold p = soloThreshold p := by
  unfold preThreshold
  apply min_eq_left
  unfold copilotThreshold
  linarith

/-- If B>0 under the foothold, the new threshold equals T^D. -/
theorem postThreshold_eq_delegation_of_advantage
    (p : DelegationPrimitives)
    (hfoot : p.copilotProductivity * p.skill - p.copilotCost ≤ 0)
    (hB : 0 < delegationAdvantage p) :
    postThreshold p = delegationThreshold p := by
  have hpre := preThreshold_eq_solo_of_foothold p hfoot
  have hdiff : 0 < soloThreshold p - delegationThreshold p := by
    rw [← delegationAdvantage_eq_threshold_difference p]
    exact hB
  unfold postThreshold
  rw [hpre]
  exact min_eq_right (le_of_lt (by linarith : delegationThreshold p < soloThreshold p))

/-- If the delegation advantage is not positive, old production survives.
This statement requires the unfamiliar-language foothold. -/
theorem postThreshold_eq_pre_of_nonpositive_advantage
    (p : DelegationPrimitives)
    (hfoot : p.copilotProductivity * p.skill - p.copilotCost ≤ 0)
    (hB : delegationAdvantage p ≤ 0) :
    postThreshold p = preThreshold p := by
  have hpre := preThreshold_eq_solo_of_foothold p hfoot
  have hdiff : soloThreshold p - delegationThreshold p ≤ 0 := by
    rw [← delegationAdvantage_eq_threshold_difference p]
    exact hB
  unfold postThreshold
  apply min_eq_left
  rw [hpre]
  linarith

/-- Proposition 2 from the economic formulas: strict advantage plus foothold
implies exactly the half-open activation band (A.4), using the original
Lean indicator lemma. -/
theorem activation_band_from_economic_primitives
    (p : DelegationPrimitives) (ω : ℝ)
    (hfoot : p.copilotProductivity * p.skill - p.copilotCost ≤ 0)
    (hB : 0 < delegationAdvantage p) :
    (if postThreshold p ≤ ω then (1 : ℝ) else 0) -
      (if preThreshold p ≤ ω then (1 : ℝ) else 0) =
      (if delegationThreshold p ≤ ω ∧ ω < soloThreshold p then
        (1 : ℝ) else 0) := by
  have hpre := preThreshold_eq_solo_of_foothold p hfoot
  have hpost := postThreshold_eq_delegation_of_advantage p hfoot hB
  have hdiff : 0 < soloThreshold p - delegationThreshold p := by
    rw [← delegationAdvantage_eq_threshold_difference p]
    exact hB
  have horder : delegationThreshold p ≤ soloThreshold p := by linarith
  rw [hpre, hpost]
  exact activation_band (delegationThreshold p) (soloThreshold p) ω horder

/-- The old modes remain available: menu inclusion weakly raises best surplus
for every opportunity realization, independently of B's sign. -/
theorem menu_surplus_weak_expansion
    (p : DelegationPrimitives) (ω : ℝ) :
    max (soloValue p ω) (copilotValue p ω) ≤
      max (max (soloValue p ω) (copilotValue p ω))
        (delegationValue p ω) := by
  exact le_max_left _ _

end QX26AgenticDelegation
