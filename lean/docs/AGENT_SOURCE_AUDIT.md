# Agent Source Audit: QX26AgenticDelegation

## Overall status: COMPLETE — PARTIALLY FORMALIZED

Independent source-first review completed on 2026-11-23 by OpenAI
`gpt-5.6-sol` with reasoning effort `medium`. This is a semantic audit result,
not a human dashboard sign-off or an EcoCSLib final-closure credential.

## Source Inventory

- Source: Quispe and Xu (2026), arXiv:2605.25438v2.
- Audited PDF SHA-256:
  `cddc048711c43022d5fd01b995bfb1114c728c8c879b809b5fdc354a391d3c35`.
- Reviewed source surface: Propositions 1--5; Equation (10); the
  first-difference identity in Equation (26); and the strict-increase and
  strict-concavity argument for Proposition 3.
- Source-first evidence was read from the proposition statements and appendix
  proofs before comparing the Lean declarations.
- Empirical estimates, data construction, and the Bayesian-learning extension
  were excluded because the current Lean interface does not claim to formalize
  them.

## Lean Interface Comparison

| Lean `Spec` | Semantic judgment | Source comparison |
|---|---|---|
| `frontier_expansionSpec` | Partial match | Correctly proves monotonicity of active-language counts once pointwise `V1 <= V2` is supplied. It does not formalize the paper's menu definitions or derive that premise from `M1 subset M2`; developer/language/date structure is abstracted away. |
| `activation_bandSpec` | Partial match | The indicator identity is correct and slightly more general at `TD = TS`. The source route through unfamiliar-language status, Assumption 1, `T1 = TS`, `B = TS - TD > 0`, and `T2 = TD` is not represented. |
| `cumulative_effect_nonnegSpec` | Match at the stated algebraic layer | It represents Equation (10) for a finite unfamiliar-language set and makes the probability bounds `0 <= p1 <= p2 <= 1` explicit. |
| `cumulative_gap_first_differenceSpec` | Match | It is the exact one-language algebraic identity used in Equation (26). |
| `cumulative_effect_strict_mono_closedFrontierSpec` | Corrected match | It proves the source conclusion only on the valid interior domain `0 < p2 < 1`. The paper states only `0 < p2`, which also admits the false endpoint `p2 = 1`. |
| `cumulative_effect_strict_concave_closedFrontierSpec` | Corrected match | It proves strict concavity on `0 < p2 < 1`; the same missing upper-bound condition affects the paper statement. |
| `cumulative_effect_endpoint_flatSpec` | Valid audit support | It proves the counterexample at `p2 = 1`: the cumulative effect equals one and is flat. This is an audit finding, not a theorem asserted by the source. |
| `specialist_heterogeneitySpec` | Partial / material mismatch | It proves only `sum p = card(U) * p`. The conditional-expectation object, Assumption 3, dependence on ability, monotonicity of `p_i(a_i,A)`, and the paper's comparative-static conclusions are absent. |
| `repository_expansionSpec` | Partial match | It proves deterministic weak indicator-count monotonicity under pointwise cost reduction. The paper's expectation, repository-to-required-language map, strict expansion, and positive-mass activation-band condition are absent. |

The source-facing interface also omits standalone representations of the three
named paper assumptions, the production-mode values, the threshold definitions,
the delegation advantage `B`, and the conditional-CDF probability statement.
`Assumptions.lean` is empty, while several `Spec` declarations accept local
premises that have not been connected to named source assumptions or checked
Lean derivations. These omissions prevent an exact full-paper status.

## Machine Audit Results

- `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast`:
  PASS in WSL; focused build reported 8,315 jobs.
- Direct compilation of `ProofInterface.lean`: PASS with exit code 0.
- Proof endpoints: 9; executable `sorry`/`admit` occurrences: 0.
- Public paper folder copied to `lean/`: 25 of 25 files match the WSL-generated
  folder byte-for-byte after excluding ignored source bytes.
- Strict EcoCSLib closeout: not issued. At official repository HEAD
  `cf500b74`, the current formalization-engine digest
  `482e459e24cf7163b4c6abdb6e4db1c6872c52e9adffab1eed7ab30b7e1c7bcc`
  is not the last digest registered by
  `config/formalization_engine_revisions.json`. The official planner therefore
  stops at `inspect_engine_registration` before semantic closeout.

## Findings

- Audit result: the nine Lean propositions are genuine proved algebraic
  statements, but the module is only a partial semantic formalization of the
  paper.
- Confirmed paper defect: Proposition 3's strict increase and strict concavity
  require `p2 < 1`; at `p2 = 1` the path is flat after immediate entry.
- Main remaining formalization obligations: source-route the paper assumptions
  and model definitions; replace the Proposition 4 surrogate with the actual
  conditional-expectation/comparative-static claim; and add the expectation and
  strictness parts of Proposition 5.
- Human dashboard review remains unrecorded. The machine closeout can only be
  retried after EcoCSLib registers or repairs the engine revision at its
  official HEAD.
