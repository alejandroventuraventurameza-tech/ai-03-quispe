# Apéndice A.7 — posterior regular condicional por desintegración

**Fecha:** 2026-11-24. **Fuente de economía:** Quispe y Xu, arXiv:2605.25438v2, Apéndice A.7, ecuaciones 28–29; [fijación del TeX original](PRIMARY_SOURCE_PIN_20261124.md). **Biblioteca formal:** Mathlib, `Mathlib.Probability.Kernel.Posterior` de la revisión identificada por el `lake-manifest.json` del upstream fijado. **Extensión:** [`AppendixA7PosteriorDisintegration.lean`](../extensions/AppendixA7PosteriorDisintegration.lean). **Estado — DEMOSTRADO EN LEAN:** [GitHub Actions #45337734090](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337734090) **PASS**, en el commit `27ce83545f0f4447b363c291f7cf271dbd98ccc3`: **8,327 tareas compiladas**, **70 teoremas** inspeccionados sin `sorryAx` ni `unsafeAx`, `paper_contribution.py check ... --fast` **PASS** (**8,315 tareas**), sin advertencias del módulo nuevo. [Artefacto de evidencias](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337734090/artifacts/14894586957).

## 1. Qué se construye

La [extensión anterior](APPENDIX_A7_SIGNAL_KERNEL_20261124.md) definió un kernel Markov \(Q_\theta=\operatorname{Law}(X\mid\theta)\) del vector de señales, con ley condicional \(\bigotimes_k N(\theta,v_k)\). El [prior gaussiano](APPENDIX_A7_JOINT_GAUSSIAN_20261124.md) es una medida \(\mu=N(\mu_0,1/\pi)\). La nueva extensión construye directamente la **ley conjunta por composición de medida y kernel**

\[
M(d\theta,dx)=\mu(d\theta)\,Q_\theta(dx).
\]

Para un espacio latente estándar de Borel, Mathlib suministra el posterior formal \(\kappa^\dagger_\mu\) de un kernel finito \(\kappa\) respecto de una medida finita \(\mu\). Se usa la construcción `ProbabilityTheory.posterior` con \(\kappa=Q\). Su propiedad definitoria es la identidad de desintegración

\[
\underbrace{(\mu\circ Q)}_{\text{distribución de }X}(dx)\,
\underbrace{P_x(d\theta)}_{\text{posterior regular}}
=
\underbrace{M(d\theta,dx)}_{\text{ley conjunta}}\text{ con factores intercambiados}.
\]

Esto es una igualdad exacta entre medidas sobre el producto, no solo una equivalencia de formas cuadráticas ni una asignación de nombre a una distribución Normal.

## 2. Cuatro resultados nuevos

| Teorema Lean | Resultado |
| --- | --- |
| `bayesA7_posterior_is_markov` | La medida \(P_x\) es una probabilidad para cada vector observado \(x\) |
| `bayesA7_posterior_disintegration` | El posterior satisface la igualdad rigurosa de la medida conjunta con factores intercambiados |
| `bayesA7_posterior_recovers_prior` | Promediar la posterior bajo la marginal de señales recupera el prior |
| `bayesA7_posterior_unique_ae` | Cualquier posterior finito con la misma identidad de desintegración coincide con \(P_x\) para casi todo \(x\) bajo la ley marginal de señales |

El segundo teorema utiliza `ProbabilityTheory.compProd_posterior_eq_map_swap`; el tercero, `posterior_comp_self`; el cuarto, `ae_eq_posterior_of_compProd_eq` de Mathlib. La premisa de kernel finito no es gratuita: está justificada por la propiedad Markov que se comprobó por separado en la extensión del kernel condicional, y por la probabilidad del prior gaussiano.

## 3. Distinción decisiva: existencia vs. identificación de la Normal de la fuente

**Sí cierra, si compila:** existencia y unicidad casi segura de un kernel posterior regular **para el modelo conjunto \(M=\mu\otimes Q\) que acabamos de definir**.

**No cierra aún:** demostrar que el kernel posterior construido por desintegración es igual, para casi todo vector observado, a la gaussiana explícita

\[
P_x\stackrel{?}{=}N\!\left(
\frac{\pi\mu_0+\sum_k x_k/v_k}{\pi+\sum_k1/v_k},
\frac{1}{\pi+\sum_k1/v_k}\right),
\qquad \pi>0,\quad v_k>0.
\]

[La igualdad de densidades normalizadas para datos fijos](APPENDIX_A7_NORMALIZED_DENSITY_20261124.md) ya está demostrada, pero no se ha probado todavía que la gaussiana así definida satisfaga la identidad de desintegración de \(M\). La **unicidad** anterior permitirá concluirlo cuando dispongamos de esa identidad, no antes. Tampoco se ha cotejado en este módulo que \(M\) sea exactamente el transporte del espacio con índice `Option(Fin n)` de [`AppendixA7JointGaussianSignals.lean`](../extensions/AppendixA7JointGaussianSignals.lean).

## 4. Reglas de cierre

**COMPUERTA DE LEAN SUPERADA:** [#45337734090](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337734090) compiló los cuatro endpoints nuevos y los 66 anteriores, inspeccionó **70** declaraciones de teoremas sin `sorryAx` o `unsafeAx` y aprobó `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast`. Se conserva la obligación semántica **PENDIENTE** de demostrar la identidad con la Normal de media ponderada y la correspondencia con el espacio original de productividad más errores.

La carpeta generada `lean/`, las nueve especificaciones fuente-facing originales y los dictámenes v11 de EconCSLib no se editan. Ninguna prueba aquí reemplaza el transcript auténtico del agente histórico. Se compila **exclusivamente en GitHub Actions**, sin Codex ni API de modelos.
