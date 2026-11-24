# A.7 — Construcción de una probabilidad conjunta para productividad y señales gaussianas

**Revisión:** 2026-11-24, Lima. **Fuente:** Quispe y Xu (2026), [arXiv 2605.25438v2, apéndice A.7](https://arxiv.org/html/2605.25438v2); [TeX original fijado con hashes SHA-256](PRIMARY_SOURCE_PIN_20261124.md), particularmente `sections/10_appendix.tex`. **Extensión:** [`extensions/AppendixA7JointGaussianSignals.lean`](../extensions/AppendixA7JointGaussianSignals.lean). **Estado:** comprobar el resultado final de GitHub Actions antes de declarar que las seis nuevas pruebas están verificadas.

## 1. Modelo probabilístico construido, no meramente supuesto

Para un número finito \(n\) de señales, se define un espacio de resultados

\[
\mathcal W=\mathbb R^{\{\varnothing\}\cup\{1,\dots,n\}},
\qquad \omega=(\theta,\varepsilon_1,\ldots,\varepsilon_n).
\]

El índice `none` representa \(\theta\); cada `some k` representa \(\varepsilon_k\). Para \(\pi>0\) y \(v_k>0\), el modelo de la fuente exige

\[
\theta\sim N(\mu,1/\pi), \qquad
\varepsilon_k\sim N(0,v_k),\qquad
\theta,\varepsilon_1,\ldots,\varepsilon_n \text{ mutuamente independientes}.
\]

En Lean, `bayesA7JointDrawLaw` se construye como el **producto finito de medidas `gaussianReal` de Mathlib**, no como una hipótesis que afirme la independencia. El resultado `bayesA7_joint_coordinates_independent` utiliza el teorema matemático `ProbabilityTheory.iIndepFun_pi` de Mathlib para demostrarla. Las leyes marginales se deducen de `measurePreserving_eval`. Las señales observadas se definen como

\[
X_k(\omega)=\theta(\omega)+\varepsilon_k(\omega).
\]

El resultado marginal que debe demostrar la extensión es

\[
X_k\sim N\left(\mu,\frac1\pi+v_k\right),
\]

mediante `gaussianReal_add_gaussianReal_of_indepFun`; este último teorema **sí requiere y utiliza** la independencia de \(\theta\) y \(\varepsilon_k\).

**Advertencia económica imprescindible:** los errores \(\varepsilon_k\) son independientes; los resultados \(X_k\) no tienen por qué ser independientes incondicionalmente, ya que todos comparten la productividad latente \(\theta\). La fuente impone independencia de las señales **condicional en \(\theta\)**, la cual es compatible con este diseño, pero comprobar esa condicionalidad como propiedad de un kernel y una desintegración es un resultado aún pendiente.

## 2. Correspondencia exacta de teoremas y compuerta

| Teorema | Afirmación matemática |
| --- | --- |
| `bayesA7_joint_draw_probability` | El producto finito de leyes Normal es una medida de probabilidad |
| `bayesA7_joint_coordinates_independent` | Todas las coordenadas del producto son mutuamente independientes |
| `bayesA7_joint_prior_marginal` | La marginal de \(\theta\) coincide con su Normal previa |
| `bayesA7_joint_noise_marginal` | La marginal de cada \(\varepsilon_k\) es \(N(0,v_k)\) |
| `bayesA7_prior_independent_of_noise` | \(\theta\) es independiente de cada \(\varepsilon_k\) |
| `bayesA7_observed_signal_marginal` | Cada \(X_k=\theta+\varepsilon_k\) es Normal con media \(\mu\) y varianza \(1/\pi+v_k\) |

La medida `gaussianReal` es válida también con varianza cero (en tal caso es Dirac). Para interpretar el modelo como señales no degeneradas del artículo, **se deben imponer adicionalmente** \(\pi>0\) y \(v_k>0\). La definición no convierte valores negativos en varianzas económicas válidas: `Real.toNNReal` los recorta y por eso no se afirma una interpretación para ellos.

**Comprobación exigida:** compilar `QX26AgenticDelegation.AppendixA7JointGaussianSignals`; imprimir los axiomas de los seis teoremas nuevos junto con los 51 previamente verificados; prohibir `sorryAx` y `unsafeAx`; ejecutar `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast`, íntegramente en GitHub Actions. Si no termina en `success`, el incremento de cobertura queda **PENDIENTE**.

## 3. Puente pendiente hacia una posterior condicional

La anterior [demostración de densidad normalizada](APPENDIX_A7_NORMALIZED_DENSITY_20261124.md) ya prueba que, **dados** \(x_1,\ldots,x_n\), la normalización del núcleo previo×verosimilitud produce una medida gaussiana con \(\pi'=\pi+\sum_k 1/v_k\) y media ponderada \(\mu'\). La nueva construcción coloca esos datos dentro de un espacio probabilístico conjunto genuino.

**Aún falta** formalizar el kernel de observación \(\theta\mapsto\mathsf{Law}(X\mid\theta)\), demostrar que las coordenadas de \(X\) son independientes condicionadas a \(\theta\), y que la medida \(\mathsf{Normal}(\mu'(x),1/\pi')\) satisface la identidad de desintegración

\[
\Pr(\theta\in A,\;X\in B)=
\int_B \mathsf{Normal}(\mu'(x),1/\pi')(A)\,\Pr_X(dx),
\]

para todos los conjuntos medibles \(A,B\) pertinentes. Solo esa identidad (o una forma equivalente de esperanza condicional) habilita la frase **«posterior regular condicional formalmente demostrada»**.

**No se altera** la carpeta generada `lean/`, ni sus estados de auditoría `not started`; tampoco se sustituye el recibo fuente→`Spec` v11 de EconCSLib por este resultado matemático. El trabajo se desarrolla con GPT-6 en esta conversación y el código se compila exclusivamente con **GitHub Actions, sin Codex ni API**.


## Registro de primera ejecución y corrección Lean (2026-11-24)

La primera [ejecución #45335578219](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45335578219) **FAIL** (no se reetiqueta como válida): los 51 teoremas anteriores compilaron, pero la extensión falló porque la inferencia de instancias no identificaba la familia `∀ i, IsProbabilityMeasure (bayesA7DrawCoordLaw ... i)` para las medidas coordenadas, y porque `by decide` no puede cerrar una proposición con índice libre `k`.

En el commit [`08446c9`](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/commit/08446c9af27e1072eafbea689b9ac187cb7bd0fc) se añadió una instancia **demostrada** para cada medida gaussiana y se cambió la prueba de desigualdad entre índices `none` y `some k` por `by simp`. No se supuso la independencia como axioma ni se alteraron las hipótesis del artículo. La [segunda corrida #45335958632](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45335958632) debe completar la compilación, los axiomas y el chequeo fast; **no declararla aprobada hasta consultar los logs**.
