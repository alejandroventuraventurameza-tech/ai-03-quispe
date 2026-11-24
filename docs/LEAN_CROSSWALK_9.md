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

## Verified extension for the missing aggregate no-catch-up condition (2026-11-23)

The original nine endpoints include an exact one-language first-difference identity, but not the aggregated necessary-and-sufficient condition. A separate non-generated module [extensions/Prop3NoCatchUp.lean](../extensions/Prop3NoCatchUp.lean) now proves:

1. `auditedCumulativeGap_step`: the aggregate one-period increment equals the finite sum of the individual weighted hazard advantages.
2. `auditedCumulativeGap_nocatchup_iff`: the aggregate gap increases weakly at a given horizon **if and only if** that sum is nonnegative.

**Verification:** [Actions #45235387712](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45235387712), 8,317 jobs, eleven endpoints free of sorryAx, `check --fast` PASS. The extension was injected only into a temporary pinned upstream checkout during CI; it was **not** added to or substituted for the original generated `lean/` artifacts. This does not close the remaining source-to-Spec audit for the entire paper.

**Illustrative exact counterexample (arithmetic, not a separately Lean-certified theorem):** for a single language, let (p^1=1/5) and (p^2=2/5). Then (d(2)=37/125=185/625), while (d(3)=175/625), so (d(3)<d(2)) despite (p^2>p^1). Hazard ordering guarantees nonnegativity of the level difference, not its monotonicity at every horizon.

## Puente económico de la Proposición 2 — verificado en GitHub Actions

La matriz de **nueve** filas anterior corresponde al **módulo generado** y no cambia. Una extensión separada, [`extensions/Prop2ThresholdBridge.lean`](../extensions/Prop2ThresholdBridge.lean), añade **nueve teoremas nuevos**: tres identidades de beneficio y umbral, la igualdad de la ventaja de delegación, el caso foothold, el caso B positivo, el caso B no positivo, el indicador de banda activada desde los parámetros y el aumento débil del mejor beneficio por menú ampliado.

**Prueba independiente:** [GitHub Actions #45245835608](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45245835608) **PASS**: 8,318 jobs, 20 endpoints inspeccionados sin `sorryAx`, `check --fast` correcto. La correspondencia primaria de las ecuaciones (16)–(20) y sus supuestos consta en [`SOURCE_AUDIT_PROP2_20261123.md`](SOURCE_AUDIT_PROP2_20261123.md). No se deriva la distribución de oportunidades ni la fórmula de CDF de la banda, ni se sustituye la carpeta EconCSLib original.


## Proposición 4: puente de esperanza condicional (extensión externa)

Se conserva la matriz original de nueve `Spec`. [`Prop4ExpectedExpansion.lean`](../extensions/Prop4ExpectedExpansion.lean) incorpora cuatro teoremas sobre esperanza condicional mediante `conditionalLaw a U` **suministrada** y sobre las condiciones débiles/estrictas de especialización y habilidad. [Actions #45283067690](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45283067690) **PASS** con **8,319 jobs**, **24 teoremas sin `sorryAx`** y `check --fast` aprobado. No se construye la ley condicional ni se deduce de las primitivas la probabilidad de activar una lengua. Véase [auditoría de A.5](SOURCE_AUDIT_PROP4_20261123.md).


## Proposición 5: esperanza y masa positiva (extensión externa)

La matriz original de nueve `Spec` permanece intacta. [`Prop5RepositoryExpectation.lean`](../extensions/Prop5RepositoryExpectation.lean) agrega cuatro teoremas: suma de bandas igual a diferencia de conteos, monotonía puntual, monotonía de la esperanza y crecimiento estricto bajo masa positiva en una banda. **GitHub Actions [#45288831429](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45288831429) PASS**, 8,320 jobs, 28 endpoints sin `sorryAx`, `check --fast` correcto. Los costes (c_r^g) siguen siendo entradas del modelo; la construcción económica completa de esos costes no ha sido formalizada. [Auditoría A.8](SOURCE_AUDIT_PROP5_20261123.md).


## Proposición 1: expansión estricta como corolario condicionado (extensión externa)

Se conserva inalterada la tabla de nueve `Spec` del módulo original. [`Prop1StrictFrontier.lean`](../extensions/Prop1StrictFrontier.lean) agrega cinco teoremas: expansión débil desde el menú de tres opciones, diferencia exacta del conteo, expansión estricta dada una lengua nueva viable solo por delegación, implicación banda→`B>0` y expansión estricta desde el foothold más la banda económica. **GitHub Actions [#45291226305](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45291226305) PASS:** 8,321 jobs, **33 teoremas sin `sorryAx` ni `unsafeAx`**, `check --fast` aprobado. Fuente contrastada en [§4.2 y apéndice A.3](SOURCE_AUDIT_PROP1_20261123.md). La estrictez requiere un testigo: no es conclusión incondicional de la Proposición 1 ni prueba de un efecto causal de adopción.


## Apéndice A.7: álgebra de precisión y media posteriores (extensión externa)

Las nueve declaraciones fuente-facing originales siguen intactas. [`AppendixA7BayesianLearning.lean`](../extensions/AppendixA7BayesianLearning.lean) prueba **siete teoremas** sobre suma de precisiones inversas de varianzas, mayor precisión posterior, media ponderada, expansión del núcleo cuadrático Normal y dirección posible del cambio de media. **[GitHub Actions #45331830830](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45331830830) PASS:** **8,322 jobs, 40 teoremas inspeccionados sin `sorryAx` ni `unsafeAx`**, `check --fast` correcto. La demostración probabilística de conjugación Normal–Normal con distribuciones condicionales **no** se reivindica como finalizada. [Fuente y límites matemáticos](APPENDIX_A7_BAYESIAN_20261124.md).
