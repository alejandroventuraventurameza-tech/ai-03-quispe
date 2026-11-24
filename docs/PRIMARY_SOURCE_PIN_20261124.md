# Fuente primaria verificable y fijación de bytes — arXiv:2605.25438v2

**Fecha UTC del último control:** 2026-11-24. **Solo GitHub Actions; ninguna API de modelos ni Codex.**

## Descarga original y hashes auditables

La ejecución [GitHub Actions #45333083356](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333083356) ejecutó `source-pin.yml` sobre el commit `bc4831908b2aaaa588bf6e820f301193cee47bfa`. Descargó las fuentes de arXiv **v2** y calculó las huellas SHA-256 de los bytes recibidos. Se intentó leer el archivo fuente como tar sin extraerlo al filesystem.

| Objeto descargado / archivo en el tar | Tamaño (bytes) | SHA-256 |
|---|---:|---|
| [HTML v2](https://arxiv.org/html/2605.25438v2) | 569,361 | `a0745ad646bbaae09bebf60f83f01b4ba8d903d5b2fdfe14efacae4abda03202` |
| [Archivo fuente v2](https://arxiv.org/src/2605.25438v2) | 358,685 | `1b3e7968697bcb306f7c96fbdb60e93d8c49eb805afb15ce00271084da24a296` |
| `sections/03_theory.tex` dentro del tar | 13,905 | `19292a132f536d5a20019618a5ccf6260f6a81af3520e43993e96aa88fdd3b7a` |
| `sections/10_appendix.tex` dentro del tar | 19,107 | `9b6ec306138f1105c42d2d19737cf93e4233c7c77a10dced0aba640dc8f1472c` |

La lectura de tar confirmó **46 entradas, 26 archivos .tex/.ltx** y coincidencias textuales relevantes para A.7 en `sections/02_related_literature.tex`, `sections/03_theory.tex` y `sections/10_appendix.tex`.

[Artefacto real de GitHub Actions: manifiesto de fuente y SHA-256 por archivo TeX](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333083356/artifacts/14891694658).

## Qué certifica este nuevo control

- **VERIFICADO:** procedencia de versión declarada (URL arXiv v2), integridad de bytes del HTML/tar efectivamente recuperados, capacidad de enumerar y hashear todos los miembros TeX del tar sin extraerlos, localización de miembros relevantes a A.7.
- **NO VERIFICADO TODAVÍA:** reconstrucción de un inventario de cada átomo matemático desde spans precisos del TeX, enlace automático de cada átomo a un `Spec` expandido, y recibo semántico de cierre **v11** de EconCSLib.
- **NO ALTERAR:** `lean/status.json`, `lean/audit/source_proof_fidelity.json` y `lean/audit/paper_statement_map.json` no deben marcarse como completos a partir de hashes o compilaciones.
- La evidencia en este repositorio es **solo el manifiesto**, sin incorporar una copia completa del artículo al historial de Git.

## Reproducción

Se puede volver a ejecutar [`.github/workflows/source-pin.yml`](../.github/workflows/source-pin.yml) mediante GitHub Actions. Repetir la descarga del HTML puede cambiar su hash por regeneración del portal; eso indica diferencias de bytes de la representación HTML, **no** necesariamente una nueva versión científica del artículo. El hash del tar v2 permite fijar el archivo fuente exacto para cotejo posterior.

Este control es compatible con la auditoría independiente [de las nueve especificaciones Lean](SEMANTIC_AUDIT_NINE_SPECS_20261124.md), pero no la transforma en aprobación formal por parte del motor.

## Anclajes de proposiciones en el TeX exacto — validados por Actions

La [corrida #45333392245](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333392245) ejecutó [`scripts/source_span_audit.py`](../scripts/source_span_audit.py) sobre el mismo archivo tar v2 y las declaraciones textuales de `lean/PaperInterface.lean`. Registró **9 filas** y las siguientes etiquetas fuente efectivamente encontradas:

| Propósito | TeX y posición del `\label` | Observación |
|---|---|---|
| Frontera, P1 | `sections/03_theory.tex:156` (`prop:frontier`) | Enunciado principal débil |
| Banda de activación, P2 | `sections/03_theory.tex:166` (`prop:band`) | La probabilidad exige un puente adicional de CDF |
| Dinámica, P3 | `sections/03_theory.tex:283` (`prop:dynamic`) | Las dos filas de estrictez comparten la etiqueta, pero corrigen el dominio |
| Heterogeneidad, P4 | `sections/10_appendix.tex:139` (`prop:specialist`) | El `Spec` original no incluye una esperanza condicional |
| Repositorios, P5 | `sections/10_appendix.tex:252` (`prop:repos`) | El `Spec` original solo incluye indicadores puntuales |

La identidad auxiliar de la primera diferencia (A.6) y el contraejemplo de frontera en P3 no tienen un identificador fuente único; la herramienta los registra respectivamente como `paper_equation_no_unique_label` y `reviewer_counterexample_not_source_theorem`. **No se inventan etiquetas.** El recibo tiene hashes de líneas de las declaraciones textuales de los nueve `Spec` y de los TeX relevantes. [Artefacto descargable](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333392245/artifacts/14892364260).

**Límite:** enlazar bytes, nombres y líneas no equivale a verificar que las premisas y conclusiones de los `Spec` elaborados reflejen todas las afirmaciones económicas y probabilísticas originales; el recibo se rotula `NOT_semantic_v11_receipt`.
