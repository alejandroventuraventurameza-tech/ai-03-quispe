# Repository 3 — Quispe & Xu (2026)

**Paper.** Quispe, A., and K. Xu (2026), *Agentic Delegation and the Language Frontier of Software Developers: A Model and Evidence from Claude Code on GitHub*, [arXiv:2605.25438v2](https://arxiv.org/abs/2605.25438v2).  
**Submission.** [Course issue #2](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/2) · [Beamer source](presentation.tex) · [selected raw chats and provenance limitations](prompts.md) · [EconCSLib folder](lean/) · [compliance ledger](docs/ISSUE2_CLOSEOUT.md).

## Question and economic problem

Can delegated AI execution make a developer *produce* in programming languages previously outside their production frontier? For each developer \(i\), language \(k\), and month \(t\), the developer chooses the production mode with the highest certainty-equivalent surplus. Before delegation the menu is \(\mathcal M_1=\{S,C\}\) (solo and conversational); afterwards \(\mathcal M_2=\{S,C,D\}\). The language is active if the best available surplus is nonnegative:
\[
Z^g_{ik,t}=\mathbf 1\!\left[\max_{m\in\mathcal M_g}V^m_{ik,t}\geq0\right].
\]
Conversational assistance is valuable when language-specific skill already exists; the delegated mode also uses general ability to specify and verify work.

## Main results — conditions matter

**Weak frontier expansion (Proposition 1).** When \(\mathcal M_1\subseteq\mathcal M_2\), developers can ignore delegation. For the same opportunity realization, \(Z^2_{ik,t}\geq Z^1_{ik,t}\) and therefore \(N^2_{it}\geq N^1_{it}\). This is a *production* result, not proof of acquired language skill.

**Activation band (Proposition 2).** For an **initially unfamiliar language**, the paper's *foothold* assumption prevents conversational assistance from lowering the solo threshold: \(T^1=T^S\) (in particular, \(\gamma s-r_C\leq0\)). Let \(B=T^S-T^D\), where its sign depends on delegation productivity, verification cost, residual risk, and compute cost. **If \(B>0\)**, then \(T^D<T^S\), and
\[
Z^2_{ik,t}-Z^1_{ik,t}
=\mathbf1[T^D_{ik,t}\leq\omega_{ik,t}<T^S_{ik,t}].
\]
For a continuous conditional opportunity CDF \(F\), this band's probability is \(F(T^S)-F(T^D)\). Without the foothold and threshold conditions, the exact band formula need not hold.

**Dynamic accumulation (Proposition 3).** With constant first-use hazards and \(0\leq p^1_{ik}\leq p^2_{ik}\leq1\), for integer \(s\geq0\):
\[
\Delta C_i(s)=\sum_{k\in\mathcal U_i}
[(1-p^1_{ik})^{s+1}-(1-p^2_{ik})^{s+1}]\geq0.
\]
Weak hazard ordering alone **does not** guarantee that the gap grows at every horizon. In the closed-frontier benchmark \(p^1=0\), strict increase and *strict discrete concavity* require \(0<p^2<1\). At \(p^2=1\) the effect equals one immediately and is flat: an endpoint correction identified in our derivation and encoded in Lean.

## Evidence, independent check, and formalization boundary

The paper follows 5,346 developers for 28 months and reports sharp event-time increases in language breadth around detectable Claude Code adoption. **Selection into adoption remains a causal-identification limitation.** Our mathematical critique checks the \(p^2=1\) endpoint; the threshold geometry is not exclusive to AI agents, since another productivity improvement could also lower an entry threshold.

The archived EconCSLib run reports **nine proved algebraic endpoints without `sorry` and a passing fast check** ([record](lean-check.txt)). These do **not** certify exact source-to-`Spec` equivalence or completion of the paper's probabilistic model; source-first semantic review and human sign-off remain open. The unmodified generated status/audit files deliberately retain those limitations.

**Further detail:** [thresholds and activation](extra/02-model-thresholds-and-activation-band.md) · [Proposition 3 derivation](extra/03-proposition-3-dynamics.md) · [citation audit](extra/01-citation-audit.md) · [handwritten work requirements](hand/README.md) · [nine-endpoint Lean crosswalk](docs/LEAN_CROSSWALK_9.md) · [primary-source Proposition 3 audit](docs/SOURCE_AUDIT_PROP3_20261123.md) · [agent provenance audit](docs/AGENT_PROVENANCE_AND_RERUN.md).
