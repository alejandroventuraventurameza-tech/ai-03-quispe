# Auditoría de fuente a Lean — Proposición 5: participación en repositorios

**Revisión:** 2026-11-23. **Fuente primaria:** Quispe y Xu (2026), [arXiv:2605.25438v2, Apéndice A.8](https://arxiv.org/html/2605.25438v2). **Código:** [`extensions/Prop5RepositoryExpectation.lean`](../extensions/Prop5RepositoryExpectation.lean). Esta extensión no modifica los nueve `Spec` originales ni los archivos generados por EconCSLib.

## 1. Fuente: qué se afirma y bajo qué condiciones

El apéndice A.8 introduce un conjunto de repositorios potenciales \(\mathcal R\), un lenguaje requerido \(\ell(r)\) por repositorio, un valor de oportunidad \(\Omega_{ir,t}\) y un coste de entrada por generación \(c_r(\ell(r),g)\). Para el mismo desarrollador, repositorio y oportunidad:

\[
Z_{r}^{g}(\omega)=\mathbf1\{\Omega_r(\omega)\ge c_r^{g}\}.
\]

Cuando la delegación reduce débilmente el coste de entrada, \(c^2_r\le c^1_r\), se tiene \(Z^2_r(\omega)\ge Z^1_r(\omega)\) para toda realización. En consecuencia:

\[
\mathbb E\!\left[\sum_{r\in\mathcal R}Z^2_r\right]
\ge
\mathbb E\!\left[\sum_{r\in\mathcal R}Z^1_r\right].
\]

Para obtener desigualdad **estricta**, no basta con señalar un repositorio cuyo lenguaje sea nuevo. Se requiere un evento de probabilidad positiva que cambie efectivamente la decisión de entrada. Una condición suficiente y verificable es:

\[
\exists r\in\mathcal R:\quad
\Pr_\mu[c_r^2\le\Omega_r<c_r^1]>0.
\]

La diferencia del conteo por realización obedece exactamente a:

\[
\sum_{r\in\mathcal R}\bigl(Z_r^2-Z_r^1\bigr)
=
\sum_{r\in\mathcal R}
\mathbf1\{c_r^2\le\Omega_r<c_r^1\}.
\]

No se requiere independencia entre las oportunidades de distintos repositorios para la comparación de expectativas.

## 2. Correspondencia de las declaraciones Lean

| Nombre | Resultado matemático y alcance |
| --- | --- |
| `repo5Count` | Definición de conteo finito de repositorios accesibles para una realización y umbrales dados |
| `repo5Band` | Indicador de la banda semiabierta \(c_r^2\le\Omega_r<c_r^1\) |
| `prop5_count_gap_eq_band_sum` | Identidad puntual de la diferencia de conteos y la suma de indicadores de bandas |
| `prop5_count_weak` | Monotonía puntual bajo orden de costes |
| `prop5_expected_count_weak` | Monotonía de expectativas bajo la **misma medida de probabilidad** y condiciones de integrabilidad |
| `prop5_expected_count_strict_of_positive_band_mass` | Estrictez si un repositorio tiene **masa positiva medida por \(\mu\)** dentro de su banda |

La prueba de estrictez no introduce una supuesta independencia estadística: construye la diferencia puntual no negativa, verifica que es estrictamente positiva en el evento de masa positiva, demuestra que su soporte tiene medida positiva y aplica el teorema de positividad de la integral a funciones no negativas e integrables.

## 3. Lo que el módulo no demuestra

- El paper afirma que cada repositorio requiere *al menos un lenguaje* y en su prueba selecciona un lenguaje requerido \(\ell(r)\). El módulo reproduce esa **representación de una restricción por repositorio**; no pretende resolver requisitos de varios lenguajes simultáneos o una función de producción más compleja.
- Los costes \(c_r^1,c_r^2\) y su orden se **suponen**, no se derivan aquí de los tres modos de producción ni de la frontera de lenguajes.
- \(\Omega_r\) y la distribución común \(\mu\) son datos; no se construyen a partir de adopción observada, no se demuestra identificación causal ni se reestima el artículo.
- Las condiciones `Integrable` aparecen como hipótesis para la operación de esperanza. Con medibilidad y acotación de indicadores podrían justificarse desde una construcción probabilística mayor, que no es el objetivo de este bridge.
- La condición de masa positiva es **suficiente**, no se afirma que sea necesaria para todos los modelos o universos de repositorios posibles.

## 4. Estado de verificación

**DEMOSTRADO EN LEAN (bajo las hipótesis de medida, integrabilidad y costes)**: [GitHub Actions #45288831429](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45288831429) terminó con `success`. Compiló `Prop5RepositoryExpectation.lean` en **8,320 jobs**, inspeccionó los **28 endpoints** (nueve originales y diecinueve de extensiones), sin `sorryAx` ni `unsafeAx`, y aprobó `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast` (**8,315 jobs**). [Artefacto de trazabilidad](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45288831429/artifacts/14873163272). El [registro de errores y corrección](PROP5_BUILD_JOURNAL.md) conserva la ejecución inicial fallida. Este PASS prueba la condición de masa positiva dentro del **modelo de indicadores definido**, no que los costes de cada repositorio se deriven automáticamente de todas las primitivas del artículo.

La carpeta `lean/` generada por EconCSLib no ha sido alterada. El proceso de compilación usa GitHub Actions, sin Codex ni llamadas de modelos a una API.
