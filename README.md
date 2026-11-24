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

The nine original Lean endpoints and 73 separately audited extension declarations—including threshold results, Gaussian prior/noise sampling, the conditional-signal kernel, a regular posterior with disintegration, and an explicitly constructed precision-weighted Gaussian **candidate** Markov kernel—[compiled and passed a source-scoped fast check in GitHub Actions](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45443996146) (**8,331 build jobs**, **82 axiom-audited declarations** without `sorryAx` or `unsafeAx`; paper `check --fast` PASS). The joint observed-signal law has been proved equivalent to the original independent-noise sampling law. A further Lean-checked algebraic result factors the Gaussian-height-normalized prior–likelihood expression into an observation-only evidence factor and the normalized candidate posterior density; this **pointwise** result does not establish the remaining disintegration identity. However, the posterior candidate has **not** yet been proved equal almost everywhere to the regular conditional posterior of that joint law; full EconCSLib source-to-`Spec` equivalence also remains open. Generated `lean/` status/audit outputs remain unchanged.

## AI assistance and provenance disclosure (24 November 2026)

Later reviews and Lean extensions were conducted with **ChatGPT GPT-6**. The author reports **XHIGH reasoning effort** for this work; the XHIGH setting has not been authenticated here by exported agent/session configuration. The author describes GPT-6 as a superior successor to the model requested in the assignment; we record that as the **author's description**, not a validated equivalence with the exact course requirement.

The historical original-module commit [b10f831](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/commit/b10f831ab68159882f69c9c0fe93b824a3869fe9) credits **Claude Opus 4.8**. We do not retrospectively attribute that original run to GPT-6, and the professor's explicit `gpt-5.6-sol` / `xhigh` requirement should be considered **not formally substituted without approval**. See [agent provenance and model disclosure](docs/AGENT_PROVENANCE_AND_RERUN.md) and the [evidence-based closeout ledger](docs/CLOSEOUT_DECISION_20261124.md).

**Further detail:** [thresholds and activation](extra/02-model-thresholds-and-activation-band.md) · [Proposition 3 derivation](extra/03-proposition-3-dynamics.md) · [citation audit](extra/01-citation-audit.md) · [handwritten work requirements](hand/README.md) · [nine-endpoint Lean crosswalk](docs/LEAN_CROSSWALK_9.md) · [primary-source Proposition 3 audit](docs/SOURCE_AUDIT_PROP3_20261123.md) · [agent provenance audit](docs/AGENT_PROVENANCE_AND_RERUN.md) · [Actions reproduction](docs/LEAN_GITHUB_ACTIONS.md) · [economic-threshold bridge audit](docs/SOURCE_AUDIT_PROP2_20261123.md) · [conditional-expectation audit](docs/SOURCE_AUDIT_PROP4_20261123.md) · [repository-expansion audit](docs/SOURCE_AUDIT_PROP5_20261123.md) · [Proposition 1 strict-witness audit](docs/SOURCE_AUDIT_PROP1_20261123.md) · [consolidated source-to-Lean coverage](docs/SOURCE_TO_LEAN_CONSOLIDATED_20261123.md) · [nine-Spec semantic audit](docs/SEMANTIC_AUDIT_NINE_SPECS_20261124.md) · [Appendix A.7 Bayesian learning audit](docs/APPENDIX_A7_BAYESIAN_20261124.md) · [Gaussian posterior-kernel bridge](docs/APPENDIX_A7_GAUSSIAN_KERNEL_20261124.md) · [normalized Bayes-density equality](docs/APPENDIX_A7_NORMALIZED_DENSITY_20261124.md) · [joint Gaussian prior/noise model](docs/APPENDIX_A7_JOINT_GAUSSIAN_20261124.md) · [Gaussian conditional signal kernel](docs/APPENDIX_A7_SIGNAL_KERNEL_20261124.md) · [posterior disintegration audit (Lean verified)](docs/APPENDIX_A7_POSTERIOR_DISINTEGRATION_20261124.md) · [arXiv v2 byte-pinned TeX source](docs/PRIMARY_SOURCE_PIN_20261124.md).
