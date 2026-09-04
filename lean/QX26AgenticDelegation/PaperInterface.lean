import QX26AgenticDelegation.MainTheorems
import QX26AgenticDelegation.Assumptions

/-!
# Human-Facing Paper Interface: Agentic Delegation and the Language Frontier of Software Developers

This is the compact Lean file a human should read after formalization to check
whether the paper's definitions and named theorem statements were represented
correctly. Keep the row-level dashboard and LLM audit statements in this file
for every paper. Move implementation details, proof aliases, and bulky helper
lemmas behind imported modules such as `AuditInterface.lean`, but expose the
audited paper-facing statements directly here; do not use
`paper_interface.audit_surface_path`.

Rules for completing this file:

- Keep the paper's definitions/formatted objects first, in source order.
- Expose the actual paper formulas here; do not only point to generic library
  definitions or implementation witnesses.
- A material reusable `EconCSLib` primitive may remain a reference here only
  after `audit/library_semantic_review.json` records its exact bounded library
  declaration and an explicit byte-pinned paper-source connection. The
  dashboard and human-review packet show and source-check that declaration
  before the dependent Spec; a library name, docstring, or glossary is not a
  semantic bridge. Do not add a duplicate paper claim merely to restate it.
- If a named theorem needs a hypothesis that is not derived from earlier Lean
  declarations, declare that hypothesis in `Assumptions.lean` and list it in
  `status.json` `review_surface.assumption_names`.
- Then state the named results directly, with assumptions visible in each
  theorem signature by referencing named paper assumptions imported from
  `Assumptions.lean`.
- In the statement-first phase, write every complete source-facing statement as
  a transparent `<name>Spec : Prop` here, exactly once. Put the paired
  theorem/lemma of that exact type in `ProofInterface.lean`; its temporary
  proof body may be `by sorry` only in a private draft. This separation keeps
  the human semantic surface free of thin wrapper declarations.
- Before drafting that Lean surface, independently inventory every material
  source atom from exact pinned source quote bytes. Do not infer source atoms
  from declaration, binder, field, function, or source-map names.
- Run raw-source-to-expanded-Spec statement matching plus recursive
  premise/conclusion provenance on the skeleton. The semantic comparison uses
  only byte-pinned source quotes (and separately pinned source context) against
  the expanded transparent Spec; map summaries and proof wrappers are not
  semantic inputs. Then freeze each canonical Lean declaration-manifest digest.
- In the proof phase, replace the `ProofInterface.lean` `sorry` with a short
  proof that calls into `MainTheorems.lean` or lower proof files without
  changing the specification or theorem type. Any specification/type change
  invalidates the freeze and requires a fresh statement audit.
- At formalized closeout, complete the v11 realization receipt: Lean Meta checks
  the theorem has exactly the transparent Spec type; each source atom is bound
  to the elaborated Spec surface; closure traversal includes proof and instance
  arguments; and every material terminal has a source, approved correction or
  additional assumption, checked derivation, or version-pinned foundation
  disposition. No data, container, or identifier-based exemption is allowed.
- The transparent `...Spec` is the sole semantic-review target for its source
  claim. The paired theorem/lemma is a proof endpoint whose exact Spec type is
  verified by Lean Meta, not a duplicate source-to-Lean comparison row.
- Keep proof endpoints, exhaustive endpoint aliases, and proof-seam checks in
  `ProofInterface.lean`, implementation modules, or `ProofLedger.lean`, not
  here. Do not create new `PostPaperAudit.lean` or `AuditLedger.lean` files;
  those names are legacy.

## Named Results

Each entry has one semantic-review target (`Spec`) and one proof endpoint (the
paired theorem/lemma). The human dashboard and review packet present that pair
once rather than treating the two declarations as duplicate paper claims.

