# Apéndice A.7 — aprendizaje después de delegación: auditoría de ecuaciones (28)–(29)

**Fecha:** 2026-11-24, Lima. **Fuente primaria:** [Quispe y Xu (2026), arXiv 2605.25438v2, apéndice A.7](https://arxiv.org/html/2605.25438v2). **Extensión Lean:** [`extensions/AppendixA7BayesianLearning.lean`](../extensions/AppendixA7BayesianLearning.lean). No modifica los archivos de `lean/` generados por EconCSLib. **Estado de compilación — VERIFICADO EN LEAN:** [GitHub Actions #45331830830](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45331830830) **PASS** (8,322 jobs, 40 teoremas inspeccionados sin `sorryAx` ni `unsafeAx`, paper check `--fast` exitoso). [Artefacto de la ejecución](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45331830830/artifacts/14892850522).

## 1. Inventario matemático en la fuente

El artículo considera una productividad por lengua desconocida \(\theta_{ik}\) y observaciones \(x_\ell=\theta_{ik}+\varepsilon_\ell\) con \(\varepsilon_\ell\sim N(0,\sigma_\ell^2)\), **independientes condicionalmente en \(\theta\)**, para \(\ell=1,\ldots,L\) (ecuación 28). El prior Normal tiene media \(\mu\) y precisión \(\pi\), y las precisiones individuales de las señales son \(w_\ell=1/\sigma_\ell^2\), con \(\sigma_\ell^2>0\). Denotando \(q=\sum_\ell w_\ell\) y \(z=\sum_\ell w_\ell x_\ell\), la suma de cuadrados en el exponente de la posterior es

\[
\pi(\theta-\mu)^2+\sum_\ell w_\ell(x_\ell-\theta)^2
=(\pi+q)\theta^2-2(\pi\mu+z)\theta+
\pi\mu^2+\sum_\ell w_\ell x_\ell^2.
\]

Al completar cuadrados (y usar que la posterior es Normal dado el modelo conjugado), los parámetros actualizados son

\[
\pi'=\pi+q,\qquad
\mu'=\frac{\pi\mu+z}{\pi+q}
=\frac{\pi\mu+q\bar x_q}{\pi+q},
\quad \bar x_q=\frac{z}{q}\quad(q>0).
\]

La forma que usa \(\bar x_q\) requiere **\(q>0\)**. Con **cero señales**, \(q=0\), la regla directa \(\mu'=(\pi\mu+z)/(\pi+q)\) sigue siendo válida con \(\pi>0\), pero el promedio de señales \(\bar x_q\) no tiene interpretación.

**Señal económica:** precisión no disminuye y **aumenta estrictamente si hay al menos una señal de varianza finita y positiva**. La media posterior **no** es necesariamente mayor que la anterior: evidencia desfavorable puede disminuirla. El texto de la fuente utiliza este mecanismo para explicar persistencia, no para garantizar mejora de productividad de cada lengua.

## 2. Pruebas exactas añadidas y alcance

| Teorema Lean | Hecho matemático |
| --- | --- |
| `bayesA7_signal_precision_nonneg` | \(q\ge0\) si todas las varianzas señaladas son positivas |
| `bayesA7_signal_precision_pos_of_witness` | \(q>0\) si existe una observación en el conjunto y todas tienen varianza positiva |
| `bayesA7_posterior_precision_ge` | \(\pi'\ge\pi\) por \(q\ge0\) |
| `bayesA7_posterior_precision_gt` | \(\pi'>\pi\) si hay al menos una observación válida |
| `bayesA7_posterior_mean_eq_source` | Coinciden la media calculada con \(z\) y la forma \((\pi\mu+q\bar x_q)/(\pi+q)\) bajo denominadores positivos |
| `bayesA7_normal_kernel_quadratic` | Coeficientes de \(\theta^2,\theta\) y término constante al expandir la suma de cuadrados del kernel de la fuente |
| `bayesA7_weighted_mean_below_prior_of_signal_below` | Si la media de señales no supera el prior y los pesos son no negativos, la nueva media no supera el prior |

**El significado es algebraico**: aun si las siete pruebas compilan, no se habrá formalizado una ley Normal, su mgf, una densidad de posterior ni la igualdad de dos medidas por conjugación Bayesiana. Para cerrar el argumento estocástico se requiere especificar el prior, el espacio de señales, las medidas condicionales, independencia, actualización por Bayes y demostrar la equivalencia de la posterior construida con la Normal de parámetros \((\mu',1/\pi')\).

## 3. Compuertas de seguridad de las afirmaciones

- **Aprobación Lean — COMPLETA:** el runner [#45331830830](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45331830830) compiló `QX26AgenticDelegation.AppendixA7BayesianLearning` junto con 33 resultados anteriores (**8,322 jobs**), inspeccionó siete nuevos `#print axioms` y los 33 previos (**40**, sin `sorryAx` ni `unsafeAx`) y terminó `check --fast` exitosamente. Esto acredita los enunciados algebraicos, no la conjugación Normal–Normal como igualdad de medidas.
- **Correspondencia semántica:** no elevar la fila A.7 a “formalización Bayesiana completa” solo por álgebra del exponente.
- **Fuente y alcance:** ecuaciones 28 y 29 del HTML v2 consultado; sin reclamar transcripción byte-pinned de las líneas TeX ni aprobación v11 de EconCSLib.
- **Proveniencia:** las nuevas pruebas son mejoras posteriores de esta conversación y se publican como `extensions/` separadas. No se presentan como artefactos recuperados de la sesión histórica del agente.

El procedimiento de compilación es **solo GitHub Actions, sin Codex ni API de modelos**.
