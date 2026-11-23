# Source-to-Lean crosswalk — Quispe & Xu, arXiv:2605.25438v2

**Scope:** this is a researcher-authored explanation of the nine selected algebraic proof endpoints in `lean/`. It is **not** the generated EconCSLib source-first audit and must not be used to promote `lean/status.json` to `formalized`.

| Paper item | Lean `Spec` / proof endpoint | Exact mathematical result represented | Important boundary |
| --- | --- | --- | --- |
| Proposition 1, frontier expansion | `frontier_expansionSpec` / `frontier_expansion` | The sum of activation indicators is weakly monotone if each period-specific surplus increases pointwise | Assumes `V1 k ≤ V2 k`; does not itself derive these surpluses from the full mode-choice model |
| Proposition 2, activation band | `activation_bandSpec` / `activation_band` | If `TD ≤ TS`, the difference of two entry indicators equals the indicator of `TD ≤ ω < TS` | Does not prove the paper's formula for `B = TS − TD`, its sign from primitives, or the full *foothold* assumption |
| Proposition 3, cumulative gap | `cumulative_effect_nonnegSpec` / `cumulative_effect_nonneg` | For finite language sets and `0 ≤ p1 ≤ p2 ≤ 1`, the sum of differences of survival powers is nonnegative | Probability interpretation of constant hazards and information structure remains an external model bridge |
| Proposition 3, first difference | `cumulative_gap_first_differenceSpec` / `cumulative_gap_first_difference` | Exact algebraic forward-difference identity for one language | The no-catch-up condition for aggregated languages is not established by this identity |
| Proposition 3, strict increase | `cumulative_effect_strict_mono_closedFrontierSpec` / corresponding theorem | For closed frontier `p1 = 0` and **`0 < p2 < 1`**, the one-language gap grows strictly | This corrects the source's stated endpoint domain; not an unconditional statement for arbitrary `p1,p2` |
| Proposition 3, strict concavity | `cumulative_effect_strict_concave_closedFrontierSpec` / corresponding theorem | Strictly negative second forward difference under **`0 < p2 < 1`** | Discrete, one-language strict concavity, not a proved generic path for every heterogeneous language set |
| Proposition 3, endpoint counterexample | `cumulative_effect_endpoint_flatSpec` / `cumulative_effect_endpoint_flat` | If `p1=0,p2=1`, then `d(s)=d(s+1)=1` | Refutes *strict* increase and *strict* discrete concavity, not weak concavity |
| Proposition 4, specialist heterogeneity | `specialist_heterogeneitySpec` / `specialist_heterogeneity` | A finite sum of identical real increments equals cardinality times that increment | Does not formalize the conditional expectation, exchangeability or probability law in the economic proposition |
| Proposition 5, repository expansion | `repository_expansionSpec` / `repository_expansion` | Sum of repository entry indicators rises weakly if entry cost weakly falls for each repository | No derivation of the expected repository count from the source's stochastic model |

## Endpoint derivation that motivates the audit

For one unfamiliar language, define `d(s)=(1-p1)^(s+1)-(1-p2)^(s+1)`. Algebra yields

\[
d(s+1)-d(s)=p^2(1-p^2)^{s+1}-p^1(1-p^1)^{s+1}.
\]

In the closed-frontier benchmark `p1=0`, the first difference is `p2(1-p2)^(s+1)` and the second difference is `-(p2)^2(1-p2)^(s+1)`. Both strict signs require `0<p2<1`. If `p2=1`, the path is constant at one for every nonnegative integer horizon.

This is a **genuine source-side conditional correction** supported by a short proof, not a proof of a complete empirical causal model.

## Evidence classification and remaining obligations

1. **Lean kernel claim (recorded, not independently rerun here):** the repository's `lean-check.txt` reports the focused build (8,315 jobs) and `paper_contribution.py check ... --fast` as PASS, with nine proof endpoints and no `sorry` in the paper Lean files.
2. **Source semantics (still open):** the generated `lean/status.json`, `lean/FINAL_VALIDATION_REPORT.md`, `lean/docs/AGENT_SOURCE_AUDIT.md` and audit ledgers retain incomplete state. The nine source-facing `Spec` declarations have not received independent source-first, byte-pinned semantic review or human sign-off.
3. **Presentation (separate check):** the GitHub Actions `Build and review Beamer` job compiles `presentation.tex` into a PDF. A Beamer success proves neither the Lean theorem types nor source correspondence.
4. **Agent provenance (still open):** the raw agent transcript and proof that `gpt-5.6-sol` with effort `xhigh` was used are not present in the repository. Do not infer them from the local check.
5. **Author's independent handwritten audit (still open):** genuine photographs are required in `hand/` and in the deck; the existing `hand/README.md` is instructions only.

**Conclusion:** report this as **nine recorded Lean algebraic proof endpoints with a corrected Proposition 3 endpoint and incomplete source-to-Lean equivalence review**, not as the complete formalization of all five source propositions.
