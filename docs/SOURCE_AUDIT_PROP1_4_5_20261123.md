# Auditoría acotada de fuente a Lean — Proposiciones 1, 4 y 5

**Fecha:** 2026-11-23. **Fuente:** [Quispe y Xu (2026), arXiv:2605.25438v2](https://arxiv.org/html/2605.25438v2), §4.2 y Apéndice A.3, A.5, A.8. **Código revisado:** `lean/PaperInterface.lean`, `lean/ProofInterface.lean`. **Estado:** mapa de requisitos y límites, no un dictamen formal de equivalencia semántica de EconCSLib.

## Proposición 1 — expansión de la frontera

El apéndice A.3, ecuación (21), toma **la inclusión de menús** como premisa: \(\mathcal M_1=\{S,C\}\subseteq\mathcal M_2=\{S,C,D\}\). Por tanto \(V^2=\max\{V^S,V^C,V^D\}\ge V^1=\max\{V^S,V^C\}\), los indicadores de activación no decrecen y \(N^2\ge N^1\) para la misma realización de oportunidades. Hay crecimiento **estricto** cuando existe al menos un lenguaje no activo antes, pero activo al delegar.

- El `frontier_expansionSpec` original es una suma de indicadores bajo la hipótesis **ya dada** \(V^1_k\le V^2_k\); prueba el último paso pero **no construye** \(V^1,V^2\) desde los tres modos.
- El puente separado [`Prop2ThresholdBridge.lean`](../extensions/Prop2ThresholdBridge.lean) construye los tres valores originales y enuncia `menu_surplus_weak_expansion`, que incorpora el paso de máximos de A.3. El registro de compilación de GitHub Actions debe corroborarse antes de afirmar que esa extensión está demostrada.
- **Pendiente:** demostrar a partir de un testigo de nuevo lenguaje que el conteo total aumenta **estrictamente**, no solo débilmente.

## Proposición 4 — especialistas y habilidad general

El apéndice A.5, ecuaciones (22)–(23), requiere **Supuesto 3 (candidatos desconocidos comparables)**: condicionada la habilidad, cada lengua desconocida tiene la misma esperanza de activación \(p_i(a_i,A)\ge0\). Por linealidad, la esperanza del número de activaciones es \(U_i p_i(a_i,A)\). La comparación por habilidad exige adicionalmente que \(p_i(a_i,A)\) aumente en \(a_i\), y la argumentación económica del paper invoca caída de costes y error residual junto con densidad positiva en el umbral.

- `specialist_heterogeneitySpec` representa únicamente la identidad algebraica \(\sum_{k\in U}p=|U|p\).
- **No representa** explícitamente una variable aleatoria \(E_i\), una medida de probabilidad, una esperanza condicional ni la hipótesis de simetría de activaciones. Tampoco demuestra que la reducción de \(\kappa\) y \(\sigma_D^2\) haga \(p_i(a_i,A)\) creciente: es un puente económico adicional.
- La afirmación causal de quién se beneficia más no sigue de la mera identidad \(\sum p=|U|p\); debe condicionarse a los supuestos de la fuente.
- **Pendiente:** definición probabilística y formalización explícita de la igualdad de esperanzas condicionales antes de marcar como completo el resultado original.

## Proposición 5 — acceso a repositorios

El apéndice A.8 sostiene que cada repositorio necesita al menos un lenguaje. Si la delegación reduce débilmente el coste de entrar para el lenguaje requerido, \(c_r(\ell,2)\le c_r(\ell,1)\), entonces, fijada la oportunidad \(\Omega_r\), cada indicador de participación crece débilmente. La expectativa del total de repositorios también crece; el crecimiento **estricto** necesita masa positiva de repositorios/oportunidades dentro de la banda.

- `repository_expansionSpec` codifica correctamente la comparación **puntual** \(\sum_r\mathbf1[\Omega_r\ge c^1_r]\le\sum_r\mathbf1[\Omega_r\ge c^2_r]\), dado el orden de costes.
- **No codifica** la distribución de las oportunidades ni la expectativa de conteos ni la condición de masa positiva para estrictez.
- **Pendiente:** construir el puente probabilístico del valor esperado y un teorema de estrictez bajo una hipótesis explícita de probabilidad positiva. No confundir el indicador de que una oportunidad particular cae en la banda con la existencia de masa positiva en una distribución.

## Compromisos para el cierre científico

1. Preservar literalmente `lean/` y sus reportes de EconCSLib. Las pruebas nuevas se introducen por separado en `extensions/` y se compilan solo en un checkout temporal de GitHub Actions.
2. Mantener condiciones, cuantificadores y variables de la fuente original, y señalar cuándo se añade un supuesto o se sustituye una conclusión económica por una identidad algebraica más estrecha.
3. Distinguir **DEMOSTRADO EN LEAN** (tipos exactos compilados y axiomas revisados), **MATEMÁTICAMENTE DERIVADO** (prueba aún no compilada), y **PENDIENTE** (CDF, CARA-normal, condicionalidad, derivadas y validez causal). Un workflow verde no cierra automáticamente estos puentes.
4. Tras verificar la Proposición 2, priorizar los puentes probables de Proposición 4 (esperanzas) y Proposición 5 (estrictez con masa positiva) sin etiquetar como formalizado el modelo completo.


## Actualización verificada — Proposición 4, 2026-11-23

La [extensión de esperanza condicional](../extensions/Prop4ExpectedExpansion.lean) se integró **sin alterar `lean/`**. [GitHub Actions #45283067690](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45283067690) **PASS**: cuatro nuevos teoremas y **24 endpoints** totales inspeccionados sin `sorryAx`. El teorema `prop4_conditional_expected_expansion` introduce una **familia dada de leyes** `conditionalLaw a U`, normalización probabilística, integrabilidad y simetría de las medias de activación, y demuestra la igualdad de esperanzas para el conjunto fijo de candidatos. Las hipótesis de `0 ≤ p`, `0 < p` y monotonía de `p` con habilidad se registran separadamente para los resultados débiles/estrictos. **Sigue pendiente** obtener esa familia condicional y el signo de `p` desde las primitivas estocásticas del artículo, construir indicadores 0/1 y la correspondencia semántica integral del paper. La sección histórica anterior describe la brecha original; este addendum acredita solo la parte resuelta.


## Actualización verificada — Proposición 5, 2026-11-23

La [extensión de repositorios](../extensions/Prop5RepositoryExpectation.lean) formaliza el **conteo puntual** y sus expectativas con una distribución μ común, condiciones de integrabilidad y orden de costes. Demuestra crecimiento **estricto** de la expectativa cuando existe un repositorio cuyo evento (c_r^2\le\Omega_r<c_r^1) tiene probabilidad positiva. [GitHub Actions #45288831429](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45288831429) **PASS**, 8,320 jobs, 28 resultados inspeccionados sin `sorryAx`, `check --fast` exitoso. Queda pendiente derivar el orden de costes de repositorios desde las decisiones de producción por lenguaje y auditar íntegramente la correspondencia probabilística de la fuente. [Informe Prop. 5](SOURCE_AUDIT_PROP5_20261123.md).
