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
| [Actions #45291226305](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45291226305) | Los 28 anteriores + cinco teoremas en [Prop1StrictFrontier.lean](../extensions/Prop1StrictFrontier.lean), con testigo de activación y banda | **PASS:** 8,321 jobs, 33 endpoints sin `sorryAx` ni `unsafeAx`, `check ... --fast` PASS |
| [Actions #45331830830](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45331830830) | Los 33 anteriores + siete teoremas algebraicos de [AppendixA7BayesianLearning.lean](../extensions/AppendixA7BayesianLearning.lean), ecuaciones 28–29 | **PASS:** 8,322 jobs, 40 endpoints sin `sorryAx` ni `unsafeAx`, `check ... --fast` PASS |
| [Actions #45333297951](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45333297951) | Los 40 anteriores + seis resultados sobre núcleo Normal y ley gaussiana candidata en [AppendixA7GaussianKernelBridge.lean](../extensions/AppendixA7GaussianKernelBridge.lean) | **PASS:** 8,323 jobs, 46 endpoints sin `sorryAx`/`unsafeAx`, `check ... --fast` PASS y sin advertencias del módulo nuevo |
| [Actions #45334600598](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45334600598) | Los 46 anteriores + cinco teoremas sobre densidad bayesiana normalizada, integral unidad y medida construida en [AppendixA7NormalizedPosteriorDensity.lean](../extensions/AppendixA7NormalizedPosteriorDensity.lean) | **PASS:** 8,324 jobs, **51 endpoints** sin `sorryAx`/`unsafeAx`, `check ... --fast` PASS, sin advertencias del módulo nuevo |
| [Actions #45335958632](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45335958632) | Los 51 anteriores + seis demostraciones de probabilidad conjunta, independencia y marginales de [AppendixA7JointGaussianSignals.lean](../extensions/AppendixA7JointGaussianSignals.lean); la primera corrida fallida [#45335578219](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45335578219) y su corrección están documentadas | **PASS:** 8,325 jobs, **57 endpoints** sin `sorryAx`/`unsafeAx`, `check ... --fast` PASS, sin advertencias del módulo nuevo |
| [Actions #45337236049](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337236049) | Los 57 anteriores + nueve demostraciones sobre el kernel condicional y las señales normales de [AppendixA7SignalKernel.lean](../extensions/AppendixA7SignalKernel.lean); primer fallo de táctica [#45336887383](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45336887383) registrado | **PASS:** 8,326 jobs, **66 endpoints** sin `sorryAx`/`unsafeAx`, `check ... --fast` PASS, sin advertencias del nuevo módulo |
| [Actions #45337734090](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337734090) | Los 66 anteriores + cuatro teoremas de posterior Markov, desintegración, recuperación del prior y unicidad a.e. en [AppendixA7PosteriorDisintegration.lean](../extensions/AppendixA7PosteriorDisintegration.lean) | **PASS:** 8,327 jobs, **70 endpoints** sin `sorryAx`/`unsafeAx`, `check ... --fast` PASS, sin advertencias del módulo nuevo |

El workflow emplea `leanprover/lean4:v4.30.0-rc2` y la revisión `nikhgarg/AppliedModelingLib@194edcc95df74806a39b961d10dedddc6e730cce`, fijada para permitir reproducibilidad. El archivo `lean/` original permanece intacto; la extensión se copia a la carpeta temporal de compilación.

**Evidencia descargable:** [artefacto actualizado con 70 teoremas](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45337734090/artifacts/14894586957).

## Diferencia entre compilación y equivalencia económica

- **DEMOSTRADO EN LEAN:** **70 endpoints** (nueve originales y sesenta y uno en extensiones separadas: Props. 1–5 y treinta y siete resultados del aprendizaje bayesiano A.7, incluidos el kernel de señales y **cuatro resultados del posterior regular/desintegración**). **PENDIENTE:** equivalencia a.e. de la posterior construida con la Normal explícita de los autores, cotejo con la medida de muestreo original, inventario semántico v11 y procedencia auténtica del agente. Un CI verde no sustituye esas obligaciones ni deriva los costes de repositorios desde las primitivas.
- **VERIFICADO COMO PROCESO:** los imports y compilación con herramienta fija, `check --fast` y la inspección de axiomas.
- **PENDIENTE:** revisión independiente completa de si cada `Spec` corresponde exactamente a todo el contenido probabilístico y económico de las proposiciones del artículo.
- **PENDIENTE POR REQUISITO DOCENTE:** la entrega original exigía que el agente generador fuera GPT-5.6 Sol/`xhigh`. La compilación Lean no depende de esa elección, pero tampoco acredita qué modelo escribió el código de 2026-09-04. El commit original declara colaboración con Claude Opus 4.8.

## Corrección de rumbo respecto a la API

Se había propuesto un workflow separado para invocar GPT-6 por API. La ejecución histórica [#45235012269](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45235012269) no llamó a ningún modelo porque faltaba un secreto. **Esa vía era innecesaria para el objetivo actual y se retiró del PR.** El registro histórico permanece en Actions, pero no es una tarea pendiente ni se requiere configurar ninguna clave.

**Procedimiento vigente:** ChatGPT GPT-6 para análisis y redacción, GitHub Actions para ejecutar y verificar Lean. No se requieren claves de OpenAI API.

## Actualización — pruebas reproducidas el 24 de noviembre de 2026

| [Actions #45445246319](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45445246319) | [Caso sin señales](../extensions/AppendixA7ZeroSignalPosterior.lean): prior, posterior explícito y posterior desintegrado coinciden casi seguramente cuando no hay observaciones | **PASS:** 8,332 compilaciones, 86 declaraciones auditadas, `check --fast` PASS |
| [Actions #45446009562](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45446009562) | [Identidad integral de evidencia gaussiana](../extensions/AppendixA7PredictiveEvidenceIntegral.lean) para cualquier colección finita de señales | **PASS:** 8,333 compilaciones, 88 declaraciones auditadas, `check --fast` PASS (8,315 tareas) |

Los módulos corresponden a **extensiones separadas**, no a modificaciones de la carpeta original `lean/`. El pipeline verifica tipos y axiomas declarados; no garantiza aún equivalencia semántica fuente–Spec ni reemplaza los registros auténticos del modelo agente.

## Ampliación de densidad conjunta escalar — 94 declaraciones (24 noviembre 2026)

| Ejecución | Objeto | Resultado |
| --- | --- | --- |
| [#45455461266](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45455461266) | Kernel escalar de señal obtenido del modelo `Fin 1`, representación `Kernel.withDensity` y ley conjunta respecto de prior × Lebesgue | **PASS:** 8,334 tareas, 92 declaraciones auditadas |
| [#45457640213](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45457640213) | Prior gaussiano como densidad y ley conjunta en Lebesgue² con densidad producto `pdf_prior · pdf_signal` | **PASS:** 8,335 tareas, 94 declaraciones auditadas y EconCSLib `check --fast` PASS (8,315 tareas) |

El módulo de la segunda fila tuvo dos intentos previos fallidos por referencias de nombres de Mathlib y forma de la función de densidad; se corrigió sin alterar la conclusión matemática ni introducir axiomas. **Estas pruebas no completan la identificación de la posterior para todo `n>0`**.

## Puente escalar de evidencia y marginal — ejecución de 99 declaraciones

| CI | Prueba y objeto | Resultado |
| --- | --- | --- |
| [#45485098502](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45485098502) | Densidad conjunta gaussiana auténtica = factor de evidencia × densidad candidata posterior para una señal | **PASS:** 8,336 tareas, 97 declaraciones sin axiomas no admitidos |
| [#45486549728](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45486549728) | Tonelli: segunda marginal de densidad conjunta y aplicación a la señal original | **PASS:** 8,337 tareas, **99** declaraciones; `check --fast` PASS (8,315 tareas) |

**Compuerta faltante:** identificación de la integral marginal real con la evidencia normalizada `ENNReal.ofReal` y desintegración gaussiana explícita en la ley conjunta para `n > 0`. Las pruebas ya compiladas no presuponen esta igualdad ni cambian la procedencia de la generación original.
