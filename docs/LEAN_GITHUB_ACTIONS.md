# Verificación de Lean en GitHub Actions — sin API ni Codex

**Fecha:** 2026-11-23. **Objeto:** reproducir la compilación y las pruebas algebraicas del trabajo Quispe y Xu (2026), como en IE project. **No necesita `OPENAI_API_KEY` ni una cuenta de API.**

## Cadena de trabajo

1. En esta conversación, el asistente analiza el artículo, revisa la lógica matemática y escribe/corrige los archivos `.lean`.
2. Los cambios se incorporan a una rama del repositorio semanal y quedan trazados por commit y PR.
3. El workflow [`lean-verify.yml`](../.github/workflows/lean-verify.yml) se ejecuta en **GitHub Actions**, descarga una revisión fija de la biblioteca Lean, reconstruye temporalmente el módulo desde `lean/`, compila **pruebas**, inspecciona axiomas y ejecuta el chequeo rápido exigido.
4. Cuando una prueba falla, se revisa el log verdadero del runner, se cambia el código y se vuelve a ejecutar Actions. **Nunca** se afirma que pasó una prueba antes del resultado verde real.

No se utiliza Codex, una CLI de agente generativo ni una API de modelos para compilar. Lean, Lake, Mathlib y los scripts de EconCSLib/AppliedModelingLib son las herramientas de verificación.

## Ejecuciones verificadas

| Run | Código | Resultado |
| --- | --- | --- |
| [Actions #45234775082](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45234775082) | Nueve teoremas del archivo original `lean/ProofInterface.lean` | **PASS:** 8,316 jobs compilados, `#print axioms` sin `sorryAx`, `check ... --fast` PASS |
| [Actions #45235387712](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45235387712) | Nueve teoremas originales + dos resultados adicionales en `extensions/Prop3NoCatchUp.lean` | **PASS:** 8,317 jobs compilados, once endpoints inspeccionados sin `sorryAx`, `check ... --fast` PASS |
| [Actions #45245835608](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45245835608) | Los once resultados previos + nueve identidades y teoremas de [Prop2ThresholdBridge.lean](../extensions/Prop2ThresholdBridge.lean) | **PASS:** 8,318 jobs compilados, 20 endpoints sin `sorryAx`, `check ... --fast` PASS |
| [Actions #45283067690](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45283067690) | Los 20 resultados previos + cuatro teoremas con ley condicional suministrada en [Prop4ExpectedExpansion.lean](../extensions/Prop4ExpectedExpansion.lean) | **PASS:** 8,319 jobs, 24 endpoints inspeccionados sin `sorryAx`, `check ... --fast` PASS |
| [Actions #45288831429](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45288831429) | Los 24 anteriores + cuatro teoremas en [Prop5RepositoryExpectation.lean](../extensions/Prop5RepositoryExpectation.lean), incluyendo estrictez bajo masa positiva | **PASS:** 8,320 jobs, 28 endpoints sin `sorryAx`, `check ... --fast` PASS |

El workflow emplea `leanprover/lean4:v4.30.0-rc2` y la revisión `nikhgarg/AppliedModelingLib@194edcc95df74806a39b961d10dedddc6e730cce`, fijada para permitir reproducibilidad. El archivo `lean/` original permanece intacto; la extensión se copia a la carpeta temporal de compilación.

**Evidencia descargable:** [artefacto actualizado con 28 teoremas](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45288831429/artifacts/14873163272).

## Diferencia entre compilación y equivalencia económica

- **DEMOSTRADO EN LEAN:** **28 endpoints** (nueve de EconCSLib original y diecinueve de extensiones separadas: dos no-catch-up, nueve del puente de Proposición 2, cuatro de Proposición 4 y cuatro de Proposición 5, todos bajo sus supuestos explícitos). Ni los tipos Lean ni el CI construyen una distribución condicional no especificada, ni derivan los costes de entrada de los repositorios desde las primitivas.
- **VERIFICADO COMO PROCESO:** los imports y compilación con herramienta fija, `check --fast` y la inspección de axiomas.
- **PENDIENTE:** revisión independiente completa de si cada `Spec` corresponde exactamente a todo el contenido probabilístico y económico de las proposiciones del artículo.
- **PENDIENTE POR REQUISITO DOCENTE:** la entrega original exigía que el agente generador fuera GPT-5.6 Sol/`xhigh`. La compilación Lean no depende de esa elección, pero tampoco acredita qué modelo escribió el código de 2026-09-04. El commit original declara colaboración con Claude Opus 4.8.

## Corrección de rumbo respecto a la API

Se había propuesto un workflow separado para invocar GPT-6 por API. La ejecución histórica [#45235012269](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45235012269) no llamó a ningún modelo porque faltaba un secreto. **Esa vía era innecesaria para el objetivo actual y se retiró del PR.** El registro histórico permanece en Actions, pero no es una tarea pendiente ni se requiere configurar ninguna clave.

**Procedimiento vigente:** ChatGPT GPT-6 para análisis y redacción, GitHub Actions para ejecutar y verificar Lean. No se requieren claves de OpenAI API.
