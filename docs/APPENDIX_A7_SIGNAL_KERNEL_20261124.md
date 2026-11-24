# Apéndice A.7 — kernel de señales condicionales a la productividad

**Fecha:** 2026-11-24 (Lima). **Fuente:** Quispe y Xu, arXiv:2605.25438v2, Apéndice A.7, ecuaciones (28)–(29); [manifiesto del TeX original](PRIMARY_SOURCE_PIN_20261124.md). **Módulo:** [`AppendixA7SignalKernel.lean`](../extensions/AppendixA7SignalKernel.lean) — extensión separada que no modifica el directorio `lean/` de EconCSLib.

## 1. Qué cambia respecto de los 57 resultados anteriores

[El módulo conjunto anterior](../extensions/AppendixA7JointGaussianSignals.lean) ya construyó un espacio de probabilidad con una productividad latente y ruidos gaussianos independientes, comprobado en [Actions #45335958632](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45335958632).

El nuevo módulo formaliza la **distribución de todo el vector de señales condicionada al valor de productividad** \(\theta\), a partir de la ley producto de errores \(\varepsilon_k\sim N(0,v_k)\):

\[
Q_\theta
=\operatorname{Law}((\theta+\varepsilon_k)_{k=1}^n)
=\bigotimes_{k=1}^n N(\theta,v_k).
\]

Se crea una función medible \(\Phi(\theta,\varepsilon)=(\theta+\varepsilon_k)_k\) y un verdadero objeto `ProbabilityTheory.Kernel ℝ (Fin n → ℝ)`. Se lo construye mediante el producto de dos kernels —el determinista en \(\theta\) y el constante de los errores— seguido por el transporte de medida a través de \(\Phi\). La propiedad **Markov** significa que \(Q_\theta\) es una medida de probabilidad para cada \(\theta\).

La segunda igualdad usa el teorema matemático de transporte de medidas producto `Measure.pi_map_pi` y la invariancia de la ley Normal por desplazamiento, `gaussianReal_map_const_add`. Se demuestra la independencia de coordenadas **bajo \(Q_\theta\)**; no se afirma la independencia incondicional de las señales.

## 2. Nuevo inventario de declaraciones sujetas a kernel-check

| Resultado Lean | Contenido |
| --- | --- |
| `bayesA7_noise_coordinates_independent` | Los errores independientes forman una familia `iIndepFun` |
| `bayesA7_signal_shift_measurable` | Es medible el desplazamiento \(\varepsilon\mapsto\theta+\varepsilon\) |
| `bayesA7_signal_map_measurable` | Es medible \(\Phi(\theta,\varepsilon)\) |
| `bayesA7_signal_kernel_markov` | El kernel de observaciones es Markov, es decir, probabilístico para cada \(\theta\) |
| `bayesA7_signal_kernel_apply_eq_shifted_noise` | Aplicar el kernel en \(\theta\) coincide con el transporte de la ley de errores desplazados |
| `bayesA7_shifted_noise_eq_gaussian_product` | El transporte de errores independientes produce el producto finito de normales centradas en \(\theta\) |
| `bayesA7_signal_kernel_eq_gaussian_product` | Fórmula exacta \(Q_\theta=\bigotimes_k N(\theta,v_k)\) |
| `bayesA7_signals_independent_given_theta` | Independencia de observaciones bajo cada ley \(Q_\theta\) |
| `bayesA7_conditional_signal_marginal` | Marginal de cada señal bajo \(Q_\theta\) es \(N(\theta,v_k)\) |

Los nueve endpoints son adicionales a los **57 verificados**. La primera corrida [GitHub Actions #45336887383](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45336887383) **FALLÓ** con el diagnóstico de Lean `No goals to be solved` en la prueba de transporte del kernel: `congr 1` ya resolvía la igualdad y las tácticas `funext`/`rfl` eran redundantes. Se corrigió en el [commit `f09e148`](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/commit/f09e148781aa62353529683efa172f1bdf2d9280). La segunda [corrida #45337236049](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337236049) terminó en **PASS**, en el commit `f09e148781aa62353529683efa172f1bdf2d9280`: **8,326 tareas compiladas**, **66 teoremas** inspeccionados mediante `#print axioms` sin `sorryAx`/`unsafeAx`, **sin advertencias del módulo nuevo**, y `paper_contribution.py ... check --fast` aprobado (**8,315 tareas**). [Artefacto real del runner](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337236049/artifacts/14894775972). **DEMOSTRADO EN LEAN bajo las hipótesis exactas**; la demostración de la posterior (P_x) permanece separada.

## 3. Límite probabilístico aún pendiente

La formulación \(\theta\mapsto Q_\theta\) es un **kernel de verosimilitud**. Aunque se compruebe que las observaciones son independientes bajo cada \(Q_\theta\), todavía debe demostrar que este kernel es la distribución condicional de las observaciones bajo la **medida conjunta** de productividad y señales formada al transportar la medida de prior y ruido previamente construida. Y para completar el argumento inverso de Bayes faltará probar que, en ese modelo, el kernel gaussiano posterior explícitamente normalizado en el módulo [`AppendixA7NormalizedPosteriorDensity.lean`](../extensions/AppendixA7NormalizedPosteriorDensity.lean) es una versión de la distribución **de \(\theta\) dado \(X\)**.

La forma rigurosa de cierre es una igualdad de desintegración: para toda pareja de conjuntos medibles \(A,B\),

\[
\Pr(\theta\in A,\ X\in B)
=\int_B P_x(A)\, \Pr_X(dx),
\]

donde \(P_x=N(\mu'(x),1/\pi')\). **El kernel de señales \(Q_\theta\) no es el kernel posterior \(P_x\): tienen direcciones opuestas.** No declarar finalizada la conjugación probabilística solo porque los dos tienen forma gaussiana.

La evidencia generada por Github Actions no sustituye la validación fuente→`Spec` v11 de EconCSLib ni una transcripción auténtica de la sesión histórica del agente. Se compila **solo en GitHub Actions; sin Codex ni llamadas a API de modelos**.
