# Auditoría fuente → Lean — Proposición 1 y corolario estricto de expansión

**Fecha:** 2026-11-23. **Fuente primaria:** [Quispe y Xu (2026), arXiv:2605.25438v2, §4.2, Proposición 1 y apéndice A.3](https://arxiv.org/html/2605.25438v2). **Extensión independiente:** [Prop1StrictFrontier.lean](../extensions/Prop1StrictFrontier.lean). La carpeta generada por EconCSLib (`lean/`) permanece intacta.

## 1. Distinción indispensable entre fuente y resultado derivado

**Enunciado de Proposición 1 en el texto principal (débil):** la inclusión \(\mathcal M_1=\{S,C\}\subseteq\mathcal M_2=\{S,C,D\}\) asegura para cada desarrollador, lenguaje, periodo y realización de oportunidades

\[
V^2_k=\max\{V^S_k,V^C_k,V^D_k\}\geq V^1_k=\max\{V^S_k,V^C_k\}.
\]

Luego \(Z^2_k=\mathbf1\{V^2_k\ge0\}\ge Z^1_k=\mathbf1\{V^1_k\ge0\}\) y \(N^2=\sum_k Z^2_k\ge N^1=\sum_k Z^1_k\). Esta conclusión no exige que la delegación sea beneficiosa para todas las lenguas.

**Corolario estricto, referido en la demostración A.3:** \(N^2>N^1\) si hay **al menos un lenguaje testigo** \(k_0\) para el cual las dos opciones antiguas son inviables, \(\max\{V^S_{k_0},V^C_{k_0}\}<0\), pero la delegación sí es viable, \(V^D_{k_0}\ge0\). No se debe atribuir esta estrictez al enunciado principal sin añadir el testigo.

Para una lengua inicialmente desconocida, el **Supuesto 1** de §4.1 exige \(\gamma s-r_C\le0\). En ese caso, el testigo anterior puede obtenerse a partir de la **banda económica** \(\omega_{k_0}\in[T^D_{k_0},T^S_{k_0})\). La banda implica a su vez \(B_{k_0}=T^S_{k_0}-T^D_{k_0}>0\); no hace falta duplicar esta última desigualdad como supuesto independiente.

## 2. Puente Lean implementado y controles

| Declaración nueva | Afirmación exacta |
| --- | --- |
| `prop1CountBefore` / `prop1CountAfter` | Conteo de lenguajes activos a partir de **los tres excedentes económicos**, tomados de [Prop2ThresholdBridge.lean](../extensions/Prop2ThresholdBridge.lean); ningún `V^1\le V^2` se incorpora como hipótesis exógena |
| `prop1_menu_count_weak` | Menú ampliado implica \(N^1\le N^2\), punto por punto |
| `prop1_count_gap_eq_sum` | Identidad exacta de la diferencia de conteos como suma de diferencias de indicadores |
| `prop1_count_strict_of_new_mode_witness` | Un testigo con \(\max\{V^S,V^C\}<0\le V^D\) implica \(N^1<N^2\) |
| `prop1_band_implies_positive_delegation_advantage` | La banda \([T^D,T^S)\) implica \(B=T^S-T^D>0\) |
| `prop1_count_strict_of_delegation_band` | La banda y el foothold del Supuesto 1 implican \(N^1<N^2\) |

El argumento de estrictez usa una **suma finita de incrementos de indicadores no negativos** y un incremento estrictamente positivo para el lenguaje testigo. La misma realización de \(\omega\) se utiliza antes y después: es una conclusión de estática comparativa *path-by-path*. No depende de independencia ni de una medida de probabilidad, y tampoco identifica un efecto causal observado de adopción de IA.

**Límites semánticos:** las primitivas tienen tipo `ℝ`; el puente ya verificado de Proposición 2 expresa los excedentes de certeza equivalente pero no deriva la CARA-normalidad de una distribución construida dentro de Lean. El nuevo corolario no convierte las expectativas probabilísticas de Proposiciones 4 y 5 en resultados causales.

## 3. Compuerta de compilación

El workflow [`lean-verify.yml`](../.github/workflows/lean-verify.yml) compila el módulo `QX26AgenticDelegation.Prop1StrictFrontier`, inspecciona con `#print axioms` los **cinco teoremas** nuevos y los 28 anteriores, y ejecuta el comando `python3 scripts/paper_contribution.py check QX26AgenticDelegation --fast`. La ejecución solo puede declararse **DEMOSTRADA EN LEAN** cuando GitHub Actions informe `success` para el commit que contiene este archivo; de lo contrario, el estado es **PENDIENTE**.

El historial de fallos, si los hubiera, se conserva y no se sustituye por un juicio intuitivo sobre el razonamiento.
