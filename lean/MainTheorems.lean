import Mathlib

/-!
# Paper-Facing Theorems: Agentic Delegation and the Language Frontier of Software Developers

Implementation theorem layer. Reusable helper lemmas used by the exact-type
proof endpoints in `ProofInterface.lean` live here; the compact human-review
`...Spec` surface stays in `PaperInterface.lean`.
-/

namespace QX26AgenticDelegation

/-- Monotonicity of the activation indicator `1[0 ≤ V]` in the surplus `V`.
This is the shared engine behind Proposition 1 (frontier) and Proposition 5
(repository expansion): a weakly higher available surplus never deactivates an
already-active language/repository. -/
lemma indicator_mono {V1 V2 : ℝ} (h : V1 ≤ V2) :
    (if 0 ≤ V1 then (1 : ℝ) else 0) ≤ (if 0 ≤ V2 then (1 : ℝ) else 0) := by
  by_cases h1 : 0 ≤ V1
  · have h2 : 0 ≤ V2 := le_trans h1 h
    simp [if_pos h1, if_pos h2]
  · rw [if_neg h1]
    split_ifs <;> norm_num

end QX26AgenticDelegation
