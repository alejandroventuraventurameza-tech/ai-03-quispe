# Auditoría fuente → Lean — Proposición 4 (esperanza condicional)

**Corte:** 2026-11-23. **Fuente primaria:** [Quispe y Xu (2026), arXiv 2605.25438v2, A.5 (ecuaciones 22–23)](https://arxiv.org/html/2605.25438v2). **Código separado:** [`extensions/Prop4ExpectedExpansion.lean`](../extensions/Prop4ExpectedExpansion.lean). **Estado:** propuesta de extensión matemática; comprobar GitHub Actions antes de etiquetar como probado.

## 1. La proposición de los autores

Definen, para un desarrollador `i`, el conteo de activaciones de lenguajes desconocidos

\[
E_i=\sum_{k\in\mathcal U_i}(Z^2_{ik}-Z^1_{ik}),
\qquad
\mathbb E[E_i\mid a_i,U_i]=U_i\,p_i(a_i,A).
\]

Aquí \(\mathcal U_i\) es el conjunto de lenguajes antes desconocidos, \(U_i=|\mathcal U_i|\), \(a_i\) es habilidad general y \(A\) es capacidad del agente. El **Supuesto 3** postula que cada candidato desconocido tiene el mismo incremento esperado de activación condicionado a las características del desarrollador. Por linealidad de la esperanza, no hace falta asumir independencia estadística entre lenguajes.

Para que la esperanza crezca **débilmente** con \(U_i\), se necesita \(p_i(a_i,A)\ge0\). Para un incremento **estricto** al agregar candidatos, se necesita \(p_i(a_i,A)>0\). El resultado de habilidad general necesita adicionalmente \(p_i(a',A)\ge p_i(a,A)\) cuando \(a'\ge a\); la igualdad \(\sum p=Up\) por sí sola no lo demuestra.

El artículo sugiere que los costes de verificación y el error residual se reducen con habilidad y que una densidad positiva en el umbral transmite el efecto a \(p_i\). Este puente de derivadas de costes → umbral → CDF → probabilidad de activación **no está probado en el módulo original ni se afirma probado aquí**.

## 2. Limitación del `Spec` generado y reparación propuesta

El código original [`specialist_heterogeneitySpec`](../lean/PaperInterface.lean) presenta solamente \(\sum_{k\in\mathcal U_i}p=U_i p\) como identidad de números reales. Carece de variables aleatorias \(Z^1,Z^2\), de la operación de esperanza y de una ley condicional.

La nueva extensión formula explícitamente:

- Un espacio de shocks \(Ω\) con `MeasurableSpace Ω`.
- Una familia de leyes `conditionalLaw : ℝ → Finset ι → Measure Ω`, indexada por habilidad general y por el conjunto de candidatos; se exige `IsProbabilityMeasure` para el par \((a,U)\) concreto.
- Los procesos de activación `Z1,Z2 : ι → Ω → ℝ`, interpretables como indicadores en una aplicación.
- Integrabilidad de cada incremento \(\omega\mapsto Z^2_{ik}(\omega)-Z^1_{ik}(\omega)\).
- Simetría **como condición explícita**: la esperanza de cada incremento es el mismo número `p a`.

Con esos supuestos, la prueba de [`prop4_conditional_expected_expansion`](../extensions/Prop4ExpectedExpansion.lean) intercambia integral y suma finita y aplica la hipótesis de simetría. Es la contraparte de A.5 (22–23). **No construye** una distribución condicional regular a partir de una distribución conjunta en el espacio \((a,U,\omega)\): la recibe como dato. Por eso es un puente comprobable, no la formalización completa del modelo estocástico.

Tres lemas complementarios distinguen:
1. Monotonicidad **débil** en el número de candidatos si \(p\ge0\).
2. Monotonicidad **estricta** si se agregan candidatos y \(p>0\).
3. Monotonicidad **débil** en habilidad si la probabilidad `p` ya es monótona en habilidad.

## 3. Riesgos que quedan fuera de la nueva prueba

- No se demuestra a partir de CARA-normalidad que las ganancias de delegación produzcan una mayor probabilidad condicional de activación.
- `Z1` y `Z2` son funciones reales que representan los indicadores. La propiedad de tomar solo valores \(0,1\) debe derivarse o imponerse aparte para su interpretación como activación.
- No se construye una probabilidad conjunta con una desintegración `P(dω|a,U)`; se **asume** una familia de distribuciones.
- No se exige independencia entre candidatos. Sería una hipótesis artificial e innecesaria para la **esperanza del total**.
- No se reclama identificación causal a partir de resultados algebraicos.

## 4. Compuerta de entrega

La nueva prueba solo puede figurar como **DEMOSTRADA EN LEAN** después de verificar que el workflow `lean-verify.yml` compila `QX26AgenticDelegation.Prop4ExpectedExpansion`, inspecciona sus cuatro teoremas mediante `#print axioms` y ejecuta `paper_contribution.py check QX26AgenticDelegation --fast` con resultado `success`.

El módulo `lean/` generado por EconCSLib permanece sin modificar. Las mejoras del revisor están aisladas en `extensions/`.