- `frontier_expansionSpec` -> `frontier_expansion`: Proposition 1 (Frontier expansion), sections/03_theory.tex:155-163 (label prop:frontier); proof sections/10_appendix.tex:90-105.
- `activation_bandSpec` -> `activation_band`: Proposition 2 (Activation band for unfamiliar languages), sections/03_theory.tex:165-193 (label prop:band, Eq. band-indicator L173); proof sections/10_appendix.tex:107-123.
- `cumulative_effect_nonnegSpec` -> `cumulative_effect_nonneg`: Proposition 3 (Dynamic cumulative-language effect) -- nonnegativity, sections/03_theory.tex:282-298 (label prop:dynamic, Eq. cumulative-gap); proof sections/10_appendix.tex:172-210.
- `cumulative_gap_first_differenceSpec` -> `cumulative_gap_first_difference`: Proposition 3 proof -- one-language first-difference identity, sections/10_appendix.tex:188-198 (first-difference align block).
- `cumulative_effect_strict_mono_closedFrontierSpec` -> `cumulative_effect_strict_mono_closedFrontier`: Proposition 3 -- closed-frontier strict increase (corrected hypothesis), sections/03_theory.tex:296-297; proof sections/10_appendix.tex:206-209.
- `cumulative_effect_strict_concave_closedFrontierSpec` -> `cumulative_effect_strict_concave_closedFrontier`: Proposition 3 -- closed-frontier strict concavity (corrected hypothesis), sections/03_theory.tex:296-297; proof sections/10_appendix.tex:206-209 (second difference -(p2)^2(1-p2)^{s+1}<0).
- `cumulative_effect_endpoint_flatSpec` -> `cumulative_effect_endpoint_flat`: Proposition 3 -- included-endpoint counterexample to strictness (audit finding), audit of sections/03_theory.tex:296-297 vs proof L206-209; benchmark p1=0<p2 admits p2=1.
- `specialist_heterogeneitySpec` -> `specialist_heterogeneity`: Proposition 4 (Specialist and ability heterogeneity), sections/10_appendix.tex:138-146 (label prop:specialist, Eq. specialist-expansion); proof L148-165.
- `repository_expansionSpec` -> `repository_expansion`: Proposition 5 (Repository expansion), sections/10_appendix.tex:251-272 (label prop:repos).
-/

namespace QX26AgenticDelegation

/--
Proposition 1 (Frontier expansion)

Paper statement: For every developer, language, date, and opportunity realization, Z^2_ik,t >= Z^1_ik,t, hence N^2_it >= N^1_it path by path (M_1={S,C} subset {S,C,D}=M_2 so V^2 >= V^1).

Source location: sections/03_theory.tex:155-163 (label prop:frontier); proof sections/10_appendix.tex:90-105
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def frontier_expansionSpec : Prop :=
  ∀ {ι : Type*} (K : Finset ι) (V1 V2 : ι → ℝ), (∀ k ∈ K, V1 k ≤ V2 k) → ∑ k ∈ K, (if 0 ≤ V1 k then (1:ℝ) else 0) ≤ ∑ k ∈ K, (if 0 ≤ V2 k then (1:ℝ) else 0)

/--
Proposition 2 (Activation band for unfamiliar languages)

Paper statement: For an unfamiliar language with T^1=T^S (Assumption foothold), if B=T^S-T^D>0 then Z^2-Z^1 = 1[T^D <= omega < T^S].

Source location: sections/03_theory.tex:165-193 (label prop:band, Eq. band-indicator L173); proof sections/10_appendix.tex:107-123
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def activation_bandSpec : Prop :=
  ∀ (TD TS ω : ℝ), TD ≤ TS → (if TD ≤ ω then (1:ℝ) else 0) - (if TS ≤ ω then (1:ℝ) else 0) = (if TD ≤ ω ∧ ω < TS then (1:ℝ) else 0)

/--
Proposition 3 (Dynamic cumulative-language effect) -- nonnegativity

Paper statement: If p^2_ik >= p^1_ik then Delta C_i(s) = sum_{k in U_i}[(1-p^1_ik)^{s+1}-(1-p^2_ik)^{s+1}] >= 0.

Source location: sections/03_theory.tex:282-298 (label prop:dynamic, Eq. cumulative-gap); proof sections/10_appendix.tex:172-210
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def cumulative_effect_nonnegSpec : Prop :=
  ∀ {ι : Type*} (U : Finset ι) (p1 p2 : ι → ℝ) (s : ℕ), (∀ k ∈ U, 0 ≤ p1 k ∧ p1 k ≤ p2 k ∧ p2 k ≤ 1) → 0 ≤ ∑ k ∈ U, ((1 - p1 k) ^ (s + 1) - (1 - p2 k) ^ (s + 1))

