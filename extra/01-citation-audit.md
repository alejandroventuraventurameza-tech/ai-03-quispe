# Citation audit and the first model check

## Why this check matters

The course issue deliberately begins with a citation-verification exercise. The earlier working title can tempt a language model to treat a prior version, the current version, or a fabricated paper as the same object. Our repository therefore starts from the bibliographic record before interpreting the economics.

## Verified record

| Field | Verified information |
|---|---|
| Current title | *Agentic Delegation and the Language Frontier of Software Developers: A Model and Evidence from Claude Code on GitHub* |
| Authors | Alexander Quispe and Kevin Xu |
| arXiv identifier | 2605.25438v2 |
| arXiv history | Submitted May 25, 2026; version 2 posted July 7, 2026 |
| Date on the version 2 PDF title page | July 8, 2026 |
| Date shown by the experimental HTML rendering | August 24, 2026; this does not match the versioned PDF |
| Analysis sample | 5,346 developers observed over 28 months |
| Reconstructed activity | About 3.2 million commits and 57 million changed files |

## The discrepancy to show in the presentation

“Coding Beyond Your Training: Claude Code and the Technological Frontier of Software Developers” is not the current title. The version 2 manuscript states that this was an earlier title. The current title changes the emphasis from a broad technological frontier to the specific mechanism of **agentic delegation** and the measured **language-production frontier**.

There is also a source-surface discrepancy in the manuscript date. The arXiv history records version 2 on July 7 and the version 2 PDF is dated July 8, while the experimental HTML rendering displays August 24. We use the versioned PDF for page-level analysis and retain this discrepancy in the audit rather than silently choosing the convenient date.

The honest sequence in this run is also informative: the original Word heading pointed to the wrong authors, the user challenged the identification, and the arXiv record resolved it. We will not fabricate a supposedly pre-verification model answer after having already opened the source.

## Presentation-ready verification slide

**What changed after checking the source?** The assigned paper has two authors, studies 5,346 developers, and makes a narrower claim than the earlier title suggests. It studies whether developers *produce* in more languages after agent adoption; it does not claim that they acquire unassisted language skill, and the empirical design identifies robust event-time associations rather than a settled causal effect.

## Mandatory stress tests to carry through the project

1. **Agent-specific mechanism:** determine whether the threshold result genuinely requires delegated execution or would follow from any sufficiently large productivity shock.
2. **Selection into adoption:** determine what the event study rules out and whether project-driven adoption can still explain frontier expansion.
3. **Endpoint validity:** check each proposition at the endpoints of its parameter domain, especially $\lambda$, $p^1$, $p^2$, ability, and the observed event-time horizon.

These are research questions for later analytical blocks, not conclusions recorded in advance.

## Sources

- [Current arXiv record](https://arxiv.org/abs/2605.25438v2)
- [Current paper in HTML](https://arxiv.org/html/2605.25438v2)
- [Course issue](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/2)
