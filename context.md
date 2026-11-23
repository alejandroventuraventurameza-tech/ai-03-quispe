# context.md — Estado del proyecto (Repository 3: Quispe & Xu 2026)

> Documento de traspaso. Cualquier asistente (ChatGPT, Claude, etc.) debe leer
> esto primero para continuar el trabajo sin repetir pasos ni volver a chocar
> con los obstáculos ya resueltos. Última actualización: 2026-09-04.

## 1. Qué es este proyecto

Tarea del curso **AI and Economic Modeling** (Alexander Quispe), "Repository 3".
Objetivo: tomar el paper **Quispe, A. & Xu, K. (2026), "Agentic Delegation and
the Language Frontier of Software Developers: A Model and Evidence from Claude
Code on GitHub"** (arXiv:2605.25438**v2**) y (a) derivar/auditar su teoría, (b)
hacer una derivación a mano de la Proposición 3, y (c) formalizarla en Lean vía
**EconCSLib**.

Pregunta del paper: ¿el acceso a un agente de IA de código permite a los
desarrolladores trabajar en lenguajes que no habían usado antes, y lo muestran
los registros de GitHub alrededor de la adopción de Claude Code? Respuesta del
modelo: sí, cuando la delegación baja el umbral de entrada de un lenguaje
desconocido (crea una "banda de activación"). El resultado empírico es una
asociación en tiempo-evento, no un efecto causal definitivo.

## 2. El modelo y los resultados formalizados

Fuente exacta: `paper/source/QX26AgenticDelegation-arXiv-v2/sections/03_theory.tex`
y `10_appendix.tex` (SHA-256 del PDF: cddc048711c43022d5fd01b995bfb1114c728c8c879b809b5fdc354a391d3c35).

Tres supuestos nombrados: `foothold` (03_theory.tex:64), `verification`
(03_theory.tex:71), `exchangeable` (10_appendix.tex:130).

Cinco proposiciones nombradas:
- **Prop 1 — Frontier expansion** (03_theory.tex:155): Z²≥Z¹ ⇒ N²≥N¹ punto por punto.
- **Prop 2 — Activation band** (03_theory.tex:165): con B=Tˢ−T^D>0, Z²−Z¹ = 1[T^D≤ω<Tˢ].
- **Prop 3 — Dynamic cumulative-language effect** (03_theory.tex:282): ΔC_i(s)=Σ[(1−p¹)^{s+1}−(1−p²)^{s+1}]≥0; y en el benchmark de frontera cerrada p¹=0<p², "estrictamente creciente y cóncava".
- **Prop 4 — Specialist heterogeneity** (10_appendix.tex:138): E[E_i|a,U]=U_i·p_i.
- **Prop 5 — Repository expansion** (10_appendix.tex:251): expansión monótona de repositorios.