/--
Proposition 3 proof -- one-language first-difference identity

Paper statement: [(1-p1)^{s+2}-(1-p2)^{s+2}]-[(1-p1)^{s+1}-(1-p2)^{s+1}] = p2(1-p2)^{s+1}-p1(1-p1)^{s+1}.

Source location: sections/10_appendix.tex:188-198 (first-difference align block)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def cumulative_gap_first_differenceSpec : Prop :=
  ∀ (p1 p2 : ℝ) (s : ℕ), (((1 - p1) ^ (s + 2) - (1 - p2) ^ (s + 2)) - ((1 - p1) ^ (s + 1) - (1 - p2) ^ (s + 1))) = p2 * (1 - p2) ^ (s + 1) - p1 * (1 - p1) ^ (s + 1)

/--
Proposition 3 -- closed-frontier strict increase (corrected hypothesis)

Paper statement: Source writes p^1=0<p^2 => strictly increasing. DEVIATION: strictness also requires p^2<1; corrected hypothesis 0<p^2<1.

Source location: sections/03_theory.tex:296-297; proof sections/10_appendix.tex:206-209
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def cumulative_effect_strict_mono_closedFrontierSpec : Prop :=
  ∀ (p2 : ℝ) (s : ℕ), 0 < p2 → p2 < 1 → (1 - (1 - p2) ^ (s + 1)) < (1 - (1 - p2) ^ (s + 2))

/--
Proposition 3 -- closed-frontier strict concavity (corrected hypothesis)

Paper statement: Source: p^1=0<p^2 => strictly concave. DEVIATION: strictness requires 0<p^2<1.

Source location: sections/03_theory.tex:296-297; proof sections/10_appendix.tex:206-209 (second difference -(p2)^2(1-p2)^{s+1}<0)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def cumulative_effect_strict_concave_closedFrontierSpec : Prop :=
  ∀ (p2 : ℝ) (s : ℕ), 0 < p2 → p2 < 1 → ((1 - (1 - p2) ^ (s + 3)) - (1 - (1 - p2) ^ (s + 2))) < ((1 - (1 - p2) ^ (s + 2)) - (1 - (1 - p2) ^ (s + 1)))

/--
Proposition 3 -- included-endpoint counterexample to strictness (audit finding)

Paper statement: At p1=0,p2=1 the one-language gap is d(s)=1-(1-1)^{s+1}=1 for all s, hence d(s+1)=d(s): the strict conclusion fails at the included endpoint p2=1.

Source location: audit of sections/03_theory.tex:296-297 vs proof L206-209; benchmark p1=0<p2 admits p2=1
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def cumulative_effect_endpoint_flatSpec : Prop :=
  ∀ (s : ℕ), (1 - (1 - (1 : ℝ)) ^ (s + 1)) = 1 ∧ (1 - (1 - (1 : ℝ)) ^ (s + 2)) = (1 - (1 - (1 : ℝ)) ^ (s + 1))

/--
Proposition 4 (Specialist and ability heterogeneity)

Paper statement: Under Assumption exchangeable, E[E_i | a_i,U_i] = U_i p_i(a_i,A) (linearity of expectation over U_i identical increments).

Source location: sections/10_appendix.tex:138-146 (label prop:specialist, Eq. specialist-expansion); proof L148-165
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def specialist_heterogeneitySpec : Prop :=
  ∀ {ι : Type*} (U : Finset ι) (p : ℝ), ∑ _k ∈ U, p = (U.card : ℝ) * p

/--
Proposition 5 (Repository expansion)

Paper statement: If delegation weakly lowers entry cost per repository (c^2<=c^1), the expected number of enterable repositories weakly increases.

Source location: sections/10_appendix.tex:251-272 (label prop:repos)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def repository_expansionSpec : Prop :=
  ∀ {ρ : Type*} (R : Finset ρ) (Ω c1 c2 : ρ → ℝ), (∀ r ∈ R, c2 r ≤ c1 r) → ∑ r ∈ R, (if 0 ≤ Ω r - c1 r then (1:ℝ) else 0) ≤ ∑ r ∈ R, (if 0 ≤ Ω r - c2 r then (1:ℝ) else 0)

end QX26AgenticDelegation
