# Auditoría primaria y parcial de la Proposición 3 — Quispe y Xu (2026)

**Fecha:** 2026-11-23. **Fuente efectivamente leída:** [arXiv:2605.25438v2, HTML](https://arxiv.org/html/2605.25438v2), sección **4.3** (Proposición 3, ecuación 10), y apéndice **A.6** (ecuaciones 24–27). La versión HTML muestra una fecha de renderización distinta de la portada del PDF; para la bibliografía de la entrega se mantiene identificada la versión **v2**, no se extrapola la fecha HTML a la fecha de envío a arXiv. Este documento es una **auditoría humana independiente y acotada** de una proposición, no la revisión fuente–\`Spec\` formal de EconCSLib ni una aprobación de toda la obra.

## 1. Inventario desde la fuente antes de leer el código

La proposición contiene cuatro objetos matemáticos relevantes:

1. **Dominio probabilístico:** \`p^g_ik\` es el hazard constante de primer uso, por lo que \`0 ≤ p^g_ik ≤ 1\`; se consideran horizontes discretos \`s≥0\`.
2. **Efecto acumulado y orden de hazards:** \`p2_ik≥p1_ik\` implica \`ΔC_i(s) = Σ_k[(1-p1_ik)^(s+1)−(1-p2_ik)^(s+1)] ≥ 0\` (ecuación 10).
3. **Condición de no alcance (no-catch-up):** la diferencia entre horizontes es no negativa **si y solo si** la suma de diferencias de hazards ponderadas por supervivencia es no negativa (apéndice A.6, ecuaciones 26–27). Ordenar hazards \`p2≥p1\` **no** basta para garantizar crecimiento del gap agregado a todos los horizontes.
4. **Benchmark cerrado:** el texto enuncia \`p1=0<p2\` y afirma crecimiento estricto y concavidad. El apéndice evalúa \`p2(1-p2)^(s+1)>0\` y \`-(p2)^2(1-p2)^(s+1)<0\` **sin excluir expresamente \`p2=1\`**.

## 2. Contradicción en el extremo y reparación mínima

Para un lenguaje con frontera cerrada, \`p1=0\`, sea

\[
d(s)=1-(1-p)^{s+1},\qquad 0\leq p\leq1.
\]

Entonces

\[
d(s+1)-d(s)=p(1-p)^{s+1},
\qquad
\Delta^2d(s)=-p^2(1-p)^{s+1}.
\]

- Si \`0<p<1\`, el primer incremento es **positivo** y la segunda diferencia es **negativa** para todo \`s≥0\`.
- Si \`p=1\`, \`d(s)=1\` para todo \`s≥0\`. Ambas diferencias son exactamente \`0\`; el efecto es **débilmente** creciente y **débilmente** cóncavo, pero **no estrictamente** creciente ni estrictamente cóncavo.
- Si \`p=0\`, \`d(s)=0\` para todo \`s≥0\`. El supuesto \`p1=0<p2\` del paper ya excluye este último caso.

**Corrección mínima:** al sostener crecimiento y concavidad estrictos en el benchmark, requerir \`0<p2<1\`, no solo \`p2>0\`.

La demostración independiente del autor está preservada en [\`hand/Prop_3_manoscrito_original.pdf\`](../hand/Prop_3_manoscrito_original.pdf), siete páginas. No se sustituyó la evidencia por una transcripción tipográfica.

## 3. Comparación con el código Lean realmente publicado

| Afirmación fuente | Declaración en \`lean/PaperInterface.lean\` | Estado del puente |
| --- | --- | --- |
| Ecuación (10): suma no negativa | \`cumulative_effect_nonnegSpec\` | Codifica suma finita, \`0≤p1≤p2≤1\` y la desigualdad. \`ProofInterface.lean\` cierra la desigualdad algebraica; no representa explícitamente el proceso estocástico de primeras adopciones |
| Identidad primera diferencia, ecuación (26) | \`cumulative_gap_first_differenceSpec\` | Codifica la igualdad algebraica unilenguaje, probada con \`ring\` |
| Condición general no-catch-up, ecuación (27) | No hay un \`Spec\` distinto que pruebe la equivalencia general para todas las lenguas | La identidad por sí sola no demuestra crecimiento sin \`p1=0\` ni condiciones adicionales |
| Estrictez en benchmark cerrado | \`cumulative_effect_strict_mono_closedFrontierSpec\` y \`cumulative_effect_strict_concave_closedFrontierSpec\` | Sus binders añaden **\`0<p2<1\`**. Es una **reparación de dominio** respecto del texto de la Proposición 3 |
| Extremo incluido \`p2=1\` | \`cumulative_effect_endpoint_flatSpec\` | Prueba el contraejemplo de igualdad de horizontes; no es una proposición original nombrada sino resultado de auditoría |

Los teoremas correspondientes aparecen en \`lean/ProofInterface.lean\`; el registro local [\`lean-check.txt\`](../lean-check.txt) declara un \`check --fast\` exitoso, no una revisión semántica concluida.

## 4. Límites del informe

**COMPROBADO DESDE LA FUENTE:** el enunciado original, el paso de la prueba que falla en \`p2=1\`, la corrección de la hipótesis y el carácter condicional de las metas Lean comparadas.

**NO COMPROBADO AQUÍ:** fuente LaTeX byte-pinned accesible a todos los auditores; el cierre completo de las proposiciones 1, 2, 4 y 5; el estado de los archivos de auditoría generados; la equivalencia de todo el paper y su formalización; el uso de \`gpt-5.6-sol\`/\`xhigh\`.

**Próximo control sustantivo:** una auditoría fuente-first de todos los resultados, usando el material TeX/versión pinned de EconCSLib. **No modificar** \`lean/status.json\` o \`lean/audit/\` de forma manual para presentar como aprobadas comprobaciones que no se han realizado.

## Referencias comprobables

- [Quispe & Xu (2026), arXiv v2 HTML, §4.3 y §A.6](https://arxiv.org/html/2605.25438v2)
- [Especificaciones Lean (capturadas en este repositorio)](../lean/PaperInterface.lean)
- [Pruebas Lean (capturadas en este repositorio)](../lean/ProofInterface.lean)