### Aporte intelectual (el hallazgo, corre por todo el repo)
La afirmación de estrictez de la Prop 3 ("p¹=0<p² ⇒ estrictamente creciente y
cóncava") **falla en el extremo incluido p²=1**: ahí d(s)=1−(1−1)^{s+1}=1 para
todo s, o sea plano (el lenguaje entra con certeza en el mes 0). La hipótesis
**corregida** es 0<p²<1. Esto está documentado en `extra/03-proposition-3-dynamics.md`,
`hand/README.md`, y formalizado en Lean como `cumulative_effect_endpoint_flat`.

## 3. Estado actual (checkpoints)

- ✅ **Punto 1 — Módulo oficial de EconCSLib.** `papers/QX26AgenticDelegation`
  andamiado con `paper_contribution.py new` (9 metas del statement-spec, ancladas
  a líneas exactas del TeX). **Los 9 teoremas están probados en Lean 4 / Mathlib,
  sin `sorry`.** `lake build QX26AgenticDelegation.PaperInterface` compila (8315
  jobs) y `paper_contribution.py check --fast` pasa. Enunciados (`...Spec`) en
  `PaperInterface.lean`, pruebas en `ProofInterface.lean`, helper `indicator_mono`
  en `MainTheorems.lean`.
- ✅ **Punto 2 — En el repo de la entrega.** El módulo verificado está copiado
  directamente en `lean/` (25 archivos; se excluyen el PDF fuente y el volcado
  de texto). La comparación SHA-256 contra
  `.work/EconCSLib/papers/QX26AgenticDelegation/` coincide en todos los archivos
  publicables. El contenido original fue incluido en `b10f831` y la ubicación
  final exigida por el issue quedó registrada en `c91237c`.
- ✅ **Punto 3 — Derivación a mano de la Prop 3.** El usuario completó y aprobó
  las dos páginas manuscritas. Están guardadas como
  `hand/prop-3-page-1.jpg` y `hand/prop-3-page-2.jpg`; cubren supervivencia,
  acumulado, Ec. (10), no-negatividad, primera diferencia, crecimiento,
  concavidad y el endpoint $p^2=1$.
- ✅ **Punto 4 — Presentación.** `presentation.tex` contiene una
  portada y 14 diapositivas de contenido para 20 minutos. Incluye la auditoría
  de la cita, el modelo, las tres trampas, la comparación con Aouad--Lykouris--
  Zhong, una lámina exclusiva para cada foto manuscrita y dos diapositivas Lean.
  `presentation.pdf` contiene las 15 páginas, incorpora ambas fotografías y pasó
  la revisión visual completa sin recortes ni superposiciones.
- ✅ **Auditoría semántica independiente.** `lean/docs/AGENT_SOURCE_AUDIT.md`
  revisa las nueve filas contra la fuente y concluye **formalización parcial**:
  las identidades centrales de la Prop. 3 coinciden, la condición estricta fue
  corregida, y las Props. 1, 2, 4 y 5 conservan abstracciones u omisiones
  documentadas. El cierre automático estricto no pudo emitir credencial porque
  el `HEAD` oficial de EcoCSLib falla su propio gate de registro del motor; los
  `audit/*.json` y el visto bueno humano conservan por eso estado pendiente.
- ⬜ **Diferido por el usuario:** abrir el PR a EcoCSLib y la redacción en
  prosa del paper ("la escritura").

### Precisión sobre el alcance Lean

Los nueve endpoints están probados y la revisión semántica independiente ya se
realizó. El veredicto es **parcial**: los `Spec` formalizan núcleos algebraicos
seleccionados, pero no exponen cada cláusula probabilística, de monotonicidad o
de estrictez de las cinco proposiciones impresas. La descripción pública
correcta es: “nueve resultados algebraicos Lean probados, `check --fast`
superado y auditoría fuente--`Spec` con veredicto parcial”. El registro
reproducible está en `lean-check.txt` y el dictamen en
`lean/docs/AGENT_SOURCE_AUDIT.md`.

### Estado externo de la entrega

- El PR #1 de `analysis` a `main` fue fusionado el 2026-09-04 a las 03:56 UTC.
- El enlace del repositorio fue publicado en el issue a las 03:57 UTC.
- En hora de Lima, esos eventos ocurrieron aproximadamente a las 22:56 y
  22:57 del 3 de septiembre, después del plazo publicado de las 22:00. El
  timestamp no puede corregirse retroactivamente.
- El issue exige GPT-5.6 Sol con esfuerzo `xhigh` para la corrida de EconCSLib.
  `prompts.md` ya conserva el arranque recuperable de Codex, el prompt obligatorio
  del issue y la derivación manuscrita guiada. `context-transcript.md` contiene
  la sesión posterior de Claude en formato verbatim (26 bloques USER y 26
  ASSISTANT, con las salidas de terminal pegadas). El archivo declara
  `Model/configuration: unavailable`, por lo que no acredita el uso de
  GPT-5.6 Sol con esfuerzo `xhigh`; esa limitación sigue abierta.

## 4. Estructura del repo / archivos clave

- `README.md` — resumen del paper y del resultado principal (con el math).
- `extra/01-citation-audit.md` — auditoría de la cita/fuente.
- `extra/02-model-thresholds-and-activation-band.md` — derivación de umbrales y Prop 2.
- `extra/03-proposition-3-dynamics.md` — derivación pedagógica completa de la Prop 3.
- `extra/03-lean-target-proposition-3.md` — inventario de metas Lean de la Prop 3.
- `hand/README.md` — guía de la derivación a mano (las dos páginas).
- `paper/source/…` — fuente arXiv v2 (PDF + TeX). GITIGNORED (no se commitea).
- `lean/` — carpeta completa generada por EconCSLib, colocada al nivel exigido
  por el issue.
- `lean-check.txt` — comando, entorno, resultado y límite del chequeo rápido.
- `lean/docs/AGENT_SOURCE_AUDIT.md` — revisión semántica fuente--`Spec`,
  veredictos por fila y bloqueo exacto del cierre automático.
- `presentation.tex` — deck Beamer listo para compilar en Overleaf; carga las
  fotos desde `hand/` cuando existan.
- `prompts.md` — bitácora de la conversación.
- `context-transcript.md` — transcript raw de la sesión de Claude, con mensajes
  visibles, comandos y salidas de terminal; omite razonamiento interno y JSON de
  herramientas.
- `.work/EconCSLib/` — clon de trabajo de EconCSLib. GITIGNORED. Contiene
  `scratch_QX26/QX26AgenticDelegation.lean` (versión standalone verificada) y
  `scratch_QX26/statement-spec.json` (spec de 9 metas).

## 5. Entorno para Lean/EconCSLib (cómo continuar sin chocar)

- La máquina es **Windows** con **WSL (Ubuntu)** + VS Code + Lean vía `elan`.
  `lake` en `/home/asus/.elan/bin/lake`, Lean **v4.30.0-rc2**. Python 3.14 en WSL.
- **OBSTÁCULO CLAVE:** compilar o hacer git **sobre el disco de Windows
  (`/mnt/c/...`) FALLA** ("Operation not permitted": chmod / index.lock). Hay que
  trabajar en el **home nativo de WSL**. El build vivo está en **`~/EconCSLib`**
  (copia del clon `.work/EconCSLib`, con `.lake` reconstruido: `lake exe cache get`
  para mathlib y `lake build EconCSLib` una vez para la librería).
- **Bucle de edición:** editar los `.lean` en `/mnt/c/...` (visible para Claude),
  el usuario los copia a `~/EconCSLib/...` y corre `lake env lean <archivo>` o
  `paper_contribution.py check QX26AgenticDelegation --fast`.
- **Git:** los commits los hace el usuario desde **Windows (GitHub Desktop)**, NO
  desde WSL. Se fijó `git config core.whitespace cr-at-eol` para que el CRLF no
  rompa el `git diff --check` del `check`.
- Comandos de referencia (en `~/EconCSLib`):
  `python3 scripts/paper_contribution.py doctor`
  `python3 scripts/paper_contribution.py new … --statement-spec …`
  `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast`

## 6. Qué sigue (para quien releve)

1. **Resolver la configuración exigida:** el transcript raw existe, pero no
   acredita el modelo. Para cumplimiento estricto, reproducir la revisión con
   GPT-5.6 Sol y esfuerzo `xhigh`, o conservar explícitamente esta limitación.
2. **Cerrar la entrega:** publicar la rama `presentation-and-hand`, abrir el PR
   y fusionarlo a `main`.
3. Opcional/diferido: corregir los alcances parciales identificados, reintentar
   el closeout cuando EcoCSLib repare su gate del motor, abrir el PR upstream y
   redactar el paper.

## 7. Notas de handoff

- El usuario (Alejandro) prefiere hacer él las instalaciones/compilaciones/commits
  pesados para ahorrar tokens; el asistente prepara archivos y da comandos exactos.
- Idioma de trabajo: español; términos técnicos y código en inglés.
- Nombres de teoremas Lean (todos probados): `frontier_expansion`, `activation_band`,
  `cumulative_effect_nonneg`, `cumulative_gap_first_difference`,
  `cumulative_effect_strict_mono_closedFrontier`,
  `cumulative_effect_strict_concave_closedFrontier`, `cumulative_effect_endpoint_flat`,
  `specialist_heterogeneity`, `repository_expansion`.
