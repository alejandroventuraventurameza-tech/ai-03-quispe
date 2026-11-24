# Repository 3 — Quispe & Xu (2026)

**Reference.** Quispe, A., and K. Xu (2026), *Agentic Delegation and the Language Frontier of Software Developers: A Model and Evidence from Claude Code on GitHub*, [arXiv:2605.25438v2](https://arxiv.org/abs/2605.25438v2). The assigned pre-verification title, *Coding Beyond Your Training*, is not the paper's actual title; see the [citation audit](extra/01-citation-audit.md).

**Submission.** [Course Issue #2](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/2) · [Slides (TeX)](presentation.tex) / [PDF](presentation.pdf) · [Original handwritten derivation](hand/Prop_3_manoscrito_original.pdf) · [Raw prompt excerpts](prompts.md) · [Generated EconCSLib folder](lean/) · [Verification and compliance ledger](docs/CLOSEOUT_DECISION_20261124.md).

## Economic question and developer's problem

Can agentic delegation expand the **production frontier** to programming languages in which developers lack prior expertise? Developer \(i\), language \(k\), and month \(t\) have mode-dependent certainty-equivalent surplus \(V^m_{ik,t}\). Before delegation, \(\mathcal M_1=\{S,C\}\) contains solo and conversational production; afterwards \(\mathcal M_2=\{S,C,D\}\) also allows delegation. A language is active when
\[
Z^g_{ik,t}=\mathbf 1\!\left[\max_{m\in\mathcal M_g}V^m_{ik,t}\geq0\right].
\]
Conversation depends on existing language-specific ability; delegation also uses general ability to specify and verify work. Frontier expansion is **production**, not necessarily acquired skill.

## Main results, with their conditions

1. **Weak frontier expansion (Proposition 1).** For the same realization of opportunities, menu inclusion \(\mathcal M_1\subseteq\mathcal M_2\) and the option not to delegate imply \(Z^2_{ik,t}\geq Z^1_{ik,t}\) and \(N^2_{it}\geq N^1_{it}\). Strict expansion requires at least one newly feasible language, not merely menu inclusion.

2. **Activation band (Proposition 2).** For an initially unfamiliar language, the **foothold condition** makes the pre-agent entry threshold equal the solo threshold, \(T^1=T^S\) (in particular, \(\gamma s-r_C\leq0\)). Define the delegation advantage \(B=T^S-T^D\). Only if \(B>0\), so that \(T^D<T^S\), does the exact activation band follow:
\[
Z^2_{ik,t}-Z^1_{ik,t}
=\mathbf1[T^D_{ik,t}\leq\omega_{ik,t}<T^S_{ik,t}].
\]
With a continuous conditional CDF \(F\), its probability is \(F(T^S)-F(T^D)\). Lowering a threshold is not a mechanism exclusive to AI agents.

3. **First-use accumulation (Proposition 3).** With constant first-use hazards and \(0\leq p^1_{ik}\leq p^2_{ik}\leq1\), for integer \(s\geq0\),
\[
\Delta C_i(s)=\sum_{k\in\mathcal U_i}
\left[(1-p^1_{ik})^{s+1}-(1-p^2_{ik})^{s+1}\right]\geq0.
\]
This does **not** imply that the gap increases at every horizon. In the closed-frontier case \(p^1=0\), strict growth and strict discrete concavity require \(0<p^2<1\). At \(p^2=1\) the effect immediately equals one and is flat, as shown by the [handwritten proof](hand/REVISION_MANUSCRITA_2026-11-23.md).

## Evidence, Lean, and limits

The paper studies 5,346 developers over 28 months; the adoption event study does not by itself resolve selection into adoption. [CI #45486549728](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45486549728) compiled **99 Lean declarations** (nine generated endpoints and 90 audited extensions), with no `sorryAx` or `unsafeAx` in the axiom audit, and passed the EconCSLib paper-scoped fast check. The generated `lean/` subtree and its unfinished status/audit artifacts remain intact. Extensions prove the true scalar observation marginal by Tonelli, but **do not** identify the explicit Gaussian candidate with the regular conditional posterior for positive numbers of signals. Full source-to-nine-`Spec` semantic equivalence is **not established**: see the [nine-Spec audit](docs/SEMANTIC_AUDIT_NINE_SPECS_20261124.md).

**Provenance disclaimer.** Later reviews/extensions used **GPT-6**; **XHIGH** is author-declared, not independently authenticated by an exported session setting. A historical original-module commit credits Claude Opus 4.8. Neither fact proves an original `gpt-5.6-sol`/`xhigh` run. The author reports that the model substitution has been resolved with the instructor. An [author-supplied 1,107-line Claude Cowork transcript](context-transcript.md) is now archived, but its tool actions are summarized and model/session configuration is unavailable; this is not an authenticated native Claude Code execution log. This is an **audited partial submission, not full academic compliance**; see [provenance](docs/AGENT_PROVENANCE_AND_RERUN.md) and [closeout decision](docs/CLOSEOUT_DECISION_20261124.md).