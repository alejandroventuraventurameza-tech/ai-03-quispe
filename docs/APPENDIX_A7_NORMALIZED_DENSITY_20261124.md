# Apéndice A.7 — densidad bayesiana normalizada para señales observadas

**Fecha:** 2026-11-24. **Fuente:** Quispe y Xu (2026), arXiv:2605.25438v2, apéndice A.7, ecuaciones (28)–(29). **TeX original fijado:** [`PRIMARY_SOURCE_PIN_20261124.md`](PRIMARY_SOURCE_PIN_20261124.md), SHA-256 `sections/10_appendix.tex` = `9b6ec306138f1105c42d2d19737cf93e4233c7c77a10dced0aba640dc8f1472c`. **Extensión separada:** [`AppendixA7NormalizedPosteriorDensity.lean`](../extensions/AppendixA7NormalizedPosteriorDensity.lean). **Verificación — DEMOSTRADO EN LEAN:** [GitHub Actions #45334600598](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45334600598) **PASS** en el commit `91e73d56b8777223fedc6c5acb029614bbf4daf0`: **8,324 tareas compiladas**, **51 teoremas inspeccionados** sin `sorryAx` ni `unsafeAx`, cero advertencias en el módulo nuevo, y `paper_contribution.py check ... --fast` **PASS** (**8,315 tareas**). [Artefacto con registros de compilación y axiomas](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45334600598/artifacts/14893796724).

## 1. Núcleo, media, precisión y normalización

Para \(\pi>0\), \(v_\ell>0\), prior \(N(\mu,1/\pi)\) y señales \(x_\ell\) con errores gaussianos independientes condicionales, la parte del producto densidad previa × verosimilitud que depende de la productividad \(\theta\) es

\[
K_x(\theta)=\exp\!\left[-\frac12 \left(
\pi(\theta-\mu)^2+\sum_{\ell\in L}\frac{(x_\ell-\theta)^2}{v_\ell}
\right)\right].
\]

Con \(P=\pi+\sum_{\ell}1/v_\ell>0\), \(m=(\pi\mu+\sum_{\ell}x_\ell/v_\ell)/P\), y \(C=\pi\mu^2+\sum_\ell x_\ell^2/v_\ell-Pm^2\), la extensión anterior ya demostró \(K_x(\theta)=e^{-C/2}e^{-P(\theta-m)^2/2}\).

La densidad explícitamente normalizada que se verifica es

\[
f_x(\theta)=\frac{\sqrt{P/(2\pi)}}{e^{-C/2}}K_x(\theta)
=\frac{1}{\sqrt{2\pi/P}}\exp[-P(\theta-m)^2/2].
\]

La nueva extensión aborda en Lean (a) la positividad del factor \(e^{-C/2}\), (b) la forma normalizada, (c) la **igualdad punto a punto con `ProbabilityTheory.gaussianPDFReal` de Mathlib**, (d) \(\int_{\mathbb R} f_x(\theta)\,d\theta=1\) y (e) la igualdad de la medida \(\mathrm{volume.withDensity}(\mathrm{ENNReal.ofReal}\circ f_x)\) con la gaussiana candidata construida anteriormente.

No se introducen axiomas nuevos para «suponer» que integra 1: se usa el resultado matemático ya demostrado por Mathlib para densidades gaussianas, después de probar que ambas funciones son idénticas.

## 2. Qué es y qué no es una posterior demostrada

**Sí demostraría, si compila:** para **cada vector de datos observado y fijo**, la densidad construida normalizando el núcleo previo × verosimilitud es una densidad gaussiana y define exactamente la medida Normal con media \(m\), varianza \(1/P\).

**Todavía no demuestra:** una construcción conjunta de las variables aleatorias \(\theta,X_1,\ldots,X_L\), la independencia condicional de las señales como propiedad de esa distribución conjunta, ni la igualdad \(\mathrm{Law}(\theta\mid X=x)=\mathrm{Gaussian}(m(x),1/P)\) como **desintegración o esperanza condicional** del modelo. Para cerrar esa última igualdad se requiere el modelo conjunto con medidas normales y una versión rigurosa de Bayes/desintegración.

**No es un resultado causal** sobre adopción de Claude Code ni un teorema de identificación empírica. Tampoco reemplaza el recibo `source→Spec` v11 de EconCSLib ni corrige los estados internos `not started`.

## 3. Compuerta de calidad

- [x] Compilar `QX26AgenticDelegation.AppendixA7NormalizedPosteriorDensity` en [GitHub Actions #45334600598](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45334600598), **PASS**.
- [x] Inspeccionar `#print axioms` de **cinco** resultados nuevos y los **46** previos (51 resultados en total), sin `sorryAx` ni `unsafeAx`.
- [x] Superar `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast` en la misma corrida.
- [x] Preservar `lean/` sin ediciones en esta ronda y documentar el commit compilado y el artefacto del runner.

Se ejecuta **únicamente con GitHub Actions**, sin Codex ni llamadas a API de modelos.
