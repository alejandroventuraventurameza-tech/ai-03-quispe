# Auditoría semántica independiente, fila por fila — nueve Specs originales

**Fecha de auditoría:** 2026-11-24 (Lima). **Artículo:** [Quispe y Xu, *Agentic Delegation and the Language Frontier of Software Developers*, arXiv:2605.25438v2](https://arxiv.org/html/2605.25438v2). **Versión efectivamente inspeccionada:** arXiv HTML v2, apartados 4.1–4.3, A.1–A.8. **El cotejo original partió del HTML v2; posteriormente se añadió el tar TeX v2 byte-pinned (SHA-256 citado en el apartado de anclajes).** El digest autentica bytes de fuente, no la equivalencia de los teoremas.

**Snapshot previo del repositorio:** `0886ba27db789feeb54f4caa0c1aa4c0ea2d6fa9`. **Interfaces originales:** `lean/PaperInterface.lean` (blob `d3eba7c986e79576512bbd69e1b88e84d21c2150`), `lean/ProofInterface.lean` (blob `e9823c5d3771ef4bd7710fd6e7124ff557c5d466`). **Comprobación independiente de los tipos Lean existentes:** [GitHub Actions #45291226305](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45291226305), compilación de 8,321 jobs, 33 inspecciones de axiomas sin `sorryAx` ni `unsafeAx`, paper check `--fast` exitoso. Esa corrida certifica **teoremas con sus hipótesis escritas**, no la equivalencia económica de sus nueve firmas.

## Clave de clasificación

- **ALGEBRAICAMENTE ACREDITADO:** enunciado Lean preciso y comprobado; no implica el modelo generador de sus variables.
- **PARCIAL RESPECTO A LA FUENTE:** fórmula correcta para una parte del argumento, pero falta un supuesto, construcción, cuantificador o conclusión del artículo.
- **REPARACIÓN CONDICIONAL:** el artículo usa un dominio excesivo y se ha demostrado una conclusión bajo una hipótesis adicional matemáticamente necesaria.
- **CONTRAEJEMPLO DE AUDITORÍA:** resultado verdadero, **no** una proposición enunciada como tal por los autores.

## Nueve comparaciones concretas

### 1. `frontier_expansionSpec` — Proposición 1, §4.2, A.3, ecuación (21)

- **Fuente:** el menú \(\{S,C\}\) está contenido en \(\{S,C,D\}\); se construye \(V^1_k=\max(V^S_k,V^C_k)\), \(V^2_k=\max(V^S_k,V^C_k,V^D_k)\) y se prueba \(\sum_k Z^1_k\le\sum_k Z^2_k\) para cada oportunidad.
- **Lean original:** para un conjunto finito \(K\), funciones reales arbitrarias \(V1,V2\), asume *directamente* \(\forall k\in K,\;V1(k)\le V2(k)\) y demuestra monotonía de sumas de indicadores.
- **Veredicto:** **PARCIAL**. La desigualdad puntual es un resultado válido, pero el `Spec` por sí solo no demuestra la inclusión del menú ni el origen económico de \(V1,V2\).
- **Extensión compilada:** [`Prop1StrictFrontier.lean`](../extensions/Prop1StrictFrontier.lean) construye los tres excedentes y demuestra el corolario estricto **con testigo**. La estrictez no es parte incondicional de la Proposición 1.

### 2. `activation_bandSpec` — Proposición 2, §4.2, A.4, ecuación (8)

- **Fuente:** para una lengua desconocida, el supuesto foothold implica \(T^1=T^S\); la condición \(B=T^S-T^D>0\) da \(T^D<T^S\), \(T^2=T^D\) y la identidad de indicadores. La ecuación (9) requiere además una distribución de oportunidades para obtener probabilidades/expectativas.
- **Lean original:** asume solo \(T^D\le T^S\) y prueba algebraicamente la identidad del intervalo semiabierto.
- **Veredicto:** **PARCIAL**. El `Spec` ofrece una identidad correcta incluso con umbrales iguales, pero no contiene foothold, expresión de \(B\), minimización entre modos ni CDF condicional.
- **Extensión compilada:** [`Prop2ThresholdBridge.lean`](../extensions/Prop2ThresholdBridge.lean) conecta primitivas, \(B>0\), umbrales y banda. **Permanece pendiente** la probabilidad del intervalo bajo un \(F\) construido/aprobado.

### 3. `cumulative_effect_nonnegSpec` — Proposición 3, §4.3, A.6, ecuación (10)

- **Fuente:** hazards condicionales de primer uso constantes en el horizonte; la supervivencia es \((1-p^g_k)^{s+1}\), y bajo \(p^2_k\ge p^1_k\) la suma de brechas de supervivencia es no negativa.
- **Lean original:** demuestra exactamente la desigualdad de una suma finita de potencias bajo \(0\le p^1_k\le p^2_k\le1\), para \(s\in\mathbb N\).
- **Veredicto:** **ALGEBRAICAMENTE ACREDITADO, MODELO PROBABILÍSTICO PARCIAL**. No construye los tiempos aleatorios de primer uso ni demuestra la supervivencia desde la ley condicional de transición.

### 4. `cumulative_gap_first_differenceSpec` — Apéndice A.6, ecuaciones (26)–(27)

- **Fuente:** la primera diferencia temporal de la brecha unilenguaje iguala la diferencia de hazards ponderados por supervivencia; al sumar sobre lenguajes se obtiene la condición necesaria y suficiente de *no-catch-up*.
- **Lean original:** prueba la igualdad unilenguaje para reales arbitrarios y horizonte natural, incluso fuera del dominio económico \([0,1]\).
- **Veredicto:** **ALGEBRAICAMENTE ACREDITADO, PARCIAL** respecto al criterio agregado (27).
- **Extensión compilada:** [`Prop3NoCatchUp.lean`](../extensions/Prop3NoCatchUp.lean) acredita ambas direcciones de la condición agregada en un conjunto finito.

### 5. `cumulative_effect_strict_mono_closedFrontierSpec` — Proposición 3, A.6, benchmark cerrado

- **Fuente:** afirma crecimiento estricto cuando \(p^1=0<p^2\), sin excluir explícitamente el extremo \(p^2=1\).
- **Lean original:** prueba el **resultado unilenguaje** bajo \(0<p^2<1\), para horizontes naturales.
- **Veredicto:** **REPARACIÓN CONDICIONAL NECESARIA**, no transcripción literal del dominio original. En \(p^2=1\), \(d(s)\equiv1\) para todo \(s\ge0\), por lo que la primera diferencia es 0. El paso de una lengua a un total requiere sumar y justificar al menos una contribución estricta.

### 6. `cumulative_effect_strict_concave_closedFrontierSpec` — Proposición 3, A.6, segunda diferencia

- **Fuente:** asegura concavidad estricta de la trayectoria acumulada del benchmark; el argumento usa \(- (p^2)^2(1-p^2)^{s+1}<0\).
- **Lean original:** prueba concavidad **discreta de una lengua** bajo \(0<p^2<1\).
- **Veredicto:** **REPARACIÓN CONDICIONAL NECESARIA**. En \(p^2=1\) la segunda diferencia vale 0. No se debe llamar a este resultado diferenciabilidad/concavidad continua, ni atribuirlo sin condiciones al agregado heterogéneo.

### 7. `cumulative_effect_endpoint_flatSpec` — contraejemplo al extremo de Proposición 3

- **Fuente:** no lo presenta como teorema nombrado; surge de auditar la afirmación estricta y su prueba.
- **Lean original:** demuestra para todo \(s\in\mathbb N\) que \(d(s)=1\) y \(d(s+1)=d(s)\) bajo \(p^1=0,p^2=1\).
- **Veredicto:** **CONTRAEJEMPLO DE AUDITORÍA**, no una proposición económica adicional de los autores. Refuta estrictamente crecimiento/concavidad estrictos en el extremo, sin refutar los resultados débiles.

### 8. `specialist_heterogeneitySpec` — Proposición 4, A.5, ecuaciones (22)–(23)

- **Fuente:** con candidatos desconocidos comparables, \(\mathbb E[E_i\mid a_i,U_i]=U_i p_i(a_i,A)\), donde \(E_i\) suma incrementos aleatorios de activación. Se enuncian predicciones de especialización y habilidad condicionadas a supuestos.
- **Lean original:** demuestra únicamente \(\sum_{k\in U}p=|U|p\) para reales arbitrarios; no hay variable aleatoria, esperanza ni condicionamiento.
- **Veredicto:** **PARCIAL SUSTANTIVO**. No corresponde íntegramente a la conclusión probabilística de la proposición.
- **Extensión compilada:** [`Prop4ExpectedExpansion.lean`](../extensions/Prop4ExpectedExpansion.lean) demuestra linealidad **dada una familia de leyes condicionales**, integrabilidad y medias comparables. Siguen pendientes la construcción de esa ley desde una distribución conjunta y la deducción del signo del efecto de habilidad desde las primitivas.

### 9. `repository_expansionSpec` — Proposición 5, A.8

- **Fuente:** orden débil de costes de entrada a repositorios implica mayor **participación esperada** y crecimiento estricto bajo masa positiva de oportunidades que cambian la decisión.
- **Lean original:** prueba solo la comparación de **conteos deterministas** de indicadores, dada una oportunidad fija y \(c^2_r\le c^1_r\) para cada repositorio.
- **Veredicto:** **PARCIAL SUSTANTIVO**. El `Spec` no contiene la medida, integración, hipótesis de masa positiva ni la relación de costes con lenguajes requeridos.
- **Extensión compilada:** [`Prop5RepositoryExpectation.lean`](../extensions/Prop5RepositoryExpectation.lean) integra conteos y deriva crecimiento estricto **si una banda tiene masa positiva**, pero recibe los costes como insumo; no los endogeneiza desde la tecnología de lenguajes.

## Decisión documentada y límites

- **9/9 declaraciones originales compilan con prueba Lean y sin `sorryAx`.** Sus pruebas son válidas dentro de los tipos escritos.
- **No son 9/9 equivalencias semánticas completas.** Las filas 1, 2, 3, 4, 8 y 9 requieren al menos un puente respecto a la fuente; las filas 5 y 6 corrigen el dominio del artículo; la fila 7 es un contraejemplo adicional, no un teorema fuente.
- **Inventario de extensiones actualizado:** [Actions #45446009562](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45446009562) verificó **88 declaraciones** con sus tipos Lean, sin `sorryAx` ni `unsafeAx` y con `check --fast` PASS. Incluye los nueve endpoints originales y **79 declaraciones adicionales** de las extensiones. Están demostrados el kernel condicional, la ley conjunta que reproduce el experimento original, la desintegración regular, la candidata gaussiana con densidad normalizada, la igualdad con la posterior regular **para `n=0`** y la integral exacta del factor de evidencia para toda colección finita. Este avance no prueba todavía la identificación posterior a.e. para `n>0` ni repara por sí mismo las equivalencias semánticas de las nueve Specs.
- **A.7, aprendizaje bayesiano:** las ecuaciones (28)–(29) de fuente están ausentes de los nueve `Spec` originales. Ya se construyeron y verificaron por separado la [distribución conjunta original](../extensions/AppendixA7ObservedJointBridge.lean), la [posterior regular y su desintegración](../extensions/AppendixA7PosteriorDisintegration.lean), la [candidata gaussiana medible](../extensions/AppendixA7ExplicitGaussianKernel.lean), la [identificación exacta sin señales](../extensions/AppendixA7ZeroSignalPosterior.lean) y el [factor de evidencia](../extensions/AppendixA7PredictiveEvidenceIntegral.lean). **Queda pendiente el puente de densidad/medida marginal y la identificación casi segura para `n>0`.**

**Compuerta formal todavía NO SUPERADA:** el generado [`lean/status.json`](../lean/status.json) sigue diciendo `not started`, [`lean/audit/source_proof_fidelity.json`](../lean/audit/source_proof_fidelity.json) sigue en `not_started`, y [`lean/audit/paper_statement_map.json`](../lean/audit/paper_statement_map.json) sigue indicando `source_curated: false`. No se han alterado esos registros manualmente ni se ha firmado una conformidad semántica final. Un cotejo humano con HTML v2 y código comprometido **no sustituye** un inventario source-byte-pinned ni el recibo de correspondencia v11 exigido por EconCSLib.

## Fuentes y verificaciones

- [Artículo v2, sección 4.2, proposiciones 1–2](https://arxiv.org/html/2605.25438v2#S4.SS2)
- [Artículo v2, sección 4.3, proposición 3](https://arxiv.org/html/2605.25438v2#S4.SS3)
- [Artículo v2, apéndice de teoría A](https://arxiv.org/html/2605.25438v2#A1)
- [Especificaciones originales](../lean/PaperInterface.lean) y [sus nueve pruebas](../lean/ProofInterface.lean)
- [GitHub Actions #45337734090 — 70 teoremas](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337734090)

## Anclajes originales auditados en archivos TeX (Actions, 2026-11-24)

El cotejo ahora cuenta con un [manifiesto fuente byte-pinned](PRIMARY_SOURCE_PIN_20261124.md) y un [recibo automatizado de nueve filas](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333392245/artifacts/14892364260). GitHub Actions recuperó el tar v2 (**SHA-256 `1b3e7968697bcb306f7c96fbdb60e93d8c49eb805afb15ce00271084da24a296`**), identificó 26 archivos TeX y comprobó los siguientes `\label` **reales**: P1 línea 156, P2 línea 166, P3 línea 283 en `sections/03_theory.tex`; P4 línea 139 y P5 línea 252 en `sections/10_appendix.tex`. La identidad auxiliar de P3 y el contraejemplo no se presentan como teoremas con etiquetas originales. **La herramienta no certifica equivalencia semántica; esta matriz conserva los veredictos de alcance parcial y dominio corregido indicados anteriormente.**

## Precisión del recibo v11 y estado académico

Esta auditoría de los **nueve Specs originales** es una comprobación humana fuente ↔ código: describe qué significa cada fórmula, las hipótesis omitidas, las condiciones añadidas y las diferencias de dominio. No transforma automáticamente los ficheros generados `lean/status.json` o `lean/audit/source_proof_fidelity.json` en estados aprobados. Esos archivos se preservan como procedencia original, con estado de revisión inicial; no deben retocarse para forzar un «aprobado».

**Distinción de acreditación:** 88 declaraciones Lean compiladas y auditadas ≠ nueve `Spec` integralmente equivalentes a las proposiciones del artículo. Para resolver la compuerta semántica completa se necesita una nueva evaluación v11 transparente sobre una generación original auténtica, con comprobación de hipótesis, cuantificadores y conclusiones —y, si la consigna lo exige, aprobación docente de la sustitución declarada por GPT-6/XHIGH en la fase posterior, sin reatribuir el commit original de Claude.

## Extensión posterior a la auditoría: 94 declaraciones compiladas

La corrida [#45457640213](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45457640213) amplía el inventario a **94 declaraciones verificadas**, incluidas seis pruebas nuevas de [densidad del kernel escalar](../extensions/AppendixA7ScalarLikelihoodDensity.lean) y [ley conjunta gaussiana en Lebesgue²](../extensions/AppendixA7ScalarJointLebesgueDensity.lean). El cotejo fuente↔Spec de las **nueve interfaces originales** conserva sus veredictos independientes: las pruebas adicionales no equivalen a certificar los nueve enunciados económicos completos. La identidad de desintegración explícita para el caso general `n>0` sigue pendiente, al igual que la aprobación de una sustitución del modelo de agente exigido en la consigna.

## Extensiones bayesianas posteriores: 99 declaraciones comprobadas

En [Actions #45486549728](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45486549728) se han auditado **99** declaraciones Lean compiladas (nueve originales más **90** declaraciones de extensiones), incluyendo una factorización gaussiana auténtica con una señal y [un teorema de Tonelli aplicado a la ley marginal observada](../extensions/AppendixA7ScalarObservedMarginal.lean). Son pruebas adicionales separadas de la equivalencia semántica de las nueve especificaciones originales. Los veredictos de alcance parcial, reparación condicional y contraejemplo de esta auditoría permanecen válidos y no se elevan automáticamente a nueve equivalencias fuente–Spec completas.
